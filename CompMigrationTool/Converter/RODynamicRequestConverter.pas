unit RODynamicRequestConverter;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRODR = class(TConverter)
  protected
    // 컴포넌트 찾기
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;

    // 컴포넌트 변경
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
  end;

implementation

uses
  ObjectTextParser, ConvertUtils;

{ TConverterRODR }

{
  Params
    AData : 변환에 필요한 정보
      .SrcDfm : dfm 파일, TStringList(변환 수행 시 변경됨)
      .CompStartIndex : SrcDfm에서 해당 컴포넌트의 시작 라인
      .CompEndIndex : SrcDfm에서 해당 컴포넌트 종료 라인
}
function TConverterRODR.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := inherited;

  if Result then
  begin
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I].Trim;
      if S.StartsWith('Channel =') then
        Exit
      else if S.StartsWith('Message =') then
        Exit
      else if S.StartsWith('ServiceName =') then
        Exit
      else if S.StartsWith('OperationName =') then
        Exit
      ;
    end;

    Result := False;
  end;
end;

function TConverterRODR.GetConvertCompClassName: string;
begin
  Result := 'TRODynamicRequest';
end;

function TConverterRODR.GetTargetCompClassName: string;
begin
  Result := 'TRODynamicRequest';
end;

{
  컴포넌트 변환

  Params
    ACompText : 컴포넌트 Object Text(DFM) 문자열이 넘어오고,
                문자열을 변경하면 DFM의 Object Text가 치환됨
  Result
    변환 수행 여부
}
function TConverterRODR.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  I: Integer;
  S: string;
  Parser: TObjectTextParser;
  ServiceName, RemoteService: string;
  FoundRemoteService: Boolean;
begin
  Parser := TObjectTextParser.Create;
  Parser.Parse(ACompText.Text);

  for I := 1 to ACompText.Count - 2 do
  begin
    S := ACompText[I];

    if S.Contains(' Channel =') then
      ACompText[I] := ''
    else if S.Contains(' Message = ') then
      ACompText[I] := ''
    else if S.Contains(' OperationName = ') then
      ACompText[I] := S.Replace('OperationName =', 'MethodName =')


    else if S.Contains(' ServiceName =') then
    begin
      ServiceName := Parser.Properties.Values['ServiceName'];
      // ServiceName이 같은 TRORemoteService 찾기
      FoundRemoteService := FindCompWithPropInDfm(
                      FConvData.SrcDfm,
                      'TRORemoteService',                                 // 찾을 classname
                      Format('ServiceName = ''%s''', [ServiceName]),      // 찾을 속성
                      RemoteService);
      if not FoundRemoteService then
        RemoteService := ServiceName;

      ACompText[I] := GetIndent(S) + Format('RemoteService = %s', [RemoteService]);
    end;
  end;

  if not FoundRemoteService then
  begin
    const
      TAG_ROREMOTESERVICE = '' +
        '  object [[COMP_NAME]]: TRORemoteService'#13#10 +
        '    ServiceName = ''[[SERVICE_NAME]]'''#13#10 +
        '    Message = [[MESSAGE]]'#13#10 +
        '    Channel = [[CHANNEL]]'#13#10 +
        '    Left = 0'#13#10 +
        '    Top = 0'#13#10 +
        '  end'#13#10
      ;
    var CompText := TAG_ROREMOTESERVICE;

    CompText := CompText.Replace('[[COMP_NAME]]',     Parser.Properties.Values['ServiceName']);
    CompText := CompText.Replace('[[SERVICE_NAME]]',  Parser.Properties.Values['ServiceName']);
    CompText := CompText.Replace('[[MESSAGE]]',       Parser.Properties.Values['Message']);
    CompText := CompText.Replace('[[CHANNEL]]',       Parser.Properties.Values['Channel']);

    ACompText.Append(CompText);
  end;


  Parser.Free;

  Result := True;
end;

initialization
  TConvertManager.Instance.Regist(TConverterRODR);

end.
