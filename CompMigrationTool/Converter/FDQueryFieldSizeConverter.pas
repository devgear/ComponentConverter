unit FDQueryFieldSizeConverter;

interface

uses
  CompConverterTypes,
  ObjectTextParser,
  CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
  TConverterFDQueryFldSize = class(TConverter)
  private
    FParser: TObjectTextParser;
//    FConvData: TConvertData;
    FConnStr: string;
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    // ������Ʈ �̸� ��� �� UpdateObject�� �ش� �̸��� ������ TFDQuery ã��
    // TFDQuery�� Connection �Ӽ��� TFDUpdateSQL�� ����
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;

    function GetDescription: string; override;
  end;

  TConverterFDQueryParamSize = class(TConverter)
  private
    FParser: TObjectTextParser;
//    FConvData: TConvertData;
    FConnStr: string;
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetComponentClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    // ������Ʈ �̸� ��� �� UpdateObject�� �ش� �̸��� ������ TFDQuery ã��
    // TFDQuery�� Connection �Ӽ��� TFDUpdateSQL�� ����
    function GetConvertedCompStrs(var ACompText: TStrings): Boolean; override;

    function GetDescription: string; override;
  end;

implementation

uses
  ConvertUtils;

{ TConvertercxGrid }

function TConverterFDQueryFldSize.FindComponentInDfm(
  AData: TConvertData): Boolean;
begin
  Result := inherited;
end;

function TConverterFDQueryFldSize.GetComponentClassName: string;
begin
  Result := 'TStringField';
end;

function TConverterFDQueryFldSize.GetConvertCompClassName: string;
begin
  Result := 'TStringField';
end;

function TConverterFDQueryFldSize.GetConvertedCompStrs(var ACompText: TStrings): Boolean;
type
  TFieldSizeChage = record
    FN: string;
    FS,
    CS: Integer;
  end;
const
  ChangeTargets: array[0..14] of TFieldSizeChage = (
      (FN: '���ǻ��';              FS: 8;  CS: 16)
    , (FN: '��������';              FS: 2;  CS: 6)
    , (FN: '�����ڵ�';              FS: 5;  CS: 10)
    , (FN: '���ݰ�꼭������';      FS: 1;  CS: 8)  // BUS.TbF_4407_1P.Qry_Master
    , (FN: '�۾����� ';             FS: 4;  CS: 16) // BUS.TbF_317P.qry_Master
    , (FN: '������';                FS: 1;  CS: 8)  // BUS.TbF_4407_1P.Qry_Master
    , (FN: '��¥';                  FS: 8;  CS: 10) // BUS.TbF_503P.Qry_Master
    , (FN: '�����ڵ�';              FS: 4;  CS: 5)  // BUS.TbF_4201P.Qry_Book
    , (FN: '���ǻ�';                FS: 8;  CS: 16)
    , (FN: '�����';                FS: 20;  CS: 40)
    , (FN: '������';                FS: 20;  CS: 40)
    , (FN: '����ó';                FS: 11;  CS: 22)
    , (FN: '�۾��ڵ�';              FS: 3;  CS: 5)
    , (FN: '��ȣ';                  FS: 20;  CS: 40)
    , (FN: '����';                  FS: 10;  CS: 20)
  );

var
  I, Idx: Integer;
  S: string;
  FieldName: string;
  FieldSize: Integer;
  Info: TFieldSizeChage;
begin
  Result := False;
  FieldName := '';
  FieldSize := -1;
  for I := 1 to ACompText.Count - 1 do
  begin
    S := ACompText[I];
    if S.Contains(' FieldName = ') then
    begin
      FieldName := Copy(S, Pos(' FieldName = ', S) + Length(' FieldName = '), Length(S));
      FieldName := UnicodeStrToStr(FieldName);
    end
    else if S.Contains(' Size = ') then
    begin
      FieldSize := S.Replace('Size =', '').Trim.ToInteger;
      Idx := I;
    end;
  end;

  if (FieldName = '') or (FieldSize = -1) then
    Exit;

  for Info in ChangeTargets do
  begin
    if (Info.FN = FieldName) and (Info.FS = FieldSize)  then
    begin
      ACompText[Idx] := ' Size = ' + Info.CS.ToString;
      Exit(True);
    end;
  end;


//  for I := ACompText.CompStartIndex + 1 to AData.CompEndIndex - 2 do
//  begin
//    S := AData.SrcDfm[I];
//    if S.Contains(' FieldName = ') then
//    begin
//      Val := Copy(S, Pos(' FieldName = ', S) + Length(' FieldName = '), Length(S));
//      Val := UnicodeStrToStr(Val);
//      if Val = '���ǻ��' then
//      begin
//        HasComp := True;
//        Break;
//      end;
//    end;
//  end;


//  FParser := TObjectTextParser.Create;
//  FParser.Parse(ACompText.Text);

//  FParser.Properties

//  Result := False;
//  Output := ACompText.Text;
//
//  FParser.Free;

//  if FConnStr <> '' then
//    ACompText.Insert(1, FConnStr);
end;

function TConverterFDQueryFldSize.GetDescription: string;
begin
  Result := 'FDQuery �ʵ� ������ ������';
end;

function TConverterFDQueryFldSize.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

{ TConverterFDQueryParamSize }

function TConverterFDQueryParamSize.FindComponentInDfm(
  AData: TConvertData): Boolean;
begin
  Result := inherited;
end;

function TConverterFDQueryParamSize.GetComponentClassName: string;
begin
  Result := 'TFDQuery';
end;

function TConverterFDQueryParamSize.GetConvertCompClassName: string;
begin
  Result := 'TFDQuery';
end;

function TConverterFDQueryParamSize.GetConvertedCompStrs(
  var ACompText: TStrings): Boolean;
type
  TFieldSizeChage = record
    FN: string;
    FS,
    CS: Integer;
  end;
const
  ChangeTargets: array[0..0] of TFieldSizeChage = (
      (FN: '�۾��ڵ�';              FS: 4;  CS: 5)
  );

var
  I, Idx: Integer;
  S: string;
  InParam, InItem: Boolean;
  ParamName: string;
  ParamSize: Integer;
  Info: TFieldSizeChage;
begin
  Result := False;
  ParamName := '';
  ParamSize := -1;
  InParam := False;
  InItem := False;
  for I := 1 to ACompText.Count - 1 do
  begin
    S := ACompText[I];
    if S.Trim.Contains('ParamData = <') then
      InParam := True;

    if InParam then
    begin
      if S.Trim = 'item' then
      begin
        ParamName := '';
        ParamSize := -1;
        InItem := True;
      end;

      if InItem and S.Trim.Contains('end') then
      begin
        for Info in ChangeTargets do
        begin
          if (Info.FN = ParamName) and (Info.FS = ParamSize) then
          begin
            ACompText[Idx] := ' Size = ' + Info.CS.ToString;
          end;
        end;

        InItem := False;
      end;

      if InItem then
      begin
        if S.Contains('  Name = ') then
        begin
          ParamName := Copy(S, Pos(' Name = ', S) + Length(' Name = '), Length(S));
          ParamName := UnicodeStrToStr(ParamName);
        end
        else if S.Contains(' Size = ') then
        begin
          ParamSize := S.Replace('Size =', '').Trim.ToInteger;
          Idx := I;
        end;
      end;
    end;

    if S.Trim.Contains('end>') then
      Break;
  end;
end;

function TConverterFDQueryParamSize.GetDescription: string;
begin
  Result := 'FDQuery �Ķ� ������ ������';
end;

function TConverterFDQueryParamSize.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

initialization
  TConvertManager.Instance.Regist(TConverterFDQueryFldSize);
//  TConvertManager.Instance.Regist(TConverterFDQueryParamSize);

end.
