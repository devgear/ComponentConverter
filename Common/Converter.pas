unit Converter;

interface

uses
  ConverterTypes;

type
  TConverter = class
  private
  protected
    // 컨버터 설명
    function GetCvtCompClassName: string; virtual; abstract; // 변환 대상 컴포넌트 클래스명
    function GetDescription: string; virtual;
    function ConvertSource(AProc, ASrc: string; var ADest: string): Boolean; virtual; abstract;
    function ConvertIntfSource(ASrc: string; var ADest: string): Boolean; virtual;
  public
    function Convert(AData: TConvertData): Integer; virtual;
    property Description: string read GetDescription;
  end;

implementation

{ TConverter }

function TConverter.Convert(AData: TConvertData): Integer;
begin
end;

function TConverter.ConvertIntfSource(ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
end;

function TConverter.GetDescription: string;
begin
  Result := '';
end;

end.
