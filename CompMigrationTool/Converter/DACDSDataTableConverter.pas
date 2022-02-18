unit DACDSDataTableConverter;

interface
uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterDACDSDT = class(TConverter)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;

    // 컴포넌트 변경
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;

    // 소스(pas)에 들어갈 컴포넌트 정의 반환
    function GetConvertCompList(AMainCompName: string): string; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ObjectTextParser;

{ TConverterDACDSDT }

function TConverterDACDSDT.GetTargetCompClassName: string;
begin
  Result := 'TDACDSDataTable';
end;

function TConverterDACDSDT.GetConvertCompClassName: string;
begin
  Result := 'TDAMemDataTable';
end;

function TConverterDACDSDT.GetConvertCompList(AMainCompName: string): string;
begin
  Result := '';
  Result := Result + #13#10'    ' + AMainCompName + 'Adapter: TDARemoteDataAdapter;';
end;

function TConverterDACDSDT.GetConvertedCompStrs(
  var ACompText: TStrings): Boolean;
var
  I: Integer;
  S: string;
  AdapterCompStrs: TStringList;
  AdapterName: string;
  Parser: TObjectTextParser;
  InCopyTargetParams: Boolean;
  DataRequestCallParams, SchemaCallParams: string;
begin
  Parser := TObjectTextParser.Create;
  Parser.Parse(ACompText.Text);

  AdapterName := FConvData.CompName + 'Adapter';
  AdapterCompStrs := TStringList.Create;
  AdapterCompStrs.Add('  object ' + AdapterName + ': TDARemoteDataAdapter');

  InCopyTargetParams := False;
  for I := 1 to ACompText.Count - 2 do
  begin
    S := ACompText[I];

    if InCopyTargetParams then
    begin
      if S.Contains(' ParamType =') then
        AdapterCompStrs.Add(S.Replace('ParamType =', 'Flag ='))
      else
        AdapterCompStrs.Add(S);
      if (S.Trim = 'end>') or (S.Trim = '>') then
        InCopyTargetParams := False;
      ACompText[I] := '';
      Continue;
    end;

    if S.Trim = 'DataUpdateCall.Params = <>' then
      ACompText[I] := ''
    else if S.Trim = 'ScriptCall.Params = <>' then
      ACompText[I] := ''
    else if S.Trim = 'SchemaCall.Params = <>' then
      ACompText[I] := ''
    else if S.Trim = 'SchemaCall.Params = <' then
    begin
      ACompText[I] := '';
      InCopyTargetParams := True;
      AdapterCompStrs.Add('    GetSchemaCall.Params = <');
    end

    else if S.Trim = 'DataRequestCall.Params = <' then
    begin
      ACompText[I] := '';
      InCopyTargetParams := True;
      AdapterCompStrs.Add('    GetDataCall.Params = <');
    end
    else if S.Contains(' DataRequestCall.') then
    begin
      ACompText[I] := '';
      AdapterCompStrs.Add(S.Replace(' DataRequestCall.', ' GetDataCall.'));
    end


    else if S.Contains(' RemoteService = ') then
    begin
      ACompText[I] := '    RemoteDataAdapter = ' + AdapterName;
      AdapterCompStrs.Add(S);
    end
    else if S.Contains(' Adapter =') then
    begin
      ACompText[I] := '';
      AdapterCompStrs.Add(S.Replace(' Adapter =', ' DataStreamer ='));
    end
    ;
  end;

  AdapterCompStrs.Add('  end');
  ACompText.AddStrings(AdapterCompStrs);

  Parser.free;
  AdapterCompStrs.Free;

  Result := True;
end;

function TConverterDACDSDT.GetDescription: string;
begin
  Result := 'DACDSDataTable 변환';
end;

initialization
  TConvertManager.Instance.Regist(TConverterDACDSDT);

end.
