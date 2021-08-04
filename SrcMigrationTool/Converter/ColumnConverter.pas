unit ColumnConverter;

interface

uses
  SrcConverter;

type
  TColumnConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
    function GetCvtBaseClassName: string; override;
  published
    [Impl]
    function ConvertFixedCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsReadOnly(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsGroup(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsAlignment(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertDBColumnsFieldName(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertDBColumnsCaption(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnTitleColor(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnColor(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnFontSize(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertColumnHeaderClick(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertColumItemsClear(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertColumItemsAdd(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertColumsNum(AProc, ASrc: string; var ADest: string): Integer;

    // 단순변경은 최종적으로
    [Impl]
    function ConvertColumns_Suffix(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
  System.RegularExpressions,
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

function TColumnConverter.ConvertColumItemsClear(AProc, ASrc: string;
  var ADest: string): Integer;
{
RealDBGrid2.Columns[8].Items.Clear;
RealDBGrid2.Columns[8].Values.Clear;
  TcxCustomImageComboBoxProperties(RealDBGrid2DBBandedTableView1.Columns[8].Properties).Items.Clear;
}
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Vv]alues\.[Cc]lear;';
  REPLACE_FORMAT  = 'TcxCustomImageComboBoxProperties([[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Properties).Items.Clear;';
var
  SrcPrv: string;
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
  begin
    SrcPrv := FConvData.Source[FCurrIndex - 1];
    if SrcPrv.Contains('.Items.Clear;') and (not SrcPrv.StartsWith('//')) then
      FConvData.Source[FCurrIndex - 1] := '';
    Inc(Result);
  end;
end;

function TColumnConverter.ConvertColumItemsAdd(AProc, ASrc: string;
  var ADest: string): Integer;
{
RealDBGrid2.Columns[8].Items.Add(FieldByName('코드명').AsString);
RealDBGrid2.Columns[8].Values.Add(Trim(FieldByName('관리상세코드').AsString));
  with TcxCustomImageComboBoxProperties(RealDBGrid2DBBandedTableView1.Columns[8].Properties).Items.Add do
  begin
    Description := FieldByName('코드명').AsString;
    Value := Trim(FieldByName('관리상세코드').AsString);
  end;

}
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Vv]alues\.[Aa]dd\(';
  REPLACE_FORMAT  = 'with TcxCustomImageComboBoxProperties([[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Properties).Items.Add do';
  VALUE_FORMAT = 'Add\([\S]+\)\;';  // Remove: Add(    );
var
  SrcPrv, CompName, Idx: string;
  Indent, Dsc, Val: string;
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    Inc(Result);
    SrcPrv := FConvData.Source[FCurrIndex - 1];
    if not SrcPrv.Contains('Items.Add(') then
    begin
      ADest := '//' + ASrc;
      Exit;
    end;

    Indent := TConvUtils.GetIndent(ASrc);

    CompName  := TConvUtils.GetCompName(ASrc);
    Idx       := TConvUtils.GetIndex(ASrc);

    Dsc := TRegEx.Match(SrcPrv, VALUE_FORMAT).Value.Replace('Add(', '').Replace(');', '');
    Val := TRegEx.Match(ASrc, VALUE_FORMAT).Value.Replace('Add(', '').Replace(');', '');

    ADest := Indent + REPLACE_FORMAT.Replace('[[COMP_NAME]]', CompName).Replace('[[INDEX]]', Idx) + #13#10;
    ADest := ADest + Indent + 'begin'#13#10;
    ADest := ADest + Indent + '  Description := ' + Dsc + ';'#13#10;
    ADest := ADest + Indent + '  Value := ' + Val + ';'#13#10;
    ADest := ADest + Indent + 'end;'#13#10;

    FConvData.Source[FCurrIndex - 1] := '';
  end;

end;

function TColumnConverter.ConvertColumnColor(AProc, ASrc: string;
  var ADest: string): Integer;
//       RealDBGrid_High.Columns[17].Color        := clWhite;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Cc]olor[\s]+\:\=';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Styles.Content :=';
var
  ColorCode: string;
begin
  Result := 0;
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
  begin
    Inc(Result);
    ADest := ADest.Replace(':= cl', ':= dmDataBase.cxStyle');

    ColorCode := GetColorCode(ADest);
    if ColorCode <> '' then
      ADest := ADest.Replace(ColorCode, GetColorToStyleName(ColorCode));

    Result := 1;
  end;
end;

function TColumnConverter.ConvertColumnFontSize(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Ff]ont\.[Ss]ize';
begin
  Result := 0;
  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc;
    Inc(Result, AddComment(ADest, '].Font.Size'));
  end;
end;

function TColumnConverter.ConvertColumnHeaderClick(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;
  if not AProc.Contains('ColumnHeaderClick') then
    Exit;

  Datas.Add('AColumn.VIndex =', 'AColumn.VisibleIndex =');
  Datas.Add('Acolumn = RealDBGrid1.Columns[0]', 'Acolumn = RealDBGrid1DBBandedTableView1.Columns[0]');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TColumnConverter.ConvertColumnsAlignment(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Aa]lignment';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Properties.Alignment.Horz';
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

function TColumnConverter.ConvertColumnsGroup(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Gg]roup';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Position.BandIndex';
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumns_Suffix(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].';
var
  HasKeyword: Boolean;
  Suffix: string;
  Suffixes: TArray<string>;
begin
  Result := 0;

  Suffixes := [
    'Caption',
    'Footer',
    'Visible',
    'Title',
    'Width',
    'Destroy'
  ];
  if not IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    Exit;
  end;

  HasKeyword := False;
  for Suffix in Suffixes do
  begin
    if IsContainsRegEx(ASrc, SEARCH_PATTERN + Suffix) then
    begin
      HasKeyword := True;
      Break;
    end;
  end;

  if not HasKeyword then
    Exit;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsReadOnly(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Rr]ead[Oo]nly[\s:]';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].ReadOnlyEx';
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnTitleColor(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns' + INDEX_REGEX + '\.[Tt]itle\.[Cc]olor[\s]+\:\=';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]].Styles.Header :=';
var
  ColorCode: string;
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
  begin
    Inc(Result);
    ADest := ADest.Replace(':= cl', ':= dmDataBase.cxStyle');

    ColorCode := GetColorCode(ADest);
    if ColorCode <> '' then
      ADest := ADest.Replace(ColorCode, GetColorToStyleName(ColorCode));

    Result := 1;
  end;
  // From : RealDBGrid1DBBandedTableView1.Columns[8].Title.Color := clBlue;
  // To   : RealDBGrid1DBBandedTableView1.Columns[8].Styles.Header := dmDataBase.cxStyleBlue;
end;

function TColumnConverter.ConvertColumsNum(AProc, ASrc: string;
  var ADest: string): Integer;
{
Acolumn = RealDBGrid1.Columns[27] then
}
const
  SEARCH_PATTERN  = '\=\s' + GRIDNAME_REGEX + '\.[Cc]olumns'+INDEX_REGEX+'\sthen';
  REPLACE_FORMAT  = '= [[COMP_NAME]]DBBandedTableView1.Columns[[[INDEX]]] then';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertDBColumnsCaption(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Dd]B[Cc]olumns'+INDEX_REGEX+'\.[Tt]itle\.[Ca]aption';
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
  Datas, Datas2: TChangeDatas;
  Keywords: TArray<string>;
begin
  Result := 0;
  ADest := ASrc;

  Datas.Add('].Footer.Values[', '].Footers[');
  Datas.Add('Title.CellStyle', 'HeaderHint');
  Datas.Add('Title.Caption', 'Caption');
  Datas.Add('title.Caption', 'Caption');

  // 주석처리할 키워드
  Keywords := [
    '.Title.Font.Color'
  ];

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
  Inc(Result, AddComments(ADest, Keywords));

  Datas2.AddInFile('TbF_206P',
    'RDBGridMaster.Columns[lg최대차수',
    'RDBGridMasterDBBandedTableView1.Columns[lg최대차수');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas2));
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

function TColumnConverter.GetCvtBaseClassName: string;
begin
  Result := 'TfrmTzzRealMaster2';
end;

function TColumnConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TColumnConverter.GetDescription: string;
begin
  Result := 'TcxGrid:Column';
end;

initialization
  TConvertManager.Instance.Regist(TColumnConverter);
end.
