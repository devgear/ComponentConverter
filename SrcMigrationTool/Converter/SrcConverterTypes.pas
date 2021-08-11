unit SrcConverterTypes;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

const
  GRIDNAME_REGEX = '(' +
    'RDBG[Rr]id[a-zA-Z\d_]+' +
    '|' +
    'DBGridMaster' +
    '|' +
    'D[Bb]GridDetail' +
    '|' +
    'RealDBGrid[a-zA-Z\d_]+' +
  ')';
  VIEWNAME_REGEX = '(SetRGrid|aRGrid|R1)';
  INDEX_REGEX = '\[[\w\(\)\[\]\+\-\*\.\s]+\]';
  KOR_REGEX = 'ㄱ-ㅎㅏ-ㅣ가-힣';
  STRS_REGEX = '[\wㄱ-ㅎㅏ-ㅣ가-힣]+';


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

  // 변환정보
  TConvertData = class
  private
    FFileInfo: TFileInfo;
    FSource: TStringList;
    FRootPath: string;
  public
    property FileInfo: TFileInfo read FFileInfo;

    constructor Create(AFileInfo: TFileInfo);
    destructor Destroy; override;

    procedure LoadFromFile(ARootPath: string);
    procedure SaveToFile(ARootPath: string);

    property Source: TStringList read FSource;
    property RootPath: string read FRootPath;
  end;

//function GRIDNAME_REGEX(ACompName: string = ''): string;


implementation

//function GRIDNAME_REGEX(ACompName: string = ''): string;
//begin
//  Result := '(' +
//    'RDBG[Rr]id[a-zA-Z\d_]+' +
//    '|' +
//    'DBGridMaster' +
//    '|' +
//    'D[Bb]GridDetail' +
//    '|' +
//    'RealDBGrid[a-zA-Z\d_]+' +
//  ')';
//end;

{ TFileInfo }

function TFileInfo.GetFullpath(ARootpath: string): string;
begin
  Result := '';
  Result := TPath.Combine(ARootPath, FPath);
  Result := TPath.Combine(Result, FFilename);
end;

{ TConvertData }

constructor TConvertData.Create(AFileInfo: TFileInfo);
begin
  FFileInfo := AFileInfo;

  FSource := TStringList.Create;
end;

destructor TConvertData.Destroy;
begin
  FSource.Free;

  inherited;
end;

procedure TConvertData.LoadFromFile(ARootPath: string);
begin
  FRootPath := ARootPath;
  FSource.LoadFromFile(FFileInfo.GetFullpath(ARootPath));
end;

procedure TConvertData.SaveToFile(ARootPath: string);
begin
  FSource.SaveToFile(FFileInfo.GetFullpath(ARootPath));
end;

end.
