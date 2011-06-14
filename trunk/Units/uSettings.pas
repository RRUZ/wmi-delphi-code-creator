unit uSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, uDelphiIDEHighlight, SynEdit;

type
  TSettings = class
  private
    FCurrentTheme: string;
    FFontSize: Word;
    FFontName: string;
  published
    property CurrentTheme : string Read FCurrentTheme Write FCurrentTheme;
    property FontName     : string Read FFontName Write FFontName;
    property FontSize     : Word Read FFontSize Write FFontSize;
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
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxThemeChange(Sender: TObject);
    procedure ButtonGetMoreClick(Sender: TObject);
    procedure ComboBoxFontChange(Sender: TObject);
  private
    FSettings: TSettings;
    FCurrentTheme:  TIDETheme;
    FForm: TForm;
    procedure LoadFixedWidthFonts;
    procedure LoadThemes;
  public
    property Settings: TSettings Read FSettings Write FSettings;
    property Form: TForm Read FForm Write FForm;
    procedure LoadSettings;
  end;

  procedure LoadCurrentTheme(Form: TForm;const ThemeName:string);
  procedure LoadCurrentThemeFont(Form: TForm;const FontName:string;FontSize:Word);
  procedure ReadSettings(var Settings: TSettings);

implementation

{$R *.dfm}

uses
  ShellAPI,
  GraphUtil,
  uDelphiVersions,
  SynHighlighterPas,
  SynEditHighlighter,
  StrUtils,
  IOUtils,
  IniFiles;

const
  sThemesExt  ='.theme.xml';

Var
  DummyFrm : TFrmSettings;

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

procedure ReadSettings(var Settings: TSettings);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Settings.ini');
  try
    Settings.CurrentTheme := iniFile.ReadString('Global', 'CurrentTheme', '');
    Settings.FontName     := iniFile.ReadString('Global', 'FontName', 'Consolas');
    Settings.FontSize     := iniFile.ReadInteger('Global', 'FontSize', 10);
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
  finally
    iniFile.Free;
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
  ShellExecute(self.WindowHandle,'open','http://theroadtodelphi.wordpress.com/delphi-ide-theme-editor/',nil,nil, SW_SHOWNORMAL);
end;

procedure TFrmSettings.ButtonApplyClick(Sender: TObject);
begin
  if Application.MessageBox(PChar(Format('Do you want save the changes ?%s', [''])), 'Confirmation', MB_YESNO + MB_ICONQUESTION) = idYes then
  begin
    FSettings.CurrentTheme := ComboBoxTheme.Text;
    FSettings.FontName     := ComboBoxFont.Text;
    FSettings.FontSize     := StrToInt(EditFontSize.Text);
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
     RefreshSynPasHighlighter(FCurrentTheme,TSynEdit(Form.Components[i]));
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


procedure TFrmSettings.ComboBoxFontChange(Sender: TObject);
begin
  LoadCurrentThemeFont(FForm,ComboBoxFont.Text,StrToInt(EditFontSize.Text));
end;

procedure TFrmSettings.ComboBoxThemeChange(Sender: TObject);
begin
  LoadCurrentTheme(FForm,TComboBox(Sender).Text);
end;


procedure TFrmSettings.FormCreate(Sender: TObject);
begin
  FSettings:=TSettings.Create;
  DummyFrm:=Self;
  LoadFixedWidthFonts;
  LoadThemes;
end;

procedure TFrmSettings.FormDestroy(Sender: TObject);
begin
  FSettings.Free;
end;

procedure TFrmSettings.LoadSettings;
begin
  ReadSettings(FSettings);
  ComboBoxTheme.ItemIndex := ComboBoxTheme.Items.IndexOf(FSettings.CurrentTheme);
  ComboBoxFont.ItemIndex  := ComboBoxFont.Items.IndexOf(FSettings.FontName);
  UpDown1.Position        := FSettings.FontSize;
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

end.
