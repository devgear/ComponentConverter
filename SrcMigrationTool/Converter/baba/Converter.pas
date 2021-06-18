unit Converter;

interface

uses
  ConverterTypes,
  System.Classes, System.SysUtils, System.Generics.Collections,
  Vcl.Forms, Vcl.Controls;

type
  // 실제 전환 작업은 해당 클래스를 상속받아 구현한다.
  // protected의 virtual 메소드를 전환대상에 맞춰 재구현해야 한다.
  TConverter = class
  private
    FIsInherited: Boolean;

    // DFM에서 변환 대상이 있는지 확인
      // 컴포넌트 소스 라인(AData.CompStartIndex, AData.CompEndIndex) 설정
    function FindComponentInDfm(AData: TConvertData): Boolean; virtual;
    // 원소스의 컴포넌트 코드를 변환된 컴포넌트 코드로 변경한다.
    procedure ReplaceComponentInDfm(AData: TConvertData);
    procedure InsertCompCodeToPas(ALineIdx: Integer; ASource: TStrings; ACompCode: string);
  protected
    // 컨버터 설명
    function GetDescription: string; virtual;

    // [상속필요] 상속한 클래스에서 처리할 컴포넌트 이름 반환
    function GetComponentClassName: string; virtual; abstract;
    function GetConvertCompClassName: string; virtual; abstract;
    function GetConvertCompList(AMainCompName: string): string; virtual;
    function GetRemoveUses: TArray<string>; virtual; abstract;
    function GetAddedUses: string; virtual;
    // 이미 uses절에 포함되었는지 확인하기 위한 Unit 이름제공
    function GetMainUsesUnit: string; virtual;

    // PAS 파일에 이벤트 코드 추가 여부(향후 Interface 처리 할 것)
    function IsWantWriteEvnetCodeToPas: Boolean; virtual;

    function GetConvertedCompText(ACompText: TStrings): string; virtual; abstract;

    function GetIntfCompCode: string; virtual;
    function GetImplCompCode(AFormClass: string): string; virtual;

    // [상속필요] 변환대상 컴포넌를 읽어 변경할 컴포넌트 소스코드로 변경한다.
    procedure ConvertDfm(AData: TConvertData); virtual;
    procedure ConvertPas(AData: TConvertData); virtual;
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
  ConvertUtils,
  System.IOUtils, ViewerForm;

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
  TFile.Copy(AData.GetDfmFullpath(FRootPath), BackupPath);

  BackupPath := Copy(BackupPath, 1, Length(BackupPath) - 3) + 'pas';
  TFile.Copy(AData.GetPasFullpath(FRootPath), BackupPath);
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
    ConvData.FormName := GetFormNameFromDfmText(ConvData.SrcDfm[0]);


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

function TConverter.FindComponentInDfm(AData: TConvertData): Boolean;
var
  CompClassName: string;
begin
  CompClassName := GetComponentClassName;

  Result := False;

  AData.CompStartIndex := GetCompStartIndex(AData.SrcDfm, AData.CompStartIndex+1, CompClassName);
  if AData.CompStartIndex <= 0 then
    Exit;

  AData.IsInherited := AData.SrcDfm[AData.CompStartIndex].Contains('inherited');

  AData.CompEndIndex := GetCompEndIndex(AData.SrcDfm, AData.CompStartIndex+1);
  AData.CompName := GetNameFromObjectText(AData.SrcDfm[AData.CompStartIndex]);

  Result := True;
end;

function TConverter.GetAddedUses: string;
begin
  Result := '';
end;

function TConverter.GetConvertCompList(AMainCompName: string): string;
begin
  Result := '';
end;

function TConverter.GetDescription: string;
begin
  Result := Format('%s to %s 변화', [GetComponentClassName, GetConvertCompClassName])
end;

function TConverter.GetImplCompCode(AFormClass: string): string;
begin
  Result := '';
end;

function TConverter.GetIntfCompCode: string;
begin
  Result := '';
end;

function TConverter.GetMainUsesUnit: string;
begin
  Result := '';
end;

procedure TConverter.InsertCompCodeToPas(ALineIdx: Integer; ASource: TStrings;
  ACompCode: string);
var
  I: Integer;
  Strs: TStringList;
begin
  Strs := TStringList.Create;
  try
    for I := 0 to ALineIdx - 1 do
      Strs.Add(ASource[I]);

    Strs.Add(ACompCode);

    for I := ALineIdx to ASource.Count - 1 do
      Strs.Add(ASource[I]);

    ASource.Assign(Strs);
  finally
    Strs.Free;
  end;
end;

function TConverter.IsWantWriteEvnetCodeToPas: Boolean;
begin
  Result := False;
end;

procedure TConverter.ConvertDfm(AData: TConvertData);
var
  I: Integer;
  Strs: TStringList;
begin
  // 상속받은 폼의 컴포넌트는 컴포넌트 클래스명만 변경
  // inherited RealGrid2: TRealGrid [31]
  if AData.IsInherited then
  begin
    AData.SrcDfm[AData.CompStartIndex] := AData.SrcDfm[AData.CompStartIndex].Replace(
        GetComponentClassName,
        GetConvertCompClassName);
    Exit;
  end;

  AData.ConvDfm.Clear;

  Strs := TStringList.Create;
  try
    for I := AData.CompStartIndex to AData.CompEndIndex do
      Strs.Add(AData.SrcDfm[I]);

    AData.ConvDfm.Text := GetConvertedCompText(Strs);

    ReplaceComponentInDfm(AData);
//    TfrmViewer.ShowData('Converted CompText', AData.ConvDfm.Text);
  finally
    Strs.Free;
  end;
end;

procedure TConverter.ReplaceComponentInDfm(AData: TConvertData);
var
  I: Integer;
  Strs: TStringList;
begin
  Strs := TStringList.Create;
  try
    for I := 0 to AData.CompStartIndex - 1 do
      Strs.Add(AData.SrcDfm[I]);

    Strs.AddStrings(AData.ConvDfm);

    for I := AData.CompEndIndex+1 to AData.SrcDfm.Count - 1 do
      Strs.Add(AData.SrcDfm[I]);

    AData.SrcDfm.Assign(Strs);
  finally
    Strs.Free;
  end;
end;

procedure TConverter.ConvertPas(AData: TConvertData);
var
  UsesIdx: TUsesIndex;

  function _GetCompFormat(ACompName, ACompClassName: string): string;
  begin
    Result := ACompName + ': ' + ACompClassName + ';';
  end;

  function IncludeUnitNameInUses(AUnitName: string): Boolean;
  var
    I: Integer;
    Line: string;
  begin
    if AUnitName = '' then
      Exit(False);

    Result := False;
    for I := UsesIdx.IntfUsesSIdx to UsesIdx.IntfUsesEIdx do
    begin
      Line := AData.SrcPas[I];
      if IsIncludeUnitNameInUses(AUnitName, Line) then
        Exit(True);
    end;
  end;

var
  RemoveUseList: TArray<string>;
  I, J: Integer;
  Text, CompClassName, ConvClassName: string;

  // 이벤트 선언
  FormDefIdx,               // 폼 정의 라인번호
  FormPrivateIdx: Integer;  // 이벤트 선언부 라인번호
  FormEndIdx: Integer;      // 마지막(end.) 라인번호
  IntfCompCode, ImplCompCode: string;
begin
  // uses 구간
  SearchUsesIndex(AData.SrcPas, UsesIdx);

  // 제거할 uses 목록
  RemoveUseList := GetRemoveUses;

  // interface uses절
  for I := UsesIdx.IntfUsesSIdx to UsesIdx.IntfUsesEIdx do
  begin
    Text := AData.SrcPas[I];
    for J := 0 to Length(RemoveUseList) - 1 do
      Text := RemoveUses(Text, RemoveUseList[J]);
    AData.SrcPas[I] := Text;
  end;

  // implimentation uses 절제거
  if UsesIdx.ImplUsesSIdx > -1 then
  begin
    for I := UsesIdx.ImplUsesSIdx to UsesIdx.ImplUsesEIdx do
    begin
      Text := AData.SrcPas[I];
      for J := 0 to Length(RemoveUseList) - 1 do
        Text := RemoveUses(Text, RemoveUseList[J]);
      AData.SrcPas[I] := Text;
    end;
  end;

  // 컴포넌트 클래스 이름 교체(라인번호가 변경 될 수 있음)
  CompClassName := GetComponentClassName;
  ConvClassName := GetConvertCompClassName;
  for I := UsesIdx.IntfUsesEIdx to UsesIdx.ImplIdx - 1 do
  begin
    Text := AData.SrcPas[I];
    if Text.Contains(_GetCompFormat(AData.CompName, CompClassName)) then
    begin
      // 컴포넌트 삭제
      if ConvClassName = '' then
      begin
       AData.SrcPas[I] := '';
      end
      else
      begin
        Text := Text.Replace(_GetCompFormat(AData.CompName, CompClassName), _GetCompFormat(AData.CompName, ConvClassName));
        Text := Text + GetConvertCompList(AData.CompName);
        AData.SrcPas[I] := Text;
      end;
    end;
  end;

  // uses 절 추가(라인번호가 변경 될 수 있음)
  if not IncludeUnitNameInUses(GetMainUsesUnit) then
  begin
    Text := AData.SrcPas[UsesIdx.IntfUsesEIdx];
    if Text.Contains(';') then
    begin
      Text := Text.Replace(';', GetAddedUses + ';');
      AData.SrcPas[UsesIdx.IntfUsesEIdx] := Text;
    end;
  end;

  // 이벤트 추가
  if IsWantWriteEvnetCodeToPas and (not AData.IsInherited) then
  begin
    for I := 3 to AData.SrcPas.Count - 1 do
    begin
      Text := AData.SrcPas[I];
      if Text.Contains(Format('%s = class(', [AData.FormName])) then
      begin
        FormDefIdx := I;
        Break;
      end;
    end;

    for I := FormDefIdx+1 to AData.SrcPas.Count do
    begin
      Text := AData.SrcPas[I].Trim;
      if Text = 'private' then
      begin
        FormPrivateIdx := I;
        Break;
      end;

      // 예외(private 구문을 지운경우)
      if (Text = 'public') or (Text = 'end;') then
      begin
        FormPrivateIdx := I;
        Break;
      end;
    end;

    for I := AData.SrcPas.Count - 1 downto 0 do
    begin
      Text := AData.SrcPas[I].Trim;
      if Text = 'end.' then
      begin
        FormEndIdx := I;
        Break;
      end;
    end;

    // 선언부
    IntfCompCode := GetIntfCompCode;
    if IntfCompCode <> '' then
      InsertCompCodeToPas(FormPrivateIdx, AData.SrcPas, IntfCompCode);

    // 구현부
    ImplCompCode := GetImplCompCode(AData.FormName);
    if ImplCompCode <> '' then
      InsertCompCodeToPas(FormEndIdx, AData.SrcPas, ImplCompCode);
  end;
end;

function TConverter.Convert(AData: TConvertData): Integer;
begin
  Result := 0;

  while FindComponentInDfm(AData) do
  begin
    ConvertDfm(AData);
    ConvertPas(AData);
    Inc(Result);
  end;
end;

initialization

finalization
  TConvertManager.ReleaseInstance;

end.
