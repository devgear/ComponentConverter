program SrcMigrationTool;

uses
  Vcl.Forms,
  SrcMigForm in 'SrcMigForm.pas' {frmSrcMainForm},
  Environments in '..\Common\Environments.pas',
  SrcConverterTypes in 'Converter\SrcConverterTypes.pas',
  SrcConverter in 'Converter\SrcConverter.pas',
  CellsConverter in 'Converter\CellsConverter.pas',
  ColumnsConverter in 'Converter\ColumnsConverter.pas',
  RowConverter in 'Converter\RowConverter.pas',
  SelectedConverter in 'Converter\SelectedConverter.pas',
  DataSetConverter in 'Converter\DataSetConverter.pas',
  ComFuncConverter in 'Converter\ComFuncConverter.pas',
  Logger in '..\Common\Logger.pas',
  SrcConvertUtils in 'Utils\SrcConvertUtils.pas',
  EventConverter in 'Converter\EventConverter.pas',
  GridViewConverter in 'Converter\GridViewConverter.pas',
  ConverterManager in '..\Common\ConverterManager.pas',
  Converter in '..\Common\Converter.pas',
  ConverterTypes in '..\Common\ConverterTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSrcMainForm, frmSrcMainForm);
  Application.Run;
end.
