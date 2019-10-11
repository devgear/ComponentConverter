unit ObjectTextParser;

interface

uses
  System.Classes, System.SysUtils;

type
  TStringListHelper = class helper for TStringList
  private
    function GetValueDef(const Name: string; const Def: string): string;
  public
    property ValuesDef[const Name: string; const Def: string]: string read GetValueDef;
  end;

  // Reference : System.Classes.ObjectTextToBinary
  TObjectTextParser = class
  private
    FPropertyName: string;
    FCollectionName: string;
    FListName: string;
    FIsList,
    FIsCollection: Boolean;
    FCompName: string;
    FProperties: TStringList;
    procedure FindProperty(AName: string);

    procedure FindValueIdent(AValue: string);
    procedure FindValueInteger(AValue: Integer);
    procedure FindValueString(AValue: string);
    procedure FindValueSingle(AValue: Single);
    procedure FindValueCurrency(AValue: Currency);
    procedure FindValueDate(AValue: TDateTime);
    procedure FindValueFloat(AValue: Extended);

    procedure FindValueBinary(WriteData: TStreamProc);

    procedure FindListStart;
    procedure FindListEnd;

    procedure FindCollectionStart;
    procedure FindCollectionEnd;
    procedure FindCollectionItemBegin;
    procedure FindCollectionItemEnd;

    procedure SetPropertyValue(AProp, AValue: string);
  protected
    procedure BeginList(AName: string); virtual;
    procedure EndList(AName: string); virtual;

    procedure BeginCollection(AName: string); virtual;
    procedure EndCollection(AName: string); virtual;
    procedure BeginCollectionItem; virtual;
    procedure EndCollectionItem; virtual;

    // 속성 기록
    procedure WriteProperty(AProp, AValue: string); virtual;
    // 속성 중 Collection 기록
    procedure WriteCollectionItem(AProp, AValue: string); virtual;
    procedure WriteListItem(AProp, AValue: string); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Parse(AObjectText: string);

    property CompName: string read FCompName;
    property Properties: TStringList read FProperties;
  end;

implementation

uses
  ConvertUtils;

{ TObjectTextParser }

constructor TObjectTextParser.Create;
begin
  FIsCollection := False;

  FProperties := TStringList.Create;
end;

destructor TObjectTextParser.Destroy;
begin
  FProperties.Free;

  inherited;
end;

procedure TObjectTextParser.BeginCollection(AName: string);
begin
end;

procedure TObjectTextParser.EndCollection(AName: string);
begin
end;

procedure TObjectTextParser.BeginCollectionItem;
begin
end;

procedure TObjectTextParser.BeginList(AName: string);
begin
end;

procedure TObjectTextParser.EndCollectionItem;
begin
end;

procedure TObjectTextParser.EndList(AName: string);
begin

end;

procedure TObjectTextParser.FindCollectionStart;
begin
  FIsCollection := True;
  FCollectionName := FPropertyName;

  BeginCollection(FCollectionName);
end;

procedure TObjectTextParser.FindListStart;
begin
  FIsList := True;
  FListName := FPropertyName;

  BeginList(FListName);
end;

procedure TObjectTextParser.FindListEnd;
begin
  FIsList := False;
  EndList(FListName);
end;

procedure TObjectTextParser.FindCollectionEnd;
begin
  FIsCollection := False;
  EndCollection(FCollectionName);
end;

procedure TObjectTextParser.FindCollectionItemBegin;
begin
  BeginCollectionItem;
end;

procedure TObjectTextParser.FindCollectionItemEnd;
begin
  EndCollectionItem;
end;

procedure TObjectTextParser.FindProperty(AName: string);
begin
  FPropertyName := AName;
end;

procedure TObjectTextParser.FindValueBinary(WriteData: TStreamProc);
var
  Stream: TMemoryStream;

  Count: Int32;
begin
  Stream := TMemoryStream.Create;
  try
    WriteData(Stream);
//    WriteValue(vaBinary);
    Count := Stream.Size;
//    Write(Count, SizeOf(Count));
//    Write(Stream.Memory^, Count);
  finally
    Stream.Free;
  end;
end;

procedure TObjectTextParser.FindValueCurrency(AValue: Currency);
begin
  SetPropertyValue(FPropertyName, CurrToStr(AValue));
end;

procedure TObjectTextParser.FindValueDate(AValue: TDateTime);
begin
  SetPropertyValue(FPropertyName, DateTimeToStr(AValue));
end;

procedure TObjectTextParser.FindValueFloat(AValue: Extended);
begin
  SetPropertyValue(FPropertyName, FloatToStr(AValue));
end;

procedure TObjectTextParser.FindValueIdent(AValue: string);
begin
  SetPropertyValue(FPropertyName, AValue);
end;

procedure TObjectTextParser.FindValueInteger(AValue: Integer);
begin
  SetPropertyValue(FPropertyName, IntToStr(AValue));
end;

procedure TObjectTextParser.FindValueSingle(AValue: Single);
begin
  SetPropertyValue(FPropertyName, FloatToStr(AValue));
end;

procedure TObjectTextParser.FindValueString(AValue: string);
begin
  SetPropertyValue(FPropertyName, AValue);
end;

procedure TObjectTextParser.Parse(AObjectText: string);
var
  Parser: TParser;
  FFmtSettings: TFormatSettings;
  TokenStr: String;

  function ConvertOrderModifier: Integer;
  begin
    Result := -1;
    if Parser.Token = '[' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toInteger);
      Result := Parser.TokenInt;
      Parser.NextToken;
      Parser.CheckToken(']');
      Parser.NextToken;
    end;
  end;

  procedure ConvertHeader(IsInherited, IsInline: Boolean);
  var
    ClassName, ObjectName: string;
    Flags: TFilerFlags;
    Position: Integer;
  begin
    Parser.CheckToken(toSymbol);
    ClassName := Parser.TokenString;
    ObjectName := '';
    if Parser.NextToken = ':' then
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      ObjectName := ClassName;
      ClassName := Parser.TokenString;
      Parser.NextToken;
    end;
    Flags := [];
    Position := ConvertOrderModifier;
    if IsInherited then
      Include(Flags, ffInherited);
    if IsInline then
      Include(Flags, ffInline);
    if Position >= 0 then
      Include(Flags, ffChildPos);
//    Writer.WritePrefix(Flags, Position);
//    Writer.WriteUTF8Str(ClassName);
//    Writer.WriteUTF8Str(ObjectName);
  end;

  procedure ConvertProperty; forward;

  procedure ConvertValue;
  var
    Order: Integer;

    function CombineString: String;
    begin
      Result := Parser.TokenWideString;
      while Parser.NextToken = '+' do
      begin
        Parser.NextToken;
        if not (Parser.Token in [System.Classes.toString, toWString]) then
          Parser.CheckToken(System.Classes.toString);
        Result := Result + Parser.TokenWideString;
      end;
    end;

  begin
    if Parser.Token in [System.Classes.toString, toWString] then
      FindValueString(CombineString)
    else
    begin
      case Parser.Token of
        toSymbol:
          FindValueIdent(Parser.TokenComponentIdent);
        toInteger:
          FindValueInteger(Parser.TokenInt);
        toFloat:
          begin
            case Parser.FloatType of
              's', 'S': FindValueSingle(Parser.TokenFloat);
              'c', 'C': FindValueCurrency(Parser.TokenFloat / 10000);
              'd', 'D': FindValueDate(Parser.TokenFloat);
            else
              FindValueFloat(Parser.TokenFloat);
            end;
          end;
        '[':
          begin
            Parser.NextToken;
//            Writer.WriteValue(vaSet);
            if Parser.Token <> ']' then
              while True do
              begin
                TokenStr := Parser.TokenString;
                case Parser.Token of
                  toInteger: begin end;
                  System.Classes.toString,toWString: TokenStr := '#' + IntToStr(Ord(TokenStr.Chars[0]));
                else
                  Parser.CheckToken(toSymbol);
                end;
//                Writer.WriteUTF8Str(TokenStr);
                if Parser.NextToken = ']' then Break;
                Parser.CheckToken(',');
                Parser.NextToken;
              end;
//            Writer.WriteUTF8Str('');
          end;
        '(':
          begin
            Parser.NextToken;
            FindListStart;
            while Parser.Token <> ')' do ConvertValue;
            FindListEnd;
          end;
        '{':
          FindValueBinary(Parser.HexToBinary);
        '<':
          begin
            Parser.NextToken;
            FindCollectionStart;
//            Writer.WriteValue(vaCollection);
            while Parser.Token <> '>' do
            begin
              Parser.CheckTokenSymbol('item');
              Parser.NextToken;
              Order := ConvertOrderModifier;
              if Order <> -1 then
//                Writer.WriteInteger(Order);
                ;
              FindCollectionItemBegin;
//              Writer.WriteListBegin;
              while not Parser.TokenSymbolIs('end') do ConvertProperty;
              FindCollectionItemEnd;
//              Writer.WriteListEnd;
              Parser.NextToken;
            end;
            FindCollectionEnd;
//            Writer.WriteListEnd;
          end;
      else
        Parser.Error('Invalid property value');
      end;
      Parser.NextToken;
    end;
  end;

  procedure ConvertProperty;
  var
    PropName: string;
  begin
    Parser.CheckToken(toSymbol);
    PropName := Parser.TokenString;
    Parser.NextToken;
    while Parser.Token = '.' do
    begin
      Parser.NextToken;
      Parser.CheckToken(toSymbol);
      PropName := PropName + '.' + Parser.TokenString;
      Parser.NextToken;
    end;
    FindProperty(PropName);
    Parser.CheckToken('=');
    Parser.NextToken;
    ConvertValue;
  end;

  procedure ConvertObject;
  var
    InheritedObject: Boolean;
    InlineObject: Boolean;
  begin
    InheritedObject := False;
    InlineObject := False;
    if Parser.TokenSymbolIs('INHERITED') then
      InheritedObject := True
    else if Parser.TokenSymbolIs('INLINE') then
      InlineObject := True
    else
      Parser.CheckTokenSymbol('OBJECT');
    Parser.NextToken;
    ConvertHeader(InheritedObject, InlineObject);
    while not Parser.TokenSymbolIs('END') and
      not Parser.TokenSymbolIs('OBJECT') and
      not Parser.TokenSymbolIs('INHERITED') and
      not Parser.TokenSymbolIs('INLINE') do
      ConvertProperty;
//    Writer.WriteListEnd;
    while not Parser.TokenSymbolIs('END') do ConvertObject;
//    Writer.WriteListEnd;
    Parser.NextToken;
  end;

var
  Input: TStringStream;
begin
  FFmtSettings := FormatSettings;
  FFmtSettings.DecimalSeparator := '.';

  Input := TStringStream.Create;
  Input.WriteString(AObjectText);

  Input.Position := 0;

  Parser := TParser.Create(Input, FFmtSettings);
  try
    ConvertObject;
  finally
    Parser.Free;
  end;
  Input.Free;

  FCompName := GetNameFromObjectText(AObjectText);
end;

procedure TObjectTextParser.SetPropertyValue(AProp, AValue: string);
begin
  if FIsList then
    WriteListItem(AProp, AValue)
  else if FIsCollection then
    WriteCollectionItem(AProp, AValue)
  else
    WriteProperty(AProp, AValue);
end;

procedure TObjectTextParser.WriteCollectionItem(AProp, AValue: string);
begin
end;

procedure TObjectTextParser.WriteListItem(AProp, AValue: string);
begin
end;

procedure TObjectTextParser.WriteProperty(AProp, AValue: string);
begin
  FProperties.Values[AProp] := AValue;
end;

{ TStringListHelper }

function TStringListHelper.GetValueDef(const Name: string; const Def: string): string;
begin
  Result := Values[Name];
  if Result = '' then
    Result := Def;
end;

end.
