object frmExtract: TfrmExtract
  Left = 0
  Top = 0
  Caption = #49688#51089#50629' '#45824#49345' '#52628#52636
  ClientHeight = 590
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 920
    Height = 590
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Footers '#44288#47144
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 912
        Height = 105
        Align = alTop
        TabOrder = 0
        ExplicitWidth = 1036
        DesignSize = (
          912
          105)
        object Label1: TLabel
          Left = 16
          Top = 51
          Width = 33
          Height = 13
          Caption = #53412#50892#46300
        end
        object Label2: TLabel
          Left = 64
          Top = 74
          Width = 821
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            #50500#47000' '#54028#51068#46308#51032' '#53076#46300' '#54869#51064' '#54980' CustomConverter.TCustomBusConvert.ConvertDataSet' +
            'DCEC '#52280#44256#54644' '#51088#46041#54868' '#53076#46300#47484' '#52628#44032#54616#49464#50836'.'
          WordWrap = True
          ExplicitWidth = 890
        end
        object btnFooter: TButton
          Left = 0
          Top = 8
          Width = 905
          Height = 33
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Footers[0] '#49444#51221#54616#45716' '#53076#46300#50948#50640' EnableControls '#48120#49444#51221#46108' '#50976#45787' '#52628#52636
          TabOrder = 0
          OnClick = btnFooterClick
          ExplicitWidth = 569
        end
        object edtKeywordFooter: TEdit
          Left = 64
          Top = 47
          Width = 329
          Height = 21
          TabOrder = 1
          Text = '\]\.\Footers\[0\][\s]+\:\=[\s]+[Ff]ormat'
        end
      end
      object mmoFooter: TMemo
        Left = 0
        Top = 105
        Width = 912
        Height = 457
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitTop = 81
        ExplicitWidth = 583
        ExplicitHeight = 263
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'CustomDrawCell'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 912
        Height = 81
        Align = alTop
        TabOrder = 0
        DesignSize = (
          912
          81)
        object Label3: TLabel
          Left = 72
          Top = 56
          Width = 821
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = #50500#47000' '#54028#51068#46308#50640#49436' '#54596#46300#44032' '#52972#47100#51004#47196' '#49373#49457#46104#50632#45716#51648' '#54869#51064'('#48120#49373#49457' '#49884' '#49373#49457') '#54980' (*TODO*)'#47484' '#51228#44144#54644#51452#49464#50836'.'
          WordWrap = True
        end
        object btnCustomDrawCell: TButton
          Left = 1
          Top = 1
          Width = 910
          Height = 40
          Align = alTop
          Caption = 'CustomDrawCell '#51060#48292#53944' '#50504#50640#49436' '#52280#51312#54616#45716' '#54596#46300#44032' '#52972#47100#51004#47196' '#49373#49457#46104#50632#45716#51648' '#54869#51064#54644' '#51452#49464#50836'.'
          TabOrder = 0
          OnClick = btnCustomDrawCellClick
        end
      end
      object mmoCustomDrawCell: TMemo
        Left = 0
        Top = 81
        Width = 912
        Height = 481
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
end
