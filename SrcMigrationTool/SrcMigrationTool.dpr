program SrcMigrationTool;

uses
  Vcl.Forms,
  SrcMigForm in 'SrcMigForm.pas' {frmSrcMainForm},
  Environments in '..\Common\Environments.pas',
  SrcConverterTypes in 'Converter\SrcConverterTypes.pas',
  SrcConverter in 'Converter\SrcConverter.pas',
  Logger in '..\Common\Logger.pas',
  SrcConvertUtils in 'Utils\SrcConvertUtils.pas',
  ConverterManager in '..\Common\ConverterManager.pas',
  Converter in '..\Common\Converter.pas',
  ConverterTypes in '..\Common\ConverterTypes.pas',
  SelectedConverter in 'Converter\SelectedConverter.pas',
  EtcConverter in 'Converter\EtcConverter.pas',
  DataControllerConverter in 'Converter\DataControllerConverter.pas',
  GridConverter in 'Converter\GridConverter.pas',
  ColumnConverter in 'Converter\ColumnConverter.pas',
  GroupConverter in 'Converter\GroupConverter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSrcMainForm, frmSrcMainForm);
  Application.Run;
end.
