unit DataControllerConverter;

interface

uses
  SrcConverter;

type
  TDataControllerConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertDataSource(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertEditorMode(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

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

function TDataControllerConverter.ConvertEditorMode(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ee]ditor[Mm]ode';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.DataController.IsEditing';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TDataControllerConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TDataControllerConverter.GetDescription: string;
begin
  Result := 'TcxGrid DataController';
end;

initialization
  TConvertManager.Instance.Regist(TDataControllerConverter);
end.
