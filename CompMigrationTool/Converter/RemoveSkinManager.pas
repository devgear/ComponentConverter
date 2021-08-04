unit RemoveSkinManager;

interface

uses
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRemoveSkinManager = class(TConverter)
  protected
    function GetDescription: string; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;
  end;


implementation

{ TConverterRealGridToCXGrid }

function TConverterRemoveSkinManager.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterRemoveSkinManager.GetComponentClassName: string;
begin
  Result := 'TsSkinManager';
end;

function TConverterRemoveSkinManager.GetConvertCompClassName: string;
begin
  Result := ''; // 제거
end;

function TConverterRemoveSkinManager.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
begin
  Result := True;
  Output := '';
end;

function TConverterRemoveSkinManager.GetDescription: string;
begin
  Result := 'TsSkinManager 제거';
end;

function TConverterRemoveSkinManager.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRemoveSkinManager);

end.

