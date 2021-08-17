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
    function ConvertTbF_201I(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertTbF_4207P(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertTbF_4105P(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertTbF_4407_1P(AProc, ASrc: string; var ADest: string): Integer;


    [Impl]
    // DataSet while �� �յڿ� DisableControls > EnableControls �߰� �ڵ�ȭ
    function ConvertDataSetWhile(AProc, ASrc: string; var ADest: string): Integer;
  end;

  TCustomCustConvert = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertTbF_319P(AProc, ASrc: string; var ADest: string): Integer;
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
    'RDBGridMaster.Columns[��Į����].Visible',
    'RDBGridMasterDBBandedTableView1.Columns[��Į����].Visible');

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
  Result := 'Make Ŀ���� ��ȯ';
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
  Result := 'BookStore Ŀ����';
end;

{ TCustomBusConvert }

function TCustomBusConvert.ConvertDataSetWhile(AProc, ASrc: string;
  var ADest: string): Integer;
var
  I: Integer;
  Datas: TArray<TArray<string>>;
  DataSet, NextSrc: string;
  DCP, ECP, DC, EC: string;
begin
  Result := 0;
  Datas := [
    // ���ָ�,      �Լ���,                 �����ͼ� ������Ʈ ��
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

    , ['TmF_DayMonth_Report_P', 'Rtrv',     'Qry_Master']
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
        DCP := 'while not ' + DataSet.ToLower + '.eof do'; // do begin ���� ��쵵 ����
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

function TCustomBusConvert.ConvertTbF_201I(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;

  if not SrcFilename.Contains('TbF_201I') then
    Exit;

  if AProc.Contains('RealDBGrid1DBBandedTableView1EditKeyDown') then
  begin
    if ASrc.Trim = 'inherited;' then
    begin
      ADest := ASrc +'(*mig: appended 1 line below*)' + #13#10 + '  Exit;';
      Inc(Result);
    end;
  end;
end;

function TCustomBusConvert.ConvertTbF_4105P(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;

  if not SrcFilename.Contains('TbF_4105P') then
    Exit;

  if AProc.Contains('Rtrv') then
  begin
    if ASrc = '   While not qry_Master.EOF do begin' then
    begin
      ADest := '' +
        '   qry_Master.DisableControls;'#13#10 +
        '   kbmMemMasterT.DisableControls;'#13#10 +
        '   While not qry_Master.EOF(*DC*) do begin';

      Inc(Result);
    end
    else if ASrc = '      qry_Master.Next;' then
    begin
      ADest := '      qry_Master.Next(*EC*);';
      FConvData.Source[FCurrIndex+1] := '   end;'#13#10 +
        '   qry_Master.EnableControls;'#13#10 +
        '   kbmMemMasterT.EnableControls;'
      ;
      Inc(Result);
    end;


//   While not qry_Master.EOF do begin
{
   qry_Master.DisableControls;
   kbmMemMasterT.DisableControls;
   While not qry_Master.EOF(*DC*) do begin
}

{
      qry_Master.Next;
   end;
      qry_Master.Next(*EC*);
   end;

}
  end;
end;

function TCustomBusConvert.ConvertTbF_4207P(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;

  if not SrcFilename.Contains('TbF_4207P') then
    Exit;

  if not AProc.Contains('Rtrv') then
    Exit;

  if ASrc.Trim = 'RealDBGrid2DBBandedTableView1.Bands.Clear;' then
  begin
    ADest := '' +
      '   kbmMaster.Open;'#13#10 +
      '   RealDBGrid2DBBandedTableView1.OptionsView.BandHeaders := True;'#13#10 +
      ''#13#10 +
      ASrc + '(*mig: appended 3 line above*)'
      ;
    Inc(Result);
  end
  else if ASrc.Trim = 'for I := 0 to 4 do begin' then
  begin
    ADest := ASrc + '(*mig: appended 1 line below*)' + #13#10 +
      '      RealDBGrid2DBBandedTableView1.Columns[I].PropertiesClassName := ''TcxTextEditProperties'';'
      ;
    Inc(Result);
  end;


end;

function TCustomBusConvert.ConvertTbF_4407_1P(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;

  if not SrcFilename.Contains('TbF_4407_1P') then
    Exit;

  if AProc.Contains('Rtrv') then
  begin
    if ASrc.Trim = 'Qry_Detail.Active := True;' then
    begin
      ADest := ''#13#10 +
        '  Qry_Detail.MasterFields := ''�۾��ڵ�;��꼭��ȣ;���ݰ�꼭��ȣ'';'#13#10 +
        '  Qry_Detail.ParamByName(''�۾��ڵ�'').DataType := ftFixedChar;'#13#10 +
        '  Qry_Detail.ParamByName(''�۾��ڵ�'').Size := 5;'#13#10 +
        '  if Assigned(Qry_Detail.FindParam(''���ݰ�꼭��ȣ'')) then'#13#10 +
        '    Qry_Detail.ParamByName(''���ݰ�꼭��ȣ'').DataType := ftInteger;'#13#10 +
        '  if Assigned(Qry_Detail.FindParam(''��꼭��ȣ'')) then'#13#10 +
        '    Qry_Detail.ParamByName(''��꼭��ȣ'').DataType := ftInteger;'#13#10 +
        '  Qry_Detail.Active := True(*mig*);'
        ;
      Inc(Result);
    end;
  end
  else if AProc.Contains('Tax_Save3') then
  begin
    if ASrc.Trim = 'with Qry_Master do begin' then
    begin
      ADest := '' +
        '   DataBase := dmDataBase.DBKatasBusDB2;'#13#10 +
        '   with Qry_Master do begin(*mig: append 1 line above*)';

      Inc(Result);
    end;
  end;

end;

function TCustomBusConvert.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TCustomBusConvert.GetDescription: string;
begin
  Result := 'Bus Ŀ����';
end;

{ TCustomCustConvert }

function TCustomCustConvert.ConvertTbF_319P(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;

  if not SrcFilename.Contains('TbF_319P') then
    Exit;
  if AProc.Contains('Rtrv') then
  begin
    if ASrc = '   for I := 0 to 7 do begin' then
    begin
      ADest := ASrc + '(*mig: 1�� �߰�*)'#13#10 +
        '      RealDBGrid2DBBandedTableView1.Columns[I].PropertiesClassName := ''TcxTextEditProperties'';';

      Inc(Result);
    end;
  end;

end;

function TCustomCustConvert.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TCustomCustConvert.GetDescription: string;
begin
  Result := 'Cust Ŀ����';
end;

initialization
  TConvertManager.Instance.Regist(TCustomBusConvert);
  TConvertManager.Instance.Regist(TCustomMakeConvert);
  TConvertManager.Instance.Regist(TCustomBookStoreConvert);

end.
