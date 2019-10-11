unit ViewerForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmViewer = class(TForm)
    mmoLog: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    class function JsonReformat(const AJson: string; Indented: Boolean): string;
    class procedure ShowData(ATitle, AData: string);
  end;

implementation

{$R *.dfm}

uses
  System.JSON.Readers,
  System.JSON.Types,
  System.JSON.Writers;

var
  frmJsonViewer: TfrmViewer;

{ TfrmJsonViewer }

procedure TfrmViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

class function TfrmViewer.JsonReformat(const AJson: string;
  Indented: Boolean): string;
var
  StringReader: TStringReader;
  StringBuilder: TStringBuilder;
  StringWriter: TStringWriter;

  JsonReader: TJsonTextReader;
  JsonWriter: TJsonTextWriter;
begin
  StringReader := TStringReader.Create(AJson);
  StringBuilder := TStringBuilder.Create;
  StringWriter := TStringWriter.Create(StringBuilder);

  JsonReader := TJsonTextReader.Create(StringReader);
  JsonWriter := TJsonTextWriter.Create(StringWriter);

  if Indented then
    JsonWriter.Formatting := TJsonFormatting.Indented;

  try
    JsonWriter.WriteToken(JsonReader);
    Result := StringBuilder.ToString;
  finally
    StringReader.Free;
    StringBuilder.Free;
    StringWriter.Free;

    JsonReader.Free;
    JsonWriter.Free;
  end;
end;

class procedure TfrmViewer.ShowData(ATitle, AData: string);
begin
  if not Assigned(frmJsonViewer) then
  begin
    frmJsonViewer := TfrmViewer.Create(Application);
    frmJsonViewer.Left := Application.MainForm.Left + Application.MainForm.Width;
    frmJsonViewer.Top := Application.MainForm.Top;
  end;
  frmJsonViewer.Caption := ATitle;
  frmJsonViewer.mmoLog.Lines.Text := AData;
  frmJsonViewer.Show;
end;

end.
