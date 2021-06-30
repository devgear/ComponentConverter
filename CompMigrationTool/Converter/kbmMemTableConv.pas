unit kbmMemTableConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
{
  FieldDefs 제거
  StoreDefs = True 설정(IndexDef 사용을 위해 필요)
}
  TConverterkbmMemTable = class(TConverter)
  private
    FHasFieldDefs,
    FHasStoreDefs: Boolean;
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

function TConverterkbmMemTable.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := inherited;

  if Result then
  begin
    FHasFieldDefs := False;
    FHasStoreDefs := False;
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];

      // TFDMemTable FieldDefs 제거
      if (not FHasFieldDefs) and S.Contains('FieldDefs = <') then
        FHasFieldDefs := True;

      // StoreDefs = True
      if (not FHasStoreDefs)and S.Contains('StoreDefs = True') then
        FHasStoreDefs := True;
    end;
    if FHasFieldDefs or (not FHasStoreDefs) then
      Exit(True);

    Exit(False);
  end;
end;

function TConverterkbmMemTable.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterkbmMemTable.GetComponentClassName: string;
begin
  Result := 'TFDMemTable';
end;

function TConverterkbmMemTable.GetConvertCompClassName: string;
begin
  Result := 'TFDMemTable';
end;

function TConverterkbmMemTable.GetConvertedCompText(ACompText: TStrings): string;
var
  I, SIdx, EIdx: Integer;
  S: string;
begin
  // TFDMemTable FieldDefs 제거
  if FHasFieldDefs then
  begin
    SIdx := -1;
    EIdx := -1;
    for I := 0 to ACompText.Count - 1 do
    begin
      S := ACompText[I];

      if (SIdx = -1) and S.Contains('FieldDefs = <') then
        SIdx := I
      else if (SIdx > -1) and S.Contains('>') then
      begin
        EIdx := I;
        Break;
      end;
    end;

    for I := EIdx downto SIdx do
      ACompText.Delete(I);
  end;

  // StoreDefs = True
  if not FHasStoreDefs then
    ACompText.Insert(1, 'StoreDefs = True');

  Result := ACompText.Text;
end;

function TConverterkbmMemTable.GetDescription: string;
begin
  Result := 'TkbmMemTable 관련 전환';
end;

function TConverterkbmMemTable.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterkbmMemTable);

end.

