unit GridConverter;

interface

uses
  SrcConverter;

type
  TGridConverter = class(TConverter)
  private
    function RealGridOptionToStr(ACompName, ASrc: string): string;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
    function GetCvtBaseClassName: string; override;
  published
    [Impl]
    function ConvertWithGrid(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertCustomDrawCell(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertAfterScroll(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGridOptions(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGridOptions2(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGridOptionsCopy(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGridRowHeight(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGridHeaderHeight(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertKeyPressToKeyDown(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertDBFooterComment(AProc, ASrc: string; var ADest: string): Integer;

    [Intf]
    function ConvertRemoveNotUsedIntf(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertRemoveNotUsed(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertBuildFromDataSet(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
  System.StrUtils,
  SrcConvertUtils,
  System.Classes, System.SysUtils;

{ TSelectedConverter }

function TGridConverter.ConvertAfterScroll(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not AProc.Contains('AfterScroll') then
    Exit;

  Datas.Add('inherited;',
    'inherited{};'#13#10 +
    '  if DataSet.ControlsDisabled then'#13#10 +
    '    Exit;'
  );

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TGridConverter.ConvertBuildFromDataSet(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Bb]uild[Ff]rom[Dd]ata[Ss]et';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.DataController.CreateAllItems';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGridConverter.ConvertCustomDrawCell(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not AProc.Contains('CustomDrawCell') then
    Exit;

  Datas.Add('AColumn.Index',              'AViewInfo.Item.Index');
  Datas.Add('(AColumn <> nil)',           '(AViewInfo.Item <> nil)');
  Datas.Add('BCol',                       'ACanvas.Brush.Color');
  Datas.Add('FCol',                       'ACanvas.Font.Color');
  Datas.Add('fCol',                       'ACanvas.Font.Color');
  Datas.Add('FStyle',                     'ACanvas.Font.Style');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TGridConverter.ConvertDBFooterComment(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Keywords: TArray<string>;
begin
  Result := 0;
//  if not SrcFilename.Contains('TbF_206P') then
//    Exit;

  if not AProc.Contains('Rtrv') then
    Exit;

  Keywords := [
    'DBFooter'
  ];

  Inc(Result, AddComments(ADest, Keywords));
end;

function TGridConverter.RealGridOptionToStr(ACompName, ASrc: string): string;
var
  IsAdded: string;
begin
  Result := '';
  ASrc := ASrc.ToLower;
  IsAdded := IfThen(ASrc.Contains('+'), 'True', 'False');
  if ASrc.Contains('wgoEditing'.ToLower) then
    Result := IfThen(Result = '', '', Result + #13#10) + ACompName + Format('.OptionsData.Editing := %s;', [IsAdded]);
  if ASrc.Contains('wgoInserting'.ToLower) then
    Result := IfThen(Result = '', '', Result + #13#10) + ACompName + Format('.OptionsData.Inserting := %s;', [IsAdded]);
  if ASrc.Contains('wgoAlwaysShowEditor'.ToLower) then
    Result := IfThen(Result = '', '', Result + #13#10) + ACompName + Format('.OptionsBehavior.ImmediateEditor := %s;', [IsAdded]);
  if ASrc.Contains('wgoDeleting'.ToLower) then
    Result := IfThen(Result = '', '', Result + #13#10) + ACompName + Format('.OptionsData.Deleting := %s;', [IsAdded]);
end;

function TGridConverter.ConvertGridHeaderHeight(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Hh]eaders\.[Hh]eight';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.OptionsView.HeaderHeight';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGridConverter.ConvertGridOptions(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Oo]ptions\s[\+\-]\s\[wgo';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1';
var
  AddOpt: Boolean;
  CompName: string;
begin
  Result := 0;
  ADest := ASrc;

  if IsContainsRegExCompName(ASrc, SEARCH_PATTERN, CompName) then
  begin
    ADest := '';
    CompName := TConvUtils.GetIndent(ASrc) + REPLACE_FORMAT.Replace('[[COMP_NAME]]', CompName);
    ADest := RealGridOptionToStr(CompName, ASrc);

    if ADest = '' then
      ADest := ASrc
    else
      Result := 1;
  end;
end;

{
         RDBGridMaster.Options := RDBGridMaster.Options
                                - [wgoAlwaysShowEditor, wgoEditing];
}
function TGridConverter.ConvertGridOptions2(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN = '(\+|\-)*[\s]*\[wgo[\w\,\s]+\]\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1';
var
  CompName: string;
  SrcPrv: string;
begin
  Result := 0;
  ADest := ASrc;

  if IsContainsRegExCompName(ASrc, SEARCH_PATTERN, CompName) then
  begin
    if CompName <> '' then
      Exit;
    SrcPrv := FConvData.Source[FCurrIndex - 1];
    CompName  := TConvUtils.GetCompName(SrcPrv);
    CompName := TConvUtils.GetIndent(SrcPrv) + REPLACE_FORMAT.Replace('[[COMP_NAME]]', CompName);

    ADest := RealGridOptionToStr(CompName, ASrc);
    if ADest = '' then
    begin
      ADest := ASrc;
      Exit;
    end;

    FConvData.Source[FCurrIndex - 1] := '// ' + SrcPrv;
    Result := 1;
  end;
end;

function TGridConverter.ConvertGridOptionsCopy(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Oo]ptions[\s]*\:\=[\s]*' + GRIDNAME_REGEX +'\.[Oo]ptions\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1';
var
  Tmp, Indent: string;
  CompName, LCompName, RCompName: string;
begin
  Result := 0;
  ADest := ASrc;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    Tmp := Copy(ASrc, 1, ASrc.IndexOf(':='));
    CompName := TConvUtils.GetCompName(Tmp);
    LCompName := REPLACE_FORMAT.Replace('[[COMP_NAME]]', CompName);

    Tmp := Copy(ASrc, ASrc.IndexOf(':='), Length(ASrc));
    CompName := TConvUtils.GetCompName(Tmp);
    RCompName := REPLACE_FORMAT.Replace('[[COMP_NAME]]', CompName);

    Indent := TConvUtils.GetIndent(ASrc);

    ADest := '';
    ADest := ADest + Indent + LCompName + '.OptionsData.Editing := ' + RCompName + '.OptionsData.Editing;'#13#10;
    ADest := ADest + Indent + LCompName + '.OptionsData.Inserting := ' + RCompName + '.OptionsData.Inserting;'#13#10;
    ADest := ADest + Indent + LCompName + '.OptionsData.Deleting := ' + RCompName + '.OptionsData.Deleting;'#13#10;
    ADest := ADest + Indent + LCompName + '.OptionsBehavior.ImmediateEditor := ' + RCompName + '.OptionsBehavior.ImmediateEditor;'#13#10;

    Inc(Result);
  end;
end;

function TGridConverter.ConvertGridRowHeight(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Rr]owHeight';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.OptionsView.DataRowHeight';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGridConverter.ConvertKeyPressToKeyDown(AProc, ASrc: string;
  var ADest: string): Integer;
{
if ((Key < '0') or (Key > '9')) and (Key <> ',') and (Key <> #8 ) and (Key <> #13 ) and (Key <> #27 )
}
var
  I: Integer;
  Datas: TChangeDatas;
begin
  Result := 0;

  if not AProc.Contains('EditKeyDown') then
    Exit;

  Datas.Add('key =',         'Key =');

  // #제거
  Datas.Add('Key := #',         'Key := ');
  Datas.Add('Key = #',          'Key = ');
  Datas.Add('Key <> #',         'Key <> ');

  Datas.Add('Key < ''0''',      'Key < Ord(''0'')');
  Datas.Add('Key > ''9''',      'Key > Ord(''9'')');
  Datas.Add('Key <> '',''',     'Key <> Ord('','')');

  for I := 0 to 9 do
  begin
    Datas.Add('Key = ''' + IntToStr(I) + '''',    'Key = Ord(''' + IntToStr(I) + ''')');
    Datas.Add('Key := ''' + IntToStr(I) + '''',   'Key := Ord(''' + IntToStr(I) + ''')');
  end;

  Datas.Add('Key = ''+''',          'Key = Ord(''+'')');

  Datas.Add('Key in [',                   'Chr(Key) in [');
  Datas.Add('Key := UpperCase(Key)[1];',  'Key := Ord(UpperCase(Chr(Key))[1]);');

  Datas.Add('.AsString <> Key',                   '.AsString <> Char(Key)');
  // Acct
  Datas.Add('AcctSave2(Key);',                   'AcctSave2(Char(Key));');
  Datas.Add('TempKey : Char;',                   'TempKey : Word;');
  Datas.Add('TempKey = ''+''',                   'TempKey = Ord(''+'')');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TGridConverter.ConvertRemoveNotUsed(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;
  if SrcFilename.Contains('TaF_467IP') then
  begin
    if AProc = 'RealDBGrid1DrawCell' then
    begin
      if (ASrc.Trim = '') or (ASrc.Trim.StartsWith('//')) then
        Exit;

      ADest := '// ' + ASrc;
      Inc(Result);
    end;
  end;
end;

function TGridConverter.ConvertRemoveNotUsedIntf(AProc, ASrc: string;
  var ADest: string): Integer;
begin
  Result := 0;
  if SrcFilename.Contains('TaF_467IP') then
  begin
    if ASrc.Contains('procedure RealDBGrid1DrawCell') then
    begin
      ADest := '// ' + ASrc;
      FConvData.Source[FCurrIndex+1] := '// ' + FConvData.Source[FCurrIndex+1];
      Inc(Result);
    end;
  end;
end;

function TGridConverter.ConvertWithGrid(AProc, ASrc: string;
  var ADest: string): Integer;
// with RDBGridMaster1 do begin
  // with RDBGridMaster1 do begin
const
  SEARCH_PATTERN  = '[Ww]ith\s' + GRIDNAME_REGEX + '\sdo';
  REPLACE_FORMAT  = 'with [[COMP_NAME]]DBBandedTableView1 do';
begin
  Result := 0;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TGridConverter.GetCvtBaseClassName: string;
begin
  Result := 'TfrmTzzRealMaster2';
end;

function TGridConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TGridConverter.GetDescription: string;
begin
  Result := 'TcxGrid:Grid';
end;

function TGridConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
  Keywords: TArray<string>;
begin
  Result := 0;
  ADest := ASrc;

  Keywords := [
    '.GroupMode := ',
    '.ImeMode := '
  ];

  // 제거
  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
  Inc(Result, AddComments(ADest, Keywords));
end;

initialization
  TConvertManager.Instance.Regist(TGridConverter);
end.
