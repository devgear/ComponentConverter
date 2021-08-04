unit cxGridViewParser;

interface

uses
  ObjectTextParser,
  System.Generics.Collections, System.Classes, System.SysUtils;

type
  TBandInfo = record
    Index: Integer;
    Caption: string;
    FixedKind: string;
    VisibleForCustomization: Boolean;
  end;

  TColumnInfo = record
    Name: string;
    FieldName: string;
    Caption: string;
    BandIndex: Integer;
    ColIndex: Integer;
    RowIndex: Integer;
    LineCount: Integer;

    StylesHeader: string;

    ToBandIndex: Integer;
    ToColIndex: Integer;
  end;

  TGridViewParser = class(TObjectTextParser)
  private
    FCollection: string;
    FObjectName, FClassName: string;

    FBand: TBandInfo;
    FColumn: TColumnInfo;

    FBands: TList<TBandInfo>;
    FColumns: TList<TColumnInfo>;
  protected
    procedure BeginCollection(AName: string); override;
    procedure EndCollection(AName: string); override;
    procedure BeginCollectionItem; override;
    procedure EndCollectionItem; override;

    procedure BeginObject(AName, AClassName: string); override;
    procedure EndObject(AName, AClassName: string); override;

    procedure WriteProperty(AProp, AValue: string); override;
    procedure WriteCollectionItem(AProp, AValue: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Bands: TList<TBandInfo> read FBands;
    property Columns: TList<TColumnInfo> read FColumns;
  end;

implementation

{ TGridViewParser }

constructor TGridViewParser.Create;
begin
  inherited;

  FBands := TList<TBandInfo>.Create;
  FColumns := TList<TColumnInfo>.Create;
end;

destructor TGridViewParser.Destroy;
begin
  FBands.Free;
  FColumns.Free;

  inherited;
end;

procedure TGridViewParser.BeginCollection(AName: string);
begin
  inherited;

  FCollection := AName;
end;

procedure TGridViewParser.EndCollection(AName: string);
begin
  inherited;

  FCollection := '';
end;

procedure TGridViewParser.BeginCollectionItem;
begin
  inherited;

  if FCollection = 'Bands' then
  begin
    FBand.VisibleForCustomization := True;
  end;
end;

procedure TGridViewParser.EndCollectionItem;
begin
  inherited;

  if FCollection = 'Bands' then
    FBands.Add(FBand);
end;

procedure TGridViewParser.BeginObject(AName, AClassName: string);
begin
  FObjectName := AName;
  FClassName := AClassName;

  FColumn := Default(TColumnInfo);
  FColumn.Name := AName;
end;

procedure TGridViewParser.EndObject(AName, AClassName: string);
begin
  FObjectName := '';
  FColumns.Add(FColumn);
end;

procedure TGridViewParser.WriteCollectionItem(AProp, AValue: string);
begin
  inherited;

  if FCollection = 'Bands' then
  begin
    if AProp = 'Caption' then
      FBand.Caption := AValue
    else if AProp = 'FixedKind' then
      FBand.FixedKind := AValue
    else if AProp = 'VisibleForCustomization' then
      FBand.VisibleForCustomization := StrToBoolDef(AValue, True)
    ;
  end;

end;

procedure TGridViewParser.WriteProperty(AProp, AValue: string);
begin
  if ObjectLevel <> 1 then
    inherited
  else if FClassName = 'TcxGridDBBandedColumn' then
  begin
    if AProp = 'Caption' then
      FColumn.Caption := AValue
    else if AProp = 'DataBinding.FieldName' then
      FColumn.FieldName := AValue
    else if AProp = 'Position.BandIndex' then
      FColumn.BandIndex := StrToIntDef(AValue, 0)
    else if AProp = 'Position.BandIndex' then
      FColumn.ColIndex := StrToIntDef(AValue, 0)
    else if AProp = 'Position.BandIndex' then
      FColumn.RowIndex := StrToIntDef(AValue, 0)
    else if AProp = 'Position.LineCount' then
      FColumn.LineCount := StrToIntDef(AValue, 0)
    ;

  end;
end;

end.
