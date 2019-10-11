unit GridViewConverter;

interface

uses
  SrcConverter;

type
  TGridViewConverter = class(TConverter)
  private
    function ConvertSenderAs(ASrc: string; var ADest: string): Boolean;
    function ConvertSenderSelIdx(ASrc: string; var ADest: string): Boolean;
    function ConvertGroupMode(ASrc: string; var ADest: string): Boolean;

    function ConvertRowHeight(ASrc: string; var ADest: string): Boolean;

    function ConvertFind(ASrc: string; var ADest: string): Boolean;

    function ConvertBeginUpdate(ASrc: string; var ADest: string): Boolean;
    function ConvertEndUpdate(ASrc: string; var ADest: string): Boolean;

    function ConvertEtc(AProc, ASrc: string; var ADest: string): Boolean;
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

// iRow := RealGrid4.Find(1,RealGrid4BandedTableView1.DataController.Values[RealGrid4BandedTableView1.DataController.FocusedRowIndex, 0]);
// iRow := RealGrid2.Find(0,sCode);

// iRow := RealGrid2BandedTableView1.DataController.FindRecordIndexByText(0, 1, VarAsType(RealGrid2BandedTableView1.DataController.Values[RealGrid2BandedTableView1.DataController.FocusedRowIndex, 1], varString), false, false, true)
function TGridViewConverter.ConvertFind(ASrc: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.Find\([\w\,\.\[\]\s]+\)';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.FindRecordIndexByText(0, [[PARAM]], false, false, true)';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Param: string;
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

    Param := TRegEx.Match(Src, '\([\w\,\.\[\]\s]+\)').Value.Replace('(', '').Replace(')', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[PARAM]]',     Param);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TGridViewConverter.ConvertGroupMode(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roup[Mm]ode';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.OptionsView.BandHeaders';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  ADest := ASrc;
  if AddComment(ADest, '.ColumnMode') then
    Exit(True);

  if not ASrc.Contains('.GroupMode') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
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

function TGridViewConverter.ConvertRowHeight(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.RowHeight';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.OptionsView.DataRowHeight';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  ADest := ASrc;

  if not ASrc.Contains('.RowHeight') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
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

function TGridViewConverter.ConvertSenderAs(ASrc: string; var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('(Sender as TcxGrid).Row,',
      '(Sender as TcxGrid).Views[0].DataController.FocusedRowIndex,');
  Datas.Add('(Sender as TcxGrid).DataController',
      '(Sender as TcxGrid).Views[0].DataController');
  Datas.Add('(Sender as TcxGrid).Row ',
      '(Sender as TcxGrid).Views[0].DataController.FocusedRowIndex ');
  Datas.Add('(Sender as TcxGrid).RowCount',
      '(Sender as TcxGrid).Views[0].DataController.RecordCount');
  Datas.Add('(Sender as TcxGrid).Cancel',
      '(Sender as TcxGrid).Views[0].DataController.Cancel');
  Datas.Add('(Sender as TcxGrid).Columns[',
      'TcxGridBandedTableView((Sender as TcxGrid).Views[0]).Columns[');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

// (Sender as TcxGrid).SelectedIndex := 0;
// Parambyname('코드명').AsString   := '%'+(Sender as TcxGrid).Views[0].DataController.Values[iCol, (Sender as TcxGrid).SelectedIndex ], varString)+ '%';
// (Sender as TcxGrid).Views[0].SelectedIndex := 0;
function TGridViewConverter.ConvertSenderSelIdx(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\(Sender\sas\sTcxGrid\)\.[Ss]elected[Ii]ndex';
  REPLACE_READ_FORMAT  = 'TcxGridBandedTableView((Sender as TcxGrid).Views[0]).Controller.FocusedColumn.Index';
  REPLACE_WRITE_FORMAT  = 'TcxGridBandedTableView((Sender as TcxGrid).Views[0]).Columns[[[COL_IDX]]].Focused := True';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, AfterStr, ColIdx: string;
  Src, Dest, Temp: string;
  AssignType: TAssignType;
begin
  Result := False;

  if not ASrc.Contains('(Sender as TcxGrid).SelectedIndex') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

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
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      ADest := ADest.Replace(Src, Dest);
    end
    else
    begin
      Dest := REPLACE_WRITE_FORMAT;
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      Temp := Copy(ADest, 1, Match.Index-1);
      Temp := Temp + Dest;
      Temp := Temp + Copy(AfterStr, Pos(';', AfterStr), Length(AfterStr));
      ADest := Temp;
    end;
    Result := True;
  end;
end;

function TGridViewConverter.ConvertBeginUpdate(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.BeginUpdate\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.BeginUpdate;';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  ADest := ASrc;

  if not ASrc.Contains('.BeginUpdate') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
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

function TGridViewConverter.ConvertEndUpdate(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.EndUpdate(\(True\))?\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.EndUpdate;';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  ADest := ASrc;

  if not ASrc.Contains('.EndUpdate') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
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

function TGridViewConverter.ConvertEtc(AProc, ASrc: string; var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    '].Font.Size :=',
    '.FixedCount :=',         '.fixedcount :=',
    '.TopRow',
    'Footers[0].Visible'
  ];

  // TableView.ColumnCount
  Datas.Add(' ColCount',        ' ColumnCount');
  Datas.Add(' GroupCount',        ' Bands.Count');
  Datas.Add(' CalcFooters',        ' DataController.Summary.CalculateFooterSummary');


  if AProc = 'Real_Check' then
    Datas.Add('Col := 00;',        'Columns[00].Focused := True;');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TGridViewConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertSenderAs(ADest, ADest) then
    Result := True;
  if ConvertSenderSelIdx(ADest, ADest) then
    Result := True;
  if ConvertFind(ADest, ADest) then
    Result := True;

  if ConvertBeginUpdate(ADest, ADest) then
    Result := True;
  if ConvertEndUpdate(ADest, ADest) then
    Result := True;

  if ConvertGroupMode(ADest, ADest) then
    Result := True;
  if ConvertRowHeight(ADest, ADest) then
    Result := True;

  if ConvertEtc(AProc, ADest, ADest) then
    Result := True;
end;

function TGridViewConverter.GetCvtCompClassName: string;
const
  COMP_NAME = '';
begin
  Result := COMP_NAME;
end;

function TGridViewConverter.GetDescription: string;
begin
  Result := 'TcxGrid Grid&View';
end;

initialization
  TConvertManager.Instance.Regist(TGridViewConverter);

end.

