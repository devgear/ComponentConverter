unit ColumnConverter;

interface

uses
  SrcConverter;

type
  TColumnConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertFixedCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsItems(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertColumnsReadOnly(AProc, ASrc: string; var ADest: string): Integer;

    [Impl]
    function ConvertEtc(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  System.Classes, System.SysUtils, SrcConvertUtils;

{ TSelectedConverter }

function TColumnConverter.ConvertColCount(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]ol[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.ColumnCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsCount(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\.[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.ColumnCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsItems(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = '(' + GRIDNAME_REGEX + '\.[Cc]olumns\[|' + GRIDNAME_REGEX + '\.[Cc]olumns.Items\[)';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Columns[';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.ConvertColumnsReadOnly(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Cc]olumns\[\d\]\.[Rr]ead[Oo]nly[\s:]';
var
  Datas: TChangeDatas;
begin
  Result := 0;
  ADest := ASrc;

  if IsContainsRegEx(ASrc, SEARCH_PATTERN) then
  begin
    Datas.Add('].ReadOnly', '].ReadOnlyEx');

    Inc(Result, ReplaceKeywords(ADest, Datas));
  end;
end;

function TColumnConverter.ConvertEtc(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;
  ADest := ASrc;

  Datas.Add('].Footer.Values[', '].Footers[');
  Datas.Add('Title.CellStyle', 'HeaderHint');

  Inc(Result, ReplaceKeywords(ADest, Datas));
end;

function TColumnConverter.ConvertFixedCount(AProc, ASrc: string;
  var ADest: string): Integer;
// if not (RealDBGrid1.DataSource.DataSet.State in [dsInsert]) then
  // if not (RealDBGrid1DBBandedTableView1.DataController.DataSource.DataSet.State in [dsInsert]) then
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ff]ixed[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.FixedCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TColumnConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TColumnConverter.GetDescription: string;
begin
  Result := 'Column - TRealDBGrid to TcxGrid ';
end;

initialization
  TConvertManager.Instance.Regist(TColumnConverter);
end.
