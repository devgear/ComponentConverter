unit CompConverterTypes;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  // DFM 파일 정보
  TDfmFileData = class
  private
    FFilename: string;
    FPath: string;
  public
    destructor Destroy; override;

    property Filename: string read FFilename write FFilename;
    property Path: string read FPath write FPath;

    function GetDfmFullpath(ARootpath: string): string;
    function GetPasFullpath(ARootPath: string): string;
  end;

  // 컴포넌트 이벤트 정보
  TCompEventInfo = record
    EventName,
    IntfCode,
    ImplCode,
    BeforeEventName: string;
  end;

  // 변환정보
  TConvertData = class
  private
    FDfmFileData: TDfmFileData;
    FSourceDfm: TStringList;
    FSourcePas: TStringList;
    FConvertDfm: TStringList;

    // 분석 대상 컴포넌트 정보
    FCompName: string;
    FCompStartIndex: Integer;
    FCompEndIndex: Integer;
    FIsInherited: Boolean;
    // 분석 중인 폼의 이름(T 포함)
    FFormName: string;
    FTotalEventInfos: TArray<TCompEventInfo>;
    FRootPath: string;
  public
    property DfmFileData: TDfmFileData read FDfmFileData;
    property RootPath: string read FRootPath;

    constructor Create(AFileData: TDfmFileData);
    destructor Destroy; override;

    procedure LoadFromFile(ARootPath: string);
    procedure SaveToFile(ARootPath: string);

    property IsInherited: Boolean read FIsInherited write FIsInherited;

    property FormName: string read FFormName write FFormName;
    property CompName: string read FCompName write FCompName;
    property CompStartIndex: Integer read FCompStartIndex write FCompStartIndex;
    property CompEndIndex: Integer read FCompEndIndex write FCompEndIndex;

    property SrcDfm: TStringList read FSourceDfm;
    property SrcPas: TStringList read FSourcePas;
    property ConvDfm: TStringList read FConvertDfm;

    // 모든 컴포넌트의 이벤트 정보 동일한 이벤트를 공유하면 재사용해야 함
    property TotalEventInfos: TArray<TCompEventInfo> read FTotalEventInfos write FTotalEventInfos;
  end;


implementation

{ TFileInfo }

destructor TDfmFileData.Destroy;
begin

  inherited;
end;

function TDfmFileData.GetDfmFullpath(ARootpath: string): string;
begin
  Result := '';
  Result := TPath.Combine(ARootPath, FPath);
  Result := TPath.Combine(Result, FFilename);
end;

function TDfmFileData.GetPasFullpath(ARootPath: string): string;
begin
  Result := GetDfmFullpath(ARootPath);
  Result := Copy(Result, 1, Length(Result) - 3) + 'pas';
end;

{ TConvertData }

constructor TConvertData.Create(AFileData: TDfmFileData);
begin
  FDfmFileData := AFileData;

  FSourceDfm := TStringList.Create;
  FSourcePas := TStringList.Create;
  FConvertDfm := TStringList.Create;
end;

destructor TConvertData.Destroy;
begin
  FSourceDfm.Free;
  FSourcePas.Free;
  FConvertDfm.Free;

  inherited;
end;

procedure TConvertData.LoadFromFile(ARootPath: string);
begin
  FRootPath := ARootPath;

  FSourceDfm.LoadFromFile(FDfmFileData.GetDfmFullpath(ARootPath));
  FSourcePas.LoadFromFile(FDfmFileData.GetPasFullpath(ARootPath));
end;

procedure TConvertData.SaveToFile(ARootPath: string);
begin
  FSourceDfm.SaveToFile(FDfmFileData.GetDfmFullpath(ARootPath));
  FSourcePas.SaveToFile(FDfmFileData.GetPasFullpath(ARootPath));
end;

end.
