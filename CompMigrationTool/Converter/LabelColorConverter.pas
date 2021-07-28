unit LabelColorConverter;

interface

uses
  CompConverterTypes,
  System.SysUtils, System.Classes,
  CompConverter;

type
  // TLabel의 Color 설정된 경우 Transparent = True 설정
  TConverterLabelColor = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;

    function GetDescription: string; override;
  end;

implementation

{ TConverterUpdateSQLConnection }

function TConverterLabelColor.FindComponentInDfm(
  AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasColor: Boolean;
begin
  while True do
  begin
    Result := inherited;
    if not Result then
      Break;

    HasColor := False;
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];
      if S.Contains(' Transparent =') then
      begin
        HasColor := False;
        Break;
      end;

      if S.Contains(' Color = ') then
        HasColor := True;
    end;
    if HasColor then
      Exit(True);
  end;

  Result := False;
end;

function TConverterLabelColor.GetComponentClassName: string;
begin
  Result := 'TLabel';
end;

function TConverterLabelColor.GetConvertCompClassName: string;
begin
  Result := 'TLabel';
end;

function TConverterLabelColor.GetConvertedCompText(
  ACompText: TStrings): string;
begin
  ACompText.Insert(ACompText.Count - 1, '  Transparent = False');
  Result := ACompText.Text;
end;

function TConverterLabelColor.GetDescription: string;
begin
  Result := 'Label.Color 설정';
end;

initialization
  TConvertManager.Instance.Regist(TConverterLabelColor);

end.
