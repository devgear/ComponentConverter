unit RealGridToCXGridConverter;

interface

uses
  RealGridParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRealGridToCXGrid = class(TConverter)
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

{ TConverterRealGridToCXGrid }

uses ObjectTextParser, cxGridTagDefine;

destructor TConverterRealGridToCXGrid.Destroy;
begin
  if Assigned(FParser) then
    FParser.Free;

  inherited;
end;

function TConverterRealGridToCXGrid.GetDescription: string;
begin
  Result := 'RealGrid to cxGrid 변환';
end;

function TConverterRealGridToCXGrid.GetComponentClassName: string;
begin
  Result := 'TRealGrid';
end;

function TConverterRealGridToCXGrid.GetConvertCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TConverterRealGridToCXGrid.GetMainUsesUnit: string;
begin
  Result := 'cxGrid';
end;

function TConverterRealGridToCXGrid.GetAddedUses: TArray<string>;
begin
  Result := [
      'RealGridTocxGridHelper', 'CommonModule', 'Variants',
      'cxGraphics', 'cxControls', 'cxLookAndFeels', 'cxLookAndFeelPainters','cxStyles',
      'cxCustomData', 'cxFilter', 'cxData', 'cxDataStorage', 'cxEdit',
      'cxNavigator','dxDateRanges', 'cxDataControllerConditionalFormattingRulesManagerDialog',
      'cxTextEdit', 'cxCurrencyEdit', 'cxCheckBox', 'cxGridLevel', 'cxGridCustomTableView',
      'cxGridTableView', 'cxGridBandedTableView',  'cxClasses', 'cxGridCustomView', 'cxGrid'
    ];
end;

function TConverterRealGridToCXGrid.GetRemoveUses: TArray<string>;
begin
  Result := ['URGrids', 'URMGrid'];
end;

function TConverterRealGridToCXGrid.GetConvertCompList(AMainCompName: string): string;
var
  ViewName, LevelName: string;
begin
  ViewName  := AMainCompName + 'BandedTableView1';
  LevelName := AMainCompName + 'Level1';
  Result := '';
  Result := Result + #13#10'    ' + ViewName + ': TcxGridBandedTableView;';
  Result := Result + FColumnCompList;
  Result := Result + #13#10'    ' + LevelName + ': TcxGridLevel;';
end;

function TConverterRealGridToCXGrid.GetConvertedCompText(ACompText: TStrings): string;
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
begin
  if not Assigned(FParser) then
    FParser.Free;
  FParser := TRealGridParser.Create;

  FParser.Parse(ACompText.Text);

  GridName  := FParser.CompName;
  ViewName  := GridName + 'BandedTableView1';
  LevelName := GridName + 'Level1';
  ColName   := ViewName + 'BandedColumn%d';

  GridText := TAG_CXGRID_COMP;
  GridText := GridText.Replace('[[COMP_NAME]]',       GridName);
  GridText := GridText.Replace('[[VIEW_NAME]]',       ViewName);
  GridText := GridText.Replace('[[LEVEL_NAME]]',      LevelName);

  GridText := GridText.Replace('[[COMP_LEFT]]',       FParser.Properties.ValuesDef['Left', '0']);
  GridText := GridText.Replace('[[COMP_TOP]]',        FParser.Properties.ValuesDef['Top', '0']);
  GridText := GridText.Replace('[[COMP_WIDTH]]',      FParser.Properties.ValuesDef['Width', '0']);
  GridText := GridText.Replace('[[COMP_HEIGHT]]',     FParser.Properties.ValuesDef['Height', '0']);
  GridText := GridText.Replace('[[COMP_ALIGN]]',      FParser.Properties.ValuesDef['Align', 'alNone']);

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

    GroupList := GroupList + GroupText;
    if GroupInfo.TitleVisible then
      ShowBand := True;
  end;
  if GroupList = '' then
    GroupList := TAG_CXGRID_GROUP_NULL;
  GridText := GridText.Replace('[[GROUP_LIST]]', GroupList);
  GridText := GridText.Replace('[[BAND_HEADERS]]', BoolToStr(ShowBand, True));

  // 컬럼 설정
  ColList := '';
  FooterItems := '';
  FColumnCompList := ''; //GetConvertCompList에서 사용할 컬럼 컴포넌트 목록
  Idx := 1;
  for ColumnInfo in FParser.ColumnInfos do
  begin
    if Length(ColumnInfo.Items) > 0 then
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
    else if ColumnInfo.DataType = 'wdtFloat' then
    begin
      ColText := TAG_CXGRID_COLUMN_FLT;
      ColText := ColText.Replace('[[DISPLAY_FORMAT]]', ColumnInfo.DisplayFormat);
    end
    else if ColumnInfo.DataType = 'wdtDate' then
    begin
      ColText := TAG_CXGRID_COLUMN_DATE
    end
    else if ColumnInfo.DataType = 'wdtBool' then
    begin
      ColText := TAG_CXGRID_COLUMN_BOOL
    end
    else
      ColText := TAG_CXGRID_COLUMN_DEF;

    FColumnCompList := FColumnCompList + #13#10'    ' + Format(ColName, [Idx]) + ': TcxGridBandedColumn;';

    ColText := ColText.Replace('[[COLUMN_NAME]]',     Format(ColName, [Idx]));
    ColText := ColText.Replace('[[COLUMN_CAPTION]]',  ColumnInfo.TitleCaption);
    // RealGrid Group이 미지정(-1)인 경우 컬럼 감춤
    if ColumnInfo.Group = -1 then
      ColText := ColText.Replace('[[VISIBLE]]',         'False')
    else
      ColText := ColText.Replace('[[VISIBLE]]',       BoolToStr(ColumnInfo.Visible, True));
    ColText := ColText.Replace('[[READONLY]]',        BoolToStr(ColumnInfo.ReadOnly, True));
    ColText := ColText.Replace('[[BAND_INDEX]]',      IntToStr(ColumnInfo.Group));
    ColText := ColText.Replace('[[WIDTH]]',           IntToStr(ColumnInfo.Width));
    ColText := ColText.Replace('[[COL_INDEX]]',       IntToStr(ColumnInfo.LevelIndex));

    ColList := ColList + ColText;

    // Footer 처리
    if ColumnInfo.FooterStyle <> '' then
    begin
      FooterItem := TAG_CXGRID_FOOTER_ITEM;
      FooterItem := FooterItem.Replace('[[FOOTER_KIND]]', ColumnInfo.FooterStyle);
      FooterItem := FooterItem.Replace('[[FOOTER_COLUMN]]', Format(ColName, [Idx]));

      FooterItems := FooterItems + FooterItem;
    end;

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
// eg   DataController.OnAfterDelete = cxGrid1BandedTableView1DataControllerAfterDelete
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

function TConverterRealGridToCXGrid.GetCompEventInfos(AFormClass: string): TArray<TCompEventInfo>;
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
  ViewName  := GridName + 'BandedTableView1';

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

function TConverterRealGridToCXGrid.IsWantWriteEvnetCodeToPas: Boolean;
begin
  Result := True;
end;

initialization
  TConvertManager.Instance.Regist(TConverterRealGridToCXGrid);

end.
