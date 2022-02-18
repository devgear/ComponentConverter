unit DataSetConverter;

interface

uses
  SrcConverter;

type
  TFDQueryConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertParamByNameValue1(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertParamByNameValue2(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  System.Classes, System.SysUtils,
  SrcConvertUtils,
  SrcConverterTypes;

{ TDataSetConverter }

function TFDQueryConverter.ConvertParamByNameValue1(AProc, ASrc: string;
  var ADest: string): Integer;
// .ParamByName('*계산서*').AsString
// .ParamByName('*계산서*').AsInteger
  // .ParamByName('*계산서*').Value
const
  SEARCH_PATTERN  = '\.ParamByName\(''' + STRS_REGEX + '계산서' + STRS_REGEX + '''\)\.As';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc.Replace('AsString', 'Value').Replace('AsInteger', 'Value');
    Inc(Result);
  end;
end;

function TFDQueryConverter.ConvertParamByNameValue2(AProc, ASrc: string;
  var ADest: string): Integer;
// ParamByName('p접수*').AsString
const
  SEARCH_PATTERN  = '\.ParamByName\(''' + 'p접수' + STRS_REGEX + '''\)\.As';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc.Replace('AsString', 'Value').Replace('AsInteger', 'Value');
    Inc(Result);
  end;
end;

function TFDQueryConverter.GetCvtCompClassName: string;
begin
  Result := 'TFDQuery';
end;

function TFDQueryConverter.GetDescription: string;
begin
  Result := 'FDQuery 변환';
end;

initialization
  TConvertManager.Instance.Regist(TFDQueryConverter);

end.
