﻿program CompMigrationTool;

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
  RealDBGridToCXGridConverter in 'Converter\RealDBGridToCXGridConverter.pas',
  cxDBGridTagDefine in 'Converter\Types\cxDBGridTagDefine.pas',
  RemoveSkinManager in 'Converter\RemoveSkinManager.pas',
  RemoveCompsConverter in 'Converter\RemoveCompsConverter.pas',
  UpdateSQLConnectionConv in 'Converter\UpdateSQLConnectionConv.pas',
  kbmMemTableConv in 'Converter\kbmMemTableConv.pas',
  wControlConv in 'Converter\wControlConv.pas',
  wControlDefine in 'Converter\Types\wControlDefine.pas',
  ReplaceMemoFieldToStringFieldConv in 'Converter\ReplaceMemoFieldToStringFieldConv.pas',
  FireDACConv in 'Converter\FireDACConv.pas',
  EtcPropsConverter in 'Converter\EtcPropsConverter.pas',
  FDQueryFieldSizeConverter in 'Converter\FDQueryFieldSizeConverter.pas',
  cxGridViewParser in 'Parser\cxGridViewParser.pas',
  GridBandHeaderMergeForm in 'GridBandHeaderMergeForm.pas' {frmBandHeader};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCompMigTool, frmCompMigTool);
  Application.Run;
end.
