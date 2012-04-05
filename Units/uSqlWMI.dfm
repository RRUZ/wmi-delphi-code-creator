object FrmWMISQL: TFrmWMISQL
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmWMISQL'
  ClientHeight = 432
  ClientWidth = 763
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 185
    Align = alTop
    TabOrder = 0
    object SynEdit1: TSynEdit
      Left = 1
      Top = 1
      Width = 761
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
    end
    object Panel2: TPanel
      Left = 1
      Top = 112
      Width = 761
      Height = 72
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 6
        Width = 55
        Height = 13
        Caption = 'Namespace'
      end
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
        TabOrder = 1
        OnClick = BtnExecuteWQLClick
      end
      object CbNameSpaces: TComboBox
        Left = 96
        Top = 6
        Width = 201
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object DBNavigator1: TDBNavigator
        Left = 392
        Top = 6
        Width = 104
        Height = 25
        DataSource = DataSource1
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Kind = dbnHorizontal
        TabOrder = 2
      end
      object EditMachine: TEdit
        Left = 96
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 4
        Text = 'localhost'
        OnExit = EditMachineExit
      end
      object EditUser: TEdit
        Left = 258
        Top = 40
        Width = 121
        Height = 21
        TabOrder = 5
        OnExit = EditUserExit
      end
      object EditPassword: TEdit
        Left = 444
        Top = 40
        Width = 121
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
        OnExit = EditPasswordExit
      end
    end
  end
  object DBGridWMI: TDBGrid
    Left = 0
    Top = 185
    Width = 763
    Height = 247
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
  object SynSQLSyn1: TSynSQLSyn
    Left = 96
    Top = 24
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 208
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
    Editor = SynEdit1
    Left = 144
    Top = 24
  end
end
