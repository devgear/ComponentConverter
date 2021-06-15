object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 765
  ClientWidth = 1067
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RealDBGrid1: TcxGrid
    Left = 25
    Top = 59
    Width = 1098
    Height = 421
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object RealDBGrid1DBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = dsMaster
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = '<'#54364#49884#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.DataRowHeight = 52
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 41
      OptionsView.Indicator = True
      OptionsView.BandHeaders = False
      Bands = <
        item
          Caption = 'Group0'
          Width = 32
        end
        item
          Caption = 'Group1'
          Width = 160
        end
        item
          Caption = 'Group2'
          Width = 359
        end
        item
          Caption = 'Group3'
          Width = 113
        end
        item
          Caption = 'Group4'
          Width = 103
        end
        item
          Caption = 'Group6'
          Width = 140
        end
        item
          Caption = #44228#50557#44288#47144#50672#46020
          Width = 76
        end
        item
          Caption = 'Group5'
          Width = 33
        end>
      object RealDBGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = 'Company_Cod'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 32
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.LineCount = 2
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn
        Caption = #50557#52845
        DataBinding.FieldName = 'Company_Name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 160
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn
        Caption = #54924#49324#47749
        DataBinding.FieldName = 'Company_Des'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 160
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object RealDBGrid1DBBandedTableView1Column4: TcxGridDBBandedColumn
        Caption = #49324#50629#51088#46321#47197#48264#54840
        DataBinding.FieldName = 'SaNo'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 126
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column5: TcxGridDBBandedColumn
        Caption = #45824#54364#51088
        DataBinding.FieldName = 'PName'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 149
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column6: TcxGridDBBandedColumn
        Caption = #50864#54200#48264#54840
        DataBinding.FieldName = 'Post'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 84
        Position.BandIndex = 2
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = #51452'      '#49548
        DataBinding.FieldName = 'Addr'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 359
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object RealDBGrid1DBBandedTableView1Column8: TcxGridDBBandedColumn
        Caption = #50629#53468
        DataBinding.FieldName = 'UpTae'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 113
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column9: TcxGridDBBandedColumn
        Caption = #51333#47785
        DataBinding.FieldName = 'Kind'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 113
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object RealDBGrid1DBBandedTableView1Column10: TcxGridDBBandedColumn
        Caption = #51204#54868#48264#54840
        DataBinding.FieldName = 'Tel'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 103
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column11: TcxGridDBBandedColumn
        Caption = #54057#49828#48264#54840
        DataBinding.FieldName = 'Fax'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 103
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object RealDBGrid1DBBandedTableView1Column12: TcxGridDBBandedColumn
        Caption = #52636#47141
        DataBinding.FieldName = 'Prn_Chk'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        Properties.DisplayChecked = '1'
        Properties.DisplayUnchecked = '0'
        Properties.NullStyle = nssUnchecked
        Properties.ValueChecked = 1
        Properties.ValueUnchecked = 0
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 33
        Position.BandIndex = 7
        Position.ColIndex = 0
        Position.LineCount = 2
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column13: TcxGridDBBandedColumn
        DataBinding.FieldName = #51008#54665#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 61
        Position.BandIndex = 5
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column14: TcxGridDBBandedColumn
        DataBinding.FieldName = #50696#44552#51452#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 79
        Position.BandIndex = 5
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column15: TcxGridDBBandedColumn
        DataBinding.FieldName = #44228#51340#48264#54840
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 140
        Position.BandIndex = 5
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
      object RealDBGrid1DBBandedTableView1Column16: TcxGridDBBandedColumn
        DataBinding.FieldName = #44228#50557#49884#51089#45380#46020
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 76
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column17: TcxGridDBBandedColumn
        DataBinding.FieldName = #44228#50557#54644#51648#45380#46020
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 76
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 1
      end
    end
    object RealDBGrid1Level1: TcxGridLevel
      GridView = RealDBGrid1DBBandedTableView1
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
      end
      item
        SourceDataType = dtDateTimeStamp
        TargetDataType = dtDateTime
      end>
    Connected = True
    LoginPrompt = False
    Left = 328
    Top = 536
  end
  object dsMaster: TDataSource
    DataSet = qry_Master
    Left = 144
    Top = 528
  end
  object qry_Master: TFDQuery
    Active = True
    CachedUpdates = True
    Connection = DBKatasCommon2
    SQL.Strings = (
      'SELECT *, 1 Prn_Chk'
      'FROM C_Company'
      'WHERE Company_Ty_COD = '#39'1'#39
      'and '#44228#50557#54644#51648#45380#46020' >= :pYear'
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
    Top = 528
    ParamData = <
      item
        Name = 'pYear'
        DataType = ftString
        ParamType = ptInput
        Value = '2021'
      end>
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
      Size = 8
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
    object qry_MasterPrn_Chk: TIntegerField
      FieldName = 'Prn_Chk'
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
      FieldName = #44228#50557#49884#51089#45380#46020
      Size = 4
    end
    object qry_MasterStringField5: TStringField
      FieldName = #44228#50557#54644#51648#45380#46020
      Size = 4
    end
  end
end
