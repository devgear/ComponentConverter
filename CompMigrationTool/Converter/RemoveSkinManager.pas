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
    function GetMainUsesUnit: string; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;
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

function TConverterRemoveSkinManager.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := '';
end;

function TConverterRemoveSkinManager.GetDescription: string;
begin
  Result := 'TsSkinManager 제거';
end;

function TConverterRemoveSkinManager.GetMainUsesUnit: string;
begin
  Result := '';
end;

function TConverterRemoveSkinManager.GetRemoveUses: TArray<string>;
begin
  Result := ['OdacVcl', 'Ora'];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRemoveSkinManager);

end.

