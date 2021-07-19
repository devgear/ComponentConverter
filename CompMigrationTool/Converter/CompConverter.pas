unit CompConverter;

interface

uses
  CompConverterTypes,
  System.Classes, System.SysUtils, System.Generics.Collections,
  Vcl.Forms, Vcl.Controls;

type
  TCompEventInfo = record
    EventName,
    IntfCode,
    ImplCode,
    BeforeEventName: string;
  end;

  TConverterClass = class of TConverter;
  // 실제 전환 작업은 해당 클래스를 상속받아 구현한다.
  // protected의 virtual 메소드를 전환대상에 맞춰 재구현해야 한다.
  TConverter = class
  private
    // DFM에서 변환 대상이 있는지 확인
      // 컴포넌트 소스 라인(AData.CompStartIndex, AData.CompEndIndex) 설정
    // 원소스의 컴포넌트 코드를 변환된 컴포넌트 코드로 변경한다.
    procedure ReplaceComponentInDfm(AData: TConvertData);
    procedure InsertCompCodeToPas(AInsertLine: Integer; ASource: TStrings; ACompCode: string);
  protected
    // DFM 파일에서 변환할 컴포넌트 탐색(반복 변환 방지 코드 재구현 필요)
    function FindComponentInDfm(AData: TConvertData): Boolean; virtual;
    // 변환기 설명
    function GetDescription: string; virtual;

    // [상속필요] 상속한 클래스에서 처리할 컴포넌트 이름 반환
    //  변환 대상 컴포넌트 클래스 이름(예: TRealGrid)
    function GetComponentClassName: string; virtual; abstract;
    //  변환할 컴포넌트 클래스 이름(예: TcxGrid)
    function GetConvertCompClassName: string; virtual; abstract;
    //  하나의 컴포넌트를 여러개의 컴포넌트로 변환 시 추가 컴포넌트 내용
    function GetConvertCompList(AMainCompName: string): string; virtual;
    //  제거할 Uses 구문
    function GetRemoveUses: TArray<string>; virtual; abstract;
    //  추가할 Uses 구문
    function GetAddedUses: TArray<string>; virtual;

    // PAS 파일에 이벤트 코드 추가 여부(향후 Interface 처리 할 것)
    function IsWantWriteEvnetCodeToPas: Boolean; virtual;

    // 변환된 컴포넌트 문자열 반환
    function GetConvertedCompText(ACompText: TStrings): string; virtual;
    function GetConvertedCompStrs(ACompText: TStrings): TStrings; virtual;

    // 컴포넌트 이벤트코드 정보/변환정보 반환
    function GetCompEventInfos(AFormClass: string): TArray<TCompEventInfo>; virtual;

    // 변환대상 컴포넌를 읽어 변경할 컴포넌트 소스코드로 변경한다.
    procedure ConvertDfm(AData: TConvertData); virtual;
    procedure ConvertPas(AData: TConvertData); virtual;
  public
    function Convert(AData: TConvertData): Integer;
    property Description: string read GetDescription;
  end;

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
  System.IOUtils, ViewerForm, Logger;

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
  I, W, H: Integer;
  S, SW, SH: string;
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
    if (Result > 0) then
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

function TConverter.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverter.GetCompEventInfos(AFormClass: string): TArray<TCompEventInfo>;
begin
  Result := [];
end;

function TConverter.GetConvertCompList(AMainCompName: string): string;
begin
  Result := '';
end;

function TConverter.GetConvertedCompStrs(ACompText: TStrings): TStrings;
begin
  Result := ACompText;
end;

function TConverter.GetConvertedCompText(ACompText: TStrings): string;
begin
  Result := GetConvertedCompStrs(ACompText).Text;
end;

function TConverter.GetDescription: string;
begin
  Result := Format('%s to %s 변화', [GetComponentClassName, GetConvertCompClassName])
end;

procedure TConverter.InsertCompCodeToPas(AInsertLine: Integer; ASource: TStrings; ACompCode: string);
var
  I: Integer;
  Strs: TStringList;
begin
  Strs := TStringList.Create;
  try
    for I := 0 to AInsertLine - 1 do
      Strs.Add(ASource[I]);

    Strs.Add(ACompCode);

    for I := AInsertLine to ASource.Count - 1 do
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
  // 상속받은 폼의 컴포넌트는 컴포넌트 클래스명만 변경, 제거인 경우 제외
  // inherited RealGrid2: TRealGrid [31]
  if AData.IsInherited and (GetConvertCompClassName <> '') then
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

    TLogger.Log(Format('[DFM] Org: %s'#13#10'Converted: %s', [Strs.Text, AData.ConvDfm.Text]));

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
    // 컴포넌트 시작 전 내용 복사
    for I := 0 to AData.CompStartIndex - 1 do
      Strs.Add(AData.SrcDfm[I]);

    Strs.AddStrings(AData.ConvDfm);

    // 컴포넌트 이후 내용 복사
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
    for I := UsesIdx.InterfaceUsesStartIndex to UsesIdx.InterfaceUsesEndIndex do
    begin
      Line := AData.SrcPas[I];
      if IsIncludeUnitNameInUses(AUnitName, Line) then
        Exit(True);
    end;

    for I := UsesIdx.ImplimentationUsesStartIndex to UsesIdx.ImplimentationUsesEndIndex do
    begin
      Line := AData.SrcPas[I];
      if IsIncludeUnitNameInUses(AUnitName, Line) then
        Exit(True);
    end;
  end;

  function GetUnitEndIdx: Integer;
  var
    I: Integer;
    Text: string;
  begin
    Result := AData.SrcPas.Count - 1;
    for I := AData.SrcPas.Count - 1 downto 0 do
    begin
      Text := AData.SrcPas[I].Trim;
      if (Text = 'end.') or (Text = 'initialization') then
      begin
        Result := I;
      end;

      if (Text = 'end;') then
      begin
        Break;
      end;
    end;
  end;

var
  RemoveUseList: TArray<string>;
  I, J, Idx: Integer;
  Text, CompName, CompClassName, ConvClassName: string;
//  IntfCompCode, ImplCompCode: string;
  Use: string;
  Count: Integer;
  AddUses: TArray<string>;

  // 이벤트 선언
  CompDefStart,             // 컴포넌트 정의부 시작(Form 선언)
  CompDefEnd: Integer;      // 컴포넌트 정의부 끝(private 이전)
  CompEventStart,           // 이벤트 시작 라인
  CompEventEnd: Integer;    // 이벤트 끝 라인
  UnitEndIdx: Integer;      // 마지막(end.) 라인번호

  // 이벤트 추가
  CompCodeInfos: TArray<TCompEventInfo>;
  CompCodeInfo: TCompEventInfo;
  Code: string;
begin
  // uses 구간 탐색
  SearchUsesIndex(AData.SrcPas, UsesIdx);

  // 제거할 uses 목록
  RemoveUseList := GetRemoveUses;

  // interface uses절 제거
  for I := UsesIdx.InterfaceUsesStartIndex to UsesIdx.InterfaceUsesEndIndex do
  begin
    Text := AData.SrcPas[I];
    for J := 0 to Length(RemoveUseList) - 1 do
      Text := RemoveUses(Text, RemoveUseList[J]);
    AData.SrcPas[I] := Text;
  end;

  // implimentation uses 절 제거
  if UsesIdx.ImplimentationUsesStartIndex > -1 then
  begin
    for I := UsesIdx.ImplimentationUsesStartIndex to UsesIdx.ImplimentationUsesEndIndex do
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
  for I := UsesIdx.InterfaceUsesEndIndex to UsesIdx.ImplimentationIndex - 1 do
  begin
    Text := AData.SrcPas[I];
//    if Text.Contains(_GetCompFormat(AData.CompName, CompClassName)) then
    if IsEqualsCompCode(AData.CompName, CompClassName, Text) then
    begin
      if not Text.Contains(AData.CompName) then
        Text := '    ' + _GetCompFormat(AData.CompName, CompClassName);
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

  // uses 절 추가
  SearchUsesIndex(AData.SrcPas, UsesIdx);
  AddUses := GetAddedUses;
  Count := 0;
  for Use in AddUses do
  begin
    if Use.Trim = '' then
      Continue;
    if not IncludeUnitNameInUses(Use) then
    begin
      Text := AData.SrcPas[UsesIdx.InterfaceUsesEndIndex];
      if Count mod 5 = 0 then
        Text := Text.Replace(';', #13#10'  ;');

      Text := Text.Replace(';', ', ' + Use + ';');
      AData.SrcPas[UsesIdx.InterfaceUsesEndIndex] := Text;
      Inc(Count);
    end;
  end;

  // 이벤트 추가
  CompCodeInfos := GetCompEventInfos(AData.FormName);
  if (Length(CompCodeInfos) > 0) and (not AData.IsInherited) then
  begin
    // [선언부] 컴포넌트 선언부 시작(폼 시작) 라인 추출
    for I := 3 to AData.SrcPas.Count - 1 do
    begin
      Text := AData.SrcPas[I];
      if Text.Contains(Format('%s = class(', [AData.FormName])) then
      begin
        CompDefStart := I;  // TForm1 = class(
        Break;
      end;
    end;

    // [선언부] 컴포넌트 선언부 끝 라인 추출(private 시작)
    for I := CompDefStart+1 to AData.SrcPas.Count do
    begin
      Text := AData.SrcPas[I].Trim;
      if Text = 'private' then
      begin
        CompDefEnd := I;
        Break;
      end;

      // 예외(private 구문을 지운경우)
      if (Text = 'public') or (Text = 'end;') then
      begin
        CompDefEnd := I;
        Break;
      end;
    end;

    // 컴포넌트 이벤트 변경
    for CompCodeInfo in CompCodeInfos do
    begin
      if CompCodeInfo.BeforeEventName = '' then
      // 새로운 이벤트 추가
      begin
        Code := CompCodeInfo.IntfCode;
        InsertCompCodeToPas(CompDefEnd, AData.SrcPas, Code);

        Idx := GetUnitEndIdx;
        Code := CompCodeInfo.ImplCode + #13#10;
        InsertCompCodeToPas(Idx, AData.SrcPas, Code);
      end
      else
      begin
        if CompCodeInfo.BeforeEventName = CompCodeInfo.EventName then
        begin
          // 동일한 이벤트 무시
          Continue;
        end;
        // [선언부] 이벤트 시작/끝 추출
        CompEventStart := 0;
        CompEventEnd := 0;
        for I := CompDefStart+1 to CompDefEnd do
        begin
          Text := AData.SrcPas[I].ToLower;
          if Text.Contains(' ' + CompCodeInfo.BeforeEventName.ToLower + '(') then
            CompEventStart := I;
          if (CompEventStart > 0) and Text.Contains(');') then
          begin
            CompEventEnd := I;
            Break;
          end;
        end;
        if (CompEventStart = 0) or (CompEventEnd = 0) then
        begin
          TLogger.Error('[%s] Not found event(Intf) ''%s''', [AData.FileInfo.Filename, CompCodeInfo.BeforeEventName]);
          Continue;
        end;

        if CompCodeInfo.EventName = '' then
        begin
          Code := Format('    { TODO : %s 이벤트를 검토 후 제거하세요. }', [CompCodeInfo.BeforeEventName]);
          InsertCompCodeToPas(CompEventStart, AData.SrcPas, Code);

        end
        else
        begin
          // [선언부] 기존 이벤트 주석 처리
          for I := CompEventStart to CompEventEnd do
            AData.SrcPas[I] := '//' + AData.SrcPas[I];

          // [선언부] 교체할 이벤트 추가
          Code := Format('    // %s > %s'#13#10, [CompCodeInfo.BeforeEventName, CompCodeInfo.EventName]);
          Code := Code + CompCodeInfo.IntfCode;
          InsertCompCodeToPas(CompEventEnd+1, AData.SrcPas, Code);
          Inc(CompDefEnd);

          // [구현부] 이벤트 시작/끝 추출
          CompEventStart := 0;
          CompEventEnd := 0;
          for I := UsesIdx.ImplimentationIndex+1 to AData.SrcPas.Count - 1 do
          begin
            Text := AData.SrcPas[I].ToLower;
            if Text.Contains(AData.FormName.ToLower + '.' + CompCodeInfo.BeforeEventName.ToLower + '(') then
              CompEventStart := I;
            if (CompEventStart > 0) and Text.Contains(');') then
            begin
              CompEventEnd := I;
              Break;
            end;
          end;
          if (CompEventStart = 0) or (CompEventEnd = 0) then
          begin
            TLogger.Error('[%s] Not found event(Impl) ''%s''', [AData.FileInfo.Filename, CompCodeInfo.BeforeEventName]);
            Continue;
          end;

          // [구현부] 기존 이벤트 주석 처리
          for I := CompEventStart to CompEventEnd do
            AData.SrcPas[I] := '//' + AData.SrcPas[I];
  //        Code := 'begin'#13#10;
  //        Code := Code + Format('  { TODO : %s 이벤트를 호출하는 코드를 %s로 변경 후 해당 이벤트를 제거하세요. }'#13#10, [CompCodeInfo.BeforeEventName, CompCodeInfo.EventName]);
  //        Code := Code + 'end;'#13#10#13#10;

          // [구현부] 교체할 이벤트 추가
    //      Code := Format('// %s 대체'#13#10, [CompCodeInfo.BeforeEventName]);
          Code := CompCodeInfo.ImplCode;
          InsertCompCodeToPas(CompEventEnd+1, AData.SrcPas, Code);
          Inc(CompDefEnd);
        end;
      end;
    end;
  end;
end;

function TConverter.Convert(AData: TConvertData): Integer;
begin
  Result := 0;

  while FindComponentInDfm(AData) do
  begin
    ConvertDfm(AData);
    if not AData.IsInherited then
      ConvertPas(AData);

//    AData.FileInfo.Filename
    Inc(Result);
  end;
end;

initialization

finalization
  TConvertManager.ReleaseInstance;

end.
