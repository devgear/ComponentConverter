unit ODAC2FireDACConverter;

interface

uses
  Converter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRealGridToCXGrid = class(TConverter)
  private
    const ORG_COMP_NAME = 'TRealGrid';
    const CVT_COMP_NAME = 'TcxGrid';
  private
    FColumnCompList: string;
  protected
    function GetDescription: string; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetConvertCompList(AMainCompName: string): string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: string; override;
    function GetMainUsesUnit: string; override;

    function GetConvertedCompText(ACompText: string): string; override;
  end;


implementation

{ TConverterRealGridToCXGrid }

uses ObjectTextParser, RealGridParser, cxGridTagDefine;

function TConverterRealGridToCXGrid.GetAddedUses: string;
begin
  Result := ','#13#10 +
    '  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,'#13#10 +
    '  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,'#13#10 +
    '  dxDateRanges, cxDataControllerConditionalFormattingRulesManagerDialog,'#13#10 +
    '  cxTextEdit, cxCurrencyEdit, cxCheckBox, cxGridLevel, cxGridCustomTableView,'#13#10 +
    '  cxGridTableView, cxGridBandedTableView, cxClasses, cxGridCustomView, cxGrid';
end;

function TConverterRealGridToCXGrid.GetComponentClassName: string;
begin
  Result := ORG_COMP_NAME;
end;

function TConverterRealGridToCXGrid.GetConvertCompClassName: string;
begin
  Result := CVT_COMP_NAME;
end;

function TConverterRealGridToCXGrid.GetConvertCompList(AMainCompName: string): string;
var
  ViewName, LevelName: string;
begin
  ViewName  := AMainCompName + 'BandedTableView1';
  LevelName := AMainCompName + 'Level1';
  Result := '';
  Result := Result + #13#10'    ' + ViewName + ': TcxGridBandedTableView;';
  Result := Result + FColumnCompList;
  Result := Result + #13#10'    ' + LevelName + ': TcxGridLevel;';
end;

function TConverterRealGridToCXGrid.GetConvertedCompText(
  ACompText: string): string;
var
  Idx: Integer;
  Parser: TRealGridParser;
  Column: TRealGridColumn;
  Group: TRealGridGroup;
  GridName, ViewName, LevelName, ColName: string;
  GridText, ColText, ColList, GroupText, GroupList: string;
  Grop: TObject;
begin
  Parser := TRealGridParser.Create;
  Parser.Parse(ACompText);

  GridName  := Parser.Data.Name;
  ViewName  := GridName + 'BandedTableView1';
  LevelName := GridName + 'Level1';
  ColName   := ViewName + 'BandedColumn%d';

  GridText := TAG_CXGRID_COMP;
  GridText := GridText.Replace('[[COMP_NAME]]',       GridName);
  GridText := GridText.Replace('[[TABLEVIEW_NAME]]',  ViewName);
  GridText := GridText.Replace('[[LEVEL_NAME]]',      LevelName);

  GridText := GridText.Replace('[[COMP_LEFT]]',       Parser.Data.Properties.Values['left']);
  GridText := GridText.Replace('[[COMP_TOP]]',        Parser.Data.Properties.Values['top']);
  GridText := GridText.Replace('[[COMP_WIDTH]]',      Parser.Data.Properties.Values['width']);
  GridText := GridText.Replace('[[COMP_HEIGHT]]',     Parser.Data.Properties.Values['height']);
  GridText := GridText.Replace('[[COMP_ALIGN]]',      Parser.Data.Properties.Values['align']);

  GroupList := '';
  for Group in Parser.Data.Groups do
  begin
    GroupText := TAG_CXGRID_GROUP;
    GroupText := GroupText.Replace('[[CAPTION]]', Group.TitleCaption);
    GroupText := GroupText.Replace('[[VISIBLE]]', BoolToStr(Group.Visible, True));

    GroupList := GroupList + GroupText;
  end;
  GridText := GridText.Replace('[[GROUP_LIST]]', GroupList);

  ColList := '';
  FColumnCompList := ''; //GetConvertCompList에서 사용할 컬럼 컴포넌트 목록
  Idx := 1;
  for Column in Parser.Data.Columns do
  begin
    if Column.DataType = 'wdtFloat' then
    begin
      ColText := TAG_CXGRID_COLUMN_FLT
    end
    else if Column.DataType = 'wdtBool' then
    begin
      ColText := TAG_CXGRID_COLUMN_BOOL
    end
    else
      ColText := TAG_CXGRID_COLUMN_DEF;

    FColumnCompList := FColumnCompList + #13#10'    ' + Format(ColName, [Idx]) + ': TcxGridBandedColumn;';

    ColText := ColText.Replace('[[COLUMN_NAME]]',     Format(ColName, [Idx]));
    ColText := ColText.Replace('[[COLUMN_CAPTION]]',  Column.TitleCaption);
    ColText := ColText.Replace('[[VISIBLE]]',         BoolToStr(Column.Visible, True));
    ColText := ColText.Replace('[[BAND_INDEX]]',      IntToStr(Column.Group));
    ColText := ColText.Replace('[[COL_INDEX]]',       IntToStr(Column.LevelIndex-1));

    ColList := ColList + ColText;
    Inc(Idx);
  end;
  GridText := GridText.Replace('[[COLUMN_LIST]]', ColList);

  Result := GridText;

  Parser.Free;
end;

function TConverterRealGridToCXGrid.GetDescription: string;
begin
  Result := 'RealGrid to cxGrid 변환';
end;

function TConverterRealGridToCXGrid.GetMainUsesUnit: string;
begin
  Result := 'cxGrid';
end;

function TConverterRealGridToCXGrid.GetRemoveUses: TArray<string>;
begin
  Result := ['URGrids', 'URMGrid'];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRealGridToCXGrid);

end.
