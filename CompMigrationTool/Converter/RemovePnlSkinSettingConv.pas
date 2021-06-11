unit RemovePnlSkinSettingConv;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRmPnlSkinSetting = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetConvertedCompText(ACompText: TStrings): string; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ConvertUtils;

{ TConvertercxGrid }
{
  inherited PnlSkinSetting: TPanel
    Top = 97
    Width = 1065
    ExplicitTop = 97
    ExplicitWidth = 1065
  end
}
function TConverterRmPnlSkinSetting.FindComponentInDfm(AData: TConvertData): Boolean;
var
  CompName: string;
begin
  CompName := 'PnlSkinSetting';

  Result := False;

  AData.CompStartIndex := GetCompStartIndexFromCompNamee(AData.SrcDfm, AData.CompStartIndex+1, CompName);
  if AData.CompStartIndex <= 0 then
    Exit;

  AData.IsInherited := AData.SrcDfm[AData.CompStartIndex].Contains('inherited');

  AData.CompEndIndex := GetCompEndIndex(AData.SrcDfm, AData.CompStartIndex+1);
  AData.CompName := GetNameFromObjectText(AData.SrcDfm[AData.CompStartIndex]);

  Result := True;
end;

function TConverterRmPnlSkinSetting.GetComponentClassName: string;
begin
  Result := 'TPanel';
end;

function TConverterRmPnlSkinSetting.GetConvertCompClassName: string;
begin
  Result := '';
end;

function TConverterRmPnlSkinSetting.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := '';
end;

function TConverterRmPnlSkinSetting.GetDescription: string;
begin
  Result := 'PnlSkinSetting: TPanel Á¦°Å';
end;

function TConverterRmPnlSkinSetting.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRmPnlSkinSetting);

end.
