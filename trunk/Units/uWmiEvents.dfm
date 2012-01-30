object FrmWmiEvents: TFrmWmiEvents
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmWmiEvents'
  ClientHeight = 472
  ClientWidth = 881
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
  object Splitter6: TSplitter
    Left = 416
    Top = 0
    Width = 5
    Height = 472
    ExplicitLeft = 402
    ExplicitHeight = 454
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 416
    Height = 472
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      416
      472)
    object LabelEventsConds: TLabel
      Left = 5
      Top = 157
      Width = 50
      Height = 13
      Caption = 'Conditions'
    end
    object LabelTargetInstance: TLabel
      Left = 5
      Top = 103
      Width = 77
      Height = 13
      Caption = 'Target Instance'
    end
    object LabelEvents: TLabel
      Left = 5
      Top = 76
      Width = 33
      Height = 13
      Caption = 'Events'
    end
    object Label2: TLabel
      Left = 5
      Top = 6
      Width = 60
      Height = 13
      Caption = 'Namespaces'
    end
    object Label3: TLabel
      Left = 5
      Top = 133
      Width = 73
      Height = 13
      Caption = 'Poll event each'
    end
    object Label5: TLabel
      Left = 151
      Top = 131
      Width = 40
      Height = 13
      Caption = 'Seconds'
    end
    object Label7: TLabel
      Left = 5
      Top = 29
      Width = 68
      Height = 13
      Caption = 'Type of Event'
    end
    object ListViewEventsConds: TListView
      Left = 5
      Top = 176
      Width = 405
      Height = 257
      Anchors = [akLeft, akTop, akRight, akBottom]
      Checkboxes = True
      Columns = <
        item
          Caption = 'Property'
          Width = 150
        end
        item
          Caption = 'Type'
          Width = 60
        end
        item
          Caption = 'Condition'
          Width = 150
        end
        item
          Caption = 'Value'
          Width = 60
        end
        item
          Caption = 'Description'
        end>
      HideSelection = False
      ReadOnly = True
      TabOrder = 6
      ViewStyle = vsReport
      OnClick = ListViewEventsCondsClick
    end
    object EditValueEvent: TEdit
      Left = 88
      Top = 235
      Width = 145
      Height = 21
      TabOrder = 8
      Visible = False
    end
    object ComboBoxCond: TComboBox
      Left = 88
      Top = 208
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 7
      Text = '='
      Visible = False
      OnExit = ComboBoxCondExit
      Items.Strings = (
        '='
        '>'
        '<'
        '<>'
        'ISA')
    end
    object ComboBoxNamespacesEvents: TComboBox
      Left = 97
      Top = 6
      Width = 313
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 0
      OnChange = ComboBoxNamespacesEventsChange
    end
    object ComboBoxEvents: TComboBox
      Left = 97
      Top = 76
      Width = 313
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      Sorted = True
      TabOrder = 3
      OnChange = ComboBoxEventsChange
    end
    object ComboBoxTargetInstance: TComboBox
      Left = 97
      Top = 103
      Width = 313
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      Sorted = True
      TabOrder = 4
      OnChange = ComboBoxTargetInstanceChange
    end
    object EditEventWait: TEdit
      Left = 97
      Top = 130
      Width = 48
      Height = 21
      TabOrder = 5
      Text = '1'
    end
    object ButtonGenerateEventCode: TButton
      Left = 288
      Top = 439
      Width = 122
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Generate Code'
      TabOrder = 9
      OnClick = ButtonGenerateEventCodeClick
    end
    object RadioButtonIntrinsic: TRadioButton
      Left = 5
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Intrinsic'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RadioButtonIntrinsicClick
    end
    object RadioButtonExtrinsic: TRadioButton
      Left = 127
      Top = 48
      Width = 113
      Height = 17
      Caption = 'Extrinsic'
      TabOrder = 2
      OnClick = RadioButtonIntrinsicClick
    end
  end
  object PanelEventCode: TPanel
    Left = 421
    Top = 0
    Width = 460
    Height = 472
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
  end
end
