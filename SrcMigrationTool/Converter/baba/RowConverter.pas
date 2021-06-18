unit RowConverter;

interface

uses
  SrcConverter;

type
  TRowConverter = class(TConverter)
  private
    function ConvertRowCount(ASrc: string; var ADest: string): Boolean;
    function ConvertCompRow(ASrc: string; var ADest: string): Boolean;
    function ConvertWithRow(ASrc: string; var ADest: string): Boolean;

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

function TRowConverter.ConvertCompRow(ASrc: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.(Row|row|ROW)[\s\,\)\+\-\]\;]';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.FocusedRowIndex';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
  LastChar: string;
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
    LastChar := Src[Length(Src)];

    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\.').Value.Replace('.', '').Trim;

    Dest := REPLACE_FORMAT + LastChar;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TRowConverter.ConvertEtc(AProc, ASrc: string; var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];

  if (AProc = 'Fun_PopupMenu')
    or (AProc = 'RealGrid_PopupMenu')
  then
  begin
    Datas.Add(' Row,', ' DataController.FocusedRowIndex,');
    Datas.Add('(Sender as TcxGridBandedTableView).Row,',
        '(Sender as TcxGridBandedTableView).DataController.FocusedRowIndex,');
  end;

//  Datas.Add('(Sender as TcxGridBandedTableView).Row,',
//      '(Sender as TcxGridBandedTableView).DataController.FocusedRowIndex,');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

// [\s\[\(]+RowCount
function TRowConverter.ConvertRowCount(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Rr]ow[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]BandedTableView1.DataController.RecordCount';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;

  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Datas.Add('[RowCount', '[DataController.RecordCount');
  Datas.Add(' RowCount', ' DataController.RecordCount');
  Datas.Add('(RowCount', '(DataController.RecordCount');
  Datas.Add('/RowCount', '/DataController.RecordCount');

  if ReplaceKeywords(ADest, Datas) then
    Exit(True);

  if not (ASrc.Contains('.RowCount') or ASrc.Contains('.Rowcount') or ASrc.Contains('.rowcount')) then
    Exit;
  if (ASrc.Contains('DataController.RecordCount')) then
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

function TRowConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertRowCount(ADest, ADest) then
    Result := True;
  if ConvertCompRow(ADest, ADest) then
    Result := True;
  if ConvertWithRow(ADest, ADest) then
    Result := True;

  if ConvertEtc(AProc, ADest, ADest) then
    Result := True;
end;

function TRowConverter.ConvertWithRow(ASrc: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '(\s|\()DataController\.Values\[(Row|row|ROW),';
  REPLACE_FORMAT  = 'DataController.Values[DataController.FocusedRowIndex,';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
  FirstChar: string;
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

    Dest := Src[1] + REPLACE_FORMAT;

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
  if not Result then
    OutputDebugString(PChar(ASrc));
end;

function TRowConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TRowConverter.GetDescription: string;
begin
  Result := 'TcxGrid Row';
end;

initialization
  TConvertManager.Instance.Regist(TRowConverter);

end.

