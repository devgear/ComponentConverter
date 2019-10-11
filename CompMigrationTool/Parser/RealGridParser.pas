unit RealGridParser;

interface

uses
  ObjectTextParser,
  System.Generics.Collections, System.Classes, System.SysUtils;

type
  // 리얼그리드 컬럼 정보
  TRealGridColumnInfo = record
    Alignment: string;
    TitleCaption: string;
    Visible: Boolean;
    ReadOnly: Boolean;
    Width: Integer;
    Group: Integer;
    DataType: string; // wdtFloat
    DisplayFormat: string;
    LevelIndex: Integer;
    Items: TArray<string>;
    Values: TArray<string>;
    FooterStyle: string;
  end;

  // 리얼그리드 그룹 정보
  TRealGridGroupInfo = record
    TitleCaption: string;
    TitleVisible: Boolean;
    Visible: Boolean;
    Width: Integer;
  end;

  TRealGridEventInfo = record
    Prop,           // 이벤트 종류(e.g. OnClick)
    Value: string;  // 이벤트(e.g. Button1Click)
  end;

  TRealGridParser = class(TObjectTextParser)
  private
    FCollection: string;

    FUseFooter: Boolean;
    FColumn: TRealGridColumnInfo;
    FGroup: TRealGridGroupInfo;

    FColumnInfos: TList<TRealGridColumnInfo>;
    FGroupInfos: TList<TRealGridGroupInfo>;
    FEventInfos: TList<TRealGridEventInfo>;
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
    property FooterVisible: Boolean read FUseFooter;
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
  FEventInfos := TList<TRealGridEventInfo>.Create;
  FUseFooter := False;
end;


destructor TRealGridParser.Destroy;
begin
  FColumnInfos.Free;
  FGroupInfos.Free;
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
    FColumn.Group := 0;
    FColumn.ReadOnly := False;
    FColumn.DataType := '';
    FColumn.LevelIndex := 0;
    FColumn.Items := [];
    FColumn.Values := [];
    FColumn.FooterStyle := '';
    FColumn.Width := 64;
  end
  else
  begin
    FGroup := Default(TRealGridGroupInfo);
    FGroup.Visible := True;
    FGroup.Width := 0;
    FGroup.TitleVisible := True;
  end;
end;

procedure TRealGridParser.EndCollectionItem;
begin
  inherited;

  if LowerCase(FCollection) = 'columns' then
    FColumnInfos.Add(FColumn)
  else if LowerCase(FCollection) = 'groups' then
    FGroupInfos.Add(FGroup);
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
      FColumn.Width := StrToIntDef(AValue, 0);
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
      FGroup.TitleCaption := AValue;
  end
  else if LowerCase(FCollection) = 'footers' then
  begin
    FUseFooter := True;
  end;
end;

procedure TRealGridParser.WriteListItem(AProp, AValue: string);
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
      if AValue[1] = '2' then
        FColumn.FooterStyle := 'skCount'
      else if AValue[1] = '3' then
        FColumn.FooterStyle := 'skSum'
      else if AValue[1] = '4' then
        FColumn.FooterStyle := 'skAverage'
      else if AValue[1] = '5' then
        FColumn.FooterStyle := 'skMax'
      else if AValue[1] = '6' then
        FColumn.FooterStyle := 'skMin'
      else
        FColumn.FooterStyle := ''
      ;
    end;
  end;
end;

end.
