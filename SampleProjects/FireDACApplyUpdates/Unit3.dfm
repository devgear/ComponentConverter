object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 501
  ClientWidth = 868
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 671
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 16
    Width = 641
    Height = 457
    DataSource = ds_EnvSetup
    Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object qry_EnvSetup: TFDQuery
    Active = True
    CachedUpdates = True
    Connection = DBKatasBusDB2
    UpdateObject = UpdateSQL_Record
    SQL.Strings = (
      'SELECT '#51089#50629#45380#46020', '#51312#54633#53076#46300', '#51312#54633#44396#48516', '#51312#54633#50557#52845', '#51312#54633#47749','
      '       Teacher, Audio, Video, '#50696#49345#47588#52636#50984
      'FROM Common2..C_SetUp'
      'WHERE'
      
        '   (('#51312#54633#44396#48516' = '#39'1'#39') or (('#51089#50629#45380#46020' >= '#39'12'#39') and ('#51312#54633#44396#48516' = '#39'2'#39'))) and    --' +
        '// 2012'#54617#45380#46020' '#48512#53552#45716' '#48277#51064'('#51064#51221')'#51204#49884#48376' '#51312#54633#46020' '#45208#50752#50556#54620#45796'.('#49373#49328#51077#44256' '#47700#45684#50857') 2011.07.22 PJY, HD' +
        'S, '#44608#51452#50756
      '   '#49324#50857#44396#48516' in ('#39'1'#39') and'
      '   '#51089#50629#45380#46020' >= '#39'07'#39
      'ORDER BY '#51089#50629#45380#46020', '#51312#54633#53076#46300)
    Left = 48
    Top = 328
    object qry_EnvSetupStringField: TStringField
      FieldName = #51089#50629#45380#46020
      Size = 2
    end
    object qry_EnvSetupStringField2: TStringField
      FieldName = #51312#54633#53076#46300
      Size = 2
    end
    object qry_EnvSetupStringField3: TStringField
      FieldName = #51312#54633#44396#48516
      Size = 1
    end
    object qry_EnvSetupStringField4: TStringField
      FieldName = #51312#54633#50557#52845
    end
    object qry_EnvSetupStringField5: TStringField
      FieldName = #51312#54633#47749
      Size = 40
    end
    object qry_EnvSetupTeacher: TStringField
      FieldName = 'Teacher'
      FixedChar = True
      Size = 1
    end
    object qry_EnvSetupAudio: TStringField
      FieldName = 'Audio'
      FixedChar = True
      Size = 1
    end
    object qry_EnvSetupVideo: TStringField
      FieldName = 'Video'
      FixedChar = True
      Size = 1
    end
    object qry_EnvSetupFloatField: TFloatField
      FieldName = #50696#49345#47588#52636#50984
    end
  end
  object ds_EnvSetup: TDataSource
    DataSet = qry_EnvSetup
    Left = 16
    Top = 328
  end
  object UpdateSQL_Record: TFDUpdateSQL
    Connection = DBKatasBusDB2
    InsertSQL.Strings = (
      'insert into Common2..C_SetUp'
      '  ('#51089#50629#45380#46020', '#51312#54633#53076#46300', '#51312#54633#47749', '#51312#54633#44396#48516', Teacher, Audio,'
      'Video, '#50696#49345#47588#52636#50984')'
      'values'
      '  (:'#51089#50629#45380#46020', :'#51312#54633#53076#46300', :'#51312#54633#47749', '#39'1'#39', :Teacher, :Audio,'
      ':Video, :'#50696#49345#47588#52636#50984')')
    ModifySQL.Strings = (
      'update Common2..C_SetUp'
      'set'
      '  '#51312#54633#47749' = :'#51312#54633#47749','
      '  Teacher = :Teacher,'
      '  Audio = :Audio,'
      '  Video = :Video,'
      '  '#50696#49345#47588#52636#50984' = :'#50696#49345#47588#52636#50984
      'where'
      '  '#51089#50629#45380#46020' = :OLD_'#51089#50629#45380#46020' and'
      '  '#51312#54633#53076#46300' = :OLD_'#51312#54633#53076#46300
      '')
    DeleteSQL.Strings = (
      'delete from Common2..C_SetUp'
      'where'
      '  '#51089#50629#45380#46020' = :OLD_'#51089#50629#45380#46020' and'
      '  '#51312#54633#53076#46300' = :OLD_'#51312#54633#53076#46300)
    Left = 88
    Top = 328
  end
  object DBKatasBusDB2: TFDConnection
    ConnectionName = 'DBKatasBusDB2'
    Params.Strings = (
      'Server=112.161.65.6,4452'
      'Database=BusDB2'
      'User_Name=ktbookuser'
      'Password=USER1!qoaRhfl'
      'ODBCAdvanced=MARS_Connection=YES'
      'DriverID=MSSQL')
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        SourceDataType = dtBCD
        TargetDataType = dtDouble
      end
      item
        SourceDataType = dtFmtBCD
        TargetDataType = dtDouble
      end
      item
        SourceDataType = dtDateTimeStamp
        TargetDataType = dtDateTime
      end>
    Connected = True
    LoginPrompt = False
    Left = 48
    Top = 280
  end
end
