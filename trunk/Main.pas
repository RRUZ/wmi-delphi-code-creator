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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit Main;

interface


//TODO
{
  Fix disabled icons
  Remote machine support
  Improve source code
  Add automated tests
  Store cache x machine
  Create code based in plugins and interfaces
}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  SynEdit, ImgList, ToolWin, uWmiTree, uSettings, uWmi_Metadata,uWmiDatabase,
  Menus, Buttons, uComboBox, uWmiClassTree,
  uCodeEditor, uWmiEvents, uWmiMethods;


type
  TProgressBar = class(ComCtrls.TProgressBar)
    procedure CreateParams(var Params: TCreateParams); override;
  end;


  TFrmMain = class(TForm)
    PanelMain: TPanel;
    PageControlMain: TPageControl;
    TabSheetWmiClasses: TTabSheet;
    TabSheetWmiExplorer: TTabSheet;
    TabSheetMethods: TTabSheet;
    StatusBar1: TStatusBar;
    PanelMetaWmiInfo: TPanel;
    PanelCode: TPanel;
    LabelProperties: TLabel;
    LabelClasses: TLabel;
    ComboBoxClasses: TComboBox;
    ComboBoxNameSpaces: TComboBox;
    LabelNamespace: TLabel;
    Splitter1: TSplitter;
    CheckBoxSelAllProps: TCheckBox;
    ToolBar1:  TToolBar;
    ToolButtonSearch: TToolButton;
    ToolButtonAbout: TToolButton;
    ToolButton4: TToolButton;
    MemoClassDescr: TMemo;
    ToolButtonOnline: TToolButton;
    TabSheet6: TTabSheet;
    MemoLog:   TMemo;
    ProgressBarWmi: TProgressBar;
    MemoConsole: TMemo;
    ListViewProperties: TListView;
    TabSheetCodeGen: TTabSheet;
    PanelCodeGen: TPanel;
    PageControlCodeGen: TPageControl;
    PanelConsole: TPanel;
    Splitter4: TSplitter;
    ToolButtonGetValues: TToolButton;
    ButtonGetValues: TButton;
    TabSheetWmiDatabase: TTabSheet;
    ImageList1: TImageList;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    ToolButtonSettings: TToolButton;
    TabSheetTreeClasses: TTabSheet;
    TabSheetEvents: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBoxNameSpacesChange(Sender: TObject);
    procedure ComboBoxClassesChange(Sender: TObject);
    procedure ListBoxPropertiesClick(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
    procedure ButtonGetValuesClick(Sender: TObject);
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
    { Private declarations }
    FrmWmiDatabase: TFrmWmiDatabase;
    FDataLoaded: boolean;
    FItem:      TListitem;
    FrmWMIExplorer  : TFrmWMITree;
    FrmWmiClassTree : TFrmWmiClassTree;

    FrmCodeEditor         : TFrmCodeEditor;
    FrmWmiEvents          : TFrmWmiEvents;
    FrmWmiMethods         : TFrmWmiMethods;

    Settings : TSettings;
    procedure LoadWmiMetaData;
    procedure LoadWmiProperties(WmiMetaClassInfo : TWMiClassMetaData);
    procedure SetToolBar;
    procedure SetLog(const Log :string);
    procedure GenerateCode;
  public
    procedure SetMsg(const Msg: string);
    procedure LoadWmiClasses(const Namespace: string);
    procedure LoadClassInfo;
    procedure GenerateConsoleCode(WmiMetaClassInfo : TWMiClassMetaData);
    procedure GetValuesWmiProperties(const Namespace, WmiClass: string);
  end;


var
  FrmMain: TFrmMain;

implementation

uses
  Rtti,
  uXE2Patches,
  Vcl.Styles.Ext,
  VCl.Themes,
  ComObj,
  ShellApi,
  CommCtrl,
  StrUtils,
  uWmi_About,
  uSelectCompilerVersion,
  uWmi_ViewPropsValues,
  uListView_Helper,
  uDelphiIDE,
  uBorlandCppIDE,
  uLazarusIDE,
  uDelphiPrismIDE,
  uDelphiPrismHelper,
  uWmiGenCode,
  uWmiDelphiCode,
  uWmiOxygenCode,
  uWmiFPCCode,
  uWmiBorlandCppCode,
  uMisc;

const
  PBS_MARQUEE    = $08;
  PBM_SETMARQUEE = (WM_USER + 10);

{$R *.dfm}

{$R ManAdmin.RES}

{ TProgressBar }
procedure TProgressBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or PBS_MARQUEE;
end;

procedure TFrmMain.ButtonGetValuesClick(Sender: TObject);
begin
  GetValuesWmiProperties(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

procedure TFrmMain.CheckBoxSelAllPropsClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ListViewProperties.Items.Count - 1 do
    ListViewProperties.Items[i].Checked := CheckBoxSelAllProps.Checked;

  GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));
end;

procedure TFrmMain.ComboBoxClassesChange(Sender: TObject);
begin
  LoadClassInfo;
end;

procedure TFrmMain.ComboBoxNameSpacesChange(Sender: TObject);
begin
  LoadWmiClasses(TComboBox(Sender).Text);
  ComboBoxClasses.ItemIndex := 0;
  LoadClassInfo;
end;

procedure TFrmMain.FormActivate(Sender: TObject);
begin
  if not FDataLoaded then
    LoadWmiMetaData;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmWmiEvents.Close();
  FrmWmiMethods.Close();

  Settings.LastWmiNameSpace:=ComboBoxNameSpaces.Text;
  Settings.LastWmiClass:=ComboBoxClasses.Text;


  WriteSettings(Settings);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  ProgressBarStyle: integer;
begin
  ReportMemoryLeaksOnShutdown:=DebugHook<>0;
  Settings :=TSettings.Create;
  SetToolBar;

  SetLog('Reading settings');
  ReadSettings(Settings);
  LoadVCLStyle(Settings.VCLStyle);

  MemoConsole.Color:=Settings.BackGroundColor;
  MemoConsole.Font.Color:=Settings.ForeGroundColor;

  MemoLog.Color:=MemoConsole.Color;
  MemoLog.Font.Color:=MemoConsole.Font.Color;

  FDataLoaded := False;
  StatusBar1.Panels[2].Text := Format('WMI installed version %s      ', [GetWmiVersion]);

  ProgressBarWmi.Parent := StatusBar1;
  ProgressBarStyle      := GetWindowLong(ProgressBarWmi.Handle, GWL_EXSTYLE);
  ProgressBarStyle      := ProgressBarStyle - WS_EX_STATICEDGE;
  SetWindowLong(ProgressBarWmi.Handle, GWL_EXSTYLE, ProgressBarStyle);
  ProgressBarWmi.Perform(PBM_SETMARQUEE, 1, 100);

  FrmWmiDatabase := TFrmWmiDatabase.Create(Self);
  FrmWmiDatabase.Parent := TabSheetWmiDatabase;
  FrmWmiDatabase.BorderStyle := bsNone;
  FrmWmiDatabase.Align := alClient;
  FrmWmiDatabase.Status:=SetMsg;
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

  FrmWMIExplorer.Show;

  FrmWmiClassTree := TFrmWmiClassTree.Create(Self);
  FrmWmiClassTree.Parent := TabSheetTreeClasses;
  FrmWmiClassTree.Align := alClient;
  FrmWmiClassTree.Show;

  FrmCodeEditor  := TFrmCodeEditor.Create(Self);
  FrmCodeEditor.CodeGenerator:=GenerateCode;
  FrmCodeEditor.Parent := PanelCode;
  FrmCodeEditor.Show;
  FrmCodeEditor.Settings:=Settings;
  FrmCodeEditor.Console:=MemoConsole;
  FrmCodeEditor.CompilerType:=Ct_Delphi;


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
end;


procedure TFrmMain.FormDestroy(Sender: TObject);
var
 i : Integer;
begin
  for i := 0 to ComboBoxClasses.Items.Count-1 do
   if ComboBoxClasses.Items.Objects[i]<>nil then
   begin
    TWMiClassMetaData(ComboBoxClasses.Items.Objects[i]).Free;
    ComboBoxClasses.Items.Objects[i]:=nil;
   end;



  FrmWmiEvents.Free;
  FrmWmiMethods.Free;

  FrmWMIExplorer.Free;
  FrmWmiClassTree.Free;
  Settings.Free;
end;

procedure TFrmMain.GenerateCode;
begin

  if PageControlCodeGen.ActivePage=TabSheetWmiClasses then
   if ComboBoxClasses.ItemIndex>=0 then
     GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));

      {
  if PageControlCodeGen.ActivePage=TabSheetMethods then
    if ComboBoxClassesMethods.ItemIndex>=0 then
      GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));


  if PageControlCodeGen.ActivePage=TabSheetEvents then
    if ComboBoxEvents.ItemIndex>=0 then
      GenerateEventCode(TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]));
       }
end;

procedure TFrmMain.GenerateConsoleCode(WmiMetaClassInfo : TWMiClassMetaData);
var
  i,j:     integer;
  Props: TStrings;
  Str:  string;
  DelphiWmiCodeGenerator : TDelphiWmiClassCodeGenerator;
  FPCWmiCodeGenerator    : TFPCWmiClassCodeGenerator;
  OxygenWmiCodeGenerator : TOxygenWmiClassCodeGenerator;
  CppWmiCodeGenerator    : TBorlandCppWmiClassCodeGenerator;

begin
  if not Assigned(WmiMetaClassInfo) then Exit;

  SetLog(Format('Generating code for %s:%s',[WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

  //Object Pascal console Code
  Props := TStringList.Create;
  try
    Str := '';
    for i := 0 to ListViewProperties.Items.Count - 1 do
      if ListViewProperties.Items[i].Checked then
        Str := Str + Format('%s=%s, ', [ListViewProperties.Items[i].Caption,
          ListViewProperties.Items[i].SubItems[0]]);

    Props.CommaText := Str;

    j:=0;
    for i := 0 to ListViewProperties.Items.Count - 1 do
      if ListViewProperties.Items[i].Checked then
      begin
        Props.Objects[j]:=ListViewProperties.Items[i].Data;//CimType
        inc(j);
      end;

    case FrmCodeEditor.CompilerType of
      Ct_Delphi:
                  begin
                    DelphiWmiCodeGenerator:=TDelphiWmiClassCodeGenerator.Create;
                    try
                      DelphiWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      DelphiWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      DelphiWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      DelphiWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=DelphiWmiCodeGenerator.OutPutCode;
                    finally
                      DelphiWmiCodeGenerator.Free;
                    end;
                  end;


      Ct_Lazarus_FPC:
                  begin
                    FPCWmiCodeGenerator:=TFPCWmiClassCodeGenerator.Create;
                    try
                      FPCWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      FPCWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      FPCWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      FPCWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=FPCWmiCodeGenerator.OutPutCode;
                    finally
                      FPCWmiCodeGenerator.Free;
                    end;
                  end;


      Ct_Oxygene:
                  begin
                    OxygenWmiCodeGenerator:=TOxygenWmiClassCodeGenerator.Create;
                    try
                      OxygenWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      OxygenWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      OxygenWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      OxygenWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=OxygenWmiCodeGenerator.OutPutCode;
                    finally
                      OxygenWmiCodeGenerator.Free;
                    end;
                  end;

      Ct_BorlandCpp:
                  begin
                    CppWmiCodeGenerator:=TBorlandCppWmiClassCodeGenerator.Create;
                    try
                      CppWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      CppWmiCodeGenerator.UseHelperFunctions:=false;//Settings.DelphiWmiClassHelperFuncts;
                      CppWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      CppWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=CppWmiCodeGenerator.OutPutCode;
                    finally
                      CppWmiCodeGenerator.Free;
                    end;
                  end;

    end;

  finally
    Props.Free;
  end;
end;


procedure TFrmMain.GetValuesWmiProperties(const Namespace, WmiClass: string);
var
  Props: TStringList;
  i    : Integer;
begin
  if (ListViewProperties.Items.Count > 0) and (WmiClass <> '') and (Namespace <> '') then
  begin
    Props:=TStringList.Create;
    try
      for i := 0 to ListViewProperties.Items.Count - 1 do
        if ListViewProperties.Items[i].Checked then
          Props.Add(ListViewProperties.Items[i].Caption);

      ListValuesWmiProperties(Namespace, WmiClass, Props);
    finally
     Props.Free;
    end;
  end;
end;

procedure TFrmMain.ListBoxPropertiesClick(Sender: TObject);
begin
  CheckBoxSelAllProps.Checked := False;
  GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));
end;

procedure TFrmMain.LoadClassInfo;
var
  WmiMetaClassInfo : TWMiClassMetaData;
begin
  if ComboBoxClasses.ItemIndex=-1 then exit;

  ProgressBarWmi.Visible := True;
  try
    if ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]=nil then
    begin
      WmiMetaClassInfo:=TWMiClassMetaData.Create(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
      ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]:= WmiMetaClassInfo;
    end
    else
      WmiMetaClassInfo:=TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]);

    if Assigned(WmiMetaClassInfo) then
    begin
      SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));
      MemoClassDescr.Text :=  WmiMetaClassInfo.Description; //GetWmiClassDescription(Namespace, WmiClass);
      if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';

      //LoadWmiProperties(Namespace, WmiClass);
      LoadWmiProperties(WmiMetaClassInfo);
      FrmWMIExplorer.LoadClassInfo(WmiMetaClassInfo);
    end;
  finally
    SetMsg('');
    ProgressBarWmi.Visible := False;
  end;
end;



procedure TFrmMain.LoadWmiClasses(const Namespace: string);
var
  Node: TTreeNode;
  NodeC: TTreeNode;
  FClasses: TStringList;
  i: integer;
begin
  SetMsg(Format('Loading Classes of %s', [Namespace]));
  Node := FindTextTreeView(Namespace, FrmWMIExplorer.TreeViewWmiClasses);
  if Assigned(Node) then
  begin

    for i := 0 to ComboBoxClasses.Items.Count-1 do
     if ComboBoxClasses.Items.Objects[i]<>nil then
     begin
      TWMiClassMetaData(ComboBoxClasses.Items.Objects[i]).Free;
      ComboBoxClasses.Items.Objects[i]:=nil;
     end;


    if Assigned(Node.Data) then
    begin
      FClasses := TStringList(Node.Data);
      ComboBoxClasses.Items.BeginUpdate;
      try
        ComboBoxClasses.Items.Clear;
        ComboBoxClasses.Items.AddStrings(FClasses);
        LabelClasses.Caption := Format('Classes (%d)', [FClasses.Count]);
      finally
        ComboBoxClasses.Items.EndUpdate;
      end;
    end
    else
    begin
      FClasses := TStringList.Create;
      FClasses.Sorted := True;
      FClasses.BeginUpdate;

      try

        try
          if not ExistWmiClassesCache(Namespace) then
          begin
            //GetListWmiDynamicAndStaticClasses(Namespace,FClasses);
            //GetListWmiClasses(Namespace,FClasses,['dynamic','static'],['abstract'],False);
            GetListWmiClasses(Namespace, FClasses, [], ['abstract'], True);
            SaveWMIClassesToCache(Namespace, FClasses);
          end
          else
            LoadWMIClassesFromCache(Namespace, FClasses);

        except
          on E: EOleSysError do
            if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
              SetLog(
                Format('Access denied  %s %s  Code : %x', ['GetListWmiClasses', E.Message, E.ErrorCode]))
            else
              raise;
        end;

      finally
        FClasses.EndUpdate;
      end;

      ComboBoxClasses.Items.BeginUpdate;
      try
        ComboBoxClasses.Items.Clear;
        ComboBoxClasses.Items.AddStrings(FClasses);
        LabelClasses.Caption := Format('Classes (%d)', [FClasses.Count]);
      finally
        ComboBoxClasses.Items.EndUpdate;
      end;

      FrmWMIExplorer.TreeViewWmiClasses.Items.BeginUpdate;
      Node.Data := FClasses;
      try
        for i := 0 to FClasses.Count - 1 do
        begin
          NodeC := FrmWMIExplorer.TreeViewWmiClasses.Items.AddChild(Node, FClasses[i]);
          NodeC.ImageIndex := ClassImageIndex;
          NodeC.SelectedIndex := ClassImageIndex;
        end;
      finally
        FrmWMIExplorer.TreeViewWmiClasses.Items.EndUpdate;
      end;
    end;
  end
  else
    MsgWarning(Namespace + ' not found');

  SetMsg('');
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

    if (DebugHook=0) and (SameText(Settings.VCLStyle,'Windows')) then
    Frm.Show;

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
        LabelNamespace.Caption := Format('Namespaces (%d)', [FNameSpaces.Count]);
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

    ComboBoxNameSpaces.Items.BeginUpdate;
    try
      ComboBoxNameSpaces.Items.AddStrings(FNameSpaces);
    finally
      ComboBoxNameSpaces.Items.EndUpdate;
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
      ComboBoxNameSpaces.ItemIndex := ComboBoxNameSpaces.Items.IndexOf(Settings.LastWmiNameSpace)
    else
      ComboBoxNameSpaces.ItemIndex := 0;

    LoadWmiClasses(ComboBoxNameSpaces.Text);
    if Settings.LastWmiClass<>'' then
      ComboBoxClasses.ItemIndex := ComboBoxClasses.Items.IndexOf(Settings.LastWmiClass)
    else
      ComboBoxClasses.ItemIndex := 0;


    LoadClassInfo;

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


procedure TFrmMain.LoadWmiProperties(WmiMetaClassInfo : TWMiClassMetaData);
var
  i:     integer;
  //Props: TStringList;
  item:  TListItem;
begin
  StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
  ListViewProperties.Items.BeginUpdate;
  try
    ListViewProperties.Items.Clear;

    for i := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
    begin
      item := ListViewProperties.Items.Add;
      item.Caption := WmiMetaClassInfo.Properties[i].Name;
      item.SubItems.Add(WmiMetaClassInfo.Properties[i].&Type);
      item.SubItems.Add(WmiMetaClassInfo.Properties[i].Description);
      item.Checked := CheckBoxSelAllProps.Checked;
      item.Data    := Pointer(WmiMetaClassInfo.Properties[i].CimType); //Cimtype
    end;

    LabelProperties.Caption := Format('%d Properties of %s:%s',
      [ListViewProperties.Items.Count, WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
  finally
    ListViewProperties.Items.EndUpdate;
  end;
  SetMsg('');

  for i := 0 to ListViewProperties.Columns.Count - 1 do
    AutoResizeColumn(ListViewProperties.Column[i]);

  GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));
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

procedure TFrmMain.SetToolBar;
begin
  {
  ToolButtonRun.Enabled    := (PageControlMain.ActivePage = TabSheetCodeGen);
  ToolButtonSave.Enabled   := (PageControlMain.ActivePage = TabSheetCodeGen);
  ToolButtonSearch.Enabled := (PageControlMain.ActivePage = TabSheetWmiExplorer);
  ToolButtonGetValues.Enabled := (PageControlMain.ActivePage = TabSheetWmiExplorer);
  }
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
  ShellExecute(Handle, 'open', PChar(Format(UrlWmiHelp, [ComboBoxClasses.Text])), nil,
    nil, SW_SHOW);
end;

procedure TFrmMain.ToolButtonAboutClick(Sender: TObject);
var
  Frm: TFrmAbout;
begin
  Frm := TFrmAbout.Create(nil);
  try
    Frm.ShowModal();
  finally
    //Frm.Free;
  end;
end;

procedure TFrmMain.ToolButtonGetValuesClick(Sender: TObject);
begin
  GetValuesWmiProperties(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

procedure TFrmMain.PageControlMainChange(Sender: TObject);
begin
  SetToolBar;
  if PageControlMain.ActivePage = TabSheetWmiDatabase then
  begin
   FrmWmiDatabase.NameSpaces.Clear;
   FrmWmiDatabase.NameSpaces.AddStrings(ComboBoxNameSpaces.Items);
  end;
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
    ReadSettings(Settings);
  end;
end;


initialization

if not IsStyleHookRegistered(TCustomSynEdit, TScrollingStyleHook) then
 TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);

TStyleManager.Engine.UnRegisterStyleHook(TCustomTabControl, TTabControlStyleHook);
TStyleManager.Engine.RegisterStyleHook(TCustomTabControl, TMyTabControlStyleHook);

end.
