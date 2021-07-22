unit SrcConvertUtils;

interface

uses
  System.Classes, System.SysUtils, System.RegularExpressions;

type
  TChangeData = record
    Filename,
    Source, Dest: string;
  end;

  TChangeDatas = TArray<TChangeData>;
  TChangeDatasHelper = record helper for TChangeDatas
  public
    procedure Add(ASource, ADest: string);
    procedure AddInFile(AFilename, ASource, ADest: string);
  end;

  TTargetSrc = record
    FN,
    SRC,
    DST: string;
  end;

  TConvUtils = class
    class function GetCompName(ASrc: string): string;
    class function GetIndex(ASrc: string): string;
    class function GetIndent(ASource: string): string;
  end;

function ReplaceKeyword(var AValue: string; ASource, ADest: string): Integer;
function ReplaceKeywords(const AFilename: string; var AValue: string; ADatas: TChangeDatas): Integer;

function RemoveKeyword(var AValue: string; AKeyword: string): Integer;

function AddTodo(var AValue: string; AKeyword: string; ATodo: string): Integer;
function AddComment(var AValue: string; AKeyword: string; ATodo: string = ''): Integer;
function AddComments(var AValue: string; AKeywords: TArray<string>): Integer;

function GetColorCode(ASource: string): string;
function GetColorToStyleName(AColor: string): string;

implementation

uses
  SrcConverterTypes;

{ TChangeDatasHelper }

procedure TChangeDatasHelper.Add(ASource, ADest: string);
var
  Data: TChangeData;
begin
  Data.Source := ASource;
  Data.Dest := ADest;
  Self := Self + [Data];
end;

procedure TChangeDatasHelper.AddInFile(AFilename, ASource, ADest: string);
var
  Data: TChangeData;
begin
  Data.Filename := AFilename;
  Data.Source := ASource;
  Data.Dest := ADest;
  Self := Self + [Data];
end;

function RemoveKeyword(var AValue: string; AKeyword: string): Integer;
begin
  Result := 0;
  if AValue.Contains(AKeyword) then
  begin
    AValue := '';
    Inc(Result);
  end;
end;

function ReplaceKeyword(var AValue: string; ASource, ADest: string): Integer;
begin
  Result := 0;
  if AValue.Contains(ASource) then
  begin
    AValue := AValue.Replace(ASource, ADest);
    Inc(Result);
  end;
end;

function ReplaceKeywords(const AFilename: string; var AValue: string; ADatas: TChangeDatas): Integer;
var
  Data: TChangeData;
begin
  Result := 0;
  for Data in ADatas do
    if (Data.Filename = '') or (AFilename.Contains(Data.Filename)) then
      Inc(Result, ReplaceKeyword(AValue, Data.Source, Data.Dest));
end;

function AddComment(var AValue: string; AKeyword: string; ATodo: string): Integer;
begin
  Result := 0;
  if AValue.Contains(AKeyword) and (not AValue.StartsWith('//')) then
  begin
    if ATodo = '' then
      AValue := '//(*mig*)' + AValue
    else
      AValue := '//(* TODO : ' + ATodo + ' *)' + AValue;
    Inc(Result);

  end;
end;

function AddTodo(var AValue: string; AKeyword: string; ATodo: string): Integer;
begin
  Result := 0;
  if AValue.Contains(AKeyword) and (not AValue.StartsWith('//')) then
  begin
    AValue := '(* TODO : ' + ATodo + ' *)' + AValue;
    Inc(Result);
  end;
end;

function AddComments(var AValue: string; AKeywords: TArray<string>): Integer;
var
  Keyword: string;
begin
  Result := 0;
  for Keyword in AKeywords do
    Inc(Result, AddComment(AValue, Keyword));
end;

function GetColorCode(ASource: string): string;
const
  COLOR_REGEX = '\$[\w]{8}';
begin
  Result := TRegEx.Match(ASource, COLOR_REGEX).Value;
end;

function GetColorToStyleName(AColor: string): string;
const
  COLOR_TO_STYLE: array[0..14] of array[0..1] of string = (
    ('8454143', 'cxStyle1'),
    ('8454016', 'cxStyle2'),
    ('12615935', 'cxStyle3'),
    ('16751515', 'cxStyle4'),
    ('clAqua', 'cxStyle5'),
    ('clInactiveCaptionText', 'cxStyle6'),
    ('clLime', 'cxStyle7'),
    ('clMoneyGreen', 'cxStyle8'),
    ('clSilver', 'cxStyle9'),
    ('clSkyBlue', 'cxStyle10'),
    ('clYellow', 'cxStyle11'),
    ('$0080FFFF', 'cxStyle1'),
    ('$0080FF80', 'cxStyle2'),
    ('$00C080FF', 'cxStyle3'),
    ('$00FF9B9B', 'cxStyle4')
  );
var
  I: Integer;
begin
  Result := 'nil';
  for I := 0 to Length(COLOR_TO_STYLE) - 1 do
    if COLOR_TO_STYLE[I][0] = AColor then
      Exit('dmDatabase.' + COLOR_TO_STYLE[I][1]);
end;

{ TConvUtils }

class function TConvUtils.GetCompName(ASrc: string): string;
begin
  Result := TRegEx.Match(ASrc, GRIDNAME_REGEX).Value.Replace('.', '').Trim;
end;

class function TConvUtils.GetIndent(ASource: string): string;
var
  I: Integer;
  C: string;
begin
  Result := '';
  for I := 1 to Length(ASource) do
    if ASource[I] <> ' ' then
      Exit
    else
      Result := Result + ' ';
end;

class function TConvUtils.GetIndex(ASrc: string): string;
var
  Idx: string;
begin
  Idx := TRegEx.Match(ASrc, INDEX_REGEX).Value.Trim;
  // 첫번째 [ 제거
  if Idx.StartsWith('[') then
    Idx := Idx.Substring(1);
  // 마지막 ] 제거(또는 ].)
  if Idx.EndsWith('].') then
    Idx := Idx.Substring(0, Idx.Length - 2);
  if Idx.EndsWith(']') then
    Idx := Idx.Substring(0, Idx.Length - 1);

  Result := Idx;
end;

end.
