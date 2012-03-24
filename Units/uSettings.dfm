object FrmSettings: TFrmSettings
  Left = 504
  Top = 302
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 475
  ClientWidth = 587
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
    Width = 587
    Height = 440
    Align = alClient
    BorderWidth = 5
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 6
      Top = 6
      Width = 575
      Height = 428
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
          Top = 175
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
          Top = 152
          Width = 177
          Height = 17
          Caption = 'Check for updates in the startup'
          TabOrder = 4
        end
        object ComboBoxLanguageSel: TComboBox
          Left = 16
          Top = 194
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
        Caption = 'GUI Settings'
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 567
          Height = 400
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object PageControl2: TPageControl
            Left = 5
            Top = 5
            Width = 557
            Height = 390
            ActivePage = TabSheet6
            Align = alClient
            TabOrder = 0
            object TabSheet6: TTabSheet
              Caption = 'Themes (Vcl Styles)'
              object Label9: TLabel
                Left = 3
                Top = 26
                Width = 45
                Height = 13
                Caption = 'VCL Style'
              end
              object ImageVCLStyle: TImage
                Left = 3
                Top = 72
                Width = 350
                Height = 246
                Transparent = True
              end
              object CheckBoxDisableVClStylesNC: TCheckBox
                Left = 3
                Top = 3
                Width = 396
                Height = 17
                Caption = 
                  'Disable VCL Styles in Non client Area (Only valid when Vcl Style' +
                  's are activated)'
                TabOrder = 0
                OnClick = CheckBoxDisableVClStylesNCClick
              end
              object ComboBoxVCLStyle: TComboBox
                Left = 3
                Top = 45
                Width = 254
                Height = 21
                Style = csDropDownList
                TabOrder = 1
                OnChange = ComboBoxVCLStyleChange
              end
            end
            object TabSheet7: TTabSheet
              Caption = 'Syntax Highlighting'
              ImageIndex = 1
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
                Width = 534
                Height = 300
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
      object TabSheet8: TTabSheet
        Caption = 'C++ Compiler Options'
        ImageIndex = 5
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
          Width = 266
          Height = 13
          Caption = 'Addiional Microsoft C++ compilers (register one by line)'
        end
        object EditMicrosoftCppSwitch: TMemo
          Left = 8
          Top = 35
          Width = 529
          Height = 78
          ScrollBars = ssBoth
          TabOrder = 0
        end
        object Memo1: TMemo
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
    Top = 440
    Width = 587
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
    Left = 218
    Top = 230
  end
  object SynCSSyn1: TSynCSSyn
    Left = 184
    Top = 232
  end
  object SynCppSyn1: TSynCppSyn
    Left = 248
    Top = 232
  end
end
