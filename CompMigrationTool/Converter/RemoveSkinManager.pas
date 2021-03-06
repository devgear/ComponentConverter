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
  Result := ''; // ����
end;

function TConverterRemoveSkinManager.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := '';
end;

function TConverterRemoveSkinManager.GetDescription: string;
begin
  Result := 'TsSkinManager ����';
end;

function TConverterRemoveSkinManager.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRemoveSkinManager);

end.

