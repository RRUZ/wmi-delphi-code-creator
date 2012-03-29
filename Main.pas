{**************************************************************************************************}
{                                                                                                  }
{ Unit Main                                                                                        }
{ Main Form for the WMI Delphi Code Creator                                                        }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is Main.pas.                                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit Main;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  SynEdit, ImgList, ToolWin, uWmiTree, uSettings, uWmiDatabase, uWmi_Metadata,
  Menus, Buttons, uWmiClassTree, uWmiEvents, uWmiMethods, uWmiClasses, Consts,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup;


type
  TFrmMain = class(TForm)
    PanelMain: TPanel;
    PageControlMain: TPageControl;
    TabSheetWmiClasses: TTabSheet;
    TabSheetWmiExplorer: TTabSheet;
    TabSheetMethods: TTabSheet;
    StatusBar1: TStatusBar;
    ToolBar1:  TToolBar;
    ToolButtonSearch: TToolButton;
    ToolButtonAbout: TToolButton;
    ToolButton4: TToolButton;
    ToolButtonOnline: TToolButton;
    TabSheet6: TTabSheet;
    MemoLog:   TMemo;
    ProgressBarWmi: TProgressBar;
    MemoConsole: TMemo;
    TabSheetCodeGen: TTabSheet;
    PanelCodeGen: TPanel;
    PageControlCodeGen: TPageControl;
    PanelConsole: TPanel;
    Splitter4: TSplitter;
    ToolButtonGetValues: TToolButton;
    TabSheetWmiDatabase: TTabSheet;
    ImageList1: TImageList;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    ToolButtonSettings: TToolButton;
    TabSheetTreeClasses: TTabSheet;
    TabSheetEvents: TTabSheet;
    PopupActionBar1: TPopupActionBar;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ToolButtonOnlineClick(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure ToolButtonSearchClick(Sender: TObject);
    procedure PageControlMainChange(Sender: TObject);
    procedure ToolButtonGetValuesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButtonSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FrmWmiDatabase: TFrmWmiDatabase;
    FDataLoaded: boolean;
    FrmWMIExplorer  : TFrmWMITree;
    FrmWmiClassTree : TFrmWmiClassTree;

    FrmWmiEvents          : TFrmWmiEvents;
    FrmWmiMethods         : TFrmWmiMethods;
    FSettings: TSettings;

    procedure LoadWmiMetaData;
    procedure SetLog(const Log :string);
  public
    FrmWmiClasses         : TFrmWmiClasses;
    procedure SetMsg(const Msg: string);
    property Settings : TSettings read FSettings;
  end;


var
  FrmMain: TFrmMain;

implementation

uses
  ComObj,
  ShellApi,
  uStdActionsPopMenu,
  Vcl.Styles.FormStyleHooks,
  Vcl.Styles.OwnerDrawFix,
  Vcl.Styles.Ext,
  Vcl.Themes,
  uWmi_About;

{$R *.dfm}

procedure TFrmMain.FormActivate(Sender: TObject);
begin
  if not FDataLoaded then
    LoadWmiMetaData;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmWmiEvents.Close();
  FrmWmiMethods.Close();
  FrmWmiClasses.Close();
  WriteSettings(Settings);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown:=DebugHook<>0;
  {$WARN SYMBOL_PLATFORM ON}
  FillPopupActionBar(PopupActionBar1);

  FSettings :=TSettings.Create;
  SetLog('Reading settings');

  ReadSettings(FSettings);
  LoadVCLStyle(Settings.VCLStyle);


  if FSettings.DisableVClStylesNC then
  begin
   TStyleManager.Engine.RegisterStyleHook(TCustomForm, TFormStyleHookNC);
   TStyleManager.Engine.RegisterStyleHook(TForm, TFormStyleHookNC);
   //GlassFrame.Enabled:=True;
  end
  else
  if FSettings.ActivateCustomForm then
  begin
   TStyleManager.Engine.RegisterStyleHook(TCustomForm, TFormStyleHookBackround);
   TStyleManager.Engine.RegisterStyleHook(TForm, TFormStyleHookBackround);

   if FSettings.CustomFormNC then
   begin
     TFormStyleHookBackround.NCSettings.Enabled  := True;
     TFormStyleHookBackround.NCSettings.UseColor := FSettings.UseColorNC;
     TFormStyleHookBackround.NCSettings.Color    := FSettings.ColorNC;
     TFormStyleHookBackround.NCSettings.ImageLocation := FSettings.ImageNC;
   end;

   if FSettings.CustomFormBack then
   begin
     TFormStyleHookBackround.BackGroundSettings.Enabled  := True;
     TFormStyleHookBackround.BackGroundSettings.UseColor := FSettings.UseColorBack;
     TFormStyleHookBackround.BackGroundSettings.Color    := FSettings.ColorBack;
     TFormStyleHookBackround.BackGroundSettings.ImageLocation := FSettings.ImageBack;
   end;

  end;

  MemoConsole.Color:=Settings.BackGroundColor;
  MemoConsole.Font.Color:=Settings.ForeGroundColor;

  MemoLog.Color:=MemoConsole.Color;
  MemoLog.Font.Color:=MemoConsole.Font.Color;

  FDataLoaded := False;
  StatusBar1.Panels[2].Text := Format('WMI installed version %s      ', [GetWmiVersion]);

  ProgressBarWmi.Parent := StatusBar1;
  FrmWmiDatabase := TFrmWmiDatabase.Create(Self);
  FrmWmiDatabase.Parent := TabSheetWmiDatabase;
  FrmWmiDatabase.BorderStyle := bsNone;
  FrmWmiDatabase.Align := alClient;
  //FrmWmiDatabase.Status:=SetMsg;
  FrmWmiDatabase.Log   :=SetLog;
  FrmWmiDatabase.Show;

  FrmWMIExplorer := TFrmWMITree.Create(Self);
  FrmWMIExplorer.Parent := TabSheetWmiExplorer;
  FrmWMIExplorer.BorderStyle := bsNone;
  FrmWMIExplorer.Align := alClient;

  FrmWMIExplorer.MemoDescr.Color:=Settings.BackGroundColor;
  FrmWMIExplorer.MemoDescr.Font.Color:=MemoConsole.Font.Color;
  FrmWMIExplorer.MemoWmiMOF.Color:=Settings.BackGroundColor;
  FrmWMIExplorer.MemoWmiMOF.Font.Color:=MemoConsole.Font.Color;
  FrmWMIExplorer.MemoQualifiers.Color:=Settings.BackGroundColor;
  FrmWMIExplorer.MemoQualifiers.Font.Color:=MemoConsole.Font.Color;
  FrmWMIExplorer.SetMsg:=SetMsg;
  FrmWMIExplorer.SetLog:=SetLog;

  FrmWMIExplorer.Show;

  FrmWmiClassTree := TFrmWmiClassTree.Create(Self);
  FrmWmiClassTree.Parent := TabSheetTreeClasses;
  FrmWmiClassTree.Align := alClient;
  FrmWmiClassTree.Show;

  FrmWmiClasses  := TFrmWmiClasses.Create(Self);
  //FrmWmiClasses.CodeGenerator:=GenerateCode;
  FrmWmiClasses.Parent := TabSheetWmiClasses;
  FrmWmiClasses.Align  := alClient;
  FrmWmiClasses.Show;
  FrmWmiClasses.Settings:=Settings;
  FrmWmiClasses.Console:=MemoConsole;
  FrmWmiClasses.SetLog:=SetLog;
  FrmWmiClasses.SetMsg:=SetMsg;
  //FrmWmiClasses.CompilerType:=Ct_Delphi;

  FrmWmiMethods  := TFrmWmiMethods.Create(Self);
  //FrmCodeEditorMethod.CodeGenerator:=GenerateCode;
  FrmWmiMethods.Parent := TabSheetMethods;
  FrmWmiMethods.Align  := alClient;
  FrmWmiMethods.Show;
  FrmWmiMethods.Settings:=Settings;
  FrmWmiMethods.Console:=MemoConsole;
  FrmWmiMethods.SetLog:=SetLog;
  FrmWmiMethods.SetMsg:=SetMsg;
  //FrmCodeEditorMethod.CompilerType:=Ct_Delphi;

  FrmWmiEvents  := TFrmWmiEvents.Create(Self);
  FrmWmiEvents.Parent := TabSheetEvents;
  FrmWmiEvents.Align  := alClient;
  FrmWmiEvents.Settings:=Settings;
  FrmWmiEvents.SetLog:=SetLog;
  FrmWmiEvents.Console:=MemoConsole;
  FrmWmiEvents.Show;
  //FrmWmiEvents.CompilerType:=Ct_Delphi;
  //FrmWmiEvents.CodeGenerator:=GenerateCode;

  LoadCurrentTheme(Self,Settings.CurrentTheme);
  LoadCurrentThemeFont(Self,Settings.FontName,Settings.FontSize);

  AssignStdActionsPopUpMenu(Self, PopupActionBar1);
  ApplyVclStylesOwnerDrawFix(Self, True);
end;


procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FrmWmiClasses.Free;
  FrmWmiEvents.Free;
  FrmWmiMethods.Free;

  FrmWMIExplorer.Free;
  FrmWmiClassTree.Free;
  Settings.Free;
end;

procedure TFrmMain.LoadWmiMetaData;
var
  i:    integer;
  Node: TTreeNode;
  // GWmiNamespaces : IAsyncCall;
  FNameSpaces: TStringList;
  Frm:  TFrmAbout;
begin
  FDataLoaded := True;
  FNameSpaces := TStringList.Create;
  Frm := TFrmAbout.Create(Self);
  try

    {$WARN SYMBOL_PLATFORM OFF}
    if (DebugHook=0) and (SameText(Settings.VCLStyle,'Windows') or Settings.DisableVClStylesNC) then
    Frm.Show;
    {$WARN SYMBOL_PLATFORM ON}

    SetMsg('Loading Namespaces');
    ProgressBarWmi.Visible := True;
    FNameSpaces.Sorted     := True;
    //FNameSpaces.Clear;
    FNameSpaces.BeginUpdate;
    Self.Enabled := False;
    try
      try
        if not ExistWmiNameSpaceCache then
        begin
          GetListWMINameSpaces('root', FNameSpaces);
          SaveWMINameSpacesToCache(FNameSpaces);
        end
        else
          LoadWMINameSpacesFromCache(FNameSpaces);

          FrmWmiClassTree.CbNamespaces.Items.Clear;
          FrmWmiClassTree.CbNamespaces.Items.AddStrings(FNameSpaces);
          FrmWmiClassTree.CbNamespaces.ItemIndex:=0;

               {

           GWmiNamespaces := AsyncCall(@GetListWMINameSpaces, ['root', FNameSpaces]);
           while AsyncMultiSync([GWmiNamespaces], True, 100) = WAIT_TIMEOUT do
             Application.ProcessMessages;
                  }
        FrmWmiClasses.LabelNamespace.Caption := Format('Namespaces (%d)', [FNameSpaces.Count]);
      except
        on E: EOleSysError do

          if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
            SetLog(
              Format('Access denied  %s %s  Code : %x', ['GetListWMINameSpaces', E.Message, E.ErrorCode]))
          else
            raise;
      end;

    finally
      Self.Enabled := True;
      FNameSpaces.EndUpdate;
      ProgressBarWmi.Visible := False;
    end;

    FrmWmiClasses.ComboBoxNameSpaces.Items.BeginUpdate;
    try
      FrmWmiClasses.ComboBoxNameSpaces.Items.AddStrings(FNameSpaces);
    finally
      FrmWmiClasses.ComboBoxNameSpaces.Items.EndUpdate;
    end;

    FrmWmiEvents.ComboBoxNamespacesEvents.Items.BeginUpdate;
    try
      FrmWmiEvents.ComboBoxNamespacesEvents.Items.AddStrings(FNameSpaces);
    finally
      FrmWmiEvents.ComboBoxNamespacesEvents.Items.EndUpdate;
    end;

    FrmWmiMethods.ComboBoxNamespaceMethods.Items.BeginUpdate;
    try
      FrmWmiMethods.ComboBoxNamespaceMethods.Items.AddStrings(FNameSpaces);
    finally
      FrmWmiMethods.ComboBoxNamespaceMethods.Items.EndUpdate;
    end;


    FrmWMIExplorer.TreeViewWmiClasses.Items.BeginUpdate;
    try
      for i := 0 to FNameSpaces.Count - 1 do
      begin
        Node := FrmWMIExplorer.TreeViewWmiClasses.Items.Add(nil, FNameSpaces[i]);
        Node.ImageIndex := NamespaceImageIndex;
        Node.SelectedIndex := NamespaceImageIndex;
      end;
    finally
      FrmWMIExplorer.TreeViewWmiClasses.Items.EndUpdate;
    end;

    if Settings.LastWmiNameSpace<>'' then
      FrmWmiClasses.ComboBoxNameSpaces.ItemIndex := FrmWmiClasses.ComboBoxNameSpaces.Items.IndexOf(Settings.LastWmiNameSpace)
    else
      FrmWmiClasses.ComboBoxNameSpaces.ItemIndex := 0;

    FrmWmiClasses.LoadWmiClasses(FrmWmiClasses.ComboBoxNameSpaces.Text);
    if Settings.LastWmiClass<>'' then
      FrmWmiClasses.ComboBoxClasses.ItemIndex := FrmWmiClasses.ComboBoxClasses.Items.IndexOf(Settings.LastWmiClass)
    else
      FrmWmiClasses.ComboBoxClasses.ItemIndex := 0;


    FrmWmiClasses.LoadClassInfo;

    if Settings.LastWmiNameSpaceEvents<>'' then
      FrmWmiEvents.ComboBoxNamespacesEvents.ItemIndex := FrmWmiEvents.ComboBoxNamespacesEvents.Items.IndexOf(Settings.LastWmiNameSpaceEvents)
    else
      FrmWmiEvents.ComboBoxNamespacesEvents.ItemIndex := 0;

    FrmWmiEvents.LoadWmiEvents(FrmWmiEvents.ComboBoxNamespacesEvents.Text, True);

    if Settings.LastWmiNameSpaceMethods<>'' then
      FrmWmiMethods.ComboBoxNamespaceMethods.ItemIndex := FrmWmiMethods.ComboBoxNamespaceMethods.Items.IndexOf(Settings.LastWmiNameSpaceEvents)
    else
      FrmWmiMethods.ComboBoxNamespaceMethods.ItemIndex := 0;

    FrmWmiMethods.LoadWmiMethods(FrmWmiMethods.ComboBoxNamespaceMethods.Text, True);

    SetMsg('');
  finally
    FNameSpaces.Free;
    //Frm.Close;
    //Frm.Free;
  end;
end;

procedure TFrmMain.SetLog(const Log: string);
begin
 MemoLog.Lines.Add(Log);
end;

procedure TFrmMain.SetMsg(const Msg: string);
begin
  StatusBar1.Panels[0].Text := Msg;
  StatusBar1.Update;
end;

procedure TFrmMain.StatusBar1DrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel = StatusBar.Panels[1] then
    ProgressBarWmi.Top := Rect.Top;
  ProgressBarWmi.Left := Rect.Left;
  ProgressBarWmi.Width  := Rect.Right - Rect.Left - 15;
  ProgressBarWmi.Height := Rect.Bottom - Rect.Top;
end;

procedure TFrmMain.ToolButtonOnlineClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(Format(UrlWmiHelp, [FrmWmiClasses.ComboBoxClasses.Text])), nil,
    nil, SW_SHOW);
end;

procedure TFrmMain.ToolButtonAboutClick(Sender: TObject);
var
  Frm: TFrmAbout;
begin
  Frm := TFrmAbout.Create(nil);
  Frm.ShowModal();
end;

procedure TFrmMain.ToolButtonGetValuesClick(Sender: TObject);
begin
  FrmWmiClasses.GetValuesWmiProperties(FrmWmiClasses.ComboBoxNameSpaces.Text, FrmWmiClasses.ComboBoxClasses.Text);
end;

procedure TFrmMain.PageControlMainChange(Sender: TObject);
begin
  if PageControlMain.ActivePage = TabSheetWmiDatabase then
   FrmWmiDatabase.NameSpaces:=FrmWmiClasses.ComboBoxNameSpaces.Items;
end;

procedure TFrmMain.ToolButtonSearchClick(Sender: TObject);
begin
  PageControlMain.ActivePage := TabSheetWmiExplorer;
  FrmWMIExplorer.FindDialog1.Execute(Handle);
end;

procedure TFrmMain.ToolButtonSettingsClick(Sender: TObject);
var
  Frm : TFrmSettings;
begin
  Frm :=TFrmSettings.Create(nil);
  try
    Frm.Form:=Self;
    Frm.LoadSettings;
    Frm.ShowModal();
  finally
    Frm.Free;
    ReadSettings(FSettings);
  end;
end;

initialization

if not IsStyleHookRegistered(TCustomSynEdit, TScrollingStyleHook) then
 TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);


end.
