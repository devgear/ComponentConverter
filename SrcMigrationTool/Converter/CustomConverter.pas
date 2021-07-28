unit CustomConverter;

interface
uses
  SrcConverter;

type
  TCustomBusConvert = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertTbF_010I(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertDataSetDCEC(AProc, ASrc: string; var ADest: string): Integer;
  end;

  TCustomMakeConvert = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
    function GetCvtBaseClassName: string; override;
  published
    [Impl]
    function ConvertTmF_Box_PanJiBeJung_I(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertTmF_Yong101I(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertTmF_InJung_FactoryExpenses_I(AProc, ASrc: string; var ADest: string): Integer;
  end;

  TCustomBookStoreConvert = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertBS102I(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
  SrcConvertUtils,
  System.SysUtils;

{ TCustomMakeConvert }

function TCustomMakeConvert.ConvertTmF_Box_PanJiBeJung_I(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;
  if not (SrcFilename.Contains('TmF_Box_PanJiBeJung_I')) then
    Exit;

  Datas.Add(
    'DBGrid1.SelectedIndex := 3;',
    'DBGrid1DBBandedTableView1.Controller.FocusedItemIndex := 3;');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TCustomMakeConvert.ConvertTmF_InJung_FactoryExpenses_I(AProc,
  ASrc: string; var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if (SrcFilename.Contains('TmF_InJung_FactoryExpenses_I') and (AProc.Contains('Rtrv'))) then
  begin
    Datas.Add(
      'DataBase.Commit;',
      'Connection.Commit;');
    Datas.Add(
      'DataBase.Rollback;',
      'Connection.Rollback;');
  end;

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TCustomMakeConvert.ConvertTmF_Yong101I(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not (SrcFilename.Contains('TmF_Yong101I')) then
    Exit;

  Datas.Add(
    'RDBGridMaster.Columns[ÃÑÄ®·³¼ö].Visible',
    'RDBGridMasterDBBandedTableView1.Columns[ÃÑÄ®·³¼ö].Visible');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TCustomMakeConvert.GetCvtBaseClassName: string;
begin
  Result := 'TfrmTzzRealMaster2';
end;

function TCustomMakeConvert.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TCustomMakeConvert.GetDescription: string;
begin
  Result := 'Make Ä¿½ºÅÒ º¯È¯';
end;

{ TCustomBookStoreConvert }

function TCustomBookStoreConvert.ConvertBS102I(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not (SrcFilename.Contains('BS102I')) then
    Exit;

  Datas.Add(
    'wdeBalDay.AsString',
    'wdeBalDay.Text');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TCustomBookStoreConvert.GetCvtCompClassName: string;
begin
  Result := 'TcxDateEdit';
end;

function TCustomBookStoreConvert.GetDescription: string;
begin
  Result := 'BookStore Ä¿½ºÅÒ';
end;

{ TCustomBusConvert }

function TCustomBusConvert.ConvertDataSetDCEC(AProc, ASrc: string;
  var ADest: string): Integer;
var
  I: Integer;
  Datas: TArray<TArray<string>>;
  DataSet, NextSrc: string;
  DCP, ECP, DC, EC: string;
begin
  Result := 0;
  Datas := [
      ['TbF_101I', 'Rtrv',                  'QryBusDB']
    , ['TbF_101I', 'Qry_MasterAfterScroll', 'QryBusDB']
    , ['TbF_101I', 'QryBusDB1AfterScroll',  'QryBusDB']

    , ['TbF_102P', 'Rtrv',                  'Qry_Master']
    , ['TbF_103P', 'Rtrv',                  'Qry_Master']
    , ['TbF_104P', 'Rtrv',                  'Qry_Master']
    , ['TbF_105P', 'Rtrv',                  'Qry_Master']
    , ['TbF_106P', 'Rtrv',                  'Qry_Master']
    , ['TbF_107P', 'Rtrv',                  'Qry_Master']
    , ['TbF_109P', 'Rtrv',                  'Qry_Master']
    , ['TbF_110P', 'Rtrv',                  'Qry_Master']
    , ['TbF_111P', 'Rtrv',                  'Qry_Master']

    , ['TbF_117P', 'FooterSUM',             '']

    , ['TbF_121I', 'Rtrv',                  'QryBusDB']
    , ['TbF_121I', 'Qry_MasterAfterScroll', 'QryBusDB']
    , ['TbF_121I', 'QryBusDB1AfterScroll',  'QryBusDB']
    , ['TbF_122P', 'Rtrv',                  'Qry_Master']
    , ['TbF_123P', 'Rtrv',                  'Qry_Master']
    , ['TbF_123P', 'Rtrv',                  'Kmt_FooterSUM']

    , ['TbF_204P', 'Rtrv',                  'Qry_Master']
    , ['TbF_206P', 'FooterSUM',             '']
    , ['TbF_212P', 'Rtrv',                  'Qry_Master']

    , ['TbF_503P', 'Rtrv',                  'Qry_Master']
    , ['TbF_504P', 'Rtrv',                  'Qry_Master']
    , ['TbF_505P', 'Rtrv',                  'Qry_Master']
    , ['TbF_505P1', 'Rtrv',                  'Qry_Master']
    , ['TbF_505P2', 'Rtrv',                  'Qry_Master']
    , ['TbF_506P', 'Rtrv',                  'Qry_Master']
    , ['TbF_508P', 'Rtrv',                  'Qry_Master']
    , ['TbF_514P', 'Rtrv',                  'Qry_Master']

    , ['TbF_602P', 'Rtrv',                  'Qry_Master']

    , ['TmF_DayMonth_Report_P', 'Rtrv',                  'Qry_Master']
  ];

  for I := 0 to Length(Datas) - 1 do
  begin
    if SrcFilename.Contains(Datas[I][0]) and AProc.Contains(Datas[I][1]) then
    begin
      DataSet := Datas[I][2];
      if DataSet = '' then
      begin
        DCP := 'while not eof do';
        ECP := 'next;';
        DC := 'DisableControls;';
        EC := 'EnableControls;';
      end
      else
      begin
        DCP := 'while not ' + DataSet.ToLower + '.eof do'; // do begin ºÙÀº °æ¿ìµµ ÀÖÀ½
        ECP := DataSet.ToLower + '.next;';
        DC := DataSet + '.DisableControls;';
        EC := DataSet + '.EnableControls;';
      end;

      // DisableControls
      if ASrc.ToLower.Contains(DCP)  then
      begin
        ADest := TConvUtils.GetIndent(ASrc) + DC + #13#10 +
                ASrc.Replace('EOF', 'EOF(*DC*)');
        Inc(Result);
        Break;
      end

      // EnableControls
      else if ASrc.ToLower.Trim = ECP then
      begin
        NextSrc := FConvData.Source[FCurrIndex+1];
        if NextSrc.Trim = 'end;' then
        begin
          ADest := ASrc.Replace('Next;', 'Next(*EC*);');
          FConvData.Source[FCurrIndex+1] := NextSrc + #13#10 +
                  TConvUtils.GetIndent(NextSrc) + EC;

          Inc(Result);
          Break;
        end;
      end;
    end;
  end;
end;

function TCustomBusConvert.ConvertTbF_010I(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN = 'RealDBGrid2DBBandedTableView1\.Columns\[\d\]\.Footers\[\d\]';
var
  Datas: TChangeDatas;
  Keywords: TArray<string>;
begin
  Result := 0;

  if not SrcFilename.Contains('TbF_010I') then
    Exit;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    ADest := ASrc;
    Datas.Add('.Footers[2]', '.Footers[0(*2>0*)]');
    Datas.Add('.Footers[3]', '.Footers[1(*3>1*)]');
    Datas.Add('.Footers[4]', '.Footers[2(*4>2*)]');

    Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));

    Keywords := [
      '.Footers[0]',
      '.Footers[1]'
    ];
    Inc(Result, AddComments(ADest, Keywords));
  end;
end;

function TCustomBusConvert.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';end;

function TCustomBusConvert.GetDescription: string;
begin
  Result := 'Bus Ä¿½ºÅÒ';
end;

initialization
  TConvertManager.Instance.Regist(TCustomBusConvert);
  TConvertManager.Instance.Regist(TCustomMakeConvert);
  TConvertManager.Instance.Regist(TCustomBookStoreConvert);

end.
