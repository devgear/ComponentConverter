unit SrcConvertUtils;

interface

uses
    System.Classes, System.SysUtils;

type
  TChangeData = record
    Source, Dest: string;
  end;

  TChangeDatas = TArray<TChangeData>;
  TChangeDatasHelper = record helper for TChangeDatas
  public
    procedure Add(ASource, ADest: string);
  end;

function ReplaceKeyword(var AValue: string; ASource, ADest: string): Boolean;
function ReplaceKeywords(var AValue: string; ADatas: TChangeDatas): Boolean;

function AddTodo(var AValue: string; AKeyword: string; ATodo: string): Boolean;
function AddComment(var AValue: string; AKeyword: string; ATodo: string = ''): Boolean;
function AddComments(var AValue: string; AKeywords: TArray<string>): Boolean;

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


function ReplaceKeyword(var AValue: string; ASource, ADest: string): Boolean;
begin
  Result := False;
  if AValue.Contains(ASource) then
  begin
    AValue := AValue.Replace(ASource, ADest);
    Result := True;
  end;
end;

function ReplaceKeywords(var AValue: string; ADatas: TChangeDatas): Boolean;
var
  Data: TChangeData;
begin
  Result := False;
  for Data in ADatas do
    if ReplaceKeyword(AValue, Data.Source, Data.Dest) then
      Result := True;
end;

function AddComment(var AValue: string; AKeyword: string; ATodo: string): Boolean;
begin
  Result := False;
  if AValue.Contains(AKeyword) and (not AValue.StartsWith('//')) then
  begin
    if ATodo = '' then
      AValue := '//(*mig*)' + AValue
    else
      AValue := '//(* TODO : ' + ATodo + ' *)' + AValue;
    Result := True;

  end;
end;

function AddTodo(var AValue: string; AKeyword: string; ATodo: string): Boolean;
begin
  Result := False;
  if AValue.Contains(AKeyword) and (not AValue.StartsWith('//')) then
  begin
    AValue := '(* TODO : ' + ATodo + ' *)' + AValue;
    Result := True;

  end;
end;

function AddComments(var AValue: string; AKeywords: TArray<string>): Boolean;
var
  Keyword: string;
begin
  Result := False;
  for Keyword in AKeywords do
    if AddComment(AValue, Keyword) then
      Result := True;
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
