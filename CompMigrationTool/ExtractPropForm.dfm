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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 89
    Align = alTop
    TabOrder = 0
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
    object Button1: TButton
      Left = 319
      Top = 47
      Width = 75
      Height = 25
      Caption = '&Execute'
      TabOrder = 2
      OnClick = Button1Click
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
  object Panel2: TPanel
    Left = 0
    Top = 89
    Width = 644
    Height = 396
    Align = alClient
    TabOrder = 1
    object mmoProperties: TMemo
      Left = 1
      Top = 1
      Width = 642
      Height = 353
      Align = alClient
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 1
      Top = 354
      Width = 642
      Height = 41
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        642
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
        Left = 560
        Top = 6
        Width = 75
        Height = 25
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = '&Close'
        TabOrder = 1
        OnClick = btnCloseClick
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'CSV|*.csv'
    Left = 320
    Top = 248
  end
end
