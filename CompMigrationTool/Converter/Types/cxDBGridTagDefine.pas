unit cxDBGridTagDefine;

interface

const
  TAG_CXGRID_COMP = '' +
    'object [[COMP_NAME]]: TcxGrid'#13#10 +
    '  Left = [[COMP_LEFT]]'#13#10 +
    '  Top = [[COMP_TOP]]'#13#10 +
    '  Width = [[COMP_WIDTH]]'#13#10 +
    '  Height = [[COMP_HEIGHT]]'#13#10 +
    '  Visible = [[COMP_VISIBLE]]'#13#10 +
    '  Align = [[COMP_ALIGN]]'#13#10 +
    '  Font.Charset = DEFAULT_CHARSET'#13#10 +
    '  Font.Color = clWindowText'#13#10 +
    '  Font.Height = -12'#13#10 +
    '  Font.Name = #44404#47548'#13#10 +
    '  Font.Style = []'#13#10 +
    '  ParentFont = False'#13#10 +
    '  TabOrder = [[TAB_ORDER]]'#13#10 +
    '  LookAndFeel.NativeStyle = False'#13#10 +
    '  LookAndFeel.Kind = lfFlat'#13#10 +
    '  LookAndFeel.ScrollbarMode = sbmClassic'#13#10 +
    '  LookAndFeel.ScrollMode = scmClassic'#13#10 +
    '[[GRID_EVENT]]'#13#10 +
    '  object [[VIEW_NAME]]: TcxGridDBBandedTableView'#13#10 +
    '[[VIEW_EVENT]]'#13#10 +
    '    DataController.DataSource = [[DATASOURCE]]'#13#10 +
    '    DataController.DataModeController.GridMode = True'#13#10 +
    '    DataController.DataModeController.GridModeBufferCount = 50'#13#10 +
    '    DataController.Summary.DefaultGroupSummaryItems = <>'#13#10 +
    '    DataController.Summary.FooterSummaryItems = <'#13#10 +
    '[[FOOTER_ITEMS]]'#13#10 +
    '    >'#13#10 +
    '    DataController.Summary.SummaryGroups = <>'#13#10 +
    '    OptionsView.NoDataToDisplayInfoText = ''<''#54364#49884#54624'' ''#45936#51060#53552#44032'' ''#50630#49845#45768#45796''.>'''#13#10 +
    '    OptionsView.GroupByBox = False'#13#10 +
    '    OptionsView.Indicator = True'#13#10 +
    '    OptionsView.BandHeaders = [[BAND_HEADERS]]'#13#10 +
    '    OptionsView.Footer = [[FOOTER_VISIBLE]]'#13#10 +
    '    OptionsView.FixedBandSeparatorWidth = 1'#13#10 +

    '    OptionsView.FooterMultiSummaries = [[FOOTER_MULTI]]'#13#10 +

    '    OptionsView.BandHeaderHeight = [[BAND_HEADER_HEIGHT]]'#13#10 +
    '    OptionsView.HeaderHeight = [[HEADER_HEIGHT]]'#13#10 +
    '    OptionsView.DataRowHeight = [[DATAROW_HEIGHT]]'#13#10 +

    '    OptionsView.HeaderEndEllipsis = True'#13#10 +
    '    OptionsView.BandHeaderEndEllipsis = True'#13#10 +

    // RealDBGrid.Options 처리
    '    OptionsData.DeletingConfirmation = [[wgoConfirmDelete]]'#13#10 +
    '    OptionsData.Inserting = [[wgoInserting]]'#13#10 +
    '    OptionsData.Appending = [[wgoInserting]]'#13#10 +
    '    OptionsData.Editing = [[wgoEditing]]'#13#10 +
    '    OptionsData.CancelOnExit = [[wgoCancelOnExit]]'#13#10 +
    '    OptionsData.Deleting = [[wgoDeleting]]'#13#10 +

    '    OptionsBehavior.GoToNextCellOnenter = [[wgoEnterToTab]]'#13#10 +
    '    OptionsView.FocusRect = [[wgoFocusRect]]'#13#10 +
    '    OptionsSelection.InvertSelect = [[wgoRowSelect]]'#13#10 +
    '    OptionsCustomize.ColumnHorzSizing = [[wgoColSizing]]'#13#10 +
    '    OptionsCustomize.DataRowSizing = [[wgoRowSizing]]'#13#10 +
    '    OptionsBehavior.ImmediateEditor = [[wgoAlwaysShowEditor]]'#13#10 +
    '    OptionsBehavior.AlwaysShowEditor = True'#13#10 +
//    '    OptionsBehavior.AlwaysShowEditor = [[wgoAlwaysShowEditor]]'#13#10 +  // PickList(ComboBox) 선택 시 바로 항목 표시하기 위해 항상 True(기본)
    '    OptionsCustomize.ColumnMoving = [[wgoColMoving]]'#13#10 +
    '    OptionsSelection.MultiSelect = [[wgoMultiSelect]]'#13#10 +

    '    OptionsCustomize.ColumnFiltering = False'#13#10 +    // 컬럼 필터링 미사용
    '    OptionsCustomize.ColumnSorting = False'#13#10 +      // 컬럼 소팅 미사용
    '    OptionsBehavior.FocusCellOnCycle = True'#13#10 +     // 마지막 컬럼에서 다음 행 첫컬럼으로 이동

    '    OptionsView.NoDataToDisplayInfoText = ''<데이터가 없습니다.>'''#13#10 +
    '    Styles.Selection = [[SEL_BG_COLOR]]'#13#10 +         // 선택 색상
    '    Styles.Footer = [[STYLE_FOOTER]]'#13#10 +  // dmDataBase.cxStyleFooter9
    '    Styles.Header = dmDataBase.cxStyleHeader'#13#10 +
    '    Styles.BandHeader = dmDataBase.cxStyleHeader'#13#10 +

    '[[DATA_EVENT]]'#13#10 +
    '    Bands = <'#13#10 +
    '    [[GROUP_LIST]]'#13#10 +
    '    >'#13#10 +
    '    [[COLUMN_LIST]]'#13#10 +
    // 이벤트
    '  end'#13#10 +
    '  object [[LEVEL_NAME]]: TcxGridLevel'#13#10 +
    '    GridView = [[VIEW_NAME]]'#13#10 +
    '  end'#13#10 +
    'end'#13#10
  ;



  TAG_CXGRID_COLUMN_COMMON_PROP = '' +
    '      Options.Editing = [[EDITING]]'#13#10 +
    '      Options.Focusing = [[EDITING]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      [[COL_ALIGN]]'+
    '      DataBinding.FieldName = ''[[FIELD_NAME]]'''#13#10 +

    '      Visible = [[VISIBLE]]'#13#10 +
    '      [[FOOTER_ALIGN]]'+
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +
    '      HeaderHint = ''[[HEADER_HINT]]'''#13#10 +

    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = [[ROW_INDEX]]'#13#10 +
    '      Position.LineCount = [[LINE_COUNT]]'#13#10 +
    '      [[STYLE_CONTENT]]'#13#10 +
    '      [[STYLE_HEADER]]'#13#10 +
    '      Width = [[WIDTH]]'#13#10
  ;

  TAG_CXGRID_COLUMN_DEF = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxTextEditProperties'''#13#10 +
    TAG_CXGRID_COLUMN_COMMON_PROP +
    '    end'#13#10
  ;

  // EditStyle = wesNumber or (EditStyle is null and EditFormat = 금액('#,.' 포함))
  TAG_CXGRID_COLUMN_CURRENCY = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxCurrencyEditProperties'''#13#10 +
    '[[EDIT_FORMAT_PROPS]]' +
    TAG_CXGRID_COLUMN_COMMON_PROP +
    '    end'#13#10
  ;

  TAG_CXGRID_EDIT_FORMAT =
    '      Properties.AssignedValues.DisplayFormat = True'#13#10 +
    '      Properties.AssignedValues.EditFormat = True'#13#10 +
    '      Properties.DecimalPlaces = [[DECIMAL_PLACE]]'#13#10 +
    '      Properties.DisplayFormat = ''[[EDIT_FORMAT]]'''#13#10 +
    '      Properties.EditFormat = ''[[EDIT_FORMAT]]'''#13#10
  ;

  TAG_CXGRID_COLUMN_MASK = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxMaskEditProperties'''#13#10 +

    '      Properties.EditMask = ''[[EDIT_FORMAT]]'''#13#10 +

    TAG_CXGRID_COLUMN_COMMON_PROP +
    '    end'#13#10
  ;

  TAG_CXGRID_COLUMN_BOOL = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxCheckBoxProperties'''#13#10 +
    '      Properties.DisplayChecked = ''True'''#13#10 +
    '      Properties.DisplayUnchecked = ''False'''#13#10 +
    '      Properties.NullStyle = nssUnchecked'#13#10 +
    '      Properties.ValueChecked = ''[[VALUE_CHK]]'''#13#10 +
    '      Properties.ValueUnchecked = ''[[VALUE_UNCHK]]'''#13#10 +

    TAG_CXGRID_COLUMN_COMMON_PROP +
    '    end'#13#10
  ;

  TAG_CXGRID_COLUMN_HIDDEN = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      DataBinding.FieldName = ''[[FIELD_NAME]]'''#13#10 +
    '      Visible = False'#13#10 +
    '      Position.BandIndex = -1'#13#10 +
    '      Position.ColIndex = -1'#13#10 +
    '      Position.RowIndex = -1'#13#10 +
    '    end'#13#10
  ;

  TAG_CXGRID_COLUMN_ALIGN_HORZ  = 'Properties.Alignment.Horz = [[HORZ_ALIGN]]'#13#10;
  TAG_CXGRID_COLUMN_ALIGN       = 'Properties.Alignment = [[HORZ_ALIGN]]'#13#10;
  TAG_CXGRID_FOOTER_ALIGN       = 'FooterAlignmentHorz = [[HORZ_ALIGN]]'#13#10;

  TAG_CXGRID_COLUMN_ITEM = '' +
    '        item'#13#10 +
    '          Description = ''[[ITEM]]'''#13#10 +
    '          Value = ''[[VALUE]]'''#13#10 +
    '        end'#13#10
  ;
  TAG_CXGRID_COLUMN_ITEMS = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxImageComboBoxProperties'''#13#10 +
    '      Properties.Items = <'#13#10 +
    '[[ITEMS]]'+
    '      >'#13#10 +

    TAG_CXGRID_COLUMN_COMMON_PROP +
    '    end'#13#10
  ;


  TAG_CXGRID_GROUP = '' +
    '      item'#13#10 +
    '        Caption = ''[[CAPTION]]'''#13#10 +
    '        FixedKind = [[FIXED_KIND]]'#13#10 +
    '        [[STYLE_CONTENT]]'#13#10 +
    '        Visible = [[VISIBLE]]'#13#10 +
//    '        Width = [[WIDTH]]'#13#10 +
    '        [[STYLE_HEADER]]'#13#10 +
    '      end'#13#10
  ;
  TAG_CXGRID_GROUP_UNFIXEDCOL = '' +
    '      item'#13#10 +
    '        Caption = ''Fixed band'''#13#10 +
    '      end'#13#10 +
    '      item'#13#10 +
    '        Caption = ''Normal band'''#13#10 +
    '        Visible = False'#13#10 +
    '      end'#13#10
  ;
  TAG_CXGRID_GROUP_FIXEDCOL = '' +
    '      item'#13#10 +
    '        Caption = ''Normal band'''#13#10 +
    '        FixedKind = fkLeft'#13#10 +
    '        Styles.Content = dmDataBase.cxStyleHeader'#13#10 +
    '      end'#13#10 +
    '      item'#13#10 +
    '        Caption = ''Hidden band'''#13#10 +
    '      end'#13#10
  ;

  TAG_CXGRID_FOOTER_ITEM = '' +
    '      item'#13#10 +
//    '        Format = ''#,##0'''#13#10 +
    '        OnGetText = SummaryItemsGetText'#13#10 +
    '        Kind = [[FOOTER_KIND]]'#13#10 +
    '        Column = [[FOOTER_COLUMN]]'#13#10 +
    '        DisplayText = ''[[FOOTER_TEXT]]'''#13#10 +
    '        Tag = [[FOOTER_TAG]]'#13#10 +
    '      end'#13#10
  ;

//        Caption = #48156#49373#48264#54840
//        Visible = False

type
  TEventOwner = (eoNone, eoGrid, eoView, eoData, eoDataSummury, eoIgnore, eoCase);
  TEventTagInfo = record
    EventName: string;
    RGEvent: string;
    EventOwner: TEventOwner;
    ProcTag: string;
  end;

const
  TAG_PROC_GRID_COMMON = 'procedure [[FORMCLASS_NAME]][[GRID_NAME]][[EVENT_NAME]]';
  TAG_PROC_VIEW_COMMON = 'procedure [[FORMCLASS_NAME]][[VIEW_NAME]][[EVENT_NAME]]';
  TAG_PROC_DATA_COMMON = 'procedure [[FORMCLASS_NAME]][[VIEW_NAME]]DataController[[EVENT_NAME]]('#13#10;
  TAG_PROC_SUMR_COMMON = 'procedure [[FORMCLASS_NAME]][[VIEW_NAME]]DataControllerSummary[[EVENT_NAME]]('#13#10;

  TAG_PROC_DATA_CTRLR = TAG_PROC_DATA_COMMON +
    '      ADataController: TcxCustomDataController);';

  TAG_PROC_GRID_SENDER = TAG_PROC_GRID_COMMON + '(Sender: TObject);';
  TAG_PROC_VIEW_SENDER = TAG_PROC_VIEW_COMMON + '(Sender: TObject);';
  TAG_PROC_VIEW_DBLCLICK = TAG_PROC_VIEW_SENDER;

  TAG_PROC_GRID_KEYPRESS = TAG_PROC_GRID_COMMON + '(Sender: TObject;'#13#10 +
    '  var Key: Char);';
  TAG_PROC_VIEW_KEYPRESS = TAG_PROC_VIEW_COMMON + '(Sender: TObject;'#13#10 +
    '  var Key: Char);';
  TAG_PROC_VIEW_EDITKEYDOWN = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);';
  TAG_PROC_VIEW_EDITKEYPRESS = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit; var Key: Char);';
  TAG_PROC_VIEW_MOUSEDOWN = TAG_PROC_VIEW_COMMON + '(Sender: TObject;'#13#10 +
    '      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);';
  TAG_PROC_VIEW_COL_HDR = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxGridTableView; AColumn: TcxGridColumn);';
  TAG_PROC_VIEW_CUST_DRAW = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;'#13#10 +
    '      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);';
  TAG_PROC_VIEW_CELL_CLICK = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;'#13#10 +
    '      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);';
  TAG_PROC_VIEW_EDIT_DBLCLICK = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit);';
  TAG_PROC_VIEW_RECCHG = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; APrevFocusedRecord,'#13#10 +
    '      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);';
  TAG_PROC_VIEW_INIT_EDIT = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit);';

  TAG_PROC_VIEW_FOCUSED_ITEM_CHANGED = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; APrevFocusedItem,'#13#10 +
    '      AFocusedItem: TcxCustomGridTableItem);';


const
  EventTagInfos: array[0..13] of TEventTagInfo =
    (
      (EventName: 'EditDblClick';         RGEvent: 'OnDblClick';          EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_EDIT_DBLCLICK),
      (EventName: 'DblClick';             RGEvent: 'OnDblClickKeep';      EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_DBLCLICK),

      (EventName: 'EditKeyDown';          RGEvent: 'OnKeyPressToDown';    EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_EDITKEYDOWN),
      (EventName: 'EditKeyPress';         RGEvent: 'OnKeyPress';          EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_EDITKEYPRESS),

      (EventName: 'ColumnHeaderClick';    RGEvent: 'OnColumnTitleClick';  EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_COL_HDR),
      (EventName: 'CustomDrawCell';       RGEvent: 'OnDrawCell';	        EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_CUST_DRAW),
      (EventName: 'CellClick';            RGEvent: 'OnClick';             EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_CELL_CLICK),

      (EventName: 'Enter';                RGEvent: 'OnEnter';	            EventOwner: eoGrid;         ProcTag: TAG_PROC_GRID_SENDER),
      (EventName: 'Exit';                 RGEvent: 'OnExit';              EventOwner: eoGrid;         ProcTag: TAG_PROC_GRID_SENDER),
      (EventName: 'MouseDown';            RGEvent: 'OnMouseDown';         EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_MOUSEDOWN),
      (EventName: 'FocusedRecordChanged'; RGEvent: 'OnRowChange';         EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_RECCHG),
      (EventName: 'InitEdit';             RGEvent: 'OnEdit';	            EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_INIT_EDIT),

      (EventName: 'FocusedItemChanged';   RGEvent: 'OnCellExit';	        EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_FOCUSED_ITEM_CHANGED),
      (EventName: 'EditKeyDown';          RGEvent: 'OnKeyDown';	          EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_EDITKEYDOWN)
    );

function GetEventTagInfo(ARGEventProp: string; var OutInfo: TEventTagInfo): Boolean;
function GetColorToStyleName(AColor: string; AFontColor: string = 'clWindowText'): string;

implementation

function GetEventTagInfo(ARGEventProp: string; var OutInfo: TEventTagInfo): Boolean;
var
  Info: TEventTagInfo;
begin
  Result := False;

  if ARGEventProp = 'OnKeyPress' then
  begin

  end;

  for Info in EventTagInfos do
  begin
    if (Info.EventOwner = eoNone) then
      Continue;
    if Info.RGEvent = ARGEventProp then
    begin
      OutInfo := Info;
      Exit(True);
    end;
  end;
end;

function GetColorToStyleName(AColor: string; AFontColor: string): string;
const
  COLOR_TO_STYLE: array[0..15] of array[0..2] of string = (
    ('8454143',                 'clWindowText',   'cxStyle1'),
    ('8454143',                 'clRed',          'cxStyle1Red'),
    ('8454016',                 'clWindowText',   'cxStyle2'),
    ('12615935',                'clWindowText',   'cxStyle3'),
    ('16751515',                'clWindowText',   'cxStyle4'),
    ('clAqua',                  'clWindowText',   'cxStyle5'),
    ('clInactiveCaptionText',   'clWindowText',   'cxStyle6'),
    ('clLime',                  'clWindowText',   'cxStyle7'),
    ('clMoneyGreen',            'clWindowText',   'cxStyle8'),
    ('clSilver',                'clWindowText',   'cxStyle9'),
    ('clSkyBlue',               'clWindowText',   'cxStyle10'),
    ('clYellow',                'clWindowText',   'cxStyle11'),
    ('$0080FFFF',               'clWindowText',   'cxStyle1'),
    ('$0080FF80',               'clWindowText',   'cxStyle2'),
    ('$00C080FF',               'clWindowText',   'cxStyle3'),
    ('$00FF9B9B',               'clWindowText',   'cxStyle4')
  );

var
  I: Integer;
begin
  if AFontColor = '' then
    AFontColor := 'clWindowText';

  Result := 'nil';
  for I := 0 to Length(COLOR_TO_STYLE) - 1 do
    if (COLOR_TO_STYLE[I][0] = AColor) and (COLOR_TO_STYLE[I][1] = AFontColor) then
      Exit('dmDatabase.' + COLOR_TO_STYLE[I][2]);
end;

//{$Message Error 'Not implemented'}
end.
