object FrmWmiClasses: TFrmWmiClasses
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 635
  ClientWidth = 1113
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 308
    Top = 0
    Width = 5
    Height = 635
    ExplicitLeft = 289
    ExplicitHeight = 704
  end
  object PanelMetaWmiInfo: TPanel
    Left = 0
    Top = 0
    Width = 308
    Height = 635
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      308
      635)
    object LabelProperties: TLabel
      Left = 9
      Top = 142
      Width = 49
      Height = 13
      Caption = 'Properties'
    end
    object LabelClasses: TLabel
      Left = 9
      Top = 35
      Width = 36
      Height = 13
      Caption = 'Classes'
    end
    object LabelNamespace: TLabel
      Left = 9
      Top = 5
      Width = 60
      Height = 13
      Caption = 'Namespaces'
    end
    object ComboBoxClasses: TComboBox
      Left = 101
      Top = 32
      Width = 201
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 1
      OnChange = ComboBoxClassesChange
    end
    object ComboBoxNameSpaces: TComboBox
      Left = 101
      Top = 5
      Width = 200
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 0
      OnChange = ComboBoxNameSpacesChange
    end
    object CheckBoxSelAllProps: TCheckBox
      Left = 9
      Top = 169
      Width = 114
      Height = 17
      Caption = 'Select all Properties'
      TabOrder = 4
      OnClick = CheckBoxSelAllPropsClick
    end
    object MemoClassDescr: TMemo
      Left = 9
      Top = 59
      Width = 293
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object ListViewProperties: TListView
      Left = 7
      Top = 192
      Width = 295
      Height = 433
      Anchors = [akLeft, akTop, akRight, akBottom]
      Checkboxes = True
      Columns = <
        item
          Caption = 'Property'
          Width = -1
          WidthType = (
            -1)
        end
        item
          Caption = 'Type'
          Width = -1
          WidthType = (
            -1)
        end
        item
          Caption = 'Description'
          Width = -1
          WidthType = (
            -1)
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 5
      ViewStyle = vsReport
      OnClick = ListViewPropertiesClick
    end
    object ButtonGetValues: TButton
      Left = 128
      Top = 161
      Width = 174
      Height = 25
      Caption = 'Get Properties Values'
      ImageIndex = 15
      TabOrder = 3
      OnClick = ButtonGetValuesClick
    end
  end
  object PanelCode: TPanel
    Left = 313
    Top = 0
    Width = 800
    Height = 635
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
  end
end
