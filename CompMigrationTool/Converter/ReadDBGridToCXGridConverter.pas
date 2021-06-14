unit ReadDBGridToCXGridConverter;

interface

uses
  RealGridParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRealDBGridToCXGrid = class(TConverter)
  private
    FParser: TRealGridParser;
    FColumnCompList: string;
  protected
    function GetDescription: string; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetConvertCompList(AMainCompName: string): string; override;

    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;
    function GetMainUsesUnit: string; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;

    // PAS 파일에 이벤트 추가
    function IsWantWriteEvnetCodeToPas: Boolean; override;
    function GetCompEventInfos(AFormClass: string): TArray<TCompEventInfo>; override;
  public
    destructor Destroy; override;
  end;

implementation

uses ObjectTextParser, cxDBGridTagDefine;

{ TConverterRealDBGridToCXGrid }

function TConverterRealDBGridToCXGrid.GetDescription: string;
begin
  Result := 'RealDBGrid to cxGrid 변환';
end;

destructor TConverterRealDBGridToCXGrid.Destroy;
begin
  if Assigned(FParser) then
    FParser.Free;

  inherited;
end;

function TConverterRealDBGridToCXGrid.GetCompEventInfos(
  AFormClass: string): TArray<TCompEventInfo>;

  function GetEventNameFromIntfCode(ACode: string): string;
  var
    SIdx, EIdx: Integer;
  begin
    SIdx := Pos('procedure ', ACode) + 10;
    EIdx := Pos('(', ACode);
    Result := Copy(ACode, SIdx, EIdx-SIdx);
  end;

const
  INDENT = '    ';
var
  GridName, ViewName, CompCode: string;
  RGEvent: TRealGridEventInfo;
  TagInfo: TEventTagInfo;
  CodeInfo: TCompEventInfo;
begin
  GridName  := FParser.CompName;
  ViewName  := GridName + 'DBBandedTableView1';

  for RGEvent in FParser.EventInfos do
  begin
    if GetEventTagInfo(RGEvent.Prop, TagInfo) then
    begin
      CodeInfo := Default(TCompEventInfo);
      // 일부 이벤트 무시(에러 발생)
      if TagInfo.EventOwner <> eoIgnore then
      begin
        CompCode := INDENT + TagInfo.ProcTag;
        CompCode := CompCode.Replace('[[FORMCLASS_NAME]]', '');
        CompCode := CompCode.Replace('[[GRID_NAME]]', GridName);
        CompCode := CompCode.Replace('[[VIEW_NAME]]', ViewName);
        CompCode := CompCode.Replace('[[EVENT_NAME]]', TagInfo.EventName);

        CodeInfo.IntfCode := CompCode;
        CodeInfo.EventName := GetEventNameFromIntfCode(CompCode);

        CompCode := TagInfo.ProcTag;
        CompCode := CompCode.Replace('[[FORMCLASS_NAME]]', AFormClass+'.');
        CompCode := CompCode.Replace('[[GRID_NAME]]', GridName);
        CompCode := CompCode.Replace('[[VIEW_NAME]]', ViewName);
        CompCode := CompCode.Replace('[[EVENT_NAME]]', TagInfo.EventName);

  //      CompCode := CompCode + 'begin'#13#10;
  //      CompCode := CompCode + '  [[IMPL_MSG]]'#13#10;
  //      CompCode := CompCode + Format('//  {$Message Error ''기 구현된 [%s] 메소드를 참고해 다시 구현하세요.''}'#13#10, [RGEvent.Value]);
  //      CompCode := CompCode + 'end;'#13#10;

        CodeInfo.ImplCode := CompCode;
      end;
      CodeInfo.BeforeEventName := RGEvent.Value;

      Result := Result + [CodeInfo];
    end;
  end;
end;

function TConverterRealDBGridToCXGrid.GetComponentClassName: string;
begin
  Result := 'TRealDBGrid';
end;

function TConverterRealDBGridToCXGrid.GetConvertCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TConverterRealDBGridToCXGrid.GetConvertCompList(
  AMainCompName: string): string;
var
  ViewName, LevelName: string;
begin
  ViewName  := AMainCompName + 'DBBandedTableView1';
  LevelName := AMainCompName + 'Level1';
  Result := '';
  Result := Result + #13#10'    ' + ViewName + ': TcxGridDBBandedTableView;';
  Result := Result + FColumnCompList; // 컬럼목록
  Result := Result + #13#10'    ' + LevelName + ': TcxGridLevel;';
end;

function TConverterRealDBGridToCXGrid.GetConvertedCompText(
  ACompText: TStrings): string;
var
  Idx: Integer;
  GridName, ViewName, LevelName, ColName: string;
  GridText, ColText, ColList, GroupText, GroupList: string;

  GridEvent, ViewEvent, DataEvent: string;

  ColumnInfo: TRealGridColumnInfo;
  GroupInfo: TRealGridGroupInfo;
  EventInfo: TRealGridEventInfo;
  EventTagInfo: TEventTagInfo;

  I: Integer;
  Item, Value, ItemText, ItemsText: string;
  FooterItem, FooterItems: string;
  ShowBand: Boolean;

  SeqColIdx: Integer;
  NoGroup: Boolean;
  RowHeight, HeadHeight: Integer;
begin
  if not Assigned(FParser) then
    FParser.Free;
  FParser := TRealGridParser.Create;

  FParser.Parse(ACompText.Text);

  GridName  := FParser.CompName;
  ViewName  := GridName + 'DBBandedTableView1';
  LevelName := GridName + 'Level1';
  ColName   := ViewName + 'Column%d';

  GridText := TAG_CXGRID_COMP;
  GridText := GridText.Replace('[[COMP_NAME]]',       GridName);
  GridText := GridText.Replace('[[VIEW_NAME]]',       ViewName);
  GridText := GridText.Replace('[[LEVEL_NAME]]',      LevelName);

  GridText := GridText.Replace('[[COMP_LEFT]]',       FParser.Properties.ValuesDef['Left', '0']);
  GridText := GridText.Replace('[[COMP_TOP]]',        FParser.Properties.ValuesDef['Top', '0']);
  GridText := GridText.Replace('[[COMP_WIDTH]]',      FParser.Properties.ValuesDef['Width', '0']);
  GridText := GridText.Replace('[[COMP_HEIGHT]]',     FParser.Properties.ValuesDef['Height', '0']);
  GridText := GridText.Replace('[[COMP_ALIGN]]',      FParser.Properties.ValuesDef['Align', 'alNone']);

  GridText := GridText.Replace('[[TAB_ORDER]]',      FParser.Properties.ValuesDef['TabOrder', '0']);
  GridText := GridText.Replace('[[DATASOURCE]]',      FParser.Properties.ValuesDef['DataSource', 'nil']);

  GridText := GridText.Replace('[[POPUP_MENU]]',      FParser.Properties.ValuesDef['PopupMenu', 'nil']);

  GridText := GridText.Replace('[[FOOTER_VISIBLE]]',  BoolToStr(FParser.FooterVisible, True));


  // 밴드(그룹) 설정
  GroupList := '';
  ShowBand := False;
  for GroupInfo in FParser.GroupInfos do
  begin
    GroupText := TAG_CXGRID_GROUP;
    GroupText := GroupText.Replace('[[CAPTION]]', GroupInfo.TitleCaption);
    GroupText := GroupText.Replace('[[VISIBLE]]', BoolToStr(GroupInfo.Visible, True));
    GroupText := GroupText.Replace('[[WIDTH]]',   IntToStr(GroupInfo.Width));

    if GroupInfo.TitleColor = '' then
      GroupText := GroupText.Replace('[[STYLE_HEADER]]', '')
    else
      GroupText := GroupText.Replace('[[STYLE_HEADER]]', 'Styles.Header = ' + GetColorToStyleName(GroupInfo.TitleColor));

    GroupList := GroupList + GroupText;
    if GroupInfo.TitleVisible then
      ShowBand := True;
  end;

  NoGroup := False;
  if GroupList = '' then
  begin
    GroupList := TAG_CXGRID_GROUP_NULL;
    NoGroup := True;
  end;

  GridText := GridText.Replace('[[GROUP_LIST]]', GroupList);
  GridText := GridText.Replace('[[BAND_HEADERS]]', BoolToStr(ShowBand, True));

  if NoGroup then
  begin
    GridText := GridText.Replace('[[BAND_HEADER_HEIGHT]]', '0');
    GridText := GridText.Replace('[[HEADER_HEIGHT]]',      FParser.Properties.ValuesDef['Headers.ColHeight', '0']);
  end
  else
  begin
    if ShowBand then
    begin
      RowHeight := StrToIntDef(FParser.Properties.ValuesDef['GrpRowHeight', '25'], 25);
      HeadHeight := StrToIntDef(FParser.Properties.ValuesDef['Headers.GrpHeight', '50'], 50);
      GridText := GridText.Replace('[[BAND_HEADER_HEIGHT]]', IntToStr(HeadHeight - RowHeight));
      GridText := GridText.Replace('[[HEADER_HEIGHT]]',      FParser.Properties.ValuesDef['GrpRowHeight', '0']);
    end
    else
    begin
      GridText := GridText.Replace('[[BAND_HEADER_HEIGHT]]', '0');
      GridText := GridText.Replace('[[HEADER_HEIGHT]]',      FParser.Properties.ValuesDef['Headers.GrpHeight', '0']);
    end;
  end;
  GridText := GridText.Replace('[[DATAROW_HEIGHT]]',     FParser.Properties.ValuesDef['RowHeight', '25']);

  // 컬럼 설정
  ColList := '';
  FooterItems := '';
  FColumnCompList := ''; //GetConvertCompList에서 사용할 컬럼 컴포넌트 목록
  Idx := 1;
  SeqColIdx := 0;
  for ColumnInfo in FParser.ColumnInfos do
  begin
    if ColumnInfo.EditStyle = 'wesCheckBox' then
    begin
      ColText := TAG_CXGRID_COLUMN_BOOL;
    end
    else if Length(ColumnInfo.Items) > 0 then
    begin
      ColText := TAG_CXGRID_COLUMN_ITEMS;
      ItemsText := '';
      for I := 0 to Length(ColumnInfo.Items) - 1 do
      begin
        Item := ColumnInfo.Items[I];
        if Length(ColumnInfo.Values) > I then
          Value := ColumnInfo.Values[I]
        else
          Value := '';

        ItemText := TAG_CXGRID_COLUMN_ITEM;
        ItemText := ItemText.Replace('[[ITEM]]',  Item);
        ItemText := ItemText.Replace('[[VALUE]]', Value);

        ItemsText := ItemsText + ItemText;
      end;

      ColText := ColText.Replace('[[ITEMS]]', ItemsText);
    end
    else
    begin
      ColText := TAG_CXGRID_COLUMN_DEF;
    end;

    FColumnCompList := FColumnCompList + #13#10'    ' + Format(ColName, [Idx]) + ': TcxGridDBBandedColumn;';

    ColText := ColText.Replace('[[COLUMN_NAME]]',     Format(ColName, [Idx]));
    ColText := ColText.Replace('[[COLUMN_CAPTION]]',  ColumnInfo.TitleCaption);
    // RealGrid Group이 미지정(-1)인 경우 컬럼 감춤
    if (not NoGroup) and (ColumnInfo.Group = -1) then
      ColText := ColText.Replace('[[VISIBLE]]',         'False')
    else
      ColText := ColText.Replace('[[VISIBLE]]',       BoolToStr(ColumnInfo.Visible, True));
    ColText := ColText.Replace('[[READONLY]]',        BoolToStr(ColumnInfo.ReadOnly, True));

    // 리얼그리드에서 Group과 LevelIndex를 설정하지 않은 경우(TbF_0006I)
      // BandIndex = 0, ColIndex는 순번(0..)으로 설정해야 함
    if NoGroup then
    begin
      ColText := ColText.Replace('[[BAND_INDEX]]',      '0');
      ColText := ColText.Replace('[[COL_INDEX]]',       IntToStr(SeqColIdx));
      ColText := ColText.Replace('[[WIDTH]]',           IntToStr(ColumnInfo.ColWidth));
      Inc(SeqColIdx);
    end
    else
    begin
      ColText := ColText.Replace('[[BAND_INDEX]]',      IntToStr(ColumnInfo.Group));
      ColText := ColText.Replace('[[COL_INDEX]]',       IntToStr(ColumnInfo.LevelIndex));
      ColText := ColText.Replace('[[WIDTH]]',           IntToStr(ColumnInfo.GrpWidth));
    end;

    ColText := ColText.Replace('[[HORZ_ALIGN]]',      ColumnInfo.Alignment);
    ColText := ColText.Replace('[[FIELD_NAME]]',      ColumnInfo.FieldName);
    ColText := ColText.Replace('[[ROW_INDEX]]',       IntToStr(ColumnInfo.Level));

    // cxGridView의 Column.Position.LineCount는 라인 몇칸을 차지할지 설정
      // 리얼그리드는 그룹의 Levels는 몇행을 표시할지 설정
      // 즉, RG.Levels가 1이면 CX.LineCount는 전체 해더 행수를 설정해야 함
    if (ColumnInfo.Group > -1) and (FParser.GroupInfos.Count > ColumnInfo.Group) then
    begin
      GroupInfo := FParser.GroupInfos[ColumnInfo.Group];
      if GroupInfo.Levels = 1 then
        ColText := ColText.Replace('[[LINE_COUNT]]',       IntToStr(FParser.GroupMaxLevels))
      else
        ColText := ColText.Replace('[[LINE_COUNT]]',       '1');
    end
    else
      ColText := ColText.Replace('[[LINE_COUNT]]',       '1');

    if ColumnInfo.Color = '' then
      ColText := ColText.Replace('[[STYLE_CONTENT]]', '')
    else
      ColText := ColText.Replace('[[STYLE_CONTENT]]', 'Styles.Content = ' + GetColorToStyleName(ColumnInfo.Color));

    if ColumnInfo.TitleColor = '' then
      ColText := ColText.Replace('[[STYLE_HEADER]]', '')
    else
      ColText := ColText.Replace('[[STYLE_HEADER]]', 'Styles.Header = ' + GetColorToStyleName(ColumnInfo.TitleColor));



    ColList := ColList + ColText;

//    // Footer 처리
//    if ColumnInfo.FooterStyle <> '' then
//    begin
//      FooterItem := TAG_CXGRID_FOOTER_ITEM;
//      FooterItem := FooterItem.Replace('[[FOOTER_KIND]]', ColumnInfo.FooterStyle);
//      FooterItem := FooterItem.Replace('[[FOOTER_COLUMN]]', Format(ColName, [Idx]));
//
//      FooterItems := FooterItems + FooterItem;
//    end;

    Inc(Idx);
  end;
  GridText := GridText.Replace('[[COLUMN_LIST]]', ColList);
  GridText := GridText.Replace('[[FOOTER_ITEMS]]', FooterItems);

  // 이벤트
  GridEvent := '';
  ViewEvent := '';
  DataEvent := '';
  for EventInfo in FParser.EventInfos do
  begin
    if GetEventTagInfo(EventInfo.Prop, EventTagInfo) then
    begin
// eg   OnEnter = RealGrid1Enter
//        On[이벤트명] = [그리드이름][이벤트명]
// eg   DataController.OnAfterDelete = cxGrid1DBBandedTableView1DataControllerAfterDelete
//        DataController.On[이벤트명] = [뷰명]DataController[이벤트명]
      case EventTagInfo.EventOwner of
        eoGrid:
          GridEvent := GridEvent + '  On' + EventTagInfo.EventName +
              ' = ' + GridName + EventTagInfo.EventName +  #13#10;
        eoView:
          ViewEvent := ViewEvent + '  On' + EventTagInfo.EventName +
              ' = ' + ViewName + EventTagInfo.EventName +  #13#10;
        eoData:
          DataEvent := DataEvent + '  DataController.On' + EventTagInfo.EventName +
              ' = ' + ViewName + 'DataController' + EventTagInfo.EventName +  #13#10;
        eoDataSummury:
          DataEvent := DataEvent + '  DataController.Summary.On' + EventTagInfo.EventName +
              ' = ' + ViewName + 'DataControllerSummary' + EventTagInfo.EventName +  #13#10;
      end;
    end;
  end;
  GridText := GridText.Replace('[[GRID_EVENT]]', GridEvent);
  GridText := GridText.Replace('[[VIEW_EVENT]]', ViewEvent);
  GridText := GridText.Replace('[[DATA_EVENT]]', DataEvent);

  Result := GridText;
end;

function TConverterRealDBGridToCXGrid.GetMainUsesUnit: string;
begin
  Result := 'cxGrid';
end;

function TConverterRealDBGridToCXGrid.GetAddedUses: TArray<string>;
begin
  Result := [
      'Variants', 'TzzU_DataBase',
      'cxGridLevel', 'cxGridCustomTableView',
      'cxGridTableView', 'cxGridBandedTableView', 'cxGridDBBandedTableView', 'cxClasses',
      'cxGridCustomView', 'cxGrid', 'cxGraphics', 'cxControls', 'cxLookAndFeels',
      'cxLookAndFeelPainters', 'cxStyles', 'cxCustomData', 'cxFilter',
      'cxData', 'cxDataStorage', 'cxEdit', 'cxNavigator', 'dxDateRanges',
      'dxScrollbarAnnotations', 'cxDBData', 'cxTextEdit'
    ];
{
  cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxTextEdit
}
end;

function TConverterRealDBGridToCXGrid.GetRemoveUses: TArray<string>;
begin
  Result := ['URGrids', 'URDBGrid'];
end;

function TConverterRealDBGridToCXGrid.IsWantWriteEvnetCodeToPas: Boolean;
begin
  Result := True;
end;

initialization
  TConvertManager.Instance.Regist(TConverterRealDBGridToCXGrid);

end.
