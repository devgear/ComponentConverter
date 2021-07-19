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
  RemoveSkinManager in 'Converter\RemoveSkinManager.pas',
  RemoveSkinProvider in 'Converter\RemoveSkinProvider.pas',
  RemoveCompsConverter in 'Converter\RemoveCompsConverter.pas',
  UpdateSQLConnectionConv in 'Converter\UpdateSQLConnectionConv.pas',
  kbmMemTableConv in 'Converter\kbmMemTableConv.pas',
  wControlConv in 'Converter\wControlConv.pas',
  wControlDefine in 'Converter\Types\wControlDefine.pas',
  ReplaceMemoFieldToStringFieldConv in 'Converter\ReplaceMemoFieldToStringFieldConv.pas',
  FDQryDirectExecuteConv in 'Converter\FDQryDirectExecuteConv.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCompMigTool, frmCompMigTool);
  Application.Run;
end.
