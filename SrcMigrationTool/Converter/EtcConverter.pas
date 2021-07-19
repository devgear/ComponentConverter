unit EtcConverter;

interface

uses
  SrcConverter;

type
  TEtcConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Intf]
    [Impl]
    function ConvertEventParamChange(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertFDUpdateRecord(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertExportFromRealDB(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertExportFromRealDBType2(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertCbxReadOnly(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertBus2021(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

  TFDStoredProcConvert = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertParamValue(AProc, ASrc: string; var ADest: string): Integer;
  end;

  TKbmMemTableConvert = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
  published
    [Impl]
    function ConvertAddIndex(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConvertUtils,
  System.SysUtils;

{ TEtcConverter }


function TEtcConverter.ConvertCbxReadOnly(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  Datas.AddInFile('TbF_4407_1P',
    'Deal_EDT.ReadOnly := False;',
    'Deal_EDT.Enabled := True;');

  Datas.AddInFile('TbF_4407_1P',
    'Deal_EDT.ReadOnly := True;',
    'Deal_EDT.Enabled := False;');


  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TEtcConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
  Keywords: TArray<string>;
begin
  Result := 0;
  ADest := ASrc;

  Datas.Add('RealDBGrid1Click(Self);', 'var B: Boolean;'#13#10'   RealDBGrid1DBBandedTableView1CellClick(RealDBGrid1DBBandedTableView1, nil, mbLeft, [], B);');
  Datas.Add('''Bus2010_config.ini''', 'ExtractFilePath(Application.ExeName) + ''Bus2021_config.ini''');

  Keywords := [
    '.BuildFromDataSet;'
  ];

  // 제거
  Inc(Result, RemoveKeyword(ADest, 'sSkinManager1.Active'));
  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
  Inc(Result, AddComments(ADest, Keywords));
end;

function TEtcConverter.ConvertEventParamChange(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := 0;

  Datas.Add('var CellText: WideString', 'var CellText: string');

  ADest := ASrc;

  // 주석처리할 키워드
  Keywords := [
  ];

  {
  CellText의 데이터타입을 WideString에서 string으로 변경
  변경 전
    procedure VTDetailGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
  변경 후
    procedure VTDetailGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
  }
  Datas.Add('var CellText: WideString', 'var CellText: string');
  {
  TFDQuery.OnUpdateRecord 파라메터 변경 대응
  변경 전
    procedure qry_MasterUpdateRecord(DataSet: TDataSet; UpdateKind: TFDUpdateRequest;
      var UpdateAction: TFDErrorAction);
  변경 후
    procedure qry_MasterUpdateRecord(DataSet: TDataSet; UpdateKind: TFDUpdateRequest;
      var UpdateAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  }
  Datas.Add('var UpdateAction: TFDErrorAction);', 'var UpdateAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);');


  Inc(Result, AddComments(ADest, Keywords));
  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TEtcConverter.ConvertExportFromRealDB(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = 'up_ExcelExportFromRealDB\(' + GRIDNAME_REGEX + '\,';
  REPLACE_FORMAT  = 'up_ExcelExportFromGrid([[COMP_NAME]]DBBandedTableView1,';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TEtcConverter.ConvertExportFromRealDBType2(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = 'up_ExcelExportFromRealDBType2\(' + GRIDNAME_REGEX + '\,';
  REPLACE_FORMAT  = 'up_ExcelExportFromGridType2([[COMP_NAME]]DBBandedTableView1,';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TEtcConverter.ConvertFDUpdateRecord(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not AProc.Contains('UpdateRecord') then
    Exit;

  Datas.Add('.Apply(UpdateKind)',         '.Apply(UpdateKind, UpdateAction, AOptions)');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TEtcConverter.ConvertBus2021(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Keywords: TArray<string>;
begin
  Result := 0;
  ADest := ASrc;

  if SrcFilename.Contains('TbF_4208P') and AProc.Contains('ToolButtonPrintClick') then
  begin
    Keywords := [
      'var',
      'IWaitCursor'
    ];

    Inc(Result, AddComments(ADest, Keywords));
  end;

  if SrcFilename.Contains('TbF_4407_1P') and AProc.Contains('Tax_EDTChange') then
  begin
    Keywords := [
      'RDBGridMaster.Options',
      '[wgoAlwaysShowEditor, wgoEditing]'
    ];

    Inc(Result, AddComments(ADest, Keywords));
  end;
end;

function TEtcConverter.GetCvtCompClassName: string;
begin
  Result := '';
end;

function TEtcConverter.GetDescription: string;
begin
  Result := '기타 수정건';
end;

{ TSPParamValueConvert }

function TFDStoredProcConvert.ConvertParamValue(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  Datas.AddInFile('TbF_129I',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');
  Datas.AddInFile('TbF_323P',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');
  Datas.AddInFile('TbF_331I',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');
  Datas.AddInFile('TbF_338I',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');
  Datas.AddInFile('TbF_4407_2P',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');
  Datas.AddInFile('TbF_4407P',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');
  Datas.AddInFile('TbF_129I',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').AsString',
    'spGetSeqNum.ParamByName(''@Gubun_COD'').Value');

//  Datas.AddInFile('TbF_003I',
//    'spGetJumunNum.ParamByName(''@Gubun_COD'').AsString',
//    'spGetJumunNum.ParamByName(''@Gubun_COD'').Value');



  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TFDStoredProcConvert.GetCvtCompClassName: string;
begin
  Result := 'TFDStoredProc';
end;

function TFDStoredProcConvert.GetDescription: string;
begin
  Result := 'FDStoredProc 변환';
end;

{ TKbmMemTableConvert }

function TKbmMemTableConvert.ConvertAddIndex(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Keywords: TArray<string>;
begin
  Result := 0;
  if not SrcFilename.Contains('TbF_206P') then
    Exit;

  if not AProc.Contains('Rtrv') then
    Exit;

  if ASrc.Contains('kmt_master.AddIndex') then
  begin
    if ASrc.Contains(''', ''''{Exp}, []);') then
      Exit;

    ADest := ASrc;
    Inc(Result, ReplaceKeyword(ADest, ''', []);', ''', ''''{Exp}, []);'));
  end;
end;

function TKbmMemTableConvert.GetCvtCompClassName: string;
begin
  Result := 'TFDMemTable';
end;

function TKbmMemTableConvert.GetDescription: string;
begin
  Result := 'kbm 변환';
end;

initialization
  TConvertManager.Instance.Regist(TEtcConverter);
  TConvertManager.Instance.Regist(TFDStoredProcConvert);
  TConvertManager.Instance.Regist(TKbmMemTableConvert);


end.
