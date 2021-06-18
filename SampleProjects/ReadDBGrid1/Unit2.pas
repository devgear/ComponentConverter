unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  Data.DB, cxDBData, cxTextEdit, cxImageComboBox, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm2 = class(TForm)
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
    RealDBGrid1DBBandedTableView1Column18: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column19: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column20: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column21: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column22: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column23: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column24: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column25: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column26: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column27: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column28: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column29: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column30: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column31: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column32: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column33: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column34: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column35: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column36: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column37: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column38: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column39: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column40: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column41: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column42: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column43: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column44: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column45: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column46: TcxGridDBBandedColumn;
    RealDBGrid1Level1: TcxGridLevel;
    qry_Master: TFDQuery;
    qry_MasterWork_COD: TStringField;
    qry_MasterBook_COD: TStringField;
    qry_MasterKJ_COD: TStringField;
    qry_MasterAuthor_OPT: TStringField;
    qry_MasterVolumn: TStringField;
    qry_MasterPubCop_COD: TStringField;
    qry_MasterAuthor: TStringField;
    qry_MasterPack_Busu: TIntegerField;
    qry_MasterBox_Busu: TIntegerField;
    qry_MasterBJ_OPT: TStringField;
    qry_MasterPaperTy_COD: TStringField;
    qry_MasterFilm_Work: TStringField;
    qry_MasterFilm_Stat: TStringField;
    qry_MasterFilm_Mark: TStringField;
    qry_MasterBoxUP_COD: TStringField;
    qry_MasterBook_YR: TStringField;
    qry_MasterFilm_Mod_DAY: TStringField;
    qry_MasterFilm_Mod: TStringField;
    qry_MasterBook_OPT: TStringField;
    qry_MasterCompany_DES: TStringField;
    qry_MasterBasBook_DES: TStringField;
    qry_MasterPric: TIntegerField;
    qry_MasterDisc: TIntegerField;
    qry_Mastereb: TIntegerField;
    qry_MasterCost: TIntegerField;
    qry_MasterPlan_MakeBusu: TIntegerField;
    qry_MasterPlan_OPT: TStringField;
    qry_MasterBDEDesigner: TStringField;
    qry_MasterPanType_COD: TStringField;
    qry_MasterIntegerField: TIntegerField;
    qry_MasterStringField: TStringField;
    qry_MasterStringField3: TStringField;
    qry_MasterStringField2: TStringField;
    qry_MasterStringField4: TStringField;
    qry_MasterDateTimeField: TDateTimeField;
    qry_MasterStringField5: TStringField;
    qry_MasterStringField6: TStringField;
    qry_MasterField: TIntegerField;
    qry_MasterField2: TIntegerField;
    qry_MasterIntegerField5: TIntegerField;
    qry_MasterIntegerField2: TIntegerField;
    qry_MasterStringField7: TStringField;
    qry_MasterStringField8: TStringField;
    qry_MasterStringField9: TStringField;
    qry_MasterStringField10: TStringField;
    qry_MasterIntegerField3: TIntegerField;
    qry_MasterStringField11: TStringField;
    qry_MasterStringField12: TStringField;
    qry_MasterStringField13: TStringField;
    qry_MasterStringField14: TStringField;
    qry_MasterIntegerField4: TIntegerField;
    qry_MasterCD: TStringField;
    qry_MasterStringField15: TStringField;
    qry_MasterStringField16: TStringField;
    qry_MasterStringField17: TStringField;
    qry_MasterStringField18: TStringField;
    qry_MasterStringField19: TStringField;
    qry_MasterStringField20: TStringField;
    qry_MasterStringField21: TStringField;
    qry_MasterStringField22: TStringField;
    qry_MasterIntegerField6: TIntegerField;
    qry_MasterStringField23: TStringField;
    qry_MasterStringField24: TStringField;
    qry_MasterStringField25: TStringField;
    qry_MasterStringField27: TStringField;
    qry_MasterStringField26: TStringField;
    DBKatasCommon2: TFDConnection;
    dsMaster: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
