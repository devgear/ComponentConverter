unit RemoveCompsConverter;

interface

uses
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TfrxDesignerRemoveConv = class(TRemoveConverter)
  protected
    function GetTargetCompClassName: string; override;
  end;

  TfrxXLSExportRemoveConv = class(TRemoveConverter)
  protected
    function GetTargetCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
  end;

implementation

{ TfrxDesignerRemoveConv }

function TfrxDesignerRemoveConv.GetTargetCompClassName: string;
begin
  Result := 'TfrxDesigner';
end;

{ TfrxXLSExportRemoveConv }

function TfrxXLSExportRemoveConv.GetTargetCompClassName: string;
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

