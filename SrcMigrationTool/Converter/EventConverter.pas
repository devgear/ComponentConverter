unit EventConverter;

interface

uses
  SrcConverter;

type
  TViewEventConverter = class(TConverter)
  private
    function RealGridOptionToStr(ACompName, ASrc: string): string;
  protected
    function GetCvtCompClassName: string; override;
    function GetDescription: string; override;
  published
    [Impl]
    function ConvertEditKeyDown_FocusedItemIndex(AProc, ASrc: string; var ADest: string): Integer;
  end;

implementation

uses
  SrcConverterTypes,
  System.StrUtils,
  SrcConvertUtils,
  System.Classes, System.SysUtils;

{ TGridConverter }

function TViewEventConverter.ConvertEditKeyDown_FocusedItemIndex(AProc,
  ASrc: string; var ADest: string): Integer;
begin
  Result := 0;
  if not AProc.Contains('EditKeyDown') then
    Exit;

  if ASrc.Contains('Controller.FocusedItemIndex :=') then
  begin
    if ASrc.Contains('Key := 0;') then
      Exit;

    ADest := ASrc + ' Key := 0;(*mig*)';
    Inc(Result);
  end;
end;

function TViewEventConverter.GetCvtCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TViewEventConverter.GetDescription: string;
begin
  Result := 'TcxGrid:Event';
end;

function TViewEventConverter.RealGridOptionToStr(ACompName, ASrc: string): string;
begin

end;

initialization
  TConvertManager.Instance.Regist(TViewEventConverter);

end.
