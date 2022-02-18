unit wControlConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterWControlToCxControl = class(TConverter)
  protected
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
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
  TConverterwNumEdit = class(TConverterWControlToCxControl)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
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
  TConverterwLabel = class(TConverterWControlToCxControl)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
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
  TConverterwNumLabel = class(TConverterWControlToCxControl)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
  end;

  TConverterwEdit = class(TConverterWControlToCxControl)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;
  end;

  TConverterwMaskEdit = class(TConverterWControlToCxControl)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
  end;

  TConverterwDateEdit = class(TConverterWControlToCxControl)
  protected
    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;
  end;

implementation

{ TConverterwControl }

function TConverterWControlToCxControl.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  I: Integer;
  S: string;
begin
  ACompText[0] := ACompText[0].Replace(GetTargetCompClassName, GetConvertCompClassName);

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
    else if S.Contains(' EditFormat =') then
      ACompText[I] := S.Replace(' EditFormat =', ' Properties.EditFormat =')

    else if S.Contains(' EditMask =') then
      ACompText[I] := S.Replace(' EditMask =', ' Properties.EditMask =').Replace(';0;''', ';0;_''')
    else if S.Contains(' Layout =') then
      ACompText[I] := S.Replace(' Layout =', ' Properties.Alignment.Vert =').Replace('tlCenter', 'taVCenter')

    // TwNumLabel 속성제거
    else if S.Contains(' IsNull =') then
      ACompText[I] := ''
    else if S.Contains(' MarginRight =') then
      ACompText[I] := ''

    else if S.Contains(' OnChange =') then
      ACompText[I] := S.Replace(' OnChange =', ' Properties.OnChange =')
    ;
  end;

  Result := True;
end;

function TConverterWControlToCxControl.GetRemoveUses: TArray<string>;
begin
  Result := ['URNEdit', 'URCtrls', 'UREdits', 'URLabels'];
end;

{ TConverterwNumEdit }

function TConverterwNumEdit.GetAddedUses: TArray<string>;
begin
  Result := ['cxCurrencyEdit'];
end;

function TConverterwNumEdit.GetTargetCompClassName: string;
begin
  Result := 'TwNumEdit';
end;

function TConverterwNumEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxCurrencyEdit';
end;

function TConverterwNumEdit.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  Props: string;
begin
  Result := inherited GetConvertedCompStrs(ACompText);

  Props := '' +
    '  EditValue = 0'#13#10 +
    '  Properties.Alignment.Horz = taRightJustify'#13#10 +
    '  Properties.DisplayFormat = ''#,##0'''#13#10 +
    '  Properties.UseThousandSeparator = True'
  ;

  ACompText.Insert(1, Props);
end;

{ TConverterwLabel }

function TConverterwLabel.GetAddedUses: TArray<string>;
begin
  Result := ['cxLabel'];
end;

function TConverterwLabel.GetTargetCompClassName: string;
begin
  Result := 'TwLabel';
end;

function TConverterwLabel.GetConvertCompClassName: string;
begin
  Result := 'TcxLabel';
end;

function TConverterwLabel.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  Props: string;
begin
  Result := inherited GetConvertedCompStrs(ACompText);

  Props := '' +
    '  AutoSize = False'#13#10 +
    '  ParentColor = False'
  ;

  ACompText.Insert(1, Props);
end;

{ TConverterwNumLabel }

function TConverterwNumLabel.GetAddedUses: TArray<string>;
begin
  Result := ['cxCurrencyEdit'];
end;

function TConverterwNumLabel.GetTargetCompClassName: string;
begin
  Result := 'TwNumLabel';
end;

function TConverterwNumLabel.GetConvertCompClassName: string;
begin
  Result := 'TcxCurrencyEdit';
end;

function TConverterwNumLabel.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  Props: string;
begin
  Result := inherited GetConvertedCompStrs(ACompText);

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
  ACompText.Insert(1, Props);
end;

{ TConverterwEdit }

function TConverterwEdit.GetAddedUses: TArray<string>;
begin
  Result := ['cxTextEdit'];
end;

function TConverterwEdit.GetTargetCompClassName: string;
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

function TConverterwMaskEdit.GetTargetCompClassName: string;
begin
  Result := 'TwMaskEdit';
end;

function TConverterwMaskEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxMaskEdit';
end;

function TConverterwMaskEdit.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  Props: string;
begin
  Result := inherited GetConvertedCompStrs(ACompText);

  Props := '' +
    '  Properties.AlwaysshowBlanksAndLiterals = True'
  ;
  ACompText.Insert(1, Props);
end;

{ TConverterwDateEdit }

function TConverterwDateEdit.GetAddedUses: TArray<string>;
begin
  Result := ['cxCalendar'];
end;

function TConverterwDateEdit.GetTargetCompClassName: string;
begin
  Result := 'TwDateEdit';
end;

function TConverterwDateEdit.GetConvertCompClassName: string;
begin
  Result := 'TcxDateEdit';
end;

function TConverterwDateEdit.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := inherited GetConvertedCompStrs(ACompText);

  for I := 0 to ACompText.Count - 1 do
  begin
    S := ACompText[I];
    if S.Contains('Time = ') then
      ACompText[I] := ''
    else if S.Contains('Checked = ') then
      ACompText[I] := '';
  end;
end;

//initialization
//  TConvertManager.Instance.Regist(TConverterwNumEdit);
//  TConvertManager.Instance.Regist(TConverterwLabel);
//  TConvertManager.Instance.Regist(TConverterwNumLabel);
//  TConvertManager.Instance.Regist(TConverterwEdit);
//  TConvertManager.Instance.Regist(TConverterwMaskEdit);
//  TConvertManager.Instance.Regist(TConverterwDateEdit);

//finalization

end.
