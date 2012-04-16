object FrmWMIInfo: TFrmWMIInfo
  Left = 326
  Top = 122
  Caption = 'FrmWMIInfo'
  ClientHeight = 637
  ClientWidth = 1289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1289
    Height = 637
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'WMI Info'
      object ValueListEditorWMI: TValueListEditor
        Left = 0
        Top = 0
        Width = 1281
        Height = 609
        Align = alClient
        DisplayOptions = [doAutoColResize, doKeyColFixed]
        TabOrder = 0
        ColWidths = (
          426
          849)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'OS Info'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 281
      ExplicitHeight = 165
      object ValueListEditorOS: TValueListEditor
        Left = 0
        Top = 0
        Width = 1281
        Height = 609
        Align = alClient
        DisplayOptions = [doAutoColResize, doKeyColFixed]
        TabOrder = 0
        ExplicitWidth = 281
        ExplicitHeight = 165
        ColWidths = (
          426
          849)
      end
    end
  end
end
