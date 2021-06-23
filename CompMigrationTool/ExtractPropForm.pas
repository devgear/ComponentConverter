unit ExtractPropForm;

interface

uses
  CompConverterTypes,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmExtractProperties = class(TForm)
    edtClassName: TEdit;
    edtPropertyKeyword: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    mmoProperties: TMemo;
    Panel3: TPanel;
    btnSave: TButton;
    btnClose: TButton;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FDataList: TStringList;
    FFileInfos: TList<TFileInfo>;

    procedure WriteLog(const AValue: string); overload;
    procedure WriteLog(const AValue: string; const Args: array of const); overload;
  public
    { Public declarations }
    procedure SetFileInfos(AFileInfos: TList<TFileInfo>);
  end;

var
  frmExtractProperties: TfrmExtractProperties;

implementation

{$R *.dfm}

uses Environments, ConvertUtils;

{ TfrmExtractProperties }

procedure TfrmExtractProperties.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExtractProperties.btnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    FDataList.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmExtractProperties.Button1Click(Sender: TObject);
type
  TCompIdx = record
    CompStart, CompEnd: Integer;
  end;
var
  I: Integer;
  S, P, V: string;
  Info: TFileInfo;
  Comp, ClassName, PropName: string;
  DfmFile: TStringList;
  Idx: Integer;
  CompIdx: TCompIdx;
  CompIdxs: TArray<TCompIdx>;
begin
  if edtClassName.Text = '' then
  begin
    ShowMessage('클래스 이름 입력하세요');
    edtClassName.SetFocus;
    Exit;
  end;

  ClassName := edtClassName.Text;
  PropName := edtPropertyKeyword.Text;

  TEnv.Instance.ClassName := ClassName;
  TEnv.Instance.PropertyName := PropName;

  FDataList.Clear;
  FDataList.Add(Format('%s,%s,%s,%s,%s', ['Path', 'Filename', 'Component', 'Event name', 'Event']));
  DfmFile := TStringList.Create;
  for Info in FFileInfos do
  begin
    CompIdxs := [];
    DfmFile.LoadFromFile(Info.GetDfmFullpath(TEnv.Instance.RootPath));

    CompIdx.CompStart := 0;
    CompIdx.CompEnd := 0;
    // DFM 파일에서 컴포넌트 시작과 끝 정보를 반복해서 찾는다.
    Idx := GetCompStartIndex(DfmFile, CompIdx.CompStart+1, ClassName);
    while Idx > -1 do
    begin
      CompIdx.CompStart := Idx;
      CompIdx.CompEnd   := GetCompEndIndex(DfmFile, CompIdx.CompStart+1);

      CompIdxs := CompIdxs + [CompIdx];

      Idx := GetCompStartIndex(DfmFile, CompIdx.CompStart+1, ClassName);
    end;

    if Length(CompIdxs) = 0 then
      Continue;

    WriteLog('[%s]', [Info.Filename]);
    for CompIdx in CompIdxs do
    begin
      Comp := GetNameFromObjectText(DfmFile[CompIdx.CompStart]);
      WriteLog('Comp: %s', [Comp]);

      for I := CompIdx.CompStart to CompIdx.CompEnd do
      begin
        S := DfmFile[I];
        if GetPropValueFromPropText(S, P, V) then
        begin
          if P.StartsWith(PropName) then
          begin
            WriteLog(S);

            FDataList.Add(Format('%s,%s,%s, %s,%s', [Info.Path, Info.Filename, Comp, P, S]));
          end;
        end;
      end;
    end;
    WriteLog('');
  end;
  DfmFile.Free;
end;

procedure TfrmExtractProperties.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  frmExtractProperties := nil;
end;

procedure TfrmExtractProperties.FormCreate(Sender: TObject);
begin
  FDataList := TStringList.Create;

  edtClassName.Text       := TEnv.Instance.ClassName;
  edtPropertyKeyword.Text := TEnv.Instance.PropertyName;
end;

procedure TfrmExtractProperties.FormDestroy(Sender: TObject);
begin
  FDataList.Free;
end;

procedure TfrmExtractProperties.SetFileInfos(AFileInfos: TList<TFileInfo>);
begin
  FFileInfos := AFileInfos;
end;

procedure TfrmExtractProperties.WriteLog(const AValue: string;
  const Args: array of const);
begin
  WriteLog(Format(AValue, Args));
end;

procedure TfrmExtractProperties.WriteLog(const AValue: string);
begin
  mmoProperties.Lines.Add(AValue);
end;

end.
