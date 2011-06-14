program WmiDelphiCodeCreator;

uses
  Forms,
  MainWmiDelphiC in 'MainWmiDelphiC.pas' {FrmMain},
  uWmiTree in 'Units\uWmiTree.pas' {FrmWMITree},
  uWmi_Metadata in '..\..\2007\WmiMetadata\uWmi_Metadata.pas',
  uDelphiSyntax in 'Units\uDelphiSyntax.pas',
  uListView_Helper in 'Units\uListView_Helper.pas',
  Wmi_About in 'Units\Wmi_About.pas' {FrmAbout},
  uWmiDelphiCode in 'Units\uWmiDelphiCode.pas',
  AsyncCalls in 'C:\Delphi\Librerias\AsyncCalls\AsyncCalls.pas',
  uDelphiIDE in 'Units\uDelphiIDE.pas',
  uDelphiPrismHelper in 'Units\uDelphiPrismHelper.pas',
  uDelphiPrismIDE in 'Units\uDelphiPrismIDE.pas',
  uLazarusIDE in 'Units\uLazarusIDE.pas',
  uSelectCompilerVersion in 'Units\uSelectCompilerVersion.pas' {FrmSelCompilerVer},
  Wmi_ViewPropsValues in 'Units\Wmi_ViewPropsValues.pas' {FrmWmiVwProps},
  uRegistry in 'Units\uRegistry.pas',
  uWmiDatabase in 'Units\uWmiDatabase.pas' {FrmWmiDatabase},
  uCustomImageDrawHook in 'Units\uCustomImageDrawHook.pas',
  uMisc in 'Units\uMisc.pas',
  uComboBox in 'Units\uComboBox.pas',
  uSettings in 'Units\uSettings.pas' {FrmSettings},
  uDelphiIDEHighlight in 'Units\uDelphiIDEHighlight.pas',
  uDelphiVersions in 'Units\uDelphiVersions.pas',
  uWmiGenCode in 'Units\uWmiGenCode.pas',
  uWmiOxygenCode in 'Units\uWmiOxygenCode.pas',
  uWmiFPCCode in 'Units\uWmiFPCCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
