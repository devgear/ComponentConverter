{*******************************************************}
{                                                       }
{           컴포넌트 복사 라이브러리                    }
{                                                       }
{ 2016.12 - Humphrey Kim(Devgear)                       }
{                                                       }
{*******************************************************}
unit ConvertUtils;

interface

uses
  System.TypInfo,
  System.SysUtils, System.Types, System.Classes, Vcl.Clipbrd,
  System.Rtti,
  System.StrUtils;


type
  TUsesIndex = record
    InterfaceUsesStartIndex,        // interface uses 절 시작
    InterfaceUsesEndIndex,
    ImplimentationIndex,            // implimentation 시작
    ImplimentationUsesStartIndex,   // implimentation uses 절 시작
    ImplimentationUsesEndIndex: Integer;
  end;

  TTargetComp = record
    FN,
    CN: string;
  end;

/// <summary>들여쓰기 추가(맨 앞줄에 공백을 ACount 만큼 추가)</summary>
procedure WriteIndent(var AList: TStringList; ACount: Integer);
/// <summary>오브젝트 텍스트(DFM 문자열)인 AParent에 AChild 추가(마지막 end 이전 줄에)</summary>
/// <code>
///  object Parent: TPanel
///    Left = 100
///    object Child: TLabel
///     Caption = 'text'
///    end;
///  end;</code>
procedure InsertChildCompText(AParent, AChild: TStringList);

/// <summary>오브젝트 문자열(object ObjName: DataType)에서 이름(ObjName) 반환</summary>
function GetNameFromObjectText(AText: string): string;

/// <summary>유니코드 문자열을 문자열로 전환</summary>
  // '#44256#44061#44396#48516' => '고객전환'
function UnicodeStrToStr(AUnicode: string): string;

/// <summary>소스코드에서 uses 절 인덱스 탐색</summary>
/// <param name="ASourceCode">소스코드</param>
/// <param name="UsesIdx">uses 절 구조체(Interface, Implimentation)</param>
procedure SearchUsesIndex(ASourceCode: TStringList; var UsesIdx: TUsesIndex);

function GetCompStartIndex(ADfmFile: TStrings; AStartIdx: Integer; ACompClassName: string): Integer;
function GetCompStartIndexFromCompNamee(ADfmFile: TStrings; AStartIdx: Integer; ACompName: string): Integer;
function GetCompEndIndex(ADfmFile: TStrings; AStartIdx: Integer): Integer;
function GetPropValueFromPropText(APropText: string; var Prop, Value: string): Boolean;

// 한라인의 uses구문(AUsesText)에서 유닛네임을 제거한다.(쉼표, 주석에 주의)
function RemoveUses(AUsesText: string; AUnitName: string): string;
function IsIncludeUnitNameInUses(AUnitName: string; AUsesLine: string): Boolean;

function GetFormNameFromDfmText(ADfmFirstLineText: string): string;

function IsEqualsCompCode(ACompName, ACompType, ACode: string): Boolean;

function InArray(AArray: TArray<string>; AValue: string): Boolean;

implementation

procedure WriteIndent(var AList: TStringList; ACount: Integer);
var
  I: Integer;
  Indent: string;
begin
  Indent := '';
  for I := 0 to ACount - 1 do
    Indent := Indent + ' ';
  for I := 0 to AList.Count - 1 do
    AList[I] := Indent + ALIst[I];
end;

procedure InsertChildCompText(AParent, AChild: TStringList);
begin
  WriteIndent(AChild, 2);
//    AParent.Insert(AParent.Count - 1, AChild.Text);
  AParent.Delete(AParent.Count - 1);
  AParent.AddStrings(AChild);
  AParent.Add('end' + sLineBreak);
end;

//procedure RemoveParentName(var ACompStrings: TStringList);
//var
//  I: Integer;
//  Value: string;
//begin
//  for I := 0 to ACompStrings.Count - 1 do
//  begin
//    Value := ACompStrings.ValueFromIndex[I];
//    if Value.Contains('.') and (not Value.Trim.StartsWith('''')) then
//    begin
//      Value := ' ' + Copy(Value, Pos('.', Value)+1, Length(Value));
//      ACompStrings.ValueFromIndex[I] := Value
//    end;
//  end;
//end;

//procedure ComponentToStringList(AComponent: TComponent; AStringList: TStringList; const ARemoveParentName: Boolean);
//begin
//  AStringList.Text := ComponentToText(AComponent);
//  if ARemoveParentName then
//    RemoveParentName(AStringList);
//end;
//
//function ComponentToText(AComponent: TComponent): string;
//var
//  LStrStream: TStringStream;
//  LMemStream: TMemoryStream;
//begin
//  if AComponent = nil then
//    Exit('');
//
//  LStrStream := nil;
//  LMemStream := nil;
//
//  try
//    LMemStream := TMemoryStream.Create();
//    LStrStream := TStringStream.Create();
//    // Stream the component
//    LMemStream.WriteComponent(AComponent);
//    LMemStream.Position := 0;
//    // Convert to text
//    ObjectBinaryToText(LMemStream, LStrStream);
//    LStrStream.Position := 0;
//    // Output the text
//    Result := LStrStream.ReadString(LStrStream.Size);
//  finally
//    LStrStream.Free;
//    LMemStream.Free;
//  end;
//end;

{
컴포넌트 정보 첫줄에서 컴포넌트 이름을 추출해 반환
object qry_Master: TFDQuery
inherited PnlSkinSetting: TPanel
}
function GetNameFromObjectText(AText: string): string;
begin
  Result := AText.Trim;
  Result := Copy(Result, Pos(' ', Result)+1, Length(Result));
  Result := Copy(Result, 1, Pos(':', Result)-1);
end;

function UnicodeStrToStr(AUnicode: string): string;
var
  I, Len, W, Count: Integer;
  C: Char;
  WideChars: TCharArray;

  IsTokenStart: Boolean;
  IsUnicode: Boolean;

  procedure SetChar(AChar: WideChar);
  begin
    WideChars[Count] := AChar;
    Inc(Count);
  end;
begin
// Samples
//  s := '#44256#44061#44396#48516';                        // 고객구분
//  s := '#54788#44552'' ''#51077''/''#52636#44552';        // 현금 입/출금
//  s := '#54788#44552'' ''#51077''/''#52636#44552''/''';   // 현금 입/출금/

// "#"로 시작하는 숫자는 유니코드
// "''" 사이의 문자는 일반문자
  Len := AUnicode.CountChar('#');
  if Len = 0 then
    Exit(AUnicode);

  /////////////////////////////////////////////
  // 길이 계산
  Len := 0;
  IsTokenStart := False;
  IsUnicode := False;
  for I := Low(AUnicode) to High(AUnicode) do
  begin
    C := AUnicode[I];
    case C of
    '#':
      begin
        Inc(Len);
      end;
    '''':
      begin
        IsTokenStart := not IsTokenStart;
      end;
    else
      begin
        if IsTokenStart then // 일반문자
          Inc(Len)
        else                 // 유니코드
        ;
      end;
    end;
  end;
  SetLength(WideChars, Len);

  /////////////////////////////////////////////
  // 유니코드와 문자 구분
  W := 0;
  Count := 0;
  for I := Low(AUnicode) to High(AUnicode) do
  begin
    C := AUnicode[I];
    case C of
    '#':
      begin
        if IsUnicode then
          SetChar(WideChar(SmallInt(W)));
        IsUnicode := True;
        W := 0;
        if I = Low(AUnicode) then
          Continue;
      end;
    '''':
      begin
        if (not IsTokenStart) and IsUnicode then
          SetChar(WideChar(SmallInt(W)));

        IsTokenStart := not IsTokenStart;
        IsUnicode := False;
      end;
    else
      begin
        if IsTokenStart then // 일반문자
          SetChar(C)
        else                 // 유니코드
          W := W * 10 + (Ord(C) - Ord('0'));
        ;
      end;
    end;
  end;
  if IsUnicode then
    SetChar(WideChar(SmallInt(W)));

  Result := string.Create(WideChars);
end;

//function SetProperty(AComp: TComponent; APropName, APropValue: string; out AllowType: Boolean): Boolean;
//
//  // AValue 값의 데이터타입으로 APropValue를 설정해 TValue 반환
//  function GetTValue(AValue: TValue; APropValue: string): TValue;
//  var
//    IdentToInt: TIdentToInt;
//    Int: Integer;
//  begin
//    Result := TValue.Empty;
//
//    case AValue.Kind of
//      tkString, tkLString, tkWString:
//        Result := TValue.From<string>(APropValue);
//      tkUString:
//        Result := TValue.From<string>(UnicodeStrToStr(APropValue));
//      tkInteger, tkInt64:
//        begin
//          IdentToInt := FindIdentToInt(AValue.TypeInfo);
//          if Assigned(IdentToInt) then
//            IdentToInt(APropValue, Int)
//          else
//            Int := StrToIntDef(APropValue, 0);
//          Result := TValue.From<Integer>(Int);
////
////          if AValue.TypeInfo.Name = 'TColor' then
////            Result := TValue.From<TColor>(StringToColor(APropValue))
////          else if AValue.TypeInfo.Name = 'TCursor' then
////            Result := TValue.From<TCursor>(StringToCursor(APropValue))
////          else if AValue.TypeInfo.Name = 'TFontCharset' then
////          begin
////            if IdentToCharset(APropValue, Int) then
////              Result := TValue.From<Integer>(Int);
////          end
////          else
////            Result := TValue.From<Integer>(APropValue.ToString);
//        end;
//      tkEnumeration:
//        Result := TValue.FromOrdinal(AValue.TypeInfo, GetEnumValue(AValue.TypeInfo, APropValue));
//      tkSet:
//        begin
//          Int := StringToSet(AValue.TypeInfo, APropValue);
//          TValue.Make(@Int, AValue.TypeInfo, Result);
//        end;
//
//      tkUnknown: ;
//      tkChar: ;
//      tkFloat: ;
//      tkClass: ;
//      tkMethod: ;
//      tkWChar: ;
//      tkVariant: ;
//      tkArray: ;
//      tkRecord: ;
//      tkInterface: ;
//      tkDynArray: ;
//      tkClassRef: ;
//      tkPointer: ;
//      tkProcedure: ;
//    end;
//  end;
//
//  procedure GetPropertyFromPropertiesText(
//          Context: TRttiContext;
//          PropName: string;
//          var PropObj: TObject;        // 속성을 적용할 객체
//          var Prop: TRttiProperty
//      );
//  var
//    I: Integer;
//    Properties: TArray<string>;
//    TypeInfo: PTypeInfo;
//  begin
//    Properties := PropName.Split(['.']);
//    TypeInfo := PropObj.ClassInfo;
//    for I := Low(Properties) to High(Properties) do
//    begin
//      if I > Low(Properties) then
//        PropObj := Prop.GetValue(PropObj).AsObject;
//      Prop := Context.GetType(TypeInfo).GetProperty(Properties[I]);
//      if not Assigned(Prop) then
//        Exit;
//      TypeInfo := Prop.PropertyType.Handle;
//    end;
//  end;
//
//var
//  CompObj: TObject;
//  Context: TRttiContext;
//  Prop: TRttiProperty;
//  Value, NewValue: TValue;
//begin
//  Result := False;
//  AllowType := True;
//
//  Context := TRttiContext.Create;
//  CompObj := TObject(AComp);
//  GetPropertyFromPropertiesText(
//    Context,
//    APropName,
//    CompObj,            // var
//    Prop                // var
//  );
//
//  // 컴포넌트에 해당 속성 없음
//  if not Assigned(Prop) then
//    Exit;
//
//  // [예외] TabOrder를 큰수로 맞춰도 컴포넌트 갯수가 적으면 적용되지 않음
//  if APropName = 'TabOrder' then
//  begin
//    AllowType := False;
//    Exit;
//  end;
//
//  Value := Prop.GetValue(CompObj);
//
//  // [예외] 메소드(이벤트 핸들러)와 클래스(인스턴스)는 구현되지 않아 속성 적용 불가
//  AllowType := not (Value.Kind in [tkMethod, tkClass]);
//  if not AllowType then
//    Exit;
//
//  NewValue := GetTValue(Value, APropValue);
//  if NewValue.IsEmpty then
//    Exit;
//
//  Prop.SetValue(CompObj, NewValue);
//  Result := True;
//end;

function RemoveUses(AUsesText: string; AUnitName: string): string;
var
  Str, Text, CommentInStr, DblComment, BracketComment, Indent: string;
  HasUsesText, HasDblComment, HasSemiColon, BeforeMatched: Boolean;
  I, Idx: Integer;
  Strs: TArray<string>;
begin
  Result := '';
  Indent := '';
  if not AUsesText.Contains(AUnitName) then
    Exit(AUsesText);

  for I := Low(AUsesText) to High(AUsesText) do
    if AUsesText[I] = ' ' then
      Indent := Indent + ' '
    else
      Break;
  if Length(Indent) > 0 then
    AUsesText := AUsesText.Substring(Length(Indent));


  // uses 체크
  HasUsesText := AUsesText.StartsWith('uses');
  if HasUsesText then
    AUsesText := AUsesText.SubString(Length('uses '));

  // 세미콜론체크
  HasSemiColon := AUsesText.Contains(';');
  if HasSemiColon then
    AUsesText := AusesText.Replace(';', '');

  // 주석 체크
  HasDblComment := AUsesText.Contains('//');
  if HasDblComment then
  begin
    if AUsesText.TrimLeft.StartsWith('//') then
      Exit(Indent + AUsesText);

    Idx := AUsesText.IndexOf('//');
    DblComment := Copy(AUsesText, Idx+1, Length(AUsesText));
    AUsesText := Copy(AUsesText, 1, Idx);
  end;

  Strs := AUsesText.Split([',']);

  BeforeMatched := False;
  for Text in Strs do
  begin
    Str := Text.Trim;
    if Str.Contains(AUnitName) then
    begin
      if Str.Contains('{') then
      begin
        CommentInStr := Copy(Str, Str.IndexOf('{')+1, Length(Str));
        Str := Copy(Str, 1, Str.IndexOf('{'));
        if CommentInStr.Contains('}') then
        begin
          CommentInStr := Copy(CommentInStr, 1, CommentInStr.IndexOf('}')+1);
          Str := Str + Copy(Text, Text.IndexOf('}')+2, Length(Text));
          Result := Result + CommentInStr;
        end
        else
        begin
          Result := Result + CommentInStr + ',';
        end;
      end
      else if Str.Contains('}') then
      begin
        CommentInStr := Copy(Str, 1, Str.IndexOf('}')+1);
        Str := Copy(Text, Text.IndexOf('}') + 2, Length(Text));
        Result := Result + CommentInStr;
      end;
    end;

    if Str.Trim = AUnitName then
    begin
      BeforeMatched := True;
      Result := Result + Str.Substring(0, Str.IndexOf(Str.Trim));
      Continue;
    end;

    // 'TEST, ABC'에서 TEST 치환 시 ABC앞의 공백도 제거(바로 앞에서 매치된 경우 공백 제거)
    if BeforeMatched and (Str.Length > 0) and (Str[1] = ' ') then
      Str := Str.Substring(1);
    Result := Result + IfThen(Result = '', Str, ',' + Str);
    BeforeMatched := False;
  end;

  if HasUsesText then
    Result := 'uses' + IfThen(Result.Length > 0, ' ' + Result, '');
  if HasDblComment then
    Result := Result + DblComment;

  Result := Indent + Result;
  if HasSemiColon then
    Result := Result + ';';
end;

function IsIncludeUnitNameInUses(AUnitName: string; AUsesLine: string): Boolean;
var
  I: Integer;
  Strs: TArray<string>;
begin
  Strs := AUsesLine.Trim.Replace(';', '').Split([',']);

  Result := False;
  for I := 0 to Length(Strs) - 1 do
    if Strs[I].Trim.Equals(AUnitName) then
      Exit(True);
end;

//     RealGrid1: TRealGrid;
//     REAlGrid3: TRealGrid;
// 고려되지 않음
  //     REAlGrid3 : TRealGrid ;
function IsEqualsCompCode(ACompName, ACompType, ACode: string): Boolean;
var
  Code: string;
begin
  Code := ACompName + ': ' + ACompType + ';';
  Result := (ACode.Trim.ToLower = Code.ToLower);
end;

procedure SearchUsesIndex(ASourceCode: TStringList; var UsesIdx: TUsesIndex);
var
  I: Integer;
  Text: string;
begin
  UsesIdx.InterfaceUsesStartIndex := -1;
  UsesIdx.InterfaceUsesEndIndex := -1;
  UsesIdx.ImplimentationIndex := -1;
  UsesIdx.ImplimentationUsesStartIndex := -1;
  UsesIdx.ImplimentationUsesEndIndex := -1;

  // '//' 주석 처리 완료
  // '{ xxxxxx }' 처리 구현안됨
  for I := 0 to ASourceCode.Count - 1 do
  begin
    Text := ASourceCode[I];

    if UsesIdx.InterfaceUsesStartIndex = -1 then
    begin
      if Text.Trim.ToLower.StartsWith('uses') then
        UsesIdx.InterfaceUsesStartIndex := I;
    end
    else if UsesIdx.InterfaceUsesEndIndex = -1 then
    begin
      if (not Text.TrimLeft.StartsWith('//')) and (Text.Contains(';')) then
        UsesIdx.InterfaceUsesEndIndex := I;
    end
    else if UsesIdx.ImplimentationIndex = -1 then
    begin
      if Text.Trim.ToLower.StartsWith('implementation') then
        UsesIdx.ImplimentationIndex := I;
    end
    else if UsesIdx.ImplimentationUsesStartIndex = -1 then
    begin
      if Text.Trim.ToLower.StartsWith('uses') then
        UsesIdx.ImplimentationUsesStartIndex := I;
    end
    else if UsesIdx.ImplimentationUsesEndIndex = -1 then
    begin
      if (not Text.TrimLeft.StartsWith('//')) and (Text.IndexOf(';') > 0) then
        UsesIdx.ImplimentationUsesEndIndex := I;
    end
    else if Text.ToLower.Contains('procedure') or Text.ToLower.Contains('function') then
      Break;
  end;
end;

{
  컴포넌트 클래스명으로 찾기
}
function GetCompStartIndex(ADfmFile: TStrings; AStartIdx: Integer; ACompClassName: string): Integer;
var
  I: Integer;
  S: string;
begin
  Result := -1;
  ADfmFile.BeginUpdate;
  for I := AStartIdx to ADfmFile.Count - 1 do
  begin
    S := ADfmFile[I];
    if S.EndsWith(ACompClassName) or (S.Contains(' ' + ACompClassName + ' ')) then
      Exit(I);
  end;
  ADfmFile.EndUpdate;
end;

{
  컴포넌트 이름으로 찾기
  inherited PnlSkinSetting: TPanel    // ACompName : PnlSkinSetting
}
function GetCompStartIndexFromCompNamee(ADfmFile: TStrings; AStartIdx: Integer; ACompName: string): Integer;
var
  I: Integer;
  S: string;
begin
  Result := -1;
  ADfmFile.BeginUpdate;
  for I := AStartIdx to ADfmFile.Count - 1 do
  begin
    S := ADfmFile[I];
    if S.Contains(' ' + ACompName + ':') then
      Exit(I);
  end;
  ADfmFile.EndUpdate;
end;

function GetCompEndIndex(ADfmFile: TStrings; AStartIdx: Integer): Integer;
var
  I: Integer;
  S: string;
  Level: Integer;
begin
  Result := -1;
  ADfmFile.BeginUpdate;
  Level := 0;
  for I := AStartIdx to ADfmFile.Count-1 do
  begin
    S := ADfmFile[I];
    if (S.TrimLeft.StartsWith('object ')) or (S.Trim = 'item') or (S.TrimLeft.StartsWith('inherited')) then
      Inc(Level);
    if S.Trim.StartsWith('end') then
    begin
      if Level = 0 then
        Exit(I);
      Dec(Level);
    end;
  end;
  ADfmFile.EndUpdate;
end;

function GetPropValueFromPropText(APropText: string; var Prop, Value: string): Boolean;
var
  Strs: TArray<string>;
begin
  Result := False;
  Strs := APropText.Split(['=']);
  if Length(Strs) = 2 then
  begin
    Prop := Trim(Strs[0]);
    Value := Trim(Strs[1]);
    Result := True;
  end;
end;

//procedure AddOrSetPropertyText(AProperties: TStringList; APropName, APropValue: string);
//var
//  I: Integer;
////  Exists: Boolean;
//  Key, Value: string;
//begin
//  for I := 0 to AProperties.Count - 1 do
//  begin
//    Key := AProperties.KeyNames[I].Trim;
//    Value := AProperties.ValueFromIndex[I].Trim;
//
//    if Key = APropName then
//    begin
//      AProperties.ValueFromIndex[I] := ' ' + APropValue;
//      Exit;
//    end;
//  end;
//
//  AProperties.Insert(AProperties.Count - 1, Format('  %s = %s', [APropName, APropValue]));
//end;
//
//procedure AddProperties(AProperties, AAppendProp: TStringList);
//var
//  endstr: string;
//begin
//  endstr := AProperties[AProperties.Count - 1];
//  AProperties.Delete(AProperties.Count - 1);
//  AProperties.AddStrings(AAppendProp);
//  AProperties.Add(endstr);
//end;

function GetFormNameFromDfmText(ADfmFirstLineText: string): string;
begin
  // ADfmFirstLineText
  // eg. object CHART00FROM: TCHART00FROM
  // eg. inherited PS00002RForm: TPS00002RForm
  Result := Copy(ADfmFirstLineText,
              ADfmFirstLineText.IndexOf(':') + 2,
              ADfmFirstLineText.Length).Trim;
end;

function InArray(AArray: TArray<string>; AValue: string): Boolean;
var
  Item: string;
begin
  Result := False;
  for Item in AArray do
  begin
    if Item.ToLower = AValue.ToLower then
      Exit(True);
  end;

end;

end.

