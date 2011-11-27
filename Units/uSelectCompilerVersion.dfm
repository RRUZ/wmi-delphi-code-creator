object FrmSelCompilerVer: TFrmSelCompilerVer
  Left = 487
  Top = 403
  BorderStyle = bsToolWindow
  Caption = 'Select compiler'
  ClientHeight = 203
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelText: TLabel
    Left = 8
    Top = 8
    Width = 154
    Height = 13
    Caption = 'Object Pascal compilers installed'
  end
  object ButtonOk: TButton
    Left = 279
    Top = 175
    Width = 75
    Height = 25
    Caption = 'OK'
    Enabled = False
    ModalResult = 1
    TabOrder = 0
  end
  object ButtonCancel: TButton
    Left = 360
    Top = 175
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListViewIDEs: TListView
    Left = 8
    Top = 27
    Width = 427
    Height = 142
    Columns = <
      item
        Caption = 'Version'
        Width = -1
        WidthType = (
          -1)
      end
      item
        Caption = 'Path'
        Width = -1
        WidthType = (
          -1)
      end
      item
        Caption = 'Compiler'
        Width = -1
        WidthType = (
          -1)
      end>
    ReadOnly = True
    RowSelect = True
    SmallImages = ImageList1
    TabOrder = 2
    ViewStyle = vsReport
    OnDblClick = ListViewIDEsDblClick
    OnSelectItem = ListViewIDEsSelectItem
  end
  object ImageList1: TImageList
    Left = 88
    Top = 64
  end
end
