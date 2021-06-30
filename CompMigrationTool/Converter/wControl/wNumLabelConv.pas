unit wNumLabelConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterwNumLabel = class(TConverter)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings): string; override;
  end;


{
object cxCurrencyEdit1: TcxCurrencyEdit
  Left = 176
  Top = 176
  EditValue = 0
  Value = 1000
  Properties.Alignment.Horz = taRightJustify
  Properties.DisplayFormat = '#,##0'
  Properties.UseThousandSeparator = True
  Style.BorderStyle = ebsNone
  Style.Color = 15191807
  TabOrder = 8
  Width = 81
end


}

implementation

{ TConverterwNumEdit }

function TConverterwNumLabel.GetAddedUses: TArray<string>;
begin
  Result := ['cxCurrencyEdit'];
end;

function TConverterwNumLabel.GetComponentClassName: string;
begin
  Result := 'TwNumEdit';
end;

function TConverterwNumLabel.GetConvertCompClassName: string;
begin
  Result := 'TcxCurrencyEdit';
end;

function TConverterwNumLabel.GetConvertedCompText(ACompText: TStrings): string;
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
    ;
  end;
  Props := '' +
    '  EditValue = 0'#13#10 +
    '  Properties.Alignment.Horz = taRightJustify'#13#10 +
    '  Properties.DisplayFormat = ''#,##0'''#13#10 +
    '  Properties.UseThousandSeparator = True'
  ;

  ACompText.Insert(1, Props);

  Result := ACompText.Text;
end;

function TConverterwNumLabel.GetRemoveUses: TArray<string>;
begin
  Result := ['URNEdit', 'URCtrls'];
end;

initialization
  TConvertManager.Instance.Regist(TConverterwNumLabel);

end.

