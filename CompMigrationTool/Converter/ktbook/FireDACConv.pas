unit FireDACConv;

interface

uses
  CompConverterTypes, CompConverter, System.SysUtils, System.Classes, Vcl.Forms;

type
{
  FieldDefs 제거
  StoreDefs = True 설정(IndexDef 사용을 위해 필요)
}
  TConverterFDQryDirectExecute = class(TConverter)
  protected
    function GetDescription: string; override;

    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;
    function GetRemoveUses: TArray<string>; override;
    function GetAddedUses: TArray<string>; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;
  end;

  // TFDQutoIncField의 AutoIncrementSeed = 1 처리
  TConverterFDAutoIncSeed = class(TConverter)
  protected
    function FindComponentInDfm(AData: TConvertData): Boolean; override;

    function GetTargetCompClassName: string; override;
    function GetConvertCompClassName: string; override;

    function GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean; override;

    function GetDescription: string; override;
  end;


implementation

{ TConverterRealGridToCXGrid }

function TConverterFDQryDirectExecute.FindComponentInDfm(AData: TConvertData): Boolean;
var
  I: Integer;
  S: string;
begin
  Result := inherited;

  if Result then
  begin
    for I := AData.CompStartIndex to AData.CompEndIndex - 1 do
    begin
      S := AData.SrcDfm[I];
      if S.Contains('ResourceOptions.DirectExecute = True') then
        Exit(False)
    end;
  end;
end;

function TConverterFDQryDirectExecute.GetAddedUses: TArray<string>;
begin
  Result := [];
end;

function TConverterFDQryDirectExecute.GetTargetCompClassName: string;
begin
  Result := 'TFDQuery';
end;

function TConverterFDQryDirectExecute.GetConvertCompClassName: string;
begin
  Result := 'TFDQuery';
end;

function TConverterFDQryDirectExecute.GetConvertedCompText(ACompText: TStrings; var Output: string): Boolean;
begin
  ACompText.Insert(1, '    ResourceOptions.AssignedValues = [rvDirectExecute]'#13#10'    ResourceOptions.DirectExecute = True');

  Result := True;
  Output := ACompText.Text;
end;

function TConverterFDQryDirectExecute.GetDescription: string;
begin
  Result := 'TFDQuery ResourceOptions.DirectExecute = True';
end;

function TConverterFDQryDirectExecute.GetRemoveUses: TArray<string>;
begin
  Result := [];
end;

{ TConverterFDAutoIncSeed }

function TConverterFDAutoIncSeed.FindComponentInDfm(
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
      if S.Trim = 'AutoIncrementSeed = 1' then
      begin
        Result := False;
        Break;
      end;
    end;

    if Result then
      Exit;
  end;
end;

function TConverterFDAutoIncSeed.GetTargetCompClassName: string;
begin
  Result := 'TFDAutoIncField';
end;

function TConverterFDAutoIncSeed.GetConvertCompClassName: string;
begin
  Result := 'TFDAutoIncField';
end;

function TConverterFDAutoIncSeed.GetConvertedCompText(ACompText: TStrings;
  var Output: string): Boolean;
begin
  ACompText.Insert(1, '  AutoIncrementSeed = 1'#13#10'  AutoIncrementStep = 1');
  Result := True;
  Output := ACompText.Text;
end;

function TConverterFDAutoIncSeed.GetDescription: string;
begin
  Result := 'TFDAutoIncField.Seed 재설절';
end;

//initialization
//  TConvertManager.Instance.Regist(TConverterFDQryDirectExecute);
//  TConvertManager.Instance.Regist(TConverterFDAutoIncSeed);

end.

