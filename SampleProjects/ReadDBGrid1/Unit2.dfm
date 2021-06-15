object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 655
  ClientWidth = 1104
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
    Left = 8
    Top = 52
    Width = 1214
    Height = 455
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
      OptionsView.DataRowHeight = 27
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 42
      OptionsView.Indicator = True
      OptionsView.BandHeaders = False
      Bands = <
        item
        end>
      object RealDBGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn
        Caption = #53076#46300'(0)'
        DataBinding.FieldName = #46020#49436#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 41
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn
        DataBinding.FieldName = #54617#44368#44553#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn
        Caption = #46020#49436#47749
        DataBinding.FieldName = #44284#47785#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 77
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column4: TcxGridDBBandedColumn
        DataBinding.FieldName = #51064#51221#46020#49436#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 300
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column5: TcxGridDBBandedColumn
        DataBinding.FieldName = #51064#51221#46020#49436#50557#52845
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 120
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column6: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = 'PubCop_COD'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 32
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = #52636#54032#49324
        DataBinding.FieldName = 'Company_DES'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 160
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column8: TcxGridDBBandedColumn
        Caption = #45824#54364
        DataBinding.FieldName = 'Author_OPT'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column9: TcxGridDBBandedColumn
        Caption = #44428#48324
        DataBinding.FieldName = 'Volumn'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 47
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column10: TcxGridDBBandedColumn
        DataBinding.FieldName = #46020#49436#44536#47353#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 53
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column11: TcxGridDBBandedColumn
        Caption = #46020#49436#44277#53685#53076#46300'(10)'
        DataBinding.FieldName = #46020#49436#44277#53685#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 53
        Position.BandIndex = 0
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column12: TcxGridDBBandedColumn
        Caption = #51200#51088
        DataBinding.FieldName = 'Author'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 72
        Position.BandIndex = 0
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column13: TcxGridDBBandedColumn
        Caption = #44160#183#51064#51221#44396#48516
        DataBinding.FieldName = #44160#51221#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 74
        Position.BandIndex = 0
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column14: TcxGridDBBandedColumn
        DataBinding.FieldName = #44060#51221#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 81
        Position.BandIndex = 0
        Position.ColIndex = 13
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column15: TcxGridDBBandedColumn
        Caption = #44396#48516#44256#49884
        DataBinding.FieldName = #44396#48516#44256#49884#44396#48516
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Items = <
          item
            Description = #44256#49884
            ImageIndex = 0
            Value = 'Y'
          end
          item
            Value = 'N'
          end>
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 55
        Position.BandIndex = 0
        Position.ColIndex = 14
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column16: TcxGridDBBandedColumn
        DataBinding.FieldName = #51228#54408#49345#54408#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 55
        Position.BandIndex = 0
        Position.ColIndex = 15
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column17: TcxGridDBBandedColumn
        Caption = #46020#49436#50976#54805
        DataBinding.FieldName = #50724#46356#50724#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 129
        Position.BandIndex = 0
        Position.ColIndex = 16
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column18: TcxGridDBBandedColumn
        Caption = #49436#52293#51068#44221#50864'    CD '#46321' '#54252#54632#44396#48516
        DataBinding.FieldName = 'CD'#54252#54632#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 90
        Position.BandIndex = 0
        Position.ColIndex = 17
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column19: TcxGridDBBandedColumn
        Caption = #51221#44032
        DataBinding.FieldName = 'Pric'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 18
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column20: TcxGridDBBandedColumn
        Caption = #54624#51064#44032
        DataBinding.FieldName = 'Disc'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 19
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column21: TcxGridDBBandedColumn
        Caption = #46020#49436#51221#44032'(20)'
        DataBinding.FieldName = #46020#49436#51221#44032
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 20
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column22: TcxGridDBBandedColumn
        DataBinding.FieldName = #46020#49436#54624#51064#44032
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 21
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column23: TcxGridDBBandedColumn
        Caption = 'e'#44368#44284#49436#51221#44032' / '#46356#51648#53560#44368#44284#49436#51221#44032
        DataBinding.FieldName = 'eb'#51221#44032
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 83
        Position.BandIndex = 0
        Position.ColIndex = 22
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column24: TcxGridDBBandedColumn
        Caption = #54032#47588#44032
        DataBinding.FieldName = 'Cost'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 23
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column25: TcxGridDBBandedColumn
        DataBinding.FieldName = #47588#51077#45800#44032
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 24
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column26: TcxGridDBBandedColumn
        DataBinding.FieldName = #51312#51221#47749#47161#44032#44201
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 58
        Position.BandIndex = 0
        Position.ColIndex = 25
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column27: TcxGridDBBandedColumn
        DataBinding.FieldName = #50696#49345#51221#44032
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 26
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column28: TcxGridDBBandedColumn
        DataBinding.FieldName = #49436#51216#54624#51064#44032
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 27
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column29: TcxGridDBBandedColumn
        DataBinding.FieldName = #51221#44032#54869#51221#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 78
        Position.BandIndex = 0
        Position.ColIndex = 28
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column30: TcxGridDBBandedColumn
        Caption = #49549#45817
        DataBinding.FieldName = 'Pack_Busu'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        Visible = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 29
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column31: TcxGridDBBandedColumn
        Caption = '1'#54252'(30)'
        DataBinding.FieldName = 'Box_Busu'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        Visible = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 30
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column32: TcxGridDBBandedColumn
        Caption = #54617#45380#44396#48516'(31)'
        DataBinding.FieldName = #54617#45380#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 31
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column33: TcxGridDBBandedColumn
        DataBinding.FieldName = #54617#44592#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 32
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column34: TcxGridDBBandedColumn
        DataBinding.FieldName = #48152#44592#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 33
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column35: TcxGridDBBandedColumn
        Caption = #49884#51089#45380#46020
        DataBinding.FieldName = 'Book_YR'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 34
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column36: TcxGridDBBandedColumn
        DataBinding.FieldName = #44288#54624#44592#44288#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 53
        Position.BandIndex = 0
        Position.ColIndex = 35
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column37: TcxGridDBBandedColumn
        DataBinding.FieldName = #44288#54624#44592#44288#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 150
        Position.BandIndex = 0
        Position.ColIndex = 36
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column38: TcxGridDBBandedColumn
        DataBinding.FieldName = #44277#44553#51064#51228#54620#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        Visible = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 37
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column39: TcxGridDBBandedColumn
        DataBinding.FieldName = #48376#51452#47928#51228#54620
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 38
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column40: TcxGridDBBandedColumn
        DataBinding.FieldName = #52628#44032#51452#47928#51228#54620
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 61
        Position.BandIndex = 0
        Position.ColIndex = 39
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column41: TcxGridDBBandedColumn
        DataBinding.FieldName = #44060#48324#51452#47928#51228#54620
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 40
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column42: TcxGridDBBandedColumn
        DataBinding.FieldName = #45225#54408#50976#47924
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 41
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column43: TcxGridDBBandedColumn
        DataBinding.FieldName = #51088#52404#44060#48156#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 81
        Position.BandIndex = 0
        Position.ColIndex = 42
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column44: TcxGridDBBandedColumn
        Caption = #51901#49688'(40)'
        DataBinding.FieldName = #51901#49688
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 45
        Position.BandIndex = 0
        Position.ColIndex = 43
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column45: TcxGridDBBandedColumn
        DataBinding.FieldName = #48372#53685#51204#47928#44396#48516
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 54
        Position.BandIndex = 0
        Position.ColIndex = 44
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column46: TcxGridDBBandedColumn
        Caption = #48148#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 64
        Position.BandIndex = 0
        Position.ColIndex = 45
        Position.RowIndex = 0
      end
    end
    object RealDBGrid1Level1: TcxGridLevel
      GridView = RealDBGrid1DBBandedTableView1
    end
  end
  object qry_Master: TFDQuery
    Active = True
    CachedUpdates = True
    Connection = DBKatasCommon2
    SQL.Strings = (
      'SELECT A.*, B.Company_DES, C.'#44284#47785#47749', C.'#54617#44368#44553#44396#48516','
      '       '#44288#54624#44592#44288#47749' = D.Company_DES'
      'FROM C_InfBook A'
      ''
      '     LEFT OUTER JOIN C_Company D'
      '     ON D.Company_Ty_COD = '#39'1'#39
      '    and D.Company_COD = A.'#44288#54624#44592#44288#53076#46300
      ''
      '     ,C_Company B, C_BasBook C'
      'WHERE A.'#51089#50629#53076#46300' = :pWork'
      '  and A.'#44368#51648#53076#46300' = :pKJ'
      '  and A.PubCop_COD = B.Company_COD'
      '  and B.Company_Ty_COD = '#39'1'#39
      '  and C.'#51312#54633#53076#46300' = :pJH'
      '  and SubString(A.'#46020#49436#53076#46300',1,3) = C.'#44284#47785#53076#46300
      '  and ('
      '        (:p'#49888#44592#44036#44396#48516' = '#39'0'#39' and book_yr like '#39'%'#39') or'
      '        (:p'#49888#44592#44036#44396#48516' = '#39'1'#39' and book_yr = :p'#49884#51089#45380#46020') or'
      '        (:p'#49888#44592#44036#44396#48516' = '#39'2'#39' and book_yr < :p'#49884#51089#45380#46020')'
      '      )'
      ''
      'ORDER BY C.'#54617#44368#44553#44396#48516', A.'#46020#49436#53076#46300', A.'#44368#51648#53076#46300
      ''
      ' '
      ' ')
    Left = 232
    Top = 375
    ParamData = <
      item
        Name = 'pWork'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'pKJ'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'pJH'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'p'#49888#44592#44036#44396#48516
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'p'#49888#44592#44036#44396#48516
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'p'#49884#51089#45380#46020
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'p'#49888#44592#44036#44396#48516
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'p'#49884#51089#45380#46020
        DataType = ftString
        ParamType = ptInput
      end>
    object qry_MasterWork_COD: TStringField
      FieldName = #51089#50629#53076#46300
      FixedChar = True
      Size = 5
    end
    object qry_MasterBook_COD: TStringField
      FieldName = #46020#49436#53076#46300
      FixedChar = True
      Size = 5
    end
    object qry_MasterKJ_COD: TStringField
      FieldName = #44368#51648#53076#46300
      FixedChar = True
      Size = 1
    end
    object qry_MasterAuthor_OPT: TStringField
      FieldName = 'Author_OPT'
    end
    object qry_MasterVolumn: TStringField
      DisplayWidth = 12
      FieldName = 'Volumn'
      Size = 12
    end
    object qry_MasterPubCop_COD: TStringField
      FieldName = 'PubCop_COD'
      FixedChar = True
      Size = 3
    end
    object qry_MasterAuthor: TStringField
      FieldName = 'Author'
      Size = 10
    end
    object qry_MasterPack_Busu: TIntegerField
      FieldName = 'Pack_Busu'
      DisplayFormat = '#,###,###'
    end
    object qry_MasterBox_Busu: TIntegerField
      FieldName = 'Box_Busu'
      DisplayFormat = '#,###,###'
    end
    object qry_MasterBJ_OPT: TStringField
      FieldName = 'BJ_OPT'
      FixedChar = True
      Size = 1
    end
    object qry_MasterPaperTy_COD: TStringField
      FieldName = 'PaperTy_COD'
      FixedChar = True
      Size = 1
    end
    object qry_MasterFilm_Work: TStringField
      FieldName = 'Film_Work'
      Size = 10
    end
    object qry_MasterFilm_Stat: TStringField
      FieldName = 'Film_Stat'
      Size = 10
    end
    object qry_MasterFilm_Mark: TStringField
      FieldName = 'Film_Mark'
      Size = 10
    end
    object qry_MasterBoxUP_COD: TStringField
      FieldName = 'BoxUP_COD'
      FixedChar = True
      Size = 2
    end
    object qry_MasterBook_YR: TStringField
      FieldName = 'Book_YR'
      FixedChar = True
      Size = 4
    end
    object qry_MasterFilm_Mod_DAY: TStringField
      FieldName = 'Film_Mod_DAY'
      Size = 8
    end
    object qry_MasterFilm_Mod: TStringField
      FieldName = 'Film_Mod'
      Size = 12
    end
    object qry_MasterBook_OPT: TStringField
      FieldName = 'Book_OPT'
      FixedChar = True
      Size = 1
    end
    object qry_MasterCompany_DES: TStringField
      FieldName = 'Company_DES'
      Size = 30
    end
    object qry_MasterBasBook_DES: TStringField
      FieldName = #44284#47785#47749
    end
    object qry_MasterPric: TIntegerField
      FieldName = 'Pric'
      DisplayFormat = '#,###,###'
    end
    object qry_MasterDisc: TIntegerField
      FieldName = 'Disc'
      DisplayFormat = '#,###,###'
    end
    object qry_Mastereb: TIntegerField
      FieldName = 'eb'#51221#44032
      DisplayFormat = '#,0'
    end
    object qry_MasterCost: TIntegerField
      FieldName = 'Cost'
      DisplayFormat = '#,###,###'
    end
    object qry_MasterPlan_MakeBusu: TIntegerField
      FieldName = 'Plan_MakeBusu'
    end
    object qry_MasterPlan_OPT: TStringField
      FieldName = 'Plan_OPT'
      FixedChar = True
      Size = 1
    end
    object qry_MasterBDEDesigner: TStringField
      FieldName = #51116#44256#54876#50857
      Size = 2
    end
    object qry_MasterPanType_COD: TStringField
      FieldName = 'PanType_COD'
      FixedChar = True
      Size = 1
    end
    object qry_MasterIntegerField: TIntegerField
      FieldName = #50937#51452#47928#51228#54620#48512#49688
      DisplayFormat = '###,###,###,###'
    end
    object qry_MasterStringField: TStringField
      FieldName = #46020#49436#44277#53685#53076#46300
      Size = 5
    end
    object qry_MasterStringField3: TStringField
      FieldKind = fkCalculated
      FieldName = #54617#44368#44553#47749
      Size = 8
      Calculated = True
    end
    object qry_MasterStringField2: TStringField
      FieldName = #54617#44368#44553#44396#48516
      Size = 1
    end
    object qry_MasterStringField4: TStringField
      FieldName = #50500#51060#46356
      FixedChar = True
      Size = 4
    end
    object qry_MasterDateTimeField: TDateTimeField
      FieldName = #49688#51221#51068
    end
    object qry_MasterStringField5: TStringField
      FieldName = #54617#45380#44396#48516
      Size = 1
    end
    object qry_MasterStringField6: TStringField
      FieldName = #54617#44592#44396#48516
      Size = 1
    end
    object qry_MasterField: TIntegerField
      FieldKind = fkCalculated
      FieldName = #46020#49436#51221#44032
      DisplayFormat = '#,0'
      Calculated = True
    end
    object qry_MasterField2: TIntegerField
      FieldKind = fkCalculated
      FieldName = #46020#49436#54624#51064#44032
      DisplayFormat = '#,0'
      Calculated = True
    end
    object qry_MasterIntegerField5: TIntegerField
      FieldName = #51312#51221#47749#47161#44032#44201
      DisplayFormat = '#,0'
    end
    object qry_MasterIntegerField2: TIntegerField
      FieldName = #50696#49345#51221#44032
      DisplayFormat = '#,###,###'
    end
    object qry_MasterStringField7: TStringField
      FieldName = #51064#51221#46020#49436#47749
      Size = 100
    end
    object qry_MasterStringField8: TStringField
      FieldName = #51064#51221#46020#49436#50557#52845
      Size = 40
    end
    object qry_MasterStringField9: TStringField
      FieldName = #50724#46356#50724#44396#48516
      Size = 1
    end
    object qry_MasterStringField10: TStringField
      FieldName = #46020#49436#44536#47353#53076#46300
      Size = 5
    end
    object qry_MasterIntegerField3: TIntegerField
      FieldName = #47588#51077#45800#44032
      DisplayFormat = '#,###,###'
    end
    object qry_MasterStringField11: TStringField
      FieldName = #44160#51221#44396#48516
      Size = 1
    end
    object qry_MasterStringField12: TStringField
      FieldName = #44288#54624#44592#44288#53076#46300
      Size = 3
    end
    object qry_MasterStringField13: TStringField
      FieldName = #44288#54624#44592#44288#47749
      Size = 50
    end
    object qry_MasterStringField14: TStringField
      FieldName = #48152#44592#44396#48516
      Size = 1
    end
    object qry_MasterIntegerField4: TIntegerField
      FieldName = #49436#51216#54624#51064#44032
      DisplayFormat = '#,0'
    end
    object qry_MasterCD: TStringField
      FieldName = 'CD'#54252#54632#44396#48516
      Size = 1
    end
    object qry_MasterStringField15: TStringField
      FieldName = #44277#44553#51064#51228#54620#44396#48516
      Size = 1
    end
    object qry_MasterStringField16: TStringField
      FieldName = #44160#51221#49464#48512#44396#48516
      FixedChar = True
      Size = 1
    end
    object qry_MasterStringField17: TStringField
      FieldName = #51228#54408#49345#54408#44396#48516
      Size = 1
    end
    object qry_MasterStringField18: TStringField
      FieldName = #45225#54408#50976#47924
      Size = 1
    end
    object qry_MasterStringField19: TStringField
      FieldName = #44060#51221#44396#48516
      Size = 2
    end
    object qry_MasterStringField20: TStringField
      FieldName = #51088#52404#44060#48156#44396#48516
      Size = 1
    end
    object qry_MasterStringField21: TStringField
      FieldName = #51221#44032#54869#51221#44396#48516
      Size = 1
    end
    object qry_MasterStringField22: TStringField
      FieldName = #44396#48516#44256#49884#44396#48516
      Size = 1
    end
    object qry_MasterIntegerField6: TIntegerField
      FieldName = #51901#49688
      DisplayFormat = '#,0'
    end
    object qry_MasterStringField23: TStringField
      FieldName = #48376#51452#47928#51228#54620
      Size = 1
    end
    object qry_MasterStringField24: TStringField
      FieldName = #52628#44032#51452#47928#51228#54620
      Size = 1
    end
    object qry_MasterStringField25: TStringField
      FieldName = #48372#53685#51204#47928#44396#48516
      Size = 1
    end
    object qry_MasterStringField27: TStringField
      FieldName = #44060#48324#51452#47928#51228#54620
      Size = 1
    end
    object qry_MasterStringField26: TStringField
      FieldName = #50500#51060#54588
      Size = 15
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
    Left = 144
    Top = 296
  end
  object dsMaster: TDataSource
    DataSet = qry_Master
    Left = 144
    Top = 384
  end
end
