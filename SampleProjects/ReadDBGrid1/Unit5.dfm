object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'TbF_101I'
  ClientHeight = 644
  ClientWidth = 911
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
  object RealDBGrid3: TcxGrid
    Left = 23
    Top = 266
    Width = 802
    Height = 296
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object RealDBGrid3DBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Column = RealDBGrid3DBBandedTableView1Column6
          DisplayText = #51068'   '#44228
        end
        item
          Column = RealDBGrid3DBBandedTableView1Column6
        end
        item
          Column = RealDBGrid3DBBandedTableView1Column6
        end
        item
          Column = RealDBGrid3DBBandedTableView1Column7
        end
        item
          Format = '#'
          Column = RealDBGrid3DBBandedTableView1Column7
        end
        item
          Column = RealDBGrid3DBBandedTableView1Column7
        end>
      DataController.Summary.SummaryGroups = <
        item
          Links = <>
          SummaryItems = <
            item
              Kind = skSum
              Column = RealDBGrid3DBBandedTableView1Column10
              DisplayText = 'test'
            end>
        end
        item
          Links = <>
          SummaryItems = <>
        end>
      DataController.Summary.Options = [soNullIgnore]
      OptionsView.NoDataToDisplayInfoText = '<'#54364#49884#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.DataRowHeight = 25
      OptionsView.Footer = True
      OptionsView.FooterMultiSummaries = True
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
      object RealDBGrid3DBBandedTableView1Column1: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = #46020#49436#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 44
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column2: TcxGridDBBandedColumn
        DataBinding.FieldName = #52636#54032#49324
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 143
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column3: TcxGridDBBandedColumn
        DataBinding.FieldName = #46020#49436#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 126
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column4: TcxGridDBBandedColumn
        DataBinding.FieldName = #45824#54364
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 39
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column5: TcxGridDBBandedColumn
        DataBinding.FieldName = #44428#48324
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 37
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column6: TcxGridDBBandedColumn
        Caption = #51452#47928#48512#49688
        DataBinding.FieldName = #52509#51452#47928#48512#49688
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = '1'#54617#45380
        DataBinding.FieldName = #51452#47928#48512#49688'1'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column8: TcxGridDBBandedColumn
        Caption = '2'#54617#45380
        DataBinding.FieldName = #51452#47928#48512#49688'2'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column9: TcxGridDBBandedColumn
        Caption = '3'#54617#45380
        DataBinding.FieldName = #51452#47928#48512#49688'3'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column10: TcxGridDBBandedColumn
        Caption = '4'#54617#45380
        DataBinding.FieldName = #51452#47928#48512#49688'4'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column11: TcxGridDBBandedColumn
        Caption = '5'#54617#45380
        DataBinding.FieldName = #51452#47928#48512#49688'5'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column12: TcxGridDBBandedColumn
        Caption = '6'#54617#45380
        DataBinding.FieldName = #51452#47928#48512#49688'6'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 0
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column13: TcxGridDBBandedColumn
        DataBinding.FieldName = #54788#51116#44256
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column14: TcxGridDBBandedColumn
        DataBinding.FieldName = #48156#51452#48512#49688
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 13
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column15: TcxGridDBBandedColumn
        DataBinding.FieldName = #49849#51064#51452#47928
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 14
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column16: TcxGridDBBandedColumn
        DataBinding.FieldName = #48120#49849#51064#51452#47928
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 15
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column17: TcxGridDBBandedColumn
        DataBinding.FieldName = #48512#51313#48512#49688
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 16
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column18: TcxGridDBBandedColumn
        DataBinding.FieldName = #44032#50857#48512#49688
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 0
        Position.ColIndex = 17
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column19: TcxGridDBBandedColumn
        Caption = #44288#47532#48512#48156#54665#51068
        DataBinding.FieldName = #44277#44553#48156#54665#51068
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 83
        Position.BandIndex = 0
        Position.ColIndex = 18
        Position.RowIndex = 0
      end
      object RealDBGrid3DBBandedTableView1Column20: TcxGridDBBandedColumn
        Caption = #44277#44553#48512#52636#44256#51068
        DataBinding.FieldName = #47932#47448#48156#54665#51068
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 82
        Position.BandIndex = 0
        Position.ColIndex = 19
        Position.RowIndex = 0
      end
    end
    object RealDBGrid3Level1: TcxGridLevel
      GridView = RealDBGrid3DBBandedTableView1
    end
  end
  object Button1: TButton
    Left = 23
    Top = 568
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object RealDBGrid2: TcxGrid
    Left = 23
    Top = 33
    Width = 706
    Height = 184
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = #44404#47548
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object RealDBGrid2DBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
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
      object RealDBGrid2DBBandedTableView1Column1: TcxGridDBBandedColumn
        DataBinding.FieldName = #51452#47928#51068#51088
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 88
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column2: TcxGridDBBandedColumn
        DataBinding.FieldName = #51452#47928#48264#54840
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 56
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column3: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = #44368#50977#52397#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 38
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column4: TcxGridDBBandedColumn
        DataBinding.FieldName = #44368#50977#52397#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column5: TcxGridDBBandedColumn
        Caption = #53076#46300
        DataBinding.FieldName = #54617#44368#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 35
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column6: TcxGridDBBandedColumn
        DataBinding.FieldName = #54617#44368#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 81
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = #44368'/'#51648
        DataBinding.FieldName = #44368#51648
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 54
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column8: TcxGridDBBandedColumn
        DataBinding.FieldName = #51452#47928
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 73
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object RealDBGrid2DBBandedTableView1Column9: TcxGridDBBandedColumn
        Caption = #49849#51064
        DataBinding.FieldName = #51452#47928#49849#51064#44396#48516
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        Properties.NullStyle = nssUnchecked
        Properties.ReadOnly = False
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 32
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
    end
    object RealDBGrid2Level1: TcxGridLevel
      GridView = RealDBGrid2DBBandedTableView1
    end
  end
end
