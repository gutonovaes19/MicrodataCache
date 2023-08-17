unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, udmdados, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uTrataErros;

type
  TMainForm = class(TForm)
    pgcontrole: TPageControl;
    pgConsultaDados: TTabSheet;
    pgCadastraDados: TTabSheet;
    gridItensPedido: TDBGrid;
    Panel1: TPanel;
    dspedido: TDataSource;
    dsitempedido: TDataSource;
    btaplicarcache: TButton;
    btcancelarcache: TButton;
    EdtTotalPedido: TDBEdit;
    btexcluirpedido: TButton;
    edtnropedido: TDBEdit;
    edtdatapedido: TDBEdit;
    edtcliente: TDBEdit;
    edtobservacao: TDBEdit;
    edtdatadigiado: TDBEdit;
    Pedido: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Observações: TLabel;
    Label6: TLabel;
    btInserir: TButton;
    gridCsPedido: TDBGrid;
    gridCsItens: TDBGrid;
    pnlcsPedidos: TPanel;
    dscsPedido: TDataSource;
    dscsitem: TDataSource;
    DBNavigator1: TDBNavigator;
    MemCsPedido: TFDMemTable;
    MemCsItem: TFDMemTable;
    Label1: TLabel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Panel3: TPanel;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    mmnropedidos: TMemo;
    btBuscarPorPedido: TButton;
    Label7: TLabel;
    mmProdutos: TMemo;
    btBuscarPorProduto: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btaplicarcacheClick(Sender: TObject);
    procedure btcancelarcacheClick(Sender: TObject);
    procedure btinserirClick(Sender: TObject);
    procedure btexcluirpedidoClick(Sender: TObject);
    procedure dspedidoStateChange(Sender: TObject);
    procedure gridCsPedidoDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btBuscarPorPedidoClick(Sender: TObject);
    procedure btBuscarPorProdutoClick(Sender: TObject);
    procedure gridCsPedidoTitleClick(Column: TColumn);
  private
    { Private declarations }
    dmDados : Tdmdados;
              {apos achados pedidos, configura relacionamento entre pedido e itens da consulta de pedidos}
    procedure ConfigurarDatasets;
              {conecta componentes de dados, configuraóes iniciais ao carregar o formulario}
    Procedure ConfigurarFormulario;
              {prepara displaylabels e outras configuracoes de aparencia }
    Procedure ConfigurarGradeCsPedidos(adataSet:Tdataset);
              {prepara query , executa e monta tabela temporaria com todos os pedidos, sem filtros}
    Procedure PrepararConsultaPedidos;
              {prepara query e executa consulta pedidos filtrabdo por range de nro de pedidos}
    procedure PrepararConsultaPedidosPorNumero(aListaDeIds: string);
              {prepara query e executa consula de pedidos que tenham em seus itens, codigos de produtos pesquisados}
    Procedure PrepararConsultaPedidosProdutosSelecionados(aListaDeIdDeProdutos:string);
              {prepara query e executa consulta dos registros filhos de pedidos - itens de pedido}
    Procedure PrepararSqlCsItemPedido;
              {prepara displaylabels e outras configuracoes de aparencia }
    Procedure ConfigurarGradeCsItensPedidos(adataSet:Tdataset);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Function Fposicao(var aPosicao:integer):integer;
begin
   {ordenar dos campos do dataset }
    Inc(aposicao);
end;


procedure TMainForm.btaplicarcacheClick(Sender: TObject);
begin
  try
    dmDados.FDSchemaAdapter1.ApplyUpdates(0)
  except
    on e: exception do
    begin
      raise Exception.Create('Falha ao gravar dados no banco de dados. '+e.message);
      dmDados.FDSchemaAdapter1.CancelUpdates;
      dmDados.fdConexao.Rollback;

    end;
  end;
end;

procedure TMainForm.btcancelarcacheClick(Sender: TObject);
begin
  dmDados.FDSchemaAdapter1.CancelUpdates;
end;

procedure TMainForm.btexcluirpedidoClick(Sender: TObject);
begin
    dspedido.dataset.delete;
    dmDados.FDSchemaAdapter1.ApplyUpdates(0);


end;

procedure TMainForm.btinserirClick(Sender: TObject);
begin
    dspedido.DataSet.Insert;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  PrepararConsultaPedidos;

end;

procedure TMainForm.btBuscarPorPedidoClick(Sender: TObject);
var NumeroDePedidos : string;
begin
      NumeroDePedidos := mmnropedidos.Lines.CommaText;
      if NumeroDePedidos.IsEmpty then
      begin
          MessageDlg('Não há números informados para pesquisar',mtwarning,[mbok],0);
          exit;
      end;
      PrepararConsultaPedidosPorNumero(NumeroDePedidos);

end;

procedure TMainForm.btBuscarPorProdutoClick(Sender: TObject);
var CodigoDeProdutos : string;
begin
      CodigoDeProdutos := mmProdutos.Lines.CommaText;

      if CodigoDeProdutos.IsEmpty then
      begin
          MessageDlg('Não há códigos de produtos informados para pesquisar',mtwarning,[mbok],0);
          exit;
      end;
      PrepararConsultaPedidosProdutosSelecionados(CodigoDeProdutos);

end;

procedure TMainForm.ConfigurarFormulario;
begin
      btinserir.Enabled         := false;
      btcancelarcache.Enabled   := btinserir.Enabled;
      btaplicarcache.Enabled    := btinserir.Enabled;
      btexcluirpedido.Enabled   := btinserir.Enabled;

      dmDados.qryPedido.open;
      dmDados.qryItemPedido.open;

      dspedido.DataSet          := dmDados.qryPedido;
      dsitempedido.DataSet      := dmDados.qryItemPedido;
      edtnropedido.DataSource   := dspedido;
      edtdatapedido.DataSource  := dspedido;
      edtdatadigiado.DataSource := dspedido;
      edtobservacao.DataSource  := dspedido;
      edtcliente.DataSource     := dspedido;
      EdtTotalPedido.DataSource := dsitempedido;
      EdtTotalPedido.datafield  := 'agtotalpedido';
      pgcontrole.ActivePage     := pgConsultaDados;
      gridItensPedido.DataSource := dsitempedido;
      mmnropedidos.Lines.Clear;
      mmProdutos.lines.clear;


end;

procedure TMainForm.ConfigurarGradeCsItensPedidos(adataset:tdataset);
begin
    var posicao := 0;
    adataset.fieldbyname('id').visible := false;
    adataset.fieldbyname('vrtotalitem').visible := true;
    adataset.FieldByName('pedidoid').displaylabel     := 'Nro Pedido';
    adataset.fieldbyname('produtoid').displaylabel    := 'Cod. Produto';
    adataset.fieldbyname('descricao').displaylabel    := 'Produto';
    adataset.fieldbyname('quantidade').displaylabel   := 'Qtde Vendida';
    adataset.fieldbyname('vrunitario').displaylabel   := 'Valor unitário';
    adataset.fieldbyname('vrtotalitem').displaylabel  := 'Valor Total';
    adataset.fieldbyname('descontoitem').displaylabel := 'Desconto ';
    adataset.fieldbyname('observacao').DisplayLabel   := 'Observacao';
    adataset.fieldbyname('observacao').DisplayWidth   := 40;
    adataset.fieldbyname('descricao').DisplayWidth    := 40;

    adataset.FieldByName('pedidoid').Index := Fposicao(posicao);
    adataset.fieldbyname('produtoid').Index := Fposicao(posicao);
    adataset.fieldbyname('descricao').Index := Fposicao(posicao);

    adataset.fieldbyname('quantidade').Index := Fposicao(posicao);
    adataset.fieldbyname('vrunitario').Index := Fposicao(posicao);
    adataset.fieldbyname('descontoitem').Index := Fposicao(posicao);
    adataset.fieldbyname('vrtotalitem').Index := Fposicao(posicao);
    adataset.fieldbyname('observacao').Index := Fposicao(posicao);

    TSingleField(adataset.fieldbyname('vrunitario')).currency := true;
    TSingleField(adataset.fieldbyname('vrtotalitem')).currency := true;
    TSingleField(adataset.fieldbyname('descontoitem')).currency := true;


end;

procedure TMainForm.dspedidoStateChange(Sender: TObject);
begin
      btinserir.Enabled := dmdados.qryPedido.State = dsbrowse;
      btcancelarcache.Enabled := true;
      btaplicarcache.Enabled := dmdados.qryPedido.ChangeCount > 0;
      btexcluirpedido.Enabled := dmDados.qryPedido.RecordCount > 0;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  try
    dmdados := Tdmdados.create(nil);
    ConfigurarFormulario;

  except

    on e: exception do
      raise Exception.Create('criando formulario na memoria '+e.message);


  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
   if Assigned(dmdados)  then
    dmdados.DisposeOf;
end;

procedure TMainForm.gridCsPedidoDblClick(Sender: TObject);
begin
    if dmdados.qryPedido.active then
      dmdados.qryPedido.close;
    dmdados.qryPedido.Params.ParamByName('idpedido').asinteger := gridCsPedido.DataSource.DataSet.FieldByName('id').asinteger;
    dmdados.qryPedido.open;
    pgcontrole.ActivePage := pgCadastraDados;


end;

procedure TMainForm.gridCsPedidoTitleClick(Column: TColumn);
begin
    if MemCsPedido.IndexFieldNames = Column.FieldName then
      MemCsPedido.IndexFieldNames := Column.FieldName+':D'
    else
      MemCsPedido.IndexFieldNames := Column.FieldName;


end;

procedure TMainForm.PrepararConsultaPedidos;
begin
  MemCsItem.AfterOpen := dmdados.ItemPedidoConfiguraCampos;;
  dmdados.fdConexao.ExecSQL('select * from tbpedido ',tdataset(MemCsPedido));
  PrepararSqlCsItemPedido;
  ConfigurarDatasets;
end;
procedure TMainForm.PrepararConsultaPedidosPorNumero(aListaDeIds:string);
begin
  MemCsItem.AfterOpen := dmdados.ItemPedidoConfiguraCampos;;
  dmdados.fdConexao.ExecSQL('select * from tbpedido where id in ('+aListaDeIds+')' ,Tdataset(MemCsPedido));
  PrepararSqlCsItemPedido;
  ConfigurarDatasets;
end;
procedure TMainForm.PrepararConsultaPedidosProdutosSelecionados(aListaDeIdDeProdutos:string);
begin
  MemCsItem.AfterOpen := dmdados.ItemPedidoConfiguraCampos;;
  dmdados.fdConexao.ExecSQL('select * from tbpedido where '+
                           'id in (select distinct(pedidoid) from tbpedidoitem where '+
                           '       produtoid in ('+aListaDeIdDeProdutos+'))',Tdataset(MemCsPedido));
  PrepararSqlCsItemPedido;
  ConfigurarDatasets;
end;

procedure TMainForm.ConfigurarDatasets;
begin
  dscsPedido.DataSet        := MemCsPedido;
  dscsitem.DataSet          := MemCsItem;
  MemCsItem.MasterSource    := dscsPedido;
  MemCsItem.MasterFields    := 'id';
  MemCsItem.DetailFields    := 'pedidoid';
  MemCsItem.IndexFieldNames := 'pedidoid';
  ConfigurarGradeCsPedidos(MemCsPedido);
  ConfigurarGradeCsItensPedidos(MemCsItem);

end;
procedure TMainForm.ConfigurarGradeCsPedidos(adataset:tdataset);
begin

    var posicao := 0;
    adataset.FieldByName('id').displaylabel             := 'Nro Pedido';
    adataset.fieldbyname('Cliente').displaylabel        := 'Cod. Produto';
    adataset.fieldbyname('Observacao').displaylabel     := 'Observações';
    adataset.fieldbyname('VrTotalPedido').displaylabel  := 'Valor Total Pedido';
    adataset.fieldbyname('DataDigitacao').displaylabel  := 'Digitado em';
    adataset.fieldbyname('dataPedido').displaylabel     := 'Data do Pedido ';

    adataset.fieldbyname('observacao').DisplayWidth     := 40;

    adataset.FieldByName('id').index                    := Fposicao(posicao);
    adataset.fieldbyname('Cliente').index               := Fposicao(posicao);
    adataset.fieldbyname('Observacao').index            := Fposicao(posicao);
    adataset.fieldbyname('VrTotalPedido').index         := Fposicao(posicao);
    adataset.fieldbyname('DataDigitacao').index         := Fposicao(posicao);
    adataset.fieldbyname('dataPedido').index            := Fposicao(posicao);

    TSingleField(adataset.fieldbyname('VrTotalPedido')).currency := true;

end;

Procedure TMainForm.PrepararSqlCsItemPedido;
begin
    dmdados.fdConexao.ExecSQL('select ite.*, prod.descricao from tbpedidoitem Ite '+
                            'inner join tbproduto prod on prod.id = ite.produtoid '+
                           ' where ite.pedidoid = :id',tdataset(MemCsItem));

end;


end.
