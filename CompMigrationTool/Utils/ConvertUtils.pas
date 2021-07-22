{*******************************************************}
{                                                       }
{           ������Ʈ ���� ���̺귯��                    }
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
    InterfaceUsesStartIndex,        // interface uses �� ����
    InterfaceUsesEndIndex,
    ImplimentationIndex,            // implimentation ����
    ImplimentationUsesStartIndex,   // implimentation uses �� ����
    ImplimentationUsesEndIndex: Integer;
  end;

  TTargetComp = record
    FN,
    CN: string;
  end;

/// <summary>�鿩���� �߰�(�� ���ٿ� ������ ACount ��ŭ �߰�)</summary>
procedure WriteIndent(var AList: TStringList; ACount: Integer);
/// <summary>������Ʈ �ؽ�Ʈ(DFM ���ڿ�)�� AParent�� AChild �߰�(������ end ���� �ٿ�)</summary>
/// <code>
///  object Parent: TPanel
///    Left = 100
///    object Child: TLabel
///     Caption = 'text'
///    end;
///  end;</code>
procedure InsertChildCompText(AParent, AChild: TStringList);

/// <summary>������Ʈ ���ڿ�(object ObjName: DataType)���� �̸�(ObjName) ��ȯ</summary>
function GetNameFromObjectText(AText: string): string;

/// <summary>�����ڵ� ���ڿ��� ���ڿ��� ��ȯ</summary>
  // '#44256#44061#44396#48516' => '����ȯ'
function UnicodeStrToStr(AUnicode: string): string;

/// <summary>�ҽ��ڵ忡�� uses �� �ε��� Ž��</summary>
/// <param name="ASourceCode">�ҽ��ڵ�</param>
/// <param name="UsesIdx">uses �� ����ü(Interface, Implimentation)</param>
procedure SearchUsesIndex(ASourceCode: TStringList; var UsesIdx: TUsesIndex);

function GetCompStartIndex(ADfmFile: TStrings; AStartIdx: Integer; ACompClassName: string): Integer;
function GetCompStartIndexFromCompNamee(ADfmFile: TStrings; AStartIdx: Integer; ACompName: string): Integer;
function GetCompEndIndex(ADfmFile: TStrings; AStartIdx: Integer): Integer;
function GetPropValueFromPropText(APropText: string; var Prop, Value: string): Boolean;

// �Ѷ����� uses����(AUsesText)���� ���ֳ����� �����Ѵ�.(��ǥ, �ּ��� ����)
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
������Ʈ ���� ù�ٿ��� ������Ʈ �̸��� ������ ��ȯ
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
//  s := '#44256#44061#44396#48516';                        // ������
//  s := '#54788#44552'' ''#51077''/''#52636#44552';        // ���� ��/���
//  s := '#54788#44552'' ''#51077''/''#52636#44552''/''';   // ���� ��/���/

// "#"�� �����ϴ� ���ڴ� �����ڵ�
// "''" ������ ���ڴ� �Ϲݹ���
  Len := AUnicode.CountChar('#');
  if Len = 0 then
    Exit(AUnicode);

  /////////////////////////////////////////////
  // ���� ���
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
        if IsTokenStart then // �Ϲݹ���
          Inc(Len)
        else                 // �����ڵ�
        ;
      end;
    end;
  end;
  SetLength(WideChars, Len);

  /////////////////////////////////////////////
  // �����ڵ�� ���� ����
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
        if IsTokenStart then // �Ϲݹ���
          SetChar(C)
        else                 // �����ڵ�
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
//  // AValue ���� ������Ÿ������ APropValue�� ������ TValue ��ȯ
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
//          var PropObj: TObject;        // �Ӽ��� ������ ��ü
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
//  // ������Ʈ�� �ش� �Ӽ� ����
//  if not Assigned(Prop) then
//    Exit;
//
//  // [����] TabOrder�� ū���� ���絵 ������Ʈ ������ ������ ������� ����
//  if APropName = 'TabOrder' then
//  begin
//    AllowType := False;
//    Exit;
//  end;
//
//  Value := Prop.GetValue(CompObj);
//
//  // [����] �޼ҵ�(�̺�Ʈ �ڵ鷯)�� Ŭ����(�ν��Ͻ�)�� �������� �ʾ� �Ӽ� ���� �Ұ�
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


  // uses üũ
  HasUsesText := AUsesText.StartsWith('uses');
  if HasUsesText then
    AUsesText := AUsesText.SubString(Length('uses '));

  // �����ݷ�üũ
  HasSemiColon := AUsesText.Contains(';');
  if HasSemiColon then
    AUsesText := AusesText.Replace(';', '');

  // �ּ� üũ
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

    // 'TEST, ABC'���� TEST ġȯ �� ABC���� ���鵵 ����(�ٷ� �տ��� ��ġ�� ��� ���� ����)
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
// ������� ����
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

  // '//' �ּ� ó�� �Ϸ�
  // '{ xxxxxx }' ó�� �����ȵ�
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
  ������Ʈ Ŭ���������� ã��
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
  ������Ʈ �̸����� ã��
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

