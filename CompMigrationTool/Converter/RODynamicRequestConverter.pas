unit RODynamicRequestConverter;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRODR = class(TConverter)
  protected
    // ������Ʈ ã��
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;

    // ������Ʈ ����
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
  end;

implementation

uses
  ObjectTextParser, ConvertUtils;

{ TConverterRODR }

{
  Params
    AData : ��ȯ�� �ʿ��� ����
      .SrcDfm : dfm ����, TStringList(��ȯ ���� �� �����)
      .CompStartIndex : SrcDfm���� �ش� ������Ʈ�� ���� ����
      .CompEndIndex : SrcDfm���� �ش� ������Ʈ ���� ����
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
  ������Ʈ ��ȯ

  Params
    ACompText : ������Ʈ Object Text(DFM) ���ڿ��� �Ѿ����,
                ���ڿ��� �����ϸ� DFM�� Object Text�� ġȯ��
  Result
    ��ȯ ���� ����
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
      // ServiceName�� ���� TRORemoteService ã��
      FoundRemoteService := FindCompWithPropInDfm(
                      FConvData.SrcDfm,
                      'TRORemoteService',                                 // ã�� classname
                      Format('ServiceName = ''%s''', [ServiceName]),      // ã�� �Ӽ�
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
