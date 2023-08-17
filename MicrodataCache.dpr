program MicrodataCache;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uDmDados in 'uDmDados.pas' {dmdados: TDataModule},
  uTrataErros in 'uTrataErros.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := false;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
