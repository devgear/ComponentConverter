program CompMigrationTool;

uses
  Vcl.Forms,
  CompMigForm in 'CompMigForm.pas' {frmCompMigTool},
  CompConverter in 'Converter\CompConverter.pas',
  ConvertUtils in 'Utils\ConvertUtils.pas',
  CompConverterTypes in 'Converter\Types\CompConverterTypes.pas',
  ObjectTextParser in 'Parser\ObjectTextParser.pas',
  RealGridParser in 'Parser\RealGridParser.pas',
  cxGridTagDefine in 'Converter\Types\cxGridTagDefine.pas',
  ViewerForm in 'Utils\ViewerForm.pas' {frmViewer},
  Environments in '..\Common\Environments.pas',
  ExtractPropForm in 'ExtractPropForm.pas' {frmExtractProperties},
  Logger in '..\Common\Logger.pas',
  RemovePnlSkinSettingConv in 'Converter\RemovePnlSkinSettingConv.pas',
  ReadDBGridToCXGridConverter in 'Converter\ReadDBGridToCXGridConverter.pas',
  cxDBGridTagDefine in 'Converter\Types\cxDBGridTagDefine.pas',
<<<<<<< HEAD
  RemoveSkinManager in 'Converter\RemoveSkinManager.pas',
  RemoveSkinProvider in 'Converter\RemoveSkinProvider.pas';
=======
  RemoveSkinManager in 'Converter\RemoveSkinManager.pas';
>>>>>>> 65de63c795f1db88258b101e14dd27a4ec6fb5b8

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCompMigTool, frmCompMigTool);
  Application.Run;
end.
