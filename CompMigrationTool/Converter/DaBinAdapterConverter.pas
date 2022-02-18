unit DaBinAdapterConverter;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterDABA = class(TConverter)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;

    // 컴포넌트 변경
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ObjectTextParser, ConvertUtils;

{ TConverterRODR }


function TConverterDABA.GetConvertCompClassName: string;
begin
  Result := 'TDABin2DataStreamer';
end;

function TConverterDABA.GetTargetCompClassName: string;
begin
  Result := 'TDABINAdapter';
end;

function TConverterDABA.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
begin

  Result := True;
end;

function TConverterDABA.GetDescription: string;
begin
  Result := 'DaBinAdapter 변환';
end;

initialization
  TConvertManager.Instance.Regist(TConverterDABA);

end.
