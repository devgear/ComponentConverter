object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 685
  ClientWidth = 1121
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
    Left = 44
    Top = 91
    Width = 1229
    Height = 292
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
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = '<'#54364#49884#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
      OptionsView.DataRowHeight = 17
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 23
      OptionsView.Indicator = True
      Bands = <
        item
          Caption = #52404#53356
          Width = 23
        end
        item
          Caption = #48152#54408#44277#44553#51064'('#51116#44256' '#45336#44200#51452#45716' '#44277#44553#51064')'
          Styles.Header = cxStyle5
          Width = 400
        end
        item
          Caption = #51452#47928#44277#44553#51064'('#51116#44256' '#48155#45716' '#44277#44553#51064')'
          Styles.Header = cxStyle3
          Width = 760
        end
        item
          Caption = #48376#49324' '#48156#54665' '#54788#54889
          Width = 200
        end>
      object RealDBGrid1DBBandedTableView1Column1: TcxGridDBBandedColumn
        DataBinding.FieldName = #52404#53356
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Alignment.Horz = taCenter
        Properties.Items = <
          item
            Description = '0'
            Value = '0'
          end
          item
            Description = '1'
            Value = '1'
          end>
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 23
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column2: TcxGridDBBandedColumn
        DataBinding.FieldName = #51312#54633#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column3: TcxGridDBBandedColumn
        Caption = #44277#44553#51064#53076#46300
        DataBinding.FieldName = #48152#54408#44277#44553#51064#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column4: TcxGridDBBandedColumn
        Caption = #44277#44553#51064#47749
        DataBinding.FieldName = #48152#54408#44277#44553#51064#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 140
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column5: TcxGridDBBandedColumn
        Caption = #48152#54408#44396#48516
        DataBinding.FieldName = #48152#54408#44396#48516#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column6: TcxGridDBBandedColumn
        DataBinding.FieldName = #48152#54408#48264#54840
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column7: TcxGridDBBandedColumn
        Caption = #44277#44553#51064#53076#46300
        DataBinding.FieldName = #51452#47928#44277#44553#51064#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column8: TcxGridDBBandedColumn
        Caption = #44277#44553#51064#47749
        DataBinding.FieldName = #51452#47928#44277#44553#51064#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 130
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column9: TcxGridDBBandedColumn
        Caption = #51452#47928#44396#48516
        DataBinding.FieldName = #51452#47928#44396#48516#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = False
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 2
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column10: TcxGridDBBandedColumn
        Caption = #54617#44368#44553
        DataBinding.FieldName = #51452#47928#54617#44368#44553#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 50
        Position.BandIndex = 2
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column11: TcxGridDBBandedColumn
        Caption = #44368#50977#52397#53076#46300
        DataBinding.FieldName = #51452#47928#44368#50977#52397#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 70
        Position.BandIndex = 2
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column12: TcxGridDBBandedColumn
        Caption = #44368#50977#52397#47749
        DataBinding.FieldName = #51452#47928#44368#50977#52397#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 100
        Position.BandIndex = 2
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column13: TcxGridDBBandedColumn
        Caption = #54617#44368#53076#46300
        DataBinding.FieldName = #51452#47928#54617#44368#53076#46300
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 2
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column14: TcxGridDBBandedColumn
        Caption = #54617#44368#47749
        DataBinding.FieldName = #51452#47928#54617#44368#47749
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 160
        Position.BandIndex = 2
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column15: TcxGridDBBandedColumn
        DataBinding.FieldName = #51452#47928#48264#54840
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 2
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column16: TcxGridDBBandedColumn
        Caption = #49849#51064#51068
        DataBinding.FieldName = #48376#49324#49849#51064#51068
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taCenter
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 80
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column17: TcxGridDBBandedColumn
        Caption = #48152#54408#48264#54840
        DataBinding.FieldName = #48376#49324#48152#54408#44228#49328#49436#48264#54840
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 3
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object RealDBGrid1DBBandedTableView1Column18: TcxGridDBBandedColumn
        Caption = #52636#44256#48264#54840
        DataBinding.FieldName = #48376#49324#52636#44256#44228#49328#49436#48264#54840
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 60
        Position.BandIndex = 3
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object RealDBGrid1Level1: TcxGridLevel
      GridView = RealDBGrid1DBBandedTableView1
    end
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 48
    Top = 400
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 8454143
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = 8454016
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor]
      Color = 12615935
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor]
      Color = 16751515
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor]
      Color = clAqua
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor]
      Color = clInactiveCaptionText
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor]
      Color = clLime
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor]
      Color = clMoneyGreen
    end
    object cxStyle9: TcxStyle
      AssignedValues = [svColor]
      Color = clSilver
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor]
      Color = clSkyBlue
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor]
      Color = clYellow
    end
  end
end
