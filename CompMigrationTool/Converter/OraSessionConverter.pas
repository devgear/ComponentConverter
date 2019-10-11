unit OraSessionConverter;

interface

uses
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterOraSession2FDConn = class(TConverter)
  private
    FColumnCompList: string;
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;
    function GetMainUsesUnit: string; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;
  end;


implementation

{ TConverterRealGridToCXGrid }

uses ObjectTextParser, ODACTagDefine;

function TConverterOraSession2FDConn.GetComponentClassName: string;
begin
  Result := 'TOraSession';
end;

function TConverterOraSession2FDConn.GetConvertCompClassName: string;
begin
  Result := 'TFDConnection';
end;

function TConverterOraSession2FDConn.GetMainUsesUnit: string;
begin
  Result := 'FireDAC.Stan.Intf';
end;

function TConverterOraSession2FDConn.GetAddedUses: TArray<string>;
begin
  Result := [
    'FireDAC.Stan.Intf', 'FireDAC.Stan.Option', 'FireDAC.Stan.Error',
    'FireDAC.UI.Intf', 'FireDAC.Phys.Intf', 'FireDAC.Stan.Def',
    'FireDAC.Stan.Pool', 'FireDAC.Stan.Async', 'FireDAC.Phys',
    'FireDAC.Comp.Client', 'FireDAC.DBX.Migrate'
  ];
end;

function TConverterOraSession2FDConn.GetRemoveUses: TArray<string>;
begin
  Result := ['OdacVcl', 'Ora'];
end;

function TConverterOraSession2FDConn.GetConvertedCompText(ACompText: TStrings): string;
var
  Idx: Integer;
  Parser: TObjectTextParser;
begin
  Parser := TObjectTextParser.Create;
  Parser.Parse(ACompText.Text);

  Result := TAG_FDCONNECTION;
  Result := Result.Replace('[[COMP_NAME]]',   Parser.CompName);
  Result := Result.Replace('[[CHARSET]]',     Parser.Properties.Values['Options.Charset']);
  Result := Result.Replace('[[USERNAME]]',    Parser.Properties.Values['Username']);
  Result := Result.Replace('[[PASSWORD]]',    Parser.Properties.Values['Password']);
  Result := Result.Replace('[[DATABASE]]',    Parser.Properties.Values['Server']);
  Result := Result.Replace('[[LEFT]]',        Parser.Properties.Values['Left']);
  Result := Result.Replace('[[TOP]]',         Parser.Properties.Values['Top']);

  Parser.Free;
end;

initialization
  TConvertManager.Instance.Regist(TConverterOraSession2FDConn);

end.
