object FrmWmiDatabase: TFrmWmiDatabase
  Left = 420
  Top = 155
  BorderStyle = bsNone
  Caption = 'FrmWmiDatabase'
  ClientHeight = 639
  ClientWidth = 1087
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
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 1087
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -24
    ExplicitTop = -6
    object Label7: TLabel
      Left = 11
      Top = 51
      Width = 108
      Height = 13
      Caption = 'Enter a Text to search'
    end
    object GroupBoxTypes: TGroupBox
      Left = 305
      Top = 3
      Width = 160
      Height = 42
      Caption = 'Types of Classes'
      Enabled = False
      TabOrder = 1
      object RadioButtonDynamic: TRadioButton
        Left = 9
        Top = 17
        Width = 64
        Height = 17
        Caption = 'Dynamic'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object RadioButtonAll: TRadioButton
        Left = 79
        Top = 17
        Width = 74
        Height = 17
        Caption = 'All Classes'
        TabOrder = 1
      end
    end
    object GroupBoxMode: TGroupBox
      Left = 399
      Top = 51
      Width = 218
      Height = 41
      Caption = 'Mode'
      Enabled = False
      TabOrder = 3
      object RadioButtonInsensitive: TRadioButton
        Left = 9
        Top = 16
        Width = 98
        Height = 17
        Caption = 'Case insensitive'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ButtonSearchWmiDatabaseClick
      end
      object RadioButtonSensitive: TRadioButton
        Left = 116
        Top = 16
        Width = 94
        Height = 17
        Caption = 'Case sensitive'
        TabOrder = 1
        OnClick = ButtonSearchWmiDatabaseClick
      end
    end
    object ComboBoxSearch: TComboBox
      Left = 11
      Top = 70
      Width = 288
      Height = 21
      Enabled = False
      TabOrder = 8
      OnChange = ComboBoxSearchChange
      OnExit = ComboBoxSearchExit
    end
    object GroupBox1: TGroupBox
      Left = 471
      Top = 3
      Width = 234
      Height = 42
      Caption = 'Include in Database generation'
      TabOrder = 2
      object CheckBoxProperties: TCheckBox
        Left = 150
        Top = 17
        Width = 69
        Height = 17
        Caption = 'Properties'
        TabOrder = 2
      end
      object CheckBoxMethods: TCheckBox
        Left = 78
        Top = 17
        Width = 60
        Height = 18
        Caption = 'Methods'
        TabOrder = 0
      end
      object CheckBox1: TCheckBox
        Left = 14
        Top = 17
        Width = 58
        Height = 17
        Caption = 'Classes'
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 1
      end
    end
    object GroupBoxSearchIn: TGroupBox
      Left = 11
      Top = 3
      Width = 288
      Height = 42
      Caption = 'Search In'
      Enabled = False
      TabOrder = 0
      object CheckBoxNamespace: TCheckBox
        Left = 10
        Top = 17
        Width = 78
        Height = 17
        Caption = 'Namespaces'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = ButtonSearchWmiDatabaseClick
      end
      object CheckBoxClasses: TCheckBox
        Left = 94
        Top = 17
        Width = 58
        Height = 17
        Caption = 'Classes'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = ButtonSearchWmiDatabaseClick
      end
      object CheckBoxClassDescr: TCheckBox
        Left = 158
        Top = 17
        Width = 103
        Height = 17
        Caption = 'Item Description'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = ButtonSearchWmiDatabaseClick
      end
    end
    object ButtonSearchWmiDatabase: TButton
      Left = 305
      Top = 66
      Width = 88
      Height = 25
      Caption = 'Apply filter'
      TabOrder = 4
      OnClick = ButtonSearchWmiDatabaseClick
    end
    object ButtonBuildWmiDatabase: TButton
      Left = 639
      Top = 66
      Width = 100
      Height = 25
      Caption = 'Build Database'
      TabOrder = 5
      OnClick = ButtonBuildWmiDatabaseClick
    end
    object ButtonSaveBdd: TButton
      Left = 745
      Top = 66
      Width = 100
      Height = 25
      Caption = 'Save Database'
      TabOrder = 6
      OnClick = ButtonSaveBddClick
    end
    object ButtonDelBdd: TButton
      Left = 851
      Top = 66
      Width = 110
      Height = 25
      Caption = 'Delete Database'
      TabOrder = 7
      OnClick = ButtonDelBddClick
    end
  end
  object DBGridWMI: TDBGrid
    Left = 0
    Top = 97
    Width = 1087
    Height = 452
    Align = alClient
    DataSource = DataSource1
    Enabled = False
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGridWMIDblClick
  end
  object PanelStatus: TPanel
    Left = 0
    Top = 549
    Width = 1087
    Height = 90
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 552
    object Label1: TLabel
      Left = 11
      Top = 6
      Width = 79
      Height = 13
      Caption = 'Overall Progress'
    end
    object Label2: TLabel
      Left = 11
      Top = 32
      Width = 69
      Height = 13
      Caption = 'Local Progress'
    end
    object LabelMsg: TLabel
      Left = 11
      Top = 64
      Width = 44
      Height = 13
      Caption = 'LabelMsg'
    end
    object ProgressBarNamespaces: TProgressBar
      Left = 105
      Top = 6
      Width = 193
      Height = 17
      TabOrder = 0
    end
    object ProgressBarClasses: TProgressBar
      Left = 106
      Top = 29
      Width = 193
      Height = 17
      TabOrder = 1
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSetWmi
    Left = 282
    Top = 284
  end
  object ClientDataSetWmi: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 253
    Top = 282
  end
end
