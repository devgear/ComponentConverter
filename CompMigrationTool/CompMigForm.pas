﻿unit CompMigForm;

interface

uses
  CompConverterTypes, CompConverter, System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmCompMigTool = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    edtRootPath: TEdit;
    btnSelectDir: TButton;
    btnLoadFiles: TButton;
    chkRecursively: TCheckBox;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel6: TPanel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    btnRunConvert: TButton;
    chkBackup: TCheckBox;
    FileOpenDialog1: TFileOpenDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    lvConverter: TListView;
    lvFiles: TListView;
    chkAllFiles: TCheckBox;
    chkAllConverter: TCheckBox;
    btnExtractProps: TButton;
    Button1: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnSelectDirClick(Sender: TObject);
    procedure btnLoadFilesClick(Sender: TObject);
    procedure chkAllConverterClick(Sender: TObject);
    procedure chkAllFilesClick(Sender: TObject);
    procedure btnRunConvertClick(Sender: TObject);
    procedure btnExtractPropsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FRootPath: string;
    FDfmFileDatas: TObjectList<TDfmFileData>;   // 로드한 파일 정보 목록(재조회 또는 종료 시 초기화 필요)

    procedure LoadFileDatasAndDisplayListView(APath: string = '');
  public
    { Public declarations }
  end;

var
  frmCompMigTool: TfrmCompMigTool;

implementation

uses
  System.IOUtils, System.StrUtils, Environments,
  ExtractPropForm, Logger, GridBandHeaderMergeForm;

{$R *.dfm}

procedure TfrmCompMigTool.FormCreate(Sender: TObject);
var
  Item: TListItem;
  Converter: TConverter;
begin
  TLogger.Instance.LogLevel := llInfo;

  edtRootPath.Text        := TEnv.Instance.RootPath;
  chkRecursively.Checked  := TEnv.Instance.Recursively;
  chkBackup.Checked       := TEnv.Instance.UseBackup;

  FileOpenDialog1.Options := [fdoPickFolders, fdoPathMustExist,
                              fdoForceFileSystem];

  FDfmFileDatas := TObjectList<TDfmFileData>.Create(True);

  for Converter in TConvertManager.Instance.ConvertInstances do
  begin
    Item := lvConverter.Items.Add;
    Item.Caption := Converter.Description;
    Item.Checked := True;
    Item.Data := Converter;
  end;

  btnRunConvert.Enabled := False;
end;

procedure TfrmCompMigTool.FormDestroy(Sender: TObject);
begin
  FDfmFileDatas.Free;
end;

procedure TfrmCompMigTool.btnLoadFilesClick(Sender: TObject);
begin
  FRootPath := edtRootPath.Text;
  TConvertManager.Instance.RootPath := FRootPath;

  lvFiles.Items.Clear;;
  FDfmFileDatas.Clear;
  LoadFileDatasAndDisplayListView;

  btnRunConvert.Enabled := (lvFiles.Items.Count > 0);

  TEnv.Instance.RootPath := FRootPath;
  TEnv.Instance.Recursively := chkRecursively.Checked;
end;

procedure TfrmCompMigTool.btnRunConvertClick(Sender: TObject);
var
  I: Integer;
  Data: TDfmFileData;
  Convs: TArray<TConverter>;
  TotalCount, UpdatedCount: Integer;
  R: TRect;
begin
  Convs := [];
  // 작업 대상 컨버터
  for I := 0 to lvConverter.Items.Count - 1 do
  begin
    if lvConverter.Items[I].Checked then
      Convs := Convs + [TConverter(lvConverter.Items[I].Data)];
  end;

  TotalCount := 0;

  TConvertManager.Instance.Init;
  TConvertManager.Instance.UseBackup := chkBackup.Checked;
  TEnv.Instance.UseBackup := chkBackup.Checked;

  // 선택 파일을 위 컨버터들로 전환실행
  for I := 0 to lvFiles.Items.Count - 1 do
  begin
    if not lvFiles.Items[I].Checked then
      Continue;

    Data := TDfmFileData(lvFiles.Items[I].Data);
    UpdatedCount := TConvertManager.Instance.RunConvert(Data, Convs);
    if UpdatedCount = 0 then
      lvFiles.Items[I].SubItems[1] := '-'
    else
      lvFiles.Items[I].SubItems[1] := Format('%d 건', [UpdatedCount]);

    TotalCount := TotalCount + UpdatedCount;

    // 스크롤 이동
    lvFiles.ItemIndex := I;
    R := lvFiles.Selected.DisplayRect(drBounds);
    lvFiles.Scroll(0, (R.Top - lvFiles.ClientHeight div 2));

    lvFiles.Items[I].Checked := False;
    Application.ProcessMessages;
  end;

  ShowMessage(Format('%d 건이 변경되었습니다.', [TotalCount]));
end;

procedure TfrmCompMigTool.btnSelectDirClick(Sender: TObject);
begin
  if not FileOpenDialog1.Execute then
    Exit;

  edtRootPath.Text := FileOpenDialog1.FileName;
end;

procedure TfrmCompMigTool.chkAllConverterClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvConverter.Items.Count - 1 do
    lvConverter.Items[I].Checked := chkAllConverter.Checked;
end;

procedure TfrmCompMigTool.chkAllFilesClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to lvFiles.Items.Count - 1 do
    lvFiles.Items[I].Checked := chkAllFiles.Checked;
end;

procedure TfrmCompMigTool.LoadFileDatasAndDisplayListView(APath: string);
var
  DirPath, FilePath: string;
  SearchResult: TSearchRec;
  Item: TListItem;
  Group: TListGroup;
  Info: TDfmFileData;
begin
  DirPath := TPath.Combine(FRootPath, APath);
  FilePath := TPath.Combine(DirPath, '*.dfm');

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

      Info := TDfmFileData.Create;
      Info.FileName := SearchResult.Name;
      Info.Path := APath;
      FDfmFileDatas.Add(Info);
      Item.Data := Pointer(Info);

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

      LoadFileDatasAndDisplayListView(TPath.Combine(APath, SearchResult.Name));
    until FindNext(SearchResult) <> 0;
    FindClose(SearchResult);
  end;
end;

procedure TfrmCompMigTool.btnExtractPropsClick(Sender: TObject);
begin
  if FDfmFileDatas.Count = 0 then
  begin
    ShowMessage('파일을 먼저 불러오세요.');
    Exit;
  end;

  if not Assigned(frmExtractProperties) then
    frmExtractProperties := TfrmExtractProperties.Create(Self);
  frmExtractProperties.SetFileInfos(FDfmFileDatas);
  frmExtractProperties.Show;
end;

procedure TfrmCompMigTool.Button1Click(Sender: TObject);
begin
  if not Assigned(frmBandHeader) then
    frmBandHeader := TfrmBandHeader.Create(Self);
  frmBandHeader.Show;
end;

end.
