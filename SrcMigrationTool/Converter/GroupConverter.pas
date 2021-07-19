unit GroupConverter;

interface

uses
  SrcConverter;

type
  TGroupConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertBandsAdd(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertBandsClear(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGroups_Suffix(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertTitleVisible(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGroupsCount(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  System.StrUtils,
  SrcConvertUtils,
  System.Classes, System.SysUtils;

{ TSelectedConverter }

function TGroupConverter.ConvertBandsAdd(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups\.[Aa]dd';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Bands.Add';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGroupConverter.ConvertBandsClear(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups\.[Cc]lear';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Bands.Clear';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGroupConverter.ConvertGroupsCount(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups\.[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Bands.Count';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGroupConverter.ConvertGroups_Suffix(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups' + INDEX_REGEX + '\.';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Bands[[[INDEX]]].';
var
  HasKeyword: Boolean;
  Suffix: string;
  Suffixes: TArray<string>;
begin
  Result := 0;

  Suffixes := [
    'Caption',
    'Width',
    'Visible'
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

function TGroupConverter.ConvertTitleVisible(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups' + INDEX_REGEX + '\.[Tt]itle\.[Vv]isible';
begin
  Result := 0;
  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc;
    Inc(Result, AddComment(ADest, '].Title.Visible'));
  end;
end;

function TGroupConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TGroupConverter.GetDescription: string;
begin
  Result := '[Group] RG to cxGrid'
end;

initialization
  TConvertManager.Instance.Regist(TGroupConverter);
end.
