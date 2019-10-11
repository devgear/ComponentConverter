unit ConverterTypes;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  // DFM 파일 정보
  TFileInfo = class
  private
    FFilename: string;
    FPath: string;
  public
    property Filename: string read FFilename write FFilename;
    property Path: string read FPath write FPath;

    function GetFullpath(ARootPath: string): string;
  end;


implementation

{ TFileInfo }

function TFileInfo.GetFullpath(ARootpath: string): string;
begin
  Result := '';
  Result := TPath.Combine(ARootPath, FPath);
  Result := TPath.Combine(Result, FFilename);
end;

end.
