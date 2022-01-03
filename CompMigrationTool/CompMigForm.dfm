object frmCompMigTool: TfrmCompMigTool
  Left = 0
  Top = 0
  Caption = 'Component migrate tool'
  ClientHeight = 477
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 732
    Height = 49
    Align = alTop
    TabOrder = 0
    DesignSize = (
      732
      49)
    object Bevel1: TBevel
      Left = 493
      Top = 8
      Width = 2
      Height = 35
      Anchors = [akTop, akRight]
      ExplicitLeft = 582
    end
    object edtRootPath: TEdit
      Left = 8
      Top = 14
      Width = 438
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
    end
    object btnSelectDir: TButton
      Left = 452
      Top = 12
      Width = 26
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = btnSelectDirClick
    end
    object btnLoadFiles: TButton
      Left = 501
      Top = 12
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Load files'
      TabOrder = 2
      OnClick = btnLoadFilesClick
    end
    object chkRecursively: TCheckBox
      Left = 612
      Top = 16
      Width = 97
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Recursively'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 49
    Width = 732
    Height = 387
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 543
      Top = 1
      Height = 385
      Align = alRight
      ExplicitLeft = 545
      ExplicitTop = 6
      ExplicitHeight = 407
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 542
      Height = 385
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object lvFiles: TListView
        Left = 0
        Top = 17
        Width = 542
        Height = 368
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'Filename'
            Width = 180
          end
          item
            Alignment = taRightJustify
            Caption = 'Size'
            Width = 110
          end
          item
            Caption = 'Status'
            Width = 80
          end>
        GridLines = True
        GroupView = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object chkAllFiles: TCheckBox
        Left = 0
        Top = 0
        Width = 542
        Height = 17
        Align = alTop
        Caption = 'Check all'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = chkAllFilesClick
      end
    end
    object Panel4: TPanel
      Left = 546
      Top = 1
      Width = 185
      Height = 385
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object lvConverter: TListView
        Left = 0
        Top = 17
        Width = 185
        Height = 368
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'Converter'
            Width = 150
          end>
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object chkAllConverter: TCheckBox
        Left = 0
        Top = 0
        Width = 185
        Height = 17
        Align = alTop
        Caption = 'Check all'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = chkAllConverterClick
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 436
    Width = 732
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      732
      41)
    object Bevel2: TBevel
      Left = 139
      Top = 6
      Width = 2
      Height = 30
    end
    object Bevel3: TBevel
      Left = 347
      Top = 6
      Width = 2
      Height = 30
    end
    object btnRunConvert: TButton
      Left = 8
      Top = 8
      Width = 119
      Height = 25
      Caption = 'Convert'
      TabOrder = 0
      OnClick = btnRunConvertClick
    end
    object chkBackup: TCheckBox
      Left = 152
      Top = 12
      Width = 60
      Height = 17
      Caption = 'Backup'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object btnExtractProps: TButton
      Left = 632
      Top = 8
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Extract Props'
      TabOrder = 2
      OnClick = btnExtractPropsClick
    end
    object Button1: TButton
      Left = 551
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Band Header'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 456
    Top = 56
  end
end
