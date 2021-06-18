unit ComFuncConverter;

interface

uses
  SrcConverter;

type
  TComFuncConverter = class(TConverter)
  private
    function ConvertSortOrder(ASrc: string; var ADest: string): Boolean;
    function ConvertIsAsTRealGrid(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertOraSession(ASrc: string; var ADest: string): Boolean;
    function ConvertSWRcolFind(ASrc: string; var ADest: string): Boolean;
    function ConvertWinExec(ASrc: string; var ADest: string): Boolean;

    function ConvertSetRGrid(ASrc: string; var ADest: string): Boolean;
    function ChangeGridVar(AGridVarName: string; var ADest: string): Boolean;
    function ConvertFuncRealGrid(ASrc: string; var ADest: string): Boolean;
    function ConvertFuncParamRealGrid(ASrc: string; var ADest: string): Boolean;
    function ConvertFuncParamUse(AProc, ASrc: string; var ADest: string): Boolean;
    function ChangeViewSelectedIndex(AComp: string; var ADest: string): Boolean;
    function ConvertR_Set(ASrc: string; var ADest: string): Boolean;

    function ConvertAbs(ASrc: string; var ADest: string): Boolean;

    function ConvertGridToView(AProc, ASrc: string; var ADest: string): Boolean;

    function ConvertStyle(ASrc: string; var ADest: string): Boolean;
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Boolean;

    function ConvertMigIssue(AProc, ASrc: string; var ADest: string): Boolean;

    function ConvertIntfEtc(ASrc: string; var ADest: string): Boolean;
    function ConvertAbsRecover(ASrc: string; var ADest: string): Boolean;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;

    function ConvertSource(AProc, ASrc: string; var ADest: string): Boolean; override;
    function ConvertIntfSource(ASrc: string; var ADest: string): Boolean; override;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes, System.SysUtils,
  System.RegularExpressions, SrcConvertUtils;

{ TCellsConverter }

function TComFuncConverter.ChangeGridVar(AGridVarName: string;
  var ADest: string): Boolean;
const
  // SetRGrid :=  RGrid_ExpSty3;
  // SetRGrid := RGrid_Company; //회사코드
  SEARCH_PATTERN  = '[\s]+:=[\s]+[A-Za-z\_\d]+\;';
  REPLACE_FORMAT  = ' := [[COMP_NAME]]BandedTableView1;';
var
  I: Integer;
  SearchPattern, ReplaceFormat: string;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  SearchPattern := AGridVarName + SEARCH_PATTERN;
  ReplaceFormat := AGridVarName + REPLACE_FORMAT;

  if ADest.Contains('BandedTableView1') then
    Exit;

  Matchs := TRegEx.Matches(ADest, SearchPattern, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;
    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\;').Value.Replace(';', '').Trim;

    Dest := ReplaceFormat;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TComFuncConverter.ChangeViewSelectedIndex(AComp: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '\.[Ss]elected[Ii]ndex';
  REPLACE_READ_FORMAT  = '[[COMP_NAME]].Controller.FocusedColumn.Index';
  REPLACE_WRITE_FORMAT  = '[[COMP_NAME]].Columns[[[COL_IDX]]].Focused := True';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, AfterStr, ColIdx: string;
  Src, Dest, Temp: string;
  AssignType: TAssignType;
begin
  Result := False;

  if not ADest.Contains(AComp + '.SelectedIndex') then
    Exit;

  Matchs := TRegEx.Matches(ADest, AComp + SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    AfterStr := Copy(ADest, Match.Index + Match.Length, Length(ADest)).Trim;
    if AfterStr.StartsWith(':=') then
      AssignType := atWrite
    else
      AssignType := atRead;

    if AssignType = atWrite then
    begin
      if Pos(';', AfterStr) > 0 then
        ColIdx := Copy(AfterStr, 3, Pos(';', AfterStr)-3).Trim
      else
        ColIdx := Copy(AfterStr, 3, Length(AfterStr)).Trim;
    end;

    if AssignType = atRead then
    begin
      Dest := REPLACE_READ_FORMAT;
      Dest := Dest.Replace('[[COMP_NAME]]', AComp);
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      ADest := ADest.Replace(Src, Dest);
    end
    else
    begin
      Dest := REPLACE_WRITE_FORMAT;
      Dest := Dest.Replace('[[COMP_NAME]]', AComp);
      Dest := Dest.Replace('[[COL_IDX]]',   ColIdx);

      Temp := Copy(ADest, 1, Match.Index-1);
      Temp := Temp + Dest;
      Temp := Temp + Copy(AfterStr, Pos(';', AfterStr), Length(AfterStr));
      ADest := Temp;
    end;
    Result := True;
  end;
end;

function TComFuncConverter.ConvertAbs(ASrc: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '(Abs|ABS|abs)\([\w.\[\],\s\+]+\)';
  REPLACE_FORMAT  = 'Abs(Integer([[PARAM]]))';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Param: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  if (not ASrc.Contains('ABS')) and (not ASrc.Contains('Abs')) and (not ASrc.Contains('abs')) then
    Exit;

  if ASrc.Contains('Abs(Integer(') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    // SRC =  Abs(   )

    Param := Copy(Src, 5, Length(Src)-5);

    if not Param.Contains('DataController.Values') then
      Continue;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[PARAM]]', Param);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

// 미사용(ConvertRecover 복구용)
function TComFuncConverter.ConvertAbsRecover(ASrc: string; var ADest: string): Boolean;
const
  SEARCH_PATTERN  = '(Abs|ABS|abs)\(Integer\([\w.\[\],\s\+]+\)\)';
  REPLACE_FORMAT  = 'Abs(Integer([[PARAM]]))';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Param: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

//  if (not ASrc.Contains('ABS')) and (not ASrc.Contains('Abs')) and (not ASrc.Contains('abs')) then
//    Exit;

  if not ASrc.Contains('Abs(Integer(') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;

    // SRC =  Abs(   )

    Param := Copy(Src, 13, Length(Src)-13-1);
    if Param[Length(Param)] <> ']' then
      Param := Param + ']';

//    if not Param.Contains('DataController.Values') then
//      Continue;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[PARAM]]', Param);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TComFuncConverter.ConvertEtc(AProc, ASrc: string; var ADest: string): Boolean;
var
  I: Integer;
  Keywords: TArray<string>;
  ComSuffix: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    '.Multiplier',        'ColorPalette',       'MColumns[',
    '.Printer.PageCount', '].Color',
    '.Sort(',             '.sort(',
    '.Indicators.ShowRowNo',
    'dxSideBar1.GroupCount'
  ];

  Datas.Add('AppendStr(sTemp, ''-'')', 'sTemp := sTemp + ''-''');
  Datas.Add('AppendStr(sTemp, sCallValue[Index])', 'sTemp := sTemp + sCallValue[Index]');

  Datas.Add('AsOraBlob.LoadFromStream(AStream)',    'AsStream := AStream');
  Datas.Add(' OR (Sender is Twcells)',              '');
  // IdFTP
  Datas.Add('const AWorkCount: Integer',            'const AWorkCount: Int64');
  Datas.Add('const AWorkCountMax: Integer',         'const AWorkCountMax: Int64');

  Datas.Add(' DateSeparator',         ' FormatSettings.DateSeparator');

  Datas.Add('RealGrid4.PopupMenu.',      'TPopupMenu(RealGrid4.PopupMenu).');

  Datas.Add('ExportGrid4ToText',        'ExportGridToText');

//  Datas.Add('Application.MessageBox(pchar(',        'Application.MessageBox(pchar(string(');
//  Datas.Add('), ''오류'', MB_IconStop+MB_OK);',     ')), ''오류'', MB_IconStop+MB_OK);');

  Datas.Add('with OraQueryMst1, RealGrid1 do',        'with OraQueryMst1, RealGrid1BandedTableView1 do');
  Datas.Add('with OraPopQuery1, RealGrid1 do',        'with OraPopQuery1, RealGrid1BandedTableView1 do');
  Datas.Add('With OraPopQuery1, RealGrid2 Do',        'With OraPopQuery1, RealGrid2BandedTableView1 Do');
  Datas.Add('with RGrid_Save2, OraQueryMst1 do',      'with RGrid_Save2BandedTableView1, OraQueryMst1 do');
  Datas.Add('with RGrid_Save3, OraQueryMst1 do',      'with RGrid_Save3BandedTableView1, OraQueryMst1 do');
  Datas.Add('with OraQuery1, RGrid_Search do',        'with OraQuery1, RGrid_SearchBandedTableView1 do');
  Datas.Add('with OraPopQuery1, RGrid_Style do',      'with OraPopQuery1, RGrid_StyleBandedTableView1 do');
  Datas.Add('with OraPopQuery1, RGrid_Shop do',       'with OraPopQuery1, RGrid_ShopBandedTableView1 do');
  Datas.Add('with OraPopQuery1, RGrid_Search do',       'with OraPopQuery1, RGrid_SearchBandedTableView1 do');
  Datas.Add('with OraQueryMst1, RGrid_Search do',       'with OraQueryMst1, RGrid_SearchBandedTableView1 do');
  Datas.Add('with OraPopQuery1, RGrid_ExpStyle do',       'with OraPopQuery1, RGrid_ExpStyleBandedTableView1 do');

  Datas.Add('with RGrid_Save1 do',                    'with RGrid_Save1BandedTableView1 do');
  Datas.Add('with RGrid_Save2 do',                    'with RGrid_Save2BandedTableView1 do');
  Datas.Add('with RGrid_Save3 do',                    'with RGrid_Save3BandedTableView1 do');
  Datas.Add('with RGrid_Search do',                   'with RGrid_SearchBandedTableView1 do');
  Datas.Add('with RGrid_Point do',                    'with RGrid_PointBandedTableView1 do');
  Datas.Add('with RGrid_Template do',                 'with RGrid_TemplateBandedTableView1 do');

  if AProc = 'UpdateRecordPictureByFileName' then
    Datas.Add('AValue: string;',        'AValue: AnsiString;');

  Datas.Add('RealGrid2.MaxRowCount',        'RealGrid2BandedTableView1.DataController.RecordCount');

  Datas.Add('(Sender as TcxGridBandedTableView).SetFocus;',        '(Sender as TcxGrid).SetFocus;');

  Datas.Add('Col := Col+1;',
    'Columns[Controller.FocusedColumn.Index+1].Focused := True;');
  Datas.Add('Col := Col-1;',
    'Columns[Controller.FocusedColumn.Index-1].Focused := True;');

  Datas.Add(' Groups[i]',        ' Bands[i]');

  Datas.Add('RealGridBandedTableView1',        'RealGrid');


  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertFuncParamRealGrid(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('R1 : TRealGrid',         'R1: TcxGridBandedTableView');
  Datas.Add('R1: TRealGrid',          'R1: TcxGridBandedTableView');
  Datas.Add('Rg : TRealGrid',         'Rg: TcxGridBandedTableView');
  Datas.Add('Rg: TRealGrid',          'Rg: TcxGridBandedTableView');
  Datas.Add('SetRGrid : TRealGrid',  'SetRGrid: TcxGridBandedTableView');
  Datas.Add('SetRGrid: TRealGrid',   'SetRGrid: TcxGridBandedTableView');
  Datas.Add('SetRGrid1 : TRealGrid',  'SetRGrid1: TcxGridBandedTableView');
  Datas.Add('SetRGrid1: TRealGrid',   'SetRGrid1: TcxGridBandedTableView');
  Datas.Add('SetRGrid2 : TRealGrid', 'SetRGrid2: TcxGridBandedTableView');
  Datas.Add('SetRGrid2: TRealGrid',  'SetRGrid2: TcxGridBandedTableView');
  Datas.Add('SetRGrid3 : TRealGrid', 'SetRGrid3: TcxGridBandedTableView');
  Datas.Add('SetRGrid3: TRealGrid',  'SetRGrid3: TcxGridBandedTableView');
  Datas.Add('sReal1 : TRealGrid;',    'sReal1: TcxGridBandedTableView');
  Datas.Add('sReal1: TRealGrid',     'sReal1: TcxGridBandedTableView');
  Datas.Add('sReal2 : TRealGrid',    'sReal2: TcxGridBandedTableView');
  Datas.Add('sReal2: TRealGrid',     'sReal2: TcxGridBandedTableView');
  Datas.Add('Sender : TRealGrid',    'Sender: TcxGridBandedTableView');
  Datas.Add('Sender: TRealGrid',     'Sender: TcxGridBandedTableView');
  Datas.Add('Real : TRealGrid',      'Real: TcxGridBandedTableView');
  Datas.Add('Real: TRealGrid',       'Real: TcxGridBandedTableView');
  Datas.Add('Real : TrealGrid',      'Real: TcxGridBandedTableView');
  Datas.Add('Real: TrealGrid',       'Real: TcxGridBandedTableView');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertFuncParamUse(AProc, ASrc: string; var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add(' R1.Clear;',            ' R1.DataController.RecordCount := 0;');
  Datas.Add(' R1.RowCount',          ' R1.DataController.RecordCount');
  Datas.Add('R1BandedTableView1.',  'R1.');
  Datas.Add(' R1.Row',               ' R1.DataController.FocusedRowIndex');
  Datas.Add('[R1.Row',               '[R1.DataController.FocusedRowIndex');
  Datas.Add(' R1.SetFocus;',        '  R1.Control.SetFocus;');
  Datas.Add(' R1.ColCount',          ' R1.ColumnCount');
  Datas.Add('R1.Handle',            'R1.Control.Handle');

  Datas.Add('Real.RowCount',       'Real.DataController.RecordCount');
  Datas.Add('RealBandedTableView1.','Real.');
  Datas.Add('Real.Post;',           'Real.DataController.Post');
  Datas.Add('Real.Groups',          'Real.Bands');

  Datas.Add('SenderBandedTableView1.',  'Sender.');
  Datas.Add('Sender.RowCount',          'Sender.DataController.RecordCount');
  Datas.Add('Sender.ColCount',          'Sender.ColumnCount');
  Datas.Add('Sender.Row',               'Sender.DataController.FocusedRowIndex');
  Datas.Add('Sender.SetFocus;',         'Sender.Control.SetFocus;');
  Datas.Add('Sender.Handle',            'Sender.Control.Handle');

  if ADest.EndsWith(' ,RealGrid1') then
    Datas.Add(',RealGrid1',            ',RealGrid1BandedTableView1');
  if ADest.EndsWith(' ,RealGrid2') then
    Datas.Add(',RealGrid2',            ',RealGrid2BandedTableView1');
  if ADest.EndsWith(' ,RealGrid5') then
    Datas.Add(',RealGrid5',            ',RealGrid5BandedTableView1');


  Datas.Add('RgBandedTableView1.',  'Rg.');
  Datas.Add('Rg.RowCount',          'Rg.DataController.RecordCount');
  Datas.Add(' Rg.Clear;',            ' Rg.DataController.RecordCount := 0;');

  if (AProc = 'R_DataInput') then
  begin
    Datas.Add(' Row;',                ' DataController.FocusedRowIndex;');
    Datas.Add('(SelectedIndex ',      '(Controller.FocusedColumn.Index');
    Datas.Add('(SelectedIndex ',      '(Controller.FocusedColumn.Index');
  end;

  if (AProc = 'Gubun_All') then
  begin
    Datas.Add(' Post;',                ' DataController.Post;');
  end;

  if (AProc = 'GridDataToCSV') then
  begin
    Datas.Add('aRGrid.GroupMode',           'aRGrid.OptionsView.BandHeaders');
    Datas.Add('Columns.Count',              'ColumnCount');
    Datas.Add('Footers.Count',              'DataController.Summary.FooterSummaryItems.Count');
    Datas.Add('Columns[aCol].Footer.Text[0]',
        'DataController.Summary.FooterSummaryTexts[Columns[aCol].Summary.Item.Index]');

  end;

  Datas.Add('RealGrid3[00,RealGrid3BandedTableView1.DataController.FocusedRowIndex].AsString',
    'RealGrid3BandedTableView1.DataController.Values[RealGrid3BandedTableView1.DataController.FocusedRowIndex, 00]');
  Datas.Add('RealGrid3[01,RealGrid3BandedTableView1.DataController.FocusedRowIndex].AsString',
    'RealGrid3BandedTableView1.DataController.Values[RealGrid3BandedTableView1.DataController.FocusedRowIndex, 01]');
  Datas.Add('RealGrid3[02,RealGrid3BandedTableView1.DataController.FocusedRowIndex].AsString',
    'RealGrid3BandedTableView1.DataController.Values[RealGrid3BandedTableView1.DataController.FocusedRowIndex, 02]');


  if ChangeViewSelectedIndex('R1', ADest) then
    Result := True;
  if ChangeViewSelectedIndex('Sender', ADest) then
    Result := True;

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertFuncRealGrid(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    'RealGridColumnsDelete', 'RealGridColumnsCreate'
  ];

  Datas.Add('Real_Check(Real: TRealGrid;', 'Real_Check(Real: TcxGridBandedTableView;');
  Datas.Add('Real_Check(Real : TRealGrid;', 'Real_Check(Real: TcxGridBandedTableView;');
  Datas.Add('Real_Check(RealGrid1, ', 'Real_Check(RealGrid1BandedTableView1, ');

  Datas.Add('With RealGrid1 Do', 'with RealGrid1BandedTableView1 do');
  Datas.Add('with RealGrid2 do', 'with RealGrid2BandedTableView1 do');
  Datas.Add('With RealGrid4 Do', 'with RealGrid4BandedTableView1 do');

  Datas.Add('Real_DT(R1: TRealGrid;', 'Real_DT(R1: TcxGridBandedTableView;');
  Datas.Add('Real_DT(R1 : TRealGrid;', 'Real_DT(R1: TcxGridBandedTableView;');
  Datas.Add('Real_DT(RealGrid1,', 'Real_DT(RealGrid1BandedTableView1,');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertGridToView(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  I: Integer;
  Keywords: TArray<string>;
  ComSuffix: TArray<string>;
  Datas: TChangeDatas;

  procedure DataAddSuffix(AData: string; ASuffixes: TArray<string>);
  var
    Suffix: string;
  begin
    for Suffix in ASuffixes do
      Datas.Add(AData + Suffix,     AData + 'BandedTableView1' + Suffix);
  end;
begin
  Result := False;

  ADest := ASrc;

  // 함수 파라메터 변경으로 파라메터 전달 개체 변경
    // RealGrid1 > RealGrid1BandedTableView1
    // 그리드를 전달할 수 있어 함수 지정해 진행
  if  ADest.Contains('RealGridGroupCreate')
   or ADest.Contains('RealGridGroupDelete')
   or ADest.Contains('Program_AfterWonCalc')
   or ADest.Contains('R_DataSelect')
   or ADest.Contains('RealGridPopupMenu(')
   or ADest.Contains('FUN_PopupMenu(')
   or ADest.Contains('GridDataToCSV(')
   or ADest.Contains('Real_Value(')
   or ADest.Contains('R_Check(')
   or ADest.Contains('G_MiniPDA(')
   or ADest.Contains('Real_DT(')
   or ADest.Contains('Ban_Save(')
//   or ADest.Contains('buy_Ck(')
   or ADest.Contains('MakeSql1(')
   or ADest.Contains('RealGrid_ColumnSet(')
   or ADest.Contains('R_DataInput(')
   or ADest.Contains('RT_Save(')
   or ADest.Contains('Chul_Save(')
   or ADest.Contains('Busk_Save2(')
   or ADest.Contains('Chul_Save(')
   or ADest.Contains('RealGrid_ColumnClear(')
   or ADest.Contains('Chul_Save(')
   or ADest.Contains('R_Set(')
   or ADest.Contains('RealGrid_ColumnDisplay(')
   or ADest.Contains('RealGrid_ColumnReplace(')
  then
  begin
    ComSuffix := [',', ')', ' '];
    for I := 0 to 15 do
    begin
      DataAddSuffix(Format('RealGrid%d', [I]), ComSuffix);
      DataAddSuffix(Format('realGrid%d', [I]), ComSuffix);
    end;

    DataAddSuffix('RealGrid_First',    ComSuffix);
    DataAddSuffix('RGrid_Company',     ComSuffix);
    DataAddSuffix('RGrid_Sty1',        ComSuffix);
    DataAddSuffix('RGrid_Sty5',        ComSuffix);
    DataAddSuffix('RGrid_sCompany',        ComSuffix);
    DataAddSuffix('RGrid_sSty1',        ComSuffix);
    DataAddSuffix('RGrid_Sale',        ComSuffix);
    DataAddSuffix('RGrid_Company',     ComSuffix);
    DataAddSuffix('RGrid_ShopBrand',   ComSuffix);
  end;


  if  ADest.Contains('Insert_Barcode(')
  then
  begin
    for I := 0 to 15 do
    begin
      Datas.Add(Format(', RealGrid%d', [I]), Format(', RealGrid%dBandedTableView1', [I]));
      Datas.Add(Format(', RealGrid%dBandedTableView1BandedTableView1', [I]), Format(', RealGrid%dBandedTableView1', [I]));
    end;
  end;

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertIntfEtc(ASrc: string;
  var ADest: string): Boolean;
var
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Datas.Add('Real_Check(Real: TRealGrid;', 'Real_Check(Real: TcxGridBandedTableView;');
  Datas.Add('Real_Check(Real : TRealGrid;', 'Real_Check(Real: TcxGridBandedTableView;');
  Datas.Add('Real_DT(R1: TRealGrid;', 'Real_DT(R1: TcxGridBandedTableView;');
  Datas.Add('Real_DT(R1 : TRealGrid;', 'Real_DT(R1: TcxGridBandedTableView;');
  // IdFTP
  Datas.Add('const AWorkCount: Integer',            'const AWorkCount: Int64');
  Datas.Add('const AWorkCountMax: Integer',         'const AWorkCountMax: Int64');

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertIntfSource(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertFuncParamRealGrid(ADest, ADest) then
    Result := True;
  if ConvertIntfEtc(ADest, ADest) then
    Result := True;
end;

function TComFuncConverter.ConvertIsAsTRealGrid(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Datas.Add('is TRealGrid', 'is TcxGrid');
  Datas.Add('as TRealGrid).Tag', 'as TcxGrid).Tag');
  if AProc = 'RealGridPopupMenu' then
    Datas.Add('as TRealGrid', 'as TcxGrid')
  else
    Datas.Add('as TRealGrid', 'as TcxGridBandedTableView');

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertMigIssue(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  I: Integer;
  Keywords: TArray<string>;
  ComSuffix: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  // 마이그레이션 자동화 도구 이슈 보정(이슈 해결 후 제거 할 것)
  Datas.Add('XStrGrid1BandedTableView1.DataController.FocusedRowIndex',
      'XStrGrid1.Row');
  Datas.Add('XStrGrid1BandedTableView1.DataController.RecordCount',
      'XStrGrid1.RowCount');
  Datas.Add('XStrGrid1BandedTableView1.ColumnCount',
      'XStrGrid1.ColCount');
  Datas.Add('XStrGrid2BandedTableView1.DataController.RecordCount',
      'XStrGrid2.RowCount');
  Datas.Add('XStrGrid2BandedTableView1.ColumnCount',
      'XStrGrid2.ColCount');
  Datas.Add('XStrGrid3BandedTableView1.DataController.RecordCount',
      'XStrGrid3.RowCount');
  Datas.Add('XStrGrid3BandedTableView1.ColumnCount',
      'XStrGrid3.ColCount');

  Datas.Add('R1.R1.',      'R1.');

  Datas.Add('FocusedColumn.Indexol',      'FocusedColumn.Index');
  Datas.Add('FocusedColumn.Indexl',      'FocusedColumn.Index');

  Datas.Add('Sender.Sender.',      'Sender');
  Datas.Add('DataController.DataController.',      'DataController.');
  Datas.Add(' Save1BandedTableView1.DataController.',      ' RGrid_Save1BandedTableView1.DataController.');

  Datas.Add('SetRGrid1BandedTableView1',      ' SetRGrid');
  Datas.Add('SetRGrid2BandedTableView1',      ' SetRGrid2');
  Datas.Add('SetRGrid3BandedTableView1',      ' SetRGrid3');




  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertOraSession(ASrc: string;
  var ADest: string): Boolean;
var
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Datas.Add('OraSession1.Connect;',     'OraSession1.Open;');
  Datas.Add('OraSession1.Disconnect;',  'OraSession1.Close;');
  Datas.Add('OraSession1.Username',     'OraSession1.Params.Username');
  Datas.Add('OraSession1.Password',     'OraSession1.Params.Password');
  Datas.Add('OraSession1.Server',       'OraSession1.Params.Database');

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertR_Set(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;
  if ASrc.Contains(' R_Set(') and (not ASrc.Contains('BandedTableView1')) then
  begin
    ADest := ASrc.Replace(');', 'BandedTableView1);');
    Result := True;
  end;
end;

function TComFuncConverter.ConvertSetRGrid(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    'SetRGrid.Lines',       'SetRGrid.Color',       'SetRGrid.SelFgColor',
    'SetRGrid.FixedStyle',  'SetRGrid.Indicators',  'SetRGrid.Headers'
  ];

  Datas.Add('SetRGridBandedTableView1.',  'SetRGrid.');
  Datas.Add('SetRGrid : TRealGrid;',  'SetRGrid: TcxGridBandedTableView;');
  Datas.Add('SetRGrid.Clear;',        'SetRGrid.ClearItems;');
  Datas.Add('SetRGrid.SetFocus;',     'SetRGrid.Control.SetFocus;');
  Datas.Add('SetRGrid.CalcFooters;',  'SetRGrid.DataController.Summary.CalculateFooterSummary;');

  Datas.Add('SetRGrid.AddRow;',       'SetRGrid.DataController.AppendRecord;');
  Datas.Add('SetRGrid.Refresh;',      'SetRGrid.DataController.Refresh;');
  Datas.Add('SetRGrid.Post;',         'SetRGrid.DataController.Post;');
  Datas.Add('SetRGrid.Cancel;',       'SetRGrid.DataController.Cancel;');
  Datas.Add('SetRGrid.RowCount',      'SetRGrid.DataController.RecordCount');
  Datas.Add('SetRGrid.Row ',          'SetRGrid.DataController.FocusedRowIndex ');

  Datas.Add('SetRGrid.GroupCount',    'SetRGrid.Bands.Count');
  Datas.Add('SetRGrid.ColCount',      'SetRGrid.ColumnCount');
  Datas.Add('SetRGrid.Columns.Count', 'SetRGrid.ColumnCount');

  Datas.Add('SetRGrid.Headers.Height', 'SetRGrid.OptionsView.HeaderHeight');
  Datas.Add('SetRGrid.GroupMode',     'SetRGrid.OptionsView.BandHeaders');
  Datas.Add('SetRGrid.RowHeight',     'SetRGrid.OptionsView.DataRowHeight');

  Datas.Add('SetRGrid.Col := SetRGrid.Col+1;',
    'SetRGrid.Columns[SetRGrid.Controller.FocusedColumn.Index+1].Focused := True;');
  Datas.Add('SetRGrid.Col := SetRGrid.Col-1;',
    'SetRGrid.Columns[SetRGrid.Controller.FocusedColumn.Index-1].Focused := True;');

  Datas.Add('SetRGrid.Handle',            'SetRGrid.Control.Handle');


  if ADest.Trim.Equals('Clear;') then
    Datas.Add('Clear;', ' ClearItems;');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;

  if ChangeGridVar('SetRGrid', ADest) then
    Result := True;

  if ChangeGridVar('SetRGrid2', ADest) then
    Result := True;

  if ChangeGridVar('tReal', ADest) then
    Result := True;
end;

function TComFuncConverter.ConvertSortOrder(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;

  ADest := ASrc;
  // ' soAscending'
  if ADest.Contains(' soAscending') then
  begin
    ADest := ADest.Replace(' soAscending', ' TcxGridSortOrder.soAscending');
    Result := True;
  end;
  if ADest.Contains(' soDescending') then
  begin
    ADest := ADest.Replace(' soDescending', ' TcxGridSortOrder.soDescending');
    Result := True;
  end;
  if ADest.Contains(' soNone') then
  begin
    ADest := ADest.Replace(' soNone', ' TcxGridSortOrder.soNone');
    Result := True;
  end;

//  if HitColumn.SortOrder<>soAscending then
//    HitColumn.SortOrder:=soAscending;

  // >soAscending
  if ADest.Contains('>soAscending') then
  begin
    ADest := ADest.Replace('>soAscending', '> TcxGridSortOrder.soAscending');
    Result := True;
  end;
  if ADest.Contains('>soDescending') then
  begin
    ADest := ADest.Replace('>soDescending', '> TcxGridSortOrder.soDescending');
    Result := True;
  end;
  if ADest.Contains(' soNone') then
  begin
    ADest := ADest.Replace('>soNone', '> TcxGridSortOrder.soNone');
    Result := True;
  end;

  // =soAscending
  if ADest.Contains('=soAscending') then
  begin
    ADest := ADest.Replace('=soAscending', '= TcxGridSortOrder.soAscending');
    Result := True;
  end;
  if ADest.Contains('=soDescending') then
  begin
    ADest := ADest.Replace('=soDescending', '= TcxGridSortOrder.soDescending');
    Result := True;
  end;
  if ADest.Contains('=soNone') then
  begin
    ADest := ADest.Replace('=soNone', '= TcxGridSortOrder.soNone');
    Result := True;
  end;
end;

function TComFuncConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

//  if ConvertAbsRecover(ADest, ADest) then
//    Result := True;
//  Exit;

  if ConvertSWRcolFind(ADest, ADest) then
    Result := True;
  if ConvertIsAsTRealGrid(AProc, ADest, ADest) then
    Result := True;
  if ConvertSortOrder(ADest, ADest) then
    Result := True;
  if ConvertWinExec(ADest, ADest) then
    Result := True;
  if ConvertOraSession(ADest, ADest) then
    Result := True;

  if ConvertSetRGrid(ADest, ADest) then
    Result := True;
  if ConvertFuncRealGrid(ADest, ADest) then
    Result := True;
  if ConvertFuncParamRealGrid(ADest, ADest) then
    Result := True;
  if ConvertFuncParamUse(AProc, ADest, ADest) then
    Result := True;

  if ConvertGridToView(AProc, ADest, ADest) then
    Result := True;
  if ConvertAbs(ADest, ADest) then
    Result := True;

  if ConvertStyle(ADest, ADest) then
    Result := True;
  if ConvertEtc(AProc, ADest, ADest) then
    Result := True;

  if ConvertMigIssue(AProc, ADest, ADest) then
    Result := True;
end;

function TComFuncConverter.ConvertStyle(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    'SelBgColor'
  ];

//  Datas.Add('AppendStr(sTemp, ''-'')', 'sTemp := sTemp + ''-''');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TComFuncConverter.ConvertSWRcolFind(ASrc: string;
  var ADest: string): Boolean;
const
  // SW_Rcol_Find(RealGrid1,
  // SW_Rcol_Find(RealGrid1BandedTableView1,
  SEARCH_PATTERN  = 'SW_Rcol_Find\(' + GRIDNAME_REGEX + '\,';
  REPLACE_FORMAT  = 'SW_Rcol_Find([[COMP_NAME]]BandedTableView1,';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Comp, Col, Row: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;
    Comp  := TRegEx.Match(Src, '[a-zA-Z\d\_]+\,').Value.Replace(',', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[COMP_NAME]]', Comp);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TComFuncConverter.ConvertWinExec(ASrc: string;
  var ADest: string): Boolean;
const
  // Winexec(pChar('dll.bat FTP'), sw_show);
  // Winexec(PAnsiChar(AnsiString('dll.bat FTP')), sw_show);
  SEARCH_PATTERN  = 'Winexec\([Pp][Cc]har\([\w\''\.\s\+]+\)';
  REPLACE_FORMAT  = 'Winexec(PAnsiChar(AnsiString([[CMD]]))';
var
  I: Integer;
  Matchs: TMatchCollection;
  Match: TMatch;
  Cmd: string;
  Src, Dest: string;
  TagStartIdx, TagEndIdx: Integer;
begin
  Result := False;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;
  ADest := ASrc;
  for I := 0 to Matchs.Count - 1 do
  begin
    Match := Matchs[I];
    Src := Match.Value;
    Cmd  := TRegEx.Match(Src, '\([\w\''\.\s\+]+\)').Value.Replace('(', '').Replace(')', '').Trim;

    Dest := REPLACE_FORMAT;
    Dest := Dest.Replace('[[CMD]]', Cmd);

    ADest := ADest.Replace(Src, Dest);
    Result := True;
  end;
end;

function TComFuncConverter.GetCvtCompClassName: string;
const
  COMP_NAME = '';
begin
  Result := COMP_NAME;
end;

function TComFuncConverter.GetDescription: string;
begin
  Result := 'Common Functions';
end;

initialization
  TConvertManager.Instance.Regist(TComFuncConverter);

end.

