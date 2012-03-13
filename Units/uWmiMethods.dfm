object FrmWmiMethods: TFrmWmiMethods
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 504
  ClientWidth = 998
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
  object Splitter5: TSplitter
    Left = 393
    Top = 0
    Width = 5
    Height = 504
    ExplicitLeft = 405
    ExplicitHeight = 473
  end
  object PanelMethodInfo: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 504
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      393
      504)
    object Label4: TLabel
      Left = 11
      Top = 18
      Width = 60
      Height = 13
      Caption = 'Namespaces'
    end
    object Label6: TLabel
      Left = 11
      Top = 197
      Width = 84
      Height = 13
      Caption = 'Input Parameters'
    end
    object LabelClassesMethods: TLabel
      Left = 11
      Top = 45
      Width = 36
      Height = 13
      Caption = 'Classes'
    end
    object LabelMethods: TLabel
      Left = 11
      Top = 72
      Width = 41
      Height = 13
      Caption = 'Methods'
    end
    object ComboBoxClassesMethods: TComboBox
      Left = 103
      Top = 45
      Width = 276
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DoubleBuffered = False
      DropDownCount = 20
      ParentDoubleBuffered = False
      Sorted = True
      TabOrder = 1
      OnChange = ComboBoxClassesMethodsChange
    end
    object ComboBoxMethods: TComboBox
      Left = 103
      Top = 72
      Width = 276
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      Sorted = True
      TabOrder = 2
      OnChange = ComboBoxMethodsChange
    end
    object ComboBoxNamespaceMethods: TComboBox
      Left = 103
      Top = 18
      Width = 276
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 0
      OnChange = ComboBoxNamespaceMethodsChange
    end
    object ListViewMethodsParams: TListView
      Left = 10
      Top = 216
      Width = 368
      Height = 247
      Anchors = [akLeft, akTop, akRight, akBottom]
      Checkboxes = True
      Columns = <
        item
          Caption = 'Parameter'
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
          Caption = 'Value'
          Width = 150
        end
        item
          Caption = 'Description'
          Width = 250
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 6
      ViewStyle = vsReport
      OnClick = ListViewMethodsParamsClick
    end
    object MemoMethodDescr: TMemo
      Left = 11
      Top = 130
      Width = 367
      Height = 68
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object EditValueMethodParam: TEdit
      Left = 103
      Top = 290
      Width = 121
      Height = 21
      TabOrder = 7
      Visible = False
      OnExit = EditValueMethodParamExit
    end
    object ButtonGenerateCodeInvoker: TButton
      Left = 248
      Top = 469
      Width = 130
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Generate Code'
      TabOrder = 8
      OnClick = ButtonGenerateCodeInvokerClick
    end
    object ComboBoxPaths: TComboBox
      Left = 103
      Top = 99
      Width = 275
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      OnChange = ComboBoxPathsChange
    end
    object CheckBoxPath: TCheckBox
      Left = 11
      Top = 99
      Width = 69
      Height = 17
      Caption = 'Instances'
      TabOrder = 3
      OnClick = CheckBoxPathClick
    end
  end
  object PanelMethodCode: TPanel
    Left = 398
    Top = 0
    Width = 600
    Height = 504
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
  end
end
