object FrmOnlineResources: TFrmOnlineResources
  Left = 826
  Top = 300
  Caption = 'Online Resources'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ListViewURL: TListView
    Left = 0
    Top = 41
    Width = 635
    Height = 259
    Align = alClient
    Columns = <
      item
        Caption = 'Title'
        Width = 200
      end
      item
        Caption = 'URL'
        Width = 200
      end
      item
        Caption = 'Description'
        Width = 200
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListViewURLDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    TabOrder = 1
    object EditSearch: TEdit
      Left = 8
      Top = 14
      Width = 457
      Height = 21
      TabOrder = 0
      OnExit = EditSearchExit
    end
    object btnSearch: TButton
      Left = 471
      Top = 14
      Width = 75
      Height = 21
      Caption = 'Search'
      TabOrder = 1
      OnClick = btnSearchClick
    end
  end
end
