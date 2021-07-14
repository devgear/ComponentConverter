unit ReplaceMemoFieldToStringFieldConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms,
  ConvertUtils;

type
{
  FieldDefs 제거
  StoreDefs = True 설정(IndexDef 사용을 위해 필요)
}
  TConverterMemoToStrField = class(TConverter)
  protected
    function GetDescription: string; override;

    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;
  public
    constructor Create;
  end;


implementation

{ TConverterRealGridToCXGrid }

constructor TConverterMemoToStrField.Create;
begin
end;

function TConverterMemoToStrField.FindComponentInDfm(AData: TConvertData): Boolean;
const
  TARGET_COMPS: array[0..1] of TTargetComp = (
    (FN: 'TbF_128P'; CN: 'Qry_MasterMemoField'),
    (FN: 'TbF_128P'; CN: 'Qry_DetailMemoField')
  );
var
  I: Integer;
  S: string;
  Target: TTargetComp;
begin
  Result := inherited;

  if not Result then
    Exit;

  for Target in TARGET_COMPS do
  begin
    if not AData.FileInfo.Filename.Contains(Target.FN) then
      Continue;

    if AData.CompName.ToLower = Target.CN.ToLower then
      Exit(True);
  end;

  Result := False;
end;

function TConverterMemoToStrField.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterMemoToStrField.GetComponentClassName: string;
begin
  Result := 'TMemoField';
end;

function TConverterMemoToStrField.GetConvertCompClassName: string;
begin
  Result := 'TStringField';
end;

function TConverterMemoToStrField.GetConvertedCompText(ACompText: TStrings): string;
var
  I, SIdx, EIdx: Integer;
  S: string;
begin
  // TMemoField > TStringField
  ACompText[0] := ACompText[0].Replace(GetComponentClassName, GetConvertCompClassName);
  for I := 1 to ACompText.Count - 1 do
  begin
    S := ACompText[I];
         if S.Contains('BlobType = ') then  ACompText[I] := ''
    else if S.Contains('Size = ') then      ACompText[I] := '';
  end;

  Result := ACompText.Text;
end;

function TConverterMemoToStrField.GetDescription: string;
begin
  Result := 'TMemoField > TStringField (선택적)전환';
end;

function TConverterMemoToStrField.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterMemoToStrField);

end.

