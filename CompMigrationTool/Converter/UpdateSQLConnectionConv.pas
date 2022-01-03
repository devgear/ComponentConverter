unit UpdateSQLConnectionConv;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  // UpdateSQL에 Connecion 정보가 누락되어 전환 됨
    // UpdateSQL을 사용하는 FDQuery의 Connection(또는 ConnectionName)을 찾아
    // UpdateSQL에 설정
  TConverterUpdateSQLConnection = class(TConverter)
  private
    FConnStr: string;
  protected
    // TFDUpdateSQL에 Connection(또는 ConnectionName)이 없는 컴포넌트 정보 찾기
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    // 컴포넌트 이름 취득 후 UpdateObject에 해당 이름이 설정된 TFDQuery 찾기
    // TFDQuery의 Connection 속성을 TFDUpdateSQL에 복사
    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ConvertUtils;

{ TConverterUpdateSQLConnection }

function TConverterUpdateSQLConnection.GetDescription: string;
begin
  Result := 'FDUpdateSQL: 커넥션 설정';
end;

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

function TConverterUpdateSQLConnection.GetTargetCompClassName: string;
begin
  Result := 'TFDUpdateSQL';
end;

function TConverterUpdateSQLConnection.GetConvertCompClassName: string;
begin
  Result := 'TFDUpdateSQL';
end;

function TConverterUpdateSQLConnection.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
begin
  if FConnStr <> '' then
    ACompText.Insert(1, FConnStr);
  Result := True;
  Output := ACompText.Text;
end;

function TConverterUpdateSQLConnection.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterUpdateSQLConnection);

end.
