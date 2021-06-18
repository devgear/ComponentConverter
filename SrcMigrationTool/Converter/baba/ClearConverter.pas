unit ClearConverter;

interface

uses
  SrcConverter;

type
  TClearConverter = class(TConverter)
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

function TClearConverter.ConvertSource(ASrc: string;
  var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '(RealGrid\d+|R1|rgd_[A-Za-z]+)\.[Cc]lear\;';
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

  if not (ASrc.Contains('.Clear;') or ASrc.Contains('.clear;')) then
    Exit;

//  if ASrc.Contains(' RowCount ') then
//  begin
//    ADest := ASrc.Replace(' RowCount ', ' DataController.RowCount ');
//    Exit(True);
//  end;
//
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

function TClearConverter.GetCvtCompClassName: string;
const
  COMP_NAME = 'TcxGrid';
begin
  Result := COMP_NAME;
end;

function TClearConverter.GetDescription: string;
begin
  Result := 'TcxGrid .Clear 변환';
end;

initialization
  TConvertManager.Instance.Regist(TClearConverter);

end.

