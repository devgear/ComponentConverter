unit EtcPropsConverter;

interface

uses
  CompConverterTypes,
  System.SysUtils, System.Classes,
  CompConverter;

type
  // TLabel의 Color 설정된 경우 Transparent = True 설정
  TConverterLabelColor = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;

  // TGroupBox의 Color 설정된 경우 ParentBackground = False 설정
  TConverterGroupBoxColor = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;

  // TGroupBox의 Color 설정된 경우 ParentBackground = False 설정
  TConverterDBGrid = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;

  TConverterStaticTextColor = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;

  TConverterComboBoxStyle = class(TConverter)
  protected
    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;

    function GetDescription: string; override;
  end;

  // TPanel의 ParentBackground = False 처리
  TConverterPanelParentBackground = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;

implementation

{ TConverterUpdateSQLConnection }

function TConverterLabelColor.FindComponentInDfm(
  AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasColor: Boolean;
begin
  while True do
  begin
    Result := inherited;
    if not Result then
      Break;

    HasColor := False;
    for I := AData.CompStartIndex + 1 to AData.CompEndIndex - 2 do
    begin
      S := AData.SrcDfm[I];
      if S.Trim.StartsWith('Transparent =') then
      begin
        HasColor := False;
        Break;
      end;

      if S.Trim.StartsWith('Color = ') then
        HasColor := True;
    end;
    if HasColor then
      Exit(True);
  end;

  Result := False;
end;

function TConverterLabelColor.GetComponentClassName: string;
begin
  Result := 'TLabel';
end;

function TConverterLabelColor.GetConvertCompClassName: string;
begin
  Result := 'TLabel';
end;

function TConverterLabelColor.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
begin
  ACompText.Insert(ACompText.Count - 1, '  Transparent = False');
  Result := True;
  Output := ACompText.Text;
end;

function TConverterLabelColor.GetDescription: string;
begin
  Result := 'Label.Color 설정';
end;

{ TConverterGroupBoxColor }

function TConverterGroupBoxColor.FindComponentInDfm(
  AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasColor: Boolean;
begin
  while True do
  begin
    Result := inherited;
    if not Result then
      Break;

    HasColor := False;
    for I := AData.CompStartIndex + 1 to AData.CompEndIndex - 2 do
    begin
      S := AData.SrcDfm[I];
      if S.Trim.Contains('ParentBackground = False') then
      begin
        HasColor := False;
        Break;
      end;

      if S.Trim.StartsWith('object ') then
      begin
        Break;
      end;

      if S.Trim.StartsWith('Color = ') then
        HasColor := True;
    end;
    if HasColor then
      Exit(True);
  end;

  Result := False;
end;

function TConverterGroupBoxColor.GetComponentClassName: string;
begin
  Result := 'TGroupBox';
end;

function TConverterGroupBoxColor.GetConvertCompClassName: string;
begin
  Result := 'TGroupBox';
end;

function TConverterGroupBoxColor.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
begin
  ACompText.Insert(1, '  ParentBackground = False');
  Result := True;
  Output := ACompText.Text;
end;

function TConverterGroupBoxColor.GetDescription: string;
begin
  Result := 'GroupBox.Color 설정';
end;

{ TConverterDBGrid }

function TConverterDBGrid.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasTag: Boolean;
begin
  while True do
  begin
    Result := inherited;
    if not Result then
      Break;

    HasTag := False;
    for I := AData.CompStartIndex + 1 to AData.CompEndIndex - 2 do
    begin
      S := AData.SrcDfm[I];
      if S.Trim.Contains('DrawingStyle = gdsClassic') then
      begin
        HasTag := True;
        Break;
      end;

      if S.Trim.StartsWith('object ') then
      begin
        Break;
      end;
    end;
    if not HasTag then
      Exit(True);
  end;

  Result := False;
end;

function TConverterDBGrid.GetComponentClassName: string;
begin
  Result := 'TDBGrid';
end;

function TConverterDBGrid.GetConvertCompClassName: string;
begin
  Result := 'TDBGrid';
end;

function TConverterDBGrid.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
begin
  ACompText.Insert(ACompText.Count - 1, '  DrawingStyle = gdsClassic');
  Result := True;
  Output := ACompText.Text;

end;

function TConverterDBGrid.GetDescription: string;
begin
  Result := 'TDBGrid - DrawingStyle = gdsClassic'
end;

{ TConverterStaticTextColor }

function TConverterStaticTextColor.FindComponentInDfm(
  AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasColor: Boolean;
begin
  while True do
  begin
    Result := inherited;
    if not Result then
      Break;

    HasColor := False;
    for I := AData.CompStartIndex + 1 to AData.CompEndIndex - 2 do
    begin
      S := AData.SrcDfm[I];
      if S.Trim.StartsWith('Transparent =') then
      begin
        HasColor := False;
        Break;
      end;

      if S.Trim.StartsWith('Color = ') then
        HasColor := True;
    end;
    if HasColor then
      Exit(True);
  end;

  Result := False;
end;

function TConverterStaticTextColor.GetComponentClassName: string;
begin
  Result := 'TStaticText';
end;

function TConverterStaticTextColor.GetConvertCompClassName: string;
begin
  Result := 'TStaticText';
end;

function TConverterStaticTextColor.GetConvertedCompText(ACompText: TStrings;
  var Output: string): Boolean;
begin
  ACompText.Insert(ACompText.Count - 1, '  Transparent = False');
  Result := True;
  Output := ACompText.Text;
end;

function TConverterStaticTextColor.GetDescription: string;
begin
  Result := 'Label.Color 설정';
end;

{ TConverterComboBoxStyle }

function TConverterComboBoxStyle.GetComponentClassName: string;
begin
  Result := 'TComboBox';
end;

function TConverterComboBoxStyle.GetConvertCompClassName: string;
begin
  Result := 'TComboBox';
end;

function TConverterComboBoxStyle.GetConvertedCompStrs(
  var ACompText: TStrings): Boolean;
var
  I: Integer;
  S: string;
begin
  for I := 1 to ACompText.Count - 2 do
  begin
    S := ACompText[I];
    if S.Trim = 'Style = csDropDownList' then
    begin
      ACompText[I] := S.Replace('csDropDownList', 'csOwnerDrawFixed');
      Exit(True);
    end;
  end;
  Result := False;
end;

function TConverterComboBoxStyle.GetDescription: string;
begin
  Result := 'ComboBox Style 변경';
end;

{ TConverterPanelParentBackground }

function TConverterPanelParentBackground.FindComponentInDfm(
  AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
begin
  while True do
  begin
    Result := inherited;
    if not Result then
      Break;

    for I := AData.CompStartIndex + 1 to AData.CompEndIndex - 2 do
    begin
      S := AData.SrcDfm[I];
      if S.Trim = 'ParentBackground = False' then
      begin
        Result := False;
        Break;
      end;
    end;

    if Result then
      Exit;
  end;
end;

function TConverterPanelParentBackground.GetComponentClassName: string;
begin
  Result := 'TPanel';
end;

function TConverterPanelParentBackground.GetConvertCompClassName: string;
begin
  Result := 'TPanel';
end;

function TConverterPanelParentBackground.GetConvertedCompText(
  ACompText: TStrings; var Output: string): Boolean;
begin
  ACompText.Insert(1, '  ParentBackground = False');
  Result := True;
  Output := ACompText.Text;
end;

function TConverterPanelParentBackground.GetDescription: string;
begin
  Result := 'Panel.ParentBackgound 설정';
end;

initialization
  TConvertManager.Instance.Regist(TConverterLabelColor);
  TConvertManager.Instance.Regist(TConverterGroupBoxColor);
  TConvertManager.Instance.Regist(TConverterDBGrid);
  TConvertManager.Instance.Regist(TConverterStaticTextColor);
  TConvertManager.Instance.Regist(TConverterComboBoxStyle);
  TConvertManager.Instance.Regist(TConverterPanelParentBackground);

end.
