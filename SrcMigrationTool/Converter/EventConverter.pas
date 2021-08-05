unit EventConverter;

interface

uses
  SrcConverter;

type
  TViewEventConverter = class(TConverter)
  private
    function RealGridOptionToStr(ACompName, ASrc: string): string;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertEditKeyDown_FocusedItemIndex(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertCustomDrawCell_Query(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertFocusedItemChanged_FocusedItem(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertFocusedItemChanged_FocusedItemIndex(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnHeaderClick_HeaderHint(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
  System.StrUtils,
  SrcConvertUtils, System.RegularExpressions,
  System.Classes, System.SysUtils;

{ TGridConverter }

function TViewEventConverter.ConvertColumnHeaderClick_HeaderHint(AProc,
  ASrc: string; var ADest: string): Integer;
begin
  Result := 0;

  if not AProc.Contains('ColumnHeaderClick') then
    Exit;

  if ASrc.Trim = 'inherited;' then
  begin
    ADest := '' +
      '  inherited(*mig*);'#13#10 +
      '  if AColumn.HeaderHint = '''' then Exit;';
    ;
    Inc(Result);
  end;

end;

function TViewEventConverter.ConvertCustomDrawCell_Query(AProc, ASrc: string;
  var ADest: string): Integer;
{
Qry_Master.FieldByName('교육청코드').AsString
Qry_Master.FieldByName('학교코드').AsString
}
const
  SEARCH_PATTERN = '[\w\.]*FieldByName\(';
  REPLACE_FORMAT = 'TcxGridDBBandedTableView(Sender).GetColumnDataByFieldName(AViewInfo, (*TODO*)';
  REPLACE_FORMAT2 = 'TcxGridDBBandedTableView(Sender).GetColumnDataByFieldName(AViewInfo, ';
var
  CompleteUnits: TArray<string>;
  ReplaceFormat: string;
begin
  Result := 0;

  if not AProc.Contains('CustomDrawCell') then
    Exit;

  if FConvData.RootPath.ToLower.Contains('bus') then
  begin
    CompleteUnits := [
      'TbF_006I',
      'TbF_104P',
      'TbF_117P',
      'TbF_119P',
      'TbF_120P',
      'TbF_127P',
      'TbF_129I',
      'TbF_301I',
      'TbF_302I',
      'TbF_311I',
      'TbF_312I',
      'TbF_313I',
      'TbF_314P',
      'TbF_315I',
      'TbF_316I',
      'TbF_321I',
      'TbF_322P',
      'TbF_323P',
      'TbF_338I',
      'TbF_351I',
      'TbF_352I',
      'TbF_353I',
      'TbF_354I',
      'TbF_391IP',
      'TbF_4105P',
      'TbF_4107P',
      'TbF_4201P',
      'TbF_4202P',
      'TbF_4206P',
      'TbF_4301P',
      'TbF_4302P',
      'TbF_4304P',
      'TbF_4305P',
      'TbF_4306P',
      'TbF_4308P',
      'TbF_4401P',
      'TbF_4402P',
      'TbF_4403P',
      'TbF_4404P',
      'TbF_4404_2P',
      'TbF_4406P',
      'TbF_4409P',
      'TbF_4411P',
      'TbF_513I',
      'TbF_513_2I',
      'TmF_IpgoKumSu_I'
      //
      ,
      'TbF_101I',
      'TbF_109P',
      'TbF_4101P',
      'TbF_4102P',
      'TbF_503P'
    ];
  end
  else if FConvData.RootPath.ToLower.Contains('cust') then
  begin
    CompleteUnits := [
      'TbF_101I',
      'TbF_104P',
      'TbF_109P',
      'TbF_311I',
      'TbF_313I',
      'TbF_314P',
      'TbF_315I',
      'TbF_315I_cust',
      'TbF_316I',
      'TbF_316I_cust',
      'TbF_321I',
      'TbF_322P',
      'TbF_323P',
      'TbF_338I',
      'TbF_391IP',
      'TbF_4101P',
      'TbF_4105P',
      'TbF_4107P',
      'TbF_4201P',
      'TbF_4202P',
      'TbF_4206P',
      'TbF_4301P',
      'TbF_4302P',
      'TbF_4304P',
      'TbF_4305P',
      'TbF_4401P',
      'TbF_4402P',
      'TbF_4403P',
      'TbF_4404P',
      'TbF_4404_2P',
      'TbF_4406P',
      'TbF_4409P',
      'TbF_4411P',
      'TbF_301I',
      'TbF_302I',
      'TbF_309I',
      'TbF_310I',
      'TbF_324I',
      'TbF_325I',
      'TbF_4102P',
      'TbF_4111P',
      'TbF_4410P',
      'TbF_503P',
      'TbF_312I'
    ];
  end
  else if FConvData.RootPath.ToLower.Contains('newsupp') then
  begin
    CompleteUnits := [
      'TbF_120P',
      'TbF_4201P',
      'TsF_BalsongMasterI',
      'TbF_120P_20151201'
    ];
  end
  else if FConvData.RootPath.ToLower.Contains('supply') then
  begin
    CompleteUnits := [
      'Sup2011',
      'Sup2071',
      'Sup2081',
      'Sup3041',
      'Sup5041',
      'Sup5051',
      'Sup5071',
      'Sup5081',
      'Sup7003'
    ];
  end;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    if InArrayContains(CompleteUnits, SrcFilename) then
      ReplaceFormat := REPLACE_FORMAT2
    else
      ReplaceFormat := REPLACE_FORMAT;
    if TryRegExGridConvert(ASrc, SEARCH_PATTERN, ReplaceFormat, ADest) then
      Inc(Result);
  end;
end;

function TViewEventConverter.ConvertEditKeyDown_FocusedItemIndex(AProc,
  ASrc: string; var ADest: string): Integer;
begin
  Result := 0;
  if not AProc.Contains('EditKeyDown') then
    Exit;

  if ASrc.Contains('Controller.FocusedItemIndex :=') then
  begin
    if ASrc.Contains('Key := 0;') then
      Exit;

    ADest := ASrc + ' Key := 0;(*mig*)';
    Inc(Result);
  end;
end;

function TViewEventConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Datas.Add('RealDBGrid1CellExit(Self);', 'RealDBGrid1DBBandedTableView1FocusedItemChanged(nil, nil, nil);');

  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TViewEventConverter.ConvertFocusedItemChanged_FocusedItem(AProc,
  ASrc: string; var ADest: string): Integer;
{
(From)
  if  TcxGridDBBandedColumn(RealDBGrid1DBBandedTableView1.Controller.FocusedItem).DataBinding.FieldName = '도서코드' Then begin

(To)
  var FocusedItem: TcxGridDBBandedColumn;
  if not Assigned(AFocuseditem) then
    FocusedItem := TcxGridDBBandedColumn(RealDBGrid1DBBandedTableView1.Controller.FocusedItem)
  else
    FocusedItem := TcxGridDBBandedColumn(APrevFocusedItem);
  if  FocusedItem.DataBinding.FieldName = '도서코드' Then begin


}
const
  SEARCH_PATTTERN = 'TcxGridDBBandedColumn\([\w]+\.Controller\.FocusedItem\)';
var
  I: Integer;
  S: string;
  Matchs: TMatchCollection;
  Comp, Idx: string;
  Src, Dest: string;
  HasDefine: Boolean;
begin
  Result := 0;
  if not AProc.Contains('FocusedItemChanged') then
    Exit;

  Matchs := TRegEx.Matches(ASrc, SEARCH_PATTTERN, [roIgnoreCase]);
  if Matchs.Count = 0 then
    Exit;

  Src := Matchs[0].Value;
  Inc(Result);

  // 2회 이상 나올 수 있으므로 상단에 FocusedItem이 있는지 확인
  HasDefine := False;
  for I := FCurrIndex downto 0 do
  begin
    S := FConvData.Source[I];
    if S.Contains('var FocusedItem:') then
    begin
      HasDefine := True;
      Break;
    end;

    if (S.Trim = 'begin') or S.StartsWith('procedure ') then
      Break;
  end;

  ADest := ASrc.Replace(Src, 'FocusedItem');
  if not HasDefine then
  begin
    ADest := ''
      + '  var FocusedItem: TcxGridDBBandedColumn;'#13#10
      + '  if not Assigned(AFocuseditem) then'#13#10
      + '    FocusedItem := TcxGridDBBandedColumn(RealDBGrid1DBBandedTableView1.Controller.FocusedItem)'#13#10
      + '  else'#13#10
      + '    FocusedItem := TcxGridDBBandedColumn(APrevFocusedItem);'#13#10
      + ADest;
  end;
end;

function TViewEventConverter.ConvertFocusedItemChanged_FocusedItemIndex(AProc,
  ASrc: string; var ADest: string): Integer;
{
RealDBGrid1DBBandedTableView1.Controller.FocusedItemIndex

APrevFocusedItem.Index
}
begin

end;

function TViewEventConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TViewEventConverter.GetDescription: string;
begin
  Result := 'TcxGrid:Event';
end;

function TViewEventConverter.RealGridOptionToStr(ACompName, ASrc: string): string;
begin

end;

initialization
  TConvertManager.Instance.Regist(TViewEventConverter);

end.
