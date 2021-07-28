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
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 591
    ExplicitHeight = 372
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
            'DCEC '#52280#44256#54644' '#51088#46041#54868' '#51089#50629#51012' '#52628#44032#54616#49464#50836'.'
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
  end
end
