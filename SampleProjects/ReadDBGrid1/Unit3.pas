unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  Data.DB, cxDBData, cxTextEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, cxCheckBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm3 = class(TForm)
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

end.
