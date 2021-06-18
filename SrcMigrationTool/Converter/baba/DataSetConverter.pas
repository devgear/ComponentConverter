unit DataSetConverter;

interface

uses
  SrcConverter;

type
  TDataSetConverter = class(TConverter)
  private
    function ConvertAddRow(ASrc: string; var ADest: string): Boolean;
    function ConvertInsert(ASrc: string; var ADest: string): Boolean;
    function ConvertInsertRow(ASrc: string; var ADest: string): Boolean;
    function ConvertCancel(ASrc: string; var ADest: string): Boolean;
    function ConvertPost(ASrc: string; var ADest: string): Boolean;
    function ConvertClear(ASrc: string; var ADest: string): Boolean;
    function ConvertClearData(ASrc: string; var ADest: string): Boolean;

    function ConvertMoveRow(ASrc: string; var ADest: string): Boolean;
    function ConvertDeleteRow(ASrc: string; var ADest: string): Boolean;

    function ConvertGridMode(ASrc: string; var ADest: string): Boolean;
    function ConvertRowState(ASrc: string; var ADest: string): Boolean;

    function ConvertCalcFooters(ASrc: string; var ADest: string): Boolean;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;

    function ConvertSource(AProc, ASrc: string; var ADest: string): Boolean; override;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes, System.SysUtils,
  System.RegularExpressions, SrcConvertUtils;

{ TCellsConverter }

function TDataSetConverter.ConvertAddRow(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Aa]ddRow[\(\)]*\s*;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.AppendRecord;';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not ASrc.Contains('AddRow') then
    Exit;

  // with 문 건
  if ASrc.Contains(' AddRow') then
  begin
    ADest := ASrc.Replace(' AddRow', ' DataController.AppendRecord');
    Result := True;
    Exit;
  end;

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

function TDataSetConverter.ConvertCalcFooters(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]alcFooters';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.Summary.CalculateFooterSummary';
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
end;

function TDataSetConverter.ConvertCancel(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]ancel\s*\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.Cancel;';
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
end;

function TDataSetConverter.ConvertClear(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]lear\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.RecordCount := 0;';
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
end;

function TDataSetConverter.ConvertClearData(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]lear[Dd]ata\;';
  REPLACE_FORMAT  = 'var rowCnt := [[COMP_NAME]]BandedTableView1.DataController.RecordCount;'#13#10 +
                    '[[INDENT]][[COMP_NAME]]BandedTableView1.DataController.RecordCount := 0;'#13#10 +
                    '[[INDENT]][[COMP_NAME]]BandedTableView1.DataController.RecordCount := rowCnt;';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest, Indent: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;

  Indent := GetIndent(ADest);
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;
    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[INDENT]]',    Indent);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TDataSetConverter.ConvertDeleteRow(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Dd]elete[Rr]ow\(';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.DeleteRecord([[IDX]]);';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Idx, Prefix: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
//  Indent := GetIndent(ADest);
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;
    Prefix := Copy(ASrc, 1, Match.Index-1);

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;
    Match := TRegEx.Match(ADest, '\([\w\.\s\-\+]+\,');
    if Match.Success then
      Idx   := Match.Value.Replace('(', '').Replace(',', '').Trim;
    Match := TRegEx.Match(ADest, '\([\w\.\s\-\+]+\)');
    if Match.Success then
      Idx   := Match.Value.Replace('(', '').Replace(')', '').Trim;

    Dest := Prefix + REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[IDX]]',       Idx);

    ADest := Dest;
    Result := True;
  end;
end;

// if RealGrid2.GridMode <> wgmBrowse then
    // ERP에 위 코드만 존재
// if (dceInsert in RealGrid2BandedTableView1.DataController.EditState)
//  or (dceEdit in RealGrid2BandedTableView1.DataController.EditState) then
function TDataSetConverter.ConvertGridMode(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]rid[Mm]ode\s\<\>\swgmBrowse';
  REPLACE_FORMAT  = '(dceInsert in [[COMP_NAME]]BandedTableView1.DataController.EditState)'#13#10 +
                   '[[INDENT]]    or (dceEdit in [[COMP_NAME]]BandedTableView1.DataController.EditState)';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest, INDENT: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  Indent := GetIndent(ADest);
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;
    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[INDENT]]',    Indent);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TDataSetConverter.ConvertInsert(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ii]nsert(\s|\(True\))*\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.Insert;';
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
end;

function TDataSetConverter.ConvertInsertRow(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ii]nsert[Rr]ow\([\w\(\)\.]+\)\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.InsertRecord([[IDX]]);';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Idx: string;
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
    Idx   := TRegEx.Match(Src, '\([\w\(\)\.]+\)').Value;
    Idx   := Copy(Idx, 2, Length(Idx)-2); // () 제거

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[IDX]]',       Idx);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TDataSetConverter.ConvertMoveRow(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Mm]ove[Rr]ow\(';
  REPLACE_FORMAT  = '';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Param1, Param2, Indent: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  Indent := GetIndent(ADest);
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];

    Param1 := TRegEx.Match(ADest, '\([\w\.\s\-\+]+\,').Value.Replace('(', '').Replace(',', '').Trim;
    Param2 := TRegEx.Match(ADest, '\,[\w\.\s\-\+]+\)').Value.Replace(')', '').Replace(',', '').Trim;


    ADest := Indent + Param1 + ' := ' +Param2 + ';';
    Result := True;
  end;
end;

function TDataSetConverter.ConvertPost(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Po]ost\s*';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.Post';
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
end;

function TDataSetConverter.ConvertRowState(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;

  ADest := ASrc;
  if AddComment(ADest, '.RowState[', '검토 필요') then
    Result := True;

end;

function TDataSetConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertAddRow(ADest, ADest) then
    Result := True;
  if ConvertInsert(ADest, ADest) then
    Result := True;
  if ConvertInsertRow(ADest, ADest) then
    Result := True;
  if ConvertMoveRow(ADest, ADest) then
    Result := True;
  if ConvertDeleteRow(ADest, ADest) then
    Result := True;

  if ConvertCancel(ADest, ADest) then
    Result := True;
  if ConvertPost(ADest, ADest) then
    Result := True;
  if ConvertClear(ADest, ADest) then
    Result := True;
  if ConvertClearData(ADest, ADest) then
    Result := True;

  if ConvertGridMode(ADest, ADest) then
    Result := True;
  if ConvertRowState(ADest, ADest) then
    Result := True;

  if ConvertCalcFooters(ADest, ADest) then
    Result := True;
end;

function TDataSetConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TDataSetConverter.GetDescription: string;
begin
  Result := 'TcxGrid DataSet';
end;

initialization
  TConvertManager.Instance.Regist(TDataSetConverter);

end.

