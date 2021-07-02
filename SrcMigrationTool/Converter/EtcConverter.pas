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
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConvertUtils,
  System.SysUtils;

{ TEtcConverter }


function TEtcConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;
  ADest := ASrc;

  Datas.Add('RealDBGrid1Click(Self);', 'var B: Boolean;'#13#10'   RealDBGrid1DBBandedTableView1CellClick(RealDBGrid1DBBandedTableView1, nil, mbLeft, [], B);');

  // 제거
  Inc(Result, RemoveKeyword(ADest, 'sSkinManager1.Active'));
  Inc(Result, ReplaceKeywords(ADest, Datas));
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
  Inc(Result, ReplaceKeywords(ADest, Datas));
end;

function TEtcConverter.ConvertExportFromRealDB(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = 'up_ExcelExportFromRealDB\(' + GRIDNAME_REGEX + '\,';
  REPLACE_FORMAT  = 'up_ExcelExportFromGrid([[COMP_NAME]]DBBandedTableView1,';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
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

  Inc(Result, ReplaceKeywords(ADest, Datas));
end;

function TEtcConverter.GetCvtCompClassName: string;
begin
  Result := '';
end;

function TEtcConverter.GetDescription: string;
begin
  Result := '기타 수정건';
end;

initialization
  TConvertManager.Instance.Regist(TEtcConverter);
end.
