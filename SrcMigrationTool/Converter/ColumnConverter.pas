unit ColumnConverter;

interface

uses
  SrcConverter;

type
  TColumnConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertFixedCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsItems(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsReadOnly(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertDBColumnsFieldName(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertDBColumnsCaption(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnTitleColor(AProc, ASrc: string; var ADest: string): Integer;

    // Groups
    [Impl]
    function ConvertGroupsCaption(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  System.Classes, System.SysUtils, SrcConvertUtils;

{ TSelectedConverter }

function TColumnConverter.ConvertColCount(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]ol[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.ColumnCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsCount(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\.[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.ColumnCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsItems(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = '(' + GRIDNAME_REGEX + '\.[Cc]olumns\[|' + GRIDNAME_REGEX + '\.[Cc]olumns.Items\[)';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsReadOnly(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\[\d+\]\.[Rr]ead[Oo]nly[\s:]';
var
  Datas: TChangeDatas;
begin
  Result := 0;
  ADest := ASrc;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    Datas.Add('].ReadOnly', '].ReadOnlyEx');

    Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
  end;
end;

function TColumnConverter.ConvertColumnTitleColor(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\[\d+\]\.[Tt]itle\.[Cc]olor';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc.Replace('.Title.Color := cl', '.Styles.Header := dmDataBase.cxStyle');
    Result := 1;
  end;
  // From : RealDBGrid1DBBandedTableView1.Columns[8].Title.Color := clBlue;
  // To   : RealDBGrid1DBBandedTableView1.Columns[8].Styles.Header := dmDataBase.cxStyleBlue;
end;

function TColumnConverter.ConvertDBColumnsCaption(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Dd]B[Cc]olumns'+INDEX_REGEX+'\.[Ca]aption';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Caption';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertDBColumnsFieldName(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Dd]B[Cc]olumns'+INDEX_REGEX+'\.[Ff]ield[Nn]ame';
  REPLACE_FORMAT  = 'TcxGridDBBandedColumn([[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]]).DataBinding.FieldName';
begin
  Result := 0;

//  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
  Keywords: TArray<string>;
begin
  Result := 0;
  ADest := ASrc;

  Datas.Add('].Footer.Values[', '].Footers[');
  Datas.Add('Title.CellStyle', 'HeaderHint');
  Datas.Add('Title.Caption', 'Caption');

  // 林籍贸府且 虐况靛
  Keywords := [
    '.Title.Font.Color'
  ];

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
  Inc(Result, AddComments(ADest, Keywords));
end;

function TColumnConverter.ConvertFixedCount(AProc, ASrc: string;
  var ADest: string): Integer;
// if not (RealDBGrid1.DataSource.DataSet.State in [dsInsert]) then
  // if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsInsert]) then
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ff]ixed[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.FixedCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertGroupsCaption(AProc, ASrc: string;
  var ADest: string): Integer;
{
  RealDBGrid1.Groups[k].Caption := '';
  RealDBGrid1DBBandedTableView1.Bands[k].Caption := '';
}
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups'+INDEX_REGEX+'\.[Cc]aption';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Bands[[[INDEX]]].Caption';
begin
  Result := 0;

//  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TColumnConverter.GetDescription: string;
begin
  Result := 'Column - TRealDBGrid to TcxGrid ';
end;

initialization
  TConvertManager.Instance.Regist(TColumnConverter);
end.
