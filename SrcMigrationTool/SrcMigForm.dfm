object frmSrcMainForm: TfrmSrcMainForm
  Left = 0
  Top = 0
  Caption = 'Source migration tool'
  ClientHeight = 482
  ClientWidth = 826
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 826
    Height = 49
    Align = alTop
    TabOrder = 0
    DesignSize = (
      826
      49)
    object Bevel1: TBevel
      Left = 587
      Top = 8
      Width = 2
      Height = 35
      Anchors = [akTop, akRight]
      ExplicitLeft = 582
    end
    object edtRootPath: TEdit
      Left = 8
      Top = 14
      Width = 532
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
    end
    object btnSelectDir: TButton
      Left = 546
      Top = 12
      Width = 26
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 1
      OnClick = btnSelectDirClick
    end
    object btnLoadFiles: TButton
      Left = 595
      Top = 12
      Width = 89
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Load files'
      TabOrder = 2
      OnClick = btnLoadFilesClick
    end
    object chkRecursively: TCheckBox
      Left = 706
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
    Width = 826
    Height = 392
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 637
      Top = 1
      Height = 390
      Align = alRight
      ExplicitLeft = 545
      ExplicitTop = 6
      ExplicitHeight = 407
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 636
      Height = 390
      Margins.Left = 8
      Margins.Top = 8
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object lvFiles: TListView
        Left = 0
        Top = 17
        Width = 636
        Height = 373
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
        PopupMenu = PopupMenu1
        TabOrder = 0
        ViewStyle = vsReport
      end
      object chkAllFiles: TCheckBox
        Left = 0
        Top = 0
        Width = 636
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
      Left = 640
      Top = 1
      Width = 185
      Height = 390
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel4'
      TabOrder = 1
      object lvConverter: TListView
        Left = 0
        Top = 17
        Width = 185
        Height = 373
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
    Top = 441
    Width = 826
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Bevel2: TBevel
      Left = 139
      Top = 6
      Width = 2
      Height = 30
    end
    object Bevel3: TBevel
      Left = 320
      Top = 6
      Width = 2
      Height = 30
    end
    object lblCount: TLabel
      Left = 750
      Top = 14
      Width = 39
      Height = 13
      Caption = 'lblCount'
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
    object ProgressBar1: TProgressBar
      Left = 330
      Top = 13
      Width = 414
      Height = 17
      TabOrder = 2
    end
    object cbxLogLevel: TComboBox
      Left = 215
      Top = 10
      Width = 97
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'Info'
        'Error')
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 456
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 408
    Top = 248
    object mniSelectAll: TMenuItem
      Caption = #51204#52404' '#49440#53469
      OnClick = mniSelectAllClick
    end
    object mniUnselectAll: TMenuItem
      Caption = #51204#52404' '#49440#53469' '#54644#51228
      OnClick = mniUnselectAllClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mniBeforeSelelect: TMenuItem
      Caption = #51060#51204' '#54637#47785' '#47784#46160' '#49440#53469
      OnClick = mniBeforeSelelectClick
    end
    object mniAfterSelect: TMenuItem
      Caption = #51060#54980' '#54637#47785' '#47784#46160' '#49440#53469
      OnClick = mniAfterSelectClick
    end
  end
end
