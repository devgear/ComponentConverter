program CompMigrationTool;

uses
  Vcl.Forms,
  CompMigForm in 'CompMigForm.pas' {frmCompMigTool},
  CompConverter in 'Converter\CompConverter.pas',
  ConvertUtils in 'Utils\ConvertUtils.pas',
  CompConverterTypes in 'Converter\Types\CompConverterTypes.pas',
  cxGridConverter in 'Converter\cxGridConverter.pas',
  RealGridToCXGridConverter in 'Converter\RealGridToCXGridConverter.pas',
  ObjectTextParser in 'Parser\ObjectTextParser.pas',
  RealGridParser in 'Parser\RealGridParser.pas',
  cxGridTagDefine in 'Converter\Types\cxGridTagDefine.pas',
  ViewerForm in 'Utils\ViewerForm.pas' {frmViewer},
  Environments in '..\Common\Environments.pas',
  OraSessionConverter in 'Converter\OraSessionConverter.pas',
  ODACTagDefine in 'Converter\Types\ODACTagDefine.pas',
  RemoveConnectDialogConv in 'Converter\RemoveConnectDialogConv.pas',
  ExtractPropForm in 'ExtractPropForm.pas' {frmExtractProperties},
  cxDateEditConverter in 'Converter\cxDateEditConverter.pas',
  Logger in '..\Common\Logger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCompMigTool, frmCompMigTool);
  Application.Run;
end.
