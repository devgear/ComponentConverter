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
  xlcClasses, xlEngine, xlReport;

type
  TForm1 = class(TForm)
    dsMaster: TDataSource;
    UpdateSQL_Record: TFDUpdateSQL;
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
    qry_MasterDong: TStringField;
    qry_MasterStringField: TStringField;
    qry_MasterStringField2: TStringField;
    qry_MasterStringField3: TStringField;
    qry_MasterStringField4: TStringField;
    qry_MasterStringField5: TStringField;
    DBKatasCommon2: TFDConnection;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    cxGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column4: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column5: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column6: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column7: TcxGridDBBandedColumn;
    cxGrid1DBBandedTableView1Column8: TcxGridDBBandedColumn;
    Memo1: TMemo;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    Button1: TButton;
    ComboBox1: TComboBox;
    FDQuery1: TFDQuery;
    xlReport1: TxlReport;
    kbmMemT: TFDMemTable;
    kbmMemTL: TStringField;
    kbmMemTL2: TStringField;
    kbmMemTL3: TStringField;
    kbmMemTR: TStringField;
    kbmMemTR2: TStringField;
    kbmMemTR3: TStringField;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  cxGrid1DBBandedTableView1.OptionsView.DataRowHeight := 101;
end;

{
procedure TfrmTbF_006I.qry_MasterUpdateRecord(DataSet: TDataSet;
  UpdateKind: TFDUpdateRequest; var UpdateAction: TFDErrorAction);
}
end.
