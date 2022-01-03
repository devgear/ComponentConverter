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
    FHasStoreDefs,
    FHasIndexDefs,
    FHasIndexName,
    FHasIndexFldNm: Boolean;
  protected
    function GetDescription: string; override;

    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;
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
    FHasIndexDefs := False;
    FHasIndexName := False;
    FHasIndexFldNm := False;

    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];

      // TFDMemTable FieldDefs 제거
      if (not FHasFieldDefs) and S.Contains('FieldDefs = <') and (not S.Contains('FieldDefs = <>')) then
        FHasFieldDefs := True;

      if (not FHasIndexDefs) and S.Contains('IndexDefs = <') and (not S.Contains('IndexDefs = <>')) then
        FHasIndexDefs := True;

      if (not FHasIndexName) and S.Contains('IndexName = ') then
        FHasIndexName := True;

      if (not FHasIndexFldNm) and S.Contains('IndexFieldNames = ') then
        FHasIndexFldNm := True;


      // StoreDefs = True
      if (not FHasStoreDefs)and S.Contains('StoreDefs = True') then
        FHasStoreDefs := True;
    end;
    if FHasFieldDefs or (not FHasStoreDefs) or (not FHasIndexDefs and FHasIndexName) then
      Exit(True);

    Exit(False);
  end;
end;

function TConverterkbmMemTable.GetAddedUses: TArray<string>;
begin
  Result := ['kbmMemTableHelper'];
end;

function TConverterkbmMemTable.GetTargetCompClassName: string;
begin
  Result := 'TFDMemTable';
end;

function TConverterkbmMemTable.GetConvertCompClassName: string;
begin
  Result := 'TFDMemTable';
end;

function TConverterkbmMemTable.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
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

      if (SIdx = -1) and S.Contains('FieldDefs = <') and (not S.Contains('FieldDefs = <>')) then
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

  if (not FHasIndexDefs and FHasIndexName) then
  begin
    for I := 0 to ACompText.Count - 1 do
    begin
      S := ACompText[I];

      if S.Contains('IndexName = ') then
        ACompText[I] := '';
    end;
  end;


  Result := True;
  Output := ACompText.Text;
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

