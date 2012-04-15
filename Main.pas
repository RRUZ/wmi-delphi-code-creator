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
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,   Rtti, Generics.Collections,
  SynEdit, ImgList, ToolWin,  uSettings, Menus, Buttons,  Vcl.Styles.ColorTabs,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup;

type
  TFrmMain = class(TForm)
    PanelMain: TPanel;
    StatusBar1: TStatusBar;
    ToolBar1:  TToolBar;
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
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    PageControl3: TPageControl;
    TabSheetTask: TTabSheet;
    TabSheet2: TTabSheet;
    MemoLog: TMemo;
    Splitter2: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ToolButtonSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreeViewTasksChange(Sender: TObject; Node: TTreeNode);
    procedure FormShow(Sender: TObject);
  private
    FSettings: TSettings;
    Ctx : TRttiContext;
    RegisteredInstances : TDictionary<string,TForm>;
    procedure RegisterTask(const ParentTask, Name : string;ImageIndex:Integer; LinkObject : TRttiType);
    procedure SetLog(const Log :string);
    procedure SetMsg(const Msg: string);
  public
    property Settings : TSettings read FSettings;
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  uMisc,
  uWmi_Metadata,
  uLog,
  uGlobals,
  uSqlWMIContainer,
  uWMIClassesContainer,
  uWmiDatabase,
  uWmiClassTree,
  uWmiEvents,
  uWmiMethods,
  uWmiTree,
  uWmiInfo,
  ComObj,
  ShellApi,
  uStdActionsPopMenu,
  Vcl.Styles.FormStyleHooks,
  Vcl.Styles.OwnerDrawFix,
  Vcl.Styles.Ext,
  Vcl.Themes,
  uWmi_About;

{$R *.dfm}

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteSettings(Settings);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
Var
 LNameSpaces : TStrings;
 LIndex      : Integer;
begin
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown:=DebugHook<>0;
  {$WARN SYMBOL_PLATFORM ON}
  FillPopupActionBar(PopupActionBar1);

  Ctx:=TRttiContext.Create;
  RegisteredInstances:=TDictionary<string, TForm>.Create;

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

  //RegisterTask('','Code Generation', 30, nil);
  RegisterTask('','WMI Class Code Generation', 40, Ctx.GetType(TFrmWMiClassesContainer));
  RegisterTask('','WMI Methods Code Generation', 41,  Ctx.GetType(TFrmWmiMethods));
  RegisterTask('','WMI Events Code Generation', 45, Ctx.GetType(TFrmWmiEvents));
  //RegisterTask('','WMI Explorer', 29, Ctx.GetType(TFrmWMITree));
  RegisterTask('','WMI Classes Tree', 43, Ctx.GetType(TFrmWmiClassTree));
  RegisterTask('','WMI Finder', 57, Ctx.GetType(TFrmWmiDatabase));
  RegisterTask('','WQL', 56, Ctx.GetType(TFrmSqlWMIContainer));
  //RegisterTask('','Events Monitor', 28, nil);
  //RegisterTask('','Log', 32, Ctx.GetType(TFrmLog));
  RegisterTask('','CIM Repository', 31, Ctx.GetType(TFrmWMIInfo));

  LNameSpaces:=TStringList.Create;
  try
    LNameSpaces.AddStrings(CachedWMIClasses.NameSpaces);
    for LIndex := 0 to LNameSpaces.Count-1 do
      RegisterTask('CIM Repository', LNameSpaces[LIndex], 60, Ctx.GetType(TFrmWMITree));
  finally
    LNameSpaces.Free;
  end;


  TreeViewTasks.FullExpand;
  //TreeViewTasks.Selected:=TreeViewTasks.Items[0];

  MemoConsole.Color:=Settings.BackGroundColor;
  MemoConsole.Font.Color:=Settings.ForeGroundColor;
  MemoLog.Color:=MemoConsole.Color;
  MemoLog.Font.Color:=MemoConsole.Font.Color;

  StatusBar1.Panels[2].Text := Format('WMI installed version %s', [GetWmiVersion]);
  AssignStdActionsPopUpMenu(Self, PopupActionBar1);
  ApplyVclStylesOwnerDrawFix(Self, True);
end;


procedure TFrmMain.FormDestroy(Sender: TObject);
Var
 Pair : TPair<string,TForm>;
begin
  for Pair in  RegisteredInstances do
  begin
   Pair.Value.Close;
   Pair.Value.Free;
  end;

  RegisteredInstances.Free;
  Settings.Free;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
 if TreeViewTasks.Selected=nil then
   TreeViewTasks.Selected:=TreeViewTasks.Items[0];
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

procedure TFrmMain.ToolButtonAboutClick(Sender: TObject);
var
  Frm: TFrmAbout;
begin
  Frm := TFrmAbout.Create(nil);
  Frm.ShowModal();
end;

function GetNodeByText(ATree : TTreeView; const AValue:String; AVisible: Boolean=False): TTreeNode;
var
 Node: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then Exit;
  Node := ATree.Items[0];
  while Node <> nil do
  begin
    if SameText(Node.Text,AValue) then
    begin
      Result := Node;
      if AVisible then
        Result.MakeVisible;
      Break;
    end;
    Node := Node.GetNext;
  end;
end;

procedure TFrmMain.RegisterTask(const ParentTask, Name: string; ImageIndex: Integer;
  LinkObject: TRttiType);
Var
 PNode : TTreeNode;
 Node  : TTreeNode;
begin
   if ParentTask='' then
    Node:=TreeViewTasks.Items.AddObject(nil, Name, LinkObject)
   else
   begin
    PNode:=GetNodeByText(TreeViewTasks, ParentTask);
    Node:=TreeViewTasks.Items.AddChildObject(PNode, Name, LinkObject);
   end;

   Node.ImageIndex    :=ImageIndex;//add BN ??
   Node.SelectedIndex :=ImageIndex;
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

procedure TFrmMain.TreeViewTasksChange(Sender: TObject; Node: TTreeNode);
var
  LRttiInstanceType : TRttiInstanceType;
  LValue : TValue;
  LRttiProperty : TRttiProperty;
  LForm : TForm;
  LIndex : integer;
  ProcLog :  TProcLog;
begin
  if Node.Text<>'' then
  begin
     TabSheetTask.Caption:=Node.Text;

     for LIndex := 0 to TabSheetTask.ControlCount-1 do
      if (TabSheetTask.Controls[LIndex] is TForm) and (TForm(TabSheetTask.Controls[LIndex]).Visible) then
      begin
       TForm(TabSheetTask.Controls[LIndex]).Hide;
       break;
      end;

     if RegisteredInstances.ContainsKey(Node.Text) then
        RegisteredInstances.Items[Node.Text].Show
     else
     if Node.Data<>nil then
     begin
        LRttiInstanceType:=TRttiInstanceType(Node.Data);
        LValue:=LRttiInstanceType.GetMethod('Create').Invoke(LRttiInstanceType.MetaclassType,[Self]);
        LForm:=TForm(LValue.AsObject);
        LForm.Parent:=TabSheetTask;
        LForm.BorderStyle:=bsNone;
        LForm.Align:=alClient;

        LRttiProperty:=LRttiInstanceType.GetProperty('Console');
        if LRttiProperty<>nil then
         LRttiProperty.SetValue(LForm, MemoConsole);

        ProcLog:=SetMsg;
        LRttiProperty:=LRttiInstanceType.GetProperty('SetMsg');
        if LRttiProperty<>nil then
         LRttiProperty.SetValue(LForm, TValue.From<TProcLog>(ProcLog));

        ProcLog:=SetLog;
        LRttiProperty:=LRttiInstanceType.GetProperty('SetLog');
        if LRttiProperty<>nil then
         LRttiProperty.SetValue(LForm, TValue.From<TProcLog>(ProcLog));

        LRttiProperty:=LRttiInstanceType.GetProperty('Settings');
        if LRttiProperty<>nil then
         LRttiProperty.SetValue(LForm, FSettings);

        LRttiProperty:=LRttiInstanceType.GetProperty('NameSpace');
        if LRttiProperty<>nil then
         LRttiProperty.SetValue(LForm, Node.Text);


        LForm.Show;
        RegisteredInstances.Add(Node.Text, LForm);
     end;
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
