unit FDQryDirectExecuteConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
{
  FieldDefs 제거
  StoreDefs = True 설정(IndexDef 사용을 위해 필요)
}
  TConverterFDQryDirectExecute = class(TConverter)
  protected
    function GetDescription: string; override;

    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;
  end;


implementation

{ TConverterRealGridToCXGrid }

function TConverterFDQryDirectExecute.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := inherited;

  if Result then
  begin
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];
      if S.Contains('ResourceOptions.DirectExecute = True') then
        Exit(False)
    end;
  end;
end;

function TConverterFDQryDirectExecute.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterFDQryDirectExecute.GetComponentClassName: string;
begin
  Result := 'TFDQuery';
end;

function TConverterFDQryDirectExecute.GetConvertCompClassName: string;
begin
  Result := 'TFDQuery';
end;

function TConverterFDQryDirectExecute.GetConvertedCompText(ACompText: TStrings): string;
var
  I, SIdx, EIdx: Integer;
  S: string;
begin
  ACompText.Insert(1, '    ResourceOptions.AssignedValues = [rvDirectExecute]'#13#10'    ResourceOptions.DirectExecute = True');

  Result := ACompText.Text;
end;

function TConverterFDQryDirectExecute.GetDescription: string;
begin
  Result := 'TFDQuery ResourceOptions.DirectExecute = True';
end;

function TConverterFDQryDirectExecute.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterFDQryDirectExecute);

end.

