unit ReadDBGridToCXGridConverter;

interface

uses
  CompConverterTypes,
  RealGridParser, System.Generics.Collections,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterRealDBGridToCXGrid = class(TConverter)
  private
    FParser: TRealGridParser;
    FColumnCompList: string;

    function GetCustomEventPropName(APropName: string): string;
  protected
    function GetDescription: string; override;

    function GetCustomHiddenColumns(AFilename, AGridName: string): TArray<string>;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetConvertCompList(AMainCompName: string): string; override;

    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    // PAS 파일에 이벤트 추가
    function IsWantWriteEvnetCodeToPas: Boolean; override;
    function GetCompEventInfos(AFormClass: string): TArray<TCompEventInfo>; override;
  public
    destructor Destroy; override;
  end;

implementation

uses ObjectTextParser, cxDBGridTagDefine, ConvertUtils, System.StrUtils;

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

  function ContainItem(AArray: TArray<TCompEventInfo>; AItem: string): Boolean;
  var
    Conv: TCompEventInfo;
  begin
    Result := False;
    for Conv in AArray do
      if Conv.BeforeEventName = AItem then
        Exit(True);
  end;
const
  INDENT = '    ';
var
  GridName, ViewName, CompCode: string;
  RGEvent: TRealGridEventInfo;
  TagInfo: TEventTagInfo;
  CodeInfo: TCompEventInfo;
  ProcTag, PropName: string;
  I: Integer;
begin
  GridName  := FParser.CompName;
  ViewName  := GridName + 'DBBandedTableView1';

  for RGEvent in FParser.EventInfos do
  begin
    // 이미 구현된 이벤트 재사용 필요
    if ContainItem(FConvData.TotalEventInfos, RGEvent.Value) then
      Continue;

    PropName := GetCustomEventPropName(RGEvent.Prop);
    if GetEventTagInfo(PropName, TagInfo) then
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
      FConvData.TotalEventInfos := FConvData.TotalEventInfos + [CodeInfo];
    end;
  end;

  // KeyPress 이벤트를 갖고, KeyPress에서 Key = 13 사용하는 경우
    // KeyDown 이벤트 생성 후 KeyPress 호출
    // 만약, KeyDown 이벤트를 갖는 다면 추가

  if FParser.FooterInfos.Count > 0 then
  begin
    CodeInfo := Default(TCompEventInfo);

    CodeInfo.BeforeEventName := ''; // 추가
    CodeInfo.EventName := 'SummaryItemsGetText';
    ProcTag := '' +
      '    procedure SummaryItemsGetText('#13#10 +
      '      Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;'#13#10 +
      '      var AText: string);'
    ;
    CodeInfo.IntfCode := ProcTag;
    ProcTag := '' +
      'procedure ' + AFormClass + '.SummaryItemsGetText('#13#10 +
      '  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;'#13#10 +
      '  var AText: string);'#13#10 +
      'begin'#13#10 +
      '  inherited;'#13#10 +
      ''#13#10 +
      '  if TcxGridDBTableSummaryItem(Sender).DisplayText <> '''' then'#13#10 +
      '    AText := TcxGridDBTableSummaryItem(Sender).DisplayText;'#13#10 +
      'end;'#13#10
    ;
    CodeInfo.ImplCode := ProcTag;

    Result := Result + [CodeInfo];
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

function TConverterRealDBGridToCXGrid.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;

  function _InArray(AArray: TArray<TCompEventInfo>; AItem: string; var MethodName: string): Boolean;
  var
    Conv: TCompEventInfo;
  begin
    MethodName := '';
    Result := False;
    for Conv in AArray do
      if Conv.BeforeEventName = AItem then
      begin
        MethodName := Conv.EventName;
        Exit(True);
      end;
  end;

var
  Idx: Integer;
  GridName, ViewName, LevelName, ColName: string;
  GridText, ColText, ColAlignText, ColList, GroupText, GroupList: string;
  EditFormatProps: string;

  GridEvent, ViewEvent, DataEvent: string;
  MethodName: string;

  ColumnInfo: TRealGridColumnInfo;
  GroupInfo: TRealGridGroupInfo;
  EventInfo: TRealGridEventInfo;
  EventTagInfo: TEventTagInfo;

  I: Integer;
  Item, Value, ItemText, ItemsText: string;
  FooterItem, FooterItems: string;
  ShowBand: Boolean;

  Seq: Integer;
  GroupMode: Boolean;
  RowHeight, HeadHeight: Integer;

  GrpFixedCount, ColFixedCount: Integer;

  Option: string;
  Options: TArray<string>;
  GridOptionText: string;
  DecimalPlace: Integer;
  HiddenColumns: TArray<string>;
  PropName: string;
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
  GridText := GridText.Replace('[[COMP_VISIBLE]]',    FParser.Properties.ValuesDef['Visible', 'True']);

  GridText := GridText.Replace('[[TAB_ORDER]]',      FParser.Properties.ValuesDef['TabOrder', '0']);
  GridText := GridText.Replace('[[DATASOURCE]]',      FParser.Properties.ValuesDef['DataSource', 'nil']);

  GridText := GridText.Replace('[[POPUP_MENU]]',      FParser.Properties.ValuesDef['PopupMenu', 'nil']);

  GridText := GridText.Replace('[[FOOTER_VISIBLE]]',  BoolToStr(FParser.FooterVisibleCount > 0, True));
  GridText := GridText.Replace('[[FOOTER_MULTI]]',    BoolToStr(FParser.FooterVisibleCount > 1, True));

  GroupMode := StrToBoolDef(FParser.Properties.ValuesDef['GroupMode', 'False'], False);
  GrpFixedCount := StrToIntDef(FParser.Properties.ValuesDef['GrpFixedCount', '0'], 0);
  ColFixedCount := StrToIntDef(FParser.Properties.ValuesDef['ColFixedCount', '0'], 0);
  {
    FixedCount 참조
    [Col]
      Bus2010\FRM\TbF_006P
      Bus2010\FRM\TbF_203I
      Acct2010\FRM\TaF_772P
    [Grp]
      Bus2010\FRM\TbF_004P
  }

  // 밴드(그룹) 설정
  GroupList := '';

  ShowBand := False;
  if GroupMode then
  begin
    Seq := 0;
    for GroupInfo in FParser.GroupInfos do
    begin
      GroupText := TAG_CXGRID_GROUP;
      GroupText := GroupText.Replace('[[CAPTION]]', GroupInfo.TitleCaption);
      GroupText := GroupText.Replace('[[VISIBLE]]', BoolToStr(GroupInfo.Visible, True));
      GroupText := GroupText.Replace('[[WIDTH]]',   IntToStr(GroupInfo.Width));
      if Seq < GrpFixedCount then
      begin
        GroupText := GroupText.Replace('[[FIXED_KIND]]', 'fkLeft');
        GroupText := GroupText.Replace('[[STYLE_CONTENT]]', 'Styles.Content = dmDataBase.cxStyleHeader');
      end
      else
      begin
        GroupText := GroupText.Replace('[[FIXED_KIND]]', 'fkNone');
        GroupText := GroupText.Replace('[[STYLE_CONTENT]]', '');
      end;

      if GroupInfo.TitleColor = '' then
        GroupText := GroupText.Replace('[[STYLE_HEADER]]', '')
      else
        GroupText := GroupText.Replace('[[STYLE_HEADER]]', 'Styles.Header = ' + GetColorToStyleName(GroupInfo.TitleColor));

      GroupList := GroupList + GroupText;
      if GroupInfo.TitleVisible then
        ShowBand := True;
      Inc(Seq);
    end;
  end
  else
  begin
    if ColFixedCount = 0 then
      GroupList := TAG_CXGRID_GROUP_UNFIXEDCOL
    else
      GroupList := TAG_CXGRID_GROUP_FIXEDCOL;
//    GroupMode := False;
  end;

  GridText := GridText.Replace('[[GROUP_LIST]]', GroupList);
  GridText := GridText.Replace('[[BAND_HEADERS]]', BoolToStr(ShowBand, True));

  if not GroupMode then
  begin
    GridText := GridText.Replace('[[BAND_HEADER_HEIGHT]]', '0');
    GridText := GridText.Replace('[[HEADER_HEIGHT]]',      FParser.Properties.ValuesDef['Headers.ColHeight', '0']);
    GridText := GridText.Replace('[[DATAROW_HEIGHT]]',      FParser.Properties.ValuesDef['ColRowHeight', '25']);
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
    GridText := GridText.Replace('[[DATAROW_HEIGHT]]',      FParser.Properties.ValuesDef['GrpRowHeight', '25']);
  end;
  GridText := GridText.Replace('[[SEL_BG_COLOR]]',        GetColorToStyleName(FParser.Properties.ValuesDef['SelBgColor', '']));
  if FParser.Properties.Values['Footer.Font.Style'].Contains('fsBold') then
    GridText := GridText.Replace('[[STYLE_FOOTER]]',        'dmDataBase.cxStyleFooter9Bold')
  else
    GridText := GridText.Replace('[[STYLE_FOOTER]]',        'dmDataBase.cxStyleFooter9');

  Options := FParser.SetProp['Options'];
  GridText := GridText.Replace('[[wgoConfirmDelete]]',    BoolToStr(TArray.Contains<string>(Options, 'wgoConfirmDelete'), True));
  GridText := GridText.Replace('[[wgoEnterToTab]]',       BoolToStr(TArray.Contains<string>(Options, 'wgoEnterToTab'), True));
  GridText := GridText.Replace('[[wgoFocusRect]]',        BoolToStr(TArray.Contains<string>(Options, 'wgoFocusRect'), True));
  GridText := GridText.Replace('[[wgoRowSelect]]',        BoolToStr(TArray.Contains<string>(Options, 'wgoRowSelect'), True));
//  GridText := GridText.Replace('[[wgoColSizing]]',        BoolToStr(TArray.Contains<string>(Options, 'wgoColSizing'), True));
  GridText := GridText.Replace('[[wgoColSizing]]',        'True'); // 2021-6-30: 모든 컬럼 True로 설정키로 결정
  GridText := GridText.Replace('[[wgoRowSizing]]',        BoolToStr(TArray.Contains<string>(Options, 'wgoRowSizing'), True));
  GridText := GridText.Replace('[[wgoAlwaysShowEditor]]', BoolToStr(TArray.Contains<string>(Options, 'wgoAlwaysShowEditor'), True));
  GridText := GridText.Replace('[[wgoEditing]]',          BoolToStr(TArray.Contains<string>(Options, 'wgoEditing'), True));
  GridText := GridText.Replace('[[wgoInserting]]',        BoolToStr(TArray.Contains<string>(Options, 'wgoInserting'), True));
  GridText := GridText.Replace('[[wgoColMoving]]',        BoolToStr(TArray.Contains<string>(Options, 'wgoColMoving'), True));
  GridText := GridText.Replace('[[wgoMultiSelect]]',      BoolToStr(TArray.Contains<string>(Options, 'wgoMultiSelect'), True));
  GridText := GridText.Replace('[[wgoCancelOnExit]]',     BoolToStr(TArray.Contains<string>(Options, 'wgoCancelOnExit'), True));
  GridText := GridText.Replace('[[wgoDeleting]]',         BoolToStr(TArray.Contains<string>(Options, 'wgoDeleting'), True));

  //////////////////////////////////////////////////////////////////////////////
  // 컬럼 설정
  ColList := '';
  FooterItems := '';
  FColumnCompList := ''; //GetConvertCompList에서 사용할 컬럼 컴포넌트 목록
  Idx := 1;
  Seq := 0;
  for ColumnInfo in FParser.ColumnInfos do
  begin
    if (ColumnInfo.EditStyle = 'wesCheckBox') or (ColumnInfo.EditStyle = 'wesBoolean') then
    begin
      ColText := TAG_CXGRID_COLUMN_BOOL;
      ColText := ColText.Replace('[[VALUE_UNCHK]]', ColumnInfo.Values[0]);
      ColText := ColText.Replace('[[VALUE_CHK]]', ColumnInfo.Values[1]);

      ColAlignText := TAG_CXGRID_COLUMN_ALIGN;
    end
    else if ((ColumnInfo.EditStyle = 'wesNumber') or (ColumnInfo.EditFormatIsCurrency)) then
    begin
      ColText := TAG_CXGRID_COLUMN_CURRENCY;

      if ColumnInfo.EditFormat = '' then
        EditFormatProps := ''
      else
      begin
        EditFormatProps := TAG_CXGRID_EDIT_FORMAT;
        if not ColumnInfo.EditFormat.Contains('.') then
          DecimalPlace := 0
        else
          DecimalPlace := (ColumnInfo.EditFormat.Length - (ColumnInfo.EditFormat.IndexOf('.') + 1));

        EditFormatProps := EditFormatProps.Replace('[[EDIT_FORMAT]]', ColumnInfo.EditFormat.Replace('''', ''''''));
        EditFormatProps := EditFormatProps.Replace('[[DECIMAL_PLACE]]', DecimalPlace.ToString); // 입력 시 소숫점자리수
      end;

      ColText := ColText.Replace('[[EDIT_FORMAT_PROPS]]', EditFormatProps);

      ColAlignText := TAG_CXGRID_COLUMN_ALIGN_HORZ;
    end
    else if (ColumnInfo.EditFormatIsDate) then
    begin
      ColText := TAG_CXGRID_COLUMN_MASK;
      ColText := ColText.Replace('[[EDIT_FORMAT]]', ColumnInfo.EditFormat);

      ColAlignText := TAG_CXGRID_COLUMN_ALIGN_HORZ;
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
      ColAlignText := TAG_CXGRID_COLUMN_ALIGN_HORZ;
    end
    else
    begin
      ColText := TAG_CXGRID_COLUMN_DEF;
      ColAlignText := TAG_CXGRID_COLUMN_ALIGN_HORZ;
    end;

    FColumnCompList := FColumnCompList + #13#10'    ' + Format(ColName, [Idx]) + ': TcxGridDBBandedColumn;';

    ColText := ColText.Replace('[[COLUMN_NAME]]',     Format(ColName, [Idx]));
    ColText := ColText.Replace('[[COLUMN_CAPTION]]',  ColumnInfo.TitleCaption);
    // RealGrid Group이 미지정(-1)인 경우 컬럼 감춤
    if (GroupMode) and (ColumnInfo.Group = -1) then
      ColText := ColText.Replace('[[VISIBLE]]',         'False')
    else
      ColText := ColText.Replace('[[VISIBLE]]',       BoolToStr(ColumnInfo.Visible, True));

    if ColumnInfo.TitleClicking then
      ColText := ColText.Replace('[[HEADER_HINT]]',         ColumnInfo.TitleCaption)
    else
      ColText := ColText.Replace('[[HEADER_HINT]]',         '');

    if ColumnInfo.FieldName.ToLower.StartsWith('calc_') then
    begin
      // Calcfield 강제 ReadOnly
      ColText := ColText.Replace('[[READONLY]]',        'True');
      ColText := ColText.Replace('[[EDITING]]',         'False');
    end
    else
    begin
      ColText := ColText.Replace('[[READONLY]]',        BoolToStr(ColumnInfo.ReadOnly, True));
      ColText := ColText.Replace('[[EDITING]]',         BoolToStr(not ColumnInfo.ReadOnly, True));
    end;

    // 리얼그리드에서 Group과 LevelIndex를 설정하지 않은 경우(TbF_0006I)
      // BandIndex = 0, ColIndex는 순번(0..)으로 설정해야 함
    if not GroupMode then
    begin
      if ColFixedCount = 0 then
        ColText := ColText.Replace('[[BAND_INDEX]]', '0')
      else
      begin
        if Seq < ColFixedCount then
          ColText := ColText.Replace('[[BAND_INDEX]]', '0')
        else
          ColText := ColText.Replace('[[BAND_INDEX]]', '1');
      end;
      ColText := ColText.Replace('[[COL_INDEX]]',       IntToStr(Seq));
      ColText := ColText.Replace('[[WIDTH]]',           IntToStr(Trunc(ColumnInfo.ColWidth*1.1)));
      ColText := ColText.Replace('[[ROW_INDEX]]',       '0');
      Inc(Seq);
    end
    else
    begin
      ColText := ColText.Replace('[[BAND_INDEX]]',      IntToStr(ColumnInfo.Group));
      ColText := ColText.Replace('[[COL_INDEX]]',       IntToStr(ColumnInfo.LevelIndex));
      ColText := ColText.Replace('[[WIDTH]]',           IntToStr(Trunc(ColumnInfo.GrpWidth*1.1)));
      ColText := ColText.Replace('[[ROW_INDEX]]',       IntToStr(ColumnInfo.Level));
    end;

    if ColumnInfo.Alignment = '' then
      ColText := ColText.Replace('[[COL_ALIGN]]',      '')
    else
      ColText := ColText.Replace('[[COL_ALIGN]]',      ColAlignText.Replace('[[HORZ_ALIGN]]', ColumnInfo.Alignment));

    if ColumnInfo.FooterAlign = '' then
      if ColumnInfo.Alignment = '' then
        ColText := ColText.Replace('[[FOOTER_ALIGN]]',      '')
      else
        ColText := ColText.Replace('[[FOOTER_ALIGN]]',      TAG_CXGRID_FOOTER_ALIGN.Replace('[[HORZ_ALIGN]]', ColumnInfo.Alignment))
    else
      ColText := ColText.Replace('[[FOOTER_ALIGN]]',      TAG_CXGRID_FOOTER_ALIGN.Replace('[[HORZ_ALIGN]]', ColumnInfo.FooterAlign));

    ColText := ColText.Replace('[[FIELD_NAME]]',      ColumnInfo.FieldName);

    // cxGridView의 Column.Position.LineCount는 라인 몇칸을 차지할지 설정
      // 리얼그리드는 그룹의 Levels는 몇행을 표시할지 설정
      // 즉, RG.Levels가 1이면 CX.LineCount는 전체 해더 행수를 설정해야 함
    if GroupMode and (ColumnInfo.Group > -1) and (FParser.GroupInfos.Count > ColumnInfo.Group) then
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
      ColText := ColText.Replace('[[STYLE_HEADER]]', 'Styles.Header = ' + GetColorToStyleName(ColumnInfo.TitleColor, ColumnInfo.FontColor));

    ColList := ColList + ColText;

    // Footer 처리
      // FooterVisibleCount 만큼 생성, FVC > 1 경우
    if ColumnInfo.FooterStyleVisibleCount > 0 then
    begin
      for I := 0 to FParser.FooterInfos.Count - 1 do
      begin
        if not FParser.FooterInfos[I].Visible then
          Continue;
        FooterItem := TAG_CXGRID_FOOTER_ITEM;
        FooterItem := FooterItem.Replace('[[FOOTER_KIND]]', 'skNone');
        FooterItem := FooterItem.Replace('[[FOOTER_COLUMN]]', Format(ColName, [Idx]));
        FooterItem := FooterItem.Replace('[[FOOTER_TEXT]]', ColumnInfo.FooterStyles[I].Value);
        FooterItem := FooterItem.Replace('[[FOOTER_TAG]]', I.ToString);

        FooterItems := FooterItems + FooterItem;
      end;
    end;

    Inc(Idx);
  end;

  HiddenColumns := GetCustomHiddenColumns(FConvData.FileInfo.Filename, GridName);
  for I := 0 to Length(HiddenColumns) - 1 do
  begin
    ColText := TAG_CXGRID_COLUMN_HIDDEN;
    ColText := ColText.Replace('[[COLUMN_NAME]]',     Format(ColName, [Idx]));
    ColText := ColText.Replace('[[FIELD_NAME]]',     HiddenColumns[I]);

    FColumnCompList := FColumnCompList + #13#10'    ' + Format(ColName, [Idx]) + ': TcxGridDBBandedColumn;';
    ColList := ColList + ColText;
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
    PropName := GetCustomEventPropName(EventInfo.Prop);
    if GetEventTagInfo(PropName, EventTagInfo) then
    begin
      // 이미 구현된 이벤트라면 MethodName 재사용 아니라면 신규 메소드 설정
      if not _InArray(FConvData.TotalEventInfos, EventInfo.Value, MethodName) then
        MethodName := '';
// eg   OnEnter = RealGrid1Enter
//        On[이벤트명] = [그리드이름][이벤트명]
// eg   DataController.OnAfterDelete = cxGrid1DBBandedTableView1DataControllerAfterDelete
//        DataController.On[이벤트명] = [뷰명]DataController[이벤트명]
      case EventTagInfo.EventOwner of
        eoGrid:
          GridEvent := GridEvent + '  On' + EventTagInfo.EventName +
              ' = ' + IfThen(MethodName = '', GridName + EventTagInfo.EventName, MethodName) +  #13#10;
        eoView:
          ViewEvent := ViewEvent + '  On' + EventTagInfo.EventName +
              ' = ' + IfThen(MethodName = '', ViewName + EventTagInfo.EventName, MethodName) +  #13#10;
        eoData:
          DataEvent := DataEvent + '  DataController.On' + EventTagInfo.EventName +
              ' = ' + IfThen(MethodName = '', ViewName + 'DataController' + EventTagInfo.EventName, MethodName) +  #13#10;
        eoDataSummury:
          DataEvent := DataEvent + '  DataController.Summary.On' + EventTagInfo.EventName +
              ' = ' + IfThen(MethodName = '', ViewName + 'DataControllerSummary' + EventTagInfo.EventName, MethodName) +  #13#10;
      end;
    end;
  end;
  GridText := GridText.Replace('[[GRID_EVENT]]', GridEvent);
  GridText := GridText.Replace('[[VIEW_EVENT]]', ViewEvent);
  GridText := GridText.Replace('[[DATA_EVENT]]', DataEvent);

  Output := GridText;
  Result := True;
end;

function TConverterRealDBGridToCXGrid.GetCustomEventPropName(
  APropName: string): string;
var
  Path: string;
  Target: TArray<string>;
  Targets: TArray<TArray<string>>;
begin
  Result := APropName;
  Path := FConvData.RootPath.ToLower;
  if Path.Contains('bus') then
  begin
    Targets := [
        ['TbF_001I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_001I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_003I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_004I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_006I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_130I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_201I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_202I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_203I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_205I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_207I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_208I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_213I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_502I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_502I_2.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_509I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_513I.dfm',	'RealDBGrid2', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_513_2I.dfm',	'RealDBGrid2', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_805I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_IpgoKumSu_I.dfm',	'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('cust') then
  begin
    Targets := [
        ['TbF_001I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_003I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_004I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_006I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_201I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_202I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_203I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_502I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TbF_509I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']

      , ['TbF_309I.dfm', 'RealDBGrid1', 'OnDblClick', 'OnDblClickKeep']
      , ['TbF_324I.dfm', 'RealDBGrid1', 'OnDblClick', 'OnDblClickKeep']
      , ['TbF_310I.dfm', 'RealDBGrid1', 'OnDblClick', 'OnDblClickKeep']
      , ['TbF_325I.dfm', 'RealDBGrid1', 'OnDblClick', 'OnDblClickKeep']
      , ['TbF_318I.dfm', 'RealDBGrid1', 'OnDblClick', 'OnDblClickKeep']
    ];
  end
  else if Path.Contains('acct') then
  begin
    Targets := [
        ['TaF_103I.dfm', 'RealDBGrid_detail', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TaF_201I.dfm', 'RealDBGrid2', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TgF_501I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('acost') then
  begin
    Targets := [
        ['TaF_006I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TaF_103I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TaF_212I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TaF_213I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TaF_304I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TaF_504I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_InfBook_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('budget') then
  begin
    Targets := [
      ['TaF_201I.dfm', 'RealDBGrid2', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('make') then
  begin
    Targets := [
        ['TaF_212I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Book_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Box_Chulgo_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Company_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_DokRyue_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Film_DaySet_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Film_SuJung_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_GongImUP_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_GongIm_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_GongIm_Jibul_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_InfBook_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_IpgoKumSu_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Jiler_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Paper_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_ScheduledIpGo_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Yong101I.dfm', 'RDBGridMaster', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_Yong104I.dfm', 'RealDBGrid2', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_YongJi_Ipgo_I2.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_YongJi_Ipgo_I2.dfm', 'RealDBGrid2', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_YongJi_Ipgo_Jeji_I.dfm', 'RealDBGrid3', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('newsupp') then
  begin
    Targets := [
        ['TmF_InfBook_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TsF_BookStorePosI.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('supply') then
  begin
    Targets := [
        ['Sup3061.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['Sup3071.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['Sup3071.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['Sup7002.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end
  else if Path.Contains('plan') then
  begin
    Targets := [
        ['TaF_212I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TmF_InfBook_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TpF_BosangJikub_I.dfm', 'DBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TpF_Bosang_I.dfm', 'DBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TpF_SJ_CDModify_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TpF_SJ_InfBook_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TpF_SJ_JegoBook_I.dfm', 'RealDBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
      , ['TpF_SJ_Josa_I.dfm', 'DBGrid1', 'OnKeyPress', 'OnKeyPressToDown']
    ];
  end;

  for Target in Targets do
  begin
    if (FconvData.FileInfo.Filename = Target[0])
      and (FParser.CompName = Target[1])
      and(APropName = Target[2]) then
        Exit(Target[3]);
  end;
end;

function TConverterRealDBGridToCXGrid.GetCustomHiddenColumns(AFilename,
  AGridName: string): TArray<string>;
var
  I: Integer;
  Path: string;
  Datas: TArray<TArray<string>>;
begin
  Path := FConvData.RootPath.ToLower;
  if Path.Contains('bus') then
  begin
    Datas := [
      ['TbF_101I', 'RealDBGrid3', '협회발행구분'],
      ['TbF_101I', 'RealDBGrid3', '주문구분'],
      ['TbF_109P', 'RealDBGrid1', '교육청코드'],
      ['TbF_109P', 'RealDBGrid1', '학교코드'],
      ['TbF_4101P', 'RDBGridMaster2', '그룹코드'],
      ['TbF_4102P', 'RDBGridMaster', '교지코드'],
      ['TbF_503P', 'RealDBGrid1', '인덱스']
    ];
  end
  else if Path.Contains('cust') then
  begin
    Datas := [
      ['TbF_4101P', 'RDBGridMaster2', '그룹코드']
    ];
  end
  else if Path.Contains('newsupp') then
  begin
    Datas := [
        ['ThF_003aP',                 'RealDBGrid1', '작업구분코드']
      , ['TsF_Banpum_KumsuI',         'RealDBGrid1', '반품부수']
      , ['TsF_Banpum_Kumsu_BarCodeI', 'RealDBGrid1', '반품부수']
    ];
  end
  else if Path.Contains('supply') then
  begin
    Datas := [
        ['Sup2011', 'RealDBGrid_Elem', 'Num']
      , ['Sup2011', 'RealDBGrid_Elem', '본주문제한']
      , ['Sup2011', 'RealDBGrid_Elem', '추가주문제한']
      , ['Sup2011', 'RealDBGrid_Elem', '개별주문제한']
      , ['Sup2011', 'RealDBGrid_High', 'Num']
      , ['Sup2011', 'RealDBGrid_High', '본주문제한']
      , ['Sup2011', 'RealDBGrid_High', '추가주문제한']
      , ['Sup2011', 'RealDBGrid_Mid', 'Num']
      , ['Sup3041', 'RealDBGrid2', '확인']
      , ['Sup5081', 'RealDBGrid1', '인덱스']
      , ['Sup7003', 'RealDBGrid2', '보내준부수']
      , ['Sup7003', 'RealDBGrid2', '총주문부수']
    ];
  end
  else if Path.Contains('acct') then
  begin
    Datas := [
        ['TaF_103I', 'RealDBGrid_detail', 'Num']
      , ['TaF_774P', 'RDBGridMaster', 'Num']
      , ['TaF_776P', 'RealDBGrid4', '목코드']
      , ['TaF_103_1P', 'RealDBGrid_detail', 'Num']
      , ['TaF_777P', 'RealDBGrid1', 'Num']
      , ['TaF_777P', 'RealDBGrid2', 'Num']
    ];
  end
  else if Path.Contains('acost') then
  begin
    Datas := [
        ['TaF_103I', 'RealDBGrid_detail', 'Num']
      , ['TaF_774P', 'RDBGridMaster', 'Num']
      , ['TaF_776P', 'RealDBGrid4', '목코드']
      , ['TaF_103_1P', 'RealDBGrid_detail', 'Num']
      , ['TaF_777P', 'RealDBGrid1', 'Num']
      , ['TaF_777P', 'RealDBGrid2', 'Num']
    ];
  end;

  Result := [];
  for I := 0 to Length(Datas) - 1 do
  begin
    if not AFilename.Contains(Datas[I][0]) then
      Continue;

    if AGridName <> Datas[I][1] then
      Continue;

    Result := Result + [Datas[I][2]];
  end;
end;

function TConverterRealDBGridToCXGrid.GetAddedUses: TArray<string>;
begin
  Result := [
      'Variants', 'TzzU_DataBase', 'RealGridHelper',
      'cxGridLevel', 'cxGridCustomTableView', 'cxImageComboBox',
      'cxGridTableView', 'cxGridBandedTableView', 'cxGridDBBandedTableView', 'cxClasses',
      'cxGridCustomView', 'cxGrid', 'cxGraphics', 'cxControls', 'cxLookAndFeels',
      'cxLookAndFeelPainters', 'cxStyles', 'cxCustomData', 'cxFilter',
      'cxData', 'cxDataStorage', 'cxEdit', 'cxNavigator', 'dxDateRanges',
      'dxScrollbarAnnotations', 'cxDBData', 'cxTextEdit', 'cxGridDBTableView'
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
  Result := ['URGrids', 'URDBGrid', 'URMGrid'];
end;

function TConverterRealDBGridToCXGrid.IsWantWriteEvnetCodeToPas: Boolean;
begin
  Result := True;
end;

initialization
  TConvertManager.Instance.Regist(TConverterRealDBGridToCXGrid);

end.
