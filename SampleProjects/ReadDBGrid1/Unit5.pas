unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges, dxScrollbarAnnotations,
  Data.DB, cxDBData, cxTextEdit, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxClasses,
  cxGridCustomView, cxGrid, Vcl.StdCtrls, cxGridDBTableView, cxCheckBox;

type
  TFooter = record

  end;
  TcxGridDBBandedColumnHelper = class helper for TcxGridDBBandedColumn
  private
    function GetFooterSummaryIndexes: TArray<Integer>;
    function GetFooters(Index: Integer): Variant;
    procedure SetFooters(Index: Integer; const Value: Variant);
  public
    property Footers[Index: Integer]: Variant read GetFooters write SetFooters;
  end;

  TForm5 = class(TForm)
    RealDBGrid3: TcxGrid;
    RealDBGrid3DBBandedTableView1: TcxGridDBBandedTableView;
    RealDBGrid3DBBandedTableView1Column1: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column2: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column3: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column4: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column5: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column6: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column7: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column8: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column9: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column10: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column11: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column12: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column13: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column14: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column15: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column16: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column17: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column18: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column19: TcxGridDBBandedColumn;
    RealDBGrid3DBBandedTableView1Column20: TcxGridDBBandedColumn;
    RealDBGrid3Level1: TcxGridLevel;
    Button1: TButton;
    RealDBGrid2: TcxGrid;
    RealDBGrid2DBBandedTableView1: TcxGridDBBandedTableView;
    RealDBGrid2DBBandedTableView1Column1: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column2: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column3: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column4: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column5: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column6: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column7: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column8: TcxGridDBBandedColumn;
    RealDBGrid2DBBandedTableView1Column9: TcxGridDBBandedColumn;
    RealDBGrid2Level1: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
//  RealDBGrid3DBBandedTableView1.Columns[5].Footer.
//  RealDBGrid3DBBandedTableView1.Columns[5].Footer.Values[0]  := format('%4.0n',[Buf_Box01]);
  RealDBGrid3DBBandedTableView1.Columns[5].Footers[0]  := 'test';

  ShowMessage(RealDBGrid3DBBandedTableView1.Columns[5].Footers[0]);
//  RealDBGrid3DBBandedTableView1.DataController.Summary.FooterSummaryValues[0] := 'test';


end;

procedure TForm5.FormCreate(Sender: TObject);
begin
//  TcxGridDBTableSummaryItem(RealDBGrid3DBBandedTableView1.DataController.Summary.FooterSummaryValues[0]).
end;

{ TcxGridDBBandedColumnHelper }

function TcxGridDBBandedColumnHelper.GetFooters(Index: Integer): Variant;
var
  Idxs: TArray<Integer>;
begin
  Idxs := GetFooterSummaryIndexes;
  if Length(Idxs) > Index then
    Result := GridView.DataController.Summary.FooterSummaryValues[Idxs[Index]];
end;

function TcxGridDBBandedColumnHelper.GetFooterSummaryIndexes: TArray<Integer>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to GridView.DataController.Summary.FooterSummaryItems.Count - 1 do
    if (TcxGridDBTableSummaryItem(GridView.DataController.Summary.FooterSummaryItems[i]).Column = Self) then
      Result := Result + [I];
end;

procedure TcxGridDBBandedColumnHelper.SetFooters(Index: Integer;
  const Value: Variant);
var
  Idxs: TArray<Integer>;
begin
  Idxs := GetFooterSummaryIndexes;
  if Length(Idxs) > Index then
    GridView.DataController.Summary.FooterSummaryValues[Idxs[Index]] := Value;
end;

end.
