unit ColumnsConverter;

interface

uses
  SrcConverter;

type
  TColumnsConverter = class(TConverter)
  private
    function ConvertColumnsItems(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnsClear(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnsReadOnly(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnIndex(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertColumnGroup(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnsCount(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnsAdd(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnsDelete(ASrc: string; var ADest: string): Boolean;

    function ConvertColumnDataType(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnDataTypeEquals(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnDisplayFormat(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnMaxLength(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnFooter(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnFooterValues0(ASrc: string; var ADest: string): Boolean;
    function ConvertColumnFooterValuesN(ASrc: string; var ADest: string): Boolean;

    function ConvertAColumnToAItem(ASrc: string; var ADest: string): Boolean;
    function ConvertAColumnReadOnly(ASrc: string; var ADest: string): Boolean;

    function ConvertGroupToBandItems(ASrc: string; var ADest: string): Boolean;
    function ConvertViewGroupToBandItems(ASrc: string; var ADest: string): Boolean;
    function ConvertColCount(ASrc: string; var ADest: string): Boolean;
    function ConvertGroupCount(ASrc: string; var ADest: string): Boolean;
    function ConvertGroupToBand(ASrc: string; var ADest: string): Boolean;

    function ConvertColumnEtc(ASrc: string; var ADest: string): Boolean;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;

    function ConvertSource(AProc, ASrc: string; var ADest: string): Boolean; override;
    function ConvertIntfSource(ASrc: string; var ADest: string): Boolean; override;
  end;

implementation

uses
  Winapi.Windows,
  SrcConvertUtils,
  System.Classes, System.SysUtils,
  System.RegularExpressions, Logger;

{ TCellsConverter }

function TColumnsConverter.ConvertColumnIndex(AProc, ASrc: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = 'AColumn\.[Ii]ndex';
  REPLACE_FORMAT  = 'AItem.Index';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if AProc.Contains('ColumnHeaderClick') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Dest := REPLACE_FORMAT;

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

// RealGrid1BandedTableView1.Columns[0].MaxLength := ZZ_SeekForm11R.OraQuery1.FieldByName('LEN').AsInteger;
// TcxTextEditProperties(RealGrid1BandedTableView1.Columns[0].Properties).MaxLength := ZZ_SeekForm11R.OraQuery1.FieldByName('LEN').AsInteger;
function TColumnsConverter.ConvertColumnMaxLength(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '[\w]+\.[Cc]olumns\[[\w\d]+\]\.MaxLength\s+\:\=\s+';
  REPLACE_FORMAT  = 'TcxTextEditProperties([[COLUMN]].Properties).MaxLength := [[FORMAT]]';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Indent, Col, Fmt: string;
  Src, Dest: string;
  SIdx, EIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('].MaxLength ')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  Indent := '';
  for I := 1 to Length(ADest)-1 do
  begin
    if ADest[I] <> ' ' then
      Break;
    Indent := Indent + ' ';
  end;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Col := TRegEx.Match(Src, '[\w]+\.[Cc]olumns\[[\w\d]+\]').Value;
    // 기존 퀀텀 컨트롤의 코드는 '.Properties'가 있으므로 무시
    // 동적 캐스팅 코드 제거
    Col := Col.Replace(' As Twmemcolumn', '');

    SIdx := Match.Index+Match.Length;
    Fmt := Copy(ADest, SIdx, Length(ADest));
    Dest := REPLACE_FORMAT;
    ADest := Indent + Dest.Replace('[[COLUMN]]', Col);
    ADest := ADest.Replace('[[FORMAT]]', Fmt);

    Result := True;
  end;
end;

function TColumnsConverter.ConvertAColumnReadOnly(ASrc: string;
  var ADest: string): Boolean;
begin
  ADest := ASrc;
  if ADest.Contains('AColumn.ReadOnly') then
  begin
    ADest := ADest.Replace('AColumn.ReadOnly', 'AItem.Properties.ReadOnly');
    Result := True;
  end;
end;

function TColumnsConverter.ConvertAColumnToAItem(ASrc: string;
  var ADest: string): Boolean;
begin
  ADest := ASrc;
  // ValueChanged : AColumn: TwMemColumn > AItem: TcxCustomGridTableItem
  if ADest.Contains('AColumn: TwMemColumn') then
  begin
    ADest := ADest.Replace('AColumn: TwMemColumn', 'AItem: TcxCustomGridTableItem');
    Result := True;
  end;

  // ColumnTitleClick : AColumn: TwColumn > AColumn: TcxGridColumn
  if ADest.Contains('(AColumn: TwColumn)') then
  begin
    ADest := ADest.Replace('(AColumn: TwColumn)', '(AColumn: TcxGridColumn)');
    Result := True;
  end;

//    procedure RealGrid1DrawCell(AColumn: TwColumn; ARow: Integer;
//      var Text: String; var BCol, FCol: TColor; var FStyle: TFontStyles);
  if ADest.Contains('(AColumn: TwColumn;') then
  begin
    ADest := ADest.Replace('(AColumn: TwColumn;', '(AColumn: TcxGridColumn;');
    Result := True;
  end;
end;

function TColumnsConverter.ConvertColCount(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]ol[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.ColumnCount';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.ColCount')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

// TwMemColumn(RealGrid1BandedTableView1.Columns[RealGrid1BandedTableView1.ColumnCount - 1]).DataType      := wdtFloat;
  // RealGrid1BandedTableView1.Columns[RealGrid1BandedTableView1.ColumnCount - 1].PropertiesClassName := 'TcxCurrencyEditProperties';

function TColumnsConverter.ConvertColumnDataType(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\.DataType\s+\:\=\s+wdt[A-Za-z]+\s*\;';

  REPLACE_FORMAT_BOOL  = '[[COLUMN]].PropertiesClassName := ''TcxCheckBoxProperties'';';
  REPLACE_FORMAT_FLT  = '[[COLUMN]].PropertiesClassName := ''TcxCurrencyEditProperties'';';
  REPLACE_FORMAT_STR  = '[[COLUMN]].PropertiesClassName := ''TcxTextEditProperties'';';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Indent, Col, DataType: string;
  Src, Dest: string;
  SIdx, EIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains(').DataType')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  Indent := '';
  for I := 1 to Length(ADest)-1 do
  begin
    if ADest[I] <> ' ' then
      Break;
    Indent := Indent + ' ';
  end;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    SIdx := Pos('(', ADest);
    EIdx := Pos(')', ADest);
    Col := Copy(ADest, SIdx+1, EIdx-SIdx-1);

    DataType := TRegEx.Match(Src, 'wdt[A-Za-z]+').Value.ToLower;
    if DataType = 'wdtstring' then
      Dest := REPLACE_FORMAT_STR
    else if DataType = 'wdtfloat' then
      Dest := REPLACE_FORMAT_FLT
    else if DataType = 'wdtbool' then
      Dest := REPLACE_FORMAT_BOOL
    ;
    ADest := Indent + Dest.Replace('[[COLUMN]]', Col);

    Result := True;
  end;
end;

// if TwMemColumn(R1.Columns[iCol]).DataType <> wdtDate then exit;
// If ( TwMemColumn(Columns[K]).DataType = wdtFloat ) Then Begin
// If TwMemColumn(RealGrid5BandedTableView1.Columns[J]).DataType = wdtFloat Then Begin
function TColumnsConverter.ConvertColumnDataTypeEquals(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = 'TwMemColumn\([\w\.\[\]]+\)\.DataType\s+[\=\<\>]+\s+wdt[A-Za-z]+';

  REPLACE_FORMAT_BOOL   = '[[COLUMN]].PropertiesClassName [[MARK]] ''TcxCheckBoxProperties''';
  REPLACE_FORMAT_FLT    = '[[COLUMN]].PropertiesClassName [[MARK]] ''TcxCurrencyEditProperties''';
  REPLACE_FORMAT_STR    = '[[COLUMN]].PropertiesClassName [[MARK]] ''TcxTextEditProperties''';
  REPLACE_FORMAT_DATE   = '[[COLUMN]].PropertiesClassName [[MARK]] ''TcxDateEditProperties''';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Col, DataType, Mark: string;
  Src, Dest: string;
  SIdx, EIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains(').DataType')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    SIdx := Pos('(', Src);
    EIdx := Pos(')', Src);
    Col := Copy(Src, SIdx+1, EIdx-SIdx-1);

    DataType := TRegEx.Match(Src, 'wdt[A-Za-z]+').Value.ToLower;
    Mark := TRegEx.Match(Src, '\.DataType\s+[\=\<\>]+\s+wdt').Value;
    Mark := Mark.Replace('.DataType', '').Replace('wdt', '').Trim;
    if DataType = 'wdtstring' then
      Dest := REPLACE_FORMAT_STR
    else if DataType = 'wdtfloat' then
      Dest := REPLACE_FORMAT_FLT
    else if DataType = 'wdtbool' then
      Dest := REPLACE_FORMAT_BOOL
    else if DataType = 'wdtdate' then
      Dest := REPLACE_FORMAT_DATE
    ;
    Dest := Dest.Replace('[[COLUMN]]', Col);
    Dest := Dest.Replace('[[MARK]]',   Mark);

    ADest := ADest.Replace(Src, Dest);

    Result := True;
  end;
end;

// (RealGrid1.Columns[RealGrid1.ColCount-1] As Twmemcolumn).DisplayFormat := '#,##0';
// TwMemColumn(RealGrid1BandedTableView1.Columns[RealGrid1BandedTableView1.ColumnCount - 1]).DisplayFormat := ',#';
// TcxCurrencyEditProperties(RealGrid1BandedTableView1.Columns[RealGrid1BandedTableView1.ColumnCount - 1].Properties).DisplayFormat := ',#';

  // 아래 진행 하지 말것
// TcxCurrencyEditProperties(gridViewInsert_SUB02.Columns[gridViewInsert_SUB02.ColumnCount -1].Properties).DisplayFormat  := '#,###.##;-#,###.##';
function TColumnsConverter.ConvertColumnDisplayFormat(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\)\.DisplayFormat\s+\:\=\s+';
  REPLACE_FORMAT  = 'TcxCurrencyEditProperties([[COLUMN]].Properties).DisplayFormat := [[FORMAT]]';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Indent, Col, Fmt: string;
  Src, Dest: string;
  SIdx, EIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains(').DisplayFormat ')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  Indent := '';
  for I := 1 to Length(ADest)-1 do
  begin
    if ADest[I] <> ' ' then
      Break;
    Indent := Indent + ' ';
  end;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    SIdx := Pos('(', ADest);
    EIdx := Pos(')', ADest);
    Col := Copy(ADest, SIdx+1, EIdx-SIdx-1);
    // 기존 퀀텀 컨트롤의 코드는 '.Properties'가 있으므로 무시
    if Col.Contains('.Properties') then
      Continue;
    // 동적 캐스팅 코드 제거
    Col := Col.Replace(' As Twmemcolumn', '');

    SIdx := Pos('''', ADest, Match.Index+Match.Length);
    Fmt := Copy(ADest, SIdx, Length(ADest));
    Dest := REPLACE_FORMAT;
    ADest := Indent + Dest.Replace('[[COLUMN]]', Col);
    ADest := ADest.Replace('[[FORMAT]]', Fmt);

    Result := True;
  end;
end;

// TwMemColumnFooter(RealGrid1BandedTableView1.Columns[RealGrid1BandedTableView1.ColumnCount - 1].Footer).Method[0] := wfmeSum;
// RealGrid1BandedTableView1.Columns[RealGrid1BandedTableView1.ColumnCount - 1].Summary.FooterKind := skSum;
function TColumnsConverter.ConvertColumnFooter(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\.Method\[0\]\s+\:\=\s+wfme[A-Za-z]+\;';
  REPLACE_FORMAT  = '[[COLUMN]].Summary.FooterKind := [[SUMMURY_KIND]]';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Indent, Col, FooterMethod, SummuryKind, Suffix: string;
  Src, Dest: string;
  SIdx, EIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.Footer).Method[')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  Indent := '';
  for I := 1 to Length(ADest)-1 do
  begin
    if ADest[I] <> ' ' then
      Break;
    Indent := Indent + ' ';
  end;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    SIdx := Pos('(', ADest);
    EIdx := Pos(')', ADest);
    Col := Copy(ADest, SIdx+1, EIdx-SIdx-1);
    Col := Col.Replace('.Footer', '');

    FooterMethod := TRegEx.Match(Src, 'wfme[A-Za-z]+').Value.ToLower;
    if FooterMethod = 'wfmenone' then
      SummuryKind := 'skNone'
    else if FooterMethod = 'wfmesum' then
      SummuryKind := 'skSum'
    else if FooterMethod = 'wfmeaverage' then
      SummuryKind := 'skAverage'
    else if FooterMethod = 'wfmecount' then
      SummuryKind := 'skCount'
    else if FooterMethod = 'wfmemin' then
      SummuryKind := 'skMin'
    else if FooterMethod = 'wfmemax' then
      SummuryKind := 'skMax'
    else
      TLogger.Error('Not Support FooterMethod.[%s]', [FooterMethod]);
    ;

    SIdx := Pos(';', ADest, Match.Index + Match.Length - 1);
    Suffix := Copy(ADest, SIdx, Length(ADest) - SIdx + 1);

    Dest := REPLACE_FORMAT;
    ADest := Indent + Dest.Replace('[[COLUMN]]', Col);
    ADest := ADest.Replace('[[SUMMURY_KIND]]', SummuryKind);
    ADest := ADest  + Suffix;

    Result := True;
  end;
end;

// RealGrid1BandedTableView1.Columns[04].Footer.Values[0]
// RealGrid1BandedTableView1.DataController.Summary.FooterSummaryValues[RealGrid1BandedTableView1.Columns[0].Summary.Item.Index]
function TColumnsConverter.ConvertColumnFooterValues0(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '[a-zA-Z\d\_]+\.Columns\[[\w\.\s\-\+]+\]\.Footer\.Values\[0\]';
  REPLACE_FORMAT  = '[[COMP_NAME]].DataController.Summary.FooterSummaryValues[[[COMP_NAME]].Columns[[[COL_IDX]]].Summary.Item.Index]';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not ASrc.Contains('Footer.Values[0]') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.Columns\[').Value.Replace('.Columns[', '').Trim;
    Col := TRegEx.Match(Src, '\.Columns\[[\w\.\s\-\+]+\]').Value.Replace('.Columns[', '').Replace(']', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[COL_IDX]]',   Col);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TColumnsConverter.ConvertColumnFooterValuesN(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  if AddTodo(ADest, 'Footer.Values[1]', '수작업:Footer.Values[1]') then
    Result := True;
  if AddTodo(ADest, 'Footer.Values[2]', '수작업:Footer.Values[2]') then
    Result := True;
  if AddComment(ADest, 'Footer).Method[1]', '수작업:Footer.Method[1]') then
    Result := True;
end;

function TColumnsConverter.ConvertColumnGroup(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\]\.Group[\s\]]';
  REPLACE_FORMAT  = '].Position.BandIndex';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Dest := REPLACE_FORMAT + Src[Length(Src)];

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TColumnsConverter.ConvertColumnsAdd(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\.[Aa]dd';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.CreateColumn';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not ASrc.Contains('.Columns.Add') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
// 너무 많음
//  if not Result then
//    OutputDebugString(PChar(ASrc));
end;

function TColumnsConverter.ConvertColumnsClear(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\.Clear';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.ClearItems';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.Columns.Clear') ) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TColumnsConverter.ConvertColumnsCount(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\.[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.ColumnCount';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not ASrc.Contains('.Columns.Count') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
// 너무 많음
//  if not Result then
//    OutputDebugString(PChar(ASrc));
end;

// RealGrid1.Columns.Delete(RealGrid1BandedTableView1.ColumnCount-1);
// RealGrid1BandedTableView1.Items[RealGrid1BandedTableView1.ColumnCount-1].Free;
function TColumnsConverter.ConvertColumnsDelete(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\.[Dd]elete\([\w\.\-\d\s]+\)\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Items[[[COL_IDX]]].Free;';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not ASrc.Contains('.Columns.Delete') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;
    Col   := TRegEx.Match(Src, '\([\w\.\-\d\s]+\)').Value.Replace('(', '').Replace(')', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[COL_IDX]]', Col);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TColumnsConverter.ConvertColumnsItems(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '(' + GRIDNAME_REGEX + '\.[Cc]olumns\[|' + GRIDNAME_REGEX + '\.[Cc]olumns.Items\[)';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Columns[';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.Columns[') or ASrc.Contains('.columns[')
      or ASrc.Contains('.Columns.Items[') or ASrc.Contains('.Columns.items[')
      or ASrc.Contains('.columns.Items[') or ASrc.Contains('.columns.items[')
    ) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TColumnsConverter.ConvertColumnsReadOnly(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\]\.[Rr]ead[Oo]nly';
  REPLACE_FORMAT  = '].Properties.ReadOnly';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if (not ADest.Contains('Columns[')) and (not ADest.Contains('columns[')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Dest := REPLACE_FORMAT;

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;


function TColumnsConverter.ConvertColumnEtc(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    '].Title.Visible',        '].Title.VisiBle',
    '].Title.CellStyle',      '].Title.Color',        '].Title.Clicking',
    '].EditStyle',            '].EditFormat',
    '].Footer.Color',         '].Footer.Font.Color',
    '].MaxValue',             '].MarginRight',
    '].Font.Color',           '].Font.Size',          '].Font.Name',
    ').DataWidth',
    '].AutoSize',             '].Title.Height',
    '].CharCase',             '].Title.Font',
    '].Title.SortMark',       '].ListOption.Titles'
  ];

  Datas.Add('].Alignment',    '].Properties.Alignment.Horz');
  Datas.Add('].LevelIndex',   '].Position.ColIndex');
  Datas.Add('].Level ',       '].Position.ColIndex');
  Datas.Add('.Title.Caption', '.Caption');
  Datas.Add('.Title.caption', '.Caption');

  Datas.Add('].ColCount[0]', '].ColumnCount');
  Datas.Add('].Columns[0, I]', '].Columns[I]');


  // 1곳
  Datas.Add('TwMemColumnFooter(RealGrid1BandedTableView1.Columns[15].Footer).Values[0]',
    'RealGrid1BandedTableView1.DataController.Summary.FooterSummaryValues[RealGrid1BandedTableView1.Columns[15].Summary.Item.Index]');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TColumnsConverter.ConvertGroupCount(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roup[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Bands.Count';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.GroupCount')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TColumnsConverter.ConvertGroupToBand(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.Groups\.';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Bands.';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TColumnsConverter.ConvertGroupToBandItems(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups\[';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Bands[';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.Groups[') or ASrc.Contains('.groups[')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TColumnsConverter.ConvertIntfSource(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := True;
  if ConvertAColumnToAItem(ASrc, ADest) then
    Exit;
  Result := False;
end;

function TColumnsConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertColumnsItems(ADest, ADest) then
    Result := True;
  if ConvertColumnsClear(ADest, ADest) then
    Result := True;
  if ConvertColumnsReadOnly(ADest, ADest) then
    Result := True;
  if ConvertColumnIndex(AProc, ADest, ADest) then
    Result := True;
  if ConvertColumnGroup(ADest, ADest) then
    Result := True;
  if ConvertAColumnToAItem(ADest, ADest) then
    Result := True;
  if ConvertAColumnReadOnly(ADest, ADest) then
    Result := True;

  if ConvertColumnDataType(ADest, ADest) then
    Result := True;
  if ConvertColumnDataTypeEquals(ADest, ADest) then
    Result := True;

  if ConvertColumnDisplayFormat(ADest, ADest) then
    Result := True;
  if ConvertColumnMaxLength(ADest, ADest) then
    Result := True;

  if ConvertColumnFooter(ADest, ADest) then
    Result := True;
  if ConvertColumnFooterValues0(ADest, ADest) then
    Result := True;
  if ConvertColumnFooterValuesN(ADest, ADest) then
    Result := True;

  if ConvertColumnsCount(ADest, ADest) then
    Result := True;
  if ConvertColumnsAdd(ADest, ADest) then
    Result := True;
  if ConvertColumnsDelete(ADest, ADest) then
    Result := True;

  if ConvertGroupToBandItems(ADest, ADest) then
    Result := True;
  if ConvertViewGroupToBandItems(ADest, ADest) then
    Result := True;

  if ConvertColCount(ADest, ADest) then
    Result := True;
  if ConvertGroupCount(ADest, ADest) then
    Result := True;
  if ConvertGroupToBand(ADest, ADest) then
    Result := True;

  if ConvertColumnEtc(ADest, ADest) then
    Result := True;
end;


function TColumnsConverter.ConvertViewGroupToBandItems(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = VIEWNAME_REGEX + '\.[Gg]roups\[';
  REPLACE_FORMAT  = '[[COMP_NAME]].Bands[';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (ASrc.Contains('.Groups[') or ASrc.Contains('.groups[')) then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TColumnsConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TColumnsConverter.GetDescription: string;
begin
  Result := 'TcxGrid Columns';
end;

initialization
  TConvertManager.Instance.Regist(TColumnsConverter);

end.

