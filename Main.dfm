object FrmMain: TFrmMain
  Left = 379
  Top = 129
  Caption = 'Wmi Delphi Code Creator'
  ClientHeight = 730
  ClientWidth = 1008
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMinimized
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 30
    Width = 1008
    Height = 681
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    ExplicitTop = 36
    object PageControlMain: TPageControl
      Left = 5
      Top = 5
      Width = 998
      Height = 671
      ActivePage = TabSheetCodeGen
      Align = alClient
      Images = ImageList1
      MultiLine = True
      TabOrder = 0
      OnChange = PageControlMainChange
      object TabSheetCodeGen: TTabSheet
        Caption = 'Code Generation'
        ImageIndex = 30
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 650
        object PanelCodeGen: TPanel
          Left = 0
          Top = 0
          Width = 990
          Height = 642
          Align = alClient
          BevelOuter = bvNone
          BevelWidth = 5
          TabOrder = 0
          ExplicitHeight = 650
          object Splitter4: TSplitter
            Left = 0
            Top = 474
            Width = 990
            Height = 5
            Cursor = crVSplit
            Align = alBottom
            ExplicitLeft = 5
            ExplicitTop = 5
            ExplicitWidth = 980
          end
          object PageControlCodeGen: TPageControl
            Left = 0
            Top = 41
            Width = 990
            Height = 433
            ActivePage = TabSheetWmiClasses
            Align = alClient
            Images = ImageList1
            MultiLine = True
            TabOrder = 1
            ExplicitHeight = 434
            object TabSheetWmiClasses: TTabSheet
              Caption = 'WMI Classes'
              ImageIndex = 40
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 412
              object Splitter1: TSplitter
                Left = 308
                Top = 0
                Width = 5
                Height = 404
                ExplicitLeft = 289
                ExplicitHeight = 704
              end
              object PanelMetaWmiInfo: TPanel
                Left = 0
                Top = 0
                Width = 308
                Height = 404
                Align = alLeft
                BevelOuter = bvNone
                TabOrder = 0
                ExplicitHeight = 406
                DesignSize = (
                  308
                  404)
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
                  Left = 8
                  Top = 169
                  Width = 118
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
                object ProgressBarWmi: TProgressBar
                  Left = 60
                  Top = 335
                  Width = 150
                  Height = 17
                  TabOrder = 6
                end
                object ListViewProperties: TListView
                  Left = 9
                  Top = 192
                  Width = 295
                  Height = 122
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
                    end>
                  ReadOnly = True
                  RowSelect = True
                  TabOrder = 5
                  ViewStyle = vsReport
                  OnClick = ListBoxPropertiesClick
                  ExplicitHeight = 124
                end
                object ButtonGetValues: TButton
                  Left = 128
                  Top = 161
                  Width = 174
                  Height = 25
                  Caption = 'Get Properties Values'
                  ImageIndex = 15
                  Images = ImageList1
                  TabOrder = 3
                  OnClick = ButtonGetValuesClick
                end
              end
              object PanelCode: TPanel
                Left = 313
                Top = 0
                Width = 669
                Height = 404
                Align = alClient
                BevelOuter = bvNone
                BorderWidth = 5
                TabOrder = 1
                ExplicitHeight = 412
                object PageControlCode: TPageControl
                  Left = 5
                  Top = 5
                  Width = 659
                  Height = 394
                  ActivePage = TabSheetDelphiCode
                  Align = alClient
                  TabOrder = 0
                  ExplicitHeight = 402
                  object TabSheetDelphiCode: TTabSheet
                    Caption = 'Code'
                    ExplicitHeight = 368
                    object SynEditDelphiCode: TSynEdit
                      Left = 0
                      Top = 0
                      Width = 651
                      Height = 366
                      Align = alClient
                      Color = 4598550
                      ActiveLineColor = clBlue
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -13
                      Font.Name = 'Consolas'
                      Font.Pitch = fpFixed
                      Font.Style = []
                      TabOrder = 0
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
                      ExplicitLeft = -3
                      ExplicitTop = 7
                    end
                  end
                end
              end
            end
            object TabSheetMethods: TTabSheet
              Caption = 'Execute a WMI method'
              ImageIndex = 41
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 412
              object Splitter5: TSplitter
                Left = 393
                Top = 0
                Width = 5
                Height = 404
                ExplicitLeft = 405
                ExplicitHeight = 473
              end
              object PanelMethodInfo: TPanel
                Left = 0
                Top = 0
                Width = 393
                Height = 404
                Align = alLeft
                BevelOuter = bvNone
                TabOrder = 0
                DesignSize = (
                  393
                  404)
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
                  Left = 11
                  Top = 216
                  Width = 368
                  Height = 66
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
                    end>
                  ReadOnly = True
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
                  Left = 37
                  Top = 239
                  Width = 121
                  Height = 21
                  TabOrder = 7
                  Visible = False
                  OnExit = EditValueMethodParamExit
                end
                object ButtonGenerateCodeInvoker: TButton
                  Left = 248
                  Top = 288
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
              object Panel3: TPanel
                Left = 398
                Top = 0
                Width = 584
                Height = 404
                Align = alClient
                BevelOuter = bvNone
                BorderWidth = 5
                TabOrder = 1
                ExplicitHeight = 412
                object PageControl1: TPageControl
                  Left = 5
                  Top = 5
                  Width = 574
                  Height = 394
                  ActivePage = TabSheet2
                  Align = alClient
                  TabOrder = 0
                  ExplicitHeight = 402
                  object TabSheet2: TTabSheet
                    Caption = 'Delphi Code'
                    object SynEditDelphiCodeInvoke: TSynEdit
                      Left = 0
                      Top = 0
                      Width = 566
                      Height = 366
                      Align = alClient
                      Color = 4598550
                      ActiveLineColor = clBlue
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -13
                      Font.Name = 'Consolas'
                      Font.Pitch = fpFixed
                      Font.Style = []
                      TabOrder = 0
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
                  end
                end
              end
            end
            object TabSheetEvents: TTabSheet
              Caption = 'Receive a WMI Event'
              ImageIndex = 45
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 412
              object Splitter6: TSplitter
                Left = 416
                Top = 0
                Width = 5
                Height = 404
                ExplicitLeft = 402
                ExplicitHeight = 454
              end
              object Panel1: TPanel
                Left = 0
                Top = 0
                Width = 416
                Height = 404
                Align = alLeft
                BevelOuter = bvNone
                TabOrder = 0
                ExplicitHeight = 412
                DesignSize = (
                  416
                  404)
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
                  Height = 111
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
                    end>
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
                  OnExit = EditValueEventExit
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
                  Top = 293
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
              object Panel5: TPanel
                Left = 421
                Top = 0
                Width = 561
                Height = 404
                Align = alClient
                BevelOuter = bvNone
                BorderWidth = 5
                TabOrder = 1
                ExplicitHeight = 412
                object PageControl3: TPageControl
                  Left = 5
                  Top = 5
                  Width = 551
                  Height = 394
                  ActivePage = TabSheet1
                  Align = alClient
                  TabOrder = 0
                  ExplicitHeight = 402
                  object TabSheet1: TTabSheet
                    Caption = 'Delphi Code'
                    object SynEditEventCode: TSynEdit
                      Left = 0
                      Top = 0
                      Width = 543
                      Height = 366
                      Align = alClient
                      Color = 4598550
                      ActiveLineColor = clBlue
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWindowText
                      Font.Height = -13
                      Font.Name = 'Consolas'
                      Font.Pitch = fpFixed
                      Font.Style = []
                      TabOrder = 0
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
                  end
                end
              end
            end
          end
          object PanelConsole: TPanel
            Left = 0
            Top = 479
            Width = 990
            Height = 163
            Align = alBottom
            BevelOuter = bvNone
            BorderWidth = 5
            TabOrder = 2
            ExplicitTop = 487
            object PageControl2: TPageControl
              Left = 5
              Top = 5
              Width = 980
              Height = 153
              ActivePage = TabSheet3
              Align = alClient
              Images = ImageList1
              TabOrder = 0
              object TabSheet3: TTabSheet
                Caption = 'Console Output'
                ImageIndex = 17
                ExplicitTop = 24
                ExplicitHeight = 125
                object MemoConsole: TMemo
                  Left = 0
                  Top = 0
                  Width = 972
                  Height = 124
                  Align = alClient
                  Color = clGray
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWhite
                  Font.Height = -12
                  Font.Name = 'Consolas'
                  Font.Style = []
                  ParentFont = False
                  ScrollBars = ssBoth
                  TabOrder = 0
                  ExplicitHeight = 125
                end
              end
            end
          end
          object PanelLanguageSet: TPanel
            Left = 0
            Top = 0
            Width = 990
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object Label8: TLabel
              Left = 5
              Top = 14
              Width = 47
              Height = 13
              Caption = 'Language'
            end
            object ComboBoxLanguageSel: TComboBox
              Left = 64
              Top = 14
              Width = 220
              Height = 21
              Style = csDropDownList
              TabOrder = 0
              OnChange = ComboBoxLanguageSelChange
            end
          end
        end
      end
      object TabSheetWmiExplorer: TTabSheet
        Caption = 'Wmi Explorer'
        ImageIndex = 29
      end
      object TabSheetTreeClasses: TTabSheet
        Caption = 'WMI Classes Tree'
        ImageIndex = 43
      end
      object TabSheetWmiDatabase: TTabSheet
        Caption = 'WMI Database'
        ImageIndex = 31
      end
      object TabSheet6: TTabSheet
        Caption = 'Log'
        ImageIndex = 28
        object MemoLog: TMemo
          Left = 0
          Top = 0
          Width = 990
          Height = 642
          Align = alClient
          Color = clBlack
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 711
    Width = 1008
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Style = psOwnerDraw
        Width = 150
      end
      item
        Alignment = taRightJustify
        Width = 250
      end>
    OnDrawPanel = StatusBar1DrawPanel
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 1008
    Height = 30
    AutoSize = True
    ButtonHeight = 30
    ButtonWidth = 114
    Caption = 'ToolBarMain'
    Color = clBtnFace
    DrawingStyle = dsGradient
    Images = ImageList1
    List = True
    GradientDirection = gdHorizontal
    ParentColor = False
    ShowCaptions = True
    TabOrder = 0
    object ToolButtonRun: TToolButton
      Tag = 1
      Left = 0
      Top = 0
      AutoSize = True
      Caption = 'Execute Code'
      DropdownMenu = PopupMenu1
      ImageIndex = 27
      Style = tbsDropDown
      OnClick = ToolButtonRunClick
    end
    object ToolButtonSave: TToolButton
      Left = 119
      Top = 0
      AutoSize = True
      Caption = 'Save'
      ImageIndex = 14
      OnClick = ToolButtonSaveClick
    end
    object ToolButtonSearch: TToolButton
      Left = 174
      Top = 0
      AutoSize = True
      Caption = 'Search'
      ImageIndex = 13
      OnClick = ToolButtonSearchClick
    end
    object ToolButtonGetValues: TToolButton
      Left = 238
      Top = 0
      AutoSize = True
      Caption = 'Get Values'
      ImageIndex = 15
      OnClick = ToolButtonGetValuesClick
    end
    object ToolButtonOnline: TToolButton
      Left = 320
      Top = 0
      AutoSize = True
      Caption = 'Online Class Info'
      ImageIndex = 16
      OnClick = ToolButtonOnlineClick
    end
    object ToolButtonSettings: TToolButton
      Left = 432
      Top = 0
      AutoSize = True
      Caption = 'Settings'
      ImageIndex = 46
      OnClick = ToolButtonSettingsClick
    end
    object ToolButton4: TToolButton
      Left = 502
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButtonAbout: TToolButton
      Left = 510
      Top = 0
      AutoSize = True
      Caption = 'About'
      ImageIndex = 12
      OnClick = ToolButtonAboutClick
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
    Left = 530
    Top = 198
  end
  object SaveDialog1: TSaveDialog
    FileName = 'GetWMI_Info.dpr'
    Filter = 'Delphi Project files|*.dpr'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 832
    Top = 254
  end
  object PopupMenu1: TPopupMenu
    Images = ImageList1
    Left = 474
    Top = 196
    object CompileCode1: TMenuItem
      Caption = 'Compile Code'
      ImageIndex = 21
      OnClick = ToolButtonRunClick
    end
    object Run1: TMenuItem
      Tag = 1
      Caption = 'Compile Code and Run'
      ImageIndex = 23
      OnClick = ToolButtonRunClick
    end
    object OpeninDelphi1: TMenuItem
      Caption = 'Open in IDE'
      ImageIndex = 26
      OnClick = OpeninDelphi1Click
    end
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 423
    Top = 198
    Bitmap = {
      494C01012F007800480110001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000C0000000010020000000000000C0
      00000000000000000000000000000000000000000000000000000000011F0303
      105C0707279A080841D1040420980000000D0000011E00000A5700001D910000
      38CA000063F900001782000000060000000000000000000000000107084C0416
      197D082A30AF0B3F49DB062329AD0000000D0001011F010A0C58031C21920C3A
      43CC126376FA02161B8200000006000000000000000000000000000000000000
      000000000000000000002623208D685E57E8463F36D8000000180101011C0202
      0225000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000007071B75232371E03838A4FE4545
      C1FF5151DEFF3D3DDCFF090982FF06065BF70D0D7BFE1D1D94FF3334AFFF5154
      CFFF2F30BFFF00007CFF010120970000000F071D21851F6674E13494A5FE42AF
      BFFF48C8DBFF3CC8DFFF11687AFF0F5261F7187487FE278EA2FF3DABC1FF59C9
      DEFF43BCD5FF0C6C83FF051F25970000000F0000000000000000000000000000
      0000000000000101011C766C62FDD3C0B2FF91806CFF3C3631C6746D65FD7066
      5AFF1F1C1A920000000500000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000222258D49696FFFF8989FFFF7B7B
      FDFF7171FAFF4949DDFF0A0A94FF14149FFF3C3ECAFF4344C9FF4D4DCDFF585A
      CEFF2E2FB7FF00009EFF010181FF0202229D144953D68AF5FFFF7BE8FDFF6EE4
      F5FF64E1F2FF48CADFFF14748AFF2498AFFF46C4DDFF4CC2D9FF53C6D9FF5DC7
      DFFF40B6CCFF129BB7FF0F7287FF051B1F8C00000000000000000A0908632D28
      24B74F453DDD201D1AC57A6F65FFCCC0B6FFB7A99AFF80756DFFD1C0B4FFB9AB
      9DFF5E5447FF0000000F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002D2D63DFA1A1FFFF8F8FFCFF8383
      F9FF7979F9FF4F4FDBFF090994FF13139BFF2C2EBDFF3435C2FF3D3EC2FF4B4D
      CCFF2C2CBBFF000096FF00009EFF03034AE419545FE097F3FFFF84E5F9FF78E3
      F2FF70E2F1FF4FCCDFFF147588FF2295ABFF39B6CDFF3FBBD4FF46BBD3FF52C5
      D9FF3AB3CCFF1291ACFF149AB7FF09424FE400000000000000001D1B189EA89E
      95FFD7CDC3FFD6CBC0FFC4B7AAFFB4A79CFFC5B8ACFFD9C9BCFFCFC5BAFFA395
      82FF433A30E10000000B00000002000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000353572EAACACFFFF9A9AFCFF8E8E
      F9FF8585F9FF5656DDFF0A0A95FF0D0D91FF2020B4FF2829B9FF3C3DC5FF5B5D
      DEFF2C2CBBFF000093FF000098FF03034CE81F606CEAA3F3FFFF91E9F8FF86E6
      F3FF7BE5F2FF57CCE0FF13758AFF198296FF2DACC5FF35B3CAFF46BDD6FF5ACE
      E3FF37B2C9FF0F88A3FF1391ABFF094552E6000000000000000006060546958C
      84FFCCBEB2FFB5A79BFF8E7E6EFF887A6EFF998A79FFB29F8FFFD4C4B8FF8B80
      74FF746A60FF665E56FF0D0C0B7E000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003E3E80F2B7B7FFFFA4A4FCFF9B9B
      F9FF9393FAFF5F5FDEFF09098FFF070786FF1111A4FF2020AFFF3B3AC5FF3738
      C2FF1C1CABFF00008CFF000093FF010152F1296C7AF4B1F5FFFF9CEDFAFF93E8
      F4FF8AE8F4FF61CEE2FF106C7EFF136F83FF1B89A1FF2DA7C0FF44BCD1FF41BA
      D4FF2FA5BEFF0F8098FF1088A2FF0A4755EF00000000000000001918168C9F9B
      97FFC1B2A4FFA8988AFFBDAA9CFFBEAE9FFFCABAACFFA69789FFB5A393FFC8B9
      ACFFC1B0A3FFD6C3B5FF3E3932FF0000000E0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C4C91FDC7C7FFFFB4B4FEFF9999
      F7FF7878EBFF4444D0FF070789FF020286FF090991FF1111A1FF1514A5FF1819
      AFFF0F0FA6FF00008DFF00008CFF000053F7357B8AFDC2FBFFFFACF1FBFF93E7
      F2FF74DAEAFF49C1D8FF147A90FF127183FF137184FF1A849BFF249FB9FF27A9
      C3FF21A1BBFF127E95FF0E7D96FF084A58F7010101235C5751E59F9B94FFDED6
      CEFF938779FFD9CFC5FFA29585FF625A51FF9F9790FFB7A79AFFA39181FFCCBC
      AEFFB8A89AFFB09E8BFF544C42FD0000001A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000484887F67575E5FF4F4FEEFF3333
      CFFF5757E3FF6363E9FF6C6CF2FF7272FDFF6D6DFFFF1D1DB5FF0C0CA1FF0B0B
      9BFF0A0AA3FF0808A8FF010199FF00005BFE2A6E7BF565CEDFFF47D4EAFF2CAD
      C2FF51CCE1FF5DD3E5FF64DCEFFF66E5FAFF62E6FCFF288E9EFF166A7BFF1B8D
      A5FF1D9DB8FF1CA2BEFF1590A9FF0A5362FE05040441AEA9A4FFF9F4EDFFC9C6
      C1FFACA49DFFDBD9D6FF51493FFF000000005A5654E5BDAB9BFF9B8977FFCEC1
      B2FF75685AFF4E4537EB0706054C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000202042F1C1C369D4C4C8FF63D3D
      A9FF9696FFFF9090FFFF8686FBFF7979F9FF7474F9FF1A1AB3FF0B0BA4FF0909
      A2FF06066FFF02026BFE000054E50000229A020A0B550E2C329C2F7C88F53094
      A6FF8BEFFBFF87EBFAFF7AE6FAFF71E1F7FF6BE3F9FF288D9FFF1C6E7DFF1260
      6DFF105E6FFF0F6477FD0B5160E4031C228E0202022E99938CFCEAE6E2FFD1CF
      CCFFC3C1BDFFE9E6E4FF4D453BFF0404043B948F8CFDCDC2B6FFAE9D8DFFCABB
      ACFF6A6154FF1B1813A600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000122525
      56D6A3A3FEFF9999FDFF9090FAFF8585FAFF8282F9FF1B1BB2FF0C0CA4FF0909
      A3FF020241DA0000000A00000000000000000000000000000000000000111549
      53D797ECFAFF8FE9FBFF86E6F9FF7CE3F7FF76E7F9FF278C9DFF1C7081FF1B6F
      81FF09333AE10000000A0000000000000000000000000202022385827FFBE3E1
      DEFFBEBBB7FFFAF8F6FFB2ACA2FF86817CFFEFEDEBFFD2CBC5FFC8BDB2FFD5CB
      C1FFD2C3B6FF7E7365FE1F1D19B1000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002121
      4FC8AEAEFFFFA1A1FDFF9898FAFF8E8EF9FF8B8BF9FF1A1AB1FF0C0CA3FF0909
      A2FF010144D80000000000000000000000000000000000000000000000000F41
      4AC9A6F0FDFF9AEBFBFF92E9FAFF89E7F7FF84EAF9FF278C9FFF1C7184FF1B71
      84FF08383FE0000000000000000000000000000000000808074B67635FDAFFFF
      FEFFACA498FFD5D2CEFFEFEEECFFEBEBE8FFD8D6D4FFD8D2CEFFD7CDC4FFDCD2
      C9FFE4D9D0FF9D9080FF292520C8000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002626
      53C8BDBDFFFFAEAEFDFFA4A4FAFF9C9CFAFF9898FBFF1C1CAEFF0C0CA2FF0909
      A1FF020247DD0000000000000000000000000000000000000000000000001145
      4FCEB6F6FFFFA7EFFDFF9EECFBFF95EBF8FF93EEF9FF278D9DFF1D7384FF1B74
      84FF093A45E400000000000000000000000000000000696560F1E4D9CAFFF3ED
      E6FFE7E2DCFFB8AEA1FFC9C4BCFFE2DFDBFFE5E4E1FFF2F2EFFFC7BFB6FF6157
      4AFF746C61FF544C40FD07070657000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002929
      59CED0D0FFFFBDBDFFFFACACFAFF9797F5FF8282EEFF1C1CB1FF0B0BA1FF0909
      A0FF03034DE20000000000000000000000000000000000000000000000001549
      53D2CDFFFFFFB8F4FFFFA8EEFBFF93E9F4FF82E6F1FF2894A9FF1C7284FF1A72
      84FF0A404BE700000000000000000000000000000000211E1B9EABA79FFF8F85
      79FFC6C1BDFFFAF7F4FFEDEAE4FFF0ECE9FFFEFDFBFFF8F4F0FFA09383FF2B28
      22CC0000001E0101012700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002525
      4CBF7070CEFF5858E1FF4343E6FF3939DAFF3232D2FF2C2CCBFF1F1FBAFF0E0E
      A3FF02024EDF0000000000000000000000000000000000000000000000001341
      4BC65DB9C9FF4ECCE0FF44D5ECFF3FCEE6FF3DCBE3FF3CCBE4FF35B8D1FF2590
      A5FF0E4550DB0000000000000000000000000000000002020128060605510B0A
      096EB1AAA2FFEAE3DAFFCCC3B8FF92897DFFE3DCD2FFEDE6DCFF90867BFF201D
      19AF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      02290B0B19741D1D3DB03C3C75EA31318CFC16166AEA0E0E4FD507073ABF0303
      2BA90000094B0000000000000000000000000000000000000000000000000005
      0641051214650F3036A7276772E82C8493FC1F6774E8154B54CF0F373EB70A29
      2F9F02090A4A0000000000000000000000000000000000000000000000000101
      0118958F89FFE8DDCEFF7C7269FF262320C2969492F2C7BCADFF685D4FFF0F0E
      0C7A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000224232280595551E434302BE9000000190B0B0B541E1B169E0C0A09690000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000001011D040E
      0F5A082327980C3943CF061C20960000000C0001001E00090357031A09910A35
      16CB0C5A1FF9011E099D000000050000000000000000000000000101001F170E
      037D291A06AE3A2406DA1A1104980000000D030200340C0700671C0F009C2F1A
      00D04F2D02FA120A01810000000600000000000000000000000000020020030F
      065D07230F9B093B17D3041C0C9A0000000D0001001F000A0359021A09930A36
      16CC0B5B1FFA01140682000000060000000000000000000000000101001E0B09
      085B1816139924211BCF11100E980000000D0000001D050404560E0D0A90201D
      1ACA342F28F90B0908810000000600000000061316641F6571DE3394A5FE42AD
      BDFF48C6D9FF3BC7DFFF147084FF094030F6116B27FE20883CFF36A552FF51C5
      6DFF38B456FF087324FF062B0FB80000000C1E140685694819E09A6B2AFEB781
      37FFD1923DFFC9852EFF683F0DFF4A2D08F769410FFE80551DFF9C6D32FFA579
      40FFA77130FF583304FF190F03960000000E06160A671D6C31E12F994CFE3EB6
      5DFF44D16AFF37CD5EFF106C29FF0B501CF7146F2BFE20893CFF36A553FF51C5
      6DFF3BB558FF096F22FF031C0A980000000F14120F74524B41DF7B7163FE9086
      76FFA69B8AFF998F7EFF3D3832FF2E2A26F6484036FE5C5449FF786E63FF9A90
      83FF82776DFF3B3630FF0F0E0C960000000E26545ACC87F4FFFF7BE8FDFF6EE4
      F5FF63E1F2FF47C9DFFF177E97FF187259FF3BB75AFF45C064FF4BC069FF55C6
      73FF37AD55FF0A8A2BFF0E7C2AFF08240FA8573E1ED5FFC97EFFF9C172FFF4B5
      64FFEFAE5AFFCC8C3BFF77470FFF8B5817FFB4813BFFB68441FFB88849FFBE91
      54FFA06E2FFF7B4807FF5C3606FF190F039220582FD485FFA5FF78F49AFF6CF1
      8FFF5FEC84FF43CF67FF137B2FFF188834FF3DBF5FFF44BE63FF4BC069FF55C4
      73FF38AE56FF0A8A2BFF096D25FF0418098C46423CCFDFD5C6FFD5CABBFFCBBF
      AFFFC5B9A9FFA09787FF453F39FF5D5448FF8E8273FF918678FF968C7DFF9D93
      87FF7C7368FF474039FF423D37FF100F0E9732646DD996F1FFFF84E5F9FF78E3
      F2FF70E2F1FF4FCAE0FF177D96FF166E53FF2EAD4DFF37B357FF3EB85EFF4AC0
      69FF31AE51FF098528FF0C8D2EFF083613D0614A2DDFFFCE8EFFF4C07BFFF1B8
      6FFFEEB365FFCC9141FF76480EFF7A4D12FFA7722CFFAA7634FFAF7C3CFFB889
      48FFA46F2AFF764406FF7C4A08FF3E2704EC276438DF94FFAFFF81F09FFF75EE
      97FF6CEB8EFF4BCF6DFF127B2DFF178634FF31B052FF37B357FF3EB85EFF4AC0
      69FF32AF54FF098528FF0C8B2DFF063F17DD56524BDAE1D8CAFFD2C8BBFFCCC2
      B4FFC7BCAEFFA2998AFF46403AFF595146FF7D7265FF82776AFF887D71FF958B
      7EFF7B7267FF453E35FF47403AFF231F1DE13B747CE4A1F3FFFF91E9F8FF85E6
      F3FF7BE5F2FF57CDE1FF167D96FF126B51FF24A143FF2DAD4EFF3FB85FFF55D2
      75FF2EAC4FFF0A7C27FF0B8429FF073A15DA6D5533EAFFD49AFFF5C688FFF2BF
      7CFFEFB973FFCD9349FF774810FF784A0FFF9D6721FFA26D29FFB07C3BFFCF99
      50FFA36E28FF714306FF764408FF3B2304E82E7341EA9FFFB8FF8DF1A8FF82EF
      9EFF78ED97FF53D073FF117B2FFF138331FF24A646FF2DAC4EFF3FB85FFF55D2
      75FF2FAD50FF0A7C27FF0B8529FF083F15E0636059E8E5DCD0FFD6CEC2FFD0C7
      BAFFCBC1B4FFA59E90FF453F39FF4C463CFF716657FF776C60FF887D71FFA89D
      90FF797065FF403A34FF433D35FF231F1EE947848FF1AFF4FFFF9CEDFAFF93E8
      F4FF8AE8F4FF60CEE2FF167E96FF0F664CFF169034FF25A147FF3CB75CFF39B4
      59FF259D45FF097628FF0C7C27FF063E14E47C603CF4FFDBA7FFF5CC97FFF4C7
      8CFFF1C183FFCF9953FF70430CFF70450CFF8B5714FF976422FFAF7B38FFAA78
      36FF915F20FF6D4007FF704308FF402505F038804BF3ACFEC2FF9BF3B3FF8FF1
      A9FF87EFA3FF5DD37CFF10782CFF11772CFF178B36FF26A046FF3CB75CFF39B4
      59FF269E46FF097628FF0C7C27FF064216EB726D68F2E8E1D8FFDCD3C8FFD5CD
      C1FFD1C9BDFFABA297FF443F39FF433F37FF5C5347FF6B6156FF877C6FFF8378
      6CFF675F55FF3C362FFF3D3834FF25221EF15895A0FAC0FAFFFFACF1FBFF95E9
      F3FF72DCEFFF42C4E0FF0D87A6FF0D5D46FF38812DFF2F8130FF15983DFF20A1
      42FF199539FF0B7528FF0A7427FF064115EF8C6E48FDFFE5BAFFF8D5A8FFEFC4
      8CFFDFAD6AFFBD853BFF643D08FF5E3905FF73490DFF784B11FF8C5A17FF9660
      1BFF8B5714FF6C4008FF6B3F08FF412704F8459058FBBFFFD0FFABF5BFFF91EE
      A7FF70DF8DFF43C364FF0D6D26FF0B6624FF12792FFF178533FF1B963CFF20A1
      40FF19963BFF0B7528FF0A7426FF074617F5848078FDEFEAE1FFE2DBD2FFD1C9
      C0FFBBB4A8FF948B7DFF433D36FF3D3931FF464037FF544B42FF5D544AFF675D
      52FF5C5349FF3B3631FF38332DFF25231EF94A8A93F66BD2E3FF45D3EAFF31C6
      E1FF93B69BFFC0B17AFFE3AF63FFFEB258FFFFB154FF985A1EFF54561CFF1A83
      31FF149437FF159735FF0E832DFF064717F97E603EF5DEA963FFDF9837FFB172
      21FFD49647FFDEA153FFE8AB5CFFF7B45DFFFDB456FF925F21FF704714FF7C4D
      10FF88530FFF8A540EFF77470AFF462904FE438655F466DA85FF3FDD69FF30CB
      59FF4DD270FF59DB7CFF60E685FF63F289FF5EF786FF25933FFF17742FFF1585
      32FF149437FF159737FF0E842DFF064C19FE736F68F4BCB2A6FFADA18FFF8D82
      72FFA79D8FFFB2A89AFFC1B5A5FFCEC2B0FFCFC3B0FF6A6158FF4C453DFF5049
      3FFF574F44FF574F46FF453F37FF25211DFE020506331B373BA1448A95F63AAF
      C7FFFDC887FFFFC47AFFF5BD70FFF3B867FFF8B761FF8F5D1FFF6F4515FF6F42
      11FF105D20FF0B5E21FD084A18E2021807880B0803563A2C19B181623BF78D61
      2AFFFDC985FFFBC47CFFF4BD71FFF2B868FFF8B761FF8F5D20FF6E4615FF6B44
      13FF58370AFF573407FE422803E4170D018E0104022D17331F9D418753F540B0
      5DFF89F9A6FF82F7A0FF77F198FF6EEE91FF68F48DFF249140FF186F2FFF166D
      2DFF0E5F23FF0A5D21FD064A1AE4011A088E08080754312F2DA875706AF7867E
      73FFD9D1C4FFD8CFC0FFD3C9BAFFCEC1B3FFCEC3B1FF675E56FF4C463EFF4944
      3CFF37312BFF37302AFE2A2521E50D0D0B8F0000000000000000000000105341
      27CCFECC8FFFFAC789FFF4C17DFFF3BC73FFF9BC6FFF8D5C1FFF6F4715FF6F45
      12FF2B1907D0000000090000000000000000000000000000000000000012543C
      1DDFFCCD92FFF9C789FFF4C17DFFF3BC73FFF9BC6FFF8E5E1FFF6F4715FF6D46
      12FF2E1E07DA0000000A00000000000000000000000000000000000000122156
      2FD695F8AEFF8CF5A9FF83F0A1FF78EF99FF73F594FF23903FFF187030FF186F
      2EFF082910D00000000A00000000000000000000000000000000000000134745
      3FD6DDD5C7FFD9D2C2FFD5CBBDFFCFC4B6FFCFC5B6FF685F55FF4C483EFF4A46
      3EFF1C1B17D50000000B00000000000000000000000000000000000000004F37
      1DBAFFD59FFFF9CD94FFF5C78AFFF4C281FFF9C27AFF8D5E1EFF704915FF6F47
      12FF2B1B06CC0000000000000000000000000000000000000000000000004D38
      1CD4FED5A0FFF9CC94FFF5C78AFFF4C281FFF9C27CFF8E5D1FFF704815FF6F47
      12FF331F05D70000000000000000000000000000000000000000000000001C52
      2BCEA3FCBAFF98F7B0FF8FF1A9FF86F0A2FF80F6A0FF228F40FF187131FF1872
      2FFF082F12D0000000000000000000000000000000000000000000000000413E
      3AC8E4DBD1FFDED4C9FFD7CFC3FFD3CABFFFD5CCBEFF665D55FF4C473FFF4A47
      3EFF201D19D6000000000000000000000000000000000000000000000000553C
      20C2FFDFB0FFF9D4A1FFF5CD98FFF6C98FFFFBC98AFF8E5D1FFF724A16FF7248
      14FF352106D4000000000000000000000000000000000000000000000000513A
      1DD8FFDEAEFFF9D4A1FFF5CD98FFF6C98FFFFBC98AFF8F5D1FFF724A16FF7248
      14FF362206DD0000000000000000000000000000000000000000000000001C56
      2CD1B2FFC6FFA5F6BBFF9CF2B2FF92F2ADFF8FF7ABFF23913FFF187531FF1772
      31FF093315D30000000000000000000000000000000000000000000000004441
      3CCCEBE2DBFFE0D9D1FFDBD6C9FFDAD0C6FFDAD1C5FF665D55FF4D4841FF4C47
      3FFF23201BD80000000000000000000000000000000000000000000000005A40
      21C7FFEBC5FFFDDDB3FFF7D2A2FFF2C68CFFEEBC79FF976220FF714A17FF7147
      13FF362107D6000000000000000000000000000000000000000000000000543E
      1FDDFFECC4FFFDDDB3FFF7D2A2FFF2C68CFFEFBC79FF976220FF714A17FF7147
      13FF3C2507E10000000000000000000000000000000000000000000000001F5C
      2FD7C8FFDAFFB6F9C9FFA5F4B9FF90F0A9FF7EED9CFF249843FF187330FF1871
      2FFF0B4018DB0000000000000000000000000000000000000000000000004946
      42D2F3F0E8FFE8E3DAFFE0D9CEFFD5CCC2FFCCC3B6FF6C635AFF4C463DFF4A46
      3DFF282621DF0000000000000000000000000000000000000000000000004F38
      1FB8CD9B5FFFDD9B48FFE19837FFD89032FFD28B31FFCE8B31FFB87A2AFF8D5B
      1BFF462D0CDA0000000000000000000000000000000000000000000000004D3A
      22C7CB9E65FFDC9C49FFE19836FFD89032FFD28B31FFCF8B31FFB87A2AFF8E5B
      1BFF452C0AE20000000000000000000000000000000000000000000000001D52
      2BCA62C57CFF4DD871FF3EE069FF39D762FF37D260FF37D05FFF2FBC53FF2191
      3DFF0C441BDA000000000000000000000000000000000000000000000000423F
      3CBEAFA89DFFB2A798FFAEA18FFFA59989FF9F9482FF9C9181FF887E71FF645C
      52FF2C2825DE0000000000000000000000000000000000000000000000000000
      0012161009653A2B18A47A5833E491682FFC6A481AE74C3310CF37240CB7281B
      079F090501490000000000000000000000000000000000000000000000000000
      001215110B663A2D1DA879603FE8906732FC6B4817E84D3310D038240CB8281A
      079F110A026E0000000000000000000000000000000000000000000000000003
      0129091A0E74183C21B1327242EA2D8A47FC1B6A2FE9125023D40E3C19BE0A2F
      14A8020E065C0000000000000000000000000000000000000000000000000000
      00121615137534332FB165625CEA6D675DFC4D4841EA38342FD52A2622BF1F1D
      19A90908075D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000140C080257261A079B543611DD79501AFD261A
      0A99000000030000000000000000000000000000000000000000000000000000
      00000000000000000000000000140B0A085724201B9B4C453BDE6F6455FD231F
      1B99000000030000000000000000000000000000000000000000000000000000
      00000000000000000000000001200202106205052BA4090954E50D0D6AF90202
      1165000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000014030D0E570C2A2F9A195864DD278496FD0D29
      2F9B000000040000000000000000000000000000000000000000000000090806
      01462217078A4E3411CE8B5A1EFDA86E25FFC7842FFFE19533FFC27E28FF955F
      1CFF2B1C08A80000000500000000000000000000000000000000000000090707
      06461F1D198A464137CE7D7060FD928470FFAA9983FFBAA990FFA5947CFF8376
      65FF23201DA70000000400000000000000000000000000000000000000160202
      0E5706062A9A0D0D57DC191983FE2B2BA6FF4042CBFF5657ECFF2425C3FF1010
      7DFE020211630000000000000000000000000000000000000000000000090208
      0A460A23278A16525ACE2990A0FD31A8BCFF3AC3D8FF40D6EFFF34C9E3FF2CA1
      B7FF0C3036AB0000000500000000000000000906024A402A0EBD7F521EF7A871
      2CFFCB8836FFEA9B3DFFF0A140FFEDA13FFFECA03BFFEB9D3AFFC28029FFBA79
      24FF955F1CFF2D1C06B200000008000000000908074E38322DBC6D6658F79084
      72FFAB9C89FFC2B198FFC0B09BFFBFB09BFFBFB09AFFBEAE96FFA4947CFFA697
      81FF817463FF23201DB100000007000000000000022510104BCC201F83FE3838
      A9FF5152CDFF696BF2FF7475FDFF6E70FDFF6768FBFF6768FAFF2929C3FF1111
      B2FF101083FF030316730000000300000000020A0B4C134047BD257F8DF734A5
      B6FF3FC2D7FF46DDF5FF47DDF9FF46D9F3FF44D9EFFF44D8EEFF35C5DEFF38CA
      E4FF2BA4B7FF0B3439B5000000090000000065461DE2F0B261FFF9BB64FFF8B4
      5DFFF5AC50FFF1A546FFECA141FFEA9F3DFFE99E3AFFE99C39FFC17E29FFB575
      23FFB77522FF945E1AFF2E1E06BC0000000B645C53EFCEC0B0FFD5C6B3FFD0C1
      AEFFC9BAA6FFC2B39EFFBEAF9AFFBDAE99FFBDAE98FFBEAE96FFA4947AFFA192
      7DFFA1937EFF7D7161FF221F1ABA0000000A121242BA8182DDFF9697FFFF9091
      FFFF8788FFFF8081F9FF7878F9FF7172F8FF6B6CF7FF696AF8FF2828C2FF1212
      AFFF0E0EB1FF0D0D87FF0404208F00000007246A76E867E4F5FF69EBFDFF63E7
      FBFF58E3F7FF4EDFF5FF48DAF3FF45D7F0FF43D7EDFF45D9EFFF35C5DEFF35C5
      DDFF36C7DFFF29A5BBFF0B363EBE0000000C8A6A3FEAFFC980FFF3BD71FFF2B8
      65FFF1B15CFFEFAB52FFEDA647FFEAA140FFE99E3BFFE99C39FFBF7C28FFB274
      22FFB27220FFB2701FFF935D17FF261804B1878076F7DDD3C4FFD2C7B9FFCEC2
      B2FFCABEACFFC6B9A6FFC2B4A0FFBFB09BFFBDAE98FFBEAE96FFA3927BFFA192
      7CFF9D8F7AFF9B8D7AFF7A6F61FF1C1A16B01F1E50C3ABAEF4FF999BFFFF9192
      FEFF8A8CFBFF8486F8FF7D7EF8FF7678F8FF7072F7FF6E70F8FF2829C2FF1111
      AEFF0E0EACFF0A0AAEFF0D0D88FF0202116A448C95F184F2FFFF76EAF9FF6BE6
      F7FF62E4F6FF5ADEF5FF50DAF5FF48D7F0FF44D7EDFF44D9EEFF34C3DBFF35C0
      D9FF34C1D9FF34C4DFFF29A4BEFF092F36B58B693DECFFCC8DFFF4C17CFFF3BC
      72FFF2B668FFF0B05DFFEDAB54FFEBA54AFFE9A03FFFEA9D3AFFBC7826FFAD6F
      20FFAC701FFFAC6E1DFFAF701DFF4D2F0AE9878077F8DFD7CBFFD7CDBFFFD3C9
      BAFFCFC4B2FFCBBFACFFC7BAA6FFC3B5A0FFBFB09AFFBFAF97FF9F8E77FF9C8D
      79FF9A8C76FF968976FF988A78FF3B342DEB232257CCB1B2F5FFA0A0FFFF9899
      FEFF9193FBFF8B8DF8FF8588F8FF7E80F8FF7779F7FF7578F8FF292AC0FF1111
      AEFF0E0EACFF0A0AACFF0B0BA1FF0C0C5FEE458D96F290F5FEFF82EBF9FF77E7
      F8FF6EE3F7FF64DFF6FF5CDCF4FF53DAF0FF49D8EDFF45D9EFFF32C0D9FF31B9
      D2FF31BAD2FF30BBD4FF33C1DCFF126070EF8F6F49EDFFD198FFF5C689FFF4C1
      80FFF3BB74FFF1B56AFFEDB060FFECAA55FFEAA44CFFEAA142FFB77824FFA66A
      1DFFA6691FFFA4691CFFA86A1BFF4C2E09EA8A867AF7E4DECFFFDBD3C3FFD8CE
      BDFFD4C9B7FFD0C4B1FFCCBFABFFC8BBA5FFC3B49FFFC1B19BFF9C8C75FF9586
      71FF938772FF928471FF938774FF39352EEB27265DD2B9B8F9FFA5A6FFFF9E9F
      FEFF9899FBFF9293F8FF8B8DF8FF8586F8FF7E80F7FF7D7EF9FF2A2BC0FF1111
      ACFF0E0EA9FF0A0AA9FF0B0BA3FF0A0A5BEA4D9098F29BF7FFFF8DECFAFF84E8
      F9FF7AE4F8FF71E1F7FF68DFF4FF5EDDF0FF55DBEEFF4DDAF0FF30BDD5FF2DB4
      CBFF2EB3CCFF2EB3CCFF2FB7D1FF125F6EEF917654EEFFD9A5FFF5CD96FFF5C9
      8BFFF4C281FFF1BC77FFEEB86CFFECB162FFEAAB58FFECAA4FFFB27426FFA067
      1AFF9E651BFF9E641CFFA1661AFF4C2E09EA8E8983F7E9E3D6FFE0D7CBFFDCD2
      C5FFD8CDBFFFD4C7B9FFD0C2B4FFCBBDACFFC7B7A6FFC3B5A3FF9B8A74FF8F81
      6DFF8C7E6CFF8B7D6EFF8C806FFF3A342CEA2A2B63D9C0C1FDFFACADFFFFA5A6
      FEFF9E9FFBFF9899F8FF9293F8FF8C8DF8FF8686F7FF8485F9FF2B2ABCFF1111
      A7FF0E0EA7FF0A0AA5FF0B0BA4FF0A0A5DED589299F2A7F8FFFF99ECFBFF8FE9
      FAFF86E7F9FF7DE4F8FF73E2F4FF6AE0F1FF61DDEFFF59DEF1FF31BAD2FF2BAC
      C5FF2AADC4FF2AAFC7FF2DB1CBFF105C6FEF957A59F0FFDFB3FFF7D3A2FFF6CE
      98FFF5C88EFFF2C283FFEEBC79FFEDB76FFFEBB164FFECAE5DFFAE7428FF9A61
      1AFF996117FF975F17FF9B601AFF4C2F09EA938C86F8EFE5DEFFE6DBD2FFE0D6
      CBFFDCD1C5FFD7CCBFFFD3C7B8FFCEC2B2FFC9BEACFFC8BBA8FF958671FF897B
      68FF867868FF847666FF867A6BFF38332BE92F2F69E0C7C7FFFFB1B2FFFFABAC
      FEFFA5A6FBFF9FA0F8FF999AF8FF9394F8FF8C8FF7FF8B8EFAFF292BBAFF1111
      A3FF0E0EA4FF0A0AA2FF0A0AA2FF0A0A60F15E949DF4B3F6FFFFA5EEFCFF9CEC
      FBFF92EAFAFF88E8FAFF80E5F5FF76E2F1FF6CE0F0FF65DFF2FF31B5CFFF28A6
      BDFF28A6BEFF27A6BEFF29ACC3FF115D6CEE988062F1FFE5BFFFF8D9AFFFF7D3
      A5FFF5CD9AFFF3C891FFF0C186FFEEBC7AFFECB671FFEDB46AFFAA7027FF925C
      19FF925C16FF925B14FF945D17FF4B2D08EA969089F8F1ECE4FFE8E1D7FFE3DC
      D1FFDED7CBFFDAD2C4FFD6CDBEFFD2C8B8FFCEC3B1FFCDC1AFFF93846EFF8174
      63FF827362FF7D7162FF7E7263FF383029E8323272E8CECEFFFFB8B8FFFFB1B2
      FEFFABACFBFFA5A6F9FF9FA0F8FF999AF8FF9394F7FF9393F9FF2A2AB8FF1111
      A1FF0E0EA0FF0A0A9FFF0A0AA2FF0C0C63F465969FF4C0F8FFFFB1F1FDFFA8EF
      FCFF9EEDFBFF95EBF9FF8CE8F5FF82E5F2FF78E3F2FF73E4F3FF32B2CBFF249D
      B5FF249EB6FF24A1B6FF24A3BCFF105A6CED9A8A74F1FFEDCDFFF9E0BCFFF8DA
      B2FFF6D4A8FFF3CE9DFFF0C893FFEFC289FFECBD7EFFEDBC77FFA76E27FF8D59
      16FF8B5717FF8B5613FF8E5711FF4C2E08EB9A9893F7F4F1EBFFEBE6DFFFE7E1
      DAFFE3DCD2FFDFD7CDFFDBD2C5FFD7CDBFFFD2C8BAFFD1C6B7FF8E7E6CFF7A6E
      5DFF786C5DFF776B5CFF776C5DFF363028E842427EEFD2D2FFFFBFC0FFFFB9B9
      FEFFB3B3FBFFACADF9FFA6A6F9FF9FA0F8FF9999F7FF999AFAFF2B2BB8FF1111
      9CFF0E0E9CFF0A0A9BFF0A0A9FFF0C0C64F6779A9FF4CDFDFFFFBDF4FEFFB4F2
      FDFFABF0FCFFA1EDF9FF98EAF5FF8FE8F3FF85E5F3FF7EE6F5FF32B0C7FF2298
      AFFF2198AFFF2098AFFF239BB4FF105B69EE9C8A70F3FFF1D7FFF9E5CAFFFADF
      BFFFF8D9B6FFF4D3AAFFF1D0A2FFF0CA97FFEFC48EFFF1C48AFFA16B25FF8552
      11FF855314FF845113FF86520FFF4A2E06EC9A9792F8FAF6F1FFF1EBE6FFECE6
      DEFFE7E1D8FFE3DCD1FFE0D8CCFFDBD2C5FFD8CEC0FFD8CEC0FF8B7C68FF7266
      58FF716657FF6F6457FF726558FF352F27E7494989F6D6D6FFFFC7C6FFFFBFC1
      FFFFBBBCFBFFB5B7F9FFB1B2FAFFACABFBFFA6A7F9FFA3A4FCFF2C2CB5FF1111
      98FF0E0E99FF0A0A98FF0A0A9AFF0C0C68FA749CA2F6D7FFFFFFCBF9FEFFC1F5
      FEFFB7F4FEFFADEFF9FFA6EEF6FF9CEBF6FF94E9F5FF91E8F7FF2EAAC3FF1E90
      A6FF2092A8FF1E91AAFF1C95ABFF0F5A69EE9F917DF4FFF1DBFFFBECD7FFFBE9
      D4FFFAE4CAFFF5DBBAFFEFCEA5FFE7BE8AFFDBAC70FFCF9C5AFF9C641DFF8050
      0EFF7D4D0FFF7C4C10FF7D4E10FF4B2E06EB9C9B97F8FAF6F1FFF4F0ECFFF4EF
      E9FFEFEBE4FFE9E4DBFFE1D9CDFFD5CCBDFFC8BDABFFB9AC98FF857561FF6E62
      51FF6A5F52FF695E51FF686053FF352E29E65B5A94FDDCDCFFFFD1D1FFFFC5C5
      FFFFB3B3FAFF9B9CF3FF8485ECFF6D6EE6FF5758DDFF4445D4FF2A2ABFFF1818
      A4FF0F0F95FF0A0A94FF0A0A95FF0D0D68FA7E9FA4F6DBFFFFFFD8FBFFFFD5FA
      FFFFCCF8FFFFBDF2F9FFA9EEF5FF92E4F2FF79D9EDFF62D1E6FF26A7C1FF188A
      A0FF1A899FFF1D8BA1FF1C8DA5FF0F5968ED948B7BECFFD59EFFECB973FFE3A8
      5BFFD89744FFCB8A34FFC17E29FFB97724FFB17221FFAB6D20FFA6691EFF9C63
      1AFF895511FF7B4B0EFF76480DFF482C06EB93928FEFEBE2D6FFD5C9BAFFC9BC
      A9FFBBAD98FFB09F88FFA8957BFFA18F72FF9B886CFF948267FF8D7A63FF8072
      5BFF6F6352FF63594DFF61584DFF322C28E568688CF49D9DF3FF6262F8FF4B4B
      EDFF4343E5FF3F3FE0FF3D3DDBFF3A3AD6FF3635D1FF3232CCFF2D2DC9FF2A2A
      C6FF2121BAFF1313A5FF0B0B95FF0B0B6EFF7E9395ED9FF9FFFF75E8FCFF5FDF
      F4FF49D5ECFF38CBE5FF2EC4E0FF29BEDBFF28BAD5FF27B7D2FF26B4CFFF23AB
      C7FF1B99B2FF178AA1FF18869CFF0F5767ED16141162746B5ED3B29B78FDC59B
      65FFD1974DFFCF8A2FFFC48129FFBE7D29FFB77726FFB07224FFAA6C1FFFA166
      1BFF935C18FF865312FF75460EFF362005D21616166674706FD6A8A29AFEB2A7
      99FFB7AA96FFB19E86FFAA967CFFA59378FFA18D71FF99876BFF907E66FF8474
      5FFF766955FF665A4CFF574E44FF25201DCB0D0D1158414151BB76768EF37373
      ABFF6F6FCBFF5D5DDEFF4040E2FF3C3CDBFF3939D8FF3131CAFF2B2BBDFF2525
      B0FF1F1FA3FF191998FF13138AFF09094AD512161664607478D578B2BBFD65C2
      D1FF4FCFE5FF33CFE9FF2EC8E3FF2FC3DFFF2DBFDAFF2ABBD7FF27B7D3FF25B1
      CDFF21A6C1FF1B9BB5FF16879EFF09414DD30000000000000000000000140D0D
      0D512C2B288F635F5BCDA08E75FC865F2FFA614012E449300FCE33210AB82316
      06A21A10038C110A02750A06015F0000001A0000000000000000000000160E0E
      0E532C2B2C91626260CE98938CFC776A5CF9564B3CE43F372CCE2B261EB81D19
      15A214120F8C0D0B09750807055F000000180000000000000000000000040606
      073A1E1F227C454554C46E6E8AF437377BF1161657DA111143C10B0B32AA0707
      25920404197A02020F620101084A0000000E0000000000000000000000150D0E
      0E52282B2D905A6364CD77A1ABFC32899BFA186575E4124C58CF0C383FB80827
      2DA2061C218C03141675020C0F5F0000011A00000000706B67DCA39D96FEA19B
      95FEA19B95FEA19B95FEA19B95FEA19B95FEA19B96FEA19B94FEA19C94FEA19A
      95FEA19B95FEA39C95FE716B67DC0000000000000000706B67DCA39D96FEA19B
      95FEA19B95FEA19B95FEA19B95FEA19B95FEA19B96FEB8B4AEFE08651FFF0868
      20FF086520FFB2ACA6FE716B67DC0000000000000000706B67DCA39D96FEA19B
      95FEA19B95FEA19B95FEA19B95FEA19B95FEA19B96FEA19B94FEA19C94FEA19A
      95FEA19B95FEA39C95FE716B67DC0000000000000000706B67DCA39D96FEA19B
      95FEA19B95FEA19B95FEA19B95FEA19B95FEA19B96FEA19B94FEA19C94FEA19A
      95FEA19B95FEA39C95FE716B67DC0000000000000000A7A29DFEFFFFFFFFFFFE
      FCFFFFFFFAFFFFFDF9FFFFFEF8FFFFFCF8FFFFFBF5FFFFFAF5FFFFF9F2FFFFF6
      F0FFFEF5EEFFFFF9EFFFA7A29BFE0000000000000000A7A29DFEFFFFFFFFFFFE
      FCFFFFFFFAFFFFFDF9FFFFFEF8FFFFFCF8FFFFFBF5FFFCF7F5FF08661FFF09CA
      3BFF086820FFFCF6EFFFA7A29BFE0000000000000000A7A29DFEFFFFFFFFFFFE
      FCFFFFFFFAFFFFFDF9FFFFFEF8FFFFFCF8FFFFFBF5FFFFFAF5FFFFF9F2FFFFF6
      F0FFFEF5EEFFFFF9EFFFA7A29BFE0000000000000000A7A29DFEFFFFFFFFFFFE
      FCFFFFFFFAFFFFFDF9FFFFFEF8FFFFFCF8FFFFFBF5FFFFFAF5FFFFF9F2FFFFF6
      F0FFFEF5EEFFFFF9EFFFA7A29BFE0000000000000000A7A29AFEFFFFFDFFE9E7
      E4FFE9E6E4FFEDEAE6FFFCF8F5FFFBF7F5FFFBF6F2FFFAF5F0FFFAF4EEFFF9F3
      ECFFF9F1EAFFFDF5ECFFA6A099FE0000000000000000A7A29AFEFFFFFDFFE9E7
      E4FFE9E6E4FFEDEAE6FFFBF7F5FFF9F6F5FFF8F6F2FFF6F5F0FF08661FFF09CA
      3BFF086820FFF8F5EDFFBAB6B1FE0000000000000000A7A29AFEFFFFFDFFE6EC
      E4FFE6EBE4FFE7EBE4FFFCF8F5FFFBF7F5FFFBF6F2FFFAF5F0FFFAF4EEFFF9F3
      ECFFF9F1EAFFFDF5ECFFA6A099FE0000000000000000A7A29AFEFFFFFDFFE9E7
      E4FFE9E6E4FFEDEAE6FFFCF8F5FFFBF7F5FFFBF6F2FFFAF5F0FFFAF4EEFFF9F3
      ECFFF9F1EAFFFDF5ECFFA6A099FE0000000000000000A6A19BFEFFFFFFFF423F
      3CFF464341FF65605AFFFCFAF7FFFCF9F6FFFBF8F4FFFBF7F2FFFAF5F0FFFAF4
      EEFFF9F2ECFFFFF6EEFFA7A099FE0000000000000000A6A19BFEFFFFFFFF423F
      3CFF464341FF65605AFFFAF8F6FF216333FF17632AFF17632AFF096620FF09C8
      3AFF086A20FF086920FF086920FF08631EFF00000000A6A19BFEFFFFFFFF2572
      39FF29723DFF2C713EFFFCFAF7FFFCF9F6FFFBF8F4FFFBF7F2FFFAF5F0FFFAF4
      EEFFF9F2ECFFFFF6EEFFA7A099FE0000000000000000A6A19BFEFFFFFFFF423F
      3CFF464341FF65605AFFFCFAF7FFFCF9F6FFFBF8F4FFFBF7F2FFFAF5F0FFFAF4
      EEFFF9F2ECFFFFF6EEFFA7A099FE0000000000000000A6A19CFEFFFFFFFFFEFD
      FDFFFEFDFEFFEDECEAFFEAE9E6FFEAE7E4FFEFECEAFFEDE9E6FFE5E2DDFFFAF5
      F0FFFAF4EDFFFEF7F1FFA7A09AFE0000000000000000A6A19CFEFFFFFFFFFEFD
      FDFFFEFDFEFFEDECEAFFEDECE9FF29683AFF8CE4A4FF72DF91FF4AD571FF21CA
      4CFF09C83AFF09C83AFF09C83AFF09611FFF00000000A6A19CFEFFFFFFFFFEFD
      FDFFFEFDFEFFE8F2F3FFE7F0F0FFE7EDEEFFEDF0EFFFEAECEAFFE3E5E2FFFAF5
      F0FFFAF4EDFFFEF7F1FFA7A09AFE0000000000000000A6A19CFEFFFFFFFFFEFD
      FDFFFEFDFEFFEDECEAFFEAE9E6FFEAE7E4FFEFECEAFFEDE9E6FFE5E2DDFFFAF5
      F0FFFAF4EDFFFEF7F1FFA7A09AFE0000000000000000A6A39BFEFFFFFFFFFFFF
      FFFFFEFEFEFF5F5A54FF423F3BFF413D3AFF7D7A77FF666360FF34322FFFF7F2
      EEFFFAF5EFFFFEF8F1FFA7A09AFE0000000000000000A6A39BFEFFFFFFFFFFFF
      FFFFFEFEFEFF5F5A54FFACAAA8FF316C41FF2B6D3BFF2B6D3BFF246F38FF52D9
      78FF0F6825FF0A611FFF0A611FFF0A5E1FFF00000000A6A39BFEFFFFFFFFFFFF
      FFFFFEFEFEFF2E9DB5FF2993A9FF27899EFF6EACB9FF5297A4FF1B6575FFF7F2
      EEFFFAF5EFFFFEF8F1FFA7A09AFE0000000000000000A6A39BFEFFFFFFFFFFFF
      FFFFFEFEFEFF5F5A54FF423F3BFF413D3AFF7D7A77FF666360FF34322FFFF7F2
      EEFFFAF5EFFFFEF8F1FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFEFEEEEFFEAEAE9FFEFEDEDFFFDFCFBFFFDFAF8FFFCF9F6FFFBF7
      F3FFFAF5F0FFFFF9F4FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFEFEEEEFFEBEBEAFFEFEDEDFFFAF9F8FFF8F6F6FF306F41FF7BE2
      9AFF246935FFFAF6F4FFC1BDB9FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFF4F0EAFFF1ECE5FFF4EFEAFFFDFCFBFFFDFAF8FFFCF9F6FFFBF7
      F3FFFAF5F0FFFFF9F4FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFEFEEEEFFEAEAE9FFEFEDEDFFFDFCFBFFFDFAF8FFFCF9F6FFFBF7
      F3FFFAF5F0FFFFF9F4FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFF605C55FF3E3934FF625F5BFFFEFDFEFFFDFBFAFFFCFAF7FFFCF8
      F5FFFBF6F2FFFFFBF4FFA7A199FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFF605C55FF3E3934FF625F5BFFFEFDFEFFFAF8F7FF306F41FF93E6
      ACFF246935FFFCF8F4FFAFAAA3FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFA1702FFF8A5712FF9A713EFFFEFDFEFFFDFBFAFFFCFAF7FFFCF8
      F5FFFBF6F2FFFFFBF4FFA7A199FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFF605C55FF3E3934FF625F5BFFFEFDFEFFFDFBFAFFFCFAF7FFFCF8
      F5FFFBF6F2FFFFFBF4FFA7A199FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEEFFEBEAEAFFEAE9E7FFEAE8E5FFEBE8
      E5FFE8E4E0FFFFFAF5FFA7A199FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEEFFEBEAEAFFECEBE9FF377147FF336F
      43FF306C40FFFDF8F5FFA7A199FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFEDEDFAFFE8E8F8FFE7E6F4FFE6E4F2FFE5E2
      EEFFE2DFEAFFFFFAF5FFA7A199FE0000000000000000A6A29BFEC8934AFFC792
      49FFC79146FFC69045FFC58D40FFBA8740FFB7833DFFB7833CFFB7833CFFB985
      3DFFB6833CFFC48B3DFFA7A199FE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6661FF423C37FF46423EFF433F3AFF5A55
      4FFF403C38FFFFFCF7FFA7A19BFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF6A6661FF423C37FF575450FFADAAA8FFAEAB
      A8FFAAA8A8FFFEFBF6FFA7A19BFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF5454D3FF2C2CC4FF2E2EC0FF2828BBFF2C2B
      B8FF1717AAFFFFFCF7FFA7A19BFE0000000000000000A6A29BFEC9954EFFFBD3
      9EFFFBCF97FFFACD91FFFAC785FF695C4DFF423B35FF464038FF433D35FF5A50
      42FF403A32FFC48B3DFFA7A19BFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFF0EFEFFFEDECECFFF1F0F0FFFFFFFFFFFEFFFDFFFDFCFAFFFCFA
      F7FFFBF8F4FFFDF9F4FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFF0EFEFFFEDECECFFF1F0F0FFFFFFFFFFFEFFFDFFFDFCFAFFFCFA
      F7FFFBF8F4FFFDF9F4FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFF8F3ECFFF6F1E9FFF8F4EEFFFFFFFFFFFEFFFDFFFDFCFAFFFCFA
      F7FFFBF8F4FFFDF9F4FFA7A09AFE0000000000000000A6A29BFECA9852FFCA97
      50FFC9964FFFBD8D49FFB98740FFBB8840FFC48C3FFFC69146FFC68E42FFC58D
      41FFC48B3DFFC28A3DFFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFF65605AFF55514AFF706B68FFFFFFFFFFFEFEFFFFFDFCFBFFFCFA
      F8FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFF65605AFF55514AFF706B68FFFFFFFFFFFEFEFFFFFDFCFBFFFCFA
      F8FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFFC18B44FFB77E36FFBD9157FFFFFFFFFFFEFEFFFFFDFCFBFFFCFA
      F8FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFFFFF
      FFFFFFFFFFFF65605AFF55514AFF706B68FFFFFFFFFFFEFEFFFFFDFCFBFFFCFA
      F8FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFF0F0
      EFFFF1F1F0FFEFEFEEFFF0F0EFFFEFEFEEFFF1F0F0FFEFEEEEFFEEEDEBFFEFEC
      E9FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFF0F0
      EFFFF1F1F0FFEFEFEEFFF0F0EFFFEFEFEEFFF1F0F0FFEFEEEEFFEEEDEBFFEFEC
      E9FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFECF5
      EFFFECF5EFFFEAF3EDFFEBF4EDFFEAF3ECFFEDF4EFFFEBF2EDFFEAF0EBFFE9EE
      E7FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFFF0F0
      EFFFF1F1F0FFEFEFEEFFF0F0EFFFEFEFEEFFF1F0F0FFEFEEEEFFEEEDEBFFEFEC
      E9FFFCF8F5FFFFFBF8FFA7A09AFE0000000000000000A6A29BFEFFFFFFFF7773
      6EFF706C67FF635E58FF6F6A66FF605B56FF7D7974FF726D6AFF6C6763FF726D
      68FFFCF8F5FFFFFBF6FFA7A09AFE0000000000000000A6A29BFEFFFFFFFF7773
      6EFF706C67FF635E58FF6F6A66FF605B56FF7D7974FF726D6AFF6C6763FF726D
      68FFFCF8F5FFFFFBF6FFA7A09AFE0000000000000000A6A29BFEFFFFFFFF4DA2
      63FF459B5AFF328F4AFF439659FF2E8946FF4F9A63FF49955CFF428E56FF3E8A
      51FFFCF8F5FFFFFBF6FFA7A09AFE0000000000000000A6A29BFEFFFFFFFF7773
      6EFF706C67FF635E58FF6F6A66FF605B56FF7D7974FF726D6AFF6C6763FF726D
      68FFFCF8F5FFFFFBF6FFA7A09AFE0000000000000000A9A49EFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FEFFFFFEFBFFFFFFFCFFA8A39DFE0000000000000000A9A49EFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FEFFFFFEFBFFFFFFFCFFA8A39DFE0000000000000000A9A49EFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FEFFFFFEFBFFFFFFFCFFA8A39DFE0000000000000000A9A49EFEFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FEFFFFFEFBFFFFFFFCFFA8A39DFE0000000000000000706C67DCABA5A0FEA8A2
      9DFEA29C96FEA6A09AFEA29C96FEA29C96FEA6A19AFEA7A09CFEA7A19AFEA5A0
      9AFEA19B96FEA39D97FE716B67DC0000000000000000706C67DCABA5A0FEA8A2
      9DFEA29C96FEA6A09AFEA29C96FEA29C96FEA6A19AFEA7A09CFEA7A19AFEA5A0
      9AFEA19B96FEA39D97FE716B67DC0000000000000000706C67DCABA5A0FEA8A2
      9DFEA29C96FEA6A09AFEA29C96FEA29C96FEA6A19AFEA7A09CFEA7A19AFEA5A0
      9AFEA19B96FEA39D97FE716B67DC0000000000000000706C67DCABA5A0FEA8A2
      9DFEA29C96FEA6A09AFEA29C96FEA29C96FEA6A19AFEA7A09CFEA7A19AFEA5A0
      9AFEA19B96FEA39D97FE716B67DC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000014030D06560B2A139918592ADC25883EFE0E2C
      169E000000040000000000000000000000000000000000000000000000020B0B
      0A492F2D2B99544F48D46F675DF1766C5EFE6E6453FE564B3EF12E2821CF1210
      0F9A0403034B000000020000000000000000817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF817563E60000000000000000000000000000
      000000000000000000000000000000000000402A0CB58D6225FE906225FF8F61
      24FF8F6124FF906225FF8E6225FE3C280BB60000000000000000000000090209
      04460A25118A175426CD289344FD2FAE50FF36CA5DFF3BE168FF30CA58FF29A5
      49FF0B3015AE00000006000000000000000000000000020202235A5650CEBCB5
      ADFFD9CEC2FFDED2C3FFCDBDABFFBCAC95FFAD9A81FF9E8C71FF887967FF675F
      53FF534C44FF312D29CE01010123000000009E907AFF323232FF2D2D2DFF3131
      31FF1F1F1FFF181818FF181818FF161616FF161616FF131313FF101010FF0F0F
      0FFF0E0E0EFF0E0E0EFF0E0E0EFF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000007C4E11FEFFFAD0FFFFF4CAFFFFF3
      C9FFFFF3C9FFFFF4CAFFFFFAD0FF75490FFE0209044A10411EBD26833FF734A9
      52FF3ECB63FF45E770FF46EC6FFF45EA6CFF41E66DFF41E46CFF32C95AFF34CE
      5BFF29A749FF0A3315B80000000A0000000000000000524D48CED5CBBDFFFBF1
      E7FFEEE3D6FFDDD1C2FFCABBA7FFB9A893FFAB9981FF9D8A70FF887B67FF796E
      62FF8A8071FF978C7DFF453F38D9000000009E907AFF363636FF3F383FFF2D3F
      2DFF352A33FF0C110AFF118E1EFF0A070AFF081608FF060206FF031703FF0100
      01FF001700FF000000FF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000006F430BFFF9D09AFFF0C993FFF0C9
      93FFF0C993FFF0C993FFF9D09AFF673E09FF226533E266ED8BFF6AF490FF62F0
      88FF56ED7DFF4DEB75FF48E86FFF44E66BFF40E46BFF40E56DFF32C959FF33C9
      5AFF32CB59FF27A648FF093515C20000000E0000000080796FFEE9DDCEFFFAF1
      E9FFE6E0D7FFC5BEB5FFB1A89DFFB3A89AFFB3A899FFB5A999FFB3A896FFA69B
      8BFF968B7DFF988E80FF696157FE000000009E907AFF3A3A3AFF4C584CFF2845
      28FF426F47FF274327FF14B525FF0E3E12FF0B340DFF081C08FF062D06FF0309
      02FF0FB51EFF000200FF111111FF9E907AFF0000000000000000000000000000
      000000000000000000000000000000000008613B05FFEABC80FFE3B77CFFE2B7
      79FFE2B779FFE3B77CFFEBBE82FF5C3806FF3F8753EA85FCA4FF74F096FF6BED
      90FF62EC87FF58EB7EFF4EE976FF46E76EFF42E46BFF40E56CFF31C758FF31C6
      57FF2FC657FF2EC457FF25A747FF062F11BA0000000083796EFFCDC6BEFFB8B2
      ABFFC9BEB4FFD8CDBFFFCABAA7FFB9A993FFAC9B83FFA08F75FF8E816DFF8478
      69FFAA9E8DFFBFB2A0FF655E53FF000000009E907AFF3E3E3EFF514E51FF403C
      3EFF34B93FFF415F46FF23C62EFF14501BFF145A1AFF0A0309FF08330CFF0600
      04FF15E626FF000000FF111111FF9E907AFF3C270BB58D6225FE906225FF8F61
      24FF8F6124FF906225FF8E6225FE493312CD512D00FFE9C086FFE6C28FFFE6C1
      8DFFE6C18DFFE6C28EFFEBC28AFF522F01FE3F8853EC92FDACFF82F1A0FF77EF
      97FF6DED90FF63EC88FF5AEA81FF50E87AFF46E470FF41E56DFF30C457FF2FBF
      54FF2FC153FF2CC055FF2EC556FF0F5D23F2000000007B766EFDE1D7C8FFFAF2
      EAFFF1E8DDFFE3D7CAFFC9BAA7FFB9A893FFAB9980FF9D8B70FF887A67FF776D
      5FFF8E8377FFBBAE9FFF6B6459FD000000009E907AFF429546FF6EE878FF56D1
      5EFF2CCC36FF52A158FF48AE4FFF1C7B23FF18A320FF1DB128FF2AD536FF094C
      11FF10A518FF20F72FFF15811BFF9E907AFF74490FFEFFFAD0FFFFF4CAFFFFF3
      C9FFFFF3C9FFFFF4CAFFFFFAD0FF784A0FFF463219F75A3300FE5B3301FF5A33
      01FF5A3301FF5B3301FF5A3402FE261602B64A8B5BED9BFCB5FF8FF1A8FF84F0
      A1FF79EF99FF70ED91FF65EB89FF5CE981FF53E579FF4AE674FF2EBF54FF2BB7
      50FF2BB750FF2AB84EFF2BBF54FF0F5D23F300000000777064FFE9DCCCFFFAF5
      EDFFECE7E0FFD3CCC4FFB5AC9FFFB5AA9CFFB5AA9AFFB8AB9AFFB5A897FFA79C
      8CFF9C9285FFA49A8DFF675F55FF000000009E907AFF404040FF5E455EFF62AB
      63FF56A059FF32E83DFF537755FF49AA4FFF1CA023FF1BA225FF090E07FF22C3
      2BFF055B07FF000000FF141414FF9E907AFF673E09FFF9D09AFFF0C993FFF0C9
      93FFF0C993FFF0C993FFF9D09AFF693E06FF0808095400000000000000000000
      000000000000000000000000000000000000568F64EDAAFEC0FF99F2B2FF8FF1
      AAFF86F0A2FF7CEE9AFF72EC93FF68EA8BFF5EE683FF56E87CFF31BB55FF28AF
      4CFF27AF4BFF27B04BFF29B74CFF0D5D22F3000000007D766BFFC2BCB5FFBFB9
      B2FFCEC6BCFFDCD3C8FFC8B9A6FFB8A892FFAB9980FF9C8B70FF887967FF8276
      67FFADA091FFCFC3B1FF686157FF000000009E907AFF3E3E3EFF687168FF5F87
      60FF617B60FF42E747FF3A593AFF5BD961FF4F9E51FF185919FF081107FF1DFF
      28FF001B00FF001000FF141414FF9E907AFF5C3806FFEABC80FFE3B77CFFE2B7
      79FFE2B779FFE3B77CFFEBBE82FF5D3702FF0707085100000000000000000000
      0000000000000000000000000000000000005A9069F0B4FDC9FFA6F4BBFF9CF3
      B3FF92F3ACFF88F0A4FF7EEF9BFF74EA93FF6AE88CFF64E986FF2FB752FF25A6
      46FF26A747FF23A846FF25AC49FF0E5B21F300000000807B73FDE2D6C9FFFCF5
      EFFFF4ECE2FFE9E0D5FFC8BAA7FFB9A893FFAB9981FF9D8C72FF8A7A68FF786E
      60FF988E82FFC4B8A9FF6A6258FD000000009E907AFF3F3F3FFF6E6A6EFF6771
      67FF615261FF649063FF192217FF65F26AFF4C3F4BFF3C343CFF000000FF1FE0
      21FF000000FF000000FF121212FF9E907AFF522F01FEE9C087FFE6C28FFFE6C1
      8DFFE6C18DFFE6C28EFFEBC28AFF512D00FF654A27F78D6223FE906225FF8F61
      24FF8F6124FF906225FF8E6225FE3C280BB6619570F0C2FED4FFB2F5C5FFA8F4
      BCFF9EF3B4FF95F1ADFF8AEFA5FF80EB9DFF76E995FF6FEB90FF2FB353FF209E
      41FF219E41FF22A142FF20A443FF0D5B23F30000000081796DFFE7DCCBFFFBF7
      F2FFF4EEE7FFE4DED9FFBEB3A7FFB6AC9DFFB4A897FFB4A694FFADA291FF9D92
      84FF90877BFFACA295FF665F55FF000000009E907AFF444444FF788378FF6E87
      6EFF687468FF667A66FF60645FFF2EE130FF374437FF3B4E3BFF395539FF0F47
      10FF001E00FF001100FF111111FF9E907AFF261502B55A3402FE5B3301FF5A33
      01FF5A3301FF5B3301FF5A3401FE2E1C07CE784B0FFFFFFAD0FFFFF4CAFFFFF3
      C9FFFFF3C9FFFFF4CAFFFFFAD0FF75490FFE76987EF1CFFEDBFFBEF8CDFFB5F6
      C6FFABF4C0FFA1F2B6FF97EFAEFF8EECA6FF83EA9FFF7CEC9CFF30AD4FFF1E94
      3DFF1C963DFF1F963CFF1F9B3FFF0D5C21F400000000867E74FFC0BAB3FFC9C4
      C0FFCAC4BCFFDBD5CDFFB8AA98FFB0A18CFFA4927AFF97876EFF8A7B69FF8A7D
      6DFFBAAD9EFFD7CBBBFF696157FF000000009E907AFF414141FF857E85FF7C88
      7CFF706B70FF606C60FF504750FF3F873FFF000000FF373437FF3D4B3DFF382D
      38FF203220FF000000FF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000086D4209FFF9D09AFFF0C993FFF0C9
      93FFF0C993FFF0C993FFF9D09AFF673E09FF719A7DF3D8FFE4FFCCF9D8FFC3F8
      CFFFB7F7C7FFADF3BFFFA6F1BAFF9BEEB2FF93EEABFF8FEFA7FF2EA84FFF1B8C
      35FF1A8D37FF198E38FF1C9339FF0C5922F5000000007C776FFCE0D4C6FFFEF9
      F6FFF5EFE7FFEFE9E2FFC8B9A5FFB8A791FFAB987EFF9D8970FF897B68FF796F
      61FFA2978BFFCEC2B4FF686055FD00000000998C78FF383838FF373737FF3232
      32FF2F2F2FFF2D2D2DFF2C2C2CFF2B2B2BFF1F1F1FFF050505FF1E1E1EFF2121
      21FF1F1F1FFF1D1D1DFF141414FF998C78FF0000000000000000000000000000
      000000000000000000000000000000000000633D06FFEABC80FFE3B77CFFE2B7
      79FFE2B779FFE3B77CFFEBBE82FF5C3806FF7E9F88F4DBFFE7FFD8FCE1FFD6FB
      E0FFCCFAD9FFBDF5CBFFA8EDBBFF8FE6A5FF77DD92FF60D17EFF24A446FF1584
      34FF178432FF168532FF158835FF0B5820F500000000877E73FFE6D9CAFFFCF9
      F4FFF3EEE8FFEEE9E3FFD6CCBEFFCFC5B5FFC8BBAAFFBDB19EFFACA08EFF877C
      70FF8C847AFFC0B7AAFF675E53FF00000000968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF0000000000000000000000000000
      000000000000000000000000000000000000593402FEE9C087FFE6C28FFFE6C1
      8DFFE6C18DFFE6C28EFFEBC28AFF522F01FE7B9282ECA1FBBAFF77EC97FF61E2
      83FF4BD770FF3ACC61FF2FC456FF2BBD51FF28B64CFF26B24AFF24AD47FF1EA5
      42FF179238FF148330FF13802DFF0B5720F5000000008D877EFEF9F4EDFFEDE8
      E0FFE3DBCFFFDBD1C2FFD9CCBDFFD6CAB9FFD4C8B7FFD5C7B6FFD4C6B4FFD6CA
      B6FFD7CAB8FFD2C6B3FF6D655AFE000000005A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C60000000000000000000000000000
      000000000000000000000000000000000000281702B55A3402FE5B3301FF5A33
      01FF5A3301FF5B3301FF5A3402FE261602B6121513625F7264D37AB18BFD69C3
      80FF52D073FF37D05FFF2FC857FF2FC355FF2DBC52FF29B64EFF25B149FF22A9
      44FF1C9E3EFF179237FF127E2EFF074117DB00000000474746B2BDBBB8FFE5E1
      DEFFF3ECE4FFF7EEE4FFF5ECE2FFF4EBE0FFF2E9DEFFF1E8DCFFF1E7D9FFECE1
      D4FFD5CBBFFFA1988AFF3A3831B4000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000140D0D
      0D50272B298E5A625CCD76A084FB34894AFA18652AE5114C21CF0C3517B80625
      0FA2041B0B8C03120675010B045F0000001C00000000000000020C0C0C4B3030
      2F95535151C2746F6BE688827EF38D8781FA8E877FFA87827CF3726D67E6504E
      49C22C2B29950A0A094B00000002000000000000000000000000000000000000
      0000000000000000000000000000000000000000269F17178BFE151489FF1514
      89FF13128AFF151488FF161689FE000023990000000000000000000000000000
      0000000000000000000000000000284246A93997A7FE2F94A5FE2F95A6FE2F98
      A8FE2D95A6FE2C95A6FE2C98A8FE1A4047AC000000000000000000020020030F
      065D07230F9B093B17D3041C0C9A0000000D0001001F000A0359021A09930A36
      16CC0B5B1FFA0114068200000006000000000000000002010035241602D92E1C
      03FD130B02B60000002600000000000000000000000000000000000000000000
      000000000000000000000000000000000000817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFFB2A797FF131392FF7071FFFF7B7DFFFF7A7C
      FFFF7A7CFFFF7C7DFFFF7172FFFF12128EFF817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFFAEA392FF63A6B2FF62EFFBFF41F0FCFF51F7FFFF2020
      20FF65F9FFFF70F8FEFF44F3FEFF309CACFE06160A671D6C31E12F994CFE3EB6
      5DFF44D16AFF37CD5EFF106C29FF0B501CF7146F2BFE20893CFF36A553FF51C5
      6DFF3BB558FF096F22FF031C0A980000000F00000000321D02D99E651CFFDF96
      39FF794D12FF2A1903F70A060180000000070000000000000000000000000000
      0000000000000000000000000000000000009E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF102C18FF6E8273FF0F0F8CFF4141E0FF3D3DD9FF3C3C
      D9FF3C3CD9FF3E3ED9FF4342E1FF0D0C89FF9E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF324938FF507B79FF6FCBD7FF65F6FFFF5EFFFFFF55CC
      CCFF7CFFFFFF85FAFFFF15D6EBFF749293FF20582FD485FFA5FF78F49AFF6CF1
      8FFF5FEC84FF43CF67FF137B2FFF188834FF3DBF5FFF44BE63FF4BC069FF55C4
      73FF38AE56FF0A8A2BFF096D25FF0418098C000000004E2D03FED99136FFFFC7
      74FFFFBA5DFFBF7C2BFF503108FF1A1002D90301004300000000000000000000
      0000000000000000000000000000000000009E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF132B1AFF6F8174FF0D0D8AFF2B2BC0FF2A2ABDFF2A2A
      BDFF2A2ABDFF2A2ABEFF2C2CC2FF0C0B86FF9E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF1F3626FF475D4DFF5C9BA5FF91EFF8FF63FFFFFF1A0A
      09FF6FFFFFFF3BE6F4FF3995A2FFAFA898FF276438DF94FFAFFF81F09FFF75EE
      97FF6CEB8EFF4BCF6DFF127B2DFF178634FF31B052FF37B357FF3EB85EFF4AC0
      69FF32AF54FF098528FF0C8B2DFF063F17DD000000004D2C03FFCA8830FFF8B8
      6CFFF6B668FFF7B360FFE39D42FF8E5A17FF362104FE100901A4000000170000
      0000000000000000000000000000000000009E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF14291AFF6F7E75FF0C0C87FF1F1FA3FF1D1DA2FF1D1D
      A4FF1D1DA3FF1D1DA3FF1F1FA5FF0B0A83FF9E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF14291AFF2A4031FF58746EFF6FBECBFFA8FFFFFF3924
      22FF70FBFFFF13BED5FF507B73FFA89C8AFF2E7341EA9FFFB8FF8DF1A8FF82EF
      9EFF78ED97FF53D073FF117B2FFF138331FF24A646FF2DAC4EFF3FB85FFF55D2
      75FF2FAD50FF0A7C27FF0B8529FF083F15E0000000004D2D03FFC1802DFFE6AA
      5CFFE2A459FFE2A355FFE1A154FFE29E49FFBE7D2CFF643E0CFF241604EE0704
      0068000000020000000000000000000000009E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF18291DFF6F7C75FF101085FF4040A0FF3D3D9FFF3D3D
      9FFF3D3D9FFF3D3D9FFF3F3FA1FF0E0D82FF9E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF18291DFF182C1EFF3D5143FF599197FFA4F0F9FF6285
      85FF7AE9F6FF4E8F94FF385B42FFA19480FF38804BF3ACFEC2FF9BF3B3FF8FF1
      A9FF87EFA3FF5DD37CFF10782CFF11772CFF178B36FF26A046FF3CB75CFF39B4
      59FF269E46FF097628FF0C7C27FF064216EB000000004E2D03FFB87B29FFD298
      4EFFCF9348FFCF9045FFCC8E42FFCB8D40FFCC8D3DFFC78734FF98611AFF462B
      07FF180D03C70100002F00000000000000009E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF18C248FF5EDF83FF131484FF6F6FAAFF6A6AA8FF6A6A
      A8FF6A6AA8FF6C6CA8FF7070ABFF111081FF9E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF18C248FF18D44DFF2BFD66FF52685EFF72B3BFFFB3F5
      FEFF5AADBBFF4D6B5BFF194125FF9E907AFF459058FBBFFFD0FFABF5BFFF91EE
      A7FF70DF8DFF43C364FF0D6D26FF0B6624FF12792FFF178533FF1B963CFF20A1
      40FF19963BFF0B7528FF0A7426FF074617F5000000004F2D03FFB07326FFBE85
      3CFFBA8338FFB97E36FFB77C34FFB67A31FFB47A2FFFB5782EFFB4762BFFAC6F
      23FF754910FF311E05FA06030062000000009E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF232C25FF656D66FF33367EFF262795FF242495FF2424
      94FF232394FF232394FF232493FF4E4B93FF9E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF232C25FF1F2C23FF17281CFF324537FF557C78FF6AAC
      B9FF4B7979FF294632FF072E11FF9E907AFF438655F466DA85FF3FDD69FF30CB
      59FF4DD270FF59DB7CFF60E685FF63F289FF5EF786FF25933FFF17742FFF1585
      32FF149437FF159737FF0E842DFF064C19FE00000000502E04FFA76D22FFA76F
      2CFFA66D2AFFA46B27FFA26A26FFA16824FF9F6723FF9E6622FF9D6520FF9C64
      1FFF9D641EFF8D5914FF241604EC000000009E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF454B47FF545D56FF6D776FFF6E7A70FF7583
      79FF758679FF75897BFF728678FFABA08EFF9E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF232B25FF1F2C22FF1E2F22FF2D3F32FF2E43
      34FF263E2CFF102F19FF04280FFF9E907AFF0104022D17331F9D418753F540B0
      5DFF89F9A6FF82F7A0FF77F198FF6EEE91FF68F48DFF249140FF186F2FFF166D
      2DFF0E5F23FF0A5D21FD064A1AE4011A088E00000000503004FF9E6620FF925E
      21FF915D20FF905C1DFF8F5A1CFF8D581AFF8D5819FF8F5B1EFF916124FF966A
      31FF9D723DFF93601DFF2E1D04F0000000009E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF232D25FF152319FF021507FF0217
      07FF021C09FF03200BFF03240CFF9E907AFF9E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF232D25FF152319FF021507FF0217
      07FF021C09FF03200BFF03240CFF9E907AFF0000000000000000000000122156
      2FD695F8AEFF8CF5A9FF83F0A1FF78EF99FF73F594FF23903FFF187030FF186F
      2EFF082910D00000000A000000000000000000000000523004FF996420FF885C
      26FF8A5E29FF8B602CFF8E6432FF926A39FF977244FF9B774BFF9D7D55FF9770
      3EFF885514FF543305FD0C06006F000000009E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF9E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF0000000000000000000000001C52
      2BCEA3FCBAFF98F7B0FF8FF1A9FF86F0A2FF80F6A0FF228F40FF187131FF1872
      2FFF082F12D000000000000000000000000000000000513003FF976628FF8763
      39FF8A683EFF8D6C44FF90714AFF947751FF987C5BFF967854FF916123FF6E42
      09FF321E02D40402003E00000000000000009E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF9E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF0000000000000000000000001C56
      2CD1B2FFC6FFA5F6BBFF9CF2B2FF92F2ADFF8FF7ABFF23913FFF187531FF1772
      31FF093315D3000000000000000000000000000000005C3809FF95682FFF886D
      4EFF8C7252FF907758FF977E61FF978267FF926B3AFF82500EFF4A2B03F30F09
      007500000005000000000000000000000000998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF0000000000000000000000001F5C
      2FD7C8FFDAFFB6F9C9FFA5F4B9FF90F0A9FF7EED9CFF249843FF187330FF1871
      2FFF0B4018DB0000000000000000000000000000000083561DFF946B38FF8E7B
      62FF948268FF998973FF8E7555FF905D1BFF633B06FE211202AD0100001D0000
      000000000000000000000000000000000000968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF0000000000000000000000001D52
      2BCA62C57CFF4DD871FF3EE069FF39D762FF37D260FF37D05FFF2FBC53FF2191
      3DFF0C441BDA00000000000000000000000000000000A5712CFE957040FF9C90
      81FF938572FF936730FF7A4A0BFF361F01DC0603004A00000000000000000000
      0000000000000000000000000000000000005A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C65A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C60000000000000000000000000003
      0129091A0E74183C21B1327242EA2D8A47FC1B6A2FE9125023D40E3C19BE0A2F
      14A8020E065C000000000000000000000000000000006E4A1FD7B97D31FF9774
      46FFA86D21FF5D390BF7120B0082000000090000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000006040135714C1FD9A972
      2FFD442E12B60201002600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005D3A0DFE5D3A0DFF5D3A0DFF5C390DFE000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000B010B0462074016CB0E5F
      22FD063B13CB000903610000000A000000000000000000000000000000000000
      000000000000000000000000000000000000000000002E1E06C084561CFF2E1D
      05BF000000002E1E06C084561CFF2E1D05BF0000000000000000000000000000
      00000000000000000000000000000000000003220BA70E5721F7000B03870000
      000A000000000000000000000000000000000000000000000000000000004F4F
      4EFF3C3C3BFF3C3C3BFFB7813BFFD1903BFFAD732AFFB67D34FF363635FF3C3C
      3BFF3C3C3BFF000000000000000000000000817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9F927EFFA49C8BFF41764AFF168533FF41A55CFF1E8F
      3BFF279A45FF167B30FF3F6D44FF87806FE7817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF9E907AFFC1B9ACFF96621FFFFFCB74FF945F
      1DFFC3BBAFFF96621FFFFFCB74FF945F1DFF817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFFBAB1A2FF12722CFF76FF9EFF3BBE5BFF1C56
      2BFF7E8571FFADA292FFA49784FF817564E6000000000000000000000000CACA
      CAFFBEBEBEFFBEBEBEFF98621EFFDF9A40FF7B4E15FF95601BFFABABABFFBEBE
      BEFFABABABFF0000000000000000000000009E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF2A4331FF396445FF188D36FF64B779FFFFFFFFFF60B1
      76FF148C33FF239A42FF177D32FF72866AFF9E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF102C18FF0E2E17FF95A498FF875416FFD5933EFF8453
      16FF9AAF9FFF875416FFD5933EFF845316FF9E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF102C18FF7C8E82FF0F6927FF67F98CFF5FF185FF4EE5
      73FF198235FF1C4728FF41694CFFA99C8AFF0000000000000000000000000000
      000000000000000000000504013ABA7C2DFF754B13FF05030139000000000000
      0000000000000000000000000000000000009E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF405346FF236A36FF5DB775FFFFFFFFFF90D0A1FFFFFF
      FFFF63B478FF158D34FF279D46FF2A6B38FF9E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF132B1AFF112D18FF95A399FF7A4D13FFA56C24FF794C
      12FF9AAC9FFF7A4D13FFA56C24FF794C12FF9E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF132B1AFF7D8D83FF0F6727FF49D96DFF40CA63FF3AC4
      5EFF36BF59FF26AB48FF105C24FF687560FF00000000524C3EE95A5344FF5B54
      45FF5C5647FF5D5749FF5E584AFF5F594BFF5F594BFF5E5849FF5D5748FF5C56
      47FF5B5445FF5A5344FF534E3FEB000000009E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF4A5B4FFF18622BFF4BAA63FF71C888FF21A945FF70C6
      88FFFFFFFFFF66B77AFF1C913AFF115F24FF9E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF14291AFF122B19FF95A19AFF734710FF84561BFF7146
      0FFF9AAB9FFF734710FF84561BFF71460FFF9E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF14291AFF7D8C83FF0F6426FF31B552FF2BAA4BFF25A0
      45FF219740FF249441FF2F984AFF0F5420FF00000000585143FF1C211CFF1520
      18FF142117FF0F2014FF0D2112FF0C2212FF0B2411FF092610FF06280FFF052A
      0FFF052D10FF092A11FF585143FF000000009E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF455349FF327142FF4DB668FF41B860FF3AB65AFF30B0
      51FF7ACB90FFFFFFFFFF58B570FF327440FF9E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF18291DFF132819FF96A09AFF724C1AFF896C49FF714A
      19FF9CAA9FFF724C1AFF896C49FF714A19FF9E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF18291DFF7D8A83FF0F6427FF37A553FF399A52FF4298
      58FF539A64FF48985DFF176E2EFF5B7C59FF000000005A5344FF1E211DFF2D36
      30FF28352CFF1F3124FF142B1BFF122D19FF0F2E18FF0D3016FF0A3215FF0834
      14FF073713FF0A2F13FF5A5344FF000000009E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF32C65CFF47AB62FF68B57CFF5ABF75FF46B664FF3EB2
      5DFF3BB159FF7BCC91FF37914EFF778D70FF9E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF18C248FF18D44DFF6FFC98FF775628FF9D9383FF7755
      28FF97A59AFF775628FF9D9383FF785529FF9E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF18C248FF65DF88FF13652AFF57A26AFF629B71FF629A
      71FF2A8342FF206733FF43684DFFA99F8DFF000000005C5546FF1F211EFF3237
      33FF29322BFF253128FF192A1EFF132A1AFF112B18FF0E2D17FF0C2F15FF0931
      14FF073313FF092B12FF5C5546FF000000009E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF2B342DFF455248FF416F4EFF72B986FF80D696FF69CD
      85FF57C473FF3AA155FF2E6A3EFFA49A8AFF9E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF232C25FF1F2C23FF6F7971FF876636FFA77940FF8666
      35FF8A998EFF856634FFA77940FF9E7746FF9E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF232C25FF727B75FF1E7B36FF7CA788FF4A975EFF2478
      3BFF44734FFF5B7261FF315139FF9E917BFF000000005E5848FF21211FFF3537
      36FF2E332FFF252E27FF202D24FF17281CFF132919FF102A17FF0E2C16FF0B2E
      14FF052D10FF08270FFF5E5848FF000000009E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF313833FF445047FF476750FF3B7449FF2265
      33FF306F41FF3D6346FF2F4F37FFA19482FF9E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF232B25FF434E46FF7D877EFF838E87FF7383
      76FF5F7265FF829285FF8B9B8FFFB4A99AFF9E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF565D57FF3E8952FF268140FF39734AFF6274
      66FF364C3AFF0A2A13FF04280FFF9E907AFF00000000625A4CFF232220FF3939
      39FF333534FF272B27FF232B24FF1F2C23FF16271BFF122818FF0F2916FF0625
      0EFF04270DFF07230DFF625A4CFF000000009E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF2A342CFF2F3B32FF334337FF3D4C
      41FF334839FF1F3925FF0B2B14FF9D8F7AFF9E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF232D25FF152319FF021507FF0217
      07FF021C09FF03200BFF03240CFF9E907AFF9E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF313330FF666D67FF656E68FF3B4A40FF1024
      15FF021C09FF03200BFF03240CFF9E907AFF00000000655E4FFF242523FF2D93
      44FF374C3CFF24C148FF20BD43FF233126FF1F2B22FF132518FF051B0BFF021D
      0AFF03220BFF061F0CFF655E4FFF000000009E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF9E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF9E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF00000000696152FF20963BFF27E0
      52FF2D8341FF2F3530FF292F2AFF1E231FFF19211AFF0C1A0FFF05170AFF0218
      08FF021D0AFF051B0BFF696152FF000000009E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF9E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF9E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF000000006B6354FF246031FF28E1
      53FF2DA949FF2D2D2DFF1F1F1FFF0C0D0DFF030804FF0C150EFF0C190FFF081A
      0DFF031908FF041709FF6B6354FF00000000998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF000000006E6657FF1F1F1DFF1C65
      2BFF141413FF10100FFF0F0F0EFF0F0F0DFF0C0D0BFF080C08FF0C120CFF0C14
      0DFF0B160DFF09150BFF6D6657FF00000000968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF00000000736B5CFEB1A694FFB3A8
      97FFB7AC9DFFBBB2A4FFBFB6A8FFC2B9ACFFC1B8ABFFBDB4A5FFCEC8BCFFD5CF
      C4FF6E6BBCFF5251C9FF736A5CFF000000005A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C65A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C65A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C600000000585245E1797062FF7971
      63FF7A7264FF7B7365FF7C7466FF7C7467FF7C7466FF7B7365FF797163FF7870
      62FF777061FF776F61FF5A5345E2000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000101013310100F9B1E1E1EDE282929FB292929FC1F1F1DDF0F0F0F9D0202
      0236000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000B0007319E01147FE70115
      8EFD00107CE700052E9D0000000A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000B120B0286452A06E15B3A
      0AFD412503E1100900850000000A000000000000000000000000000000091715
      159B424340FE8B8B89FFA8A4A1FFBBB5AEFFBDB7B0FFAAA6A1FF8C8C8AFF4445
      42FE181716A00000000B0000000000000000817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF817563E6817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFFA29581FFA79D92FF1E319CFF0027DCFF052BDDFF0E36
      DCFF173ADAFF062BD1FF1E2A91FF8A8178E7817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFFA19480FFA89D8DFF6D5128FF925C17FF956930FF9367
      30FF956C39FF845317FF5F4625FF8A8172E70000000000000008272623C17978
      72FFB3AEA8FFA69A8BFFAA9E8DFFB0A595FFA79B8BFFBBAD9AFFA69B8AFFB4AF
      A8FF7B7B76FF33312CD10000000B000000009E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF102C18FF0E2E17FF0C3116FF0A3115FF093514FF0736
      13FF073914FF073D15FF094218FF9E907AFF9E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF314938FF263A7EFF0026E8FFBBC5F4FF5F73E2FF0018
      D9FF576AE1FFBFC9F4FF072DD5FF474D8BFF9E907AFF1C251EFF1B291FFF1A2C
      1FFF152A1BFF122A19FF2F4736FF645937FF9C6316FF9C651EFFE9DECFFFFFFF
      FFFFE9DECFFF916123FF875619FF77664EFF000000002A2823AD85857CFFA59D
      92FF9E9382FF9D9181FFBFBBB6FFEBE8E6FFDAD7D4FF958D81FFB7AB9BFFA499
      89FFA39B91FF88877EFF2C2B25B2000000009E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF132B1AFF112D18FF0F2E17FF0C3016FF0A3115FF0833
      14FF073513FF063914FF073D15FF9E907AFF9E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF47594CFF1229A0FF0028EEFF546AEBFFFFFFFFFF6B7C
      E9FFFFFFFFFF5468E8FF1238DEFF0F2093FF9E907AFF222822FF242D27FF1E2C
      22FF1E2F23FF152A1BFF45584BFF896129FFA5681AFF9C6114FFA7783AFFFFFF
      FFFF9D6C2BFF8A520BFF966426FF644319FF030303306A675BFDADA89DFF8E83
      74FF9A8E7EFF958979FFC8C5C0FFE5E2DEFFE2E1DFFF958C81FFABA090FFAA9F
      91FF968B7CFFACA69DFF6E6C5FFE040403359E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF14291AFF122B19FF102C18FF0E2D16FF0C2F15FF0931
      14FF073213FF063513FF063A15FF9E907AFF9E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF4E5D52FF132BA1FF2148F4FF001AEBFF6A7CEDFFFFFF
      FFFF6A7CECFF0018DEFF072FE0FF051892FF9E907AFF242724FF262E27FF2029
      22FF212E25FF1C2B21FF4E5D52FF986627FFB7823CFFA36617FFE9DECFFFFFFF
      FFFFA17030FF925A10FF955F1BFF674212FF2F2E27ABAEAB9EFF7D7467FF8B81
      72FF95897BFF9C9180FF7C7468FF989289FF857C71FF897C6EFF9E9283FF9C91
      83FF9C9386FF81776AFFB0AE9FFF323129B09E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF18291DFF132819FF112A18FF0F2B17FF0D2C16FF0B2E
      14FF0A3013FF063111FF063412FF9E907AFF9E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF4B574EFF243AA3FF3F62F9FF6B7CEBFFFFFFFFFF6E82
      F1FFFFFFFFFF5C70E5FF002BE6FF122698FF9E907AFF262727FF292C2AFF252B
      26FF202922FF212E25FF49564DFF96703CFFC6995BFFBF9255FFB7915CFFC8B1
      8FFFAC7C3CFF9F6820FF9C641BFF725125FF5A574ADFB3AFA0FF82786DFF857A
      6DFF8D8274FF928776FFC3C0BAFFE9E8E6FFE1DFDDFF8B8274FF958A7AFF8F84
      75FF92897CFF83796EFFB0AC9DFF605C4FE49E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF18C248FF18D44DFF19FF5AFF112917FF0E2A16FF0D2D
      16FF082C12FF052C0FFF053012FF9E907AFF9E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF38C761FF3D7491FF5675FCFFCDD5FDFF7D8FF3FF345A
      F4FF7285F1FFC1CCFAFF0B36ECFF4B5291FF9E907AFF292929FF383839FF18E8
      53FF2A2A2AFF232C25FF36C760FF709252FFDCB989FFC99F65FFD0B58FFFFFFF
      FFFFC4A273FFAB752FFFA7702AFF816E55FF837F6AF7A9A498FF8B8379FF8377
      6CFF857A6DFF8A7D70FFAAA49CFFEBEAE7FFE4E2E0FFD3D0CDFF7B7266FF867B
      6EFF82776BFF81776EFFA09B8EFF898570FC9E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF232C25FF1F2C23FF15261AFF122718FF112816FF0C29
      14FF04240CFF04280EFF052C0FFF9E907AFF9E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF2F3831FF4E5854FF44509BFF6382FCFF4C6EFCFF3A5F
      F9FF264EF8FF1D46F4FF1E3799FFA89F94FF9E907AFF2B2B2BFF19FF5AFF19FF
      5AFF18B444FF202621FF2E362FFF4E564DFF8D6D43FFE2C298FFD0A973FFD5B8
      90FFBF8F4FFFB7833DFF7A6237FFAA9F8DFF8F8B73F8A7A297FF89827AFF8B84
      79FF837A6DFF786E61FF776D60FFBAB5AEFFEAE8E6FFE6E5E3FFD8D7D3FF6D64
      5AFF766E62FF857D73FF9F9A8FFF96907AFC9E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF232B25FF1F2C22FF152619FF0E2314FF031C
      0AFF03200AFF03240CFF04280FFF9E907AFF9E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF353D37FF505A53FF5F6887FF344195FF1C2B
      8CFF253792FF3F517EFF385345FFA39684FF9E907AFF2E2D2EFF2F2F30FF18A4
      40FF19FF5AFF242725FF222924FF343C36FF4E564CFF6F6146FF9A7848FF9A6D
      2EFF936F39FF665F3EFF39523DFFA39683FF6C6959DFB2AEA0FF8C857EFF8A84
      7BFFCDCBC6FFD6D4D1FFA09B94FF665E52FF989189FFE7E5E4FFEBE9E9FF9994
      8EFF878076FF817972FFAEAA9CFF756F5EE59E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF232D25FF152319FF021507FF0217
      07FF021C09FF03200BFF03240CFF9E907AFF9E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF2F3931FF36423AFF3B493EFF4251
      45FF3B4F3FFF273F2DFF11301AFF9D8F7AFF9E907AFF323233FF19FF5AFF18A4
      40FF2F2F2FFF2E282CFF141715FF242623FF2E372FFF334037FF38463CFF4050
      44FF384D3DFF243D2BFF0F2E18FF9D8F7AFF3D3B34ACBAB7A8FF8A857EFF918A
      84FFDEDBD9FFF2F1F1FFAFAAA5FF817970FF8F8980FFEEEDECFFEEEDEDFFA8A3
      9EFF827B73FF7B756EFFBAB7A8FF3836309C9E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF9E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF9E907AFF333034FF18B444FF19FF
      5AFF19FF5AFF302A2EFF2E282CFF141715FF0E150FFF0C160EFF0C1A0FFF0517
      0AFF021707FF021C09FF03200CFF9E907AFF05050430ACA99BFD97948EFF9791
      8DFFBDBAB6FFF7F8F8FFEFEDEEFFF1F1F1FFEFEFEEFFEFEDECFFF5F5F5FF908B
      83FF817B75FF928F87FFAEAC9CFE070606359E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF9E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF9E907AFF383337FF312D31FF18E8
      53FF312D31FF212121FF141414FF0B0C0BFF000200FF0B120CFF0D1810FF0C1B
      10FF091B0EFF021808FF021C09FF9E907AFF000000003939349ABAB8AEFF8581
      7AFFA09C98FFC3C1BEFFF5F5F4FFF9F8F8FFF8F9F8FFF1F0F0FFA39D99FF8681
      7AFF7C7871FFBBB9B0FF3F3E39A100000000998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF998C78FF1E1C1DFF1C211EFF120D
      11FF0E0E0EFF0F0F0FFF0E0E0EFF0E0E0EFF090809FF000200FF080F09FF0B15
      0DFF0A190EFF0A1C0FFF041A0AFF998C78FF000000000000000A595753C3B8B6
      B0FF817C75FFA6A39FFF96928BFF98938DFF938E88FF8E8983FF918D88FF7C78
      70FFB9B9B2FF5E5C57C70000000B00000000968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF00000000000000000000000A3C3C
      3A9EAEADAAFE979591FF8A8781FF7D7972FF7C7770FF89857EFF989591FFB0AF
      ACFE3F3F3DA20000000B00000000000000005A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C65A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C65A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C60000000000000000000000000000
      0000070706363A3A399E797977E0A9A9AAFEA9AAAAFE7B7A7AE13C3B3AA00807
      0739000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000015020A0B57032126A5073B45E10A4B59FA0111
      1485000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000090907036A34291CDB3C34
      28E47B7775FF767371FF706D6AFF676360FF5F5A57FF57524EFF524D49FF423E
      39FD322512ED312312ED221402DB0E0701920000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000A030A
      0C590A20249510222592185965FD1C788AFF1B899EFF1C98AFFF12859CFF0034
      3FFE011115980000000200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000120E087D654826FF5D431FFF5E40
      1CFFD3D1D1FFBBB7B6FFB6B1AFFFBDB9B5FFB1ADA9FFACA6A1FFA19A93FF9E99
      96FF5A3D17FF573B18FF4F330FFF321E05FF817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF817563E6040909461E3E43C52C626DF8337A
      87FF3B99A9FF41828EFF40A7B8FF3FB3C5FF38ACC2FF2BA3BAFF158AA2FF0053
      65FF04323FFE05161AA400000005000000000000000004040552202325D83438
      3DFF2B2F31EF0D0E0F88000000000000000000000000000000000D0E0E882A2D
      30EF353A3EFF212526D80404055200000000523F28FC6C502DFF5B411EFF5B3D
      18FFC8C7C7FF5F401AFF5F401AFFC2BFBEFFC4C0BEFFB3AEA9FFA5A09BFF9E98
      96FF573916FF543916FF543B17FF301D05FF9E907AFF282828FF2D2D2DFF3131
      31FF1F1F1FFF181818FF181818FF161616FF161616FF131313FF101010FF0F0F
      0FFF0E0E0EFF0E0E0EFF0E0E0EFF9E907AFF2E585FE066BBCBFF69C9DBFF62C4
      D5FF55BFD1FF50828AFF7BCDDFFF5CBCCFFF4DB4CAFF32A8BDFF178EA6FF0362
      75FF004253FF082F37FF001215B3000000080304044E383D40FD898D91FF9294
      96FF61676EFF383E42FF111314A00000000000000000121414A04B4F53FF989B
      A0FF797D83FF52575FFF31383CFD0303044E534029FC735632FF5C411EFF5C3D
      18FFBAB8BAFF60421DFF60421DFFC4C3C1FFC8C6C4FFC0BCB9FFB3ADA9FF9E99
      96FF563915FF553A17FF503512FF321E06FF9E907AFF2C2C2CFF48AB61FF2B70
      3DFF48AB61FF447550FF1B973BFF1F6431FF1B973BFF1D622FFF1B973BFF1A5F
      2CFF1B973BFF195E2BFF111111FF9E907AFF2C5A62F19CE2EDFF84D3DEFF73CB
      D8FF5DC2D2FF51808AFF90D6E8FF71C5D7FF5CBACFFF3BABC1FF198FA8FF076B
      82FF004A5CFF083B44FF002E33FF000E10A51C1F21CF525960FFA49267FFCCBD
      7BFFC2AB76FF7E7D7CFF2C3439FE0000000000000000353B40FE696A68FFB29E
      66FFD1C180FFB5A381FF54595EFF181C1ECF55422BFC7A5C3AFF5E411EFF5C3F
      1AFFACACADFF5F401AFF5F401AFFC4C3C2FFCDCDCCFFC5C4C0FFB7B4B0FFA8A3
      9FFF563915FF563B18FF583E1BFF35230BFF9E907AFF2F2F2FFF6FE789FF459A
      58FF6FE789FF5F9B6AFF4BE16CFF3B8F4DFF4BE16CFF398D4BFF4BE16CFF358A
      48FF4BE16CFF358947FF111111FF9E907AFF29545BF2ACE8F1FF97DDE3FF82D2
      DCFF65C5D3FF51818AFF95D7EAFF88CFDFFF7BCBDDFF4EB7CCFF1994ACFF0973
      8CFF005364FF0A434FFF003C43FF00181CE32A3237FA323028FF74531CFF866D
      3BFF795A25FF947E62FF20292EFF000000200000002031383CFF453417FF7C60
      2BFF866D3BFF745118FF77726AFF23292FFA57442EFC816440FF5D4220FF5C3F
      1CFFADA7A3FFB8B3AFFFB8B4B1FFC2BFBEFFC4C2C1FFBEBBB7FFB8B4B1FFAAA5
      A1FF563A17FF573C1AFF614724FF3A2810FF9E907AFF323232FF56FFDDFF3DB3
      9CFF56FFDDFF59AF9DFF56FFDDFF2AA18AFF2CFFD6FF289F88FF2CFFD6FF259C
      85FF2CFFD6FF239A83FF111111FF9E907AFF32616BF0ADEAF2FFA9E5E9FF9BDF
      E6FF76D1DFFF52858EFF91D9ECFF7ACBDDFF5BA5B4FF468A98FF2A6875FF0F7A
      93FF035F73FF0D4855FF00414AFF001C1FEA1C2224E7292924FF705432FF7560
      41FF785E3FFF433826FF3F4850FF171919A9171818A7475055FF372A15FF775E
      3EFF765D3FFF6C502CFF373A36FF171C20E758462FFC876946FF684B27FF664A
      26FF664925FF674A25FF644723FF624521FF614420FF5C401CFF5A3E1CFF5A3E
      1CFF5A3E1CFF5B3F1CFF674D2DFF3F2D13FF9E907AFF373737FF6A6A6AFF6464
      64FF0AF3FFFF4DACB0FF3BF5FEFF1C9FA6FF0AF3FFFF179AA1FF242424FF2323
      23FF0AF3FFFF11949BFF131313FF9E907AFF2E565CD7AEEBF5FF94CDD3FF7EB2
      B8FF659AA0FF55747AFF467682FF427D89FF4292A1FF2C99AEFF1490AAFF1144
      50FF105361FF0E4F5DFF004652FF001C21EC1A1B1D934B5359FF352D21FF6556
      42FF403728FF252E34FF3A4549FF3D4348FF393F43FF616A71FF333A3CFF4E40
      2FFF685844FF2C2820FF444E54FF1A1A1B945A4731FC896C49FF9C7A4FFFD1A9
      73FFE7BA80FFE4B475FFDFAF6DFFDCAA63FFD7A35CFFD49E53FFD2994BFFCD93
      42FFB68136FF684922FF6D5332FF453018FF9E907AFF3A3A3AFF717171FF6B6B
      6BFF3DB1FEFF1F699BFF5F5F5FFF545454FF0D9EFFFF1A6BA2FF272727FF2323
      23FF1A1A1AFF1B1B1BFF141414FF9E907AFF2D4043B96798A3FF67A1ABFF62AF
      BDFF56BBCEFF497680FF65C6D9FF52BACDFF46B4C8FF35AAC1FF1895AFFF0369
      82FF064755FF193A41FF055262FF001B20D30102022C6A7074FF9BA0A5FF626A
      6FFF5C666AFF313D40FF2B373CFF404A4EFF3B454AFF59656BFFB7B9BBFF7D87
      8AFF535C60FF505B5FFF5E656AFF0102022C5B4A33FC90714DFFD9B07CFFEEC2
      89FFE7BA80FFE4B475FFDFAF6DFFDCAA63FFD7A35CFFD49E53FFD2994BFFCD93
      42FFCC903CFFA16F2DFF725835FF48351DFF9E907AFF3E3E3EFF777777FF7070
      70FF6D6D6DFF4B4B4BFF515151FF606060FF4378FEFF2147A5FF252525FF1B1B
      1BFF1A1A1AFF1B1B1BFF141414FF9E907AFF325961D89CE1F2FF85D4E4FF77CD
      DDFF63C5D8FF4D7880FF91D7E8FF6AC3D6FF59BBCDFF3CADC2FF1998B2FF0772
      8BFF005A6FFF0A4855FF0E3540FF03171BC70000000035393CDABFC1C3FFD8D7
      D7FF798082FF455255FF556065FFA2A7ABFF737C82FF626D72FF727B80FFC7C8
      C9FF5F686AFF344044FF353A3CDB000000005D4A34FC957852FFFAF4F0FFFEF9
      F4FFFCF8EFFFFBF6EEFFF9F0E5FFF9F0E5FFF9F2E8FFFAF1E6FFF8EEE3FFF8ED
      E1FFF7ECDDFFF7F2EDFF7A5F3EFF4D3B22FF9E907AFF3F3F3FFF7B7B7BFF7575
      75FF6F6F6FFF6D6D6DFF393939FF595959FF3C3C99FF3D3D70FF1C1C1CFF1414
      14FF161616FF161616FF121212FF9E907AFF335F68F2B2E9F6FF9ADDE9FF86D3
      E1FF6AC7D9FF4D7681FF9ADCEBFF7DCADDFF68C1D4FF47B0C7FF1B98B3FF0A78
      92FF015E73FF0E515EFF004558FF00161CD40000000012131480919598FFDCDC
      DCFF8F9394FF576265FF8B969DFF9CA5ADFF939DA3FF606B71FF70787BFFB0B2
      B3FF454F52FF394347FF0F101180000000005E4C36FC9C8058FFFAF5F0FFF3E1
      CBFFF3E1CBFFF3E0CAFFF2E0C8FFF2DFC8FFF1DFC6FFF0DBC1FFEFDBC0FFEFDB
      C1FFF0DCC4FFF9F4F0FF836845FF523E25FF9E907AFF444444FF828282FF7B7B
      7BFF777777FF727272FF6B6B6BFF2D2D2DFF4B4B4BFF4D4D4DFF474747FF2626
      26FF141414FF161616FF111111FF9E907AFF356269F3B3EAF8FFAAE3EDFF97DC
      E4FF75CCDDFF4C7781FF9EDFECFF93D3E6FF8BCFE2FF62BDD3FF1F9AB4FF0C7E
      99FF02647BFF105461FF004D60FF001F27F1000000000101011E595D61FED8D9
      DAFFA8ABACFF606B6EFF778389FF747C83FF747D84FF59666CFF7A8385FF9397
      99FF374346FF3A4146FE0000001E000000005E4E38FCA4875FFFFAF5F1FFFDFA
      F7FFFDFAF7FFFDF9F6FFFDF9F6FFFDF9F4FFFDF9F4FFFCF8F3FFFBF6F0FFFBF7
      F1FFFBF5F0FFF9F4F0FF8A6F4DFF57432AFF9E907AFF484848FF8C8C8CFF8787
      87FF7C7C7CFF6F6F6FFF636363FF505050FF181818FF484848FF4F4F4FFF4B4B
      4BFF363636FF171717FF111111FF9E907AFF35626AF2B6EBFAFFB7E8F1FFB1E8
      ECFF8DD9E3FF5A919CFF86D4E3FF70C5DAFF5DBBD0FF3FADC3FF1B99B5FF118A
      A6FF07708AFF115764FF025669FF00202AF200000000000000001D2023BF9598
      9AFF97999AFF1D2529FF485156FF697074FF495156FF707579FFB2B3B2FF484F
      51FF1F282CFF1D2021C10000000000000000604E39FCAC8F68FFFBF5F1FFF3E1
      CBFFF3E1CBFFF3E0CAFFF2E0C8FFF2DFC8FFF1DFC6FFF0DBC1FFEFDBC0FFEFDB
      C1FFF0DCC4FFF9F4F0FF917755FF5A4830FF998C78FF3E3E3EFF3D3D3DFF3737
      37FF343434FF323232FF313131FF303030FF232323FF050505FF1E1E1EFF2525
      25FF232323FF202020FF141414FF998C78FF3D636BE492DBECFF83D4E5FF70CA
      DCFF60C3D7FF4FA3B3FF418F9FFF3790A2FF2CA6BFFF239FB9FF2095AFFF248B
      A0FF27798DFF196E80FF076475FF002834F400000000000000000000001C3B3B
      3BC7585959FF000205FA5C6166FE979C9DFF3F4A4EFF4D5256F95A5957FC0C12
      15FF020608CA0000001C000000000000000062503BFC8F7658FFF8F2EBFFFDFA
      F7FFFDFAF7FFFDF9F6FFFDF9F6FFFDF9F4FFFDF9F4FFFCF8F3FFFBF6F0FFFBF7
      F1FFFBF5F0FFF9F4F0FF967B5BFF5F4C33FF968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF070C0E502B4D53C946808CFA4E97
      A7FF569FAEFF54AABCFF4EA9BDFF479FB1FF408F9FFF3D808FFF278498FF158B
      A5FF107D94FF0E6D82FF0C5D6FFF052A33D20000000000000000000000000000
      000000000000000000000F0F0F785C5C5AFA171D1FEF05060565000000000000
      00000000000000000000000000000000000062523EFDA88B62FF988266FF9581
      67FF968168FF978268FF988268FF988268FF978167FF968165FF958065FF957E
      64FF957D64FF8A7256FF957C5EFF645036FF5A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C600000000000000000000000C0407
      07420E191C801A3D42C22C6D7DF7256C78F816525CE20B3B46CC052228A90320
      279F02161A8A010E11730007095B000000140000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003B362EB66A5943FF5C4B39F95042
      30F3514330F3514230F3524230F351422EF3503F2CF34C3E28F34A3A25F34737
      24F344331FF34D3C29F75D4C35FF373128B70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002012086B643619BCA15729EDAD5E
      2CF7AD5E2CF7AD5E2CF7AD5D2CF7AD5D2BF7AA5D2AF7516429FCAC5C2AF7A156
      27EF643517BD1B0E0663000000000000000000000000000000000000001D0000
      0034000000360000003600000036000000360000003600000036000000360000
      00360000003600000036000000330000001D0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00030B140B72414841F6606360FE676967FF686968FF365D38EF264727CE6263
      62F7636363F75A5A5AF4373737DF020202308E4E26DEDFD9D2F2F3E8DBFDF6EB
      DEFFF6EADEFFF6EADCFFF6EADCFFFAF3EBFF5E935EFF4C854DFFFCF7F3FFF8F4
      F0FDE1E1E0F07F411CD50000000000000000000000000000000000000034E5E5
      E5F5F8F8F8FDFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFF8F8F8FDE1E1E1F3000000330000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000D2044
      22C2485449FE8D908DFFAAABA8FFADADADFF969696FF6F6F6FFF767676FF9696
      96FFADADADFF939493EF7B7B7BEF353535D7B06732F5F3E9DDFEFDBE66FFFCBC
      65FFFBBD63FFFCBD62FFFCBD62FF6C9246FF549C5CFF509857FF286F2DFF2469
      29FF216425FF415E23FC0105024000000000000000000000000100000036FAFA
      FAFEFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFC
      FCFFFCFCFCFFFCFCFCFFF8F8F8FD000000360000000000000000000000000000
      0000BF4C14FF4317079B00000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000D2E6632D1527C
      5FFF696D6BFFD3D3CEFF706B5DFF424140FF444444FF4F4F4FFF4F4F4FFF4444
      44FF404140FF425342F5C3C3C3FF595959EFB46E36F7F7EDE3FFFDC16CFFFFD8
      9FFFFFD79DFFFFD69AFF50974FFF5EA766FF8CCD96FF89CC93FF86CA90FF83C9
      8DFF80C88BFF5EA666FF133E16CC01060240000000000000000100000036FCFC
      FCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFBFBFBFFFBFBFBFFFBFBFBFFFBFB
      FBFFFBFBFBFFFBFBFBFFFCFCFCFF000000360000000000000000000000000000
      0000C35716FFCC6F39FF471A08A0000000000000000000000000000000000000
      00000000000000000000000000000000000000000000245029B174BF8CFF5F7C
      6BFF818381FFD3D3CEFFC0A467FF44423FFFBCBCBCFFCECECEFFC1C1C1FFACAC
      ACFF404341FF64A477FFC3C3C3FF787878F7B7723AF7F7F0E6FFF8B353FFF7B3
      54FFF7B452FFF8B351FFF8B151FF719B4BFF60A868FF5BA363FF337E39FF2F78
      34FF4F9657FF82C98DFF5AA062FF0B230D992E2B27D9322E2AD9282421E15755
      53FFB8B8B7FF3B3937FF403D3BFF353432FF3A3A39FFFAFAFAFFFAFAFAFFFAFA
      FAFFFAFAFAFFFAFAFAFFFCFCFCFF000000360000000000000000000000000000
      0000C96018FFDFA273FFCF723AFF4B1D08A20000000000000000000000000000
      000000000000000000000000000000000000060D07464FA859FBB4EAD3FF5690
      5EFF717571FFD3D3CEFF766B57FF4B4A49FF636363FF919191FF777777FF6363
      63FF494A49FF6C7C74FFC3C3C3FF686968F5B8763CF7F8F1E8FFFEE5D5FFFDE5
      D3FFFDE5D3FFFCE5D3FFF6E3CFFFFBE3D0FF6FA669FF5F9D5CFFFBE0C9FFFBE1
      C8FF619864FF2B7331FF276D2CFF1C501FE0615952FFA6998CFF6E655CFF433E
      39FFABAAAAFF5A534CFF95897DFF645C54FF191716FFFBFBFBFFFAFAFAFFFAFA
      FAFFF8F8F8FFF8F8F8FFFCFCFCFF000000360000000000000000000000000000
      0000CD6C21FFE1A77CFFE0A577FFD0753BFF522209A900000000000000000000
      0000000000000000000000000000000000002B5A31B291D7AEFF9FDEB3FF81C2
      6DFF748862FF909090FFE8E8E8FFDDDDDDFFC0C0C0FF898378FF897D6DFFD8D7
      D5FFDDDDDDFFC3C3C3FF909090FF324833E2B8783FF7F8F2EBFFFEE7D6FFFDE7
      D6FFFDE7D6FFFDE7D6FFFDE6D5FFFDE5D3FFFAE3D0FF80AE75FFFBE1CBFF78A5
      6DFFF9F6F0FFB87239F700000000000000006F665DFFC0B5AAFF776E64FF605B
      57FFB7B7B6FF6C645BFFBCB0A4FF7C7268FF312E2CFFFCFCFCFFFBFBFBFFF9F9
      F9FFF9F9F9FFF8F8F8FFFCFCFCFF000000360000000000000000000000000000
      0000D27533FFE4AE86FFDFA070FFE1A87AFFD0783DFF57240AAC000000040000
      000000000000000000000000000000000000499853E4AFE9CFFF82D48FFFBEDC
      89FFBCC47DFF9E875DFF8A8781FF9D9D9DFF847E74FFAC7E4AFFAF8145FF837E
      74FF9D9D9DFF828683FF87A596FF276229E9B97A41F7F9F3ECFFFEE8D6FFFEE8
      D7FFFDE7D6FF6EBC72FF57B161FF53AB5CFF77B473FFFBE3CCFFFADFC7FF609F
      5EFF68A36AFFB8763CF700000009000000006D645CF8C3B8AEFFA6998CFF7E7A
      76FFD4D4D3FF6A625CFFBAAEA3FFA5978AFF514F4DFFFCFCFCFFFAFAFAFFF9F9
      F9FFF6F6F6FFF6F6F6FFFCFCFCFF000000360000000000000000000000000000
      0000D68341FFE7B48FFFE0A272FFE0A375FFE2AA80FFD37D41FF612B0BB30000
      00000000000000000000000000000000000058B463F6BDEFDDFF71D17BFF8FD1
      6AFFBBE09DFFC7A65CFFD3AF5CFFC59851FFC5BB6CFFAED178FFB3C36BFFAEA8
      5DFF79A855FF58A265FFB0E3CEFF2C7430F7B97F43F7F9F4EDFFFEE8D8FFFEE8
      D8FFFEE8D7FF9FCE95FF8BCC94FFA9D9B0FF75BE7EFF4FA659FF4BA054FF69B1
      71FF66AD6EFF5E8743FD000000000000000058514AEF675F56FF544D46FF4B48
      46FF8A8989FF3E3A37FF44403AFF3B3631FF2A2928FFFBFBFBFFF8F8F8FFF6F6
      F6FFF3F3F3FFF2F2F2FFFCFCFCFF000000360000000000000000000000000000
      0000DB8D51FFEABA98FFE3A97EFFE3AA80FFE4B089FFD68749FF9B4B13E20000
      00000000000000000000000000000000000058B364F5BDF0DCFF80D882FF75DB
      6BFFBEE599FFCCDFA6FFCAA75BFFC1BC6AFFB7DA8AFFA5D85EFF75D13DFF68D0
      44FF57BB4EFF61AA6AFFB1E4CEFF307733F6B97F44F7F9F4EFFFFEE7D7FFFDE7
      D6FFFDE7D5FFD7DDBAFF80C580FF92D09AFFAADAB1FFA8D9AFFFA5D8ACFFA2D7
      AAFF9FD5A6FF67AE6FFF2E6933DC00000000100F0E8559524BFFAF9F8FFF675B
      4FFF857263FF61564CFFA99787FF584F48FF838281FFF8F8F8FFF5F5F5FFF2F2
      F2FFEFEFEFFFEDEDEDFFFCFCFCFF000000360000000000000000000000000000
      0000E19660FFECC0A0FFE8B691FFE9BA98FFDD965FFF552E11A4000000000000
      0000000000000000000000000000000000004B9955E2B2ECD2FF9AE2A1FF9CEA
      8CFFD4EDB6FFD0EAC7FFCFB86CFFCCB064FFCBC973FF74DB65FF64D94BFF63D7
      4BFF6AD35BFF71BA7CFFA4DBC1FF2D6D31E6B98045F7F9F4F0FFFCE6D3FFFCE6
      D4FFFDE7D3FFFCE4D1FFD5DBB5FF87C783FF5DBA68FF5AB564FF56AF60FF74BC
      7DFF70B879FF67934CFD00000000000000000101011D5B544CF384766DFF483F
      39FF94877BFF54483EFF918272FF4D453EFFE2E1E1FFF5F5F5FFF1F1F1FFECEC
      ECFFEAEAEAFFE6E6E6FFFCFCFCFF000000360000000000000000000000000000
      0000E29F6CFFEEC7A7FFEDC1A2FFE3A373FF52311A9E00000000000000000000
      0000000000000000000000000000000000002B5932AD97DEB4FFB4EBCCFFB0EF
      A6FFC9EEA8FFD1EAC9FFD5CF8CFFD9CB8AFFCDB364FFBBBB65FF99D66FFF81DE
      71FF78DC6FFF90D0A2FF87C8A3FF1F4A22B9B98045F7F9F5F1FFFCE3CFFFFBE4
      D0FFFCE4CFFFFCE3CDFFFAE1CAFFF9DDC3FFF6D9BBFFF4E9DFFFF7F2ECFF74BD
      7AFF7BBC7EFFBB7841FB00000000000000000000000F2F2B278F9B8E82FF504A
      46FFC9C5C3FF524B45FF8F8579FF979592FFF1F1F1FFF2F2F2FFEBEBEBFFFCFC
      FCFFFCFCFCFFFCFCFCFFFCFCFCFF000000360000000000000000000000000000
      0000E6A677FFEFC8ACFFE8AF86FF442D1D8E0000000000000000000000000000
      000000000000000000000000000000000000050A063C5BBB68FABFF3E2FFB4EF
      B3FFB4F0ABFFC0EDB6FFD4E3B6FFD9D89BFFDAD394FFCDB46BFFC7B26BFFB4CB
      83FF93DF99FFAEE7CDFF429649FC060E064FB77E45F6F9F5F1FFFCE3CDFFFBE3
      CEFFFBE3CDFFFBE2CBFFF9E0C8FFF8DCC1FFF5D6B9FFFDFBF8FFFCE6CDFF90C7
      87FFE0B583FF50321BA6000000000000000000000000000000136D655DF9736B
      64FFD9D5D1FF6D655DFF696460FFF7F7F7FFF3F3F3FFF0F0F0FFEAEAEAFFFCFC
      FCFFF6F6F6FFF4F4F4FF30303091000000200000000000000000000000000000
      0000EAAA7EFFE6A67AFE3F2C2087000000000000000000000000000000000000
      0000000000000000000000000000000000000000000027512DA586D79FFFBFF2
      DEFFC7F2D6FFD5EFD5FFD0E9CFFFD5DBA5FFDCDEAAFFDBCD8FFFD7C88AFFC9C0
      8DFFBCD5AEFF78C790FF245229B600000000A5713EEAF4F0ECFCFAE0C7FFFBE1
      C9FFFBE2C9FFFBE0C8FFF9DFC4FFF8DBC0FFF4D6B7FFFFFBF8FFF6D8B3FFE1AF
      7BFFCB875CF6000000070000000000000000000000000000000000000036F7F7
      F7FDF4F4F4FFF5F5F5FFF5F5F5FFF5F5F5FFF1F1F1FFEFEFEFFFE9E9E9FFFCFC
      FCFFE7E7E7FF2F2F2F9100000020000000020000000000000000000000000000
      0000D49C74F4402E228700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000005387340C48BD8
      A1FFCDF5E8FFD4EDDAFFCEEDD3FFCFDFAEFFD6DEB4FFD4D4A1FFCED0A0FFC3D0
      A9FF86C990FF36753DD10000000F00000000724C29C3D4CFC9ECF2EEE8FCF8F4
      EDFFF8F3EDFFF8F3EDFFF8F3EDFFF8F2ECFFF7F2ECFFF2E6D7FFE2B17BFFC987
      5BF500000007000000000000000000000000000000000000000000000033DBDB
      DBF0F7F7F7FDFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFF8F8
      F8FF2F2F2F910000002000000002000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000042750
      2CA45AB966F8A4E1BAFFB9EACCFFC4E0BDFFC4DAB3FFBCD7AFFFA5D7ABFF59B7
      64FB2D5E33B60000000C00000000000000001B1109606C4928BBAE7943EEBA81
      48F6BC8349F7BC8349F7BC8449F7BD8349F7BB8249F7875D33D43E2512910000
      00060000000000000000000000000000000000000000000000000000001C0000
      0033000000360000003600000036000000360000003600000036000000360000
      0036000000200000000200000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000050B063D2A5630AA499552DF57B363F45AB966F850A25BE92E5F34B2070F
      0848000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000107
      0A37000000000000000000000000000000000000000000000000061E0F88155F
      30F2176935FF155F30F2061E0F880000000000000000000000002012086B6436
      19BCA15729EDAD5E2CF7AD5E2CF7AD5E2CF7AD5D2CF7AD5D2BF7AC5D2AF7AC5D
      2AF7AC5C2AF7A15627EF643517BD1B0E066300000000000000002012086B6436
      19BCA15729EDAD5E2CF7AD5E2CF7AD5E2CF7AD5D2CF7AD5D2BF7AC5D2AF7AC5D
      2AF7AC5C2AF7A15627EF643517BD1B0E06630000000000000000000000000000
      0000000103230B112F7D22348FDB263EAFF3253CADF31C2F8BDB080F2C7D0001
      0323000000000000000000000000000000000000000000000000000000001B77
      9AD51F8DB7E90000000C000000000000000000000000061C0E84268B51FF62B9
      8CFF94D2B1FF62B98CFF268B51FF071F108C00000000000000008E4E26DEDFD9
      D2F2F3E8DBFDF6EBDEFFF6EADEFFF6EADCFFF6EADCFFFAF3EBFFFAF3EBFFFAF2
      EAFFFCF7F3FFF8F4F0FDE1E1E0F07F411CD500000000000000008E4E26DEDFD9
      D2F2F3E8DBFDF6EBDEFFF6EADEFFF6EADCFFF6EADCFFFAF3EBFFFAF3EBFFFAF2
      EAFFFCF7F3FFF8F4F0FDE1E1E0F07F411CD50000000000000000000000000608
      15532C41A6E65062D4FF838FE7FF949FEEFF949EEDFF828DE5FF4A5BCEFF1F34
      99E6030613530000000000000000000000000000000000000000000000000000
      000C2BADDFFF29AADEFF0A2F408A0000000000000000186434F760B98AFF5EB9
      86FFFFFFFFFF5EB886FF65BB8EFF166332F70000000000000000B06732F5F3E9
      DDFEFDBE66FFFCBC65FFFBBD63FFFCBD62FFFCBD62FFFCBC60FFFBBC61FFFBBB
      5FFFFCBD5EFFFCBB60FFF9F7F4FDA75927F3000000000000000098714FF7CFDC
      DCFEFDBE66FFFCBC65FFFBBD63FFFCBD62FFFCBD62FFFCBC60FFFBBC61FFFBBB
      5FFFFCBD5EFFFCBB60FFF9F7F4FDA75927F30000000000000000060916533850
      C1F47383E3FFA0ABF4FF7D8AECFF5A65E4FF5964E3FF7B86EAFF9EA7F1FF6D7A
      DDFF243CAEF40306135300000000000000000000000000000000000000000000
      00001B7293CF4DBBE7FF4AB9E6FF1F8FBDED000101172F794AFF9BD4B5FFFFFF
      FFFFFFFFFFFFFFFFFFFF94D2B1FF176935FF0000000000000000B46E36F7F7ED
      E3FFFDC16CFFFFD89FFFFFD79DFFFFD69AFFFFD797FFFFD695FFFFD694FFFFD5
      93FFFFD492FFFBBD63FFFBF7F4FFAE5F2CF700000000000000008D8065F93DAE
      DCFFB7B78FFFFFD89FFFFFD79DFFFFD69AFFFFD797FFFFD695FFFFD694FFFFD5
      93FFFFD492FFFBBD63FFFBF7F4FFAE5F2CF70000000001010322374CB0E57687
      E6FFA2AFF5FF5565E7FF5463E6FF8891EDFF8791ECFF515DE2FF505BE1FF9EA8
      F2FF6D7BDDFF21359AE500010322000000000000000000000000000000000000
      00000000000029AEDFFF83D3F2FF53BCE7FF2CA9DEFF3F835BFC8FD3B0FF91D6
      B0FFFFFFFFFF63BB8BFF65BB8EFF166332F72E2B27D9322E2AD9493C2FFE5652
      4DFFB58540FF3B2E1EFF3F3322FF352919FF392A13FFF7B250FFF7B250FFF7B1
      4FFFF7B14DFFF7B14DFFFCF9F5FFB26731F70000000000000000B7723AF75CBC
      DFFF41B4E3FF68A7ACFFE9B25AFFF8B351FFF8B151FFF7B250FFF7B250FFF7B1
      4FFFF7B14DFFF7B14DFFFCF9F5FFB26731F7000000001219367E5E71E0FFA3B2
      F7FF586CEBFF576AEAFF5667E8FFFFFFFFFFFFFFFFFF5360E5FF525FE3FF515D
      E2FF9EA8F2FF4E5FD1FF0A102E7E000000000000000000000000000000000000
      00000000000018647FC06ECCEEFF82D2F2FF7CCEF1FF4CA1A5FF5FAA80FF94D4
      B3FFB9E6D0FF68BA8EFF2B8E55FF071F108C615952FFA6998CFF6E655CFF433D
      38FFAC9B90FF5A534CFF95897DFF645C54FF191716FFFCE4D1FFFCE2CEFFFCE2
      CCFFFBE0C9FFFBE1C8FFFDFAF7FFB46D36F70000000000000000B8763CF7EDED
      E8FF2FADDEFF4FB9E6FF39A9D9FFA8C9D4FFFCE5D3FFFCE4D1FFFCE2CEFFFCE2
      CCFFFBE0C9FFFBE1C8FFFDFAF7FFB46D36F7000000003B4FA9DB8D9EF0FF8398
      F4FF5A71EEFF596EECFF586CEBFF8F9CF1FFA5AEF3FF5565E7FF5463E6FF5360
      E5FF7B88EBFF8490E7FF233591DB0000000030ABCCF032B5D9F831B2D9F82FB0
      D8F82DADD7F82BABD6F885D7F3FF2DB5EBFF48BBECFF7ECEF1FF53A6ABFF5494
      72FF4D8D64FF38754FF20A1C107C000000006F665DFFC0B5AAFF776E64FF605A
      54FFB9A89BFF6C645BFFBCB0A4FF7C7268FF312C29FFFDE5D3FFFCE4D1FFFCE2
      CDFFFBE1CBFFFBE1C9FFFBF7F2FFB87239F70B272F740F38448C709A95FB89D1
      E6FF3BB4DFFF7BD0F0FF6BC7ECFF42B1E2FF71B7D6FFDEDAD3FFFCE4D1FFFCE2
      CDFFFBE1CBFFFBE1C9FFFBF7F2FFB87239F7000000004F67D9F69FB2F7FF637E
      F2FF5D76F0FF5B74EFFF5A71EEFFD3D9FAFFFFFFFFFF576AEAFF5667E8FF5565
      E7FF5B6AE7FF98A4F1FF3048BCF6000000002FA2C1E973DAF2FF92E6F8FF90E3
      F7FF8CE0F6FF89DCF5FF89DBF5FF87D7F4FF83D3F2FF7DCFF1FF7ACCF0FF78C9
      EFFF46B3E3FF1F96C8F500030423000000006D645CF8C3B8AEFFA6998CFF7E78
      71FFD6C2B3FF6A615AFFBAAEA3FFA5978AFF514B44FFFDE5D3FFFBE4D0FFFBE3
      CCFFFADFC7FFFADFC5FFFAF2EAFFB9763CF7237B91CA6CD8F0FF66D3EFFF64CF
      EDFF83D9F3FF87D7F4FF7BCFF1FF56BBE8FF50B6E5FF209CD7FFA4C4D1FFF1DF
      CCFFFADFC7FFFADFC5FFFAF2EAFFB9763CF700000000536CDDF6A0B5F8FF6583
      F4FF5E7AF3FF5D78F1FF5D76F0FFFFFFFFFFFFFFFFFF596EECFF586CEBFF576A
      EAFF5D6DE9FF9AA7F1FF344BC0F60000000002090A374DCDECFF97E9F9FF48D5
      F3FF43CFF1FF3ECAF0FF36C1EEFF88D9F4FF2CB1DFFE28A6D4F827A3D3F825A1
      D2F8239ED0F8219BCFF81C87B6E90000000058514AEF675F56FF544D46FF4B47
      44FF8B7E75FF3E3935FF44403AFF3B3631FF2A2623FFFCE4D1FFFBE1CCFFFAE0
      C7FFF9DDC2FFF8DCC1FFFAF4EDFFB9783FF702090A3730A7C5EB8FE6F8FF8CE3
      F7FF5ED2F2FF83D7F4FF3AB5DFFF86C5DAFF8BC4D8FF82BFD7FF8FBFD2FFE0D7
      C8FFF9DDC2FFF8DCC1FFFAF4EDFFB9783FF7000000004558B1DB90A5F3FF87A0
      F8FF607EF4FF5F7CF3FF5E7AF3FFFFFFFFFFFFFFFFFF5B74EFFF5A71EEFF596E
      ECFF8192F1FF8897ECFF2C409ADB000000000000000034B6D5F47EE1F5FF8DE6
      F8FF41D2F3FF3DCDF1FF37C7EFFF8BDCF5FF56C5EAFF09242E74000000000000
      000000000000000000000000000000000000100F0E8559524BFFAF9F8FFF675B
      4FFF857263FF61564CFFA99787FF584F48FF84776CFFFBE1CCFFFADFC7FFF8DC
      C1FFF6DABCFFF6D8BAFFFAF4EFFFB97940F7000000060F353E8469D9F1FF95E7
      F8FF45CFF2FF88DCF4FF36B7E1FFA4D0D9FFFCE6D2FFFBE1CCFFFADFC7FFF8DC
      C1FFF6DABCFFF6D8BAFFFAF4EFFFB97940F700000000171E3B7E6A80ECFFA8BC
      FBFF6181F5FF6080F5FF607EF4FFFFFFFFFFFFFFFFFF5D78F1FF5D76F0FF5B74
      EFFFA4B4F8FF5B6EDDFF1016347E00000000000000000615195459D4EFFF98EA
      F9FF45D6F4FF40D0F2FF3BCBF0FF6CD5F3FF7DD7F3FF48BFE7FF030F124A0000
      0000000000000000000000000000000000000101011D5B544CF384766DFF483F
      39FF948578FF54483EFF918272FF4D453EFFE4CFBAFFFAE0C8FFF8DCC1FFF5D6
      BAFFF3D4B4FFF1D2B2FFF8F4F0FFB77840F7000000000103032042C5E2FF92E7
      F8FF5DD8F4FF8FE0F6FF7BD6F2FF50C2E9FFA9D0D4FFFAE0C8FFF8DCC1FFF5D6
      BAFFF3D4B4FFF1D2B2FFF8F4F0FFB77840F700000000010204225065C6E58296
      F0FFA8BCFBFF6181F5FF6181F5FFFFFFFFFFFFFFFFFF5F7CF3FF5E7AF3FFA5B8
      F9FF798CEAFF3B4FB2E50101032200000000000000000000000039C0DEF992E9
      F9FF70E1F7FF43D4F3FF3FCEF2FF3AC9F0FF89DCF5FF6ED0EFFF3BBAE4FF0003
      0423000000000000000000000000000000000000000F2F2B278F9B8E82FF504A
      45FFCBB6A6FF524B45FF8F8477FF998B7DFFF5DDC5FFF9DDC3FFF6D9BBFFF4E9
      DFFFF7F2ECFFFBF7F3FFF5EFE9FFBB7841FB000000000000000372ADA5FC72DE
      F3FF88E3F6FF84DEF5FF80D9F4FF76D3F1FF4EC1E8FFAECECFFFF4D9BBFFF4E9
      DFFFF7F2ECFFFBF7F3FFF5EFE9FFBB7841FB00000000000000000B0D1A535C74
      E2F48396F1FFA8BCFBFF89A2F8FF6988F6FF6988F6FF88A1F8FFA7BBFAFF7D91
      ECFF4A61D0F4080B17530000000000000000000000000000000010353D8362D9
      F1FF99EBFAFF46D8F4FF42D3F3FF3DCEF1FF38C8F0FF8BDCF5FF60CBEDFF2EB3
      DDFC000000000000000000000000000000000000000000000012756B60FF736B
      63FFDDC8B4FF6D645CFF6A6057FFFBE2CBFFF9E0C8FFF8DCC1FFF5D6B9FFFDFB
      F8FFFCE6CDFFFAE5C9FFE2B583FF50321BA6000000000000000099936FF85BD3
      ECFF57CEE6FF56CBE5FF54C8E3FF51C4E2FF4CC0E0FF57BEDCFFDFD2BDFFFDFB
      F8FFFCE6CDFFFAE5C9FFE2B583FF50321BA60000000000000000000000000B0D
      1A535368CBE66C82EEFF91A5F4FF9FB3F8FF9FB3F8FF90A5F3FF667BE9FF465C
      BFE6090B18530000000000000000000000000000000000000000000000003DC8
      E7FD99EDFAFF98EBF9FF96E8F9FF93E5F8FF90E2F7FF8DDFF6FF8ADBF5FF54C7
      EBFF2BA6CDF30000000000000000000000000000000000000000A5713EEAF4F0
      ECFCFAE0C7FFFBE1C9FFFBE2C9FFFBE0C8FFF9DFC4FFF8DBC0FFF4D6B7FFFFFB
      F8FFF6D8B3FFE1AF7BFFCB875CF6000000070000000000000000A5713EEAF4F0
      ECFCFAE0C7FFFBE1C9FFFBE2C9FFFBE0C8FFF9DFC4FFF8DBC0FFF4D6B7FFFFFB
      F8FFF6D8B3FFE1AF7BFFCB875CF6000000070000000000000000000000000000
      000001020423181F3C7D4B5EB7DB5A72E0F35870DEF3465AB3DB161C397D0102
      0423000000000000000000000000000000000000000000000000000000001953
      5FA23DCCEBFF3CCBEAFF3AC9E9FF39C7E9FF38C3E8FF36C1E7FF34BFE6FF33BC
      E5FF31BAE4FF248EB0E100000000000000000000000000000000724C29C3D4CF
      C9ECF2EEE8FCF8F4EDFFF8F3EDFFF8F3EDFFF8F3EDFFF8F2ECFFF7F2ECFFF2E6
      D7FFE2B17BFFC9875BF500000007000000000000000000000000724C29C3D4CF
      C9ECF2EEE8FCF8F4EDFFF8F3EDFFF8F3EDFFF8F3EDFFF8F2ECFFF7F2ECFFF2E6
      D7FFE2B17BFFC9875BF500000007000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001B1109606C49
      28BBAE7943EEBA8148F6BC8349F7BC8349F7BC8449F7BD8349F7BB8249F7875D
      33D43E25129100000006000000000000000000000000000000001B1109606C49
      28BBAE7943EEBA8148F6BC8349F7BC8349F7BC8449F7BD8349F7BB8249F7875D
      33D43E2512910000000600000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000711DF50279
      1CFF000200210000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000020023061D077D125816DB16671AF316641AF3125216DB061A077D0002
      0023000000000000000000000000000000000000000000000000000000000000
      0000010201230E22117D296531DB307C38F32C7A35F3226027DB0A1E0C7D0002
      0023000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007726F541A0
      5DFF006118E40002002700000000000000004735279BC28D66FFBF8A64FFBD87
      62FFBA845FFFB8825DFFB57E5CFFB37C5AFFB17A58FFB07956FFAD7755FFAC74
      54FFAA7352FFA87151FFA86F4FFF3B281D9B000000000000000000000000020E
      0353146918E6409F50FF86CA99FF9AD3AAFF9AD2AAFF82C795FF3B964AFF1458
      17E6020B0353000000000000000000000000000000000000000000000000070F
      0953367942E63F984EFF7BC18EFF95D0A5FF95CFA5FF76BD88FF348C40FF2367
      29E6040D0453000000000000000000000000493022A9C28D66FFBF8A64FFBD87
      62FFBA845FFFB8825DFF20964FFF1A9047FF148E41FF0F8A39FF389E5CFF7EC0
      95FF44A260FF0F7A22FF423A22B700000000C8916AFF505050FF515151FF5252
      52FF535353FF545454FF555555FF555555FF565656FF575757FF585858FF5959
      59FF5A5A5AFF5A5A5AFF5B5B5BFFA8704FFF0000000000000000020F0453177D
      1CF46BBD82FFA7DBB4FF86CC97FF64BB7BFF62B97AFF85CB97FFA4D9B3FF64B6
      7BFF166119F4020B03530000000000000000000000000000000008100A53458E
      53F462B376FFA7DBB4FF86CC97FF64BB7BFF62B97AFF85CB97FFA4D9B3FF56A9
      69FF27742EF4040D04530000000000000000C8916AFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF279A59FF8FCAA8FF8CC8A4FF89C5A0FF87C49DFF68B5
      84FF81C196FF46A464FF0D7A23FF00040030CA936CFF4C4C4CFF3B3B3BFF3B3B
      3BFF3C3C3CFF3D3D3DFF3F3F3FFF404040FF414141FF424242FF434343FF4444
      44FF444444FF464646FF585858FFA97151FF0000000000020022157824E570C1
      86FFA7DBB1FF5EBB75FF5AB971FF57B76EFF57B46DFF56B46DFF59B672FFA4D9
      B2FF67B77DFF135A17E500010022000000000000000001020122438251E568B8
      7BFFA7DBB1FF5EBB75FF5AB971FF57B76EFF57B46DFF56B46DFF59B672FFA4D9
      B2FF58A96AFF226729E50002002200000000CA936CFFFFFFFFFFFFFFFFFFFFFF
      FEFFFFFFFDFFFEFEFDFF2F9E61FF93CDACFF6DB98DFF69B788FF64B584FF5FB2
      7EFF65B481FF82C197FF3A9F5AFF007B23FCCC966DFF494949FF363636FF3737
      37FF383838FF3A3A3AFF3B3B3BFF3D3D3DFF3D3D3DFF3F3F3FFF404040FF4040
      40FF424242FF434343FF555555FFAB7352FF0000000006270E7E4AAF62FFA9DD
      B3FF62C077FF5DBD6FFF73C484FFD4ECD9FF89CD98FF54B56AFF56B46CFF5AB6
      72FFA5DAB3FF3F9A4CFF061C077E000000000000000016281B7E51AA66FFA9DD
      B3FF62C077FF5DBD6FFF5EBB75FFFFFFFFFFFFFFFFFF57B76EFF56B46CFF5AB6
      72FFA5DAB3FF368E41FF0A1F0C7E00000000CC966DFFFFFFFFFFFFFFFCFFFFFF
      FDFFFEFEFCFFFEFEFCFF35A269FF95CEAFFF93CDACFF90CBA9FF8FCBA7FF72BB
      8FFF89C7A0FF44A466FF078633FF0000000FCF9970FF454545FF313131FF3232
      32FF343434FF353535FF373737FF383838FF393939FF3A3A3AFF3C3C3CFF3D3D
      3DFF3E3E3EFF3F3F3FFF535353FFAC7654FF00000000167C2FDB90D29EFF8CD4
      99FF62C272FF77C986FFF2FAF4FFFFFFFFFFFDFEFDFF85CB95FF55B66BFF59B8
      70FF84CC96FF86C799FF125716DB0000000000000000467E55DB89CC97FF88D3
      95FF69C578FF61C06EFF53AA63FFFFFFFFFFFFFFFFFF57B76EFF57B76EFF59B8
      70FF84CC96FF79BD8CFF226029DB00000000D19B71FFFFFFFFFFFEFEFCFFFEFE
      FCFFFEFEFCFFFDFDFBFF3BA46DFF37A36CFF33A166FF2F9D60FF53AE7AFF90CB
      A9FF4DAA72FF178F44FFA87955FF00000000D19B71FF404040FF2D2D2DFF2E2E
      2EFF2F2F2FFF313131FF323232FF343434FF343434FF363636FF383838FF3939
      39FF3B3B3BFF3B3B3BFF505050FFAF7856FF000000001BA03CF6A5DCAEFF6ECA
      7DFF71CA7EFFF0F9F1FFFFFFFFFFEBF7EDFFFFFFFFFFFBFDFCFF87CD95FF59B8
      6FFF65BD7BFF9FD7AEFF18701AF600000000000000005CA270F6A8DDB2FF7BCF
      89FF73CC80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF57B7
      6EFF65BD7BFF9BD4AAFF2F7D37F600000000D49D73FFFFFFFFFFFEFEFCFFFDFD
      FBFFFDFDFCFFFDFDFBFFFDFDF9FFFCFCF8FFFBF9F7FFFBF9F5FF37A167FF58B2
      80FF269755FFF7FBF9FFB17A58FF00000000D49D73FF3B3B3BFF272727FFD1D1
      D1FFACACACFF2C2C2CFF2D2D2DFF2F2F2FFF303030FF323232FF343434FF3535
      35FF363636FF383838FF4C4C4CFFB17A58FF0000000022A744F6A6DDB0FF70CC
      7EFF64C771FFAFE1B6FFD2EED6FF61C06EFFB7E3BEFFFFFFFFFFFBFDFCFF8BD0
      98FF67C07CFFA0D7ADFF18751AF6000000000000000060A574F6B5E2BDFF8AD5
      96FF78C985FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF57B7
      6EFF67C07CFF9CD4A9FF32803CF600000000D59F74FFFFFFFFFFFDFDFCFFFDFD
      FBFFFDFDFAFFFCFCF9FFFCFBF7FFFBF9F5FFFBF8F4FFFBF7F3FF3DA56EFF2F9E
      63FFF1EFE7FFFFFFFFFFB47C5AFF00000000D59F74FF373737FF232323FF2424
      24FFDEDEDEFF727272FF282828FF2A2A2AFF2B2B2BFF2D2D2DFF2F2F2FFF3030
      30FF323232FF333333FF494949FFB47C5AFF0000000020893CDB94D7A0FF90D7
      9AFF67C974FF62C56DFF5FC36CFF5FC26DFF5FC16DFFB8E4BFFFFFFFFFFFE3F4
      E6FF8AD198FF8ACE9CFF136317DB00000000000000004F855FDBABDDB5FFA5DF
      AEFF80CB8BFF7AC985FF6CBC77FFFFFFFFFFFFFFFFFF59AB68FF5EBB75FF5AB9
      71FF8AD198FF7EC491FF2B6733DB00000000D8A177FFFFFFFFFFFDFDFAFFFCFC
      FAFFFCFBF9FFFBFAF6FFFBF8F5FFFBF7F4FFFBF6F1FFF8F4EEFFF7F2EBFFF7F0
      EAFFF6ECE8FFFFFFFFFFB6805CFF00000000D8A177FF323232FF1E1E1EFFCFCF
      CFFFA7A7A7FF222222FF232323FF242424FF262626FF282828FF2A2A2AFF2B2B
      2BFF2D2D2DFF2F2F2FFF444444FFB6805CFF000000000C2D157E55BE6EFFAEE1
      B6FF6BCC78FF66C870FF63C76EFF61C46CFF60C36CFF61C36FFFB5E3BDFF6DC7
      7CFFABDFB4FF46A85CFF0622087E00000000000000001B2C207E84C796FFD2EE
      D7FF94D99FFF89D393FF7DC888FFFFFFFFFFFFFFFFFF77CD84FF69C27AFF6DC7
      7CFFABDFB4FF439D55FF0F22127E00000000D9A277FFFFFFFFFFFCFBF9FFFCFB
      F8FFFBF9F7FFFBF7F4FFFAF7F2FFF9F5F0FFF7F3EDFFF6EFEAFFF5EBE7FFF3EA
      E4FFF2E7DEFFFFFFFFFFB9845EFF00000000D9A277FF323232FF1E1E1EFF1F1F
      1FFF202020FF222222FF232323FF242424FF262626FF282828FF2A2A2AFF2B2B
      2BFF2D2D2DFF2F2F2FFF444444FFB9845EFF0000000000030122299843E57DCE
      8FFFADE1B4FF6BCC78FF68CA74FF66C870FF66C872FF66C873FF69C977FFABDF
      B3FF74C388FF157823E50002002200000000000000000103022259936BE5A9DA
      B6FFD8F1DCFF91D89CFF87CD92FF83CC8DFF8AD495FF89D494FF82D28DFFAEE0
      B6FF69B87BFF397A43E50102012200000000DBA378FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFBC8661FF00000000DBA378FF2F2F2FFF303030FF3131
      31FF323232FF333333FF343434FF353535FF373737FF393939FF3A3A3AFF3B3B
      3BFF3D3D3DFF3F3F3FFF414141FFBC8661FF0000000000000000061409532EAF
      4CF47DCE8FFFAEE1B6FF91D89CFF75CE82FF75CE82FF91D89CFFADE1B4FF76C8
      8AFF198E2CF402100553000000000000000000000000000000000B130E5365A7
      7AF4AEDCBAFFDCF2E0FFB5E4BCFF9ADBA4FF95D99FFFA4DFAEFFBFE8C4FF77C1
      89FF488F55F4071009530000000000000000DCA679FFDCA679FFDCA679FFDCA6
      79FFDCA679FFDCA679FFDCA679FFDCA679FFDCA679FFDCA679FFDCA679FFDCA6
      79FFDCA679FFDCA679FFBF8A64FF00000000DCA679FFDBA378FFDAA277FFD8A1
      77FFD7A076FFD59E74FFD39D72FFD19B71FFCF9970FFCD966EFFCB946CFFC993
      6AFFC79069FFC38E67FFC28C65FFBF8A64FF0000000000000000000000000615
      0A532B9D46E657C172FF95D7A2FFA4DCADFFA4DCADFF94D6A0FF4EB868FF188A
      35E6031106530000000000000000000000000000000000000000000000000B13
      0E535A956CE693CEA3FFC2E6CBFFCFEBD4FFC9E9CEFFAEDDB7FF6BB87DFF4685
      54E608100A53000000000000000000000000D9A882FDE8B891FFE8B891FFE8B8
      91FFE8B891FFE8B891FFE8B891FFE8B891FFE8B891FFE8B891FFE8B891FFE8B8
      91FFE8B891FFE8B891FFBC8D6BFD00000000D9A882FDF1DCCEFFEAC09FFFE8B8
      91FFE8B891FFE8B891FFE8B891FFE8B891FFE8B891FFCDC8C4FFE8B891FFCDC8
      C4FFE8B891FF4262FFFFE8C3A6FFBC8D6BFD0000000000000000000000000000
      0000010301230D2E167D298E41DB2BAA4AF327A849F31E883BDB0A2B137D0003
      0123000000000000000000000000000000000000000000000000000000000000
      0000020302231A2B207D508560DB5EA272F35CA06FF3478056DB16281B7D0103
      0223000000000000000000000000000000001D130E6BCAA180F4DCA679FFDCA5
      78FFDAA378FFD8A177FFD59F74FFD49D73FFD29C71FFCF9970FFCE986EFFCB95
      6DFFC9936AFFB38C6EF41D130E6B0000000080634CC2CAA180F4DCA679FFDCA5
      78FFDAA378FFD8A177FFD8A077FFD59F74FFD49D73FFD29C71FFCF9970FFCE98
      6EFFCB956DFFC9936AFFB38C6EF4705440C20000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000C00000000100010000000000000600000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
