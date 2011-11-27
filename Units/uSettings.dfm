object FrmSettings: TFrmSettings
  Left = 504
  Top = 302
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 434
  ClientWidth = 445
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
    Width = 445
    Height = 399
    Align = alClient
    BorderWidth = 5
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 6
      Top = 6
      Width = 433
      Height = 387
      ActivePage = TabSheet4
      Align = alClient
      TabOrder = 0
      object TabSheet4: TTabSheet
        Caption = 'General'
        ImageIndex = 3
        object Label6: TLabel
          Left = 16
          Top = 13
          Width = 194
          Height = 13
          Caption = 'Output folder used for compiled projects'
        end
        object Label7: TLabel
          Left = 16
          Top = 108
          Width = 264
          Height = 87
          AutoSize = False
          Caption = 
            'This option delete the cache  of stored Namespaces and Wmi class' +
            'es used by the application to improve the performance. Use this ' +
            'option after your rebuild the WMI repository or when you install' +
            ' new WMI providers in the system'
          WordWrap = True
        end
        object EditOutputFolder: TEdit
          Left = 16
          Top = 32
          Width = 281
          Height = 21
          TabOrder = 1
        end
        object BtnSelFolderThemes: TButton
          Left = 303
          Top = 30
          Width = 26
          Height = 25
          Caption = '...'
          TabOrder = 0
          OnClick = BtnSelFolderThemesClick
        end
        object BtnDeleteCache: TButton
          Left = 16
          Top = 77
          Width = 264
          Height = 25
          Caption = 'Delete Cache'
          TabOrder = 2
          OnClick = BtnDeleteCacheClick
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Delphi Code generation'
        ImageIndex = 1
        object Label4: TLabel
          Left = 3
          Top = 35
          Width = 106
          Height = 13
          Caption = 'Delphi WMI class code'
        end
        object LabelDescr: TLabel
          Left = 152
          Top = 59
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object Label5: TLabel
          Left = 3
          Top = 275
          Width = 116
          Height = 13
          Caption = 'Delphi WMI events code'
        end
        object LabelDescrEvent: TLabel
          Left = 152
          Top = 307
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object LabelDescrMethod: TLabel
          Left = 152
          Top = 177
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object Label8: TLabel
          Left = 3
          Top = 145
          Width = 124
          Height = 13
          Caption = 'Delphi WMI methods code'
        end
        object CbDelphiCodeWmiClass: TComboBox
          Left = 152
          Top = 35
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = CbDelphiCodeWmiClassChange
        end
        object CheckBoxHelper: TCheckBox
          Left = 3
          Top = 12
          Width = 350
          Height = 17
          Caption = 'Create Helper functions in generated code to handle null values'
          TabOrder = 0
        end
        object CbDelphiCodeWmiEvent: TComboBox
          Left = 152
          Top = 272
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnChange = CbDelphiCodeWmiEventChange
        end
        object CbDelphiCodeWmiMethod: TComboBox
          Left = 152
          Top = 142
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 2
          OnChange = CbDelphiCodeWmiMethodChange
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Theme Settings'
        object Label1: TLabel
          Left = 11
          Top = 8
          Width = 127
          Height = 13
          Caption = 'Syntax Highlighting Theme'
        end
        object Label2: TLabel
          Left = 11
          Top = 51
          Width = 81
          Height = 13
          Caption = 'Code Editor Font'
        end
        object Label3: TLabel
          Left = 219
          Top = 51
          Width = 19
          Height = 13
          Caption = 'Size'
        end
        object Label9: TLabel
          Left = 11
          Top = 97
          Width = 45
          Height = 13
          Caption = 'VCL Style'
        end
        object ComboBoxTheme: TComboBox
          Left = 11
          Top = 27
          Width = 254
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = ComboBoxThemeChange
        end
        object EditFontSize: TEdit
          Left = 219
          Top = 70
          Width = 32
          Height = 21
          ReadOnly = True
          TabOrder = 3
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
          TabOrder = 4
        end
        object ComboBoxFont: TComboBox
          Left = 11
          Top = 70
          Width = 202
          Height = 21
          Style = csDropDownList
          TabOrder = 2
          OnChange = ComboBoxFontChange
        end
        object ButtonGetMore: TButton
          Left = 271
          Top = 25
          Width = 98
          Height = 25
          Caption = 'Get more themes'
          TabOrder = 0
          OnClick = ButtonGetMoreClick
        end
        object ComboBoxVCLStyle: TComboBox
          Left = 11
          Top = 116
          Width = 202
          Height = 21
          Style = csDropDownList
          TabOrder = 5
          OnChange = ComboBoxVCLStyleChange
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
    Top = 399
    Width = 445
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
