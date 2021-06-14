object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 549
  ClientWidth = 1003
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 256
    Top = 24
    Width = 425
    Height = 369
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object cxGrid1DBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = dsMaster
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.EditAutoHeight = eahRow
      OptionsData.DeletingConfirmation = False
      OptionsSelection.InvertSelect = False
      OptionsView.NoDataToDisplayInfoText = '<'#54364#49884#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.DataRowHeight = 100
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 50
      OptionsView.Indicator = True
      OptionsView.BandHeaders = False
      Preview.AutoHeight = False
      Bands = <
        item
          Caption = 'Group 1'
          FixedKind = fkLeft
        end
        item
          Caption = 'Group 2'
          FixedKind = fkLeft
          Width = 170
        end
        item
          Caption = 'Group 3'
          Width = 359
        end>
      object cxGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = 'Company_Cod'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        HeaderAlignmentHorz = taCenter
        Styles.Content = cxStyle1
        Styles.Header = cxStyle1
        Width = 32
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.LineCount = 2
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn
        Caption = #50557#52845
        DataBinding.FieldName = 'Company_Name'
        HeaderAlignmentHorz = taCenter
        Width = 170
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn
        Caption = #54924#49324#47749
        DataBinding.FieldName = 'Company_Des'
        HeaderAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object cxGrid1DBBandedTableView1Column4: TcxGridDBBandedColumn
        Caption = #49324#50629#51088#46321#47197#48264#54840
        DataBinding.FieldName = 'SaNo'
        HeaderAlignmentHorz = taCenter
        Width = 98
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1Column5: TcxGridDBBandedColumn
        Caption = #45824#54364#51088
        DataBinding.FieldName = 'PName'
        HeaderAlignmentHorz = taCenter
        Width = 121
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1Column6: TcxGridDBBandedColumn
        Caption = #46041#44160#49353
        DataBinding.FieldName = 'Dong'
        PropertiesClassName = 'TcxLabelProperties'
        HeaderAlignmentHorz = taCenter
        Width = 55
        Position.BandIndex = 2
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = #50864#54200#48264#54840
        DataBinding.FieldName = 'Post'
        HeaderAlignmentHorz = taCenter
        Width = 85
        Position.BandIndex = 2
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object cxGrid1DBBandedTableView1Column8: TcxGridDBBandedColumn
        Caption = #51452#49548
        DataBinding.FieldName = 'Addr'
        HeaderAlignmentHorz = taCenter
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBBandedTableView1
    end
  end
  object Memo1: TMemo
    Left = 32
    Top = 64
    Width = 185
    Height = 361
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 32
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 256
    Top = 432
    Width = 145
    Height = 21
    TabOrder = 3
    Text = 'ComboBox1'
  end
  object dsMaster: TDataSource
    DataSet = qry_Master
    Left = 176
    Top = 336
  end
  object UpdateSQL_Record: TFDUpdateSQL
    InsertSQL.Strings = (
      'insert into C_Company'
      
        '  (Company_Ty_COD, Company_COD, Company_Des, Company_Name, '#54924#44228#52636#54032#49324 +
        #47749','
      '  SaNo, PName, Post, Addr, UpTae, Kind, Tel, Fax,'
      '  '#51008#54665#47749', '#50696#44552#51452#47749', '#44228#51340#48264#54840', '#44228#50557#54644#51648#45380#46020', '#44228#50557#49884#51089#45380#46020')'
      'values'
      '  ('#39'1'#39', :Company_COD, :Company_Des, :Company_Name, :Company_Des,'
      '   :SaNo, :PName, :Post, :Addr, :UpTae, :Kind, :Tel, :Fax,'
      '   :'#51008#54665#47749', :'#50696#44552#51452#47749', :'#44228#51340#48264#54840', :'#44228#50557#54644#51648#45380#46020', :'#44228#50557#49884#51089#45380#46020')'
      '')
    ModifySQL.Strings = (
      'update C_Company'
      'set'
      '  Company_Des = :Company_Des,'
      '  Company_Name = :Company_Name,'
      '  '#54924#44228#52636#54032#49324#47749' = :Company_Des,'
      '  SaNo = :SaNo,'
      '  PName = :PName,'
      '  Post = :Post,'
      '  Addr = :Addr,'
      '  UpTae = :UpTae,'
      '  Kind = :Kind,'
      '  Tel = :Tel,'
      '  Fax = :Fax,'
      '  '#51008#54665#47749' = :'#51008#54665#47749','
      '  '#50696#44552#51452#47749' = :'#50696#44552#51452#47749','
      '  '#44228#51340#48264#54840' = :'#44228#51340#48264#54840','
      '  '#44228#50557#54644#51648#45380#46020' = :'#44228#50557#54644#51648#45380#46020','
      '  '#44228#50557#49884#51089#45380#46020' = :'#44228#50557#49884#51089#45380#46020
      'where'
      '  Company_Ty_Cod = :OLD_Company_Ty_Cod and'
      '  Company_Cod = :OLD_Company_Cod')
    DeleteSQL.Strings = (
      'delete from C_Company'
      'where'
      '  Company_Ty_Cod = :OLD_Company_Ty_Cod and'
      '  Company_Cod = :OLD_Company_Cod')
    Left = 176
    Top = 280
  end
  object qry_Master: TFDQuery
    Active = True
    CachedUpdates = True
    Connection = DBKatasCommon2
    UpdateObject = UpdateSQL_Record
    SQL.Strings = (
      'SELECT *, '#39'                    '#39' Dong'
      'FROM C_Company'
      'WHERE Company_Ty_COD = '#39'1'#39
      'ORDER BY Company_Ty_COD, Company_COD'
      ''
      ''
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    Left = 176
    Top = 232
    object qry_MasterCompany_Ty_Cod: TStringField
      FieldName = 'Company_Ty_Cod'
      FixedChar = True
      Size = 1
    end
    object qry_MasterCompany_Cod: TStringField
      FieldName = 'Company_Cod'
      FixedChar = True
      Size = 3
    end
    object qry_MasterCompany_Des: TStringField
      FieldName = 'Company_Des'
      Size = 50
    end
    object qry_MasterCompany_Name: TStringField
      FieldName = 'Company_Name'
    end
    object qry_MasterSaNo: TStringField
      FieldName = 'SaNo'
      Size = 12
    end
    object qry_MasterPName: TStringField
      FieldName = 'PName'
    end
    object qry_MasterPost: TStringField
      FieldName = 'Post'
      Size = 7
    end
    object qry_MasterAddr: TStringField
      FieldName = 'Addr'
      Size = 80
    end
    object qry_MasterUpTae: TStringField
      FieldName = 'UpTae'
    end
    object qry_MasterKind: TStringField
      FieldName = 'Kind'
    end
    object qry_MasterTel: TStringField
      FieldName = 'Tel'
      Size = 14
    end
    object qry_MasterFax: TStringField
      FieldName = 'Fax'
      Size = 14
    end
    object qry_MasterMun_Plc: TStringField
      FieldName = 'Mun_Plc'
      Size = 80
    end
    object qry_MasterList_YN: TStringField
      FieldName = 'List_YN'
      FixedChar = True
      Size = 1
    end
    object qry_MasterFilm_Tel: TStringField
      FieldName = 'Film_Tel'
      Size = 14
    end
    object qry_MasterFilm_Fax: TStringField
      FieldName = 'Film_Fax'
      Size = 14
    end
    object qry_MasterDong: TStringField
      FieldName = 'Dong'
    end
    object qry_MasterStringField: TStringField
      FieldName = #44228#51340#48264#54840
    end
    object qry_MasterStringField2: TStringField
      FieldName = #51008#54665#47749
    end
    object qry_MasterStringField3: TStringField
      FieldName = #50696#44552#51452#47749
    end
    object qry_MasterStringField4: TStringField
      FieldName = #44228#50557#54644#51648#45380#46020
      Size = 4
    end
    object qry_MasterStringField5: TStringField
      FieldName = #44228#50557#49884#51089#45380#46020
      Size = 4
    end
  end
  object DBKatasCommon2: TFDConnection
    ConnectionName = 'DBKatasCommon2'
    Params.Strings = (
      'Server=112.161.65.6,4452'
      'Database=Common2'
      'User_Name=ktbookuser'
      'Password=USER1!qoaRhfl'
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
      end>
    Connected = True
    LoginPrompt = False
    Left = 176
    Top = 168
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 104
    Top = 472
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 8454143
    end
  end
  object FDQuery1: TFDQuery
    Connection = DBKatasCommon2
    Left = 464
    Top = 280
  end
  object xlReport1: TxlReport
    DataExportMode = xdmDDE
    Options = [xroDisplayAlerts, xroAutoOpen]
    DataSources = <
      item
        DataSet = kbmMemT
        Alias = 'kbmMemT'
        Options = [xrgoAutoOpen, xrgoPreserveRowHeight]
        Tag = 0
      end>
    Preview = False
    Params = <
      item
      end>
    Left = 768
    Top = 280
  end
  object kbmMemT: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 880
    Top = 280
    object kbmMemTL: TStringField
      FieldName = 'L'#51452#49548
      Size = 80
    end
    object kbmMemTL2: TStringField
      DisplayWidth = 50
      FieldName = 'L'#51060#47492
      Size = 50
    end
    object kbmMemTL3: TStringField
      FieldName = 'L'#50864#54200#48264#54840
      Size = 7
    end
    object kbmMemTR: TStringField
      DisplayWidth = 80
      FieldName = 'R'#51452#49548
      Size = 80
    end
    object kbmMemTR2: TStringField
      FieldName = 'R'#51060#47492
      Size = 50
    end
    object kbmMemTR3: TStringField
      FieldName = 'R'#50864#54200#48264#54840
      Size = 7
    end
  end
end
