unit RealGridParser;

interface

uses
  ObjectTextParser,
  System.Generics.Collections, System.Classes, System.SysUtils;

type
  TFooterStyleInfo = record
    Visible: string;
    Value: string;
  end;

  // 리얼그리드 컬럼 정보
  TRealGridColumnInfo = record
    Alignment: string;
    TitleCaption: string;
    Visible: Boolean;
    ReadOnly: Boolean;
    ColWidth: Integer;
    Group: Integer;
    DataType: string; // wdtFloat
    DisplayFormat: string;
    LevelIndex: Integer;
    Items: TArray<string>;
    Values: TArray<string>;
//    FooterStyle: string;
    FooterStyles: TArray<TFooterStyleInfo>;
    FooterAlign: string;

    //
    Level: Integer;
    Color: string;
    TitleColor: string;
    FontColor: string;
    FieldName: string;
    GrpWidth: Integer;

    EditStyle: string;
    EditFormat: string;
    TitleClicking: Boolean;

    function EditFormatIsCurrency: Boolean;
    function EditFormatIsDate: Boolean;
    function FooterStyleVisibleCount: Integer;
  end;

  // 리얼그리드 그룹 정보
  TRealGridGroupInfo = record
    TitleCaption: string;
    TitleVisible: Boolean;
    TitleColor: string;
    Visible: Boolean;
    Width: Integer;
    Levels: Integer;
  end;

  TRealGridFooterInfo = record
    Visible: Boolean;
  end;

  TRealGridEventInfo = record
    Prop,           // 이벤트 종류(e.g. OnClick)
    Value: string;  // 이벤트(e.g. Button1Click)
  end;

  TRealGridParser = class(TObjectTextParser)
  private
    FCollection: string;

    FColumn: TRealGridColumnInfo;
    FGroup: TRealGridGroupInfo;
    FFooter: TRealGridFooterInfo;

    FColumnInfos: TList<TRealGridColumnInfo>;
    FGroupInfos: TList<TRealGridGroupInfo>;
    FFooterInfos: TList<TRealGridFooterInfo>;
    FEventInfos: TList<TRealGridEventInfo>;
    function GetGroupMaxLevels: Integer;
    function GetFooterVisibleCount: Integer;
  protected
    procedure BeginCollection(AName: string); override;
    procedure EndCollection(AName: string); override;
    procedure BeginCollectionItem; override;
    procedure EndCollectionItem; override;

    procedure WriteProperty(AProp, AValue: string); override;
    procedure WriteCollectionItem(AProp, AValue: string); override;
    procedure WriteListItem(AProp, AValue: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property ColumnInfos: TList<TRealGridColumnInfo> read FColumnInfos; // 그리드 컬럼 정보
    property GroupInfos: TList<TRealGridGroupInfo> read FGroupInfos;    // 그리드 그룹(밴드) 정보
    property EventInfos: TList<TRealGridEventInfo> read FEventInfos;    // 그리드 이벤트 정보
    property FooterInfos: TList<TRealGridFooterInfo> read FFooterInfos;
    property FooterVisibleCount: Integer read GetFooterVisibleCount;
    property GroupMaxLevels: Integer read GetGroupMaxLevels;
  end;


implementation

uses
  Vcl.Dialogs, Winapi.Windows;

{ TRealGridParser }

constructor TRealGridParser.Create;
begin
  inherited;

  FColumnInfos := TList<TRealGridColumnInfo>.Create;
  FGroupInfos := TList<TRealGridGroupInfo>.Create;
  FFooterInfos := TList<TRealGridFooterInfo>.Create;
  FEventInfos := TList<TRealGridEventInfo>.Create;
end;


destructor TRealGridParser.Destroy;
begin
  FColumnInfos.Free;
  FGroupInfos.Free;
  FFooterInfos.Free;
  FEventInfos.Free;

  inherited;
end;

procedure TRealGridParser.BeginCollection(AName: string);
begin
  inherited;

  FCollection := AName;
end;

procedure TRealGridParser.EndCollection(AName: string);
begin
  inherited;

  FCollection := '';
end;

procedure TRealGridParser.BeginCollectionItem;
begin
  inherited;

  // 기본 값 설정 할 것
  if LowerCase(FCollection) = 'columns' then
  begin
    FColumn := Default(TRealGridColumnInfo);
    FColumn.Visible := True;
    FColumn.Group := -1;
    FColumn.ReadOnly := False;
    FColumn.DataType := '';
    FColumn.Level := 0;
    FColumn.LevelIndex := 0;
    FColumn.Items := [];
    FColumn.Values := [];
//    FColumn.FooterStyle := '';
    FColumn.FooterStyles := [];
    FColumn.FooterAlign := '';
    FColumn.ColWidth := 64;
    FColumn.Alignment := '';

    FColumn.Color := '';
    FColumn.TitleColor := '';
    FColumn.FieldName := '';
    FColumn.GrpWidth := 64;

    FColumn.EditStyle := '';
    FColumn.EditFormat := '';
  end
  else if LowerCase(FCollection) = 'groups' then
  begin
    FGroup := Default(TRealGridGroupInfo);
    FGroup.Visible := True;
    FGroup.Width := 0;
    FGroup.TitleVisible := True;
    FGroup.TitleColor := '';
    FGroup.Levels := 1;
  end
  else if LowerCase(FCollection) = 'footers' then
  begin
    FFooter := Default(TRealGridFooterInfo);
    FFooter.Visible := True;
  end;
end;

procedure TRealGridParser.EndCollectionItem;
begin
  inherited;

  if LowerCase(FCollection) = 'columns' then
    FColumnInfos.Add(FColumn)
  else if LowerCase(FCollection) = 'groups' then
    FGroupInfos.Add(FGroup)
  else if LowerCase(FCollection) = 'footers' then
    FFooterInfos.Add(FFooter)
  ;
end;

function TRealGridParser.GetGroupMaxLevels: Integer;
var
  Group: TRealGridGroupInfo;
begin
  Result := 1;
  for Group in FGroupInfos do
  begin
    if Group.Levels > Result then
      Result := Group.Levels;
  end;
end;

function TRealGridParser.GetFooterVisibleCount: Integer;
var
  Info: TRealGridFooterInfo;
begin
  Result := 0;

  for Info in FFooterInfos do
  begin
    if Info.Visible then
      Inc(Result);
  end;
end;

procedure TRealGridParser.WriteProperty(AProp, AValue: string);
var
  Event: TRealGridEventInfo;
begin
  inherited;

  if AProp.StartsWith('On') then
  begin
    Event.Prop := AProp;
    Event.Value := AValue;

    FEventInfos.Add(Event);
  end;

end;

procedure TRealGridParser.WriteCollectionItem(AProp, AValue: string);
begin
  if LowerCase(FCollection) = 'columns' then
  begin
    if AProp = 'Alignment' then
      FColumn.Alignment := AValue
    else if AProp = 'Group' then
      FColumn.Group := StrToIntDef(AValue, 0)
    else if AProp = 'Title.Caption' then
      FColumn.TitleCaption := AValue
    else if AProp = 'Title.Clicking' then
      FColumn.TitleClicking := StrToBoolDef(AVAlue, False)
    else if AProp = 'Visible' then
      FColumn.Visible := StrToBoolDef(AValue, True)
    else if AProp = 'ReadOnly' then
      FColumn.ReadOnly := StrToBoolDef(AValue, True)
    else if AProp = 'DataType' then
      FColumn.DataType := AValue
    else if AProp = 'LevelIndex' then
      FColumn.LevelIndex := StrToIntDef(AValue, 0)
    else if AProp = 'DisplayFormat' then
      FColumn.DisplayFormat := AValue
    else if AProp = 'ColWidth' then
      FColumn.ColWidth := StrToIntDef(AValue, 0)

    else if AProp = 'Color' then
      FColumn.Color := AValue
    else if AProp = 'Title.Color' then
      FColumn.TitleColor := AValue
    else if AProp = 'Font.Color' then
      FColumn.FontColor := AValue
    else if AProp = 'FieldName' then
      FColumn.FieldName := AValue
    else if AProp = 'GrpWidth' then
      FColumn.GrpWidth := StrToIntDef(AValue, 0)
    else if AProp = 'Level' then
      FColumn.Level := StrToIntDef(AValue, 0)

    else if AProp = 'EditStyle' then
      FColumn.EditStyle := AValue
    else if AProp = 'EditFormat' then
      FColumn.EditFormat := AValue

    else if AProp = 'Footer.Alignment' then
      FColumn.FooterAlign := AValue

    else if AProp = 'Footer.Font.Style' then
      if AValue = '[fsBold]' then
        Properties.Values['FooterBold'] := 'True';
    ;

//    Color: string;
//    TitleColor: string;
//    FieldName: string;
//    GrpWidth: string;

  end
  else if LowerCase(FCollection) = 'groups' then
  begin
    if AProp = 'Visible' then
      FGroup.Visible := StrToBool(AValue)
    else if AProp = 'Title.Visible' then
      FGroup.TitleVisible := StrToBool(AValue)
    else if AProp = 'Width' then
      FGroup.Width := StrToIntDef(AValue, 0)
    else if AProp = 'Title.Caption' then
      FGroup.TitleCaption := AValue
    else if AProp = 'Levels' then
      FGroup.Levels := StrToIntDef(AValue, 1)
    else if AProp = 'Title.Color' then
      FGroup.TitleColor := AValue
    ;
  end
  else if LowerCase(FCollection) = 'footers' then
  begin
    if AProp = 'Visible' then
      FFooter.Visible := StrToBool(AValue)
  end
  ;
end;

procedure TRealGridParser.WriteListItem(AProp, AValue: string);
var
  Info: TFooterStyleInfo;
begin
//  OutputDebugString(PChar(Format('%s - %s', [AProp, AValue])));
  if LowerCase(FCollection) = 'columns' then
  begin
    if AProp = 'Items.Strings' then
      FColumn.Items := FColumn.Items + [AValue]
    else if AProp = 'Values.Strings' then
      FColumn.Values := FColumn.Values + [AValue]
    else if AProp = 'Footer.Style' then
    begin
      Info := Default(TFooterStyleInfo);
      Info.Visible := AValue[1];
      Info.Value := Copy(AValue, 2, Length(AValue));
      FColumn.FooterStyles := FColumn.FooterStyles + [Info];
//      if AValue[1] = '1' then
//        FColumn.FooterStyle := 'skNone'
//      else if AValue[1] = '2' then
//        FColumn.FooterStyle := 'skCount'
//      else if AValue[1] = '3' then
//        FColumn.FooterStyle := 'skSum'
//      else if AValue[1] = '4' then
//        FColumn.FooterStyle := 'skAverage'
//      else if AValue[1] = '5' then
//        FColumn.FooterStyle := 'skMax'
//      else if AValue[1] = '6' then
//        FColumn.FooterStyle := 'skMin'
//      else // 0
//        FColumn.FooterStyle := ''
//      ;
    end;
  end;
end;

{ TRealGridColumnInfo }

function TRealGridColumnInfo.EditFormatIsCurrency: Boolean;
begin
  if EditFormat = '' then
    Exit(False);

  Result := EditFormat.Contains('#') and EditFormat.Contains(',');
end;

function TRealGridColumnInfo.EditFormatIsDate: Boolean;
begin
  if EditFormat = '' then
    Exit(False);

  Result := EditFormat.Contains('-') and EditFormat.Contains(';');
end;

function TRealGridColumnInfo.FooterStyleVisibleCount: Integer;
var
  Info: TFooterStyleInfo;
begin
  Result := 0;
  for Info in FooterStyles do
  begin
    if Info.Visible = '1' then
      Inc(Result);
  end;
end;

end.
