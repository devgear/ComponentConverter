unit RemoveSkinManager;

interface

uses
  CompConverterTypes, CompConverter,
  System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRemoveSkinManager = class(TRemoveConverter)
  protected
    function GetTargetCompClassName: string; override;
  end;

  TConverterRemoveSkinProvider = class(TRemoveConverter)
  protected
    function GetTargetCompClassName: string; override;
  end;

  TConverterRmPnlSkinSetting = class(TRemoveConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ConvertUtils;

{ TConverterRemoveSkinManager }

function TConverterRemoveSkinManager.GetTargetCompClassName: string;
begin
  Result := 'TsSkinManager';
end;

{ TConverterRemoveSkinProvider }

function TConverterRemoveSkinProvider.GetTargetCompClassName: string;
begin
  Result := 'TsSkinProvider';
end;

{ TConverterRmPnlSkinSetting }
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

  AData.CompStartIndex := GetCompStartIndexFromCompName(AData.SrcDfm, AData.CompStartIndex+1, CompName);
  if AData.CompStartIndex <= 0 then
    Exit;

  AData.IsInherited := AData.SrcDfm[AData.CompStartIndex].Contains('inherited');

  AData.CompEndIndex := GetCompEndIndex(AData.SrcDfm, AData.CompStartIndex+1);
  AData.CompName := GetNameFromObjectText(AData.SrcDfm[AData.CompStartIndex]);

  Result := True;
end;

function TConverterRmPnlSkinSetting.GetTargetCompClassName: string;
begin
  Result := 'TPanel';
end;

function TConverterRmPnlSkinSetting.GetDescription: string;
begin
  Result := 'PnlSkinSetting: TPanel Á¦°Å';
end;

//initialization
//  TConvertManager.Instance.Regist(TConverterRemoveSkinManager);
//  TConvertManager.Instance.Regist(TConverterRemoveSkinProvider);
//  TConvertManager.Instance.Regist(TConverterRmPnlSkinSetting);

end.

