unit SelIdxConverter;

interface

uses
  SrcConverter;

type
  TSelectedConverter = class(TConverter)
  private
    function ConvertSelectedIndex(ASrc: string; var ADest: string): Boolean;

    function ConvertSelectedColumn(ASrc: string; var ADest: string): Boolean;
    function ConvertSelectedColumnIndex(ASrc: string; var ADest: string): Boolean;
    function ConvertSelectedColumnGroup(ASrc: string; var ADest: string): Boolean;
    function ConvertSelectedColumnReadOnly(ASrc: string; var ADest: string): Boolean;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;

    function ConvertSource(ASrc: string; var ADest: string): Boolean; override;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes, System.SysUtils,
  System.RegularExpressions;

{ TCellsConverter }

//RealGrid1.SelectedColumn := RealGrid1.Columns[0];
  //  RealGrid2BandedTableView1.Controller.FocusedColumn
function TSelectedConverter.ConvertSelectedColumn(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = 'RealGrid\d+\.[Ss]elected[Cc]olumn\s';
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
  SEARCH_PATTERN  = 'RealGrid\d+\.[Ss]elected[Cc]olumn\.[Gg]roup';
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
  SEARCH_PATTERN  = 'RealGrid\d+\.[Ss]elected[Cc]olumn\.[Ii]ndex';
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
  SEARCH_PATTERN  = 'RealGrid\d+\.[Ss]elected[Cc]olumn\.[Rr]ead[Oo]nly';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedColumn.Properties.ReadOnly';
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

function TSelectedConverter.ConvertSelectedIndex(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '(RealGrid[\d]+|rgd_[A-Za-z]+)\.[Ss]elected[Ii]ndex';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.Controller.FocusedItemIndex';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if not (TRegEx.Match(ASrc, '\.[Ss]elected[Ii]ndex').Success) then
    Exit;
  if (ASrc.Contains('Controller.FocusedItemIndex')) then
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

function TSelectedConverter.ConvertSource(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertSelectedIndex(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumn(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumnIndex(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumnGroup(ADest, ADest) then
    Result := True;

  if ConvertSelectedColumnReadOnly(ADest, ADest) then
    Result := True;
end;

function TSelectedConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TSelectedConverter.GetDescription: string;
begin
  Result := 'TcxGrid SelectedIndex 변환';
end;

initialization
  TConvertManager.Instance.Regist(TSelectedConverter);

end.
