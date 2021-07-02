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

  // ����
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

  // �ּ�ó���� Ű����
  Keywords := [
  ];

  {
  CellText�� ������Ÿ���� WideString���� string���� ����
  ���� ��
    procedure VTDetailGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
  ���� ��
    procedure VTDetailGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
  }
  Datas.Add('var CellText: WideString', 'var CellText: string');
  {
  TFDQuery.OnUpdateRecord �Ķ���� ���� ����
  ���� ��
    procedure qry_MasterUpdateRecord(DataSet: TDataSet; UpdateKind: TFDUpdateRequest;
      var UpdateAction: TFDErrorAction);
  ���� ��
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
  Result := '��Ÿ ������';
end;

initialization
  TConvertManager.Instance.Regist(TEtcConverter);
end.
