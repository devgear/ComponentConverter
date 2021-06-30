unit wLabelConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterwLabel = class(TConverter)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(ACompText: TStrings): TStrings; override;
  end;
{
object cxLabel1: TcxLabel
  Left = 216
  Top = 344
  AutoSize = False
  Caption = 'cxLabel1'
  ParentColor = False
  Style.BorderStyle = ebsSingle
  Style.Color = clYellow
  Properties.Alignment.Horz = taLeftJustify
  Height = 25
  Width = 129
end

}
implementation

{ TConverterwNumEdit }

function TConverterwLabel.GetAddedUses: TArray<string>;
begin
  Result := ['cxCurrencyEdit'];
end;

function TConverterwLabel.GetComponentClassName: string;
begin
  Result := 'TwLabel';
end;

function TConverterwLabel.GetConvertCompClassName: string;
begin
  Result := 'TcxLabel';
end;

function TConverterwLabel.GetConvertedCompStrs(ACompText: TStrings): TStrings;
var
  I, SIdx, EIdx: Integer;
  S, Props: string;
begin
  ACompText[0] := ACompText[0].Replace(GetComponentClassName, GetConvertCompClassName);

  for I := 1 to ACompText.Count - 2 do
  begin
    S := ACompText[I];

    if S.Contains(' Color =') then
      ACompText[I] := S.Replace(' Color =', ' Style.Color =')
    else if S.Contains(' Font.') then
      ACompText[I] := S.Replace(' Font.', ' Style.Font.')
    else if S.Contains(' MaxLength =') then
      ACompText[I] := S.Replace(' MaxLength =', ' Properties.MaxLength =')
    else if S.Contains(' ReadOnly =') then
      ACompText[I] := S.Replace(' ReadOnly =', ' Properties.ReadOnly =')
    else if S.Contains(' ReadOnly =') then
      ACompText[I] := S.Replace(' ReadOnly =', ' Properties.ReadOnly =')
    ;
  end;
  Props := '' +
    '  EditValue = 0'#13#10 +
    '  Properties.Alignment.Horz = taRightJustify'#13#10 +
    '  Properties.DisplayFormat = ''#,##0'''#13#10 +
    '  Properties.UseThousandSeparator = True'
  ;

  ACompText.Insert(1, Props);

  Result := ACompText;
end;

function TConverterwLabel.GetRemoveUses: TArray<string>;
begin
  Result := ['URNEdit', 'URCtrls'];
end;

initialization
  TConvertManager.Instance.Regist(TConverterwLabel);

end.

