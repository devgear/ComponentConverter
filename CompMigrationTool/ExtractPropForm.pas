﻿unit ExtractPropForm;

interface

uses
  CompConverterTypes,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmExtractProperties = class(TForm)
    Panel2: TPanel;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtClassName: TEdit;
    edtPropertyKeyword: TEdit;
    btnCompProps: TButton;
    Memo1: TMemo;
    mmoProperties: TMemo;
    Panel3: TPanel;
    btnSave: TButton;
    btnClose: TButton;
    Panel4: TPanel;
    mmoColColor: TMemo;
    Button1: TButton;
    TabSheet3: TTabSheet;
    Panel5: TPanel;
    btnBandHeader: TButton;
    mmoBandHeader: TMemo;
    TabSheet4: TTabSheet;
    Panel6: TPanel;
    Button2: TButton;
    mmoKeyPress: TMemo;
    procedure btnCompPropsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnBandHeaderClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FDataList: TStringList;
    FFileInfos: TList<TDfmFileData>;

    procedure WriteLog(const AValue: string); overload;
    procedure WriteLog(const AValue: string; const Args: array of const); overload;
  public
    { Public declarations }
    procedure SetFileInfos(AFileInfos: TList<TDfmFileData>);
  end;

var
  frmExtractProperties: TfrmExtractProperties;

implementation

{$R *.dfm}

uses Environments, ConvertUtils, RealGridParser;

{ TfrmExtractProperties }

procedure TfrmExtractProperties.btnBandHeaderClick(Sender: TObject);
type
  TCompIdx = record
    CompStart, CompEnd: Integer;
  end;
var
  I: Integer;
  S: string;
  Info: TDfmFileData;
  Comp, ClassName: string;
  DfmFile: TStringList;
  Idx: Integer;
  CompIdx: TCompIdx;
  CompIdxs: TArray<TCompIdx>;
  HasBandHeaders: Boolean;
begin
  ClassName := 'TcxGridDBBandedTableView';

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

    for CompIdx in CompIdxs do
    begin
      Comp := GetNameFromObjectText(DfmFile[CompIdx.CompStart]);
      HasBandHeaders := True;
      for I := CompIdx.CompStart+1 to CompIdx.CompEnd-1 do
      begin
        S := DfmFile[I];

        if S.Trim.StartsWith('object ') then
          Break;

        if S.Trim = 'OptionsView.BandHeaders = False' then
        begin
          HasBandHeaders := False;
          Break;
        end;
      end;
      if HasBandHeaders then
        mmoBandHeader.Lines.Add(Format('%s'#9'%s', [Info.Filename, Comp]));
    end;
  end;
  DfmFile.Free;
end;

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
  Info: TDfmFileData;
  ClassName: string;
  DfmFile: TStringList;
  Strs: TStringList;
  Idx: Integer;
  CompIdx: TCompIdx;
  CompIdxs: TArray<TCompIdx>;
  Parser: TRealGridParser;
  ColInfo: TRealGridColumnInfo;
begin
  ClassName := 'TRealDBGrid';

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

//    mmoColColor.Lines.Add(Format('[%s]', [Info.Filename]));
    for CompIdx in CompIdxs do
    begin
      Parser := TRealGridParser.Create;
      Strs := TStringList.Create;
      for I := CompIdx.CompStart to CompIdx.CompEnd do
        Strs.Add(DfmFile[I]);

      Parser.Parse(Strs.Text);
//      mmoColColor.Lines.Add(Format('CompName: %s', [Parser.CompName]));

      for ColInfo in Parser.ColumnInfos do
      begin
        if (ColInfo.TitleColor <> '') then
          mmoColColor.Lines.Add(Format(ColInfo.TitleColor + #9 +ColInfo.FontColor, []));
      end;

      Strs.Free;
      Parser.Free;
    end;
  end;
  DfmFile.Free;
end;

procedure TfrmExtractProperties.btnCompPropsClick(Sender: TObject);
type
  TCompIdx = record
    CompStart, CompEnd: Integer;
  end;
var
  I: Integer;
  S, P, V: string;
  Info: TDfmFileData;
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

  TEnv.Instance.ClsName := ClassName;
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

      for I := CompIdx.CompStart+1 to CompIdx.CompEnd-1 do
      begin
        S := DfmFile[I];

        if S.Trim.StartsWith('object ') then
          Break;

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

  edtClassName.Text       := TEnv.Instance.ClsName;
  edtPropertyKeyword.Text := TEnv.Instance.PropertyName;
end;

procedure TfrmExtractProperties.FormDestroy(Sender: TObject);
begin
  FDataList.Free;
end;

procedure TfrmExtractProperties.SetFileInfos(AFileInfos: TList<TDfmFileData>);
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

procedure TfrmExtractProperties.Button2Click(Sender: TObject);
type
  TCompIdx = record
    CompStart, CompEnd: Integer;
  end;
var
  I, ImplIdx: Integer;
  Info: TDfmFileData;
  SrcFile: TStringList;
  S, CompClassName, ProcName, CompName, CompTag: string;
  SearchProcName, SearchKeyword: string;
  InProcName: string;
  CompList, ProcList: TArray<string>;
  Path: string;
begin
  CompClassName := 'TRealDBGrid';
  SearchProcName := 'KeyPress';
  SearchKeyword := 'Key = #13';

  ImplIdx := 0;
  SrcFile := TStringList.Create;
  for Info in FFileInfos do
  begin
    Path := Info.GetPasFullpath(TEnv.Instance.RootPath);
    if not FileExists(Path) then
      Continue;
    SrcFile.LoadFromFile(Info.GetPasFullpath(TEnv.Instance.RootPath));

    CompList := [];
    ProcList := [];

    CompTag := Format(': %s;', [CompClassName]);
    for I := 0 to SrcFile.Count - 1 do
    begin
      S := SrcFile[I];
      if S.Contains(CompTag) then
      begin
        CompName := Copy(S, 1, Pos(':', S)-1).Trim;
        CompList := CompList + [CompName];
      end;

      if S.Contains(SearchProcName) then
      begin
        for CompName in CompList do
        begin
          if S.Contains(CompName + SearchProcName) then
            ProcList := ProcList + [CompName + SearchProcName];
        end;
      end;

      if S = 'implementation' then
      begin
        ImplIdx := I;
        Break;
      end;
    end;

    if Length(ProcList) = 0 then
      Continue;

    InProcName := '';
    for I := ImplIdx to SrcFile.Count - 1 do
    begin
      S := SrcFile[I];

      if InProcName = '' then
      begin
        for ProcName in ProcList do
        begin
          if S.Contains(ProcName) then
            InProcName := ProcName;
        end;
      end
      else
      begin
        if S.Contains(SearchKeyword) then
        begin
          mmoKeyPress.Lines.Add(Format(', [''%s'', ''%s'', ''OnKeyPress'', ''OnKeyPressToDown'']', [ExtractFileName(Info.Filename), InProcName]));
//          mmoKeyPress.Lines.Add(S);
        end
        else if S = 'end;' then
        begin
          InProcName := '';
        end;
      end;
    end;


//    Info.
  end;
  SrcFile.Free;
end;

end.
