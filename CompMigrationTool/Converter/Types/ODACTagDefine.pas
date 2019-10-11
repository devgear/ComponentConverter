unit ODACTagDefine;

interface

const
  TAG_FDCONNECTION = '' +
    'object [[COMP_NAME]]: TFDConnection'#13#10 +
    '  Params.Strings = ('#13#10 +
    '    ''CharacterSet=[[CHARSET]]'''#13#10 +
    '    ''User_Name=[[USERNAME]]'''#13#10 +
    '    ''Password=[[PASSWORD]]'''#13#10 +
    '    ''Database=[[DATABASE]]'''#13#10 +
    '    ''DriverID=Ora'')'#13#10 +
    '  LoginPrompt = False'#13#10 +
    '  Left = [[LEFT]]'#13#10 +
    '  Top = [[TOP]]'#13#10 +
    'end'#13#10
  ;

  TAG_FDQuery = ''
  ;

implementation

end.
