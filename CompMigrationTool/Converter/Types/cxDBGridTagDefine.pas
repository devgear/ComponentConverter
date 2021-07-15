unit cxDBGridTagDefine;

interface

const
  TAG_CXGRID_COMP = '' +
    'object [[COMP_NAME]]: TcxGrid'#13#10 +
    '  Left = [[COMP_LEFT]]'#13#10 +
    '  Top = [[COMP_TOP]]'#13#10 +
    '  Width = [[COMP_WIDTH]]'#13#10 +
    '  Height = [[COMP_HEIGHT]]'#13#10 +
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
    '[[GRID_EVENT]]'#13#10 +
    '  object [[VIEW_NAME]]: TcxGridDBBandedTableView'#13#10 +
    '[[VIEW_EVENT]]'#13#10 +
    '    DataController.DataSource = [[DATASOURCE]]'#13#10 +
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
    '    OptionsView.FooterMultiSummaries = [[FOOTER_MULTI]]'#13#10 +

    '    OptionsView.BandHeaderHeight = [[BAND_HEADER_HEIGHT]]'#13#10 +
    '    OptionsView.HeaderHeight = [[HEADER_HEIGHT]]'#13#10 +
    '    OptionsView.DataRowHeight = [[DATAROW_HEIGHT]]'#13#10 +

    '    OptionsView.HeaderEndEllipsis = True'#13#10 +
    '    OptionsView.BandHeaderEndEllipsis = True'#13#10 +

    // RealDBGrid.Options 처리
    '    OptionsData.DeletingConfirmation = [[wgoConfirmDelete]]'#13#10 +
    '    OptionsBehavior.GoToNextCellOnenter = [[wgoEnterToTab]]'#13#10 +
    '    OptionsView.FocusRect = [[wgoFocusRect]]'#13#10 +
    '    OptionsSelection.InvertSelect = [[wgoRowSelect]]'#13#10 +
    '    OptionsCustomize.ColumnHorzSizing = [[wgoColSizing]]'#13#10 +
    '    OptionsCustomize.DataRowSizing = [[wgoRowSizing]]'#13#10 +
    '    OptionsBehavior.ImmediateEditor = [[wgoAlwaysShowEditor]]'#13#10 +
    '    OptionsData.Editing = [[wgoEditing]]'#13#10 +
    '    OptionsBehavior.AlwaysShowEditor = [[wgoAlwaysShowEditor]]'#13#10 +
    '    OptionsData.Inserting = [[wgoInserting]]'#13#10 +
    '    OptionsCustomize.ColumnMoving = [[wgoColMoving]]'#13#10 +
    '    OptionsSelection.MultiSelect = [[wgoMultiSelect]]'#13#10 +
    '    OptionsData.CancelOnExit = [[wgoCancelOnExit]]'#13#10 +
    '    OptionsData.Deleting = [[wgoDeleting]]'#13#10 +

    '    OptionsCustomize.ColumnFiltering = False'#13#10 +    // 컬럼 필터링 미사용
    '    OptionsCustomize.ColumnSorting = False'#13#10 +      // 컬럼 소팅 미사용
    '    OptionsBehavior.FocusCellOnCycle = True'#13#10 +     // 마지막 컬럼에서 다음 행 첫컬럼으로 이동

    '    Styles.Selection = [[SEL_BG_COLOR]]'#13#10 +         // 선택 색상

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





  TAG_CXGRID_COLUMN_DEF = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxTextEditProperties'''#13#10 +

    '      Options.Editing = [[EDITING]]'#13#10 +
    '      Options.Focusing = [[EDITING]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Properties.Alignment.Horz = [[HORZ_ALIGN]]'#13#10 +
    '      DataBinding.FieldName = ''[[FIELD_NAME]]'''#13#10 +

    '      Visible = [[VISIBLE]]'#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +

    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = [[ROW_INDEX]]'#13#10 +
    '      Position.LineCount = [[LINE_COUNT]]'#13#10 +
    '      [[STYLE_CONTENT]]'#13#10 +
    '      [[STYLE_HEADER]]'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '    end'#13#10
  ;

  // EditStyle = wesNumber or (EditStyle is null and EditFormat = 금액('#,.' 포함))
  TAG_CXGRID_COLUMN_NUMBER = '' +
    '    object [[COLUMN_NAME]]: TcxGridDBBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxCurrencyEditProperties'''#13#10 +

    '      Properties.AssignedValues.DisplayFormat = True'#13#10 +
    '      Properties.AssignedValues.EditFormat = True'#13#10 +
    '      Properties.DecimalPlaces = [[DECIMAL_PLACE]]'#13#10 +
    '      Properties.DisplayFormat = ''[[EDIT_FORMAT]]'''#13#10 +
    '      Properties.EditFormat = ''[[EDIT_FORMAT]]'''#13#10 +

    '      Options.Editing = [[EDITING]]'#13#10 +
    '      Options.Focusing = [[EDITING]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Properties.Alignment.Horz = [[HORZ_ALIGN]]'#13#10 +
    '      DataBinding.FieldName = ''[[FIELD_NAME]]'''#13#10 +

    '      Visible = [[VISIBLE]]'#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +

    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = [[ROW_INDEX]]'#13#10 +
    '      Position.LineCount = [[LINE_COUNT]]'#13#10 +
    '      [[STYLE_CONTENT]]'#13#10 +
    '      [[STYLE_HEADER]]'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
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

    '      Options.Editing = [[EDITING]]'#13#10 +
    '      Options.Focusing = [[EDITING]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Properties.Alignment = [[HORZ_ALIGN]]'#13#10 +
    '      DataBinding.FieldName = ''[[FIELD_NAME]]'''#13#10 +

    '      Visible = [[VISIBLE]]'#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +

    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = [[ROW_INDEX]]'#13#10 +
    '      Position.LineCount = [[LINE_COUNT]]'#13#10 +
    '      [[STYLE_CONTENT]]'#13#10 +
    '      [[STYLE_HEADER]]'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '    end'#13#10
  ;


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

    '      Options.Editing = [[EDITING]]'#13#10 +
    '      Options.Focusing = [[EDITING]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Properties.Alignment.Horz = [[HORZ_ALIGN]]'#13#10 +
    '      DataBinding.FieldName = ''[[FIELD_NAME]]'''#13#10 +

    '      Visible = [[VISIBLE]]'#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +

    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = [[ROW_INDEX]]'#13#10 +
    '      Position.LineCount = [[LINE_COUNT]]'#13#10 +
    '      [[STYLE_CONTENT]]'#13#10 +
    '      [[STYLE_HEADER]]'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '    end'#13#10
  ;


  TAG_CXGRID_GROUP = '' +
    '      item'#13#10 +
    '        Caption = ''[[CAPTION]]'''#13#10 +
    '        FixedKind = [[FIXED_KIND]]'#13#10 +
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
    '      end'#13#10 +
    '      item'#13#10 +
    '        Caption = ''Hidden band'''#13#10 +
    '      end'#13#10
  ;

  TAG_CXGRID_FOOTER_ITEM = '' +
    '      item'#13#10 +
    '        Format = ''#,##0'''#13#10 +
    '        Kind = [[FOOTER_KIND]]'#13#10 +
    '        Column = [[FOOTER_COLUMN]]'#13#10 +
    '      end'#13#10
  ;

//        Caption = #48156#49373#48264#54840
//        Visible = False

type
  TEventOwner = (eoNone, eoGrid, eoView, eoData, eoDataSummury, eoIgnore);
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

  TAG_PROC_GRID_KEYPRESS = TAG_PROC_GRID_COMMON + '(Sender: TObject;'#13#10 +
    '  var Key: Char);';
  TAG_PROC_VIEW_KEYPRESS = TAG_PROC_VIEW_COMMON + '(Sender: TObject;'#13#10 +
    '  var Key: Char);';
  TAG_PROC_VIEW_EDITKEYDOWN = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);';
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

const
  EventTagInfos: array[0..8] of TEventTagInfo =
    (
      (EventName: 'EditDblClick';       RGEvent: 'OnDblClick';          EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_EDIT_DBLCLICK),
      (EventName: 'EditKeyDown';        RGEvent: 'OnKeyPress';          EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_EDITKEYDOWN),
      (EventName: 'ColumnHeaderClick';  RGEvent: 'OnColumnTitleClick';  EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_COL_HDR),
      (EventName: 'CustomDrawCell';     RGEvent: 'OnDrawCell';	        EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_CUST_DRAW),
      (EventName: 'CellClick';          RGEvent: 'OnClick';             EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_CELL_CLICK),

      (EventName: 'Enter';              RGEvent: 'OnEnter';	            EventOwner: eoGrid;         ProcTag: TAG_PROC_GRID_SENDER),
      (EventName: 'Exit';               RGEvent: 'OnExit';              EventOwner: eoGrid;         ProcTag: TAG_PROC_GRID_SENDER),
      (EventName: 'MouseDown';          RGEvent: 'OnMouseDown';         EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_MOUSEDOWN),
      (EventName: 'FocusedRecordChanged'; RGEvent: 'OnRowChange';         EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_RECCHG)
    );

function GetEventTagInfo(ARGEventProp: string; var OutInfo: TEventTagInfo): Boolean;
function GetColorToStyleName(AColor: string): string;

implementation

function GetEventTagInfo(ARGEventProp: string; var OutInfo: TEventTagInfo): Boolean;
var
  Info: TEventTagInfo;
begin
  Result := False;
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

function GetColorToStyleName(AColor: string): string;
const
  COLOR_TO_STYLE: array[0..10] of array[0..1] of string = (
    ('8454143', 'cxStyle1'),
    ('8454016', 'cxStyle2'),
    ('12615935', 'cxStyle3'),
    ('16751515', 'cxStyle4'),
    ('clAqua', 'cxStyle5'),
    ('clInactiveCaptionText', 'cxStyle6'),
    ('clLime', 'cxStyle7'),
    ('clMoneyGreen', 'cxStyle8'),
    ('clSilver', 'cxStyle9'),
    ('clSkyBlue', 'cxStyle10'),
    ('clYellow', 'cxStyle11')
  );
var
  I: Integer;
begin
  Result := 'nil';
  for I := 0 to Length(COLOR_TO_STYLE) - 1 do
    if COLOR_TO_STYLE[I][0] = AColor then
      Exit('dmDatabase.' + COLOR_TO_STYLE[I][1]);
end;

//{$Message Error 'Not implemented'}
end.
