unit cxDateEditConverter;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConvertercxDateEdit = class(TConverter)
  private
    FParser: TObjectTextParser;
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetConvertedCompText(ACompText: TStrings): string; override;

    destructor Destroy; override;
  end;

implementation

{ TConvertercxDateEdit }

destructor TConvertercxDateEdit.Destroy;
begin
  if Assigned(FParser) then
    FParser.Free;

  inherited;
end;

function TConvertercxDateEdit.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasDisplayFormat, HasEditFormat: Boolean;
begin
  Result := inherited;

  if Result then
  begin
    HasDisplayFormat := False;
    HasEditFormat := False;
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];

      if S.Contains('Properties.DisplayFormat = ') then
        HasDisplayFormat := True;

      if S.Contains('Properties.EditFormat = ') then
        HasEditFormat := True;
    end;

    if HasDisplayFormat and HasEditFormat then
      Exit(False);
  end;
end;

function TConvertercxDateEdit.GetComponentClassName: string;
begin
  Result := 'TcxDateEdit';
end;

function TConvertercxDateEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxDateEdit';
end;

function TConvertercxDateEdit.GetConvertedCompText(ACompText: TStrings): string;
var
  I: Integer;
  S: string;
  HasDisplayFormat, HasEditFormat: Boolean;
begin
  HasDisplayFormat := False;
  HasEditFormat := False;
  for I := 0 to ACompText.Count - 1 do
  begin
    S := ACompText[I];

    if S.Contains('Properties.DisplayFormat = ') then
      HasDisplayFormat := True;

    if S.Contains('Properties.EditFormat = ') then
      HasEditFormat := True;
  end;

  if not HasDisplayFormat then
    ACompText.Insert(ACompText.Count-1, '  Properties.DisplayFormat = ''YYYY-MM-DD''');
  if not HasEditFormat then
    ACompText.Insert(ACompText.Count-1, '  Properties.EditFormat = ''YYYY-MM-DD''');

  Result := ACompText.Text;
end;

function TConvertercxDateEdit.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConvertercxDateEdit);

end.
