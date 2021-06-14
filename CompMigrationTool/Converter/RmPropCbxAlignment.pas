unit RmPropCbxAlignment;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRmPropCbxAlignment = class(TConverter)
  private
    FParser: TObjectTextParser;
  protected
    function GetDescription: string; override;

    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetConvertedCompText(ACompText: TStrings): string; override;

    destructor Destroy; override;
  end;

implementation

{ TConvertercxDateEdit }

function TConverterRmPropCbxAlignment.GetDescription: string;
begin
  Result := 'TComboBox.Alignment 속성 제거';
end;

destructor TConverterRmPropCbxAlignment.Destroy;
begin
  if Assigned(FParser) then
    FParser.Free;

  inherited;
end;

function TConverterRmPropCbxAlignment.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := inherited;

  // TComboBox에 Alignment 속성을 갖는 경우만
  if Result then
  begin
    Result := False;
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];

      if S.Contains('Alignment = ') then
        Exit(True);
    end;
  end;
end;

function TConverterRmPropCbxAlignment.GetComponentClassName: string;
begin
  Result := 'TComboBox';
end;

function TConverterRmPropCbxAlignment.GetConvertCompClassName: string;
begin
  Result := 'TComboBox';
end;

function TConverterRmPropCbxAlignment.GetConvertedCompText(ACompText: TStrings): string;
var
  I: Integer;
  S: string;
begin
  for I := 0 to ACompText.Count - 1 do
  begin
    S := ACompText[I];

    if S.Contains('Alignment = ') then
      ACompText[I] := '';
  end;

  Result := ACompText.Text;
end;

function TConverterRmPropCbxAlignment.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRmPropCbxAlignment);

end.

