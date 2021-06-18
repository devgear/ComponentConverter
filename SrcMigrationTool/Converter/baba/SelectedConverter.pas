unit SelectedConverter;

interface

uses
  SrcConverter;

type
  TSelectedConverter = class(TConverter)
  private
    function ConvertSelectedIndex(ASrc: string; var ADest: string): Boolean;
    function ConvertWithSelectedIndexLeft(ASrc: string; var ADest: string): Boolean;
    function ConvertWithSelectedIndexRight(ASrc: string; var ADest: string): Boolean;
    function ConvertGridCol(ASrc: string; var ADest: string): Boolean;

    function ConvertSelectedColumn(ASrc: string; var ADest: string): Boolean;
    function ConvertSelectedColumnIndex(ASrc: string; var ADest: string): Boolean;
    function ConvertSelectedColumnGroup(ASrc: string; var ADest: string): Boolean;
    function ConvertSelectedColumnReadOnly(ASrc: string; var ADest: string): Boolean;

    function ConvertSenderSelected(ASrc: string; var ADest: string): Boolean;

    function ConvertEtc(ASrc: string; var ADest: string): Boolean;
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

//RealGrid1.SelectedColumn := RealGrid1.Columns[0];
  //  RealGrid2BandedTableView1.Controller.FocusedColumn
function TSelectedConverter.ConvertEtc(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('SelectedColumn := Columns[',   'Controller.FocusedColumn := Columns[');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TSelectedConverter.ConvertGridCol(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]ol[\s\;\,]';
  REPLACE_READ_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedColumn.Index';
  REPLACE_WRITE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Columns[[[COL_IDX]]].Focused := True';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, AfterStr, ColIdx: string;
  Src, Dest, Temp: string;
  AssignType: TAssignType;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value.Trim;
    Src := Copy(Src, 1, Length(Src)-2);

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    AfterStr := Copy(ASrc, Match.Index + Match.Length-1, Length(ADest)).Trim;
    if AfterStr.StartsWith(':=') then
      AssignType := atWrite
    else
      AssignType := atRead;

    if AssignType = atWrite then
    begin
      if Pos(';', AfterStr) > 0 then
        ColIdx := Copy(AfterStr, 3, Pos(';', AfterStr)-3).Trim
      else if Pos('//', AfterStr) > 0 then
        ColIdx := Copy(AfterStr, 3, Pos('//', AfterStr)-3).Trim
      else
        ColIdx := Copy(AfterStr, 3, Length(AfterStr)).Trim;
    end;

    if AssignType = atRead then
    begin
      Dest := REPLACE_READ_FORMAT;
      Dest := Dest.Replace('[[COMP_NAME]]', Comp);
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      ADest := ADest.Replace(Src, Dest);
    end
    else
    begin
      Dest := REPLACE_WRITE_FORMAT;
      Dest := Dest.Replace('[[COMP_NAME]]', Comp);
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      Temp := Copy(ADest, 1, Match.Index-1);
      Temp := Temp + Dest;
      Temp := Temp + Copy(AfterStr, Pos(';', AfterStr), Length(AfterStr));
      ADest := Temp;
    end;
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TSelectedConverter.ConvertSelectedColumn(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Cc]olumn\s';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedColumn ';
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

//    Case RealGrid1.SelectedColumn.Group Of
  //  TcxGridBandedColumn(RealGrid2BandedTableView1.Controller.FocusedItem).Position.BandIndex
function TSelectedConverter.ConvertSelectedColumnGroup(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Cc]olumn\.[Gg]roup';
  REPLACE_FORMAT  = 'TcxGridBandedColumn([[COMP_NAME]]BandedTableView1.Controller.FocusedColumn).Position.BandIndex';
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

//if (RealGrid1.SelectedColumn.Index = 31) AND ...
  //  RealGrid2BandedTableView1.Controller.FocusedColumn.Index
function TSelectedConverter.ConvertSelectedColumnIndex(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Cc]olumn\.[Ii]ndex';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedColumn.Index';
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

//    IF (Key = #13) And ( RealGrid3.SelectedColumn.ReadOnly = True) THEN
  //  RealGrid2BandedTableView1.Controller.FocusedColumn.Properties.ReadOnly
function TSelectedConverter.ConvertSelectedColumnReadOnly(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Cc]olumn\.[Rr]ead[Oo]nly';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedColumn.Properties.ReadOnly';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
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

// RealGrid2.Cells[RealGrid2.SelectedIndex,RealGrid2.Row].AsBoolean := False;
// RealGrid2.SelectedIndex := AColumn.Index;
// RealGrid2.Setfocus; RealGrid2.SelectedIndex := 29;//실판매금액

// READ - RealGrid1BandedTableView1.Controller.FocusedColumn.Index
// WRITE - RealGrid1BandedTableView1.Columns[0].Focused := True;
  // SelectedIndex 바로 뒤에 := 오는 경우에 한함
  // SRC: RealGrid2.SelectedIndex := AColumn.Index;
  // DST: RealGrid2BandedTableView1.Columns[AColumn.Index].Focused := True;
function TSelectedConverter.ConvertSelectedIndex(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Ii]ndex';
  REPLACE_READ_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedColumn.Index';
  REPLACE_WRITE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Columns[[[COL_IDX]]].Focused := True';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, AfterStr, ColIdx: string;
  Src, Dest, Temp: string;
  AssignType: TAssignType;
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

    AfterStr := Copy(ASrc, Match.Index + Match.Length, Length(ADest)).Trim;
    if AfterStr.StartsWith(':=') then
      AssignType := atWrite
    else
      AssignType := atRead;

    if AssignType = atWrite then
    begin
      if Pos(';', AfterStr) > 0 then
        ColIdx := Copy(AfterStr, 3, Pos(';', AfterStr)-3).Trim
      else
        ColIdx := Copy(AfterStr, 3, Length(AfterStr)).Trim;
    end;

    if AssignType = atRead then
    begin
      Dest := REPLACE_READ_FORMAT;
      Dest := Dest.Replace('[[COMP_NAME]]', Comp);
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      ADest := ADest.Replace(Src, Dest);
    end
    else
    begin
      Dest := REPLACE_WRITE_FORMAT;
      Dest := Dest.Replace('[[COMP_NAME]]', Comp);
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      Temp := Copy(ADest, 1, Match.Index-1);
      Temp := Temp + Dest;
      Temp := Temp + Copy(AfterStr, Pos(';', AfterStr), Length(AfterStr));
      ADest := Temp;
    end;
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TSelectedConverter.ConvertSenderSelected(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('( Sender As TRealGrid).SelectedColumn',
            '(Sender as TcxGridBandedTableView).Controller.FocusedColumn');


  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TSelectedConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertSelectedIndex(ADest, ADest) then
    Result := True;
  if ConvertWithSelectedIndexLeft(ADest, ADest) then
    Result := True;
  if ConvertWithSelectedIndexRight(ADest, ADest) then
    Result := True;
  if ConvertGridCol(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumn(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumnIndex(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumnGroup(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumnReadOnly(ADest, ADest) then
    Result := True;

  if ConvertSenderSelected(ADest, ADest) then
    Result := True;
  if ConvertEtc(ADest, ADest) then
    Result := True;
end;

function TSelectedConverter.ConvertWithSelectedIndexLeft(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = ' SelectedIndex :=';
  REPLACE_FORMAT  = 'Columns[[[COL_IDX]]].Focused := True;';
var
  Indent, Col, Dest: string;
  ColIdx, ColonIdx: Integer;
begin
  Result := False;

  ADest := ASrc;
  if not ADest.Contains(SEARCH_PATTERN) then
    Exit;

  ColIdx := Pos(SEARCH_PATTERN, ADest)+Length(SEARCH_PATTERN);
  ColonIdx := Pos(';', ADest);
  Col := Copy(ADest, ColIdx + 1, ColonIdx - ColIdx-1);

  Indent := GetIndent(ADest);
  Dest := REPLACE_FORMAT;
  Dest := Dest.Replace('[[COL_IDX]]', Col);
  ADest := Indent + Dest;
  Result := True;

//Columns[[[COL_IDX]]].Focused := True
end;

function TSelectedConverter.ConvertWithSelectedIndexRight(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;


end;

function TSelectedConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TSelectedConverter.GetDescription: string;
begin
  Result := 'TcxGrid Selected';
end;

initialization
  TConvertManager.Instance.Regist(TSelectedConverter);

end.
