unit GridEventConverter;

interface

uses
  SrcConverter;

type
  TGridEventConverter = class(TConverter)
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertCustomDrawCell(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConvertUtils,
  System.Classes, System.SysUtils;

{ TSelectedConverter }

function TGridEventConverter.ConvertCustomDrawCell(AProc, ASrc: string;
  var ADest: string): Integer;
var
  Datas: TChangeDatas;
begin
  Result := 0;

  if not AProc.Contains('CustomDrawCell') then
    Exit;

  Datas.Add('AColumn.Index',              'AViewInfo.Item.Index');
  Datas.Add('(AColumn <> nil)',           '(AViewInfo.Item <> nil)');
  Datas.Add('BCol',                       'ACanvas.Brush.Color');
  Datas.Add('FCol',                       'ACanvas.Font.Color');
  Datas.Add('FStyle',                     'ACanvas.Font.Style');

  Inc(Result, ReplaceKeywords(ADest, Datas));
end;

function TGridEventConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TGridEventConverter.GetDescription: string;
begin
  Result := 'Event - TRealDBGrid to TcxGrid ';
end;

initialization
  TConvertManager.Instance.Regist(TGridEventConverter);
end.
