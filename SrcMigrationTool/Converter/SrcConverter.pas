unit SrcConverter;

interface

uses
  SrcConverterTypes,
  System.Classes, System.SysUtils, System.Generics.Collections,
  Vcl.Forms, Vcl.Controls;

const
//  GRIDNAME_REGEX = '('
//              +'[Rr]eal[Gg]rid\d+|rgd\_SuSun|RealGrid\_First|RGrid\_Sale|RGrid\_Save\d|RGrid\_Search'
//              + '|RGrid\_Style|RGrid\_Shop|RGrid\_ExpSty\d|RGrid\_Point|RGrid\_Template
//              + ')';

// baba
//  GRIDNAME_REGEX = '(' +
//    '(Pop02\_RGrid|RealGrid\_First)' +
//    '|([Rr]eal[Gg]rid\d+)' +
//    '|(rgd\_(Su[Ss]un(Search)?|Tel))' +
//    '|(RGrid\_('+
//        'ExpSty\d|Company|(Exp)?Style|(Hp)?History|Point|Pop01|Return|RevYn' +
//        '|Sale(Gubun)?|Save\d|sCompany|Search|Shop(Brand)?|(s)?Sty\d(_\d)?|Staff|Template|Trust)' +
//    ')' +
//    '|(RGrid\d+(_\d)?)' +
//  ')';

// ktbook
  GRIDNAME_REGEX = '(' +
    'RDBGrid[a-zA-Z\d_]+' +
    '|' +
    'RealDBGrid[a-zA-Z\d_]+' +
  ')';

  VIEWNAME_REGEX = '(SetRGrid|aRGrid|R1)';
  INDEX_REGEX = '\[[\w\(\)\[\]\+\-\*\.\s]+\]';

type
  TAssignType = (
    atWrite,        // 할당(:=) 기준 좌항
    atRead          // 할당(:=) 기준 우항, 조건 문 내 등
  );

  ImplAttribute = class(TCustomAttribute)
  end;

  IntfAttribute = class(TCustomAttribute)
  end;


  // 실제 전환 작업은 해당 클래스를 상속받아 구현한다.
  // protected의 virtual 메소드를 전환대상에 맞춰 재구현해야 한다.
  TConverter = class
  private
    function GetFilename: string;
  protected
    FConvData: TConvertData;
    // 컨버터 설명
    function GetCvtCompClassName: string; virtual; abstract; // 변환 대상 컴포넌트 클래스명
    function GetDescription: string; virtual;

    function ConvertSource(AProc, ASrc: string; var ADest: string): Integer; virtual;
    function ConvertIntfSource(ASrc: string; var ADest: string): Integer; virtual;

    function IsContainsRegEx(ASrc: string; ASearchPattern: string): Boolean;
    function IsContainsRegExCompName(ASrc: string; ASearchPattern: string; var CompName: string): Boolean;
    function TryRegExGridConvert(ASrc: string; ASearchPattern, AReplacePattern: string; var ADest: string): Boolean;

    property ConvData: TConvertData read FConvData;
    property SrcFilename: string read GetFilename;
  public
    function Convert(AData: TConvertData): Integer;
    property Description: string read GetDescription;
  end;

  TConverterClass = class of TConverter;
  TConvertManager = class
  private
    class var FInstance: TConvertManager;
  private
    FUniqueBackupFolderName: string;

    FConverterInstances: TList<TConverter>;
    FRootPath: string;
    FUseBackup: Boolean;

    function GetBackupFolderName: string; virtual;
    procedure RunBackup(AData: TFileInfo);
  public
    constructor Create;
    destructor Destroy; override;

    class function Instance: TConvertManager;
    class procedure ReleaseInstance;

    procedure Init;
    function RunConvert(AFileData: TFileInfo;
      AConverters: TArray<TConverter>): Integer;

    procedure Regist(AClass: TConverterClass);

    property UseBackup: Boolean read FUseBackup write FUseBackup;
    property RootPath: string read FRootPath write FRootPath;

    property ConvertInstance: TList<TConverter> read FConverterInstances;
  end;

implementation

uses
//  ConvertUtils,
  System.IOUtils, Logger, System.RegularExpressions,
  System.Rtti, System.TypInfo;

{ TConvertManager }

constructor TConvertManager.Create;
begin
  FUseBackup := False;

  FConverterInstances := TList<TConverter>.Create;
end;

destructor TConvertManager.Destroy;
begin
  FConverterInstances.Free;

  inherited;
end;

procedure TConvertManager.Init;
begin
  FUniqueBackupFolderName := '';
end;

class function TConvertManager.Instance: TConvertManager;
begin
  if not Assigned(FInstance) then
     FInstance := Create;
   Result := FInstance;
end;

class procedure TConvertManager.ReleaseInstance;
begin
  if Assigned(FInstance) then
     FInstance.Free;
end;

procedure TConvertManager.Regist(AClass: TConverterClass);
begin
  FConverterInstances.Add(AClass.Create)
end;

function TConvertManager.GetBackupFolderName: string;
begin
  if FUniqueBackupFolderName = '' then
    FUniqueBackupFolderName := FormatDateTime('YYYYMMDDHHNNSS', Now);;
  Result := 'backup\' + FUniqueBackupFolderName;
end;

procedure TConvertManager.RunBackup(AData: TFileInfo);
var
  BackupPath: string;
begin
  BackupPath := TPath.Combine(FRootPath, GetBackupFolderName);
  BackupPath := TPath.Combine(BackupPath, AData.Path);
  if not TDirectory.Exists(BackupPath) then
    TDirectory.CreateDirectory(BackupPath);

  BackupPath := TPath.Combine(BackupPath, AData.Filename);
  TFile.Copy(AData.GetFullpath(FRootPath), BackupPath);
end;

function TConvertManager.RunConvert(AFileData: TFileInfo;
      AConverters: TArray<TConverter>): Integer;
  function _InArray(AArray: TArray<TConverter>; AItem: TConverter): Boolean;
  var
    Conv: TConverter;
  begin
    Result := False;
    for Conv in AArray do
      if Conv = AItem then
        Exit(True);
  end;
var
  ConvData: TConvertData;
  Converter: TConverter;
begin
  Result := 0;

  ConvData := TConvertData.Create(AFileData);
  try
    ConvData.LoadFromFile(FRootPath);

    for Converter in FConverterInstances do
      if _InArray(AConverters, Converter) then
        Result := Result + Converter.Convert(ConvData);

    // backup
    if FUseBackup then
      RunBackup(AFileData);

    // Save
    if Result > 0 then
      ConvData.SaveToFile(FRootPath);
  finally
    ConvData.Free;
  end;
end;

{ TConverter }

function TConverter.ConvertSource(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Cnt: Integer;
  LCtx: TRttiContext;
  LType: TRttiType;
  LMethod: TRttiMethod;
  LAttr: TCustomAttribute;
  Args: TArray<TValue>;
begin
  Result := 0;

  LCtx := TRttiContext.Create;
  LType := LCtx.GetType(Self.ClassInfo);

  ADest := ASrc;
  for LMethod in LType.GetMethods do
  begin
    if LMethod.Name.StartsWith('Convert') then
    begin
      for LAttr in LMethod.GetAttributes do
      begin
        if LAttr is ImplAttribute then
        begin
          Args := TArray<TValue>.Create(AProc, ADest, ADest);

          Cnt := LMethod.Invoke(Self, Args).AsInteger;
          if Cnt > 0 then
            ADest := Args[2].AsString;
          Inc(Result, Cnt);
        end;
      end;
    end;
  end;
end;

function TConverter.ConvertIntfSource(ASrc: string; var ADest: string): Integer;
var
  Cnt: Integer;
  LCtx: TRttiContext;
  LType: TRttiType;
  LMethod: TRttiMethod;
  LAttr: TCustomAttribute;
  Args: TArray<TValue>;
begin
  Result := 0;

  LCtx := TRttiContext.Create;
  LType := LCtx.GetType(Self.ClassInfo);

  for LMethod in LType.GetMethods do
  begin
    if LMethod.Name.StartsWith('Convert') then
    begin
      for LAttr in LMethod.GetAttributes do
      begin
        if LAttr is IntfAttribute then
        begin
          Args := TArray<TValue>.Create('', ASrc, ADest);
          Cnt := LMethod.Invoke(Self, Args).AsInteger;
          Inc(Result, Cnt);

          ADest := Args[2].AsString;
        end;
      end;
    end;
  end;
end;

function TConverter.GetDescription: string;
begin
end;

function TConverter.GetFilename: string;
begin
  Result := FConvData.FileInfo.Filename;
end;

function TConverter.IsContainsRegEx(ASrc, ASearchPattern: string): Boolean;
var
  Matchs: TMatchCollection;
begin
  Result := False;
  Matchs := TRegEx.Matches(ASrc, ASearchPattern, [roIgnoreCase]);
  Result := Matchs.Count > 0;
end;

function TConverter.IsContainsRegExCompName(ASrc, ASearchPattern: string;
  var CompName: string): Boolean;
var
  Matchs: TMatchCollection;
begin
  Result := False;
  Matchs := TRegEx.Matches(ASrc, ASearchPattern, [roIgnoreCase]);
  Result := Matchs.Count > 0;

  if Result then
    CompName  := TRegEx.Match(ASrc, GRIDNAME_REGEX).Value.Replace('.', '').Trim;
end;

function TConverter.TryRegExGridConvert(ASrc, ASearchPattern,
  AReplacePattern: string; var ADest: string): Boolean;
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Idx: string;
  Src, Dest: string;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, ASearchPattern, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    if AReplacePattern.Contains('[[COMP_NAME]]') then
      Comp  := TRegEx.Match(Src, GRIDNAME_REGEX).Value.Replace('.', '').Trim;
    if AReplacePattern.Contains('[[INDEX]]') then
    begin
      Idx := TRegEx.Match(Src, INDEX_REGEX).Value.Trim;
      // 첫번째 [ 제거
      if Idx.StartsWith('[') then
        Idx := Idx.Substring(1);
      // 마지막 ] 제거(또는 ].)
      if Idx.EndsWith('].') then
        Idx := Idx.Substring(0, Idx.Length - 2);
      if Idx.EndsWith(']') then
        Idx := Idx.Substring(0, Idx.Length - 1);
    end;

    // 이미 변환된 TableView를 그리드로 인식하는 경우 제외
    if Comp.Contains('TableView') then
      Exit;

    Dest := AReplacePattern;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);
    Dest := Dest.Replace('[[INDEX]]',     Idx);

    ADest := ADest.Replace(Src, Dest);

    Result := True;
  end;
end;

function TConverter.Convert(AData: TConvertData): Integer;
var
  Src, Dest, CompTag, Converted, CompClassName: string;
  I, ImplIdx, Idx, Cnt: Integer;
  HasComp: Boolean;
  FProcName: string;
begin
  Result := 0;

  FConvData := AData;

  // 작업 대상 확인
  CompClassName := GetCvtCompClassName;
  if CompClassName <> '' then
  begin
    HasComp := False;
    CompTag := Format(': %s;', [CompClassName]);
    for I := 0 to AData.Source.Count - 1 do
    begin
      Src := AData.Source[I];

      if Src.Contains(CompTag) then
        HasComp := True;
    end;

    if not HasComp then
      Exit;
  end;

  for I := 0 to AData.Source.Count - 1 do
  begin
    Src := AData.Source[I].ToLower;
    // implementation 찾기
    if Src = 'implementation' then
    begin
      ImplIdx := I;
      Break;
    end;
  end;

  FProcName := '';
  for I := ImplIdx+1 to AData.Source.Count - 1 do
  begin
    Src := AData.Source[I];
    if Src.StartsWith('procedure ') or Src.StartsWith('function ') then
    begin
      Idx := Pos('.', Src);
      FProcName := Copy(Src, Idx+1, Pos('(', Src)-Idx-1);
    end;

    Cnt := ConvertSource(FProcName, Src, Dest);
    if Cnt > 0 then
    begin
      AData.Source[I] := Dest;

      TLogger.Log('[%s|%d]%s     >     %s', [AData.FileInfo.Filename, I+1, Src, Dest]);

      Inc(Result, Cnt);
    end;
  end;

  for I := 0 to ImplIdx-1 do
  begin
    Src := AData.Source[I];
    Cnt := ConvertIntfSource(Src, Dest);
    if Cnt > 0 then
    begin
      AData.Source[I] := Dest;

      TLogger.Log('[%s|%d]%s     >     %s', [AData.FileInfo.Filename, I+1, Src, Dest]);

      Inc(Result, Cnt);
    end;
  end;
end;

initialization

finalization
  TConvertManager.ReleaseInstance;

end.
