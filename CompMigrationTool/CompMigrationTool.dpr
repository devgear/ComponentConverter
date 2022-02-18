program CompMigrationTool;

uses
  Vcl.Forms,
  CompMigForm in 'CompMigForm.pas' {frmCompMigTool},
  CompConverter in 'Core\CompConverter.pas',
  ConvertUtils in 'Utils\ConvertUtils.pas',
  CompConverterTypes in 'Core\CompConverterTypes.pas',
  ObjectTextParser in 'Parser\ObjectTextParser.pas',
  RealGridParser in 'Parser\RealGridParser.pas',
  cxGridTagDefine in 'Converter\Types\cxGridTagDefine.pas',
  ViewerForm in 'Utils\ViewerForm.pas' {frmViewer},
  Environments in '..\Common\Environments.pas',
  ExtractPropForm in 'ExtractPropForm.pas' {frmExtractProperties},
  Logger in '..\Common\Logger.pas',
  cxDBGridTagDefine in 'Converter\Types\cxDBGridTagDefine.pas',
  wControlDefine in 'Converter\Types\wControlDefine.pas',
  cxGridViewParser in 'Parser\cxGridViewParser.pas',
  GridBandHeaderMergeForm in 'GridBandHeaderMergeForm.pas' {frmBandHeader},
  RODynamicRequestConverter in 'Converter\RODynamicRequestConverter.pas',
  kbmMemTableConv in 'Converter\ktbook\kbmMemTableConv.pas',
  RealDBGridToCXGridConverter in 'Converter\ktbook\RealDBGridToCXGridConverter.pas',
  FireDACConv in 'Converter\ktbook\FireDACConv.pas',
  ReplaceMemoFieldToStringFieldConv in 'Converter\ktbook\ReplaceMemoFieldToStringFieldConv.pas',
  wControlConv in 'Converter\ktbook\wControlConv.pas',
  DACDSDataTableConverter in 'Converter\DACDSDataTableConverter.pas',
  DaBinAdapterConverter in 'Converter\DaBinAdapterConverter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCompMigTool, frmCompMigTool);
  Application.Run;
end.
