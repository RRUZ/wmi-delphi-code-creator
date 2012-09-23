object FrmSettings: TFrmSettings
  Left = 504
  Top = 302
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 471
  ClientWidth = 596
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
    Width = 596
    Height = 436
    Align = alClient
    BorderWidth = 5
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 6
      Top = 6
      Width = 584
      Height = 424
      ActivePage = TabSheet4
      Align = alClient
      TabOrder = 0
      object TabSheet4: TTabSheet
        Caption = 'General'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label6: TLabel
          Left = 16
          Top = 13
          Width = 194
          Height = 13
          Caption = 'Output folder used for compiled projects'
        end
        object Label7: TLabel
          Left = 16
          Top = 260
          Width = 264
          Height = 87
          AutoSize = False
          Caption = 
            'This option delete the cache  of stored Namespaces and Wmi class' +
            'es used by the application to improve the performance. Use this ' +
            'option after your rebuild the WMI repository or when you install' +
            ' new WMI providers in the system.'
          WordWrap = True
        end
        object Label10: TLabel
          Left = 16
          Top = 59
          Width = 84
          Height = 13
          Caption = 'Source Formatter'
        end
        object Label11: TLabel
          Left = 16
          Top = 147
          Width = 150
          Height = 13
          Caption = 'Default Programming Language'
        end
        object Label12: TLabel
          Left = 16
          Top = 78
          Width = 276
          Height = 13
          Caption = 'RAD Studio Source Formatter (Delphi, FPC, Borland C++)'
        end
        object Label13: TLabel
          Left = 320
          Top = 78
          Width = 134
          Height = 13
          Caption = 'AStyle (Microsoft C++, C#)'
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
          Top = 221
          Width = 264
          Height = 25
          Caption = 'Delete Cache'
          TabOrder = 6
          OnClick = BtnDeleteCacheClick
        end
        object CbFormatter: TComboBox
          Left = 16
          Top = 97
          Width = 281
          Height = 21
          Style = csDropDownList
          TabOrder = 2
        end
        object CheckBoxUpdates: TCheckBox
          Left = 16
          Top = 124
          Width = 177
          Height = 17
          Caption = 'Check for updates in the startup'
          TabOrder = 4
        end
        object ComboBoxLanguageSel: TComboBox
          Left = 16
          Top = 166
          Width = 220
          Height = 21
          Style = csDropDownList
          TabOrder = 5
        end
        object EditAStyle: TEdit
          Left = 320
          Top = 97
          Width = 225
          Height = 21
          TabOrder = 3
        end
        object GroupBox1: TGroupBox
          Left = 320
          Top = 124
          Width = 225
          Height = 63
          Caption = 'Additional Settings'
          TabOrder = 7
          object CheckBoxOnlineMSDN: TCheckBox
            Left = 16
            Top = 16
            Width = 206
            Height = 33
            Caption = 'Enable retrieve online  MSDN documentation in WMI Classes Tree '
            TabOrder = 0
            WordWrap = True
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Object Pascal Code generation'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label4: TLabel
          Left = 3
          Top = 99
          Width = 106
          Height = 13
          Caption = 'Delphi WMI class code'
        end
        object LabelDescr: TLabel
          Left = 152
          Top = 123
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object Label5: TLabel
          Left = 3
          Top = 299
          Width = 116
          Height = 13
          Caption = 'Delphi WMI events code'
        end
        object LabelDescrEvent: TLabel
          Left = 152
          Top = 331
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object LabelDescrMethod: TLabel
          Left = 152
          Top = 225
          Width = 225
          Height = 49
          AutoSize = False
          Caption = 'LabelDescr'
          WordWrap = True
        end
        object Label8: TLabel
          Left = 3
          Top = 201
          Width = 124
          Height = 13
          Caption = 'Delphi WMI methods code'
        end
        object CbDelphiCodeWmiClass: TComboBox
          Left = 152
          Top = 96
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = CbDelphiCodeWmiClassChange
        end
        object CheckBoxDelphiHelperFunc: TCheckBox
          Left = 3
          Top = 73
          Width = 398
          Height = 17
          Caption = 
            'Create Helper functions in generated delphi code for know values' +
            ' of properties'
          TabOrder = 0
        end
        object CbDelphiCodeWmiEvent: TComboBox
          Left = 152
          Top = 296
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnChange = CbDelphiCodeWmiEventChange
        end
        object CbDelphiCodeWmiMethod: TComboBox
          Left = 152
          Top = 198
          Width = 225
          Height = 21
          Style = csDropDownList
          TabOrder = 2
          OnChange = CbDelphiCodeWmiMethodChange
        end
        object CheckBoxFPCHelperFunc: TCheckBox
          Left = 3
          Top = 25
          Width = 430
          Height = 17
          Caption = 
            'Create Helper functions in generated Free Pascal code for know v' +
            'alues of properties'
          TabOrder = 4
        end
      end
      object TabSheet1: TTabSheet
        BorderWidth = 8
        Caption = 'GUI Settings'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object PageControl2: TPageControl
          Left = 0
          Top = 0
          Width = 560
          Height = 380
          ActivePage = TabSheet6
          Align = alClient
          TabOrder = 0
          object TabSheet6: TTabSheet
            Caption = 'Themes (Vcl Styles)'
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Label9: TLabel
              Left = 3
              Top = 22
              Width = 45
              Height = 13
              Caption = 'VCL Style'
            end
            object CheckBoxDisableVClStylesNC: TCheckBox
              Left = 0
              Top = 0
              Width = 193
              Height = 17
              Caption = 'Disable VCL Styles in Non client Area.'
              TabOrder = 0
              OnClick = CheckBoxDisableVClStylesNCClick
            end
            object ComboBoxVCLStyle: TComboBox
              Left = 3
              Top = 41
              Width = 190
              Height = 21
              Style = csDropDownList
              TabOrder = 1
              OnChange = ComboBoxVCLStyleChange
            end
            object GroupBoxNonClient: TGroupBox
              Left = 266
              Top = 76
              Width = 280
              Height = 121
              Caption = 'Non client area'
              TabOrder = 2
              object EditNCImage: TEdit
                Left = 16
                Top = 91
                Width = 226
                Height = 21
                Enabled = False
                TabOrder = 0
              end
              object RadioButtonNCImage: TRadioButton
                Left = 16
                Top = 68
                Width = 75
                Height = 17
                Caption = 'Use Image'
                TabOrder = 1
              end
              object RadioButtonNCColor: TRadioButton
                Left = 16
                Top = 40
                Width = 81
                Height = 17
                Caption = 'Use Color'
                Checked = True
                TabOrder = 2
                TabStop = True
              end
              object ColorBoxNC: TColorBox
                Left = 97
                Top = 40
                Width = 145
                Height = 22
                Selected = clRed
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
                TabOrder = 3
                OnGetColors = ColorBoxNCGetColors
              end
              object BtnSetNCImage: TButton
                Left = 248
                Top = 89
                Width = 25
                Height = 25
                Caption = '...'
                Enabled = False
                TabOrder = 4
                OnClick = BtnSetNCImageClick
              end
              object CheckBoxNC: TCheckBox
                Left = 16
                Top = 17
                Width = 65
                Height = 17
                Caption = 'Enabled'
                TabOrder = 5
              end
            end
            object GroupBoxBackgroud: TGroupBox
              Left = 266
              Top = 203
              Width = 280
              Height = 121
              Caption = 'Background'
              TabOrder = 3
              object EditBackImage: TEdit
                Left = 16
                Top = 91
                Width = 226
                Height = 21
                Enabled = False
                TabOrder = 0
              end
              object RadioButtonBackImage: TRadioButton
                Left = 16
                Top = 68
                Width = 75
                Height = 17
                Caption = 'Use Image'
                TabOrder = 1
              end
              object RadioButtonBackColor: TRadioButton
                Left = 16
                Top = 40
                Width = 81
                Height = 17
                Caption = 'Use Color'
                Checked = True
                TabOrder = 2
                TabStop = True
              end
              object ColorBoxBack: TColorBox
                Left = 97
                Top = 40
                Width = 145
                Height = 22
                Selected = clRed
                Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames, cbCustomColors]
                TabOrder = 3
                OnGetColors = ColorBoxNCGetColors
              end
              object BtnSetBackImage: TButton
                Left = 248
                Top = 89
                Width = 25
                Height = 25
                Caption = '...'
                Enabled = False
                TabOrder = 4
                OnClick = BtnSetBackImageClick
              end
              object CheckBoxBack: TCheckBox
                Left = 16
                Top = 17
                Width = 65
                Height = 17
                Caption = 'Enabled'
                TabOrder = 5
              end
            end
            object CheckBoxFormCustom: TCheckBox
              Left = 266
              Top = 43
              Width = 280
              Height = 17
              Caption = 'Customize non client area and background'
              TabOrder = 4
              OnClick = CheckBoxFormCustomClick
            end
            object PanelPreview: TPanel
              Left = 3
              Top = 80
              Width = 257
              Height = 257
              BevelOuter = bvNone
              TabOrder = 5
            end
          end
          object TabSheet7: TTabSheet
            Caption = 'Syntax Highlighting'
            ImageIndex = 1
            ExplicitLeft = 0
            ExplicitTop = 0
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Label3: TLabel
              Left = 491
              Top = 8
              Width = 19
              Height = 13
              Caption = 'Size'
            end
            object Label2: TLabel
              Left = 375
              Top = 8
              Width = 81
              Height = 13
              Caption = 'Code Editor Font'
            end
            object Label1: TLabel
              Left = 133
              Top = 10
              Width = 127
              Height = 13
              Caption = 'Syntax Highlighting Theme'
            end
            object Label14: TLabel
              Left = 11
              Top = 10
              Width = 47
              Height = 13
              Caption = 'Language'
            end
            object SynEditCode: TSynEdit
              Left = 11
              Top = 56
              Width = 526
              Height = 283
              Align = alCustom
              Color = 4598550
              ActiveLineColor = clBlue
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Pitch = fpFixed
              Font.Style = []
              TabOrder = 6
              Gutter.Color = 4598550
              Gutter.BorderColor = clYellow
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWhite
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Gutter.ShowLineNumbers = True
              Gutter.GradientStartColor = 4539717
              Gutter.GradientEndColor = 2565927
              Highlighter = SynPasSyn1
              FontSmoothing = fsmNone
            end
            object UpDown1: TUpDown
              Left = 523
              Top = 27
              Width = 16
              Height = 21
              Associate = EditFontSize
              Min = 8
              Max = 48
              Position = 10
              TabOrder = 1
            end
            object EditFontSize: TEdit
              Left = 491
              Top = 27
              Width = 32
              Height = 21
              ReadOnly = True
              TabOrder = 0
              Text = '10'
              OnChange = ComboBoxFontChange
            end
            object ComboBoxFont: TComboBox
              Left = 375
              Top = 29
              Width = 110
              Height = 21
              Style = csDropDownList
              TabOrder = 5
              OnChange = ComboBoxFontChange
            end
            object ButtonGetMore: TButton
              Left = 271
              Top = 28
              Width = 98
              Height = 23
              Caption = 'Get more themes'
              TabOrder = 2
              OnClick = ButtonGetMoreClick
            end
            object ComboBoxTheme: TComboBox
              Left = 133
              Top = 29
              Width = 132
              Height = 21
              Style = csDropDownList
              TabOrder = 4
              OnChange = ComboBoxThemeChange
            end
            object ComboBoxLanguageThemes: TComboBox
              Left = 11
              Top = 29
              Width = 116
              Height = 21
              Style = csDropDownList
              TabOrder = 3
              OnChange = ComboBoxLanguageThemesChange
            end
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Wmi Methods settings '
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object CheckBoxShowImplMethods: TCheckBox
          Left = 3
          Top = 7
          Width = 182
          Height = 17
          Caption = 'Only show implemented methods'
          TabOrder = 0
        end
      end
      object TabSheet8: TTabSheet
        Caption = 'Compiler Options'
        ImageIndex = 5
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label18: TLabel
          Left = 8
          Top = 16
          Width = 225
          Height = 13
          Caption = 'Microsoft C++ Compiler Command-Line options'
        end
        object Label19: TLabel
          Left = 8
          Top = 125
          Width = 170
          Height = 13
          Caption = 'C# Compiler Command-Line options'
        end
        object EditMicrosoftCppSwitch: TMemo
          Left = 8
          Top = 35
          Width = 529
          Height = 78
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object EditCSharpSwitch: TMemo
          Left = 8
          Top = 144
          Width = 529
          Height = 89
          ScrollBars = ssBoth
          TabOrder = 1
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'Templates'
        ImageIndex = 4
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label15: TLabel
          Left = 11
          Top = 10
          Width = 47
          Height = 13
          Caption = 'Language'
        end
        object Label16: TLabel
          Left = 187
          Top = 10
          Width = 82
          Height = 13
          Caption = 'Mode Generation'
        end
        object Label17: TLabel
          Left = 363
          Top = 10
          Width = 77
          Height = 13
          Caption = 'WMI Type Code'
        end
        object ComboBoxLanguageTemplate: TComboBox
          Left = 11
          Top = 29
          Width = 170
          Height = 21
          Style = csDropDownList
          TabOrder = 0
        end
        object ComboBox1: TComboBox
          Left = 187
          Top = 29
          Width = 170
          Height = 21
          Style = csDropDownList
          TabOrder = 1
        end
        object ComboBox2: TComboBox
          Left = 363
          Top = 29
          Width = 170
          Height = 21
          Style = csDropDownList
          TabOrder = 2
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 436
    Width = 596
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
  object SynPasSyn1: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    AsmAttri.Background = 4598550
    AsmAttri.Foreground = clGreen
    CommentAttri.Background = 4598550
    CommentAttri.Foreground = 1159259
    DirectiveAttri.Background = 4598550
    DirectiveAttri.Foreground = clRed
    IdentifierAttri.Background = 4598550
    IdentifierAttri.Foreground = clWhite
    KeyAttri.Background = 4598550
    KeyAttri.Foreground = 16757826
    NumberAttri.Background = 2565927
    NumberAttri.Foreground = 2876908
    FloatAttri.Background = 4598550
    FloatAttri.Foreground = 2876908
    HexAttri.Background = 4598550
    HexAttri.Foreground = 2876908
    SpaceAttri.Background = 4598550
    SpaceAttri.Foreground = clBlack
    StringAttri.Background = 4598550
    StringAttri.Foreground = 2876908
    CharAttri.Background = 4598550
    CharAttri.Foreground = clWhite
    SymbolAttri.Background = 4598550
    SymbolAttri.Foreground = clWhite
    Left = 90
    Top = 262
  end
  object SynCSSyn1: TSynCSSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 48
    Top = 264
  end
  object SynCppSyn1: TSynCppSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 136
    Top = 264
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 120
    Top = 198
  end
  object SynSQLSyn1: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 296
    Top = 240
  end
end
