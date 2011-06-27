object FrmSettings: TFrmSettings
  Left = 504
  Top = 302
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 201
  ClientWidth = 398
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 398
    Height = 166
    Align = alClient
    BorderWidth = 5
    TabOrder = 0
    ExplicitLeft = 64
    ExplicitTop = 32
    ExplicitWidth = 185
    ExplicitHeight = 41
    object PageControl1: TPageControl
      Left = 6
      Top = 6
      Width = 386
      Height = 154
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = 'Delphi Code generation'
        ImageIndex = 1
        object Label4: TLabel
          Left = 3
          Top = 35
          Width = 108
          Height = 13
          Caption = 'Delphi WMI Class code'
        end
        object LabelDescr: TLabel
          Left = 128
          Top = 59
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object CbDelphiCodewmiClass: TComboBox
          Left = 128
          Top = 32
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = CbDelphiCodewmiClassChange
        end
        object CheckBoxHelper: TCheckBox
          Left = 3
          Top = 12
          Width = 350
          Height = 17
          Caption = 'Create Helper functions in generated code to handle null values'
          TabOrder = 1
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Theme Settings'
        object Label1: TLabel
          Left = 11
          Top = 8
          Width = 32
          Height = 13
          Caption = 'Theme'
        end
        object Label2: TLabel
          Left = 11
          Top = 51
          Width = 22
          Height = 13
          Caption = 'Font'
        end
        object Label3: TLabel
          Left = 219
          Top = 51
          Width = 19
          Height = 13
          Caption = 'Size'
        end
        object ComboBoxTheme: TComboBox
          Left = 11
          Top = 27
          Width = 254
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = ComboBoxThemeChange
        end
        object EditFontSize: TEdit
          Left = 219
          Top = 70
          Width = 32
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '10'
          OnChange = ComboBoxFontChange
        end
        object UpDown1: TUpDown
          Left = 251
          Top = 70
          Width = 16
          Height = 21
          Associate = EditFontSize
          Min = 8
          Max = 48
          Position = 10
          TabOrder = 2
        end
        object ComboBoxFont: TComboBox
          Left = 11
          Top = 70
          Width = 202
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnChange = ComboBoxFontChange
        end
        object ButtonGetMore: TButton
          Left = 271
          Top = 25
          Width = 98
          Height = 25
          Caption = 'Get more themes'
          TabOrder = 4
          OnClick = ButtonGetMoreClick
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Wmi Methods settings '
        ImageIndex = 2
        object CheckBoxShowImplMethods: TCheckBox
          Left = 3
          Top = 7
          Width = 182
          Height = 17
          Caption = 'Only show implemented methods'
          TabOrder = 0
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 166
    Width = 398
    Height = 35
    Align = alBottom
    TabOrder = 1
    object ButtonApply: TButton
      Left = 6
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 0
      OnClick = ButtonApplyClick
    end
    object ButtonCancel: TButton
      Left = 87
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = ButtonCancelClick
    end
  end
end
