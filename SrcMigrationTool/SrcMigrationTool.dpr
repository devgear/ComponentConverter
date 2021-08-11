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
  ExtractForm in 'ExtractForm.pas' {frmExtract},
  GridConverter in 'Converter\GridConverter.pas',
  DataControllerConverter in 'Converter\DataControllerConverter.pas',
  ColumnConverter in 'Converter\ColumnConverter.pas',
  GroupConverter in 'Converter\GroupConverter.pas',
  SelectedConverter in 'Converter\SelectedConverter.pas',
  EventConverter in 'Converter\EventConverter.pas',
  CustomConverter in 'Converter\CustomConverter.pas',
  EtcConverter in 'Converter\EtcConverter.pas' {$R *.res},
  DataSetConverter in 'Converter\DataSetConverter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSrcMainForm, frmSrcMainForm);
  Application.Run;
end.
