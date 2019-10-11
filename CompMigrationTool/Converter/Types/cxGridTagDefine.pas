unit cxGridTagDefine;

interface

const
  TAG_CXGRID_COMP = '' +
    'object [[COMP_NAME]]: TcxGrid'#13#10 +
    '  Left = [[COMP_LEFT]]'#13#10 +
    '  Top = [[COMP_TOP]]'#13#10 +
    '  Width = [[COMP_WIDTH]]'#13#10 +
    '  Height = [[COMP_HEIGHT]]'#13#10 +
    '  Align = [[COMP_ALIGN]]'#13#10 +
    '  PopupMenu = [[POPUP_MENU]]'#13#10 +
    '  TabOrder = 0'#13#10 +
    '  LookAndFeel.NativeStyle = False'#13#10 +
    '[[GRID_EVENT]]'#13#10 +
    '  object [[VIEW_NAME]]: TcxGridBandedTableView'#13#10 +
    '[[VIEW_EVENT]]'#13#10 +
    '    DataController.Summary.DefaultGroupSummaryItems = <>'#13#10 +
    '    DataController.Summary.FooterSummaryItems = <'#13#10 +
    '[[FOOTER_ITEMS]]'#13#10 +
    '    >'#13#10 +
    '    DataController.Summary.SummaryGroups = <>'#13#10 +
    '    OptionsView.BandHeaders = [[BAND_HEADERS]]'#13#10 +
    '    OptionsView.Footer = [[FOOTER_VISIBLE]]'#13#10 +
    '    OptionsView.Indicator = True'#13#10 +
    '    OptionsView.HeaderHeight = 25'#13#10 +
    '    OptionsView.DataRowHeight = 25'#13#10 +
    '    OptionsView.GroupByBox = False'#13#10 +
    '[[DATA_EVENT]]'#13#10 +
    '    NavigatorButtons.ConfirmDelete = False'#13#10 +
    '    Styles.StyleSheet = ComModule.GridBandedTableViewStyleSheetDevExpress'#13#10 +
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
    '    object [[COLUMN_NAME]]: TcxGridBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxTextEditProperties'''#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Visible = [[VISIBLE]]'#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = 0'#13#10 +
    '    end'#13#10
  ;
  TAG_CXGRID_COLUMN_FLT = '' +
    '    object [[COLUMN_NAME]]: TcxGridBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      DataBinding.ValueType = ''Float'''#13#10 +
    '      PropertiesClassName = ''TcxCurrencyEditProperties'''#13#10 +
    '      Visible  = [[VISIBLE]]'#13#10 +
    '      Properties.Alignment.Horz = taRightJustify'#13#10 +
    '      Properties.Alignment.Vert = taVCenter'#13#10 +
    '      Properties.DisplayFormat = ''[[DISPLAY_FORMAT]]'''#13#10 +
    '      Properties.EditFormat = ''###0;'''#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Properties.ValidateOnEnter = True'#13#10 +
    '      FooterAlignmentHorz = taRightJustify'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = 0'#13#10 +
    '    end'#13#10
  ;
  TAG_CXGRID_COLUMN_DATE = '' +
    '    object [[COLUMN_NAME]]: TcxGridBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      DataBinding.ValueType = ''DateTime'''#13#10 +
    '      PropertiesClassName = ''TcxDateEditProperties'''#13#10 +
    '      Visible  = [[VISIBLE]]'#13#10 +
    '      Properties.Alignment.Horz = taRightJustify'#13#10 +
    '      Properties.Alignment.Vert = taVCenter'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = 0'#13#10 +
    '    end'#13#10
  ;
  TAG_CXGRID_COLUMN_BOOL = '' +
    '    object [[COLUMN_NAME]]: TcxGridBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxCheckBoxProperties'''#13#10 +
    '      Visible = [[VISIBLE]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      Properties.DisplayChecked = ''True'''#13#10 +
    '      Properties.DisplayUnchecked = ''False'''#13#10 +
    '      Properties.NullStyle = nssUnchecked'#13#10 +
    '      Properties.ValueChecked = ''True'''#13#10 +
    '      Properties.ValueUnchecked = ''False'''#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +
    '      Width = [[WIDTH]]'#13#10 +
    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = 0'#13#10 +
    '    end'#13#10
  ;
  TAG_CXGRID_COLUMN_ITEM = '' +
    '        item'#13#10 +
    '          Description = ''[[ITEM]]'''#13#10 +
    '          Value = ''[[VALUE]]'''#13#10 +
    '        end'#13#10
  ;
  TAG_CXGRID_COLUMN_ITEMS = '' +
    '    object [[COLUMN_NAME]]: TcxGridBandedColumn'#13#10 +
    '      Caption = ''[[COLUMN_CAPTION]]'''#13#10 +
    '      PropertiesClassName = ''TcxImageComboBoxProperties'''#13#10 +
    '      Properties.Items = <'#13#10 +
    '[[ITEMS]]'+
    '      >'#13#10 +
    '      Visible = [[VISIBLE]]'#13#10 +
    '      Properties.ReadOnly = [[READONLY]]'#13#10 +
    '      FooterAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentHorz = taCenter'#13#10 +
    '      HeaderAlignmentVert = vaCenter'#13#10 +
    '      HeaderGlyphAlignmentHorz = taCenter'#13#10 +
    '      Position.BandIndex = [[BAND_INDEX]]'#13#10 +
    '      Position.ColIndex = [[COL_INDEX]]'#13#10 +
    '      Position.RowIndex = 0'#13#10 +
    '    end'#13#10
  ;

  TAG_CXGRID_GROUP = '' +
    '      item'#13#10 +
    '        Caption = ''[[CAPTION]]'''#13#10 +
    '        Visible = [[VISIBLE]]'#13#10 +
    '        Width = [[WIDTH]]'#13#10 +
    '      end'#13#10
  ;
  TAG_CXGRID_GROUP_NULL = '' +
    '      item'#13#10 +
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

  TAG_PROC_DATA_NEWREC = TAG_PROC_DATA_COMMON +
    '      ADataController: TcxCustomDataController; ARecordIndex: Integer);';
  TAG_PROC_VIEW_RECCHG = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; APrevFocusedRecord,'#13#10 +
    '      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);';
  TAG_PROC_DATA_SUM = TAG_PROC_SUMR_COMMON +
    '      ASender: TcxDataSummary);';

  TAG_PROC_VIEW_SELCHG = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; APrevFocusedItem,'#13#10 +
    '      AFocusedItem: TcxCustomGridTableItem);';
  TAG_PROC_VIEW_VALCHG = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);';
  TAG_PROC_VIEW_EDITING = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      var AAllow: Boolean);';

  TAG_PROC_VIEW_KEY_UD = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);';
  TAG_PROC_VIEW_KEY_PRESS = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;'#13#10 +
    '      AEdit: TcxCustomEdit; var Key: Char);';
  TAG_PROC_VIEW_COL_HDR = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxGridTableView; AColumn: TcxGridColumn);';
  TAG_PROC_VIEW_CUST_DRAW = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;'#13#10 +
    '      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);';
  TAG_PROC_VIEW_CELL_CLICK = TAG_PROC_VIEW_COMMON + '('#13#10 +
    '      Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;'#13#10 +
    '      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);';

const
  EventTagInfos: array[0..27-3] of TEventTagInfo =
    (
      (EventName: 'AfterSummary';       RGEvent: 'OnAfterCalcFooters';	EventOwner: eoDataSummury;  ProcTag: TAG_PROC_DATA_SUM),
      (EventName: 'AfterCancel';        RGEvent: 'OnAfterCancel';       EventOwner: eoData;         ProcTag: TAG_PROC_DATA_CTRLR),
      (EventName: 'AfterDelete';        RGEvent: 'OnAfterDelete';	      EventOwner: eoData;         ProcTag: TAG_PROC_DATA_CTRLR),
      (EventName: 'AfterInsert';        RGEvent: 'OnAfterInsert';       EventOwner: eoData;         ProcTag: TAG_PROC_DATA_CTRLR),
      (EventName: 'AfterPost';          RGEvent: 'OnAfterPost';	        EventOwner: eoData;         ProcTag: TAG_PROC_DATA_CTRLR),

      (EventName: 'BeforeDelete';       RGEvent: 'OnBeforeDelete';      EventOwner: eoData;         ProcTag: TAG_PROC_DATA_NEWREC),
      (EventName: 'BeforeInsert';       RGEvent: 'OnBeforeInsert';	    EventOwner: eoData;         ProcTag: TAG_PROC_DATA_CTRLR),
      (EventName: 'BeforePost';         RGEvent: 'OnBeforePost';        EventOwner: eoData;         ProcTag: TAG_PROC_DATA_CTRLR),
//      (EventName: 'not used';  RGEvent: 'OnCalcColumns';	    EventOwner: eoNone;       ProcTag: ''),
      (EventName: 'EditKeyPress';       RGEvent: 'OnCellEnter';         EventOwner: eoIgnore;         ProcTag: ''),

//      (EventName: 'not used';  RGEvent: 'OnCellExit';	        EventOwner: eoNone;       ProcTag: ''),
      (EventName: 'CellClick';          RGEvent: 'OnClick';             EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_CELL_CLICK),
      (EventName: 'ColumnHeaderClick';  RGEvent: 'OnColumnTitleClick';  EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_COL_HDR),
      (EventName: 'DblClick';           RGEvent: 'OnDblClick';          EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_SENDER),

      // 중복
      (EventName: 'CustomDrawCell';     RGEvent: 'OnDrawCell';	        EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_CUST_DRAW),

      (EventName: 'CustomDrawCell';     RGEvent: 'OnDrawRow';           EventOwner: eoIgnore;         ProcTag: ''),
      (EventName: 'Enter';              RGEvent: 'OnEnter';	            EventOwner: eoGrid;         ProcTag: TAG_PROC_GRID_SENDER),
      (EventName: 'Exit';               RGEvent: 'OnExit';              EventOwner: eoGrid;         ProcTag: TAG_PROC_GRID_SENDER),
//      (EventName: 'not used';  RGEvent: 'OnGroupTitleClick';	EventOwner: eoNone;       ProcTag: ''),
      (EventName: 'EditKeyDown';        RGEvent: 'OnKeyDown';           EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_KEY_UD),

      (EventName: 'EditKeyPress';       RGEvent: 'OnKeyPress';	        EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_KEY_PRESS),
      (EventName: 'EditKeyUp';          RGEvent: 'OnKeyUp';             EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_KEY_UD),
      (EventName: 'NewRecord';          RGEvent: 'OnNewRow';	          EventOwner: eoData;         ProcTag: TAG_PROC_DATA_NEWREC),
      // 중복
      (EventName: 'FocusedRecordChanged'; RGEvent: 'OnRowChange';         EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_RECCHG),
      (EventName: 'FocusedRecordChanged'; RGEvent: 'OnRowExit';	          EventOwner: eoIgnore;         ProcTag: ''),

      (EventName: 'FocusedItemChanged'; RGEvent: 'OnSelectionChange';   EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_SELCHG),
      (EventName: 'EditValueChanged';   RGEvent: 'OnValueChanged';	    EventOwner: eoView;         ProcTag: TAG_PROC_VIEW_VALCHG),
      (EventName: 'EditValueChanged';   RGEvent: 'OnValueChanging';     EventOwner: eoIgnore;       ProcTag: '')
    );

function GetEventTagInfo(ARGEventProp: string; var OutInfo: TEventTagInfo): Boolean;

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

//{$Message Error 'Not implemented'}
end.
