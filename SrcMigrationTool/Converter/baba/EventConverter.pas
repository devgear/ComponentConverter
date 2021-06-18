unit EventConverter;

interface

uses
  SrcConverter;

type
  TEventConverter = class(TConverter)
  private
    function ConvertDrawCellEvent(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertCellClick(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertEditValueChanged(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertDataControllerBeforePost(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertEditKeyDown(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertEdit(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertColumnHeaderClick(AProc, ASrc: string; var ADest: string): Boolean;
    function ConvertDataControllerAfterInsert(AProc, ASrc: string; var ADest: string): Boolean;


    function ConvertStylesGetContentStyle(ASrc: string; var ADest: string): Boolean;

    function ConvertEtcEvent(AProc, ASrc: string;  var ADest: string): Boolean;
    function ConvertIntfEtcEvent(ASrc: string;  var ADest: string): Boolean;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;

    function ConvertSource(AProc, ASrc: string; var ADest: string): Boolean; override;
    function ConvertIntfSource(ASrc: string; var ADest: string): Boolean; override;
  end;

implementation

uses
  Winapi.Windows,
  System.Classes, System.SysUtils,
  System.RegularExpressions, SrcConvertUtils;

{ TCellsConverter }


function TEventConverter.ConvertCellClick(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('CellClick') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('TRealGrid(Sender)',          'TcxGridBandedTableView(Sender)');
  if not ADest.Contains('DataController.RecordCount') then
    Datas.Add('.RowCount',                  '.DataController.RecordCount');
  Datas.Add('.Row ',                      '.DataController.FocusedRowIndex ');
  Datas.Add(' Row,',                      ' DataController.FocusedRowIndex,');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertColumnHeaderClick(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('ColumnHeaderClick') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('TRealGrid(AColumn.Grid)',        'TcxGridBandedTableView(Sender)');
  Datas.Add('AItem.Index',                    'AColumn.Index');
  Datas.Add(' Rowcount',                      ' DataController.RecordCount');


  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertDataControllerAfterInsert(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('DataControllerAfterInsert') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('(Sender)',             '(ADataController)');

  Datas.Add('SetRGrid := (Sender as TcxGridBandedTableView);',
      'SetRGrid := ((ADataController as TcxGridDataController).GridView as TcxGridBandedTableView);');
  Datas.Add(', Row)',                       ', ADataController.RecordCount)');
  Datas.Add('[ Row,',                       '[ADataController.RecordCount,');
  Datas.Add(' Row ',                       ' ADataController.RecordCount ');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertDataControllerBeforePost(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('DataControllerBeforePost') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('Sender Is TRealGrid',             'ADataController is TcxGridDataController');
  Datas.Add('Sender As TRealGrid',             'ADataController as TcxGridDataController');
  Datas.Add('.RowCount',                       '.RecordCount');
  Datas.Add('SelectedIndex := iCol;',          'Columns[iCol].Focused := True;');

  Datas.Add('SetRGrid := (Sender as TcxGridBandedTableView);',
      'SetRGrid := ((ADataController as TcxGridDataController).GridView as TcxGridBandedTableView);');
  Datas.Add(', Row)',                       ', ADataController.RecordCount)');
  Datas.Add('[ Row,',                       '[ADataController.RecordCount,');
  Datas.Add(' Row ',                       ' ADataController.RecordCount ');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertDrawCellEvent(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('CustomDrawCell') then
    Exit;

  ADest := ASrc;

  Keywords := [
    'FStyle'
  ];

  Datas.Add('ARow',                       'AViewInfo.GridRecord.RecordIndex');
  Datas.Add('AItem.Index',                'AViewInfo.Item.Index');
  Datas.Add('BCol',                       'ACanvas.Brush.Color');
  Datas.Add('FCol',                       'ACanvas.Font.Color');
  Datas.Add('AColumn.Group',              'TcxGridBandedColumn(AViewInfo.Item).Position.BandIndex');


  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertEdit(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('Edit') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('AItem.',             'AColumn.');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertEditKeyDown(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('EditKeyDown') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('Sender Is TRealGrid',           'Sender is TcxGridBandedTableView');
  Datas.Add('Sender As TRealGrid',           'Sender as TcxGridBandedTableView');
  Datas.Add('SelectedIndex',                 'Controller.FocusedColumn.Index');
  Datas.Add(' Cancel;',                       ' DataController.Cancel;');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertEditValueChanged(AProc, ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  if not AProc.EndsWith('EditValueChanged') then
    Exit;

  ADest := ASrc;

  Keywords := [
  ];

  Datas.Add('TRealGrid(AColumn.Grid)',    'TcxGridBandedTableView(Sender)');
  Datas.Add('AColumn.Group',              'TcxGridBandedColumn(AItem).Position.BandIndex');
  Datas.Add('AColumn.Caption',            'TcxGridBandedColumn(AItem).Caption');
  Datas.Add('AColumnBandedTableView1.DataController.',
              'DataController.');
  Datas.Add('SelectedIndex := AItem.Index-2;',
              'Columns[AItem.Index-2].Focused := True;');
  Datas.Add('[Row,',                      '[DataController.FocusedRowIndex,');
  Datas.Add(').Row',                      ').DataController.FocusedRowIndex');
  Datas.Add('(Row,',                      '(DataController.FocusedRowIndex,');
  Datas.Add(' Row,',                      ' DataController.FocusedRowIndex,');


  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertEtcEvent(AProc, ASrc: string;  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    'bAppend :='
  ];

  if AProc.EndsWith('AfterExecute') then
  begin
    Datas.Add('AfterExecute(Sender: TObject;',                      'AfterExecute(');
    Datas.Add('Result: Boolean);',                      'DataSet: TFDDataSet);');
  end;


  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertIntfEtcEvent(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
    'bAppend :='
  ];

  Datas.Add('AfterExecute(Sender: TObject; Result: Boolean);',
    'AfterExecute(DataSet: TFDDataSet);');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.ConvertIntfSource(ASrc: string;
  var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertStylesGetContentStyle(ADest, ADest) then
    Result := True;

  if ConvertIntfEtcEvent(ADest, ADest) then
    Result := True;
end;

function TEventConverter.ConvertSource(AProc, ASrc: string; var ADest: string): Boolean;
begin
  Result := False;
  ADest := ASrc;

  if ConvertDrawCellEvent(AProc, ADest, ADest) then
    Result := True;
  if ConvertCellClick(AProc, ADest, ADest) then
    Result := True;
  if ConvertEditValueChanged(AProc, ADest, ADest) then
    Result := True;
  if ConvertDataControllerBeforePost(AProc, ADest, ADest) then
    Result := True;
  if ConvertEditKeyDown(AProc, ADest, ADest) then
    Result := True;
  if ConvertEdit(AProc, ADest, ADest) then
    Result := True;
  if ConvertColumnHeaderClick(AProc, ADest, ADest) then
    Result := True;
  if ConvertDataControllerAfterInsert(AProc, ADest, ADest) then
    Result := True;


  if ConvertStylesGetContentStyle(ADest, ADest) then
    Result := True;

  if ConvertEtcEvent(AProc, ADest, ADest) then
    Result := True;
end;

function TEventConverter.ConvertStylesGetContentStyle(ASrc: string;
  var ADest: string): Boolean;
var
  Keywords: TArray<string>;
  Datas: TChangeDatas;
begin
  Result := False;

  ADest := ASrc;

  Keywords := [
  ];
  Datas.Add('out AStyle: TcxStyle', 'var AStyle: TcxStyle');

  if AddComments(ADest, Keywords) then
    Result := True;

  if ReplaceKeywords(ADest, Datas) then
    Result := True;
end;

function TEventConverter.GetCvtCompClassName: string;
const
  COMP_NAME = '';
begin
  Result := COMP_NAME;
end;

function TEventConverter.GetDescription: string;
begin
  Result := 'TcxGrid Event';
end;

initialization
  TConvertManager.Instance.Regist(TEventConverter);

end.
