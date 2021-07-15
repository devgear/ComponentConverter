unit wControlConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterwControl = class(TConverter)
  protected
    function GetConvertedCompStrs(ACompText: TStrings): TStrings; override;
    function GetRemoveUses: TArray<string>; override;
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
  TConverterwNumEdit = class(TConverterwControl)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
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
  TConverterwLabel = class(TConverterwControl)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(ACompText: TStrings): TStrings; override;
  end;

{
object cxCurrencyEdit5: TcxCurrencyEdit
  Left = 368
  Top = 343
  Margins.Right = 4

  ParentFont = False

  EditValue = 0
  Properties.Alignment.Horz = taRightJustify
  Properties.AutoSelect = False
  Properties.HideSelection = False
  Properties.ReadOnly = True

  Properties.DisplayFormat = '###,###,###,###'
  Style.BorderStyle = ebsSingle
  Style.Color = clYellow
  Style.Font.Charset = DEFAULT_CHARSET
  Style.Font.Color = clWindowText
  Style.Font.Height = -13
  Style.Font.Name = #44404#47548
  Style.Font.Style = [fsBold]
  TabOrder = 12
  Width = 91
end
}
  TConverterwNumLabel = class(TConverterwControl)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(ACompText: TStrings): TStrings; override;
  end;

  TConverterwEdit = class(TConverterwControl)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;
  end;

  TConverterwMaskEdit = class(TConverterwControl)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(ACompText: TStrings): TStrings; override;
  end;

implementation

{ TConverterwControl }

function TConverterwControl.GetConvertedCompStrs(ACompText: TStrings): TStrings;
var
  I: Integer;
  S: string;
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
    else if S.Contains(' Alignment =') then
      ACompText[I] := S.Replace(' Alignment =', ' Properties.Alignment.Horz =')
    else if S.Contains(' BorderStyle =') then
      ACompText[I] := S.Replace(' BorderStyle =', ' Style.BorderStyle =')
          .Replace('bsNone', 'ebsNone')       // wNumEdit
          .Replace('mlbsLine', 'ebsSingle')   // wNumLabel, wLabel
    else if S.Contains(' Format =') then
      ACompText[I] := S.Replace(' Format =', ' Properties.DisplayFormat =')

    else if S.Contains(' EditMask =') then
      ACompText[I] := S.Replace(' EditMask =', ' Properties.EditMask =').Replace(';0;''', ';0;_''')
    else if S.Contains(' Layout =') then
      ACompText[I] := S.Replace(' Layout =', ' Properties.Alignment.Vert =').Replace('tlCenter', 'taVCenter')

    // TwNumLabel 속성제거
    else if S.Contains(' IsNull =') then
      ACompText[I] := ''
    else if S.Contains(' MarginRight =') then
      ACompText[I] := ''
    ;
  end;

  Result := ACompText;
end;

function TConverterwControl.GetRemoveUses: TArray<string>;
begin
  Result := ['URNEdit', 'URCtrls', 'UREdits', 'URLabels'];
end;

{ TConverterwNumEdit }

function TConverterwNumEdit.GetAddedUses: TArray<string>;
begin
  Result := ['cxCurrencyEdit'];
end;

function TConverterwNumEdit.GetComponentClassName: string;
begin
  Result := 'TwNumEdit';
end;

function TConverterwNumEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxCurrencyEdit';
end;

function TConverterwNumEdit.GetConvertedCompStrs(ACompText: TStrings): TStrings;
var
  Props: string;
begin
  Result := inherited;

  Props := '' +
    '  EditValue = 0'#13#10 +
    '  Properties.Alignment.Horz = taRightJustify'#13#10 +
    '  Properties.DisplayFormat = ''#,##0'''#13#10 +
    '  Properties.UseThousandSeparator = True'
  ;

  Result.Insert(1, Props);
end;

{ TConverterwLabel }

function TConverterwLabel.GetAddedUses: TArray<string>;
begin
  Result := ['cxLabel'];
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
  Props: string;
begin
  Result := inherited;

  Props := '' +
    '  AutoSize = False'#13#10 +
    '  ParentColor = False'
  ;

  Result.Insert(1, Props);
end;

{ TConverterwNumLabel }

function TConverterwNumLabel.GetAddedUses: TArray<string>;
begin
  Result := ['cxCurrencyEdit'];
end;

function TConverterwNumLabel.GetComponentClassName: string;
begin
  Result := 'TwNumLabel';
end;

function TConverterwNumLabel.GetConvertCompClassName: string;
begin
  Result := 'TcxCurrencyEdit';
end;

function TConverterwNumLabel.GetConvertedCompStrs(
  ACompText: TStrings): TStrings;
var
  Props: string;
begin
  Result := inherited;

  Props := '' +
    '  EditValue = 0'#13#10 +
    '  Properties.Alignment.Horz = taRightJustify'#13#10 +
    '  Properties.AutoSelect = False'#13#10 +
    '  Properties.HideSelection = False'#13#10 +
    '  Properties.ReadOnly = True'
  ;
{
  EditValue = 0
  Properties.Alignment.Horz = taRightJustify
  Properties.AutoSelect = False
  Properties.HideSelection = False
  Properties.ReadOnly = True}
  Result.Insert(1, Props);
end;

{ TConverterwEdit }

function TConverterwEdit.GetAddedUses: TArray<string>;
begin
  Result := ['cxTextEdit'];
end;

function TConverterwEdit.GetComponentClassName: string;
begin
  Result := 'TwEdit';
end;

function TConverterwEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxTextEdit';
end;

{ TConverterwMaskEdit }

function TConverterwMaskEdit.GetAddedUses: TArray<string>;
begin
  Result := ['cxTextEdit', 'cxMaskEdit'];
end;

function TConverterwMaskEdit.GetComponentClassName: string;
begin
  Result := 'TwMaskEdit';
end;

function TConverterwMaskEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxMaskEdit';
end;

function TConverterwMaskEdit.GetConvertedCompStrs(
  ACompText: TStrings): TStrings;
var
  Props: string;
begin
  Result := inherited;

  Props := '' +
    '  Properties.AlwaysshowBlanksAndLiterals = True'
  ;
  Result.Insert(1, Props);
end;

initialization
  TConvertManager.Instance.Regist(TConverterwNumEdit);
  TConvertManager.Instance.Regist(TConverterwLabel);
  TConvertManager.Instance.Regist(TConverterwNumLabel);
  TConvertManager.Instance.Regist(TConverterwEdit);
  TConvertManager.Instance.Regist(TConverterwMaskEdit);

finalization

end.
