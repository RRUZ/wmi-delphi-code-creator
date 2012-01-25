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
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, SynEditHighlighter, SynHighlighterPas,
  SynEdit, ImgList, ToolWin, uWmiTree, uSettings, uWmi_Metadata,uWmiDatabase,
  Menus, Buttons, uComboBox, uWmiClassTree, SynHighlighterCpp, uSynEditPopupEdit,
  uCodeEditor;

const
  UM_EDITPARAMVALUE = WM_USER + 111;
  UM_EDITEVENTVALUE = WM_USER + 112;
  UM_EDITEVENTCOND  = WM_USER + 113;

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
    TabSheetEvents: TTabSheet;
    StatusBar1: TStatusBar;
    SynPasSyn1: TSynPasSyn;
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
    ComboBoxClassesMethods: TComboBox;
    LabelClassesMethods: TLabel;
    Label4:    TLabel;
    ComboBoxNamespaceMethods: TComboBox;
    ComboBoxMethods: TComboBox;
    LabelMethods: TLabel;
    ListViewMethodsParams: TListView;
    Label6:    TLabel;
    EditValueMethodParam: TEdit;
    PanelMethodInfo: TPanel;
    Splitter5: TSplitter;
    PanelMethodCode: TPanel;
    ListViewProperties: TListView;
    MemoMethodDescr: TMemo;
    TabSheetCodeGen: TTabSheet;
    PanelCodeGen: TPanel;
    PageControlCodeGen: TPageControl;
    PanelConsole: TPanel;
    Splitter4: TSplitter;
    Panel1:    TPanel;
    ListViewEventsConds: TListView;
    EditValueEvent: TEdit;
    ComboBoxCond: TComboBox;
    LabelEventsConds: TLabel;
    LabelTargetInstance: TLabel;
    LabelEvents: TLabel;
    Label2:    TLabel;
    ComboBoxNamespacesEvents: TComboBox;
    ComboBoxEvents: TComboBox;
    ComboBoxTargetInstance: TComboBox;
    Splitter6: TSplitter;
    PanelEventCode: TPanel;
    ToolButtonGetValues: TToolButton;
    Label3:    TLabel;
    EditEventWait: TEdit;
    Label5:    TLabel;
    ButtonGetValues: TButton;
    ButtonGenerateCodeInvoker: TButton;
    ButtonGenerateEventCode: TButton;
    ComboBoxPaths: TComboBox;
    CheckBoxPath: TCheckBox;
    TabSheetWmiDatabase: TTabSheet;
    RadioButtonIntrinsic: TRadioButton;
    RadioButtonExtrinsic: TRadioButton;
    Label7:    TLabel;
    ImageList1: TImageList;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    ToolButtonSettings: TToolButton;
    TabSheetTreeClasses: TTabSheet;
    SynCppSyn1: TSynCppSyn;
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
    procedure ComboBoxNamespacesEventsChange(Sender: TObject);
    procedure ComboBoxEventsChange(Sender: TObject);
    procedure ComboBoxTargetInstanceChange(Sender: TObject);
    procedure ComboBoxNamespaceMethodsChange(Sender: TObject);
    procedure ComboBoxClassesMethodsChange(Sender: TObject);
    procedure ComboBoxMethodsChange(Sender: TObject);
    procedure ListViewMethodsParamsClick(Sender: TObject);
    procedure EditValueMethodParamExit(Sender: TObject);
    procedure ButtonGenerateCodeInvokerClick(Sender: TObject);
    procedure PageControlMainChange(Sender: TObject);
    procedure EditValueEventExit(Sender: TObject);
    procedure ComboBoxCondExit(Sender: TObject);
    procedure ListViewEventsCondsClick(Sender: TObject);
    procedure ToolButtonGetValuesClick(Sender: TObject);
    procedure ButtonGenerateEventCodeClick(Sender: TObject);
    procedure ComboBoxPathsChange(Sender: TObject);
    procedure CheckBoxPathClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RadioButtonIntrinsicClick(Sender: TObject);
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
    FrmCodeEditorMethod   : TFrmCodeEditor;
    FrmCodeEditorEvent    : TFrmCodeEditor;

    Settings : TSettings;

    procedure UMEditValueParam(var msg: TMessage); message UM_EDITPARAMVALUE;
    procedure UMEditEventValue(var msg: TMessage); message UM_EDITEVENTVALUE;
    procedure UMEditEventCond(var msg: TMessage); message UM_EDITEVENTCOND;

    procedure LoadWmiMetaData;
    procedure LoadWmiEvents(const Namespace: string);
    procedure LoadWmiMethods(const Namespace: string);

    procedure LoadWmiProperties(WmiMetaClassInfo : TWMiClassMetaData);

    procedure GenerateMethodInvoker(WmiMetaClassInfo : TWMiClassMetaData);
    procedure GenerateEventCode(WmiMetaClassInfo : TWMiClassMetaData);

    procedure LoadEventsInfo;
    procedure LoadMethodInfo;
    procedure LoadParametersMethodInfo(WmiMetaClassInfo : TWMiClassMetaData);

    procedure SetToolBar;

    function ExistWmiNameSpaceCache: boolean;
    procedure LoadWMINameSpacesFromCache(List: TStrings);
    procedure SaveWMINameSpacesToCache(List: TStrings);

    function ExistWmiClassesCache(const namespace: string): boolean;
    function ExistWmiClassesMethodsCache(const namespace: string): boolean;
    procedure LoadWMIClassesFromCache(const namespace: string; List: TStrings);
    procedure LoadWMIClassesMethodsFromCache(const namespace: string; List: TStrings);

    procedure SaveWMIClassesToCache(const namespace: string; List: TStrings);
    procedure SaveWMIClassesMethodsToCache(const namespace: string; List: TStrings);

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
  VALUE_METHODPARAM_COLUMN = 2;
  COND_EVENTPARAM_COLUMN   = 2;
  VALUE_EVENTPARAM_COLUMN  = 3;

  PBS_MARQUEE    = $08;
  PBM_SETMARQUEE = (WM_USER + 10);

  WmiTableType_Class = 1;



{$R *.dfm}

{$R ManAdmin.RES}

{ TProgressBar }
procedure TProgressBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or PBS_MARQUEE;
end;

procedure TFrmMain.ButtonGenerateCodeInvokerClick(Sender: TObject);
begin
  GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
end;

procedure TFrmMain.ButtonGenerateEventCodeClick(Sender: TObject);
begin
  GenerateEventCode(TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]));
end;

procedure TFrmMain.ButtonGetValuesClick(Sender: TObject);
begin
  GetValuesWmiProperties(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

procedure TFrmMain.CheckBoxPathClick(Sender: TObject);
begin
  LoadParametersMethodInfo(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
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

procedure TFrmMain.ComboBoxClassesMethodsChange(Sender: TObject);
begin
  LoadMethodInfo;
end;

procedure TFrmMain.ComboBoxEventsChange(Sender: TObject);
begin
  LoadEventsInfo;
end;

procedure TFrmMain.ComboBoxMethodsChange(Sender: TObject);
begin
  LoadParametersMethodInfo(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
  GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
end;

procedure TFrmMain.ComboBoxNamespaceMethodsChange(Sender: TObject);
begin
  LoadWmiMethods(ComboBoxNamespaceMethods.Text);
end;

procedure TFrmMain.ComboBoxNameSpacesChange(Sender: TObject);
begin
  LoadWmiClasses(TComboBox(Sender).Text);
  ComboBoxClasses.ItemIndex := 0;
  LoadClassInfo;
end;

procedure TFrmMain.ComboBoxNamespacesEventsChange(Sender: TObject);
begin
  LoadWmiEvents(ComboBoxNamespacesEvents.Text);
end;

procedure TFrmMain.ComboBoxPathsChange(Sender: TObject);
begin
  GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
end;

procedure TFrmMain.ComboBoxTargetInstanceChange(Sender: TObject);
var
  i:    integer;
  Item: TListItem;
  WmiMetaClassInfo : TWMiClassMetaData;
begin

  ListVieweventsConds.Items.BeginUpdate;
  try
    for i := ListVieweventsConds.Items.Count - 1 downto 0 do
      if AnsiStartsStr(wbemTargetInstance, ListVieweventsConds.Items[i].Caption) then
        ListVieweventsConds.Items.Delete(i);

    if ComboBoxTargetInstance.Text <> '' then
    begin
      WmiMetaClassInfo := TWMiClassMetaData.Create(ComboBoxNamespacesEvents.Text, ComboBoxTargetInstance.Text);
      try
        for i := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
        begin
          Item := ListVieweventsConds.Items.Add;
          Item.Caption := Format('%s.%s', [wbemTargetInstance, WmiMetaClassInfo.Properties[i].Name]);
          Item.Data:=Pointer(WmiMetaClassInfo.Properties[i].CimType);
          Item.SubItems.Add(WmiMetaClassInfo.Properties[i].&Type);
          Item.SubItems.Add('');
          Item.SubItems.Add(GetDefaultValueWmiType(WmiMetaClassInfo.Properties[i].&Type));
          Item.SubItems.Add(WmiMetaClassInfo.Properties[i].Description);
        end;
      finally
        WmiMetaClassInfo.Free;
      end;
    end;

  finally
    ListVieweventsConds.Items.EndUpdate;
  end;

  AutoResizeColumns([ListViewEventsConds.Column[0], ListViewEventsConds.Column[1],
    ListViewEventsConds.Column[2]]);

  GenerateEventCode(TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]));
end;


function TFrmMain.ExistWmiClassesCache(const namespace: string): boolean;
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := ExtractFilePath(ParamStr(0)) + '\Cache\' + FileName + '.wmic';
  Result   := FileExists(FileName);
end;

function TFrmMain.ExistWmiClassesMethodsCache(const namespace: string): boolean;
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := ExtractFilePath(ParamStr(0)) + '\Cache\' + FileName + '_ClassMethods.wmic';
  Result   := FileExists(FileName);
end;

function TFrmMain.ExistWmiNameSpaceCache: boolean;
begin
  Result := FileExists(ExtractFilePath(ParamStr(0)) + '\Cache\Namespaces.wmic');
end;

procedure TFrmMain.FormActivate(Sender: TObject);
begin
  if not FDataLoaded then
    LoadWmiMetaData;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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
  FrmWmiClassTree.BorderStyle := bsNone;
  FrmWmiClassTree.Align := alClient;
  FrmWmiClassTree.Show;

  FrmCodeEditor  := TFrmCodeEditor.Create(Self);
  FrmCodeEditor.CodeGenerator:=GenerateCode;
  FrmCodeEditor.Parent := PanelCode;
  FrmCodeEditor.Show;
  FrmCodeEditor.Settings:=Settings;
  FrmCodeEditor.Console:=MemoConsole;
  FrmCodeEditor.CompilerType:=Ct_Delphi;


  FrmCodeEditorMethod  := TFrmCodeEditor.Create(Self);
  FrmCodeEditorMethod.CodeGenerator:=GenerateCode;
  FrmCodeEditorMethod.Parent := PanelMethodCode;
  FrmCodeEditorMethod.Show;
  FrmCodeEditorMethod.Settings:=Settings;
  FrmCodeEditorMethod.Console:=MemoConsole;
  FrmCodeEditorMethod.CompilerType:=Ct_Delphi;

  FrmCodeEditorEvent  := TFrmCodeEditor.Create(Self);
  FrmCodeEditorEvent.CodeGenerator:=GenerateCode;
  FrmCodeEditorEvent.Parent := PanelEventCode;
  FrmCodeEditorEvent.Show;
  FrmCodeEditorEvent.Settings:=Settings;
  FrmCodeEditorEvent.Console:=MemoConsole;
  FrmCodeEditorEvent.CompilerType:=Ct_Delphi;

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

  for i := 0 to ComboBoxClassesMethods.Items.Count-1 do
   if ComboBoxClassesMethods.Items.Objects[i]<>nil then
   begin
    TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[i]).Free;
    ComboBoxClassesMethods.Items.Objects[i]:=nil;
   end;

  for i := 0 to ComboBoxEvents.Items.Count-1 do
   if ComboBoxEvents.Items.Objects[i]<>nil then
   begin
    TWMiClassMetaData(ComboBoxEvents.Items.Objects[i]).Free;
    ComboBoxEvents.Items.Objects[i]:=nil;
   end;

  FrmWMIExplorer.Free;
  FrmWmiClassTree.Free;
  Settings.Free;
end;

procedure TFrmMain.GenerateCode;
begin

  if PageControlCodeGen.ActivePage=TabSheetWmiClasses then
   if ComboBoxClasses.ItemIndex>=0 then
     GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));

  if PageControlCodeGen.ActivePage=TabSheetMethods then
    if ComboBoxClassesMethods.ItemIndex>=0 then
      GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));

  if PageControlCodeGen.ActivePage=TabSheetEvents then
    if ComboBoxEvents.ItemIndex>=0 then
      GenerateEventCode(TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]));

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

procedure TFrmMain.GenerateMethodInvoker(WmiMetaClassInfo : TWMiClassMetaData);
var
  Namespace: string;
  WmiClass: string;
  WmiMethod: string;
  i:      integer;
  Params: TStringList;
  Values: TStringList;
  Str:    string;
  DelphiWmiCodeGenerator : TDelphiWmiMethodCodeGenerator;
  FPCWmiCodeGenerator : TFPCWmiMethodCodeGenerator;
  OxygenWmiCodeGenerator : TOxygenWmiMethodCodeGenerator;
  BorlandCppWmiCodeGenerator : TBorlandCppWmiMethodCodeGenerator;
begin
  if (ComboBoxClassesMethods.Text = '') or (ComboBoxMethods.Text = '') then
    exit;

  SetLog(Format('Generating code for %s:%s',[WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

  Namespace := ComboBoxNamespaceMethods.Text;
  WmiClass  := ComboBoxClassesMethods.Text;
  WmiMethod := ComboBoxMethods.Text;

  Params := TStringList.Create;
  Values := TStringList.Create;
  try

    Str := '';
    for i := 0 to ListViewMethodsParams.Items.Count - 1 do
    begin
      Str := Str + Format('%s=%s, ', [ListViewMethodsParams.Items[i].Caption,
        ListViewMethodsParams.Items[i].SubItems[0]]);
      if ListViewMethodsParams.Items[i].Checked then
        Values.AddObject(ListViewMethodsParams.Items[i].SubItems[1],ListViewMethodsParams.Items[i].Data)
      else
        Values.Add(WbemEmptyParam);
    end;

    Params.CommaText := Str;

    case FrmCodeEditorMethod.CompilerType of
      Ct_Delphi:
                 begin
                  DelphiWmiCodeGenerator :=TDelphiWmiMethodCodeGenerator.Create;
                  try
                    DelphiWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                    DelphiWmiCodeGenerator.WmiMethod:=WmiMethod;
                    DelphiWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    DelphiWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    DelphiWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    DelphiWmiCodeGenerator.GenerateCode(Params, Values);
                    FrmCodeEditorMethod.SourceCode:=DelphiWmiCodeGenerator.OutPutCode;
                  finally
                    DelphiWmiCodeGenerator.Free;
                  end;
                 end;

      Ct_BorlandCpp:
                 begin
                  BorlandCppWmiCodeGenerator :=TBorlandCppWmiMethodCodeGenerator.Create;
                  try
                    BorlandCppWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                    BorlandCppWmiCodeGenerator.WmiMethod:=WmiMethod;
                    BorlandCppWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    BorlandCppWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    BorlandCppWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    BorlandCppWmiCodeGenerator.GenerateCode(Params, Values);
                    FrmCodeEditorMethod.SourceCode:=BorlandCppWmiCodeGenerator.OutPutCode;
                  finally
                    BorlandCppWmiCodeGenerator.Free;
                  end;
                 end;

      Ct_Lazarus_FPC:
                 begin
                  FPCWmiCodeGenerator :=TFPCWmiMethodCodeGenerator.Create;
                  try
                    FPCWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                    FPCWmiCodeGenerator.WmiMethod:=WmiMethod;
                    FPCWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    FPCWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    FPCWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    FPCWmiCodeGenerator.GenerateCode(Params, Values);
                    FrmCodeEditorMethod.SourceCode:=FPCWmiCodeGenerator.OutPutCode;
                  finally
                    FPCWmiCodeGenerator.Free;
                  end;
                 end;

      Ct_Oxygene:
                 begin
                  OxygenWmiCodeGenerator :=TOxygenWmiMethodCodeGenerator.Create;
                  try
                    OxygenWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                    OxygenWmiCodeGenerator.WmiMethod:=WmiMethod;
                    OxygenWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    OxygenWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    OxygenWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    OxygenWmiCodeGenerator.GenerateCode(Params, Values);
                    FrmCodeEditorMethod.SourceCode:=OxygenWmiCodeGenerator.OutPutCode;
                  finally
                    OxygenWmiCodeGenerator.Free;
                  end;
                 end;
    end;


  finally
    Params.Free;
    Values.Free;
  end;
end;

procedure TFrmMain.GenerateEventCode;
var
  Namespace: string;
  WmiTargetInstance: string;
  WmiEvent: string;
  PollSeconds: integer;
  i:      integer;
  Params: TStringList;
  Values: TStringList;
  Conds:  TStringList;
  Str:    string;
  PropsOut: TStringList;
  DelphiWmiCodeGenerator : TDelphiWmiEventCodeGenerator;
  FPCWmiCodeGenerator : TFPCWmiEventCodeGenerator;
  OxygenWmiCodeGenerator : TOxygenWmiEventCodeGenerator;

begin
  if (ComboBoxNamespacesEvents.Text = '') or (ComboBoxEvents.Text = '') then
    exit;

  Namespace := ComboBoxNamespacesEvents.Text;
  WmiEvent  := ComboBoxEvents.Text;
  WmiTargetInstance := ComboBoxTargetInstance.Text;

  SetLog(Format('Generating code for %s:%s',[Namespace, WmiEvent]));

  if not TryStrToInt(EditEventWait.Text, PollSeconds) then
    PollSeconds := 0;

  Params   := TStringList.Create;
  Values   := TStringList.Create;
  Conds    := TStringList.Create;
  PropsOut := TStringList.Create;
  try

    for i := 0 to ListViewEventsConds.Items.Count - 1 do
      if (ListViewEventsConds.Items[i].Checked) then
        PropsOut.Add(ListViewEventsConds.Items[i].Caption);

    Str := '';
    for i := 0 to ListViewEventsConds.Items.Count - 1 do
      if (ListViewEventsConds.Items[i].Checked) and
        (ListViewEventsConds.Items[i].SubItems[1] <> '') then
      begin
        Str := Str + Format('%s=%s, ', [ListViewEventsConds.Items[i].Caption,
          ListViewEventsConds.Items[i].SubItems[0]]); //name + type
        Values.Add(ListViewEventsConds.Items[i].SubItems[2]);
        Conds.Add(ListViewEventsConds.Items[i].SubItems[1]);
      end;

    Params.CommaText := Str;

    case FrmCodeEditorEvent.CompilerType  of

      Ct_Delphi:
                 begin
                   DelphiWmiCodeGenerator := TDelphiWmiEventCodeGenerator.Create;
                   try
                      DelphiWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                      DelphiWmiCodeGenerator.WmiTargetInstance    := WmiTargetInstance;
                      DelphiWmiCodeGenerator.PollSeconds          := PollSeconds;
                      DelphiWmiCodeGenerator.ModeCodeGeneration   := TWmiCode(Settings.DelphiWmiEventCodeGenMode);
                      DelphiWmiCodeGenerator.GenerateCode(Params, Values, Conds, PropsOut);
                      FrmCodeEditorEvent.SourceCode:=DelphiWmiCodeGenerator.OutPutCode;
                   finally
                      DelphiWmiCodeGenerator.Free;
                   end;
                 end;

      Ct_Lazarus_FPC:
                 begin
                   FPCWmiCodeGenerator := TFPCWmiEventCodeGenerator.Create;
                   try
                      FPCWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                      FPCWmiCodeGenerator.WmiTargetInstance    := WmiTargetInstance;
                      FPCWmiCodeGenerator.PollSeconds          := PollSeconds;
                      FPCWmiCodeGenerator.ModeCodeGeneration   := TWmiCode(Settings.DelphiWmiEventCodeGenMode);
                      FPCWmiCodeGenerator.GenerateCode(Params, Values, Conds, PropsOut);
                      FrmCodeEditorEvent.SourceCode:=FPCWmiCodeGenerator.OutPutCode;
                   finally
                      FPCWmiCodeGenerator.Free;
                   end;
                 end;

      Ct_Oxygene:
                 begin
                   OxygenWmiCodeGenerator := TOxygenWmiEventCodeGenerator.Create;
                   try
                      OxygenWmiCodeGenerator.WMiClassMetaData:=WmiMetaClassInfo;
                      OxygenWmiCodeGenerator.WmiTargetInstance    := WmiTargetInstance;
                      OxygenWmiCodeGenerator.PollSeconds          := PollSeconds;
                      OxygenWmiCodeGenerator.ModeCodeGeneration   := TWmiCode(Settings.DelphiWmiEventCodeGenMode);
                      OxygenWmiCodeGenerator.GenerateCode(Params, Values, Conds, PropsOut);
                      FrmCodeEditorEvent.SourceCode:=OxygenWmiCodeGenerator.OutPutCode;
                   finally
                      OxygenWmiCodeGenerator.Free;
                   end;
                 end;

    end;

  finally
    Conds.Free;
    Params.Free;
    Values.Free;
    PropsOut.Free;
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

procedure TFrmMain.LoadEventsInfo;
var
  Item: TListItem;
  i:    integer;
  WmiMetaClassInfo : TWMiClassMetaData;
begin
  StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [ComboBoxNamespacesEvents.Text, ComboBoxEvents.Text]);
  //ListVieweventsConds
  ListVieweventsConds.Items.BeginUpdate;
  try
    ListVieweventsConds.Items.Clear;

    if ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]=nil then
    begin
      WmiMetaClassInfo:=TWMiClassMetaData.Create(ComboBoxNamespacesEvents.Text, ComboBoxEvents.Text);
      ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]:= WmiMetaClassInfo;
    end
    else
      WmiMetaClassInfo:=TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]);


    //GetListWmiClassPropertiesTypes(NameSpace, EventClass, List);
    LabelEventsConds.Caption :=
      Format('%d Properties of %s:%s', [WmiMetaClassInfo.PropertiesCount, WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);

    for i := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
    begin
      Item := ListVieweventsConds.Items.Add;
      Item.Checked := False;
      Item.Caption := WmiMetaClassInfo.Properties[i].Name;
      item.Data    := Pointer(WmiMetaClassInfo.Properties[i].CimType);
      Item.SubItems.Add(WmiMetaClassInfo.Properties[i].&Type);
      Item.SubItems.Add('');
      Item.SubItems.Add(GetDefaultValueWmiType(WmiMetaClassInfo.Properties[i].&Type));
      Item.SubItems.Add(WmiMetaClassInfo.Properties[i].Description);
    end;
  finally
    ListVieweventsConds.Items.EndUpdate;
    SetMsg('');
  end;
  {
  if CheckBoxSelAllProps.Checked then
  ListBoxProperties.SelectAll;
  }
  AutoResizeColumn(ListViewEventsConds.Column[0]);
  AutoResizeColumn(ListViewEventsConds.Column[1]);
  AutoResizeColumn(ListViewEventsConds.Column[2]);

  GenerateEventCode(TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]));
end;

procedure TFrmMain.LoadMethodInfo;
Var
  WmiMetaClassInfo : TWMiClassMetaData;
  i                : Integer;
begin
  if ComboBoxClassesMethods.ItemIndex=-1 then exit;

  ComboBoxMethods.Items.BeginUpdate;
  try
    ComboBoxMethods.Items.Clear;

    if ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]=nil then
    begin
      WmiMetaClassInfo:=TWMiClassMetaData.Create(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text);
      ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]:= WmiMetaClassInfo;
    end
    else
      WmiMetaClassInfo:=TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]);


    if ComboBoxClassesMethods.Text <> '' then
    begin

      {
      if Settings.ShowImplementedMethods then
        GetListWmiClassImplementedMethods(ComboBoxNamespaceMethods.Text,
          ComboBoxClassesMethods.Text, ComboBoxMethods.Items)
      else
        GetListWmiClassMethods(ComboBoxNamespaceMethods.Text,
          ComboBoxClassesMethods.Text, ComboBoxMethods.Items);
      }
      if Settings.ShowImplementedMethods then
        for i:= 0 to WmiMetaClassInfo.MethodsCount-1 do
        begin
         if WmiMetaClassInfo.Methods[i].Implemented then
           ComboBoxMethods.Items.Add(WmiMetaClassInfo.Methods[i].Name)
        end
      else
        for i:= 0 to WmiMetaClassInfo.MethodsCount-1 do
          ComboBoxMethods.Items.Add(WmiMetaClassInfo.Methods[i].Name);

      ComboBoxPaths.Items.Clear;
    end;

    LabelMethods.Caption := Format('Methods (%d)', [ComboBoxMethods.Items.Count]);
  finally
    ComboBoxMethods.Items.EndUpdate;
  end;

  if ComboBoxMethods.Items.Count > 0 then
    ComboBoxMethods.ItemIndex := 0
  else
    ComboBoxMethods.ItemIndex := -1;

  LoadParametersMethodInfo(WmiMetaClassInfo);
  GenerateMethodInvoker(WmiMetaClassInfo);
end;

procedure TFrmMain.LoadParametersMethodInfo(WmiMetaClassInfo : TWMiClassMetaData);
var
  i:    integer;
  Index : Integer;
  Item: TListItem;
begin
  if not Assigned(WmiMetaClassInfo) then exit;
  Index:=-1;
  ListViewMethodsParams.Items.BeginUpdate;
  try
    ListViewMethodsParams.Items.Clear;
    if (ComboBoxClassesMethods.Text <> '') and (ComboBoxMethods.Text <> '') then
    begin
      for i:=0 to WmiMetaClassInfo.MethodsCount-1 do
       if CompareText(WmiMetaClassInfo.Methods[i].Name,ComboBoxMethods.Text)=0 then
       begin
         Index:=i;
         break;
       end;

      if not WmiMetaClassInfo.Methods[Index].IsStatic and CheckBoxPath.Checked then
      begin
        GetWmiClassPath(WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass, ComboBoxPaths.Items);
        if ComboBoxPaths.Items.Count > 0 then
          ComboBoxPaths.ItemIndex := 0;
      end
      else
        ComboBoxPaths.Items.Clear;

      MemoMethodDescr.Text := WmiMetaClassInfo.Methods[Index].Description;

      if MemoMethodDescr.Text = '' then
        MemoMethodDescr.Text := 'Method without description available';

      //GetListWmiMethodInParameters(ComboBoxNamespaceMethods.Text,  ComboBoxClassesMethods.Text, ComboBoxMethods.Text, ParamsList, ParamsTypes, ParamsDescr);
    end;

    if Index>=0 then
    for i := 0 to WmiMetaClassInfo.Methods[Index].InParameters.Count - 1 do
    begin
      Item := ListViewMethodsParams.Items.Add;
      Item.Caption := WmiMetaClassInfo.Methods[Index].InParameters[i].Name;
      Item.Data    := Pointer(WmiMetaClassInfo.Methods[Index].InParameters[i].CimType);
      Item.SubItems.Add(WmiMetaClassInfo.Methods[Index].InParameters[i].&Type);
      Item.SubItems.Add(GetDefaultValueWmiType(WmiMetaClassInfo.Methods[Index].InParameters[i].&Type));
      Item.SubItems.Add(WmiMetaClassInfo.Methods[Index].InParameters[i].Description);
    end;
  finally
    ListViewMethodsParams.Items.EndUpdate;
  end;

  AutoResizeColumn(ListViewMethodsParams.Column[0]);
  AutoResizeColumn(ListViewMethodsParams.Column[1]);
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

procedure TFrmMain.LoadWMIClassesFromCache(const namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := ExtractFilePath(ParamStr(0)) + '\Cache\' + FileName + '.wmic';
  List.LoadFromFile(FileName);
end;

procedure TFrmMain.LoadWMIClassesMethodsFromCache(const namespace: string;
  List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := ExtractFilePath(ParamStr(0)) + '\Cache\' + FileName + '_ClassMethods.wmic';
  List.LoadFromFile(FileName);
end;

procedure TFrmMain.LoadWmiEvents(const Namespace: string);
var
  i : Integer;
begin
  ComboBoxEvents.Items.BeginUpdate;
  try

    for i := 0 to ComboBoxEvents.Items.Count-1 do
     if ComboBoxEvents.Items.Objects[i]<>nil then
     begin
      TWMiClassMetaData(ComboBoxEvents.Items.Objects[i]).Free;
      ComboBoxEvents.Items.Objects[i]:=nil;
     end;


    ComboBoxEvents.Items.Clear;

    if RadioButtonIntrinsic.Checked then
    begin
      GetListIntrinsicWmiEvents(Namespace, ComboBoxEvents.Items);
      ComboBoxTargetInstance.Visible := True;
      LabelTargetInstance.Visible    := True;
    end
    else
    begin
      GetListExtrinsicWmiEvents(Namespace, ComboBoxEvents.Items);
      ComboBoxTargetInstance.Visible := False;
      LabelTargetInstance.Visible    := False;
    end;

    LabelEvents.Caption := Format('Events (%d)', [ComboBoxEvents.Items.Count]);
  finally
    ComboBoxEvents.Items.EndUpdate;
  end;


  ComboBoxTargetInstance.Items.BeginUpdate;
  try

    if ExistWmiClassesCache(Namespace) then
      LoadWMIClassesFromCache(Namespace, ComboBoxTargetInstance.Items)
    else
    begin
      //GetListWmiDynamicAndStaticClasses(Namespace,ComboBoxTargetInstance.Items);
      GetListWmiClasses(Namespace, ComboBoxTargetInstance.Items, [], ['abstract'], True);
      SaveWMIClassesToCache(Namespace, ComboBoxTargetInstance.Items);
    end;

    ComboBoxTargetInstance.Items.Insert(0, '');
  finally
    ComboBoxTargetInstance.Items.EndUpdate;
  end;


  if ComboBoxEvents.Items.Count > 0 then
    ComboBoxEvents.ItemIndex := 0;

  LoadEventsInfo;
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

    if (DebugHook=0) and (CompareText(Settings.VCLStyle,'Windows')=0) then
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

    ComboBoxNamespacesEvents.Items.BeginUpdate;
    try
      ComboBoxNamespacesEvents.Items.AddStrings(FNameSpaces);
    finally
      ComboBoxNamespacesEvents.Items.EndUpdate;
    end;

    ComboBoxNamespaceMethods.Items.BeginUpdate;
    try
      ComboBoxNamespaceMethods.Items.AddStrings(FNameSpaces);
    finally
      ComboBoxNamespaceMethods.Items.EndUpdate;
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

    ComboBoxNamespacesEvents.ItemIndex := 0;
    LoadWmiEvents(ComboBoxNamespacesEvents.Text);

    ComboBoxNamespaceMethods.ItemIndex := 0;
    LoadWmiMethods(ComboBoxNamespaceMethods.Text);

    SetMsg('');
  finally
    FNameSpaces.Free;
    //Frm.Close;
    //Frm.Free;
  end;
end;

procedure TFrmMain.LoadWmiMethods(const Namespace: string);
var
  i  : Integer;
begin
  SetMsg(Format('Loading classes with methods in %s', [Namespace]));
  try

    for i := 0 to ComboBoxClassesMethods.Items.Count-1 do
     if ComboBoxClassesMethods.Items.Objects[i]<>nil then
     begin
      TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[i]).Free;
      ComboBoxClassesMethods.Items.Objects[i]:=nil;
     end;

    if not ExistWmiClassesMethodsCache(Namespace) then
    begin
      ComboBoxClassesMethods.Items.BeginUpdate;
      try
        GetListWmiClassesWithMethods(Namespace, ComboBoxClassesMethods.Items);
        LabelClassesMethods.Caption :=
          Format('Classes (%d)', [ComboBoxClassesMethods.Items.Count]);
        SaveWMIClassesMethodsToCache(Namespace, ComboBoxClassesMethods.Items);
      finally
        ComboBoxClassesMethods.Items.EndUpdate;
      end
    end
    else
      LoadWMIClassesMethodsFromCache(Namespace, ComboBoxClassesMethods.Items);

    if ComboBoxClassesMethods.Items.Count > 0 then
      ComboBoxClassesMethods.ItemIndex := 0
    else
      ComboBoxClassesMethods.ItemIndex := -1;

    LoadMethodInfo;
  finally
    SetMsg('');
  end;
end;

procedure TFrmMain.LoadWMINameSpacesFromCache(List: TStrings);
begin
  List.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\Cache\Namespaces.wmic');
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


procedure TFrmMain.SaveWMIClassesMethodsToCache(const namespace: string;
  List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := ExtractFilePath(ParamStr(0)) + '\Cache\' + FileName + '_ClassMethods.wmic';
  List.SaveToFile(FileName);
end;

procedure TFrmMain.SaveWMIClassesToCache(const namespace: string; List: TStrings);
var
  FileName: string;
begin
  FileName := StringReplace(namespace, '\', '%', [rfReplaceAll]);
  FileName := ExtractFilePath(ParamStr(0)) + '\Cache\' + FileName + '.wmic';
  List.SaveToFile(FileName);
end;

procedure TFrmMain.SaveWMINameSpacesToCache(List: TStrings);
begin
  List.SaveToFile(ExtractFilePath(ParamStr(0)) + '\Cache\Namespaces.wmic');
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

procedure TFrmMain.RadioButtonIntrinsicClick(Sender: TObject);
begin
  LoadWmiEvents(ComboBoxNamespacesEvents.Text);
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


procedure TFrmMain.ComboBoxCondExit(Sender: TObject);
begin
  if Assigned(FItem) then
  begin
    FItem.SubItems[COND_EVENTPARAM_COLUMN - 1] := TComboBox(Sender).Text;
    FItem := nil;
  end;
  PostMessage(handle, WM_NEXTDLGCTL, ListViewEventsConds.Handle, 1);
  TComboBox(Sender).Visible := True;
end;

procedure TFrmMain.EditValueEventExit(Sender: TObject);
begin
  if Assigned(FItem) then
  begin
    FItem.SubItems[VALUE_EVENTPARAM_COLUMN - 1] := TEdit(Sender).Text;
    FItem := nil;
  end;
  PostMessage(handle, WM_NEXTDLGCTL, ListViewEventsConds.Handle, 1);
  TEdit(Sender).Visible := True;
end;

procedure TFrmMain.EditValueMethodParamExit(Sender: TObject);
begin
  if Assigned(FItem) then
  begin
    FItem.SubItems[VALUE_METHODPARAM_COLUMN - 1] := TEdit(Sender).Text;
    FItem := nil;
  end;
  PostMessage(handle, WM_NEXTDLGCTL, ListViewMethodsParams.Handle, 1);
  TEdit(Sender).Visible := True;

  GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
end;

procedure TFrmMain.ListViewEventsCondsClick(Sender: TObject);
var
  pt: TPoint;
  HitTestInfo: TLVHitTestInfo;
begin
  EditValueEvent.Visible := False;
  ComboBoxCond.Visible   := False;

  pt := TListView(Sender).ScreenToClient(Mouse.CursorPos);
  FillChar(HitTestInfo, SizeOf(HitTestInfo), 0);
  HitTestInfo.pt := pt;

  if (-1 <> TListView(Sender).Perform(LVM_SUBITEMHITTEST, 0,
    lparam(@HitTestInfo))) and
    (HitTestInfo.iSubItem = VALUE_EVENTPARAM_COLUMN) then
    PostMessage(Self.Handle, UM_EDITEVENTVALUE, HitTestInfo.iItem, 0)
  else
  if (-1 <> TListView(Sender).Perform(LVM_SUBITEMHITTEST, 0,
    lparam(@HitTestInfo))) and
    (HitTestInfo.iSubItem = COND_EVENTPARAM_COLUMN) then
    PostMessage(Self.Handle, UM_EDITEVENTCOND, HitTestInfo.iItem, 0);

  GenerateEventCode(TWMiClassMetaData(ComboBoxEvents.Items.Objects[ComboBoxEvents.ItemIndex]));
end;

procedure TFrmMain.ListViewMethodsParamsClick(Sender: TObject);
var
  pt: TPoint;
  HitTestInfo: TLVHitTestInfo;
begin
  if TListView(Sender).Items.Count=0  then exit;

  EditValueMethodParam.Visible := False;
  pt := TListView(Sender).ScreenToClient(Mouse.CursorPos);
  FillChar(HitTestInfo, sizeof(HitTestInfo), 0);
  HitTestInfo.pt := pt;
  if (-1 <> TListView(Sender).Perform(LVM_SUBITEMHITTEST, 0,
    lparam(@HitTestInfo))) and
    (HitTestInfo.iSubItem = VALUE_METHODPARAM_COLUMN) then
    PostMessage(Self.Handle, UM_EDITPARAMVALUE, HitTestInfo.iItem, 0);

  GenerateMethodInvoker(TWMiClassMetaData(ComboBoxClassesMethods.Items.Objects[ComboBoxClassesMethods.ItemIndex]));
end;


procedure TFrmMain.UMEditEventCond(var msg: TMessage);
var
  SubItemRect: TRect;
begin
  ComboBoxCond.Visible := True;
  ComboBoxCond.BringToFront;

  SubItemRect.Top  := COND_EVENTPARAM_COLUMN;
  SubItemRect.Left := LVIR_BOUNDS;
  ListViewEventsConds.Perform(LVM_GETSUBITEMRECT, msg.wparam, lparam(@SubItemRect));
  MapWindowPoints(ListViewEventsConds.Handle, ComboBoxCond.Parent.Handle,
    SubItemRect, 2);
  FItem := ListViewEventsConds.Items[msg.wparam];

  try
    ComboBoxCond.ItemIndex :=
      ComboBoxCond.Items.IndexOf(Fitem.Subitems[COND_EVENTPARAM_COLUMN - 1]);
  except
    ComboBoxCond.ItemIndex := 0;
  end;

  ComboBoxCond.BoundsRect := SubItemRect;
  ComboBoxCond.SetFocus;
end;

procedure TFrmMain.UMEditEventValue(var msg: TMessage);
var
  SubItemRect: TRect;
begin
  EditValueEvent.Visible := True;
  EditValueEvent.BringToFront;
  SubItemRect.Top  := VALUE_EVENTPARAM_COLUMN;
  SubItemRect.Left := LVIR_BOUNDS;
  ListViewEventsConds.Perform(LVM_GETSUBITEMRECT, msg.wparam, lparam(@SubItemRect));
  MapWindowPoints(ListViewEventsConds.Handle, EditValueEvent.Parent.Handle,
    SubItemRect, 2);
  FItem := ListViewEventsConds.Items[msg.wparam];
  EditValueEvent.Text := Fitem.Subitems[VALUE_EVENTPARAM_COLUMN - 1];
  EditValueEvent.BoundsRect := SubItemRect;
  EditValueEvent.SetFocus;
end;

procedure TFrmMain.UMEditValueParam(var msg: TMessage);
var
  SubItemRect: TRect;
begin
  EditValueMethodParam.Visible := True;
  EditValueMethodParam.BringToFront;
  SubItemRect.Top  := VALUE_METHODPARAM_COLUMN;
  SubItemRect.Left := LVIR_BOUNDS;
  ListViewMethodsParams.Perform(LVM_GETSUBITEMRECT, msg.wparam,
    lparam(@SubItemRect));
  MapWindowPoints(ListViewMethodsParams.Handle, EditValueMethodParam.Parent.Handle,
    SubItemRect, 2);
  FItem := ListViewMethodsParams.Items[msg.wparam];
  EditValueMethodParam.Text := Fitem.Subitems[VALUE_METHODPARAM_COLUMN - 1];
  EditValueMethodParam.BoundsRect := SubItemRect;
  EditValueMethodParam.SetFocus;
end;


initialization

   if not IsStyleHookRegistered(TCustomSynEdit, TScrollingStyleHook) then
     TStyleManager.Engine.RegisterStyleHook(TCustomSynEdit, TScrollingStyleHook);

   TStyleManager.Engine.UnRegisterStyleHook(TCustomTabControl, TTabControlStyleHook);
   TStyleManager.Engine.RegisterStyleHook(TCustomTabControl, TMyTabControlStyleHook);

end.
