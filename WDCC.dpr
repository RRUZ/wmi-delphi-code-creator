program WDCC;

uses
  Forms,
  Vcl.Themes,
  Vcl.Styles,
  WDCC.Globals in 'Units\WDCC.Globals.pas',
  Main in 'Main.pas' {FrmMain},
  WDCC.WMI.Tree in 'Units\WDCC.WMI.Tree.pas' {FrmWMITree},
  WDCC.About in 'Units\WDCC.About.pas' {FrmAbout},
  WDCC.WMI.DelphiCode in 'Units\WDCC.WMI.DelphiCode.pas',
  WDCC.Delphi.IDE in 'Units\WDCC.Delphi.IDE.pas',
  WDCC.DelphiPrism.Helper in 'Units\WDCC.DelphiPrism.Helper.pas',
  WDCC.DelphiPrism.IDE in 'Units\WDCC.DelphiPrism.IDE.pas',
  WDCC.Delphi.IDE.Highlight in 'Units\WDCC.Delphi.IDE.Highlight.pas',
  WDCC.Delphi.Versions in 'Units\WDCC.Delphi.Versions.pas',
  WDCC.Delphi.Syntax in 'Units\WDCC.Delphi.Syntax.pas',
  WDCC.Lazarus.IDE in 'Units\WDCC.Lazarus.IDE.pas',
  WDCC.SelectCompilerVersion in 'Units\WDCC.SelectCompilerVersion.pas' {FrmSelCompilerVer},
  WDCC.WMI.ViewPropsValues in 'Units\WDCC.WMI.ViewPropsValues.pas' {FrmWmiVwProps},
  WDCC.WMI.Database in 'Units\WDCC.WMI.Database.pas' {FrmWmiDatabase},
  WDCC.Settings in 'Units\WDCC.Settings.pas' {FrmSettings},
  WDCC.WMI.GenCode in 'Units\WDCC.WMI.GenCode.pas',
  WDCC.WMI.OxygenCode in 'Units\WDCC.WMI.OxygenCode.pas',
  WDCC.WMI.FPCCode in 'Units\WDCC.WMI.FPCCode.pas',
  WDCC.WMI.Classes.Tree in 'Units\WDCC.WMI.Classes.Tree.pas' {FrmWmiClassTree},
  WDCC.PropValueList in 'Units\WDCC.PropValueList.pas' {FrmValueList},
  WDCC.WMI.Borland.CppCode in 'Units\WDCC.WMI.Borland.CppCode.pas',
  WDCC.Borland.Cpp.Versions in 'Units\WDCC.Borland.Cpp.Versions.pas',
  WDCC.Borland.Cpp.IDE in 'Units\WDCC.Borland.Cpp.IDE.pas',
  WDCC.CodeEditor in 'Units\WDCC.CodeEditor.pas' {FrmCodeEditor},
  WDCC.WMI.Events in 'Units\WDCC.WMI.Events.pas' {FrmWmiEvents},
  WDCC.WMI.Methods in 'Units\WDCC.WMI.Methods.pas' {FrmWmiMethods},
  WDCC.WMI.Classes in 'Units\WDCC.WMI.Classes.pas' {FrmWmiClasses},
  WDCC.WMI.Microsoft.CppCode in 'Units\WDCC.WMI.Microsoft.CppCode.pas',
  WDCC.VisualStudio in 'Units\WDCC.VisualStudio.pas',
  AsyncCalls in 'Units\ThirdParty\AsyncCalls.pas',
  uXE2Patches in 'Units\Vcl.Styles.Utils\uXE2Patches.pas',
  uWmi_Metadata in 'Units\WMI\uWmi_Metadata.pas',
  WDCC.StdActions.PopMenu in 'Units\Misc\WDCC.StdActions.PopMenu.pas',
  WDCC.SynEdit.PopupEdit in 'Units\Misc\WDCC.SynEdit.PopupEdit.pas',
  WDCC.OleVariant.Enum in 'Units\Misc\WDCC.OleVariant.Enum.pas',
  WDCC.Registry in 'Units\Misc\WDCC.Registry.pas',
  WDCC.Misc in 'Units\Misc\WDCC.Misc.pas',
  WDCC.ListView.Helper in 'Units\Misc\WDCC.ListView.Helper.pas',
  WDCC.WinInet in 'Units\Misc\WDCC.WinInet.pas',
  WDCC.ComboBox in 'Units\Misc\WDCC.ComboBox.pas',
  WDCC.CustomImage.DrawHook in 'Units\Misc\WDCC.CustomImage.DrawHook.pas',
  WDCC.WMI.CSharpCode in 'Units\WDCC.WMI.CSharpCode.pas',
  WDCC.DotNetFrameWork in 'Units\WDCC.DotNetFrameWork.pas',
  WDCC.WMI.PropertyValue in 'Units\WDCC.WMI.PropertyValue.pas' {FrmWMIPropValue},
  WDCC.OnlineResources in 'Units\WDCC.OnlineResources.pas' {FrmOnlineResources},
  WDCC.Sql.WMI in 'Units\WDCC.Sql.WMI.pas' {FrmWMISQL},
  WDCC.UpdatesChanges in 'Units\Misc\WDCC.UpdatesChanges.pas' {FrmUpdateChanges},
  WbemScripting_TLB in 'Units\WMI\WbemScripting_TLB.pas',
  WDCC.Log in 'Units\WDCC.Log.pas' {FrmLog},
  WDCC.Sql.WMI.Container in 'Units\WDCC.Sql.WMI.Container.pas' {FrmSqlWMIContainer},
  WDCC.WMI.Info in 'Units\WDCC.WMI.Info.pas' {FrmWMIInfo},
  WDCC.WMI.Classes.Container in 'Units\WDCC.WMI.Classes.Container.pas' {FrmWMiClassesContainer},
  WDCC.WMI.Events.Container in 'Units\WDCC.WMI.Events.Container.pas' {FrmWmiEventsContainer},
  WDCC.WMI.Methods.Container in 'Units\WDCC.WMI.Methods.Container.pas' {FrmWmiMethodsContainer},
  WDCC.HostsAdmin in 'Units\WDCC.HostsAdmin.pas' {FrmHostAdmin},
  Vcl.Styles.TabsClose in 'Units\Vcl.Styles.Utils\Vcl.Styles.TabsClose.pas',
  WDCC.SupportedIDEs in 'Units\WDCC.SupportedIDEs.pas';

{$R *.res}

procedure UpdateApp;
var
  Settings : TSettings;
begin
  Settings:=TSettings.Create;
  try
    ReadSettings(Settings);
    if Settings.CheckForUpdates then
     CheckForUpdates(True);
  finally
    Settings.Free;
  end;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  UpdateApp;
  Application.Run;
end.
