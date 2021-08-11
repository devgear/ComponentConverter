unit SrcMigForm;

interface

uses
  System.Generics.Collections, SrcConverterTypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Menus, Vcl.Samples.Gauges;

type
  TfrmSrcMainForm = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    edtRootPath: TEdit;
    btnSelectDir: TButton;
    btnLoadFiles: TButton;
    chkRecursively: TCheckBox;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    lvFiles: TListView;
    chkAllFiles: TCheckBox;
    Panel4: TPanel;
    lvConverter: TListView;
    chkAllConverter: TCheckBox;
    Panel6: TPanel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    btnRunConvert: TButton;
    chkBackup: TCheckBox;
    FileOpenDialog1: TFileOpenDialog;
    lblCount: TLabel;
    PopupMenu1: TPopupMenu;
    mniAfterSelect: TMenuItem;
    mniBeforeSelelect: TMenuItem;
    mniSelectAll: TMenuItem;
    mniUnselectAll: TMenuItem;
    N5: TMenuItem;
    cbxLogLevel: TComboBox;
    Button1: TButton;
    ProgressBar1: TGauge;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectDirClick(Sender: TObject);
    procedure btnLoadFilesClick(Sender: TObject);
    procedure btnRunConvertClick(Sender: TObject);
    procedure chkAllConverterClick(Sender: TObject);
    procedure chkAllFilesClick(Sender: TObject);
    procedure mniBeforeSelelectClick(Sender: TObject);
    procedure mniAfterSelectClick(Sender: TObject);
    procedure mniSelectAllClick(Sender: TObject);
    procedure mniUnselectAllClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FRootPath: string;
    FFileInfos: TList<TFileInfo>;   // 로드한 파일 정보 목록(재조회 또는 종료 시 초기화 필요)
  public
    { Public declarations }
    procedure LoadFilelist(APath: string = '');
    procedure ClearFielInfos;
  end;

var
  frmSrcMainForm: TfrmSrcMainForm;

implementation

{$R *.dfm}

uses System.IOUtils, System.StrUtils, Environments, SrcConverter, Logger,
  ExtractForm;

procedure TfrmSrcMainForm.btnLoadFilesClick(Sender: TObject);
begin
  lvFiles.Items.Clear;
  ClearFielInfos;

  FRootPath := edtRootPath.Text;
  TConvertManager.Instance.RootPath := FRootPath;
  LoadFilelist;

  btnRunConvert.Enabled := (lvFiles.Items.Count > 0);

  TEnv.Instance.RootPath := FRootPath;
  TEnv.Instance.Recursively := chkRecursively.Checked;
end;

procedure TfrmSrcMainForm.btnRunConvertClick(Sender: TObject);
var
  I: Integer;
  Data: TFileInfo;
  Convs: TArray<TConverter>;
  TotalCount, UpdateCount: Integer;
  R: TRect;
begin
  for I := 0 to lvFiles.Items.Count - 1 do
    lvFiles.Items[I].SubItems[1] := '';

  Convs := [];
  // 작업 대상 컨버터
  for I := 0 to lvConverter.Items.Count - 1 do
  begin
    if lvConverter.Items[I].Checked then
      Convs := Convs + [TConverter(lvConverter.Items[I].Data)];
  end;

  TotalCount := 0;

  TLogger.Log('Start migration');

  TConvertManager.Instance.Init;
  TConvertManager.Instance.UseBackup := chkBackup.Checked;
  TEnv.Instance.UseBackup := chkBackup.Checked;
  TEnv.Instance.LogLevel := cbxLogLevel.ItemIndex;

  TLogger.Instance.LogLevel := TLogLevel(cbxLogLevel.ItemIndex);

  ProgressBar1.MaxValue := lvFiles.Items.Count;
  lblCount.Caption := Format('(%d / %d)', [0, ProgressBar1.MaxValue]);

  // 선택 파일을 위 컨버터들로 전환실행
  for I := 0 to lvFiles.Items.Count - 1 do
  begin
    if not lvFiles.Items[I].Checked then
      Continue;

    Data := TFileInfo(lvFiles.Items[I].Data);
    // *****
    UpdateCount := TConvertManager.Instance.RunConvert(Data, Convs);
    // *****

    if UpdateCount = 0 then
      lvFiles.Items[I].SubItems[1] := '-'
    else
      lvFiles.Items[I].SubItems[1] := Format('%d 건', [UpdateCount]);

    TotalCount := TotalCount + UpdateCount;
    // 스크롤 이동
    lvFiles.ItemIndex := I;
    R := lvFiles.Selected.DisplayRect(drBounds);
    lvFiles.Scroll(0, (R.Top - lvFiles.ClientHeight div 2));

    ProgressBar1.Progress := I+1;
    lblCount.Caption := Format('(%d / %d)', [I+1, ProgressBar1.MaxValue]);

    lvFiles.Items[I].Checked := False;
    Application.ProcessMessages;
  end;

  ProgressBar1.Progress := ProgressBar1.MaxValue;
  ShowMessage(Format('%d 건이 변경되었습니다.', [TotalCount]));
  TLogger.Log('Finish migration [Count: %d]', [TotalCount]);
end;

procedure TfrmSrcMainForm.btnSelectDirClick(Sender: TObject);
begin
  if not FileOpenDialog1.Execute then
    Exit;

  edtRootPath.Text := FileOpenDialog1.FileName;
end;

procedure TfrmSrcMainForm.Button1Click(Sender: TObject);
begin
  if not Assigned(frmExtract) then
    frmExtract := TfrmExtract.Create(Self);
  frmExtract.SetFileInfos(FFileInfos);
  frmExtract.Show;
end;

procedure TfrmSrcMainForm.chkAllConverterClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvConverter.Items.Count - 1 do
    lvConverter.Items[I].Checked := chkAllConverter.Checked;
end;

procedure TfrmSrcMainForm.chkAllFilesClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvFiles.Items.Count - 1 do
    lvFiles.Items[I].Checked := chkAllFiles.Checked;
end;

procedure TfrmSrcMainForm.ClearFielInfos;
var
  Data: TFileInfo;
begin
  for Data in FFileInfos do
    Data.Free;
  FFileInfos.Clear;
end;

procedure TfrmSrcMainForm.FormCreate(Sender: TObject);
var
  Item: TListItem;
  Converter: TConverter;
begin
  TLogger.Instance.Category := 'SRC';

  edtRootPath.Text :=       TEnv.Instance.RootPath;
  chkRecursively.Checked := TEnv.Instance.Recursively;
  chkBackup.Checked :=      TEnv.Instance.UseBackup;
  cbxLogLevel.ItemIndex :=  TEnv.Instance.LogLevel;

  FileOpenDialog1.Options := [fdoPickFolders, fdoPathMustExist,
    fdoForceFileSystem];

  FFileInfos := TList<TFileInfo>.Create;

  for Converter in TConvertManager.Instance.ConvertInstance do
  begin
    Item := lvConverter.Items.Add;
    Item.Caption := Converter.Description;
    Item.Checked := True;
    Item.Data := Converter;
  end;

//  edtRootPath.Text := '';
  btnRunConvert.Enabled := False;
end;

procedure TfrmSrcMainForm.FormDestroy(Sender: TObject);
begin
  ClearFielInfos;
  FFileInfos.Free;
end;

procedure TfrmSrcMainForm.LoadFilelist(APath: string);
var
  DirPath, FilePath: string;
  SearchResult: TSearchRec;
  Item: TListItem;
  Group: TListGroup;
  Data: TFileInfo;
begin
  DirPath := TPath.Combine(FRootPath, APath);
  FilePath := TPath.Combine(DirPath, '*.pas');

  Group := lvFiles.Groups.Add;
  Group.Header := IfThen(APath = '', '(Root)', APath);

  if FindFirst(FilePath, faAnyFile, SearchResult) = 0 then
  begin
    repeat
      Item := lvFiles.Items.Add;
      Item.Caption := SearchResult.Name;
      Item.Checked := True;
      Item.GroupID := Group.ID;
      Item.SubItems.Add(FormatFloat('#,', SearchResult.Size) + ' bytes');
      Item.SubItems.Add('');

      Data := TFileInfo.Create;
      Data.FileName := SearchResult.Name;
      Data.Path := APath;
      FFileInfos.Add(Data);
      Item.Data := Pointer(Data);

    until FindNext(SearchResult) <> 0;
    FindClose(SearchResult);
  end;

  if not chkRecursively.Checked then
    Exit;
  // sub directory search
  if FindFirst(TPath.Combine(DirPath, '*'), faDirectory, SearchResult) = 0 then
  begin
    repeat
      if string(SearchResult.Name).IndexOf('.') >= 0 then
        Continue;
      // backup 디렉토리 제외
      if string(SearchResult.Name).IndexOf('backup') >= 0 then
        Continue;
      if not SearchResult.Attr in [faDirectory] then
        Exit;

      LoadFilelist(TPath.Combine(APath, SearchResult.Name));
    until FindNext(SearchResult) <> 0;
    FindClose(SearchResult);
  end;
end;

procedure TfrmSrcMainForm.mniAfterSelectClick(Sender: TObject);
var
  I: Integer;
begin
  for I := lvFiles.Selected.Index to lvFiles.Items.Count - 1 do
    lvFiles.Items[I].Checked := True;
end;

procedure TfrmSrcMainForm.mniBeforeSelelectClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvFiles.Selected.Index do
    lvFiles.Items[I].Checked := True;
end;

procedure TfrmSrcMainForm.mniSelectAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvFiles.Items.Count - 1 do
    lvFiles.Items[I].Checked := True;
end;

procedure TfrmSrcMainForm.mniUnselectAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvFiles.Items.Count - 1 do
    lvFiles.Items[I].Checked := False;
end;

procedure TfrmSrcMainForm.PopupMenu1Popup(Sender: TObject);
begin
  mniBeforeSelelect.Enabled := Assigned(lvFiles.Selected);
  mniAfterSelect.Enabled := Assigned(lvFiles.Selected);

end;

end.
