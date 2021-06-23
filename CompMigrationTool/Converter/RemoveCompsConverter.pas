unit RemoveCompsConverter;

interface

uses
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TBaseCompRemoveConverter = class(TConverter)
  protected
    function GetDescription: string; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;
  end;

  TfrxDesignerRemoveConv = class(TBaseCompRemoveConverter)
  protected
    function GetComponentClassName: string; override;
  end;

  TfrxXLSExportRemoveConv = class(TBaseCompRemoveConverter)
  protected
    function GetComponentClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
  end;

implementation

{ TConverterRealGridToCXGrid }

function TBaseCompRemoveConverter.GetComponentClassName: string;
begin
  Result := 'TConnectDialog';
end;

function TBaseCompRemoveConverter.GetConvertCompClassName: string;
begin
  Result := ''; // 제거
end;

function TBaseCompRemoveConverter.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := '';
end;

function TBaseCompRemoveConverter.GetDescription: string;
begin
  Result := GetComponentClassName + ' 제거';
end;

function TBaseCompRemoveConverter.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

{ TfrxDesignerRemoveConv }

function TfrxDesignerRemoveConv.GetComponentClassName: string;
begin
  Result := 'TfrxDesigner';
end;

{ TfrxXLSExportRemoveConv }

function TfrxXLSExportRemoveConv.GetComponentClassName: string;
begin
  Result := 'TfrxXLSExport';
end;

function TfrxXLSExportRemoveConv.GetRemoveUses: TArray<string>;
begin
  Result := ['frxExportXLS'];
end;

initialization
  TConvertManager.Instance.Regist(TfrxDesignerRemoveConv);
  TConvertManager.Instance.Regist(TfrxXLSExportRemoveConv);

end.

