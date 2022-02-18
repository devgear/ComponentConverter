unit GroupConverter;

interface

uses
  SrcConverter;

type
  TGroupConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
    function GetCvtBaseClassName: string; override;
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
    function ConvertTitleHeight(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGroupsCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
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

function TGroupConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
  Keywords: TArray<string>;
begin
  Result := 0;
  ADest := ASrc;

  Datas.Add('Groups[0].Title.caption',   'Bands[0].Caption');

  // Á¦°Å
  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
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

function TGroupConverter.ConvertTitleHeight(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Gg]roups' + INDEX_REGEX + '\.[Tt]itle\.[Hh]eight';
begin
  Result := 0;
  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc;
    Inc(Result, AddComment(ADest, '].Title.Height'));
  end;
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

function TGroupConverter.GetCvtBaseClassName: string;
begin
  Result := 'TfrmTzzRealMaster2';
end;

function TGroupConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TGroupConverter.GetDescription: string;
begin
  Result := 'TcxGrid:Groups/Bands'
end;

initialization
  TConvertManager.Instance.Regist(TGroupConverter);
end.
