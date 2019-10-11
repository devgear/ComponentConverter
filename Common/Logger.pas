unit Logger;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  TLogLevel = (llInfo, llError);
  TLogger = class
  private const
    ROOT_DIR = '.\log\';
  private
    class var FInstance: TLogger;
    procedure WriteLog(ALog: string);
  private
    FLogLevel: TLogLevel;
    FFilename: string;
    FFilepath: string;
    FCategory: string;
    procedure SetFilename(const Value: string);
  public
    constructor Create;
    class function Instance: TLogger;
    class procedure ReleaseInstance;

    class procedure Log(ALog: string); overload;
    class procedure Log(AFormat: string; Args: array of const); overload;

    class procedure Error(ALog: string); overload;
    class procedure Error(AFormat: string; Args: array of const); overload;

    property Filename: string read FFilename write SetFilename;
    property Category: string read FCategory write FCategory;
    property LogLevel: TLogLevel read FLogLevel write FLogLevel;
  end;

implementation

{ TLogger }

constructor TLogger.Create;
begin
  FLogLevel := llInfo;
end;

class procedure TLogger.Error(AFormat: string; Args: array of const);
begin
  Error(Format(AFormat, Args));
end;

class procedure TLogger.Error(ALog: string);
begin
  Instance.WriteLog('[Err]' + ALog);
end;

class function TLogger.Instance: TLogger;
begin
  if not Assigned(FInstance) then
     FInstance := Create;
   Result := FInstance;
end;

class procedure TLogger.Log(ALog: string);
begin
  if Instance.LogLevel > llInfo then
    Exit;
  Instance.WriteLog(ALog);
end;

class procedure TLogger.Log(AFormat: string; Args: array of const);
begin
  if Instance.LogLevel > llInfo then
    Exit;

  Log(Format(AFormat, Args));
end;

class procedure TLogger.ReleaseInstance;
begin
  if Assigned(FInstance) then
     FInstance.Free;
end;

procedure TLogger.SetFilename(const Value: string);
begin
  FFilename := Value;
  FFilepath := ROOT_DIR;
  if FCategory <> '' then
    FFilepath := FFilepath + FCategory + '_';
  FFilepath := FFilepath + Value;
end;

procedure TLogger.WriteLog(ALog: string);
var
  Log: string;
begin
  if FFilepath = '' then
    SetFileName(FormatDateTime('YYYYMMDD_HHNNSS', Now) + '.log');

  Log := FormatDateTime('HH:NN:SS', Now) + ' ' + ALog + sLineBreak;

  TFile.AppendAllText(FFilepath, Log, TEncoding.Ansi);
end;

initialization

finalization
  TLogger .ReleaseInstance;

end.
