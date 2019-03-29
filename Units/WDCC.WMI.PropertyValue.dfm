object FrmWMIPropValue: TFrmWMIPropValue
  Left = 0
  Top = 0
  Caption = 'WMI property Value'
  ClientHeight = 146
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemoValue: TMemo
    Left = 0
    Top = 0
    Width = 447
    Height = 146
    Align = alClient
    PopupMenu = PopupActionBar1
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object PopupActionBar1: TPopupActionBar
    Left = 168
    Top = 16
  end
end
