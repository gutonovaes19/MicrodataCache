unit uTrataErros;

{Exemplo de como faria o tratamento centralizado de erros.
Incluí algumas classes de erro apenas para demonstrar}

interface

Uses vcl.Dialogs,  System.SysUtils, FireDAC.Stan.Error, forms, System.Classes;

Type
  TTrataErros = class
    private
      flogfile : string;
    public
      constructor create;
      Procedure TratarErros(Sender: TObject; E: Exception);
      Procedure GravarLog(value:string);
  end;


implementation

constructor TTrataErros.create;
begin
  flogfile := ChangeFileExt(paramstr(0),'.log');
  Application.OnException := TratarErros;
end;


procedure TTrataErros.GravarLog(value: string);
var txtlog : TextFile;
begin
  AssignFile(txtlog,flogfile);
  if FileExists(flogfile) then
    Append(txtlog)
  else
    Rewrite(txtlog);
  Writeln(txtlog,FormatdateTime('dd/mm/yy hh:nn:ss - ',now)+ value);
  CloseFile(txtlog);

end;

Procedure TTrataErros.Tratarerros(sender: TObject; E: Exception);
var msg :string;
begin
  GravarLog('==================================');
  if TComponent(sender) is TForm then
  begin
      GravarLog('Form:'+Tform(TComponent(sender).Owner).name);
      GravarLog('Caption: '+Tform(sender).Caption);
      GravarLog('Erro:'+e.ClassName);
      GravarLog('Erro:'+e.Message);
  end
  else begin
    if e is EFDDBEngineException then
    begin
        case  EFDDBEngineException(e).Kind of
          ekUKViolated : msg := 'Esse código já existe, informe um novo e único - %d ';
          ekNoDataFound : msg := 'Dados não encontrados - %d';
          ekRecordLocked : msg := 'Registro bloqueado por outro usuário - %d';
          ekServerGone   : msg := 'Perda de conexão com servidor - %d ';
          else
            msg := 'Erro geral - %d';
        end;
        msg := format(msg, [e.Message]);
        GravarLog(msg);
    end;
  end;
  ShowMessage(e.Message);

end;

var
  TrataErros : TTrataErros;
initialization
  TrataErros:= TTrataErros.create;

finalization
  TrataErros.DisposeOf;
end.
