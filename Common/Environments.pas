unit Environments;

interface

type
  TEnv = class
  private const
    INI_FILEPATH = 'env\env.ini';
  private
    class var FInstance: TEnv;
    function GetRootPath: string;
    procedure SetRootPath(const Value: string);
    function GetRecursively: Boolean;
    procedure SetRecursively(const Value: Boolean);
    function GetUseBackup: Boolean;
    procedure SetUseBackup(const Value: Boolean);
    function GetClassName: string;
    function GetPropertyName: string;
    procedure SetClassName(const Value: string);
    procedure SetPropertyName(const Value: string);
    function GetLogLevel: Integer;
    procedure SetLogLevel(const Value: Integer);
  public
    class function Instance: TEnv;
    class procedure ReleaseInstance;

    property RootPath: string read GetRootPath write SetRootPath;
    property Recursively: Boolean read GetRecursively write SetRecursively;
    property UseBackup: Boolean read GetUseBackup write SetUseBackup;

    property ClassName: string read GetClassName write SetClassName;
    property PropertyName: string read GetPropertyName write SetPropertyName;
    property LogLevel: Integer read GetLogLevel write SetLogLevel;
  end;

implementation

uses
  System.SysUtils, System.IniFiles, Vcl.Forms;

{ TEnv }

class function TEnv.Instance: TEnv;
begin
  if not Assigned(FInstance) then
     FInstance := Create;
   Result := FInstance;
end;

class procedure TEnv.ReleaseInstance;
begin
  if Assigned(FInstance) then
     FInstance.Free;
end;

function TEnv.GetClassName: string;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  Result := IniFile.ReadString('ExtractProp', 'ClassName', '');
  IniFile.Free;
end;

function TEnv.GetLogLevel: Integer;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  Result := IniFile.ReadInteger('base', 'LogLevel', 0);
  IniFile.Free;
end;

function TEnv.GetPropertyName: string;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  Result := IniFile.ReadString('ExtractProp', 'PropertyName', '');
  IniFile.Free;
end;

function TEnv.GetRecursively: Boolean;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  Result := IniFile.ReadBool('base', 'Recursively', True);
  IniFile.Free;
end;

function TEnv.GetRootPath: string;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  Result := IniFile.ReadString('base', 'RootPath', '');
  IniFile.Free;
end;

function TEnv.GetUseBackup: Boolean;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  Result := IniFile.ReadBool('base', 'UseBackup', True);
  IniFile.Free;
end;

procedure TEnv.SetClassName(const Value: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  IniFile.WriteString('ExtractProp', 'ClassName', Value);
  IniFile.Free;
end;

procedure TEnv.SetLogLevel(const Value: Integer);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  IniFile.WriteInteger('base', 'LogLevel', Value);
  IniFile.Free;
end;

procedure TEnv.SetPropertyName(const Value: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  IniFile.WriteString('ExtractProp', 'PropertyName', Value);
  IniFile.Free;
end;

procedure TEnv.SetRecursively(const Value: Boolean);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  IniFile.WriteBool('base', 'Recursively', Value);
  IniFile.Free;
end;

procedure TEnv.SetRootPath(const Value: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  IniFile.WriteString('base', 'RootPath', Value);
  IniFile.Free;
end;

procedure TEnv.SetUseBackup(const Value: Boolean);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + INI_FILEPATH);
  IniFile.WriteBool('base', 'UseBackup', Value);
  IniFile.Free;
end;

initialization

finalization
  TEnv.ReleaseInstance;

end.
