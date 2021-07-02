unit GridConverter;

interface

uses
  SrcConverter;

type
  TGridConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertCustomDrawCell(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertAfterScroll(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertGridOptions(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertKeyPressToKeyDown(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
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

  Inc(Result, ReplaceKeywords(ADest, Datas));
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
  Datas.Add('FStyle',                     'ACanvas.Font.Style');

  Inc(Result, ReplaceKeywords(ADest, Datas));
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
    CompName := GetIndent(ASrc) + REPLACE_FORMAT.Replace('[[COMP_NAME]]', CompName);
    if ASrc.Contains('+') then
    begin
      if ASrc.Contains('wgoEditing') then
        ADest := IfThen(ADest = '', '', ADest + #13#10) + CompName + '.OptionsData.Editing := True;';
      if ASrc.Contains('wgoInserting') then
        ADest := IfThen(ADest = '', '', ADest + #13#10) + CompName + '.OptionsData.Inserting := True;';
    end
    else if ASrc.Contains('-') then
    begin
      if ASrc.Contains('wgoEditing') then
        ADest := IfThen(ADest = '', '', ADest + #13#10) + CompName + '.OptionsData.Editing := False;';
      if ASrc.Contains('wgoInserting') then
        ADest := IfThen(ADest = '', '', ADest + #13#10) + CompName + '.OptionsData.Inserting := False;';
    end
    else
    // Assign
    begin

    end;

    if ADest = '' then
      ADest := ASrc
    else
      Result := 1;
  end;
end;

function TGridConverter.ConvertKeyPressToKeyDown(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not AProc.Contains('EditKeyDown') then
    Exit;

  // #제거
  Datas.Add('Key := #',                   'Key := ');
  Datas.Add('Key = #',                    'Key = ');

  Datas.Add('Key in [',                   'Chr(Key) in [');
  Datas.Add('Key := UpperCase(Key)[1];',  'Key := Ord(UpperCase(Chr(Key))[1]);');

  Inc(Result, ReplaceKeywords(ADest, Datas));
end;

function TGridConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TGridConverter.GetDescription: string;
begin
  Result := '그리드 관련';
end;

initialization
  TConvertManager.Instance.Regist(TGridConverter);
end.
