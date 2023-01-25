// **************************************************************************************************
//
// Unit WDCC.Settings
// unit for the WMI Delphi Code Creator
// https://github.com/RRUZ/wmi-delphi-code-creator
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is WDCC.Settings.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, WDCC.Delphi.IDE.Highlight, SynEdit, WDCC.ComboBox,
  SynEditHighlighter, SynHighlighterPas, SynHighlighterCpp, Vcl.Styles.Ext, Vcl.Styles.ColorTabs,
  SynHighlighterCS, Vcl.ExtDlgs, SynHighlighterSQL, Vcl.Themes, Vcl.Styles.Fixes,
  SynEditCodeFolding;

type
  TSettings = class
  private
    FCurrentTheme: string;
    FFontSize: Word;
    FFontName: string;
    FDelphiWmiClassCodeGenMode: Integer;
    FDelphiWmiClassHelperFuncts: Boolean;
    FShowImplementedMethods: Boolean;
    FDelphiWmiEventCodeGenMode: Integer;
    FOutputFolder: string;
    FDelphiWmiMethodCodeGenMode: Integer;
    FLastWmiNameSpace: string;
    FLastWmiClass: string;
    FVCLStyle: string;
    FFormatter: string;
    FLastWmiNameSpaceEvents: string;
    FLastWmiNameSpaceMethods: string;
    FLastWmiEvent: string;
    FLastWmiEventTargetInstance: string;
    FLastWmiEventIntrinsic: Boolean;
    FLastWmiClassesMethods: string;
    FLastWmiMethod: string;
    FCheckForUpdates: Boolean;
    FDisableVClStylesNC: Boolean;
    FDefaultLanguage: Integer;
    FAStyleCmdLine: string;
    FMicrosoftCppCmdLine: string;
    FCSharpCmdLine: string;
    FFPCWmiClassHelperFuncts: Boolean;
    // FActivateCustomForm: Boolean;
    // FCustomFormNC: Boolean;
    // FCustomFormBack: Boolean;
    // FColorBack: TColor;
    // FColorNC: TColor;
    // FImageNC: string;
    // FImageBack: string;
    // FUseColorNC: Boolean;
    // FUseColorBack: Boolean;
    FUseOnlineMSDNinTree: Boolean;
    function GetOutputFolder: string;
    function GetBackGroundColor: TColor;
    function GetForeGroundColor: TColor;
  public
    property CurrentTheme: string Read FCurrentTheme Write FCurrentTheme;
    property FontName: string Read FFontName Write FFontName;
    property FontSize: Word Read FFontSize Write FFontSize;
    property DelphiWmiClassCodeGenMode: Integer Read FDelphiWmiClassCodeGenMode Write FDelphiWmiClassCodeGenMode;
    property DelphiWmiClassHelperFuncts: Boolean Read FDelphiWmiClassHelperFuncts Write FDelphiWmiClassHelperFuncts;
    property DelphiWmiEventCodeGenMode: Integer Read FDelphiWmiEventCodeGenMode Write FDelphiWmiEventCodeGenMode;
    property DelphiWmiMethodCodeGenMode: Integer Read FDelphiWmiMethodCodeGenMode Write FDelphiWmiMethodCodeGenMode;
    property FPCWmiClassHelperFuncts: Boolean Read FFPCWmiClassHelperFuncts Write FFPCWmiClassHelperFuncts;
    property ShowImplementedMethods: Boolean read FShowImplementedMethods write FShowImplementedMethods;
    property OutputFolder: string read GetOutputFolder write FOutputFolder;
    property BackGroundColor: TColor read GetBackGroundColor;
    property ForeGroundColor: TColor read GetForeGroundColor;
    property LastWmiNameSpace: string read FLastWmiNameSpace Write FLastWmiNameSpace;
    property LastWmiClass: string read FLastWmiClass Write FLastWmiClass;

    property LastWmiNameSpaceMethods: string read FLastWmiNameSpaceMethods Write FLastWmiNameSpaceMethods;
    property LastWmiClassesMethods: string read FLastWmiClassesMethods Write FLastWmiClassesMethods;
    property LastWmiMethod: string read FLastWmiMethod Write FLastWmiMethod;

    property LastWmiNameSpaceEvents: string read FLastWmiNameSpaceEvents Write FLastWmiNameSpaceEvents;
    property LastWmiEvent: string read FLastWmiEvent Write FLastWmiEvent;
    property LastWmiEventTargetInstance: string read FLastWmiEventTargetInstance Write FLastWmiEventTargetInstance;
    property LastWmiEventIntrinsic: Boolean read FLastWmiEventIntrinsic Write FLastWmiEventIntrinsic;

    property VCLStyle: string read FVCLStyle Write FVCLStyle;
    property DisableVClStylesNC: Boolean read FDisableVClStylesNC write FDisableVClStylesNC;

    // property ActivateCustomForm : Boolean read FActivateCustomForm write FActivateCustomForm;
    // property CustomFormNC : Boolean read FCustomFormNC write FCustomFormNC;
    // property CustomFormBack : Boolean read FCustomFormBack write FCustomFormBack;
    // property UseColorNC : Boolean read FUseColorNC write FUseColorNC;
    // property UseColorBack : Boolean read FUseColorBack write FUseColorBack;
    // property ColorNC : TColor read FColorNC write FColorNC;
    // property ColorBack : TColor read FColorBack write FColorBack;
    // property ImageNC : string read FImageNC write FImageNC;
    // property ImageBack : string read FImageBack write FImageBack;

    property Formatter: string read FFormatter write FFormatter;
    property DefaultLanguage: Integer read FDefaultLanguage write FDefaultLanguage;

    property CheckForUpdates: Boolean read FCheckForUpdates write FCheckForUpdates;
    property AStyleCmdLine: string read FAStyleCmdLine write FAStyleCmdLine;
    property MicrosoftCppCmdLine: string read FMicrosoftCppCmdLine write FMicrosoftCppCmdLine;
    property CSharpCmdLine: string read FCSharpCmdLine write FCSharpCmdLine;

    property UseOnlineMSDNinTree: Boolean read FUseOnlineMSDNinTree write FUseOnlineMSDNinTree;
  end;

  TFrmSettings = class(TForm)
    ButtonApply: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ButtonCancel: TButton;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    CbDelphiCodeWmiClass: TComboBox;
    LabelDescr: TLabel;
    CheckBoxDelphiHelperFunc: TCheckBox;
    TabSheet3: TTabSheet;
    CheckBoxShowImplMethods: TCheckBox;
    Label5: TLabel;
    CbDelphiCodeWmiEvent: TComboBox;
    LabelDescrEvent: TLabel;
    TabSheet4: TTabSheet;
    EditOutputFolder: TEdit;
    Label6: TLabel;
    BtnSelFolderThemes: TButton;
    CbDelphiCodeWmiMethod: TComboBox;
    LabelDescrMethod: TLabel;
    Label8: TLabel;
    BtnDeleteCache: TButton;
    Label7: TLabel;
    ComboBoxVCLStyle: TComboBox;
    Label9: TLabel;
    CbFormatter: TComboBox;
    Label10: TLabel;
    CheckBoxUpdates: TCheckBox;
    CheckBoxDisableVClStylesNC: TCheckBox;
    TabSheet5: TTabSheet;
    SynPasSyn1: TSynPasSyn;
    ComboBoxLanguageSel: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    EditAStyle: TEdit;
    PageControl2: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    SynEditCode: TSynEdit;
    UpDown1: TUpDown;
    Label3: TLabel;
    EditFontSize: TEdit;
    Label2: TLabel;
    ComboBoxFont: TComboBox;
    ButtonGetMore: TButton;
    ComboBoxTheme: TComboBox;
    Label1: TLabel;
    ComboBoxLanguageThemes: TComboBox;
    Label14: TLabel;
    SynCSSyn1: TSynCSSyn;
    SynCppSyn1: TSynCppSyn;
    Label15: TLabel;
    ComboBoxLanguageTemplate: TComboBox;
    Label16: TLabel;
    ComboBox1: TComboBox;
    Label17: TLabel;
    ComboBox2: TComboBox;
    TabSheet8: TTabSheet;
    Label18: TLabel;
    EditMicrosoftCppSwitch: TMemo;
    EditCSharpSwitch: TMemo;
    Label19: TLabel;
    CheckBoxFPCHelperFunc: TCheckBox;
    GroupBoxNonClient: TGroupBox;
    EditNCImage: TEdit;
    RadioButtonNCImage: TRadioButton;
    RadioButtonNCColor: TRadioButton;
    ColorBoxNC: TColorBox;
    BtnSetNCImage: TButton;
    CheckBoxNC: TCheckBox;
    GroupBoxBackgroud: TGroupBox;
    EditBackImage: TEdit;
    RadioButtonBackImage: TRadioButton;
    RadioButtonBackColor: TRadioButton;
    ColorBoxBack: TColorBox;
    BtnSetBackImage: TButton;
    CheckBoxBack: TCheckBox;
    CheckBoxFormCustom: TCheckBox;
    OpenPictureDialog1: TOpenPictureDialog;
    SynSQLSyn1: TSynSQLSyn;
    PanelPreview: TPanel;
    GroupBox1: TGroupBox;
    CheckBoxOnlineMSDN: TCheckBox;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxThemeChange(Sender: TObject);
    procedure ButtonGetMoreClick(Sender: TObject);
    procedure ComboBoxFontChange(Sender: TObject);
    procedure CbDelphiCodeWmiClassChange(Sender: TObject);
    procedure CbDelphiCodeWmiEventChange(Sender: TObject);
    procedure BtnSelFolderThemesClick(Sender: TObject);
    procedure CbDelphiCodeWmiMethodChange(Sender: TObject);
    procedure BtnDeleteCacheClick(Sender: TObject);
    procedure ComboBoxVCLStyleChange(Sender: TObject);
    procedure CheckBoxDisableVClStylesNCClick(Sender: TObject);
    procedure ComboBoxLanguageThemesChange(Sender: TObject);
    procedure CheckBoxFormCustomClick(Sender: TObject);
    procedure ColorBoxNCGetColors(Sender: TCustomColorBox; Items: TStrings);
    procedure BtnSetNCImageClick(Sender: TObject);
    procedure BtnSetBackImageClick(Sender: TObject);
  private
    FPreview: TVclStylesPreview;
    FSettings: TSettings;
    FForm: TForm;
    procedure LoadFixedWidthFonts;
    procedure LoadThemes;
    procedure LoadStyles;
    procedure LoadCodeGenData;
    procedure LoadFormatters;
    procedure DrawSeletedVCLStyle;
    procedure SetStateControls(Container: TWinControl; Value: Boolean);
  public
    property Form: TForm Read FForm Write FForm;
    property Settings: TSettings Read FSettings Write FSettings;
    procedure LoadSettings;
  end;

  {
    procedure LoadCurrentTheme(Form: TForm;const ThemeName:string);
    procedure LoadCurrentThemeFont(Form: TForm;const FontName:string;FontSize:Word);
  }
procedure LoadCurrentTheme(Component: TComponent; const ThemeName: string);
procedure LoadCurrentThemeFont(Component: TComponent; const FontName: string; FontSize: Word);

procedure LoadVCLStyle(Const StyleName: String);
procedure ReadSettings(var Settings: TSettings);
procedure WriteSettings(const Settings: TSettings);

function ExistWmiClassesCache(const namespace: string): Boolean; overload;
function ExistWmiClassesCache(const Host, namespace: string): Boolean; overload;
function ExistWmiClassesMethodsCache(const namespace: string): Boolean;
function ExistWmiNameSpaceCache: Boolean; overload;
function ExistWmiNameSpaceCache(const Host: String): Boolean; overload;

procedure LoadWMINameSpacesFromCache(List: TStrings); overload;
procedure LoadWMINameSpacesFromCache(const Host: string; List: TStrings); overload;
procedure SaveWMINameSpacesToCache(List: TStrings); overload;
procedure SaveWMINameSpacesToCache(const Host: string; List: TStrings); overload;

procedure LoadWMIClassesFromCache(const namespace: string; List: TStrings); overload;
procedure LoadWMIClassesFromCache(const Host, namespace: string; List: TStrings); overload;

procedure LoadWMIClassesMethodsFromCache(const namespace: string; List: TStrings);

procedure SaveWMIClassesToCache(const namespace: string; List: TStrings); overload;
procedure SaveWMIClassesToCache(const Host, namespace: string; List: TStrings); overload;
procedure SaveWMIClassesMethodsToCache(const namespace: string; List: TStrings);

function GetWMICFolderCache: string;

// function GetUpdaterInstance: TFrmCheckUpdate;

implementation

{$R *.dfm}

uses
  Winapi.ShlObj,
  System.Types,
  System.UITypes,
  Winapi.ShellAPI,
  Vcl.GraphUtil,
{$WARN UNIT_PLATFORM OFF}
  Vcl.FileCtrl,
{$WARN UNIT_PLATFORM ON}
  WDCC.Delphi.Versions,
  WDCC.SelectCompilerVersion,
  System.StrUtils,
  System.IOUtils,
  System.IniFiles,
  WDCC.WMI.DelphiCode,
  WDCC.WMI.GenCode,
  Vcl.Styles,
  WDCC.Misc;

const
  sThemesExt = '.theme.xml';

Var
  DummyFrm: TFrmSettings;

type
  TVclStylesPreviewClass = class(TVclStylesPreview);

  // function GetUpdaterInstance: TFrmCheckUpdate;
  // begin
  // Result := TFrmCheckUpdate.Create(nil);
  // Result.RemoteVersionFile := 'http://dl.dropbox.com/u/12733424/Blog/Delphi%20Wmi%20Code%20Creator/Version.xml';
  // Result.ApplicationName := 'WMI Delphi Code Creator';
  // Result.XPathVersionNumber := '/versioninfo/@versionapp';
  // Result.XPathUrlInstaller := '/versioninfo/@url';
  // Result.XPathInstallerFileName := '/versioninfo/@installerfilename';
  // end;
  //
function GetWMICFolderCache: string;
begin
  Result := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA)) + 'WDCC\Cache\';
  // C:\Users\Dexter\AppData\Roaming\WDCC\Cache
  SysUtils.ForceDirectories(Result);
end;

function ExistWmiClassesCache(const namespace: string): Boolean;
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + FileName + '.wmic';
  Result := FileExists(FileName);
end;

function ExistWmiClassesCache(const Host, namespace: string): Boolean;
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + Host + FileName + '.wmic';
  Result := FileExists(FileName);
end;

function ExistWmiClassesMethodsCache(const namespace: string): Boolean;
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + FileName + '_ClassMethods.wmic';
  Result := FileExists(FileName);
end;

function ExistWmiNameSpaceCache: Boolean;
begin
  Result := FileExists(GetWMICFolderCache + 'Namespaces.wmic');
end;

function ExistWmiNameSpaceCache(const Host: String): Boolean;
begin
  Result := FileExists(GetWMICFolderCache + Host + 'Namespaces.wmic');
end;

procedure LoadWMINameSpacesFromCache(List: TStrings);
begin
  List.LoadFromFile(GetWMICFolderCache + 'Namespaces.wmic');
end;

procedure LoadWMINameSpacesFromCache(const Host: string; List: TStrings);
begin
  List.LoadFromFile(GetWMICFolderCache + Host + 'Namespaces.wmic');
end;

procedure LoadWMIClassesFromCache(const namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + FileName + '.wmic';
  List.LoadFromFile(FileName);
end;

procedure LoadWMIClassesFromCache(const Host, namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + Host + FileName + '.wmic';
  List.LoadFromFile(FileName);
end;

procedure LoadWMIClassesMethodsFromCache(const namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + FileName + '_ClassMethods.wmic';
  List.LoadFromFile(FileName);
end;

procedure SaveWMIClassesMethodsToCache(const namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + FileName + '_ClassMethods.wmic';
  List.SaveToFile(FileName);
end;

procedure SaveWMIClassesToCache(const namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + FileName + '.wmic';
  List.SaveToFile(FileName);
end;

procedure SaveWMIClassesToCache(const Host, namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := GetWMICFolderCache + Host + FileName + '.wmic';
  List.SaveToFile(FileName);
end;

procedure SaveWMINameSpacesToCache(List: TStrings);
begin
  List.SaveToFile(GetWMICFolderCache + 'Namespaces.wmic');
end;

procedure SaveWMINameSpacesToCache(const Host: string; List: TStrings);
begin
  List.SaveToFile(GetWMICFolderCache + Host + 'Namespaces.wmic');
end;

procedure RegisterVCLStyle(const StyleFileName: string);
begin
  if TStyleManager.IsValidStyle(StyleFileName) then
    TStyleManager.LoadFromFile(StyleFileName)
  else
    MsgWarning('the Style is not valid');
end;

procedure LoadVCLStyle(Const StyleName: String);
begin
  if StyleName <> '' then
    TStyleManager.SetStyle(StyleName)
  else
    TStyleManager.SetStyle(TStyleManager.SystemStyle);
end;

function GetCurrentTheme(const ThemeName: string): TIDETheme;
var
  FileName: string;
begin
  FileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + '\Themes') + ThemeName + sThemesExt;
  LoadThemeFromXMLFile(Result, FileName);
end;

{ TSettings }

function TSettings.GetBackGroundColor: TColor;
var
  Element: TIDEHighlightElements;
  IDETheme: TIDETheme;
begin
  Element := TIDEHighlightElements.PlainText;
  IDETheme := GetCurrentTheme(CurrentTheme);
  Result := StringToColor(IDETheme[Element].BackgroundColorNew);
end;

function TSettings.GetForeGroundColor: TColor;
var
  Element: TIDEHighlightElements;
  IDETheme: TIDETheme;
begin
  Element := TIDEHighlightElements.PlainText;
  IDETheme := GetCurrentTheme(CurrentTheme);
  Result := StringToColor(IDETheme[Element].ForegroundColorNew);
end;

function TSettings.GetOutputFolder: string;
begin
  if (FOutputFolder = '') or not SysUtils.DirectoryExists(FOutputFolder) then
    Result := GetTempDirectory
  else
    Result := FOutputFolder;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: Pointer)
  : Integer; stdcall;
begin
  // if ((FontType and TrueType_FontType) <> 0) and  ((LogFont.lfPitchAndFamily and VARIABLE_PITCH) = 0) then
  if ((LogFont.lfPitchAndFamily and FIXED_PITCH) <> 0) then
    if not StartsText('@', LogFont.lfFaceName) and (DummyFrm.ComboBoxFont.Items.IndexOf(LogFont.lfFaceName) < 0) then
      DummyFrm.ComboBoxFont.Items.Add(LogFont.lfFaceName);

  Result := 1;
end;

procedure SetSynAttr(FCurrentTheme: TIDETheme; Element: TIDEHighlightElements; SynAttr: TSynHighlighterAttributes;
  DelphiVersion: TDelphiVersions);
begin
  SynAttr.Background := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew),
    DelphiVersion);
  SynAttr.Foreground := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),
    DelphiVersion);
  SynAttr.Style := [];
  if FCurrentTheme[Element].Bold then
    SynAttr.Style := SynAttr.Style + [fsBold];
  if FCurrentTheme[Element].Italic then
    SynAttr.Style := SynAttr.Style + [fsItalic];
  if FCurrentTheme[Element].Underline then
    SynAttr.Style := SynAttr.Style + [fsUnderline];
end;

procedure RefreshSynEdit(FCurrentTheme: TIDETheme; SynEdit: TSynEdit);
var
  Element: TIDEHighlightElements;
  DelphiVer: TDelphiVersions;
begin
  DelphiVer := DelphiXE;

  Element := TIDEHighlightElements.RightMargin;
  SynEdit.RightEdgeColor := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),
    DelphiVer);

  Element := TIDEHighlightElements.MarkedBlock;
  SynEdit.SelectedColor.Foreground := GetDelphiVersionMappedColor
    (StringToColor(FCurrentTheme[Element].ForegroundColorNew), DelphiVer);
  SynEdit.SelectedColor.Background := GetDelphiVersionMappedColor
    (StringToColor(FCurrentTheme[Element].BackgroundColorNew), DelphiVer);

  Element := TIDEHighlightElements.LineNumber;
  SynEdit.Gutter.Color := StringToColor(FCurrentTheme[Element].BackgroundColorNew);
  SynEdit.Gutter.Font.Color := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),
    DelphiVer);

  Element := TIDEHighlightElements.LineHighlight;
  SynEdit.ActiveLineColor := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew),
    DelphiVer);

  Element := TIDEHighlightElements.PlainText;
  SynEdit.Gutter.BorderColor := GetHighLightColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew));
end;

procedure RefreshSynPasHighlighter(FCurrentTheme: TIDETheme; SynEdit: TSynEdit);
var
  DelphiVer: TDelphiVersions;
begin
  if not(SynEdit.Highlighter is TSynPasSyn) then
    exit;

  DelphiVer := DelphiXE;

  RefreshSynEdit(FCurrentTheme, SynEdit);

  with TSynPasSyn(SynEdit.Highlighter) do
  begin
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Assembler, AsmAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Character, CharAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Comment, CommentAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, DirectiveAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Float, FloatAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Hex, HexAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, IdentifierAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, KeyAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, NumberAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Whitespace, SpaceAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.String, StringAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, SymbolAttri, DelphiVer);
  end;
end;

procedure RefreshSynCppHighlighter(FCurrentTheme: TIDETheme; SynEdit: TSynEdit);
var
  DelphiVer: TDelphiVersions;
begin
  if not(SynEdit.Highlighter is TSynCppSyn) then
    exit;
  DelphiVer := DelphiXE;

  RefreshSynEdit(FCurrentTheme, SynEdit);

  with TSynCppSyn(SynEdit.Highlighter) do
  begin
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Assembler, AsmAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Character, CharAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Comment, CommentAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, DirecAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Float, FloatAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Hex, HexAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, IdentifierAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, InvalidAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, KeyAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, NumberAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, OctalAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Whitespace, SpaceAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.String, StringAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, SymbolAttri, DelphiVer);
  end;
end;

procedure RefreshSynCSharpHighlighter(FCurrentTheme: TIDETheme; SynEdit: TSynEdit);
var
  DelphiVer: TDelphiVersions;
begin
  if not(SynEdit.Highlighter is TSynCSSyn) then
    exit;
  DelphiVer := DelphiXE;

  RefreshSynEdit(FCurrentTheme, SynEdit);

  with TSynCSSyn(SynEdit.Highlighter) do
  begin
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Assembler, AsmAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Comment, CommentAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, DirecAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, IdentifierAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, InvalidAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, KeyAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, NumberAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Whitespace, SpaceAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.String, StringAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, SymbolAttri, DelphiVer);
  end;
end;

procedure RefreshSynSQLHighlighter(FCurrentTheme: TIDETheme; SynEdit: TSynEdit);
var
  DelphiVer: TDelphiVersions;
begin
  if not(SynEdit.Highlighter is TSynSQLSyn) then
    exit;
  DelphiVer := DelphiXE;

  RefreshSynEdit(FCurrentTheme, SynEdit);

  with TSynSQLSyn(SynEdit.Highlighter) do
  begin
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Comment, CommentAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, ConditionalCommentAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, DataTypeAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, DefaultPackageAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, DelimitedIdentifierAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, ExceptionAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, FunctionAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, IdentifierAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, KeyAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, NumberAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, PLSQLAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Whitespace, SpaceAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, SQLPlusAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.String, StringAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, SymbolAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, TableNameAttri, DelphiVer);
    SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, VariableAttri, DelphiVer);
  end;
end;

procedure ReadSettings(var Settings: TSettings);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(GetWMICFolderCache + 'Settings.ini');
  try
    Settings.CurrentTheme := iniFile.ReadString('Global', 'CurrentTheme', 'deep-blue');
    Settings.FontName := iniFile.ReadString('Global', 'FontName', 'Consolas');
    Settings.FontSize := iniFile.ReadInteger('Global', 'FontSize', 10);
    Settings.DelphiWmiClassCodeGenMode := iniFile.ReadInteger('Global', 'DelphiWmiClassCodeGenMode',
      Integer(WmiCode_LateBinding));
    Settings.DelphiWmiClassHelperFuncts := iniFile.ReadBool('Global', 'DelphiWmiClassHelperFuncts', False);
    Settings.FPCWmiClassHelperFuncts := iniFile.ReadBool('Global', 'FPCWmiClassHelperFuncts', False);

    Settings.ShowImplementedMethods := iniFile.ReadBool('Global', 'ShowImplementedMethods', True);
    Settings.DelphiWmiEventCodeGenMode := iniFile.ReadInteger('Global', 'DelphiWmiEventCodeGenMode',
      Integer(WmiCode_Scripting));
    Settings.OutputFolder := iniFile.ReadString('Global', 'OutputFolder', GetTempDirectory);
    Settings.DelphiWmiMethodCodeGenMode := iniFile.ReadInteger('Global', 'DelphiWmiMethodCodeGenMode',
      Integer(WmiCode_Scripting));
    Settings.LastWmiNameSpace := iniFile.ReadString('Global', 'LastWmiNameSpace', 'root\CIMV2');
    Settings.LastWmiClass := iniFile.ReadString('Global', 'LastWmiClass', 'Win32_OperatingSystem');

    Settings.LastWmiNameSpaceMethods := iniFile.ReadString('Global', 'LastWmiNameSpaceMethods', 'root\CIMV2');
    Settings.LastWmiClassesMethods := iniFile.ReadString('Global', 'LastWmiClassesMethods', '');
    Settings.LastWmiMethod := iniFile.ReadString('Global', 'LastWmiMethod', '');

    Settings.LastWmiNameSpaceEvents := iniFile.ReadString('Global', 'LastWmiNameSpaceEvents', 'root\CIMV2');
    Settings.LastWmiEvent := iniFile.ReadString('Global', 'LastWmiEvent', '');
    Settings.LastWmiEventTargetInstance := iniFile.ReadString('Global', 'LastWmiEventTargetInstance', '');
    Settings.LastWmiEventIntrinsic := iniFile.ReadBool('Global', 'LastWmiEventIntrinsic', True);
    Settings.VCLStyle := iniFile.ReadString('Global', 'VCLStyle', 'glow');
    Settings.Formatter := iniFile.ReadString('Global', 'Formatter', '');
    Settings.CheckForUpdates := iniFile.ReadBool('Global', 'CheckForUpdates', True);
    Settings.DisableVClStylesNC := iniFile.ReadBool('Global', 'DisableVClStylesNC', False);

    Settings.UseOnlineMSDNinTree := iniFile.ReadBool('Global', 'UseOnlineMSDNinTree', False);

    // Settings.ActivateCustomForm            := iniFile.ReadBool('Global', 'ActivateCustomForm', False);
    // Settings.CustomFormNC                  := iniFile.ReadBool('Global', 'CustomFormNC', False);
    // Settings.CustomFormBack                := iniFile.ReadBool('Global', 'CustomFormBack', False);
    // Settings.UseColorNC                    := iniFile.ReadBool('Global', 'UseColorNC', True);
    // Settings.UseColorBack                  := iniFile.ReadBool('Global', 'UseColorBack', True);
    // Settings.ColorNC                       := iniFile.ReadInteger('Global', 'ColorNC', clWebAliceBlue);
    // Settings.ColorBack                     := iniFile.ReadInteger('Global', 'ColorBack', clWebAliceBlue);
    // Settings.ImageNC                       := iniFile.ReadString('Global', 'ImageNC', '');
    // Settings.ImageBack                     := iniFile.ReadString('Global', 'ImageBack', '');

    Settings.AStyleCmdLine := iniFile.ReadString('Global', 'AStyleCmdLine', '--style=allman "%s"');
    Settings.MicrosoftCppCmdLine := iniFile.ReadString('Global', 'MicrosoftCppCmdLine',
      '/EHsc /Fe"[OutPutPath][FileName].exe" /Fo"[OutPutPath][FileName].obj" "[OutPutPath][FileName].cpp"');
    Settings.CSharpCmdLine := iniFile.ReadString('Global', 'CSharpCmdLine',
      '/target:exe /platform:x86 /r:System.Management.dll /r:System.dll /out:"[OutPutPath][FileName].exe" "[OutPutPath][FileName].cs"');
    Settings.DefaultLanguage := iniFile.ReadInteger('Global', 'DefaultLanguage', Integer(TSourceLanguages.Lng_Delphi));
  finally
    iniFile.Free;
  end;
end;

procedure WriteSettings(const Settings: TSettings);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(GetWMICFolderCache + 'Settings.ini');
  try
    iniFile.WriteString('Global', 'CurrentTheme', Settings.CurrentTheme);
    iniFile.WriteString('Global', 'FontName', Settings.FontName);
    iniFile.WriteInteger('Global', 'FontSize', Settings.FontSize);
    iniFile.WriteInteger('Global', 'DelphiWmiClassCodeGenMode', Settings.DelphiWmiClassCodeGenMode);
    iniFile.WriteBool('Global', 'DelphiWmiClassHelperFuncts', Settings.DelphiWmiClassHelperFuncts);
    iniFile.WriteBool('Global', 'FPCWmiClassHelperFuncts', Settings.FPCWmiClassHelperFuncts);

    iniFile.WriteBool('Global', 'FPCWmiClassHelperFuncts', Settings.FPCWmiClassHelperFuncts);
    iniFile.WriteBool('Global', 'ShowImplementedMethods', Settings.ShowImplementedMethods);
    iniFile.WriteInteger('Global', 'DelphiWmiEventCodeGenMode', Settings.DelphiWmiEventCodeGenMode);
    iniFile.WriteString('Global', 'OutputFolder', Settings.OutputFolder);
    iniFile.WriteInteger('Global', 'DelphiWmiMethodCodeGenMode', Settings.DelphiWmiMethodCodeGenMode);
    iniFile.WriteString('Global', 'LastWmiNameSpace', Settings.LastWmiNameSpace);
    iniFile.WriteString('Global', 'LastWmiClass', Settings.LastWmiClass);
    iniFile.WriteString('Global', 'LastWmiNameSpaceMethods', Settings.LastWmiNameSpaceMethods);
    iniFile.WriteString('Global', 'LastWmiClassesMethods', Settings.LastWmiClassesMethods);
    iniFile.WriteString('Global', 'LastWmiMethod', Settings.LastWmiMethod);
    iniFile.WriteString('Global', 'LastWmiNameSpaceEvents', Settings.LastWmiNameSpaceEvents);
    iniFile.WriteString('Global', 'LastWmiEvent', Settings.LastWmiEvent);
    iniFile.WriteString('Global', 'LastWmiEventTargetInstance', Settings.LastWmiEventTargetInstance);
    iniFile.WriteBool('Global', 'LastWmiEventIntrinsic', Settings.LastWmiEventIntrinsic);
    iniFile.WriteString('Global', 'VCLStyle', Settings.VCLStyle);
    iniFile.WriteString('Global', 'Formatter', Settings.Formatter);
    iniFile.WriteBool('Global', 'CheckForUpdates', Settings.CheckForUpdates);

    iniFile.WriteBool('Global', 'UseOnlineMSDNinTree', Settings.UseOnlineMSDNinTree);

    iniFile.WriteBool('Global', 'DisableVClStylesNC', Settings.DisableVClStylesNC);

    // iniFile.WriteBool('Global', 'ActivateCustomForm', Settings.ActivateCustomForm);
    // iniFile.WriteBool('Global', 'CustomFormNC', Settings.CustomFormNC);
    // iniFile.WriteBool('Global', 'CustomFormBack', Settings.CustomFormBack);
    // iniFile.WriteBool('Global', 'UseColorNC', Settings.UseColorNC);
    // iniFile.WriteBool('Global', 'UseColorBack', Settings.UseColorBack);
    // iniFile.WriteInteger('Global', 'ColorNC', Settings.ColorNC);
    // iniFile.WriteInteger('Global', 'ColorBack', Settings.ColorBack);
    // iniFile.WriteString('Global', 'ImageNC', Settings.ImageNC);
    // iniFile.WriteString('Global', 'ImageBack', Settings.ImageBack);

    iniFile.WriteInteger('Global', 'DefaultLanguage', Settings.DefaultLanguage);
    iniFile.WriteString('Global', 'AStyleCmdLine', Settings.AStyleCmdLine);
    iniFile.WriteString('Global', 'MicrosoftCppCmdLine', Settings.MicrosoftCppCmdLine);
    iniFile.WriteString('Global', 'CSharpCmdLine', Settings.CSharpCmdLine);
  finally
    iniFile.Free;
  end;
end;

procedure TFrmSettings.LoadCodeGenData;
var
  i: Integer;
begin
  CbDelphiCodeWmiClass.Items.Clear;
  CbDelphiCodeWmiClass.Items.BeginUpdate;
  try
    for i := 0 to DelphiMaxTypesClassCodeGen - 1 do
      // CbDelphiCodewmiClass.Items.Add(ListWmiCodeName[DelphiWmiClassCodeSupported[i]])
      CbDelphiCodeWmiClass.Items.AddObject(ListWmiCodeName[DelphiWmiClassCodeSupported[i]],
        TObject(DelphiWmiClassCodeSupported[i]));
  finally
    CbDelphiCodeWmiClass.Items.EndUpdate;
  end;

  CbDelphiCodeWmiEvent.Items.Clear;
  CbDelphiCodeWmiEvent.Items.BeginUpdate;
  try
    for i := 0 to DelphiMaxTypesEventsCodeGen - 1 do
      CbDelphiCodeWmiEvent.Items.AddObject(ListWmiCodeName[DelphiWmiEventCodeSupported[i]],
        TObject(DelphiWmiEventCodeSupported[i]));
  finally
    CbDelphiCodeWmiEvent.Items.EndUpdate;
  end;

  CbDelphiCodeWmiMethod.Items.Clear;
  CbDelphiCodeWmiMethod.Items.BeginUpdate;
  try
    for i := 0 to DelphiMaxTypesMethodCodeGen - 1 do
      CbDelphiCodeWmiMethod.Items.AddObject(ListWmiCodeName[DelphiWmiMethodCodeSupported[i]],
        TObject(DelphiWmiMethodCodeSupported[i]));
  finally
    CbDelphiCodeWmiMethod.Items.EndUpdate;
  end;
end;

procedure TFrmSettings.LoadFixedWidthFonts;
var
  sDC: Integer;
  LogFont: TLogFont;
begin
  ComboBoxFont.Items.Clear;
  sDC := GetDC(0);
  try
    ZeroMemory(@LogFont, sizeof(LogFont));
    LogFont.lfCharset := DEFAULT_CHARSET;
    EnumFontFamiliesEx(sDC, LogFont, @EnumFontsProc, 0, 0);
  finally
    ReleaseDC(0, sDC);
  end;
end;

procedure TFrmSettings.LoadFormatters;
Var
  DelphiComp: TDelphiVersions;
  FormatterPath: string;
begin
  for DelphiComp := Delphi2010 to DelphiXE2 do
  begin
    FormatterPath := GetDelphiInstallPath(DelphiComp) + 'Formatter.exe';
    if FileExists(FormatterPath) then
      CbFormatter.Items.Add(FormatterPath);
  end;
end;

procedure TFrmSettings.ButtonGetMoreClick(Sender: TObject);
begin
  ShellExecute(Self.WindowHandle, 'open', 'http://theroadtodelphi.wordpress.com/delphi-ide-theme-editor/', nil, nil,
    SW_SHOWNORMAL);
end;

procedure TFrmSettings.BtnDeleteCacheClick(Sender: TObject);
Var
  FileName: string;
begin
  for FileName in TDirectory.GetFiles(GetWMICFolderCache, '*.wmic') do
    DeleteFile(FileName);

  MsgInformation('The cache was deleted');
end;

procedure TFrmSettings.BtnSelFolderThemesClick(Sender: TObject);
var
  Directory: string;
begin
  Directory := '';
  if SysUtils.DirectoryExists(EditOutputFolder.Text) then
    Directory := EditOutputFolder.Text;

  // sdNewFolder, sdShowEdit, sdShowShares, sdNewUI, sdShowFiles,    sdValidateDir
  if SelectDirectory('Select directory', Directory, Directory, [sdNewFolder, sdNewUI, sdShowEdit, sdValidateDir,
    sdShowShares], nil) then
    EditOutputFolder.Text := Directory;
end;

procedure TFrmSettings.BtnSetNCImageClick(Sender: TObject);
begin
  OpenPictureDialog1.InitialDir := ExtractFilePath(ParamStr(0)) + 'Textures';
  if OpenPictureDialog1.Execute then
    EditNCImage.Text := OpenPictureDialog1.FileName;

end;

procedure TFrmSettings.BtnSetBackImageClick(Sender: TObject);
begin
  OpenPictureDialog1.InitialDir := ExtractFilePath(ParamStr(0)) + 'Textures';
  if OpenPictureDialog1.Execute then
    EditBackImage.Text := OpenPictureDialog1.FileName;
end;

procedure TFrmSettings.ButtonApplyClick(Sender: TObject);
var
  i: Integer;
begin
  // if Application.MessageBox(PChar(Format('Do you want save the changes ?%s', [''])), 'Confirmation', MB_YESNO + MB_ICONQUESTION) = idYes then
  if MessageDlg('Do you want save the changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FSettings.CurrentTheme := ComboBoxTheme.Text;
    FSettings.FontName := ComboBoxFont.Text;
    FSettings.FontSize := StrToInt(EditFontSize.Text);
    FSettings.DelphiWmiClassCodeGenMode := Integer(CbDelphiCodeWmiClass.Items.Objects[CbDelphiCodeWmiClass.ItemIndex]);
    // CbDelphiCodewmiClass.ItemIndex;
    FSettings.DelphiWmiClassHelperFuncts := CheckBoxDelphiHelperFunc.Checked;
    FSettings.FPCWmiClassHelperFuncts := CheckBoxFPCHelperFunc.Checked;
    FSettings.ShowImplementedMethods := CheckBoxShowImplMethods.Checked;
    FSettings.DelphiWmiEventCodeGenMode := Integer(CbDelphiCodeWmiEvent.Items.Objects[CbDelphiCodeWmiEvent.ItemIndex]);
    FSettings.DelphiWmiMethodCodeGenMode :=
      Integer(CbDelphiCodeWmiMethod.Items.Objects[CbDelphiCodeWmiMethod.ItemIndex]);
    FSettings.OutputFolder := EditOutputFolder.Text;
    FSettings.VCLStyle := ComboBoxVCLStyle.Text;
    FSettings.Formatter := CbFormatter.Text;
    FSettings.CheckForUpdates := CheckBoxUpdates.Checked;
    FSettings.UseOnlineMSDNinTree := CheckBoxOnlineMSDN.Checked;
    FSettings.AStyleCmdLine := EditAStyle.Text;
    FSettings.MicrosoftCppCmdLine := EditMicrosoftCppSwitch.Text;
    FSettings.CSharpCmdLine := EditCSharpSwitch.Text;
    FSettings.DisableVClStylesNC := CheckBoxDisableVClStylesNC.Checked;
    FSettings.DefaultLanguage := Integer(ComboBoxLanguageSel.Items.Objects[ComboBoxLanguageSel.ItemIndex]);

    // FSettings.ActivateCustomForm            := CheckBoxFormCustom.Checked;
    // FSettings.CustomFormNC                  := CheckBoxNC.Checked;
    // FSettings.CustomFormBack                := CheckBoxBack.Checked;
    // FSettings.UseColorNC                    := RadioButtonNCColor.Checked;
    // FSettings.UseColorBack                  := RadioButtonBackColor.Checked;
    // FSettings.ColorNC                       := ColorBoxNC.Selected;
    // FSettings.ColorBack                     := ColorBoxBack.Selected;
    // FSettings.ImageNC                       := EditNCImage.Text;
    // FSettings.ImageBack                     := EditBackImage.Text;

    WriteSettings(FSettings);
    Close();
    LoadVCLStyle(ComboBoxVCLStyle.Text);

    for i := 0 to Screen.FormCount - 1 do
    begin
      LoadCurrentThemeFont(Screen.Forms[i], ComboBoxFont.Text, StrToInt(EditFontSize.Text));
      LoadCurrentTheme(Screen.Forms[i], ComboBoxTheme.Text);
    end;
  end;
end;

procedure TFrmSettings.ButtonCancelClick(Sender: TObject);
begin
  Close();
end;

procedure LoadCurrentTheme(Component: TComponent; const ThemeName: string);
var
  FileName: string;
  i: Integer;
  FCurrentTheme: TIDETheme;
begin
  FileName := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + '\Themes') + ThemeName + sThemesExt;
  LoadThemeFromXMLFile(FCurrentTheme, FileName);
  for i := 0 to Component.ComponentCount - 1 do
    if Component.Components[i] is TSynEdit then
    begin
      RefreshSynPasHighlighter(FCurrentTheme, TSynEdit(Component.Components[i]));
      RefreshSynCppHighlighter(FCurrentTheme, TSynEdit(Component.Components[i]));
      RefreshSynCSharpHighlighter(FCurrentTheme, TSynEdit(Component.Components[i]));
      RefreshSynSQLHighlighter(FCurrentTheme, TSynEdit(Component.Components[i]));
    end {
    else
    if Component.Components[i] is TWinControl then
    LoadCurrentTheme(Component.Components[i], ThemeName); }
end;

procedure LoadCurrentThemeFont(Component: TComponent; const FontName: string; FontSize: Word);
var
  i: Integer;
begin
  for i := 0 to Component.ComponentCount - 1 do
    if Component.Components[i] is TSynEdit then
    begin
      TSynEdit(Component.Components[i]).Font.Name := FontName;
      TSynEdit(Component.Components[i]).Font.Size := FontSize;
    end {
    else
    if Component.Components[i] is TWinControl then
    LoadCurrentThemeFont(Component.Components[i], FontName, FontSize); }
end;

procedure TFrmSettings.CbDelphiCodeWmiClassChange(Sender: TObject);
begin
  LabelDescr.Caption := ListWmiCodeDescr
    [TWmiCode(Integer(CbDelphiCodeWmiClass.Items.Objects[CbDelphiCodeWmiClass.ItemIndex]))];
  // ListWmiCodeDescr[TWmiCode(CbDelphiCodewmiClass.ItemIndex)];
end;

procedure TFrmSettings.CbDelphiCodeWmiEventChange(Sender: TObject);
begin
  LabelDescrEvent.Caption := ListWmiCodeDescr
    [TWmiCode(Integer(CbDelphiCodeWmiEvent.Items.Objects[CbDelphiCodeWmiEvent.ItemIndex]))];
end;

procedure TFrmSettings.CbDelphiCodeWmiMethodChange(Sender: TObject);
begin
  LabelDescrMethod.Caption := ListWmiCodeDescr
    [TWmiCode(Integer(CbDelphiCodeWmiMethod.Items.Objects[CbDelphiCodeWmiMethod.ItemIndex]))];
end;

procedure TFrmSettings.CheckBoxDisableVClStylesNCClick(Sender: TObject);
begin
  if Visible then
    MsgInformation('This feature will be applied when you restart the aplication');
end;

procedure TFrmSettings.CheckBoxFormCustomClick(Sender: TObject);

  procedure SetCheck(const CheckBox: TCheckBox; const Value: Boolean);
  var
    NotifyEvent: TNotifyEvent;
  begin
    with CheckBox do
    begin
      NotifyEvent := OnClick;
      OnClick := nil;
      Checked := Value;
      OnClick := NotifyEvent;
    end;
  end;

begin
  if CheckBoxDisableVClStylesNC.Checked then
    SetCheck(CheckBoxDisableVClStylesNC, False);

  SetStateControls(GroupBoxNonClient, CheckBoxFormCustom.Checked);
  SetStateControls(GroupBoxBackgroud, CheckBoxFormCustom.Checked);

  if Visible then
    MsgInformation('This feature will be applied when you restart the aplication');
end;

procedure TFrmSettings.ColorBoxNCGetColors(Sender: TCustomColorBox; Items: TStrings);
Var
  Item: TIdentMapEntry;
begin
  Items.Clear;
  for Item in WebNamedColors do
    Items.AddObject(Item.Name, TObject(Item.Value));
end;

procedure TFrmSettings.ComboBoxFontChange(Sender: TObject);
begin
  LoadCurrentThemeFont(Self, ComboBoxFont.Text, StrToInt(EditFontSize.Text));
end;

procedure TFrmSettings.ComboBoxLanguageThemesChange(Sender: TObject);
begin
  case TSourceLanguages(ComboBoxLanguageThemes.Items.Objects[ComboBoxLanguageThemes.ItemIndex]) of

    Lng_Delphi:
      begin
        SynEditCode.Highlighter := SynPasSyn1;
        SynEditCode.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Templates\Template_Delphi.pas');
        if ComboBoxTheme.Text <> '' then
          LoadCurrentTheme(Self, ComboBoxTheme.Text);
      end;

    Lng_FPC:
      begin
        SynEditCode.Highlighter := SynPasSyn1;
        SynEditCode.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Templates\Template_FPC.pas');
        if ComboBoxTheme.Text <> '' then
          LoadCurrentTheme(Self, ComboBoxTheme.Text);
      end;

    Lng_Oxygen:
      begin
        SynEditCode.Highlighter := SynPasSyn1;
        SynEditCode.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Templates\Template_Oxygen.pas');
        if ComboBoxTheme.Text <> '' then
          LoadCurrentTheme(Self, ComboBoxTheme.Text);
      end;

    Lng_BorlandCpp:
      begin
        SynEditCode.Highlighter := SynCppSyn1;
        SynEditCode.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Templates\Template_BorlandCpp.cpp');
        if ComboBoxTheme.Text <> '' then
          LoadCurrentTheme(Self, ComboBoxTheme.Text);
      end;

    Lng_VSCpp:
      begin
        SynEditCode.Highlighter := SynCppSyn1;
        SynEditCode.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Templates\Template_MicrosoftCpp.cpp');
        if ComboBoxTheme.Text <> '' then
          LoadCurrentTheme(Self, ComboBoxTheme.Text);
      end;

    Lng_CSharp:
      begin
        SynEditCode.Highlighter := SynCSSyn1;
        SynEditCode.Lines.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Templates\Template_Csharp.cs');
        if ComboBoxTheme.Text <> '' then
          LoadCurrentTheme(Self, ComboBoxTheme.Text);
      end;
  end;

end;

procedure TFrmSettings.ComboBoxThemeChange(Sender: TObject);
begin
  LoadCurrentTheme(Self, TComboBox(Sender).Text);
end;

procedure TFrmSettings.ComboBoxVCLStyleChange(Sender: TObject);
begin
  // LoadVCLStyle(ComboBoxVCLStyle.Text);
  DrawSeletedVCLStyle;
end;

procedure TFrmSettings.DrawSeletedVCLStyle;
var
  StyleName: string;
  LStyle: TCustomStyleServices;
begin
  StyleName := ComboBoxVCLStyle.Text;
  if (StyleName <> '') and (not SameText(StyleName, 'Windows')) then
  begin
    TStyleManager.StyleNames; // call DiscoverStyleResources
    LStyle := TStyleManager.Style[StyleName];
    FPreview.Caption := StyleName;
    FPreview.Style := LStyle;
    TVclStylesPreviewClass(FPreview).Paint;
  end;
end;

procedure TFrmSettings.FormCreate(Sender: TObject);
var
  LIndex: TSourceLanguages;
begin
  FPreview := TVclStylesPreview.Create(Self);
  FPreview.Parent := PanelPreview;
  FPreview.BoundsRect := PanelPreview.ClientRect;

  for LIndex := Low(TSourceLanguages) to High(TSourceLanguages) do
  begin
    ComboBoxLanguageSel.Items.AddObject(ListSourceLanguages[LIndex], TObject(LIndex));
    ComboBoxLanguageThemes.Items.AddObject(ListSourceLanguages[LIndex], TObject(LIndex));
    ComboBoxLanguageTemplate.Items.AddObject(ListSourceLanguages[LIndex], TObject(LIndex));
  end;

  FSettings := TSettings.Create;
  DummyFrm := Self;
  LoadFixedWidthFonts;
  LoadStyles;
  LoadThemes;
  LoadCodeGenData;
  LoadFormatters;

  ComboBoxLanguageThemes.ItemIndex := 0;
  ComboBoxLanguageThemesChange(nil);
end;

procedure TFrmSettings.FormDestroy(Sender: TObject);
begin
  FPreview.Free;
  FSettings.Free;
end;

procedure TFrmSettings.LoadSettings;
var
  i: Integer;
begin
  ReadSettings(FSettings);

  for i := 0 to ComboBoxLanguageSel.Items.Count - 1 do
    if Integer(ComboBoxLanguageSel.Items.Objects[i]) = FSettings.DefaultLanguage then
    begin
      ComboBoxLanguageSel.ItemIndex := i;
      break;
    end;

  ComboBoxTheme.ItemIndex := ComboBoxTheme.Items.IndexOf(FSettings.CurrentTheme);
  ComboBoxVCLStyle.ItemIndex := ComboBoxVCLStyle.Items.IndexOf(FSettings.VCLStyle);
  DrawSeletedVCLStyle;

  ComboBoxFont.ItemIndex := ComboBoxFont.Items.IndexOf(FSettings.FontName);
  CbFormatter.ItemIndex := CbFormatter.Items.IndexOf(FSettings.Formatter);
  UpDown1.Position := FSettings.FontSize;

  for i := 0 to DelphiMaxTypesClassCodeGen - 1 do
    if FSettings.DelphiWmiClassCodeGenMode = Integer(CbDelphiCodeWmiClass.Items.Objects[i]) then
    begin
      CbDelphiCodeWmiClass.ItemIndex := i;
      break;
    end;
  // CbDelphiCodewmiClass.ItemIndex  := FSettings.DelphiWmiClassCodeGenMode;

  for i := 0 to DelphiMaxTypesEventsCodeGen - 1 do
    if FSettings.DelphiWmiEventCodeGenMode = Integer(CbDelphiCodeWmiEvent.Items.Objects[i]) then
    begin
      CbDelphiCodeWmiEvent.ItemIndex := i;
      break;
    end;

  for i := 0 to DelphiMaxTypesMethodCodeGen - 1 do
    if FSettings.DelphiWmiMethodCodeGenMode = Integer(CbDelphiCodeWmiMethod.Items.Objects[i]) then
    begin
      CbDelphiCodeWmiMethod.ItemIndex := i;
      break;
    end;

  LabelDescr.Caption := ListWmiCodeDescr
    [TWmiCode(Integer(CbDelphiCodeWmiClass.Items.Objects[CbDelphiCodeWmiClass.ItemIndex]))];
  LabelDescrEvent.Caption := ListWmiCodeDescr
    [TWmiCode(Integer(CbDelphiCodeWmiEvent.Items.Objects[CbDelphiCodeWmiEvent.ItemIndex]))];
  LabelDescrMethod.Caption := ListWmiCodeDescr
    [TWmiCode(Integer(CbDelphiCodeWmiMethod.Items.Objects[CbDelphiCodeWmiMethod.ItemIndex]))];

  CheckBoxDelphiHelperFunc.Checked := FSettings.FDelphiWmiClassHelperFuncts;
  CheckBoxFPCHelperFunc.Checked := FSettings.FDelphiWmiClassHelperFuncts;
  CheckBoxShowImplMethods.Checked := FSettings.FShowImplementedMethods;
  EditOutputFolder.Text := FSettings.OutputFolder;

  CheckBoxUpdates.Checked := FSettings.CheckForUpdates;
  CheckBoxDisableVClStylesNC.Checked := FSettings.DisableVClStylesNC;

  CheckBoxOnlineMSDN.Checked := FSettings.UseOnlineMSDNinTree;

  EditAStyle.Text := FSettings.AStyleCmdLine;
  EditMicrosoftCppSwitch.Text := FSettings.MicrosoftCppCmdLine;
  EditCSharpSwitch.Text := FSettings.CSharpCmdLine;

  // CheckBoxFormCustom.Checked         := FSettings.ActivateCustomForm;
  // CheckBoxNC.Checked                 := FSettings.CustomFormNC;
  // CheckBoxBack.Checked               := FSettings.CustomFormBack;
  //
  // if FSettings.UseColorNC then
  // RadioButtonNCColor.Checked         := True
  // else
  // RadioButtonNCImage.Checked        := True;
  //
  // if FSettings.UseColorBack then
  // RadioButtonBackColor.Checked      := True
  // else
  // RadioButtonBackImage.Checked      := True;
  //
  // ColorBoxNC.Selected                := FSettings.ColorNC;
  // ColorBoxBack.Selected              := FSettings.ColorBack;
  // EditNCImage.Text                   := FSettings.ImageNC;
  // EditBackImage.Text                 := FSettings.ImageBack;

  SetStateControls(GroupBoxNonClient, CheckBoxFormCustom.Checked);
  SetStateControls(GroupBoxBackgroud, CheckBoxFormCustom.Checked);
  LoadCurrentThemeFont(Self, ComboBoxFont.Text, StrToInt(EditFontSize.Text));
  LoadCurrentTheme(Self, ComboBoxTheme.Text);
end;

procedure TFrmSettings.LoadStyles;
var
  Style: string;
begin
  try
    ComboBoxVCLStyle.Items.BeginUpdate;
    ComboBoxVCLStyle.Items.Clear;
    for Style in TStyleManager.StyleNames do
      ComboBoxVCLStyle.Items.Add(Style);
  finally
    ComboBoxVCLStyle.Items.EndUpdate;
  end;
end;

procedure RegisterVCLStyles;
var
  Style: string;
begin
  for Style in TDirectory.GetFiles(ExtractFilePath(ParamStr(0)) + '\Styles', '*.vsf') do
    RegisterVCLStyle(Style);
end;

function GetThemeNameFromFile(const FileName: string): string;
begin
  Result := Copy(ExtractFileName(FileName), 1, Pos('.theme', ExtractFileName(FileName)) - 1);
end;

procedure TFrmSettings.LoadThemes;
var
  Theme: string;
begin
  try
    ComboBoxTheme.Items.BeginUpdate;
    ComboBoxTheme.Items.Clear;
    for Theme in TDirectory.GetFiles(ExtractFilePath(ParamStr(0)) + '\Themes', '*.theme.xml') do
      ComboBoxTheme.Items.Add(GetThemeNameFromFile(Theme));
  finally
    ComboBoxTheme.Items.EndUpdate;
  end;
end;

procedure TFrmSettings.SetStateControls(Container: TWinControl; Value: Boolean);
var
  i: Integer;
begin
  for i := 0 to Container.ControlCount - 1 do
    Container.Controls[i].Enabled := Value;
end;

initialization

RegisterVCLStyles;

end.
