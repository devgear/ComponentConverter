unit SelectedConverter;

interface

uses
  SrcConverter;

type
  TSelectedConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertSelectedIndex(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertSelectedFieldFieldName(AProc, ASrc: string; var ADest: string): Integer;
    // RealDBGrid1.SelectedRows.Count
    [Impl]
    function ConvertSelectedRowsCount(AProc, ASrc: string; var ADest: string): Integer;
    [Impl]
    function ConvertBookmarkSelectedRows(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
  Winapi.Windows,
  System.Classes, System.SysUtils,
  System.RegularExpressions, SrcConvertUtils;

{ TSelectedConverter }

function TSelectedConverter.ConvertSelectedIndex(AProc, ASrc: string;
  var ADest: string): Integer;
// RDBGridMaster.SelectedIndex := 0;
  // RealDBGrid1DBBandedTableView1.Controller.FocusedItemIndex := 0
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Ii]ndex';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Controller.FocusedItemIndex';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TSelectedConverter.ConvertSelectedRowsCount(AProc, ASrc: string;
  var ADest: string): Integer;
// RealDBGrid1.SelectedRows.Count
  // RealDBGrid1DBBandedTableView1.Controller.SelectedRecordCount
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Rr]ows\.[Cc]ount';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Controller.SelectedRecordCount';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TSelectedConverter.ConvertBookmarkSelectedRows(AProc, ASrc: string;
  var ADest: string): Integer;
// qry_Master.GotoBookMark(Pointer(RealDBGrid1.SelectedRows.Items[I]));
  // RealDBGrid1DBBandedTableView1.Controller.SelectedRecords[I].Focused := true;
const
  SEARCH_PATTERN  = '[a-zA-Z_\d]+\.GotoBookmark\([Pp]ointer\(' + GRIDNAME_REGEX +'.[Ss]elected[Rr]ows\.[Ii]tems'+INDEX_REGEX+'\)\)\;';
  REPLACE_FORMAT  = '[[COMP_NAME]]DBBandedTableView1.Controller.SelectedRecords[[[INDEX]]].Focused := True;';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TSelectedConverter.ConvertSelectedFieldFieldName(AProc, ASrc: string;
  var ADest: string): Integer;
const
  SEARCH_PATTERN  = GRIDNAME_REGEX + '\.[Ss]elected[Ff]ield\.[Ff]ield[Nn]ame';
  REPLACE_FORMAT  = 'TcxGridDBBandedColumn([[COMP_NAME]]DBBandedTableView1.Controller.FocusedItem).DataBinding.FieldName';
begin
  Result := 0;

  if TryRegExGridConvert(ASrc, SEARCH_PATTERN, REPLACE_FORMAT, ADest) then
    Inc(Result);
end;

function TSelectedConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TSelectedConverter.GetDescription: string;
begin
  Result := 'TcxGrid Selected';
end;

initialization
  TConvertManager.Instance.Regist(TSelectedConverter);

end.
