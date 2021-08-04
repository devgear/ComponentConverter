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
    Label2: TLabel;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    mmoCustomDrawCell: TMemo;
    btnCustomDrawCell: TButton;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFooterClick(Sender: TObject);
    procedure btnCustomDrawCellClick(Sender: TObject);
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
  I, J, ImplIdx, Idx: Integer;
  S, Pattern: string;
  Matchs: TMatchCollection;
  HasWhile, HasFind: Boolean;
begin
  SrcFile := TStringList.Create;
  Pattern := edtKeywordFooter.Text;
  for Info in FFileInfos do
  begin
    SrcFile.LoadFromFile(Info.GetFullpath(TEnv.Instance.RootPath));

    ImplIdx := -1;
    Idx := -1;

    // 매칭되는 라인(Idx) 찾기
    for I := 0 to SrcFile.Count - 1 do
    begin
      S := SrcFile[I];
      if ImplIdx = -1 then
      begin
        if S = 'implementation' then
          ImplIdx := I;

        Continue;
      end;

      if S.StartsWith('procedure ') then
      begin
        HasWhile := False;
        HasFind := False;
      end;

      if (not HasWhile) and S.Contains('while ') then
        HasWhile := True;

      Matchs := TRegEx.Matches(S, Pattern, [roIgnoreCase]);
      if (not HasFind) and HasWhile and (Matchs.Count > 0) then
      begin
        Idx := I;

        // Idx 위로 올라가며 procedure 시작전 enableControls가 있는지 찾기
        for J := Idx downto ImplIdx do
        begin
          S := SrcFile[J];
          if S.Contains('EnableControls') or S.Contains('enablecontrols') then
            Break;

          if S.StartsWith('procedure ') then
          begin
            mmoFooter.Lines.Add(Format('%s (%d : %s)', [Info.Filename, Idx, SrcFile[Idx]]));
            HasFind := True;
            Break;
          end;
        end;
      end;
    end;
  end;
  SrcFile.Free;
end;

procedure TfrmExtract.btnCustomDrawCellClick(Sender: TObject);
var
  Info: TFileInfo;
  SrcFile: TStringList;
  I, J, ImplIdx, Idx: Integer;
  S, Pattern: string;
  Matchs: TMatchCollection;
  HasWhile, HasFind: Boolean;
  ProcName: string;
begin
  SrcFile := TStringList.Create;
  Pattern := edtKeywordFooter.Text;
  for Info in FFileInfos do
  begin
    SrcFile.LoadFromFile(Info.GetFullpath(TEnv.Instance.RootPath));

    ImplIdx := -1;
    Idx := -1;

    // 매칭되는 라인(Idx) 찾기
    for I := 0 to SrcFile.Count - 1 do
    begin
      S := SrcFile[I];
      if ImplIdx = -1 then
      begin
        if S = 'implementation' then
          ImplIdx := I;

        Continue;
      end;

      if S.StartsWith('procedure ') or S.StartsWith('function ') then
      begin
        Idx := Pos('.', S);
        ProcName := Copy(S, Idx+1, Pos('(', S)-Idx-1);
        if ProcName = '' then
          ProcName := Copy(S, Idx+1, Pos(';', S)-Idx-1);
      end;

      if not ProcName.Contains('CustomDrawCell') then
        Continue;

      if S.Contains('TcxGridDBBandedTableView(Sender).GetColumnDataByFieldName(AViewInfo, (*TODO*)') then
      begin
        mmoCustomDrawCell.Lines.Add(Format('%s (%d : %s)', [Info.Filename, I, S]));
      end;
    end;
  end;
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
