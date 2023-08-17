unit uDmDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.VCLUI.Login, FireDAC.VCLUI.Error,
  FireDAC.Phys.IBBase, FireDAC.Comp.UI;

type
  Tdmdados = class(TDataModule)
    fdConexao: TFDConnection;
    qryPedido: TFDQuery;
    qryItemPedido: TFDQuery;
    qryPedidoID: TIntegerField;
    qryPedidoCLIENTE: TStringField;
    qryPedidoVRTOTALPEDIDO: TSingleField;
    qryPedidoDATAPEDIDO: TDateField;
    qryPedidoDATADIGITACAO: TDateField;
    qryPedidoOBSERVACAO: TStringField;
    qryItemPedidoID: TIntegerField;
    qryItemPedidoPEDIDOID: TIntegerField;
    qryItemPedidoQUANTIDADE: TIntegerField;
    qryItemPedidoVRUNITARIO: TSingleField;
    qryItemPedidoDESCONTOITEM: TSingleField;
    qryItemPedidoVRTOTALITEM: TSingleField;
    qryItemPedidoOBSERVACAO: TStringField;
    dspedido: TDataSource;
    FDSchemaAdapter1: TFDSchemaAdapter;
    qryItemPedidoagTotalPedido: TAggregateField;
    qryItemPedidoPRODUTOID: TIntegerField;
    FDGUIxLoginDialog1: TFDGUIxLoginDialog;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDGUIxErrorDialog1: TFDGUIxErrorDialog;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    qryItemPedidoCLNOMEPRODUTO: TStringField;
    MemProduto: TFDMemTable;
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDSchemaAdapter1AfterApplyUpdate(Sender: TObject);
    procedure qryPedidoNewRecord(DataSet: TDataSet);
    procedure qryItemPedidoNewRecord(DataSet: TDataSet);
    procedure qryItemPedidoBeforeInsert(DataSet: TDataSet);
    procedure qryItemPedidoPRODUTOIDSetText(Sender: TField; const Text: string);
    procedure qryPedidoUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    procedure DataModuleCreate(Sender: TObject);
    procedure qryItemPedidoCalcFields(DataSet: TDataSet);
    procedure qryPedidoBeforePost(DataSet: TDataSet);
    procedure qryItemPedidoBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
    {para alimentar campo internalcalc}
    Function GetNomeProduto(produtoid:integer):String;
    {beforespost, verifica campos obrigatórios nao preenchidos}
    Function ValidarCamposObrigatorios(adataset:Tdataset):Boolean;
    {certificar-se de não cadastrar um produto já lançado no pedido}
    Function ValidarProdutoJaLancado(produtoId:integer):Boolean;
    {informados qtd e/ou valor e/ou desconto, calcula o valor do item}
    Procedure CalcularTotalItem(sender:tfield);
    {metodo comum aos campos quantiade, desconto e valor unitario}
    Procedure CalculosSetText(Sender: TField;
      const Text: string);
    {busca no bd conteudo da tabela produtos e disponibiliza em memtable}
    Procedure PrepararBibliotecaProdutos;

  public
    { Public declarations }
    {configuracoes de aparencia e posicionamento de campos}
    Procedure ItemPedidoConfiguraCampos(dataset:tdataset);
  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}


procedure Tdmdados.CalcularTotalItem(sender:tfield);
begin
        if (sender.dataset.fieldbyname('vrunitario').AsFloat > 0) and
           (sender.dataset.FieldByName('quantidade').AsInteger > 0) and
           (sender.dataset.FieldByName('descontoitem').IsNull = false) then
        begin
            sender.dataset.FieldByName('vrtotalitem').value := (sender.dataset.fieldbyname('vrunitario').value*
                                                                sender.dataset.fieldbyname('quantidade').value) -
                                                                sender.dataset.FieldByName('descontoitem').value;
        end;


end;

procedure Tdmdados.CalculosSetText(Sender: TField; const Text: string);
begin
  try
    if sender.DataType in [ftFloat,ftCurrency] then
      sender.AsFloat := strtofloat(text)
    else
      sender.asinteger := text.ToInteger();
    CalcularTotalItem(sender);
  except
    on e:exception do
    begin
        raise Exception.Create('Favor informar um valor válido!'+e.message);
        sender.Clear;
    end;

  end;

end;


procedure Tdmdados.DataModuleCreate(Sender: TObject);
begin
    fdConexao.Connected := true;
    PrepararBibliotecaProdutos;
    qryItemPedido.AfterOpen := ItemPedidoConfiguraCampos;

end;

procedure Tdmdados.DataModuleDestroy(Sender: TObject);
begin
  if qryItemPedido.Active then
    qryItemPedido.Active := false;
  if qryPedido.active then
    qryPedido.Active := false;
    fdConexao.Connected := false;
end;

procedure Tdmdados.FDSchemaAdapter1AfterApplyUpdate(Sender: TObject);
begin
  try
      qryPedido.CommitUpdates;
      qryItemPedido.CommitUpdates;
  except
    on e: exception do
      raise Exception.Create('erro aplicando cache'+e.message);

  end;
end;

Function Tdmdados.GetNomeProduto(produtoid: integer):String;
begin
  if not MemProduto.active then
    MemProduto.Active := true;
  MemProduto.IndexFieldNames := 'id';
  if memproduto.Locate('id', produtoid,[])  then
    result := MemProduto.fieldbyname('descricao').AsString
  else
    result  := 'Produto não cadastrado';



end;

procedure Tdmdados.PrepararBibliotecaProdutos;
begin
  if MemProduto.Active then
    MemProduto.close;
  fdConexao.ExecSQL('select * from tbproduto order by id',Tdataset(MemProduto));
  MemProduto.Active := true;
end;

procedure Tdmdados.qryItemPedidoBeforeInsert(DataSet: TDataSet);
begin
  if qryPedido.STATE in dsEditModes then
    qryPedido.post; //11:04

end;

procedure Tdmdados.qryItemPedidoBeforePost(DataSet: TDataSet);
begin
    if ValidarCamposObrigatorios(dataset) = false then
      exit;
    if (dataset.fieldbyname('vrunitario').asfloat - dataset.fieldbyname('descontoitem').asfloat) <= 0 then
    begin
        raise Exception.Create('A diferença entre valor unitário devem estar zerados. Corrija!');
        DataSet.FieldByName('vrunitario').FocusControl;
        exit;
    end;
    if dataset.fieldbyname('quantidade').asinteger <= 0 then
    begin
        raise Exception.Create('Vocë deve informar ao menos 1 unidade vendida. Corrija!');
        DataSet.FieldByName('quantidade').FocusControl;
        exit;
    end;

end;

procedure Tdmdados.qryItemPedidoCalcFields(DataSet: TDataSet);
begin
      dataset.fieldbyname('clnomeproduto').asstring := GetNomeProduto(dataset.FieldByName('produtoid').asinteger);
end;

procedure Tdmdados.qryItemPedidoNewRecord(DataSet: TDataSet);
begin
  dataset.fieldbyname('quantidade').value := 0;
  dataset.fieldbyname('vrunitario').value := 0;
  dataset.fieldbyname('descontoitem').value := 0;
  dataset.fieldbyname('vrtotalitem').value := 0;
  DATASET.FieldByName('PRODUTOID').FocusControl;

end;

procedure Tdmdados.qryItemPedidoPRODUTOIDSetText(Sender: TField;
  const Text: string);
begin
     sender.AsInteger := text.ToInteger();
        if not ValidarProdutoJaLancado(text.ToInteger) then
          sender.clear;

end;

procedure Tdmdados.qryPedidoBeforePost(DataSet: TDataSet);
begin
    if ValidarCamposObrigatorios(dataset) = false then
      exit;

end;

procedure Tdmdados.qryPedidoNewRecord(DataSet: TDataSet);
begin
  dataset.FieldByName('datadigitacao').asdatetime := date;
  dataset.FieldByName('datapedido').asdatetime := date;
  dataset.fieldbyname('vrtotalpedido').value := 0;
  dataset.FieldByName('cliente').FocusControl;
end;


procedure Tdmdados.qryPedidoUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  asender.FieldByName('vrtotalpedido').NewValue := qryItemPedido.FieldByName('agtotalpedido').value;
end;

function Tdmdados.ValidarProdutoJaLancado(produtoId: integer): Boolean;
var lancados: TFDMemTable;
  msg : string;
begin
  try
  lancados := TFDMemTable.Create(nil);
  try
    result := true;
    if (qryItemPedido.RecordCount > 0) or
       (qryItemPedido.ChangeCount > 1) then
    begin
      lancados.CloneCursor(qryItemPedido,true,false);
      lancados.FilterChanges := [rtModified,rtUnmodified, rtInserted];
      lancados.IndexFieldNames := 'produtoid';
      result := not (lancados.Locate('produtoid',produtoid,[]));
      msg := Format('O produto de código %d já foi cadastrado, selecione-o para alterar!',[produtoid]);
      if not result then
        raise Exception.Create(msg);
    end;

    
  finally
    lancados.DisposeOf;
  end;
  except
    on e: exception do
      raise Exception.Create('Erro validando produto '+e.message);

  end;

end;

Procedure Tdmdados.ItemPedidoConfiguraCampos(dataset:tdataset);
begin
    try
        dataset.DisableControls;
        if dataset.FindField('agtotalpedido') <> nil then
        begin
            TAggregateField(dataset.FieldByName('agtotalpedido')).Active := true;
            TFDQuery(dataset).AggregatesActive := true;
        end;
        if dataset.FindField('clnomeproduto') <> nil then
        begin
            dataset.fieldbyname('clnomeproduto').DisplayLabel := 'Nome do Produto';
        end;

        dataset.fieldbyname('id').visible := false;
        dataset.fieldbyname('vrtotalitem').visible := true;
        dataset.FieldByName('pedidoid').displaylabel     := 'Nro Pedido';
        dataset.fieldbyname('produtoid').displaylabel    := 'Cod. Produto';
        dataset.fieldbyname('quantidade').displaylabel   := 'Qtde Vendida';
        dataset.fieldbyname('VRUNITARIO').displaylabel   := 'Valor unitário';
        dataset.fieldbyname('DESCONTOITEM').displaylabel := 'Desconto R$';
        dataset.fieldbyname('OBSERVACAO').DisplayLabel   := 'Observacao';
        dataset.fieldbyname('vrtotalitem').displaylabel   := 'Total do Item';

        dataset.fieldbyname('observacao').DisplayWidth    := 40;


        dataset.FieldByName('quantidade').OnSetText:= CalculosSetText;
        dataset.FieldByName('vrunitario').OnSetText:= CalculosSetText;
        dataset.FieldByName('descontoitem').OnSetText:= CalculosSetText;

    finally
      dataset.EnableControls;
    end;
end;

Function Tdmdados.ValidarCamposObrigatorios(adataset:Tdataset):Boolean;
var i:  integer;
  msg : string;
begin
    {refatorar cleancode}
    i:= 0;
    msg := '';
    for i:= 0 to adataset.FieldCount -1 do
    begin
      result := (adataset.fields[i].Required = false);
      if not result then
        result := (adataset.fields[i].isnull = false);
      if not result then
      begin
          msg := format('O campo %s é de preenchimento obrigatório. Corrija ',[adataset.fields[i].displaylabel]);
          raise Exception.Create(msg);
          adataset.fields[i].FocusControl;
          break;
      end;
    end;
end;



end.
