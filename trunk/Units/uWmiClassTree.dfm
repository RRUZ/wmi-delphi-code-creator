object FrmWmiClassTree: TFrmWmiClassTree
  Left = 576
  Top = 224
  BorderStyle = bsNone
  Caption = 'Wmi Classes Tree'
  ClientHeight = 507
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    534
    507)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Namespace'
  end
  object LabelStatus: TLabel
    Left = 8
    Top = 452
    Width = 56
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'LabelStatus'
    ExplicitTop = 575
  end
  object CbNamespaces: TComboBox
    Left = 8
    Top = 27
    Width = 313
    Height = 21
    Style = csDropDownList
    TabOrder = 0
    OnChange = CbNamespacesChange
  end
  object TreeViewClasses: TTreeView
    Left = 8
    Top = 54
    Width = 516
    Height = 394
    Anchors = [akLeft, akTop, akRight, akBottom]
    Indent = 19
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ExplicitWidth = 500
    ExplicitHeight = 356
  end
  object BtnFillTree: TButton
    Left = 327
    Top = 23
    Width = 75
    Height = 25
    Caption = 'Fill Tree'
    TabOrder = 2
    OnClick = BtnFillTreeClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 471
    Width = 516
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    ExplicitTop = 433
    ExplicitWidth = 500
  end
end
