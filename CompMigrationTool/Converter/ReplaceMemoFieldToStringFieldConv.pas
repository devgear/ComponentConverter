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

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;
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
  TARGET_COMPS: array[0..13] of TTargetComp = (
      (FN: 'TbF_128P';            CN: 'Qry_MasterMemoField')
    , (FN: 'TbF_128P';            CN: 'Qry_DetailMemoField')
    , (FN: 'TbF_4409P';           CN: 'Qry_HomeTaxMemoField')
    , (FN: 'TbF_4409P';           CN: 'Qry_HomeTaxMemoField2')
    , (FN: 'TsF_OderAndOutP';     CN: 'Qry_MasterMemoField')
    , (FN: 'TsF_Banpum_KumsuPI';  CN: 'qry_MasterMemoField')
    , (FN: 'TsF_Banpum_KumsuPI';  CN: 'qry_Master_')
    , (FN: 'TaF_771P';            CN: 'Qry_ChangeMemoField')
    , (FN: 'TaF_772P';            CN: 'Qry_ChangeMemoField')
    , (FN: 'TaF_773P';            CN: 'Qry_ChangeMemoField')
    , (FN: 'TaF_774P';            CN: 'Qry_ChangeMemoField')
    , (FN: 'TaF_775P';            CN: 'Qry_ChangeMemoField')
    , (FN: 'TaF_776P';            CN: 'Qry_ChangeMemoField')
    , (FN: 'TaF_757P';            CN: 'Qry_ChangeMemoField')
  );
var
  Target: TTargetComp;
begin
  Result := inherited;

  if not Result then
    Exit;

  for Target in TARGET_COMPS do
  begin
    if not AData.DfmFileData.Filename.Contains(Target.FN) then
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

function TConverterMemoToStrField.GetTargetCompClassName: string;
begin
  Result := 'TMemoField';
end;

function TConverterMemoToStrField.GetConvertCompClassName: string;
begin
  Result := 'TStringField';
end;

function TConverterMemoToStrField.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
var
  I: Integer;
  S: string;
begin
  // TMemoField > TStringField
  ACompText[0] := ACompText[0].Replace(GetTargetCompClassName, GetConvertCompClassName);
  for I := 1 to ACompText.Count - 1 do
  begin
    S := ACompText[I];
         if S.Contains('BlobType = ') then  ACompText[I] := ''
    else if S.Contains('Size = ') then      ACompText[I] := '';
  end;

  Result := True;
  Output := ACompText.Text;
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

