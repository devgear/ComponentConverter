object frmExtract: TfrmExtract
  Left = 0
  Top = 0
  Caption = #49688#51089#50629' '#45824#49345' '#52628#52636
  ClientHeight = 372
  ClientWidth = 591
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
    Width = 591
    Height = 372
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Footers '#44288#47144
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 583
        Height = 81
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 51
          Width = 33
          Height = 13
          Caption = #53412#50892#46300
        end
        object btnFooter: TButton
          Left = 0
          Top = 8
          Width = 569
          Height = 33
          Caption = 'Footers[0] '#49444#51221#54616#45716' '#53076#46300#50948#50640' EnableControls '#48120#49444#51221#46108' '#50976#45787' '#52628#52636
          TabOrder = 0
          OnClick = btnFooterClick
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
        Top = 81
        Width = 583
        Height = 263
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitTop = 49
        ExplicitHeight = 295
      end
    end
  end
end
