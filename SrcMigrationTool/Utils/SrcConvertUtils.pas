unit SrcConvertUtils;

interface

uses
    System.Classes, System.SysUtils;

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

function ReplaceKeyword(var AValue: string; ASource, ADest: string): Integer;
function ReplaceKeywords(const AFilename: string; var AValue: string; ADatas: TChangeDatas): Integer;

function RemoveKeyword(var AValue: string; AKeyword: string): Integer;

function AddTodo(var AValue: string; AKeyword: string; ATodo: string): Integer;
function AddComment(var AValue: string; AKeyword: string; ATodo: string = ''): Integer;
function AddComments(var AValue: string; AKeywords: TArray<string>): Integer;

function GetIndent(ASource: string): string;

implementation


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

function GetIndent(ASource: string): string;
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

end.
