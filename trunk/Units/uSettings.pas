{**************************************************************************************************}
{                                                                                                  }
{ Unit uSettings                                                                                   }
{ Unit for the WMI Delphi Code Creator                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uSettings.pas.                                                              }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, uDelphiIDEHighlight, SynEdit, uComboBox;

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
    function GetOutputFolder: string;
    function GetBackGroundColor: TColor;
    function GetForeGroundColor: TColor;
  public
    property CurrentTheme : string Read FCurrentTheme Write FCurrentTheme;
    property FontName     : string Read FFontName Write FFontName;
    property FontSize     : Word Read FFontSize Write FFontSize;
    property DelphiWmiClassCodeGenMode : Integer Read FDelphiWmiClassCodeGenMode Write FDelphiWmiClassCodeGenMode;
    property DelphiWmiClassHelperFuncts: Boolean Read FDelphiWmiClassHelperFuncts Write FDelphiWmiClassHelperFuncts;
    property DelphiWmiEventCodeGenMode : Integer Read FDelphiWmiEventCodeGenMode Write FDelphiWmiEventCodeGenMode;
    property DelphiWmiMethodCodeGenMode : Integer Read FDelphiWmiMethodCodeGenMode Write FDelphiWmiMethodCodeGenMode;
    property ShowImplementedMethods : Boolean read FShowImplementedMethods write FShowImplementedMethods;
    property OutputFolder : string read GetOutputFolder write FOutputFolder;
    property BackGroundColor : TColor read GetBackGroundColor;
    property ForeGroundColor : TColor read GetForeGroundColor;
    property LastWmiNameSpace : string read FLastWmiNameSpace Write FLastWmiNameSpace;
    property LastWmiClass : string read FLastWmiClass Write FLastWmiClass;
    property VCLStyle : string read FVCLStyle Write FVCLStyle;
  end;


  TFrmSettings = class(TForm)
    ButtonApply: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ButtonCancel: TButton;
    Label1: TLabel;
    ComboBoxTheme: TComboBox;
    EditFontSize: TEdit;
    UpDown1: TUpDown;
    ComboBoxFont: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    ButtonGetMore: TButton;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    CbDelphiCodeWmiClass: TComboBox;
    LabelDescr: TLabel;
    CheckBoxHelper: TCheckBox;
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
  private
    FSettings: TSettings;
    //FCurrentTheme:  TIDETheme;
    FForm: TForm;
    procedure LoadFixedWidthFonts;
    procedure LoadThemes;
    procedure LoadStyles;
    procedure LoadCodeGenData;

  public
    property Settings: TSettings Read FSettings Write FSettings;
    property Form: TForm Read FForm Write FForm;
    procedure LoadSettings;
  end;

  procedure LoadCurrentTheme(Form: TForm;const ThemeName:string);
  procedure LoadCurrentThemeFont(Form: TForm;const FontName:string;FontSize:Word);
  procedure LoadVCLStyle(Const StyleName:String);
  procedure ReadSettings(var Settings: TSettings);
  procedure WriteSettings(const Settings: TSettings);

implementation

{$R *.dfm}

uses
  ShellAPI,
  GraphUtil,
  FileCtrl,
  uDelphiVersions,
  SynHighlighterPas,
  SynHighlighterCpp,
  SynEditHighlighter,
  StrUtils,
  IOUtils,
  IniFiles,
  uWmiDelphiCode,
  uWmiGenCode,
  Vcl.Styles,
  Vcl.Themes,
  uMisc;

const
  sThemesExt  ='.theme.xml';

Var
  DummyFrm : TFrmSettings;

procedure RegisterVCLStyle(const StyleFileName: string);
begin
   if TStyleManager.IsValidStyle(StyleFileName) then
     TStyleManager.LoadFromFile(StyleFileName)
   else
     MsgWarning('the Style is not valid');
end;

procedure LoadVCLStyle(Const StyleName:String);
begin
  if StyleName<>'' then
   TStyleManager.SetStyle(StyleName)
  else
   TStyleManager.SetStyle(TStyleManager.SystemStyle.Name);
       {
  if CompareText(StyleName,'Windows')=0 then
   TStyleManager.SetStyle(TStyleManager.SystemStyle.Name)
  else
   RegisterAndSetVCLStyle( IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'Styles\'+StyleName+'.vsf');
       }
end;

function GetCurrentTheme(const ThemeName:string):TIDETheme;
var
 FileName : string;
begin
  FileName:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))+'\Themes')+ThemeName+sThemesExt;
  LoadThemeFromXMLFile(Result, FileName);
end;


{ TSettings }

function TSettings.GetBackGroundColor: TColor;
var
  Element      : TIDEHighlightElements;
  IDETheme : TIDETheme;
begin
  Element := TIDEHighlightElements.PlainText;
  IDETheme:=GetCurrentTheme(CurrentTheme);
  Result := StringToColor(IDETheme[Element].BackgroundColorNew);
end;

function TSettings.GetForeGroundColor: TColor;
var
  Element      : TIDEHighlightElements;
  IDETheme : TIDETheme;
begin
  Element := TIDEHighlightElements.PlainText;
  IDETheme:=GetCurrentTheme(CurrentTheme);
  Result := StringToColor(IDETheme[Element].ForegroundColorNew);
end;


function TSettings.GetOutputFolder: string;
begin
  if (FOutputFolder='') or not SysUtils.DirectoryExists(FOutputFolder) then
    Result:=GetTempDirectory
  else
    Result := FOutputFolder;
end;


function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: integer; Data: Pointer): integer; stdcall;
begin
  //  if ((FontType and TrueType_FontType) <> 0) and  ((LogFont.lfPitchAndFamily and VARIABLE_PITCH) = 0) then
  if ((LogFont.lfPitchAndFamily and FIXED_PITCH) <> 0) then
    if not StartsText('@', LogFont.lfFaceName) and
      (DummyFrm.ComboBoxFont.Items.IndexOf(LogFont.lfFaceName) < 0) then
      DummyFrm.ComboBoxFont.Items.Add(LogFont.lfFaceName);

  Result := 1;
end;


procedure SetSynAttr(FCurrentTheme:TIDETheme;Element: TIDEHighlightElements; SynAttr: TSynHighlighterAttributes; DelphiVersion: TDelphiVersions);
begin
  SynAttr.Background := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew),DelphiVersion);
  SynAttr.Foreground := GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),DelphiVersion);
  SynAttr.Style      := [];
  if FCurrentTheme[Element].Bold then
    SynAttr.Style := SynAttr.Style + [fsBold];
  if FCurrentTheme[Element].Italic then
    SynAttr.Style := SynAttr.Style + [fsItalic];
  if FCurrentTheme[Element].Underline then
    SynAttr.Style := SynAttr.Style + [fsUnderline];
end;

procedure RefreshSynEdit(FCurrentTheme:TIDETheme;SynEdit: TSynEdit);
var
  Element   : TIDEHighlightElements;
  DelphiVer : TDelphiVersions;
begin
    DelphiVer := DelphiXE;

    Element := TIDEHighlightElements.RightMargin;
    SynEdit.RightEdgeColor :=
      GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),DelphiVer);

    Element := TIDEHighlightElements.MarkedBlock;
    SynEdit.SelectedColor.Foreground :=
      GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),DelphiVer);
    SynEdit.SelectedColor.Background :=
      GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew),DelphiVer);

    Element := TIDEHighlightElements.LineNumber;
    SynEdit.Gutter.Color := StringToColor(FCurrentTheme[Element].BackgroundColorNew);
    SynEdit.Gutter.Font.Color :=
      GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].ForegroundColorNew),DelphiVer);

    Element := TIDEHighlightElements.LineHighlight;
    SynEdit.ActiveLineColor :=
      GetDelphiVersionMappedColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew),DelphiVer);

    Element := TIDEHighlightElements.PlainText;
    SynEdit.Gutter.BorderColor := GetHighLightColor(StringToColor(FCurrentTheme[Element].BackgroundColorNew));
end;

procedure RefreshSynPasHighlighter(FCurrentTheme:TIDETheme;SynEdit: TSynEdit);
var
  DelphiVer : TDelphiVersions;
begin
    if not (SynEdit.Highlighter is TSynPasSyn) then exit;

    DelphiVer := DelphiXE;

    RefreshSynEdit(FCurrentTheme, SynEdit);

    with TSynPasSyn(SynEdit.Highlighter) do
    begin
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Assembler, AsmAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Character, CharAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Comment, CommentAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, DirectiveAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Float, FloatAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Hex, HexAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, IdentifierAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, KeyAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, NumberAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Whitespace, SpaceAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.String, StringAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, SymbolAttri,DelphiVer);
    end;
end;

procedure RefreshSynCppHighlighter(FCurrentTheme:TIDETheme;SynEdit: TSynEdit);
var
  DelphiVer : TDelphiVersions;
begin
    if not (SynEdit.Highlighter is TSynCppSyn) then exit;
    DelphiVer := DelphiXE;

    RefreshSynEdit(FCurrentTheme, SynEdit);

    with TSynCppSyn(SynEdit.Highlighter) do
    begin
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Assembler, AsmAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Character, CharAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Comment, CommentAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, DirecAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Float, FloatAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Hex, HexAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Identifier, IdentifierAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Preprocessor, InvalidAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.ReservedWord, KeyAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, NumberAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Number, OctalAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Whitespace, SpaceAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.String, StringAttri,DelphiVer);
      SetSynAttr(FCurrentTheme, TIDEHighlightElements.Symbol, SymbolAttri,DelphiVer);
    end;
end;


procedure ReadSettings(var Settings: TSettings);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');
  try
    Settings.CurrentTheme := iniFile.ReadString('Global', 'CurrentTheme', 'deep-blue');
    Settings.FontName     := iniFile.ReadString('Global', 'FontName', 'Consolas');
    Settings.FontSize     := iniFile.ReadInteger('Global', 'FontSize', 10);
    Settings.DelphiWmiClassCodeGenMode     := iniFile.ReadInteger('Global', 'DelphiWmiClassCodeGenMode', integer(WmiCode_LateBinding));
    Settings.DelphiWmiClassHelperFuncts    := iniFile.ReadBool('Global', 'DelphiWmiClassHelperFuncts', False);
    Settings.ShowImplementedMethods        := iniFile.ReadBool('Global', 'ShowImplementedMethods', True);
    Settings.DelphiWmiEventCodeGenMode     := iniFile.ReadInteger('Global', 'DelphiWmiEventCodeGenMode', integer(WmiCode_Scripting));
    Settings.OutputFolder                  := iniFile.ReadString('Global', 'OutputFolder', GetTempDirectory);
    Settings.DelphiWmiMethodCodeGenMode    := iniFile.ReadInteger('Global', 'DelphiWmiMethodCodeGenMode', integer(WmiCode_Scripting));
    Settings.LastWmiNameSpace              := iniFile.ReadString('Global', 'LastWmiNameSpace', 'root\CIMV2');
    Settings.LastWmiClass                  := iniFile.ReadString('Global', 'LastWmiClass', 'Win32_OperatingSystem');
    Settings.VCLStyle                      := iniFile.ReadString('Global', 'VCLStyle', 'Windows');
  finally
    iniFile.Free;
  end;
end;

procedure WriteSettings(const Settings: TSettings);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');
  try
    iniFile.WriteString('Global', 'CurrentTheme', Settings.CurrentTheme);
    iniFile.WriteString('Global', 'FontName', Settings.FontName);
    iniFile.WriteInteger('Global', 'FontSize', Settings.FontSize);
    iniFile.WriteInteger('Global', 'DelphiWmiClassCodeGenMode', Settings.DelphiWmiClassCodeGenMode);
    iniFile.WriteBool('Global', 'DelphiWmiClassHelperFuncts', Settings.DelphiWmiClassHelperFuncts);
    iniFile.WriteBool('Global', 'ShowImplementedMethods', Settings.ShowImplementedMethods);
    iniFile.WriteInteger('Global', 'DelphiWmiEventCodeGenMode', Settings.DelphiWmiEventCodeGenMode);
    iniFile.WriteString('Global', 'OutputFolder', Settings.OutputFolder);
    iniFile.WriteInteger('Global', 'DelphiWmiMethodCodeGenMode', Settings.DelphiWmiMethodCodeGenMode);
    iniFile.WriteString('Global', 'LastWmiNameSpace', Settings.LastWmiNameSpace);
    iniFile.WriteString('Global', 'LastWmiClass', Settings.LastWmiClass);
    iniFile.WriteString('Global', 'VCLStyle', Settings.VCLStyle);
  finally
    iniFile.Free;
  end;
end;

procedure TFrmSettings.LoadCodeGenData;
var
  i : integer;
begin
   CbDelphiCodewmiClass.Items.Clear;
   CbDelphiCodewmiClass.Items.BeginUpdate;
   try
     for i := 0 to DelphiMaxTypesClassCodeGen-1 do
       //CbDelphiCodewmiClass.Items.Add(ListWmiCodeName[DelphiWmiClassCodeSupported[i]])
       CbDelphiCodewmiClass.Items.AddObject(ListWmiCodeName[DelphiWmiClassCodeSupported[i]],TObject(DelphiWmiClassCodeSupported[i]));
   finally
      CbDelphiCodewmiClass.Items.EndUpdate;
   end;

   CbDelphiCodeWmiEvent.Items.Clear;
   CbDelphiCodeWmiEvent.Items.BeginUpdate;
   try
     for i := 0 to DelphiMaxTypesEventsCodeGen-1 do
       CbDelphiCodeWmiEvent.Items.AddObject(ListWmiCodeName[DelphiWmiEventCodeSupported[i]],TObject(DelphiWmiEventCodeSupported[i]));
   finally
      CbDelphiCodeWmiEvent.Items.EndUpdate;
   end;

   CbDelphiCodeWmiMethod.Items.Clear;
   CbDelphiCodeWmiMethod.Items.BeginUpdate;
   try
     for i := 0 to DelphiMaxTypesMethodCodeGen-1 do
       CbDelphiCodeWmiMethod.Items.AddObject(ListWmiCodeName[DelphiWmiMethodCodeSupported[i]],TObject(DelphiWmiMethodCodeSupported[i]));
   finally
      CbDelphiCodeWmiMethod.Items.EndUpdate;
   end;
end;

procedure TFrmSettings.LoadFixedWidthFonts;
var
  sDC:     integer;
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



procedure TFrmSettings.ButtonGetMoreClick(Sender: TObject);
begin
  ShellExecute(Self.WindowHandle,'open','http://theroadtodelphi.wordpress.com/delphi-ide-theme-editor/',nil,nil, SW_SHOWNORMAL);
end;

procedure TFrmSettings.BtnDeleteCacheClick(Sender: TObject);
Var
 FileName  : string;
begin
  for FileName in IOUtils.TDirectory.GetFiles(ExtractFilePath(ParamStr(0))+'cache','*.wmic') do
    DeleteFile(FileName);

  MsgInformation('The cache was deleted');
end;

procedure TFrmSettings.BtnSelFolderThemesClick(Sender: TObject);
var
  Directory: string;
begin
  Directory:='';
  if SysUtils.DirectoryExists(EditOutputFolder.Text) then
   Directory := EditOutputFolder.Text;

  //sdNewFolder, sdShowEdit, sdShowShares, sdNewUI, sdShowFiles,    sdValidateDir
  if SelectDirectory('Select directory',Directory,Directory,[sdNewFolder, sdNewUI, sdShowEdit, sdValidateDir, sdShowShares], nil) then
   EditOutputFolder.Text := Directory;
end;

procedure TFrmSettings.ButtonApplyClick(Sender: TObject);
begin
  //if Application.MessageBox(PChar(Format('Do you want save the changes ?%s', [''])), 'Confirmation', MB_YESNO + MB_ICONQUESTION) = idYes then
  if MessageDlg('Do you want save the changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FSettings.CurrentTheme := ComboBoxTheme.Text;
    FSettings.FontName     := ComboBoxFont.Text;
    FSettings.FontSize     := StrToInt(EditFontSize.Text);
    FSettings.DelphiWmiClassCodeGenMode     := Integer(CbDelphiCodewmiClass.Items.Objects[CbDelphiCodewmiClass.ItemIndex]);//CbDelphiCodewmiClass.ItemIndex;
    FSettings.DelphiWmiClassHelperFuncts    := CheckBoxHelper.Checked;
    FSettings.ShowImplementedMethods        := CheckBoxShowImplMethods.Checked;
    FSettings.DelphiWmiEventCodeGenMode     := Integer(CbDelphiCodeWmiEvent.Items.Objects[CbDelphiCodeWmiEvent.ItemIndex]);
    FSettings.DelphiWmiMethodCodeGenMode    := Integer(CbDelphiCodeWmiMethod.Items.Objects[CbDelphiCodeWmiMethod.ItemIndex]);
    FSettings.OutputFolder                  := EditOutputFolder.Text;
    FSettings.VCLStyle                      := ComboBoxVCLStyle.Text;
    WriteSettings(FSettings);
    Close();
  end;
end;

procedure TFrmSettings.ButtonCancelClick(Sender: TObject);
begin
  Close();
end;

procedure LoadCurrentTheme(Form: TForm;const ThemeName:string);
var
 FileName : string;
 i        : Integer;
 FCurrentTheme : TIDETheme;
begin
  FileName:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))+'\Themes')+ThemeName+sThemesExt;
  LoadThemeFromXMLFile(FCurrentTheme, FileName);
  for i := 0 to Form.ComponentCount-1 do
   if Form.Components[i] is TSynEdit then
   begin
     RefreshSynPasHighlighter(FCurrentTheme,TSynEdit(Form.Components[i]));
     RefreshSynCppHighlighter(FCurrentTheme,TSynEdit(Form.Components[i]));
   end;
end;

procedure LoadCurrentThemeFont(Form: TForm;const FontName:string;FontSize:Word);
var
 i        : Integer;
begin
  for i := 0 to Form.ComponentCount-1 do
   if Form.Components[i] is TSynEdit then
   begin
    TSynEdit(Form.Components[i]).Font.Name:=FontName;
    TSynEdit(Form.Components[i]).Font.Size:=FontSize;
   end;
end;

procedure TFrmSettings.CbDelphiCodeWmiClassChange(Sender: TObject);
begin
   LabelDescr.Caption:=ListWmiCodeDescr[TWmiCode(Integer(CbDelphiCodewmiClass.Items.Objects[CbDelphiCodewmiClass.ItemIndex]))];//ListWmiCodeDescr[TWmiCode(CbDelphiCodewmiClass.ItemIndex)];
end;

procedure TFrmSettings.CbDelphiCodeWmiEventChange(Sender: TObject);
begin
   LabelDescrEvent.Caption:=ListWmiCodeDescr[TWmiCode(Integer(CbDelphiCodeWmiEvent.Items.Objects[CbDelphiCodeWmiEvent.ItemIndex]))];
end;

procedure TFrmSettings.CbDelphiCodeWmiMethodChange(Sender: TObject);
begin
   LabelDescrMethod.Caption:=ListWmiCodeDescr[TWmiCode(Integer(CbDelphiCodeWmiMethod.Items.Objects[CbDelphiCodeWmiMethod.ItemIndex]))];
end;

procedure TFrmSettings.ComboBoxFontChange(Sender: TObject);
begin
  LoadCurrentThemeFont(FForm,ComboBoxFont.Text,StrToInt(EditFontSize.Text));
end;

procedure TFrmSettings.ComboBoxThemeChange(Sender: TObject);
begin
  LoadCurrentTheme(FForm,TComboBox(Sender).Text);
end;


procedure TFrmSettings.ComboBoxVCLStyleChange(Sender: TObject);
begin
  LoadVCLStyle(ComboBoxVCLStyle.Text);
end;

procedure TFrmSettings.FormCreate(Sender: TObject);
begin
  FSettings:=TSettings.Create;
  DummyFrm:=Self;
  LoadFixedWidthFonts;
  LoadStyles;
  LoadThemes;
  LoadCodeGenData;
end;

procedure TFrmSettings.FormDestroy(Sender: TObject);
begin
  FSettings.Free;
end;

procedure TFrmSettings.LoadSettings;
var
  i  : integer;
begin
  ReadSettings(FSettings);
  ComboBoxTheme.ItemIndex    := ComboBoxTheme.Items.IndexOf(FSettings.CurrentTheme);
  ComboBoxVCLStyle.ItemIndex := ComboBoxVCLStyle.Items.IndexOf(FSettings.VCLStyle);
  ComboBoxFont.ItemIndex  := ComboBoxFont.Items.IndexOf(FSettings.FontName);
  UpDown1.Position        := FSettings.FontSize;

  for i := 0 to DelphiMaxTypesClassCodeGen-1 do
    if FSettings.DelphiWmiClassCodeGenMode=Integer(CbDelphiCodewmiClass.Items.Objects[i]) then
    begin
      CbDelphiCodewmiClass.ItemIndex  := i;
      Break;
    end;
    //CbDelphiCodewmiClass.ItemIndex  := FSettings.DelphiWmiClassCodeGenMode;

  for i := 0 to DelphiMaxTypesEventsCodeGen-1 do
    if FSettings.DelphiWmiEventCodeGenMode=Integer(CbDelphiCodeWmiEvent.Items.Objects[i]) then
    begin
      CbDelphiCodeWmiEvent.ItemIndex  := i;
      Break;
    end;

  for i := 0 to DelphiMaxTypesMethodCodeGen-1 do
    if FSettings.DelphiWmiMethodCodeGenMode=Integer(CbDelphiCodeWmiMethod.Items.Objects[i]) then
    begin
      CbDelphiCodeWmiMethod.ItemIndex  := i;
      Break;
    end;

  LabelDescr.Caption:=ListWmiCodeDescr[TWmiCode(Integer(CbDelphiCodewmiClass.Items.Objects[CbDelphiCodewmiClass.ItemIndex]))];
  LabelDescrEvent.Caption:=ListWmiCodeDescr[TWmiCode(Integer(CbDelphiCodeWmiEvent.Items.Objects[CbDelphiCodeWmiEvent.ItemIndex]))];
  LabelDescrMethod.Caption:=ListWmiCodeDescr[TWmiCode(Integer(CbDelphiCodeWmiMethod.Items.Objects[CbDelphiCodeWmiMethod.ItemIndex]))];

  CheckBoxHelper.Checked    := FSettings.FDelphiWmiClassHelperFuncts;
  CheckBoxShowImplMethods.Checked    := FSettings.FShowImplementedMethods;
  EditOutputFolder.Text              := FSettings.OutputFolder;
end;


procedure TFrmSettings.LoadStyles;
var
  Style   : string;
begin
  try
    ComboBoxVCLStyle.Items.BeginUpdate;
    ComboBoxVCLStyle.Items.Clear;
    //ComboBoxVCLStyle.Items.Add('Windows');
    for Style in TStyleManager.StyleNames do
      ComboBoxVCLStyle.Items.Add(Style);
  finally
    ComboBoxVCLStyle.Items.EndUpdate;
  end;
end;

procedure RegisterVCLStyles;
var
  Style   : string;
begin
  for Style in TDirectory.GetFiles(ExtractFilePath(ParamStr(0))+'\Styles', '*.vsf') do
    RegisterVCLStyle(Style);
end;

function GetThemeNameFromFile(const FileName:string): string;
begin
  Result:=Copy(ExtractFileName(FileName), 1, Pos('.theme', ExtractFileName(FileName)) - 1);
end;

procedure TFrmSettings.LoadThemes;
var
  Theme   : string;
begin
  try
    ComboBoxTheme.Items.BeginUpdate;
    ComboBoxTheme.Items.Clear;
    for Theme in TDirectory.GetFiles(ExtractFilePath(ParamStr(0))+'\Themes', '*.theme.xml') do
      ComboBoxTheme.Items.Add(GetThemeNameFromFile(Theme));
  finally
    ComboBoxTheme.Items.EndUpdate;
  end;
end;

initialization
 RegisterVCLStyles;


end.
