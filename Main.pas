// **************************************************************************************************
//
// Unit Main
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
// The Original Code is Main.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Rtti, Generics.Collections, WDCC.HostsAdmin,
  SynEdit, ImgList, ToolWin, WDCC.Settings, Menus, Buttons, Vcl.Styles.ColorTabs,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, Vcl.ActnList, Vcl.ActnMan,
  System.Actions, System.ImageList;

type
  TFrmMain = class(TForm)
    PanelMain: TPanel;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButtonAbout: TToolButton;
    ToolButton4: TToolButton;
    MemoConsole: TMemo;
    PanelConsole: TPanel;
    ImageList1: TImageList;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    ToolButtonSettings: TToolButton;
    PopupActionBar1: TPopupActionBar;
    TreeViewTasks: TTreeView;
    Splitter1: TSplitter;
    PageControlTasks: TPageControl;
    TabSheet1: TTabSheet;
    PageControl3: TPageControl;
    TabSheetTask: TTabSheet;
    TabSheet2: TTabSheet;
    MemoLog: TMemo;
    Splitter2: TSplitter;
    ActionManager1: TActionManager;
    ActionRegisterHost: TAction;
    RegisterHost1: TMenuItem;
    ActionConnect: TAction;
    ConnecttoHost1: TMenuItem;
    ActionPing: TAction;
    PingHost1: TMenuItem;
    ToolButton1: TToolButton;
    ActionDisconnect: TAction;
    DisconnectHost1: TMenuItem;
    ToolButtonExit: TToolButton;
    PopupActionBar2: TPopupActionBar;
    procedure FormCreate(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButtonSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeViewTasksChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
    procedure ActionRegisterHostUpdate(Sender: TObject);
    procedure ActionRegisterHostExecute(Sender: TObject);
    procedure ActionConnectUpdate(Sender: TObject);
    procedure ActionConnectExecute(Sender: TObject);
    procedure ActionPingUpdate(Sender: TObject);
    procedure ActionPingExecute(Sender: TObject);
    procedure ActionDisconnectUpdate(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButtonExitClick(Sender: TObject);
    procedure TreeViewTasksCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private
    FSettings: TSettings;
    FCtx: TRttiContext;
    FRegisteredInstances: TDictionary<string, TForm>;
    FListWINHosts: TObjectList<TWMIHost>;
    procedure RegisterTask(const ParentTask, Name: string; ImageIndex: Integer; LinkObject: TRttiType);
    procedure RegisterWMIHosts;
    procedure SetLog(const Log: string);
    procedure SetMsg(const Msg: string);
  public
    property Settings: TSettings read FSettings;
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  WDCC.StdActions.PopMenu,
  WDCC.Misc,
  uWmi_Metadata,
  WDCC.Log,
  WDCC.Globals,
  WDCC.Sql.WMI.Container,
  WDCC.WMI.Classes.Container,
  WDCC.WMI.Database,
  WDCC.WMI.Classes.Tree,
  WDCC.WMI.Events.Container,
  WDCC.WMI.Methods.Container,
  WDCC.WMI.Tree,
  WDCC.WMI.Info,
  Vcl.Styles.FormStyleHooks,
  Vcl.Styles.Ext,
  Vcl.Themes,
  WDCC.About;

Const
  HostCIMStr = 'CIM Repository (%s)';

{$R *.dfm}

function GetNodeByText(ATree: TTreeView; const AValue: String; AVisible: Boolean = False): TTreeNode;
var
  Node: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then
    Exit;
  Node := ATree.Items[0];
  while Node <> nil do
  begin
    if SameText(Node.Text, AValue) then
    begin
      Result := Node;
      if AVisible then
        Result.MakeVisible;
      Break;
    end;
    Node := Node.GetNext;
  end;
end;

procedure TFrmMain.ActionConnectExecute(Sender: TObject);
Var
  LForm: TFrmWMIInfo;
  LWMIHost: TWMIHost;
  LNameSpaces: TStrings;
  LIndex: Integer;
  LNode: TTreeNode;
begin
  LWMIHost := TWMIHost(TreeViewTasks.Selected.Data);
  if LWMIHost.Form = nil then
  begin
    if Ping(LWMIHost.Host, 4, 32, MemoConsole.Lines) then
    begin
      LForm := TFrmWMIInfo.Create(Self);
      LForm.Parent := TabSheetTask;
      LForm.BorderStyle := bsNone;
      LForm.Align := alClient;
      LForm.SetLog := SetLog;
      LForm.WMIHost := LWMIHost;
      LWMIHost.Form := LForm;
      LWMIHost.Form.Show;

      TreeViewTasks.Selected.ImageIndex := 6;
      TreeViewTasks.Selected.SelectedIndex := 6;

      LNameSpaces := TStringList.Create;
      SetMsg(Format('Getting WMI namespaces from [%s]', [LWMIHost.Host]));
      try
        LNameSpaces.AddStrings(CachedWMIClasses.GetNameSpacesHost(LWMIHost.Host, LWMIHost.User, LWMIHost.Password));
        for LIndex := 0 to LNameSpaces.Count - 1 do
          RegisterTask(Format(HostCIMStr, [LWMIHost.Host]), LNameSpaces[LIndex], 58, FCtx.GetType(TFrmWMITree));

        LNode := GetNodeByText(TreeViewTasks, Format(HostCIMStr, [LWMIHost.Host]));
        if LNode <> nil then
          LNode.Expand(True);
      finally
        LNameSpaces.Free;
        SetMsg('');
      end;
    end
    else
    begin
      TreeViewTasks.Selected.ImageIndex := 12;
      TreeViewTasks.Selected.SelectedIndex := 12;
      MsgWarning('Was not possible establish a connection with the host');
    end;
  end;
end;

procedure TFrmMain.ActionConnectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (PageControlTasks.Visible) and (TreeViewTasks.Selected <> nil) and
    (TObject(TreeViewTasks.Selected.Data) is TWMIHost) and (TWMIHost(TreeViewTasks.Selected.Data).Form = nil);
end;

procedure TFrmMain.ActionDisconnectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (PageControlTasks.Visible) and (TreeViewTasks.Selected <> nil) and
    (TObject(TreeViewTasks.Selected.Data) is TWMIHost) and (TWMIHost(TreeViewTasks.Selected.Data).Form <> nil);
end;

procedure TFrmMain.ActionPingExecute(Sender: TObject);
begin
  Ping(TWMIHost(TreeViewTasks.Selected.Data).Host, 4, 32, MemoConsole.Lines);
end;

procedure TFrmMain.ActionPingUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (PageControlTasks.Visible) and (TreeViewTasks.Selected <> nil) and
    (TObject(TreeViewTasks.Selected.Data) is TWMIHost);
end;

procedure TFrmMain.ActionRegisterHostExecute(Sender: TObject);
Var
  Frm: TFrmHostAdmin;
begin
  Frm := TFrmHostAdmin.Create(Self);
  Frm.ShowModal;
end;

procedure TFrmMain.ActionRegisterHostUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := True;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteSettings(Settings);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
Var
  LNameSpaces: TStrings;
  LIndex: Integer;
begin
{$WARN SYMBOL_PLATFORM OFF}
  // ReportMemoryLeaksOnShutdown:=DebugHook<>0;
{$WARN SYMBOL_PLATFORM ON}
  // FillPopupActionBar(PopupActionBar1);

  FillPopupActionBar(PopupActionBar2);
  AssignStdActionsPopUpMenu(Self, PopupActionBar2);

  FListWINHosts := nil;

  FCtx := TRttiContext.Create;
  FRegisteredInstances := TDictionary<string, TForm>.Create;

  FSettings := TSettings.Create;
  SetLog('Reading settings');

  ReadSettings(FSettings);
  LoadVCLStyle(Settings.VCLStyle);

  if FSettings.DisableVClStylesNC then
  begin
    TStyleManager.Engine.RegisterStyleHook(TCustomForm, TFormStyleHookNC);
    TStyleManager.Engine.RegisterStyleHook(TForm, TFormStyleHookNC);
    // GlassFrame.Enabled:=True;
  end
  // else
  // if FSettings.ActivateCustomForm then
  // begin
  // TStyleManager.Engine.RegisterStyleHook(TCustomForm, TFormStyleHookBackground);
  // TStyleManager.Engine.RegisterStyleHook(TForm, TFormStyleHookBackground);
  //
  // if FSettings.CustomFormNC then
  // begin
  // TFormStyleHookBackground.NCSettings.Enabled  := True;
  // TFormStyleHookBackground.NCSettings.UseColor := FSettings.UseColorNC;
  // TFormStyleHookBackground.NCSettings.Color    := FSettings.ColorNC;
  // TFormStyleHookBackground.NCSettings.ImageLocation := FSettings.ImageNC;
  // end;
  //
  // if FSettings.CustomFormBack then
  // begin
  // TFormStyleHookBackground.BackGroundSettings.Enabled  := True;
  // TFormStyleHookBackground.BackGroundSettings.UseColor := FSettings.UseColorBack;
  // TFormStyleHookBackground.BackGroundSettings.Color    := FSettings.ColorBack;
  // TFormStyleHookBackground.BackGroundSettings.ImageLocation := FSettings.ImageBack;
  // end;
  //
  // end
    ;

  // RegisterTask('','Code Generation', 30, nil);
  RegisterTask('', 'WMI Class Code Generation', 40, FCtx.GetType(TFrmWMiClassesContainer));
  RegisterTask('', 'WMI Methods Code Generation', 41, FCtx.GetType(TFrmWmiMethodsContainer));
  RegisterTask('', 'WMI Events Code Generation', 45, FCtx.GetType(TFrmWmiEventsContainer));
  // RegisterTask('','WMI Explorer', 29, Ctx.GetType(TFrmWMITree));
  RegisterTask('', 'WMI Classes Tree', 47, FCtx.GetType(TFrmWmiClassTree));
  RegisterTask('', 'WMI Finder', 57, FCtx.GetType(TFrmWmiDatabase));
  RegisterTask('', 'WQL', 56, FCtx.GetType(TFrmSqlWMIContainer));
  // RegisterTask('','Events Monitor', 28, nil);
  // RegisterTask('','Log', 32, Ctx.GetType(TFrmLog));
  RegisterTask('', 'CIM Repository (localhost)', 6, FCtx.GetType(TFrmWMIInfo));

  LNameSpaces := TStringList.Create;
  try
    LNameSpaces.AddStrings(CachedWMIClasses.NameSpaces);
    for LIndex := 0 to LNameSpaces.Count - 1 do
      RegisterTask('CIM Repository (localhost)', LNameSpaces[LIndex], 58, FCtx.GetType(TFrmWMITree));
  finally
    LNameSpaces.Free;
  end;
  {
    for LHost in GetWMIRegisteredHosts do
    RegisterTask('',Format('CIM Repository (%s)', [LHost]), 31, nil);
  }
  RegisterWMIHosts;

  TreeViewTasks.FullExpand;
  // TreeViewTasks.Selected:=TreeViewTasks.Items[0];
  MemoConsole.Color := Settings.BackGroundColor;
  MemoConsole.Font.Color := Settings.ForeGroundColor;
  MemoLog.Color := MemoConsole.Color;
  MemoLog.Font.Color := MemoConsole.Font.Color;

  StatusBar1.Panels[2].Text := Format('WMI installed version %s', [GetWmiVersion]);
  {
    AssignStdActionsPopUpMenu(Self, PopupActionBar1);
    ApplyVclStylesOwnerDrawFix(Self, True);
  }

end;

procedure TFrmMain.FormDestroy(Sender: TObject);
Var
  Pair: TPair<string, TForm>;
begin
  if FListWINHosts <> nil then
    FreeAndNil(FListWINHosts);

  for Pair in FRegisteredInstances do
  begin
    Pair.Value.Close;
    Pair.Value.Free;
  end;

  FRegisteredInstances.Free;
  Settings.Free;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  if TreeViewTasks.Selected = nil then
    TreeViewTasks.Selected := TreeViewTasks.Items[0];
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

procedure TFrmMain.ToolButton1Click(Sender: TObject);
begin
  PageControlTasks.Visible := not PageControlTasks.Visible;
end;

procedure TFrmMain.ToolButtonAboutClick(Sender: TObject);
var
  Frm: TFrmAbout;
begin
  Frm := TFrmAbout.Create(nil);
  Frm.ShowModal();
end;

procedure TFrmMain.ToolButtonExitClick(Sender: TObject);
begin
  Close();
end;

procedure TFrmMain.RegisterTask(const ParentTask, Name: string; ImageIndex: Integer; LinkObject: TRttiType);
Var
  PNode: TTreeNode;
  Node: TTreeNode;
begin
  if ParentTask = '' then
    Node := TreeViewTasks.Items.AddObject(nil, Name, LinkObject)
  else
  begin
    PNode := GetNodeByText(TreeViewTasks, ParentTask);
    Node := TreeViewTasks.Items.AddChildObject(PNode, Name, LinkObject);
  end;

  Node.ImageIndex := ImageIndex; // add BN ??
  Node.SelectedIndex := ImageIndex;
end;

procedure TFrmMain.RegisterWMIHosts;
Var
  Node: TTreeNode;
  LWMIHost: TWMIHost;
begin
  if FListWINHosts <> nil then
    FreeAndNil(FListWINHosts);
  FListWINHosts := GetListWMIRegisteredHosts;

  for LWMIHost in FListWINHosts do
  begin
    Node := TreeViewTasks.Items.AddObject(nil, Format(HostCIMStr, [LWMIHost.Host]), LWMIHost);
    Node.ImageIndex := 31; // add BN ??
    Node.SelectedIndex := 31;
  end;
end;

procedure TFrmMain.ToolButtonSettingsClick(Sender: TObject);
var
  Frm: TFrmSettings;
begin
  Frm := TFrmSettings.Create(nil);
  try
    Frm.Form := Self;
    Frm.LoadSettings;
    Frm.ShowModal();
  finally
    Frm.Free;
    ReadSettings(FSettings);
  end;
end;

procedure TFrmMain.TreeViewTasksChange(Sender: TObject; Node: TTreeNode);
var
  LRttiInstanceType: TRttiInstanceType;
  LValue: TValue;
  LRttiProperty: TRttiProperty;
  LForm: TForm;
  LIndex: Integer;
  LProc: TProcLog;
begin
  if Node.Text <> '' then
  begin
    TabSheetTask.Caption := Node.Text;
    TabSheetTask.ImageIndex := Node.ImageIndex;

    for LIndex := 0 to TabSheetTask.ControlCount - 1 do
      if (TabSheetTask.Controls[LIndex] is TForm) and (TForm(TabSheetTask.Controls[LIndex]).Visible) then
      begin
        TForm(TabSheetTask.Controls[LIndex]).Hide;
        Break;
      end;

    if (Node.Data <> nil) and (Node.Parent <> nil) and (TObject(Node.Parent.Data) is TWMIHost) then
    begin
      if FRegisteredInstances.ContainsKey(Node.Parent.Text + Node.Text) then
        FRegisteredInstances.Items[Node.Parent.Text + Node.Text].Show
      else if Node.Data <> nil then
      begin
        LRttiInstanceType := TRttiInstanceType(Node.Data);
        LValue := LRttiInstanceType.GetMethod('Create').Invoke(LRttiInstanceType.MetaclassType, [Self]);
        LForm := TForm(LValue.AsObject);
        LForm.Parent := TabSheetTask;
        LForm.BorderStyle := bsNone;
        LForm.Align := alClient;

        LRttiProperty := LRttiInstanceType.GetProperty('Console');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, MemoConsole);

        LProc := SetMsg;
        LRttiProperty := LRttiInstanceType.GetProperty('SetMsg');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, TValue.From<TProcLog>(LProc));

        LProc := SetLog;
        LRttiProperty := LRttiInstanceType.GetProperty('SetLog');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, TValue.From<TProcLog>(LProc));

        LRttiProperty := LRttiInstanceType.GetProperty('Settings');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, FSettings);

        LRttiProperty := LRttiInstanceType.GetProperty('NameSpace');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, Node.Text);

        LRttiProperty := LRttiInstanceType.GetProperty('WMIHost');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, TWMIHost(Node.Parent.Data));

        LForm.Show;
        FRegisteredInstances.Add(Node.Parent.Text + Node.Text, LForm);
      end;
    end
    else if (Node.Data <> nil) and (TObject(Node.Data) is TWMIHost) then
    begin
      if TWMIHost(Node.Data).Form <> nil then
        TWMIHost(Node.Data).Form.Show;
    end
    else
    begin
      if FRegisteredInstances.ContainsKey(Node.Text) then
        FRegisteredInstances.Items[Node.Text].Show
      else if Node.Data <> nil then
      begin
        LRttiInstanceType := TRttiInstanceType(Node.Data);
        LValue := LRttiInstanceType.GetMethod('Create').Invoke(LRttiInstanceType.MetaclassType, [Self]);
        LForm := TForm(LValue.AsObject);
        LForm.Parent := TabSheetTask;
        LForm.BorderStyle := bsNone;
        LForm.Align := alClient;

        LRttiProperty := LRttiInstanceType.GetProperty('Console');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, MemoConsole);

        LProc := SetMsg;
        LRttiProperty := LRttiInstanceType.GetProperty('SetMsg');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, TValue.From<TProcLog>(LProc));

        LProc := SetLog;
        LRttiProperty := LRttiInstanceType.GetProperty('SetLog');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, TValue.From<TProcLog>(LProc));

        LRttiProperty := LRttiInstanceType.GetProperty('Settings');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, FSettings);

        LRttiProperty := LRttiInstanceType.GetProperty('NameSpace');
        if LRttiProperty <> nil then
          LRttiProperty.SetValue(LForm, Node.Text);

        LForm.Show;
        FRegisteredInstances.Add(Node.Text, LForm);
      end;
    end;

  end;

end;

procedure TFrmMain.TreeViewTasksCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if not StyleServices.IsSystemStyle then
    if cdsSelected in State then
    begin
      TTreeView(Sender).Canvas.Brush.Color := StyleServices.GetSystemColor(clHighlight);
      TTreeView(Sender).Canvas.Font.Color := StyleServices.GetSystemColor(clHighlightText);
    end;
end;

initialization

if not IsStyleHookRegistered(TCustomSynEdit, TScrollingStyleHook) then
  TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);

{
  TCustomStyleEngine.RegisterStyleHook(TCustomTabControl, TTabColorControlStyleHook);
  TCustomStyleEngine.RegisterStyleHook(TTabControl, TTabColorControlStyleHook);
}
end.
