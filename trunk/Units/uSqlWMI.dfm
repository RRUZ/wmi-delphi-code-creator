object FrmWMISQL: TFrmWMISQL
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmWMISQL'
  ClientHeight = 432
  ClientWidth = 958
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 301
    Top = 0
    Width = 5
    Height = 432
    ExplicitLeft = 193
    ExplicitTop = 8
  end
  object PanelLeft: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 432
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -1
    DesignSize = (
      301
      432)
    object Label1: TLabel
      Left = 10
      Top = 6
      Width = 55
      Height = 13
      Caption = 'Namespace'
    end
    object LabelClasses: TLabel
      Left = 10
      Top = 75
      Width = 36
      Height = 13
      Caption = 'Classes'
    end
    object LabelProperties: TLabel
      Left = 10
      Top = 138
      Width = 49
      Height = 13
      Caption = 'Properties'
    end
    object CbNameSpaces: TComboBox
      Left = 10
      Top = 25
      Width = 269
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = CbNameSpacesChange
    end
    object CheckBoxAutoWQL: TCheckBox
      Left = 10
      Top = 52
      Width = 201
      Height = 17
      Caption = 'Auto generate WQL sentence'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBoxAutoWQLClick
    end
    object ComboBoxClasses: TComboBox
      Left = 10
      Top = 94
      Width = 269
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 2
      OnChange = ComboBoxClassesChange
      ExplicitWidth = 198
    end
    object ListViewProperties: TListView
      Left = 10
      Top = 157
      Width = 274
      Height = 270
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
      TabOrder = 3
      ViewStyle = vsReport
      OnClick = ListViewPropertiesClick
    end
    object CheckBoxSelAllProps: TCheckBox
      Left = 10
      Top = 121
      Width = 114
      Height = 17
      Caption = 'Select all Properties'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBoxSelAllPropsClick
    end
  end
  object PanelRight: TPanel
    Left = 306
    Top = 0
    Width = 652
    Height = 432
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    ExplicitLeft = 299
    ExplicitTop = -8
    ExplicitWidth = 544
    object Splitter1: TSplitter
      Left = 5
      Top = 190
      Width = 642
      Height = 5
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = -7
      ExplicitTop = 185
      ExplicitWidth = 576
    end
    object PanelTop: TPanel
      Left = 5
      Top = 5
      Width = 642
      Height = 185
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 763
      object SynEditWQL: TSynEdit
        Left = 1
        Top = 1
        Width = 640
        Height = 111
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.ShowLineNumbers = True
        Highlighter = SynSQLSyn1
        ExplicitWidth = 761
      end
      object PanelNav: TPanel
        Left = 1
        Top = 112
        Width = 640
        Height = 72
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 761
        object Label2: TLabel
          Left = 8
          Top = 40
          Width = 39
          Height = 13
          Caption = 'Machine'
        end
        object Label3: TLabel
          Left = 223
          Top = 40
          Width = 22
          Height = 13
          Caption = 'User'
        end
        object Label4: TLabel
          Left = 392
          Top = 40
          Width = 46
          Height = 13
          Caption = 'Password'
        end
        object BtnExecuteWQL: TButton
          Left = 303
          Top = 6
          Width = 75
          Height = 22
          Caption = 'Execute'
          TabOrder = 0
          OnClick = BtnExecuteWQLClick
        end
        object DBNavigator1: TDBNavigator
          Left = 392
          Top = 6
          Width = 104
          Height = 25
          DataSource = DataSource1
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
          Kind = dbnHorizontal
          TabOrder = 1
        end
        object EditMachine: TEdit
          Left = 96
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 3
          Text = 'localhost'
          OnExit = EditMachineExit
        end
        object EditUser: TEdit
          Left = 258
          Top = 40
          Width = 121
          Height = 21
          TabOrder = 4
          OnExit = EditUserExit
        end
        object EditPassword: TEdit
          Left = 444
          Top = 40
          Width = 121
          Height = 21
          PasswordChar = '*'
          TabOrder = 2
          OnExit = EditPasswordExit
        end
      end
    end
    object DBGridWMI: TDBGrid
      Left = 5
      Top = 195
      Width = 642
      Height = 232
      Align = alClient
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object SynSQLSyn1: TSynSQLSyn
    Left = 384
    Top = 40
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 224
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 264
    Top = 224
  end
  object SynCompletionProposal1: TSynCompletionProposal
    EndOfTokenChr = '()[]. '
    TriggerChars = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    Columns = <>
    ShortCut = 16416
    Editor = SynEditWQL
    Left = 472
    Top = 24
  end
end
