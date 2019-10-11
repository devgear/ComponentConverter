unit CellsConverter;

interface

uses
  SrcConverter;

type
  TCellsConverter = class(TConverter)
  private
    function SourceToDest(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;

    function SourceToDestAsString(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
    function SourceToDestAsInteger(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
    function SourceToDestAsFloat(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
    function SourceToDestAsBoolean(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
    function SourceToDestAsDateTime(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;

    function SourceToDestValue(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
//    function SourceToDestText(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
    function SourceToDestIsNull(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
    function SourceToDestSetNull(AComp, ACol, ARow, ASuffix: string; AAssignType: TAssignType): string;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;

    function ConvertSource(AProc, ASrc: string; var ADest: string): Boolean; override;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes, System.SysUtils,
  System.RegularExpressions, Logger, SrcConvertUtils;

{ TCellsConverter }

function ParseColRowText(ASrc: string; var ACol, ARow: string): Boolean;
var
  I, StartIdx, CommaIdx, EndIdx: Integer;
  CellText: string;
  C: Char;
  Level: Integer;
begin
  StartIdx := Pos('[', ASrc);
  EndIdx := ASrc.LastIndexOf(']');
  if (StartIdx = 0) or (EndIdx = 0) then
    Exit(False);

  CellText := Copy(ASrc, StartIdx+1, EndIdx-StartIdx);
  Level := 0;
  for I := 1 to Length(CellText) do
  begin
    C := CellText[I];
    if C = '(' then
      Inc(Level)
    else if C = ')' then
      Dec(Level);

    if (Level = 0) and (C = ',') then
    begin
      CommaIdx := I;
      Break;
    end;
  end;
  if CommaIdx = 0 then
    Exit(False);
  ACol   := Copy(CellText, 1, CommaIdx-1).Trim;
  ARow   := Copy(CellText, CommaIdx+1, Length(CellText)).Trim;
  Result := True;
end;

// ]. AsFloat : As 앞에 공백이 있는 경우 존재
// CellS
function TCellsConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
const
//  SEARCH_PATTERN  = '([a-zA-Z\d\_]+\.)         ?(C|c)ell[Ss]\s*\[[\w\.\s\-\+]+\,   [\w\.\s\-\+]+\]\.\s*[a-zA-Z]+';
  SEARCH_PATTERN  =   '(' + GRIDNAME_REGEX + '\.)?(C|c)ell[Ss]\s*\[[\w\.\s\-\+]+\,\s*[\w\.\s\-\+]+\]\.\s*[a-zA-Z]+';
//  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.Values[[[ROW_IDX]], [[COL_IDX]]]';
//  REPLACE_WITHOUT_COMP = 'DataController.Values[[[ROW_IDX]], [[COL_IDX]]]';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match, Match2: TMatch;
  Comp, Col, Row, Suffix: string;
  Src, Src2, Dest: string;
  TagStartIdx, TagEndIdx: Integer;

  AssignType: TAssignType;
  AssignIdx: Integer;
begin
  Result := False;

//  if ASrc = '    for nI := 0 to RealGrid3.RowCount - 1 Do Begin' then
//    Result := True;
  if not (ASrc.Contains('Cells') or ASrc.Contains('cells') or ASrc.Contains('CellS')) then
    Exit;

  ADest := ASrc;
  // AsIndex 미사용 주석처리
  if AddComment(ADest, '.AsIndex') then
  begin
    Result := True;
    Exit;
  end;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
//  if Matchs.Count = 0 then
//    Exit;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    Comp    := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;
    Match2  := TRegEx.Match(Src, '\[[\w\.\s\-\+]+\,');
    Col     := Match2.Value;
    Col     := Copy(Col, 2, Length(Col)-2).Trim;
    Src2    := Copy(Src, Match2.Index + Match2.Length-1, Length(Src));
    Row     := TRegEx.Match(Src2, '\,\s*[\w\.\s\-\+]+\]').Value;
    Row     := Copy(Row, 2, Length(Row)-2).Trim;
    Suffix  := TRegEx.Match(Src2, '\]\.\s*[a-zA-Z]+').Value.Replace('].', '').Trim;

    // 엑셀의 Cells[].Value 미처리
    if Comp.ToUpper.Contains('XL') or Comp.ToUpper.Contains('WORKSHEET')
         or Comp.ToUpper.Contains('WORKBOOK') then
      Continue;

    AssignType := atRead;
    AssignIdx := ADest.IndexOf(':=', Match.Index);
    if AssignIdx > 0 then
      AssignType := atWrite;

    Dest := SourceToDest(Comp, Col, Row, Suffix, AssignType);
    if Dest = '' then
    begin
      TLogger.Error('[CellsConvert] %s 처리불가', [Src]);
    end
    else
    begin
      ADest := ADest.Replace(Src, Dest);
      Result := True;
    end;
  end;

  if not Result then
  begin
    // Cells 안에 한글이 포함된 경우 예외처리
    //+'  AND   작지.색상     = ''' + RealGrid1.Cells[SW_RCOL_FIND(RealGrid1,'검품색상'  ),rw].AsString + '''                           '#13#10
    while ADest.Contains('cells') or ADest.Contains('Cells') do
    begin
      TagStartIdx := 0;
      TagEndIdx := 0;
      Match := TRegEx.Match(ADest, '([a-zA-Z\d\_]+\.)?(C|c)ells\s*\[');
      if Match.Success then
        TagStartIdx := Match.Index;
      // if GBrandSizeInfo.Gu[nJ].Name = Cells[SW_Rcol_Find(SetRGrid,''브랜드2''), nRow].AsString then begin
        // '\]\.[a-zA-Z]+' 으로 검색 시 TagEndIdx 가 TagStartIdx 보다 작은 경우 발생
        // '\]\.([Aa]s[a-zA-Z]+|[Vv]alue|[Tt]ext|[Ii]s[Nn]ull)' 으로 변경
          // AsXXX, Value, Text, IsNull
      Match := TRegEx.Match(ADest, '\]\.([Aa]s[a-zA-Z]+|[Vv]alue|[Tt]ext|[Ii]s[Nn]ull)');
      if Match.Success then
      begin
        TagEndIdx := Match.Index + Match.Length;
        Suffix  := Match.Value.Replace('].', '').Trim;
      end;

      if (TagStartIdx <= 0) or (TagEndIdx <= 0) then
        Break;

      Src := Copy(ADest, TagStartIdx, TagEndIdx - TagStartIdx);

      Comp  := TRegEx.Match(Src, '[a-zA-Z]+\d+\.').Value.Replace('.', '').Trim;
      if ParseColRowText(Src, Col, Row) then
      begin
        AssignType := atRead;
        AssignIdx := ADest.IndexOf(':=', TagStartIdx);
        if AssignIdx > 0 then
          AssignType := atWrite;

        Dest := SourceToDest(Comp, Col, Row, Suffix, AssignType);
        if Dest = '' then
        begin
          TLogger.Log('[ERR][CellsConvert] %s 처리불가', [Src]);
        end
        else
        begin
          ADest := ADest.Replace(Src, Dest);
          Result := True;
        end;
//        if Comp = '' then
//          Dest := REPLACE_WITHOUT_COMP
//        else
//          Dest := REPLACE_FORMAT;
//        Dest := Dest.Replace('[[COMP_NAME]]', Comp);
//        Dest := Dest.Replace('[[COL_IDX]]', Col);
//        Dest := Dest.Replace('[[ROW_IDX]]', Row);
//        ADest := ADest.Replace(Src, Dest);
//        Result := True;
      end;
    end;
  end;
end;

function TCellsConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TCellsConverter.GetDescription: string;
begin
  Result := 'TcxGrid Cells';
end;

const
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.Values[[[ROW_IDX]], [[COL_IDX]]]';
  REPLACE_WITHOUT_COMP = 'DataController.Values[[[ROW_IDX]], [[COL_IDX]]]';

function TCellsConverter.SourceToDest(AComp, ACol, ARow, ASuffix: string;
  AAssignType: TAssignType): string;
begin
  // VarAsType 미적용하기 위해 강재로 atWrite
  AAssignType := atWrite;

  ASuffix := ASuffix.ToLower;
  if (ASuffix = 'asstring') or (ASuffix = 'text') then
    Result := SourceToDestAsString(AComp, ACol, ARow, ASuffix, AAssignType)
  else if (ASuffix = 'asinteger') or (ASuffix = 'asindex') then
    Result := SourceToDestAsInteger(AComp, ACol, ARow, ASuffix, AAssignType)
  else if ASuffix = 'asfloat' then
    Result := SourceToDestAsFloat(AComp, ACol, ARow, ASuffix, AAssignType)
  else if (ASuffix = 'asboolean') or (ASuffix = 'asbool') then
    Result := SourceToDestAsBoolean(AComp, ACol, ARow, ASuffix, AAssignType)
  else if ASuffix = 'asdatetime' then
    Result := SourceToDestAsDateTime(AComp, ACol, ARow, ASuffix, AAssignType)
  else if ASuffix = 'value' then
    Result := SourceToDestValue(AComp, ACol, ARow, ASuffix, AAssignType)
  else if ASuffix = 'isnull' then
    Result := SourceToDestIsNull(AComp, ACol, ARow, ASuffix, AAssignType)
  else if ASuffix = 'setnull' then
    Result := SourceToDestSetNull(AComp, ACol, ARow, ASuffix, AAssignType)
  ;
end;

function TCellsConverter.SourceToDestAsBoolean(AComp, ACol, ARow,
  ASuffix: string; AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = 'VarAsType(%s, varBoolean)';
begin
    if AComp = '' then
      Result := REPLACE_WITHOUT_COMP
    else
      Result := REPLACE_FORMAT;
    Result := Result.Replace('[[COMP_NAME]]', AComp);
    Result := Result.Replace('[[COL_IDX]]', ACol);
    Result := Result.Replace('[[ROW_IDX]]', ARow);

    if AAssignType = atRead then
      Result := Format(VARASTYPE_TEXT, [Result]);
end;

// result := FormatDateTime(sFormat, R1.Cells[iCol, iRow].AsDateTime);
// RealGrid2.Cells[01,iRow].AsDateTime := FieldByName('지시일자'    ).AsDateTime;
function TCellsConverter.SourceToDestAsDateTime(AComp, ACol, ARow,
  ASuffix: string; AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = 'VarAsType(%s, varDate)';
begin
    if AComp = '' then
      Result := REPLACE_WITHOUT_COMP
    else
      Result := REPLACE_FORMAT;
    Result := Result.Replace('[[COMP_NAME]]', AComp);
    Result := Result.Replace('[[COL_IDX]]', ACol);
    Result := Result.Replace('[[ROW_IDX]]', ARow);

    if AAssignType = atRead then
      Result := Format(VARASTYPE_TEXT, [Result]);
end;

function TCellsConverter.SourceToDestAsFloat(AComp, ACol, ARow, ASuffix: string;
  AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = 'VarAsType(%s, varDouble)';
begin
    if AComp = '' then
      Result := REPLACE_WITHOUT_COMP
    else
      Result := REPLACE_FORMAT;
    Result := Result.Replace('[[COMP_NAME]]', AComp);
    Result := Result.Replace('[[COL_IDX]]', ACol);
    Result := Result.Replace('[[ROW_IDX]]', ARow);

    if AAssignType = atRead then
      Result := Format(VARASTYPE_TEXT, [Result]);
end;


function TCellsConverter.SourceToDestAsInteger(AComp, ACol, ARow,
  ASuffix: string; AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = 'VarAsType(%s, varInteger)';
begin
    if AComp = '' then
      Result := REPLACE_WITHOUT_COMP
    else
      Result := REPLACE_FORMAT;
    Result := Result.Replace('[[COMP_NAME]]', AComp);
    Result := Result.Replace('[[COL_IDX]]', ACol);
    Result := Result.Replace('[[ROW_IDX]]', ARow);

    if AAssignType = atRead then
      Result := Format(VARASTYPE_TEXT, [Result]);
end;

// AsString / Text
  // +' SELECT NVL(''' + RGrid_Style.Cells[01, iRow].Text + ''','''') FROM DUAL  '#13#10
  // schk := RealGrid1.Cells[02,nRow].text;
  // if RealGrid2.Cells[14,iRow].Text = '' then begin
function TCellsConverter.SourceToDestAsString(AComp, ACol, ARow,
  ASuffix: string; AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = 'VarAsType(%s, varString)';
begin
    if AComp = '' then
      Result := REPLACE_WITHOUT_COMP
    else
      Result := REPLACE_FORMAT;
    Result := Result.Replace('[[COMP_NAME]]', AComp);
    Result := Result.Replace('[[COL_IDX]]', ACol);
    Result := Result.Replace('[[ROW_IDX]]', ARow);

    if AAssignType = atRead then
      Result := Format(VARASTYPE_TEXT, [Result]);
end;

// if (RealGrid1.Cells[0, iRow].AsString = '') or (RealGrid1.Cells[0, iRow].IsNull) or
// if Not (RealGrid1.Cells[iCol, iRow].IsNull) then
// If RealGrid1.Cells[18,nI].IsNull Then
// if R1.Cells[iCol, iRow].IsNull = true then exit;
function TCellsConverter.SourceToDestIsNull(AComp, ACol, ARow, ASuffix: string;
  AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = '%s = NULL';
begin
  if AComp = '' then
    Result := REPLACE_WITHOUT_COMP
  else
    Result := REPLACE_FORMAT;
  Result := Result.Replace('[[COMP_NAME]]', AComp);
  Result := Result.Replace('[[COL_IDX]]', ACol);
  Result := Result.Replace('[[ROW_IDX]]', ARow);

  Result := Format(VARASTYPE_TEXT, [Result]);
end;

function TCellsConverter.SourceToDestSetNull(AComp, ACol, ARow, ASuffix: string;
  AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = '%s := NULL';
begin
  if AComp = '' then
    Result := REPLACE_WITHOUT_COMP
  else
    Result := REPLACE_FORMAT;
  Result := Result.Replace('[[COMP_NAME]]', AComp);
  Result := Result.Replace('[[COL_IDX]]', ACol);
  Result := Result.Replace('[[ROW_IDX]]', ARow);

  Result := Result + ' := NULL';
end;

function TCellsConverter.SourceToDestValue(AComp, ACol, ARow, ASuffix: string;
  AAssignType: TAssignType): string;
const
  VARASTYPE_TEXT = 'VarAsType(%s, varString)';
begin
    if AComp = '' then
      Result := REPLACE_WITHOUT_COMP
    else
      Result := REPLACE_FORMAT;
    Result := Result.Replace('[[COMP_NAME]]', AComp);
    Result := Result.Replace('[[COL_IDX]]', ACol);
    Result := Result.Replace('[[ROW_IDX]]', ARow);

    // Cells[].Value가 이미 Variant
//    if AAssignType = atRead then
//      Result := Format(VARASTYPE_TEXT, [Result]);
end;

initialization
  TConvertManager.Instance.Regist(TCellsConverter);

end.
