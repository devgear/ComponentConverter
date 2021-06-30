unit UpdateSQLConnectionConv;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  // UpdateSQL�� Connecion ������ �����Ǿ� ��ȯ ��
    // UpdateSQL�� ����ϴ� FDQuery�� Connection(�Ǵ� ConnectionName)�� ã��
    // UpdateSQL�� ����
  TConverterUpdateSQLConnection = class(TConverter)
  private
    FParser: TObjectTextParser;
//    FConvData: TConvertData;
    FConnStr: string;
  protected
    // TFDUpdateSQL�� Connection(�Ǵ� ConnectionName)�� ���� ������Ʈ ���� ã��
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    // ������Ʈ �̸� ��� �� UpdateObject�� �ش� �̸��� ������ TFDQuery ã��
    // TFDQuery�� Connection �Ӽ��� TFDUpdateSQL�� ����
    function GetConvertedCompText(ACompText: TStrings): string; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ConvertUtils;

{ TConvertercxGrid }
{
  inherited PnlSkinSetting: TPanel
    Top = 97
    Width = 1065
    ExplicitTop = 97
    ExplicitWidth = 1065
  end
}
function TConverterUpdateSQLConnection.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  CompName: string;
  SIdx, EIdx: Integer;
  IsCorrect: Boolean;
begin
  Result := inherited;

  if Result then
  begin
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];

      if S.Contains('ConnectionName') or S.Contains('Connection') then
      begin
        Exit(False);
      end;
    end;
    CompName := GetNameFromObjectText(AData.SrcDfm[AData.CompStartIndex]);

    SIdx := 0;
    EIdx := 0;
    IsCorrect := False;
    while True do
    begin
      SIdx := GetCompStartIndex(AData.SrcDfm, EIdx+1, 'TFDQuery');
      if SIdx = -1 then
        Break;
      EIdx := GetCompEndIndex(AData.SrcDfm, SIdx+1);

      FConnStr := '';
      IsCorrect := False;
      for I := SIdx+1 to EIdx-1 do
      begin
        S := AData.SrcDfm[I];
        // UpdateObject = UpdateSQL_Record
        if S.Contains(Format('UpdateObject = %s', [CompName])) then
          IsCorrect := True;
        // Connection = DBKatasCommon2 / ConnectionName = 'DBKatasCommon2'
        if S.Contains('Connection =') or S.Contains('ConnectionName = ') then
          FConnStr := S;

        if IsCorrect and (FConnStr <> '') then
          Break;
      end;

      if IsCorrect then
        Break;
    end;

    Result := IsCorrect;
  end;
end;

function TConverterUpdateSQLConnection.GetComponentClassName: string;
begin
  Result := 'TFDUpdateSQL';
end;

function TConverterUpdateSQLConnection.GetConvertCompClassName: string;
begin
  Result := 'TFDUpdateSQL';
end;

function TConverterUpdateSQLConnection.GetConvertedCompText(ACompText: TStrings): string;
begin
  if FConnStr <> '' then
    ACompText.Insert(1, FConnStr);
  Result := ACompText.Text;
end;

function TConverterUpdateSQLConnection.GetDescription: string;
begin
  Result := 'FDUpdateSQL: Ŀ�ؼ� ����';
end;

function TConverterUpdateSQLConnection.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterUpdateSQLConnection);

end.
