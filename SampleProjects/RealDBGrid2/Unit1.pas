unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Param,
  FireDAC.Phys.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, Data.DB, cxDBData, cxClasses, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView,
  cxGridCustomView, cxGridLevel, cxGrid, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, cxTextEdit, dxSkinsCore, dxSkinBasic, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, Vcl.StdCtrls, cxLabel, cxGridDBTableView,
  xlcClasses, xlEngine, xlReport, cxContainer, cxCheckBox, cxDropDownEdit;

const
  UM_Message = WM_USER +1;

type
  TForm1 = class(TForm)
    RealDBGrid1: TcxGrid;
    RealDBGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    RealDBGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column4: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column5: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column6: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column7: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column8: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column9: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column10: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column11: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column12: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column13: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column14: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column15: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column16: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column17: TcxGridDBBandedColumn;
    RealDBGrid1Level1: TcxGridLevel;
    DBKatasCommon2: TFDConnection;
    dsMaster: TDataSource;
    qry_Master: TFDQuery;
    qry_MasterCompany_Ty_Cod: TStringField;
    qry_MasterCompany_Cod: TStringField;
    qry_MasterCompany_Des: TStringField;
    qry_MasterCompany_Name: TStringField;
    qry_MasterSaNo: TStringField;
    qry_MasterPName: TStringField;
    qry_MasterPost: TStringField;
    qry_MasterAddr: TStringField;
    qry_MasterUpTae: TStringField;
    qry_MasterKind: TStringField;
    qry_MasterTel: TStringField;
    qry_MasterFax: TStringField;
    qry_MasterMun_Plc: TStringField;
    qry_MasterList_YN: TStringField;
    qry_MasterFilm_Tel: TStringField;
    qry_MasterFilm_Fax: TStringField;
    qry_MasterPrn_Chk: TIntegerField;
    qry_MasterStringField: TStringField;
    qry_MasterStringField2: TStringField;
    qry_MasterStringField3: TStringField;
    qry_MasterStringField4: TStringField;
    qry_MasterStringField5: TStringField;
    cxStyleRepository: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    Button1: TButton;
    cxGrid1: TcxGrid;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    cxGridDBBandedColumn1: TcxGridDBBandedColumn;
    cxGridDBBandedColumn2: TcxGridDBBandedColumn;
    cxGridDBBandedColumn3: TcxGridDBBandedColumn;
    cxGridDBBandedColumn4: TcxGridDBBandedColumn;
    cxGridDBBandedColumn5: TcxGridDBBandedColumn;
    cxGridDBBandedColumn6: TcxGridDBBandedColumn;
    cxGridDBBandedColumn7: TcxGridDBBandedColumn;
    cxGridDBBandedColumn8: TcxGridDBBandedColumn;
    cxGridDBBandedColumn9: TcxGridDBBandedColumn;
    cxGridDBBandedColumn10: TcxGridDBBandedColumn;
    cxGridDBBandedColumn11: TcxGridDBBandedColumn;
    cxGridDBBandedColumn12: TcxGridDBBandedColumn;
    cxGridDBBandedColumn13: TcxGridDBBandedColumn;
    cxGridDBBandedColumn14: TcxGridDBBandedColumn;
    cxGridDBBandedColumn15: TcxGridDBBandedColumn;
    cxGridDBBandedColumn16: TcxGridDBBandedColumn;
    cxGridDBBandedColumn17: TcxGridDBBandedColumn;
    cxGridLevel1: TcxGridLevel;
    Edit1: TEdit;
    Memo1: TMemo;
    cxTextEdit1: TcxTextEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cxGrid1DBBandedTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxGrid1DBBandedTableView1EditKeyPress(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Char);
    procedure cxGridDBBandedTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDBBandedTableView1EditKeyPress(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Char);
    procedure cxGridDBBandedTableView1DblClick(Sender: TObject);
    procedure cxGridDBBandedTableView1EditDblClick(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit);
    procedure cxGridDBBandedColumn3HeaderClick(Sender: TObject);
    procedure cxGridDBBandedTableView1ColumnHeaderClick(
      Sender: TcxGridTableView; AColumn: TcxGridColumn);
    procedure cxTextEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure umMessage(var Message: TMessage); message UM_MESSAGE;
    procedure cxGridDBBandedTableView1InitEdit(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit);
    procedure cxGridDBBandedTableView1UpdateEdit(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit);
  private
    { Private declarations }
    procedure Log(const AValue: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//  cxGrid1DBBandedTableView1.OptionsView.DataRowHeight := 101;
  cxGridDBBandedTableView1.Columns[3].PropertiesClassName := 'TcxLabelProperties';
end;

{
procedure TfrmTbF_006I.qry_MasterUpdateRecord(DataSet: TDataSet;
  UpdateKind: TFDUpdateRequest; var UpdateAction: TFDErrorAction);
}
procedure TForm1.Button2Click(Sender: TObject);
begin
//  ShowMessage(cxGrid1DBBandedTableView1.Controller.FocusedItemIndex.ToString);
//  cxGrid1DBBandedTableView1.Controller.FocusedItemIndex := 0;

//cxGrid1DBBandedTableView1.Controller.FocusedItem.DataBinding
//  cxGrid1DBBandedTableView1.Controller.FocusedColumn.DataBinding.
//  ShowMessage(TcxGridDBBandedColumn(cxGrid1DBBandedTableView1.Controller.FocusedItem).DataBinding.FieldName);
//
//  cxGrid1DBBandedTableView1.DataController.DataSource

//  cxGrid1DBBandedTableView1.DataController.IsEditing


//  cxGrid1DBBandedTableView1.Columns[0].Visible
//  cxGrid1DBBandedTableView1.ColumnCount

end;

procedure TForm1.cxGrid1DBBandedTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if AViewInfo.Item.Index = 2 then
  begin
    ACanvas.Brush.Color := clRed;
  end;
end;

procedure TForm1.cxGrid1DBBandedTableView1EditKeyPress(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Char);
begin
  if Key = #13 then
  begin
    ShowMessage('cxGrid1DBBandedTableView1EditKeyPress');
  end;
end;

procedure TForm1.cxGridDBBandedColumn3HeaderClick(Sender: TObject);
begin
//  var AColumn := TcxGridColumn(cxGridDBBandedTableView1.Controller.FocusedItem);
  var AColumn := TcxGridColumn(Sender);
  Log(AColumn.Index.ToString);
end;

procedure TForm1.cxGridDBBandedTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  // CellSelect = False 시 선택한 컬럼에 연결된 필드정보를 찾을 수없음
    // FocusedItem = nil
  // CellSelect = False  시 CheckBox 컬럼 이벤트가 발생하지 않음
  if cxGridDBBandedTableView1.Controller.FocusedItem = nil then
  begin
    Log('FocusedItem = nil');
  end
  else
  begin
    Log(TcxGridDBBandedColumn(Sender.Controller.FocusedItem).DataBinding.FieldName);
  end;

//  Edit1.Text := TcxGridDBBandedColumn(ACellViewInfo.Item).DataBinding.FieldName;
//  Log(Edit1.Text);
//  Edit1.Text := TcxGridDBBandedColumn(cxGridDBBandedTableView1.Controller.FocusedColumn).DataBinding.FieldName

//  Edit1.Text := TcxGridDBBandedColumn(Sender.Controller.FocusedItem).DataBinding.FieldName
end;

procedure TForm1.cxGridDBBandedTableView1ColumnHeaderClick(
  Sender: TcxGridTableView; AColumn: TcxGridColumn);
begin
  //
//  AColumn.Index
end;

procedure TForm1.cxGridDBBandedTableView1DblClick(Sender: TObject);
begin
  //
end;

procedure TForm1.cxGridDBBandedTableView1EditDblClick(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
begin
  // CellSelect = True 시 DblClick 이벤트가 발생하지 않음
  Log('cxGridDBBandedTableView1EditDblClick');
end;

procedure TForm1.cxGridDBBandedTableView1EditKeyPress(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Char);
begin
  Log('cxGridDBBandedTableView1EditKeyPress');
  if not Qry_Master.Active then Exit;

  if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsInsert]) then
     Qry_Master.Edit;

  if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsEdit, dsInsert]) then Exit;

  if (RealDBGrid1DBBandedTableView1.DataController.IsEditing = True) and (Key = #13) then begin
    Log('RETURN');
  end;
end;

procedure TForm1.cxGridDBBandedTableView1InitEdit(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
begin
//  if AEdit is TcxTextEdit then
//    PostMessage(Handle, UM_MESSAGE, Integer(AEdit), 0);
end;

procedure TForm1.cxGridDBBandedTableView1UpdateEdit(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
begin
  Log('cxGridDBBandedTableView1UpdateEdit');
end;

procedure TForm1.cxTextEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  Log('cxGridDBBandedTableView1EditKeyPress');
  if not Qry_Master.Active then Exit;

  if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsInsert]) then
     Qry_Master.Edit;

  if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsEdit, dsInsert]) then Exit;

  if (RealDBGrid1DBBandedTableView1.DataController.IsEditing = True) and (Key = #13) then begin
    Log('RETURN');
  end;
end;

procedure TForm1.Log(const AValue: string);
begin
  Memo1.Lines.Add(AValue);
end;

procedure TForm1.umMessage(var Message: TMessage);
begin
  TcxTextEdit(Message.WParam).OnKeyPress := cxTextEdit1KeyPress;
end;

end.

