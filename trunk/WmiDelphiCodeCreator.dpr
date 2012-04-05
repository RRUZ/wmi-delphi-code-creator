program WmiDelphiCodeCreator;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  uWmiTree in 'Units\uWmiTree.pas' {FrmWMITree},
  uDelphiSyntax in 'Units\uDelphiSyntax.pas',
  uWmi_About in 'Units\uWmi_About.pas' {FrmAbout},
  uWmiDelphiCode in 'Units\uWmiDelphiCode.pas',
  uDelphiIDE in 'Units\uDelphiIDE.pas',
  uDelphiPrismHelper in 'Units\uDelphiPrismHelper.pas',
  uDelphiPrismIDE in 'Units\uDelphiPrismIDE.pas',
  uLazarusIDE in 'Units\uLazarusIDE.pas',
  uSelectCompilerVersion in 'Units\uSelectCompilerVersion.pas' {FrmSelCompilerVer},
  uWmi_ViewPropsValues in 'Units\uWmi_ViewPropsValues.pas' {FrmWmiVwProps},
  uWmiDatabase in 'Units\uWmiDatabase.pas' {FrmWmiDatabase},
  uSettings in 'Units\uSettings.pas' {FrmSettings},
  uDelphiIDEHighlight in 'Units\uDelphiIDEHighlight.pas',
  uDelphiVersions in 'Units\uDelphiVersions.pas',
  uWmiGenCode in 'Units\uWmiGenCode.pas',
  uWmiOxygenCode in 'Units\uWmiOxygenCode.pas',
  uWmiFPCCode in 'Units\uWmiFPCCode.pas',
  uWmiClassTree in 'Units\uWmiClassTree.pas' {FrmWmiClassTree},
  uPropValueList in 'Units\uPropValueList.pas' {FrmValueList},
  uWmiBorlandCppCode in 'Units\uWmiBorlandCppCode.pas',
  uBorlandCppVersions in 'Units\uBorlandCppVersions.pas',
  uBorlandCppIDE in 'Units\uBorlandCppIDE.pas',
  Vcl.Themes,
  Vcl.Styles,
  uCodeEditor in 'Units\uCodeEditor.pas' {FrmCodeEditor},
  uWmiEvents in 'Units\uWmiEvents.pas' {FrmWmiEvents},
  uWmiMethods in 'Units\uWmiMethods.pas' {FrmWmiMethods},
  uWmiClasses in 'Units\uWmiClasses.pas' {FrmWmiClasses},
  uGlobals in 'Units\uGlobals.pas',
  uWmiVsCppCode in 'Units\uWmiVsCppCode.pas',
  uVisualStudio in 'Units\uVisualStudio.pas',
  Vcl.Styles.Ext in 'Units\Vcl.Styles.Utils\Vcl.Styles.Ext.pas',
  Vcl.Styles.OwnerDrawFix in 'Units\Vcl.Styles.Utils\Vcl.Styles.OwnerDrawFix.pas',
  AsyncCalls in 'Units\ThirdParty\AsyncCalls.pas',
  PngFunctions in 'Units\ThirdParty\PngFunctions.pas',
  PngImageList in 'Units\ThirdParty\PngImageList.pas',
  uXE2Patches in 'Units\Vcl.Styles.Utils\uXE2Patches.pas',
  uWmi_Metadata in 'Units\WMI\uWmi_Metadata.pas',
  Vcl.Styles.WebBrowser in 'Units\Vcl.Styles.Utils\Vcl.Styles.WebBrowser.pas',
  uStdActionsPopMenu in 'Units\Misc\uStdActionsPopMenu.pas',
  uSynEditPopupEdit in 'Units\Misc\uSynEditPopupEdit.pas',
  uOleVariantEnum in 'Units\Misc\uOleVariantEnum.pas',
  uRegistry in 'Units\Misc\uRegistry.pas',
  uMisc in 'Units\Misc\uMisc.pas',
  uListView_Helper in 'Units\Misc\uListView_Helper.pas',
  uWinInet in 'Units\Misc\uWinInet.pas',
  uComboBox in 'Units\Misc\uComboBox.pas',
  uCustomImageDrawHook in 'Units\Misc\uCustomImageDrawHook.pas',
  uCheckUpdate in 'Units\Misc\uCheckUpdate.pas' {FrmCheckUpdate},
  uWmiCSharpCode in 'Units\uWmiCSharpCode.pas',
  uDotNetFrameWork in 'Units\uDotNetFrameWork.pas',
  uWmiPropertyValue in 'Units\uWmiPropertyValue.pas' {FrmWMIPropValue},
  Vcl.Styles.FormStyleHooks in 'Units\Vcl.Styles.Utils\Vcl.Styles.FormStyleHooks.pas',
  uOnlineResources in 'Units\uOnlineResources.pas' {FrmOnlineResources},
  uSqlWMI in 'Units\uSqlWMI.pas' {FrmWMISQL};

{$R *.res}

procedure UpdateApp;
var
  Frm: TFrmCheckUpdate;
begin

  Frm := GetUpdaterInstance;
  try
    Frm.CheckExternal:=True;
    if Frm.UpdateAvailable then
      Frm.ExecuteUpdater;
  finally
    Frm.Free;
  end;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  if FrmMain.Settings.CheckForUpdates then
   UpdateApp;

  Application.Run;
end.
