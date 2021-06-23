object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 450
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 586
    Top = 8
    Width = 185
    Height = 434
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object RealDBGrid1: TcxGrid
    Left = 177
    Top = 73
    Width = 376
    Height = 256
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object RealDBGrid1DBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = '<'#54364#49884#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.DataRowHeight = 25
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 21
      OptionsView.Indicator = True
      OptionsView.BandHeaders = False
      Bands = <
        item
          Caption = 'Fixed band'
        end
        item
          Caption = 'Normal band'
          Visible = False
        end>
      object RealDBGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = #44144#47000#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 37
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn
        Caption = #44277#44553#51064
        DataBinding.FieldName = #44144#47000#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 140
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn
        DataBinding.FieldName = #44148#49688
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 40
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object RealDBGrid1Level1: TcxGridLevel
      GridView = RealDBGrid1DBBandedTableView1
    end
  end
  object QryBusDB1: TFDQuery
    AfterScroll = QryBusDB1AfterScroll
    Connection = DBKatasBusDB2
    SQL.Strings = (
      'SELECT '#44144#47000#53076#46300', '#44144#47000#47749','
      '       '#44148#49688' = (SELECT count(*)'
      '               FROM (SELECT distinct '#44368#50977#52397#53076#46300', '#54617#44368#53076#46300', '#44368#51648#53076#46300','
      '                            '#51452#47928#44396#48516', '#51452#47928#51068#51088', '#51452#47928#48264#54840
      '                     FROM '#51452#47928#45824#51109
      '                     WHERE '#51089#50629#53076#46300' = :pWork'
      '                       and '#44277#44553#51064#53076#46300' = '#44144#47000#53076#46300
      '                       and '#51452#47928#49849#51064#44396#48516' = :pYN'
      '                       and '#51452#47928#44396#48516' <> '#39'2'#39
      '                       and '#51077#47141#44396#48516' = '#39'1'#39'  --// '#44277#44553#49548#44036' '#51312#51221#51452#47928#51060' '#50500#45772#44163#47564'...'
      '                       ) AA)'
      'FROM Common2..'#44144#47000#53076#46300#45824#51109
      'WHERE substring('#44144#47000#53076#46300',1,1) = '#39'1'#39
      '  and '#44228#50557#54644#51648#45380#46020' >= :pYear'
      'ORDER BY '#44144#47000#53076#46300)
    Left = 56
    Top = 217
    ParamData = <
      item
        Name = 'pWork'
        DataType = ftString
        ParamType = ptInput
        Value = '21FA1'
      end
      item
        Name = 'pYN'
        DataType = ftString
        ParamType = ptInput
        Value = '1'
      end
      item
        Name = 'pYear'
        DataType = ftString
        ParamType = ptInput
        Value = '2021'
      end>
    object QryBusDB1BDEDesigner: TStringField
      FieldName = #44144#47000#53076#46300
      FixedChar = True
      Size = 4
    end
    object QryBusDB1BDEDesigner2: TStringField
      FieldName = #44144#47000#47749
      Size = 30
    end
    object QryBusDB1IntegerField: TIntegerField
      FieldName = #44148#49688
      DisplayFormat = '#,###,###'
    end
  end
  object DBKatasBusDB2: TFDConnection
    ConnectionName = 'DBKatasBusDB2'
    Params.Strings = (
      'Server=112.161.65.6,4452'
      'Database=BusDB2'
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
    Left = 56
    Top = 136
  end
  object DataSource1: TDataSource
    DataSet = QryBusDB1
    OnDataChange = DataSource1DataChange
    Left = 56
    Top = 297
  end
end
