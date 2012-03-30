object FrmWmiClasses: TFrmWmiClasses
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 635
  ClientWidth = 1113
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 305
    Top = 0
    Width = 5
    Height = 635
    Beveled = True
  end
  object PanelMetaWmiInfo: TPanel
    Left = 0
    Top = 0
    Width = 305
    Height = 635
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -1
    DesignSize = (
      305
      635)
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
      Width = 198
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 1
      OnChange = ComboBoxClassesChange
      ExplicitWidth = 201
    end
    object ComboBoxNameSpaces: TComboBox
      Left = 101
      Top = 5
      Width = 197
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 0
      OnChange = ComboBoxNameSpacesChange
      ExplicitWidth = 200
    end
    object CheckBoxSelAllProps: TCheckBox
      Left = 9
      Top = 169
      Width = 114
      Height = 17
      Caption = 'Select all Properties'
      TabOrder = 4
      OnClick = CheckBoxSelAllPropsClick
    end
    object MemoClassDescr: TMemo
      Left = 9
      Top = 59
      Width = 290
      Height = 73
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      ExplicitWidth = 293
    end
    object ListViewProperties: TListView
      Left = 7
      Top = 192
      Width = 292
      Height = 433
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
      TabOrder = 5
      ViewStyle = vsReport
      OnClick = ListViewPropertiesClick
      ExplicitWidth = 295
    end
    object ButtonGetValues: TButton
      Left = 128
      Top = 161
      Width = 171
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Get Properties Values'
      ImageIndex = 2
      Images = ImageList1
      TabOrder = 3
      OnClick = ButtonGetValuesClick
      ExplicitWidth = 174
    end
  end
  object PanelCode: TPanel
    Left = 310
    Top = 0
    Width = 803
    Height = 635
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    ExplicitLeft = 311
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 423
    Top = 198
    Bitmap = {
      494C010103007800300210001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      00030B140B72414841F6606360FE676967FF686968FF365D38EF264727CE6263
      62F7636363F75A5A5AF4373737DF020202300000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000D2044
      22C2485449FE8D908DFFAAABA8FFADADADFF969696FF6F6F6FFF767676FF9696
      96FFADADADFF939493EF7B7B7BEF353535D70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000817563E69E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E907AFF9E90
      7AFF9E907AFF9E907AFF9E907AFF817563E60000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000D2E6632D1527C
      5FFF696D6BFFD3D3CEFF706B5DFF424140FF444444FF4F4F4FFF4F4F4FFF4444
      44FF404140FF425342F5C3C3C3FF595959EF0000000004040552202325D83438
      3DFF2B2F31EF0D0E0F88000000000000000000000000000000000D0E0E882A2D
      30EF353A3EFF212526D804040552000000009E907AFF282828FF2D2D2DFF3131
      31FF1F1F1FFF181818FF181818FF161616FF161616FF131313FF101010FF0F0F
      0FFF0E0E0EFF0E0E0EFF0E0E0EFF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000245029B174BF8CFF5F7C
      6BFF818381FFD3D3CEFFC0A467FF44423FFFBCBCBCFFCECECEFFC1C1C1FFACAC
      ACFF404341FF64A477FFC3C3C3FF787878F70304044E383D40FD898D91FF9294
      96FF61676EFF383E42FF111314A00000000000000000121414A04B4F53FF989B
      A0FF797D83FF52575FFF31383CFD0303044E9E907AFF2C2C2CFF48AB61FF2B70
      3DFF48AB61FF447550FF1B973BFF1F6431FF1B973BFF1D622FFF1B973BFF1A5F
      2CFF1B973BFF195E2BFF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000060D07464FA859FBB4EAD3FF5690
      5EFF717571FFD3D3CEFF766B57FF4B4A49FF636363FF919191FF777777FF6363
      63FF494A49FF6C7C74FFC3C3C3FF686968F51C1F21CF525960FFA49267FFCCBD
      7BFFC2AB76FF7E7D7CFF2C3439FE0000000000000000353B40FE696A68FFB29E
      66FFD1C180FFB5A381FF54595EFF181C1ECF9E907AFF2F2F2FFF6FE789FF459A
      58FF6FE789FF5F9B6AFF4BE16CFF3B8F4DFF4BE16CFF398D4BFF4BE16CFF358A
      48FF4BE16CFF358947FF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002B5A31B291D7AEFF9FDEB3FF81C2
      6DFF748862FF909090FFE8E8E8FFDDDDDDFFC0C0C0FF898378FF897D6DFFD8D7
      D5FFDDDDDDFFC3C3C3FF909090FF324833E22A3237FA323028FF74531CFF866D
      3BFF795A25FF947E62FF20292EFF000000200000002031383CFF453417FF7C60
      2BFF866D3BFF745118FF77726AFF23292FFA9E907AFF323232FF56FFDDFF3DB3
      9CFF56FFDDFF59AF9DFF56FFDDFF2AA18AFF2CFFD6FF289F88FF2CFFD6FF259C
      85FF2CFFD6FF239A83FF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000499853E4AFE9CFFF82D48FFFBEDC
      89FFBCC47DFF9E875DFF8A8781FF9D9D9DFF847E74FFAC7E4AFFAF8145FF837E
      74FF9D9D9DFF828683FF87A596FF276229E91C2224E7292924FF705432FF7560
      41FF785E3FFF433826FF3F4850FF171919A9171818A7475055FF372A15FF775E
      3EFF765D3FFF6C502CFF373A36FF171C20E79E907AFF373737FF6A6A6AFF6464
      64FF0AF3FFFF4DACB0FF3BF5FEFF1C9FA6FF0AF3FFFF179AA1FF242424FF2323
      23FF0AF3FFFF11949BFF131313FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000058B463F6BDEFDDFF71D17BFF8FD1
      6AFFBBE09DFFC7A65CFFD3AF5CFFC59851FFC5BB6CFFAED178FFB3C36BFFAEA8
      5DFF79A855FF58A265FFB0E3CEFF2C7430F71A1B1D934B5359FF352D21FF6556
      42FF403728FF252E34FF3A4549FF3D4348FF393F43FF616A71FF333A3CFF4E40
      2FFF685844FF2C2820FF444E54FF1A1A1B949E907AFF3A3A3AFF717171FF6B6B
      6BFF3DB1FEFF1F699BFF5F5F5FFF545454FF0D9EFFFF1A6BA2FF272727FF2323
      23FF1A1A1AFF1B1B1BFF141414FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000058B364F5BDF0DCFF80D882FF75DB
      6BFFBEE599FFCCDFA6FFCAA75BFFC1BC6AFFB7DA8AFFA5D85EFF75D13DFF68D0
      44FF57BB4EFF61AA6AFFB1E4CEFF307733F60102022C6A7074FF9BA0A5FF626A
      6FFF5C666AFF313D40FF2B373CFF404A4EFF3B454AFF59656BFFB7B9BBFF7D87
      8AFF535C60FF505B5FFF5E656AFF0102022C9E907AFF3E3E3EFF777777FF7070
      70FF6D6D6DFF4B4B4BFF515151FF606060FF4378FEFF2147A5FF252525FF1B1B
      1BFF1A1A1AFF1B1B1BFF141414FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004B9955E2B2ECD2FF9AE2A1FF9CEA
      8CFFD4EDB6FFD0EAC7FFCFB86CFFCCB064FFCBC973FF74DB65FF64D94BFF63D7
      4BFF6AD35BFF71BA7CFFA4DBC1FF2D6D31E60000000035393CDABFC1C3FFD8D7
      D7FF798082FF455255FF556065FFA2A7ABFF737C82FF626D72FF727B80FFC7C8
      C9FF5F686AFF344044FF353A3CDB000000009E907AFF3F3F3FFF7B7B7BFF7575
      75FF6F6F6FFF6D6D6DFF393939FF595959FF3C3C99FF3D3D70FF1C1C1CFF1414
      14FF161616FF161616FF121212FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002B5932AD97DEB4FFB4EBCCFFB0EF
      A6FFC9EEA8FFD1EAC9FFD5CF8CFFD9CB8AFFCDB364FFBBBB65FF99D66FFF81DE
      71FF78DC6FFF90D0A2FF87C8A3FF1F4A22B90000000012131480919598FFDCDC
      DCFF8F9394FF576265FF8B969DFF9CA5ADFF939DA3FF606B71FF70787BFFB0B2
      B3FF454F52FF394347FF0F101180000000009E907AFF444444FF828282FF7B7B
      7BFF777777FF727272FF6B6B6BFF2D2D2DFF4B4B4BFF4D4D4DFF474747FF2626
      26FF141414FF161616FF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050A063C5BBB68FABFF3E2FFB4EF
      B3FFB4F0ABFFC0EDB6FFD4E3B6FFD9D89BFFDAD394FFCDB46BFFC7B26BFFB4CB
      83FF93DF99FFAEE7CDFF429649FC060E064F000000000101011E595D61FED8D9
      DAFFA8ABACFF606B6EFF778389FF747C83FF747D84FF59666CFF7A8385FF9397
      99FF374346FF3A4146FE0000001E000000009E907AFF484848FF8C8C8CFF8787
      87FF7C7C7CFF6F6F6FFF636363FF505050FF181818FF484848FF4F4F4FFF4B4B
      4BFF363636FF171717FF111111FF9E907AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000027512DA586D79FFFBFF2
      DEFFC7F2D6FFD5EFD5FFD0E9CFFFD5DBA5FFDCDEAAFFDBCD8FFFD7C88AFFC9C0
      8DFFBCD5AEFF78C790FF245229B60000000000000000000000001D2023BF9598
      9AFF97999AFF1D2529FF485156FF697074FF495156FF707579FFB2B3B2FF484F
      51FF1F282CFF1D2021C10000000000000000998C78FF3E3E3EFF3D3D3DFF3737
      37FF343434FF323232FF313131FF303030FF232323FF050505FF1E1E1EFF2525
      25FF232323FF202020FF141414FF998C78FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000005387340C48BD8
      A1FFCDF5E8FFD4EDDAFFCEEDD3FFCFDFAEFFD6DEB4FFD4D4A1FFCED0A0FFC3D0
      A9FF86C990FF36753DD10000000F0000000000000000000000000000001C3B3B
      3BC7585959FF000205FA5C6166FE979C9DFF3F4A4EFF4D5256F95A5957FC0C12
      15FF020608CA0000001C0000000000000000968B7AFFA39681FFA89B87FFADA1
      90FFB2A897FFB8AD9EFFBCB3A4FFBDB4A6FFBDB4A5FFB9B0A0FFBAB1A1FFB2A8
      95FFB7AE99FF636CBBFF2342E3FF96897CFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000042750
      2CA45AB966F8A4E1BAFFB9EACCFFC4E0BDFFC4DAB3FFBCD7AFFFA5D7ABFF59B7
      64FB2D5E33B60000000C00000000000000000000000000000000000000000000
      000000000000000000000F0F0F785C5C5AFA171D1FEF05060565000000000000
      0000000000000000000000000000000000005A544CC68F887AFF92897DFF958C
      82FF968F84FF999388FF9C958BFF9C958CFF9C958BFF9A9389FF9C978BFF9A94
      87FF989286FF99938CFF9A948DFF5F5C57C60000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000050B063D2A5630AA499552DF57B363F45AB966F850A25BE92E5F34B2070F
      0848000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
