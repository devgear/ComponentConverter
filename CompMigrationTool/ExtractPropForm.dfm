object frmExtractProperties: TfrmExtractProperties
  Left = 0
  Top = 0
  Caption = #52980#54252#45324#53944#51032' '#53945#51221' '#49549#49457#51012' '#49324#50857#54616#45716' '#52980#54252#45324#53944' '#47785#47197' '#52628#52636
  ClientHeight = 485
  ClientWidth = 644
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 485
    Align = alClient
    TabOrder = 0
    ExplicitTop = 89
    ExplicitHeight = 396
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 644
    Height = 485
    ActivePage = TabSheet3
    Align = alClient
    TabHeight = 30
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #52980#54252#45324#53944' '#49549#49457' '#52628#52636
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 636
        Height = 89
        Align = alTop
        TabOrder = 0
        ExplicitTop = 8
        ExplicitWidth = 281
        object Label1: TLabel
          Left = 20
          Top = 23
          Width = 110
          Height = 13
          Alignment = taRightJustify
          Caption = 'Component class name'
        end
        object Label2: TLabel
          Left = 57
          Top = 52
          Width = 73
          Height = 13
          Alignment = taRightJustify
          Caption = 'Property prefix'
        end
        object edtClassName: TEdit
          Left = 136
          Top = 20
          Width = 177
          Height = 21
          TabOrder = 0
        end
        object edtPropertyKeyword: TEdit
          Left = 136
          Top = 49
          Width = 177
          Height = 21
          TabOrder = 1
        end
        object btnCompProps: TButton
          Left = 319
          Top = 47
          Width = 75
          Height = 25
          Caption = '&Execute'
          TabOrder = 2
          OnClick = btnCompPropsClick
        end
        object Memo1: TMemo
          Left = 404
          Top = 3
          Width = 236
          Height = 81
          Lines.Strings = (
            #50696'> '#47532#50620#44536#47532#46300#51032' '#51060#48292#53944
            'TRealGrid, On'
            #50696'> '#47532#50620#44536#47532#46300' Values.Strings = ( '#49324#50857
            'TRealGrid, Values.Strings')
          ReadOnly = True
          TabOrder = 3
        end
      end
      object mmoProperties: TMemo
        Left = 0
        Top = 89
        Width = 636
        Height = 315
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitWidth = 642
        ExplicitHeight = 353
      end
      object Panel3: TPanel
        Left = 0
        Top = 404
        Width = 636
        Height = 41
        Align = alBottom
        TabOrder = 2
        ExplicitLeft = 1
        ExplicitTop = 354
        ExplicitWidth = 642
        DesignSize = (
          636
          41)
        object btnSave: TButton
          Left = 8
          Top = 6
          Width = 113
          Height = 25
          Caption = '&Save to CSV'
          TabOrder = 0
          OnClick = btnSaveClick
        end
        object btnClose: TButton
          Left = 915
          Top = 6
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Cancel = True
          Caption = '&Close'
          TabOrder = 1
          OnClick = btnCloseClick
          ExplicitLeft = 560
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #47532#50620#44536#47532#46300' '#52972#47100' '#49353#49345' '#52628#52636
      ImageIndex = 1
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 636
        Height = 49
        Align = alTop
        TabOrder = 0
        DesignSize = (
          636
          49)
        object Button1: TButton
          Left = 8
          Top = 10
          Width = 617
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          Caption = #52972#47100' '#49353#49345' '#52628#52636
          TabOrder = 0
          OnClick = Button1Click
        end
      end
      object mmoColColor: TMemo
        Left = 0
        Top = 49
        Width = 636
        Height = 396
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitTop = 41
        ExplicitHeight = 404
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'cxGrid '#48180#46300'/'#54644#45908' '#48337#54633' '#45824#49345
      ImageIndex = 2
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 636
        Height = 49
        Align = alTop
        TabOrder = 0
        ExplicitTop = 8
        DesignSize = (
          636
          49)
        object btnBandHeader: TButton
          Left = 8
          Top = 10
          Width = 617
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cxGrid '#48180#46300'/'#54644#45908' '#48337#54633' '#45824#49345
          TabOrder = 0
          OnClick = btnBandHeaderClick
        end
      end
      object mmoBandHeader: TMemo
        Left = 0
        Top = 49
        Width = 636
        Height = 396
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitTop = 41
        ExplicitHeight = 404
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'CSV|*.csv'
    Left = 584
    Top = 424
  end
end
