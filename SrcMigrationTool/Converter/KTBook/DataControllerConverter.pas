unit DataControllerConverter;

interface

uses
  SrcConverter,
  System.Classes;

type
  TDataControllerConverter = class(TConverter)
  private
    FHasSetFooter: Boolean;
    FFooterComps: TStringList;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
    function GetCvtBaseClassName: string; override;

    procedure DoNewProcStart; override;
  published
    [Impl]
    function ConvertDataSource(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertEditorMode(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertDrawCellDataSource(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertRefreshEndAbove(AProc, ASrc: string; var ADest: string): Integer;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses
  System.SysUtils,
  SrcConvertUtils,
  SrcConverterTypes;

{ TSelectedConverter }

function TDataControllerConverter.ConvertDataSource(AProc, ASrc: string;
  var ADest: string): Integer;
// if not (RealDBGrid1.DataSource.DataSet.State in [dsInsert]) then
  // if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsInsert]) then
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Dd]ata[Ss]ource';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.DataController.DataSource';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TDataControllerConverter.ConvertDrawCellDataSource(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  Datas.Add('if DataSource.DataSet.recno mod 2 = 0',  'if Datacontroller.DataSource.DataSet.recno mod 2 = 0');


  Inc(Result, ReplaceKeywords(SrcFilename, ADest, Datas));
end;

function TDataControllerConverter.ConvertEditorMode(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ee]ditor[Mm]ode';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.OptionsData.Editing';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TDataControllerConverter.ConvertRefreshEndAbove(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN = '\].Footers\[\d+\][\s]*:=';
var
  I: Integer;
  CompName: string;
begin
  Result := 0;
  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    FHasSetFooter := True;
    CompName := Copy(ASrc, 1, Pos('.', ASrc)-1).Trim;

    if FFooterComps.IndexOf(CompName) < 0 then
      FFooterComps.Add(CompName);
  end
  else if FHasSetFooter and (ASrc = 'end;') then
  begin
    if not FConvData.Source[FCurrIndex-1].EndsWith('.DataController.Refresh;') then
    begin
      ADest := #13#10;
      for I := 0 to FFooterComps.Count - 1 do
        ADest := ADest + '  ' + FFooterComps[I] + '.DataController.Refresh;'#13#10;
      ADest := ADest + 'end;';

      Result := 1;
    end;
  end;
end;

procedure TDataControllerConverter.AfterConstruction;
begin
  FFooterComps := TStringList.Create;
end;

procedure TDataControllerConverter.BeforeDestruction;
begin
  inherited;

  FFooterComps.Free;
end;

procedure TDataControllerConverter.DoNewProcStart;
begin
  FHasSetFooter := False;
  FFooterComps.Clear;
end;

function TDataControllerConverter.GetCvtBaseClassName: string;
begin
  Result := 'TfrmTzzRealMaster2';
end;

function TDataControllerConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TDataControllerConverter.GetDescription: string;
begin
  Result := 'TcxGrid:DataController';
end;

initialization
  TConvertManager.Instance.Regist(TDataControllerConverter);
end.
