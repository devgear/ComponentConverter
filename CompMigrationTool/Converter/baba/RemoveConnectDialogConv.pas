unit RemoveConnectDialogConv;

interface

uses
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterOraSession2FDConn = class(TConverter)
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

function TConverterOraSession2FDConn.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterOraSession2FDConn.GetComponentClassName: string;
begin
  Result := 'TConnectDialog';
end;

function TConverterOraSession2FDConn.GetConvertCompClassName: string;
begin
  Result := ''; // 제거
end;

function TConverterOraSession2FDConn.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := '';
end;

function TConverterOraSession2FDConn.GetDescription: string;
begin
  Result := 'TConnectDialog 제거';
end;

function TConverterOraSession2FDConn.GetMainUsesUnit: string;
begin
  Result := '';
end;

function TConverterOraSession2FDConn.GetRemoveUses: TArray<string>;
begin
  Result := ['OdacVcl', 'Ora'];
end;

initialization
  TConvertManager.Instance.Regist(TConverterOraSession2FDConn);

end.
