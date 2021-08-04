unit GridBandHeaderMergeForm;

interface

uses
  cxGridViewParser,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmBandHeader = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBandHeader: TfrmBandHeader;

implementation

{$R *.dfm}

procedure TfrmBandHeader.Button1Click(Sender: TObject);
var
  I: Integer;
  Parser: TGridViewParser;
begin
  Parser := TGridViewParser.Create;
  Parser.Parse(Memo1.Lines.Text);

  for I := 0 to Parser.Bands.Count - 1 do
    Memo2.Lines.Add(
      Parser.Bands[I].Caption + ' / ' +
      Parser.Bands[I].VisibleForCustomization.ToString
    );

  for I := 0 to Parser.Columns.Count - 1 do
    Memo2.Lines.Add(
      Parser.Columns[I].Caption + ' / ' +
      Parser.Columns[I].FieldName
    );

  Parser.Free;
end;

procedure TfrmBandHeader.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
