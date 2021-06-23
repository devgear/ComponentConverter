unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  dxScrollbarAnnotations, cxDBData, cxTextEdit, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxClasses, cxGridCustomView, cxGrid;

type
  TForm6 = class(TForm)
    Memo1: TMemo;
    QryBusDB1: TFDQuery;
    QryBusDB1BDEDesigner: TStringField;
    QryBusDB1BDEDesigner2: TStringField;
    QryBusDB1IntegerField: TIntegerField;
    DBKatasBusDB2: TFDConnection;
    Button1: TButton;
    DataSource1: TDataSource;
    RealDBGrid1: TcxGrid;
    RealDBGrid1DBBandedTableView1: TcxGridDBBandedTableView;
    RealDBGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn;
    RealDBGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn;
    RealDBGrid1Level1: TcxGridLevel;
    procedure Button1Click(Sender: TObject);
    procedure QryBusDB1AfterScroll(DataSet: TDataSet);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.Button1Click(Sender: TObject);
begin
  QryBusDB1.Close;
  QryBusDB1.ParamByName('pWork').AsString := '21FA1';
  QryBusDB1.ParamByName('pYN').AsString := '1';
  QryBusDB1.ParamByName('pYear').AsString := '2021';
  Memo1.Lines.Add('Open');
//  QryBusDB1.DisableControls;
  QryBusDB1.Open;
  QryBusDB1.First;
//  QryBusDB1.EnableControls;
end;

procedure TForm6.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if QryBusDB1.State = dsOpening then
  begin
    Memo1.Lines.Add('Exit');
    Exit;
  end;

  Memo1.Lines.Add('DataChange ' + QryBusDB1.RecNo.ToString);
  if Assigned(Field) then
    Memo1.Lines.Add(Field.FieldName);
end;

procedure TForm6.QryBusDB1AfterScroll(DataSet: TDataSet);
begin
  if QryBusDB1.ControlsDisabled then
    Exit;

  Memo1.Lines.Add('AfterScroll ' + DataSet.RecNo.ToString);
end;

end.
