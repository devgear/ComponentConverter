unit cxGridConverter;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConvertercxGrid = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetConvertedCompText(ACompText: TStrings): string; override;

    function GetDescription: string; override;
  end;

implementation

{ TConvertercxDateEdit }

function TConvertercxGrid.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
  HasCode: array[0..3] of Boolean;
begin
  Result := inherited;

  if Result then
  begin
    HasCode[0] := False;
    HasCode[1] := False;
    HasCode[2] := False;
    HasCode[3] := False;
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];

      if S.Contains('LookAndFeel.NativeStyle = False') then
        HasCode[0] := True;
      if S.Contains('Styles.StyleSheet = ComModule.GridBandedTableViewStyleSheetDevExpress') then
        HasCode[1] := True;

      if S.Contains('OptionsView.HeaderHeight = 25') then
        HasCode[2] := True;
      if S.Contains('OptionsView.DataRowHeight = 25') then
        HasCode[3] := True;
    end;

    for I := 0 to Length(HasCode)-1 do
      if not HasCode[I] then
        Exit(True);
  end;
end;

function TConvertercxGrid.GetComponentClassName: string;
begin
  Result := 'TcxGrid';
end;

function TConvertercxGrid.GetConvertCompClassName: string;
begin
  Result := 'TcxGrid';
end;

function TConvertercxGrid.GetConvertedCompText(ACompText: TStrings): string;
var
  I: Integer;
  S: string;
  GridIdx, ViewIdx: Integer;
  ViewIdxs: TArray<Integer>; // View 여러건
  HasCode: array[0..3] of Boolean;
begin
  for I := 0 to Length(HasCode) - 1 do
    HasCode[I] := False;
  for I := 0 to ACompText.Count - 1 do
  begin
    S := ACompText[I].Trim;

    if S.StartsWith('object ') then
    begin
      if S.EndsWith(': TcxGrid') or S.Contains(': TcxGrid ') then
        GridIdx := I;
      if S.EndsWith('TableView') then
        ViewIdxs := ViewIdxs + [I];
    end;

    if S.Contains('LookAndFeel.NativeStyle ') then
    begin
      ACompText[I] := 'LookAndFeel.NativeStyle = False';
      HasCode[0] := True;
    end;

    if S.Contains('Styles.StyleSheet = ') then
    begin
      ACompText[I] := 'Styles.StyleSheet = ComModule.GridBandedTableViewStyleSheetDevExpress';
      HasCode[1] := True;
    end;

    if S.Contains('OptionsView.HeaderHeight = ') then
    begin
      ACompText[I] := 'OptionsView.HeaderHeight = 25';
      HasCode[2] := True;
    end;
    if S.Contains('OptionsView.DataRowHeight =') then
    begin
      ACompText[I] := 'OptionsView.DataRowHeight = 25';
      HasCode[3] := True;
    end;
  end;

  // View 진행 > Grid 진행(아래에서 Idx 변경되기 때문에)
  for I := Length(ViewIdxs)-1 downto 0 do
  begin
    ViewIdx := ViewIdxs[I];
    if not HasCode[3] then
      ACompText.Insert(ViewIdx+1, 'OptionsView.DataRowHeight = 25');
    if not HasCode[2] then
      ACompText.Insert(ViewIdx+1, 'OptionsView.HeaderHeight = 25');
    if not HasCode[1] then
      ACompText.Insert(ViewIdx+1, 'Styles.StyleSheet = ComModule.GridBandedTableViewStyleSheetDevExpress');
  end;
  if not HasCode[0] then
    ACompText.Insert(GridIdx+1, 'LookAndFeel.NativeStyle = False');

  Result := ACompText.Text;
end;

function TConvertercxGrid.GetDescription: string;
begin
  Result := 'TcxGrid 스타일 일괄적용';
end;

function TConvertercxGrid.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConvertercxGrid);

end.
