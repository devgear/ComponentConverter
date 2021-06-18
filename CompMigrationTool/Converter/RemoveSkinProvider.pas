unit RemoveSkinProvider;

interface

uses
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRemoveSkinProvider = class(TConverter)
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

function TConverterRemoveSkinProvider.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterRemoveSkinProvider.GetComponentClassName: string;
begin
  Result := 'TsSkinProvider';
end;

function TConverterRemoveSkinProvider.GetConvertCompClassName: string;
begin
  Result := ''; // 제거
end;

function TConverterRemoveSkinProvider.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := '';
end;

function TConverterRemoveSkinProvider.GetDescription: string;
begin
  Result := 'TsSkinProvider 제거';
end;

function TConverterRemoveSkinProvider.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterRemoveSkinProvider);

end.

