unit ExtractForm;

interface

uses
  SrcConverterTypes,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmExtract = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    btnFooter: TButton;
    mmoFooter: TMemo;
    Label1: TLabel;
    edtKeywordFooter: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFooterClick(Sender: TObject);
  private
    { Private declarations }
    FFileInfos: TList<TFileInfo>;
  public
    { Public declarations }
    procedure SetFileInfos(AFileInfos: TList<TFileInfo>);
  end;

var
  frmExtract: TfrmExtract;

implementation

{$R *.dfm}

uses
  Environments,
  System.RegularExpressions;

procedure TfrmExtract.btnFooterClick(Sender: TObject);
var
  Info: TFileInfo;
  SrcFile: TStringList;
  I, ImplIdx, Idx: Integer;
  S, Pattern: string;
  Matchs: TMatchCollection;
begin
  SrcFile := TStringList.Create;
  Pattern := edtKeywordFooter.Text;
  for Info in FFileInfos do
  begin
    SrcFile.LoadFromFile(Info.GetFullpath(TEnv.Instance.RootPath));

    ImplIdx := -1;
    Idx := -1;

    // ��Ī�Ǵ� ����(Idx) ã��
    for I := 0 to SrcFile.Count - 1 do
    begin
      S := SrcFile[I];
      if ImplIdx = -1 then
      begin
        if S = 'implementation' then
          ImplIdx := I;

        Continue;
      end;

      Matchs := TRegEx.Matches(S, Pattern, [roIgnoreCase]);
      if Matchs.Count > 0 then
      begin
        Idx := I;
        Break;
      end;
    end;

    // ã�� ������ ������ ���� ����
    if idx = -1 then
      Continue;

    // Idx ���� �ö󰡸� procedure ������ enableControls�� �ִ��� ã��
    for I := Idx downto ImplIdx do
    begin
      S := SrcFile[I];
      if S.Contains('EnableControls') or S.Contains('enablecontrols') then
        Break;

      if S.StartsWith('procedure ') then
      begin
        mmoFooter.Lines.Add(Info.Filename);
        Break;
      end;
    end;
  end;
  SrcFile.Free;
end;

procedure TfrmExtract.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmExtract := nil;
end;

procedure TfrmExtract.SetFileInfos(AFileInfos: TList<TFileInfo>);
begin
  FFileInfos := AFileInfos;
end;

end.
