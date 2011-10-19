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
  SynEdit, ImgList, ToolWin, uWmiTree, uSettings,
  Menus, Buttons, uComboBox, uWmiClassTree, SynHighlighterCpp;

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
    SynEditWMIClassCode: TSynEdit;
    LabelProperties: TLabel;
    LabelClasses: TLabel;
    ComboBoxClasses: TComboBox;
    ComboBoxNameSpaces: TComboBox;
    LabelNamespace: TLabel;
    Splitter1: TSplitter;
    CheckBoxSelAllProps: TCheckBox;
    ToolBar1:  TToolBar;
    ToolButtonRun: TToolButton;
    ToolButtonSave: TToolButton;
    SaveDialog1: TSaveDialog;
    ToolButtonSearch: TToolButton;
    PageControlCode: TPageControl;
    TabSheetWmiClassCode: TTabSheet;
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
    PopupMenu1: TPopupMenu;
    CompileCode1: TMenuItem;
    Run1:      TMenuItem;
    OpeninDelphi1: TMenuItem;
    PanelMethodInfo: TPanel;
    Splitter5: TSplitter;
    Panel3:    TPanel;
    PageControl1: TPageControl;
    TabSheetWmiMethodCode: TTabSheet;
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
    Panel5:    TPanel;
    PageControl3: TPageControl;
    TabSheet1: TTabSheet;
    ToolButtonGetValues: TToolButton;
    Label3:    TLabel;
    EditEventWait: TEdit;
    Label5:    TLabel;
    ButtonGetValues: TButton;
    ButtonGenerateCodeInvoker: TButton;
    ButtonGenerateEventCode: TButton;
    SynEditWMIMethodCode: TSynEdit;
    SynEditEventCode: TSynEdit;
    PanelLanguageSet: TPanel;
    ComboBoxLanguageSel: TComboBox;
    Label8:    TLabel;
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
    procedure ToolButtonSaveClick(Sender: TObject);
    procedure ButtonGetValuesClick(Sender: TObject);
    procedure ToolButtonOnlineClick(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure ToolButtonSearchClick(Sender: TObject);
    procedure ComboBoxNamespacesEventsChange(Sender: TObject);
    procedure ComboBoxEventsChange(Sender: TObject);
    procedure ToolButtonRunClick(Sender: TObject);
    procedure ComboBoxTargetInstanceChange(Sender: TObject);
    procedure ComboBoxNamespaceMethodsChange(Sender: TObject);
    procedure ComboBoxClassesMethodsChange(Sender: TObject);
    procedure ComboBoxMethodsChange(Sender: TObject);
    procedure ListViewMethodsParamsClick(Sender: TObject);
    procedure EditValueMethodParamExit(Sender: TObject);
    procedure OpeninDelphi1Click(Sender: TObject);
    procedure ButtonGenerateCodeInvokerClick(Sender: TObject);
    procedure PageControlMainChange(Sender: TObject);
    procedure EditValueEventExit(Sender: TObject);
    procedure ComboBoxCondExit(Sender: TObject);
    procedure ListViewEventsCondsClick(Sender: TObject);
    procedure ToolButtonGetValuesClick(Sender: TObject);
    procedure ButtonGenerateEventCodeClick(Sender: TObject);
    procedure ComboBoxLanguageSelChange(Sender: TObject);
    procedure ComboBoxPathsChange(Sender: TObject);
    procedure CheckBoxPathClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RadioButtonIntrinsicClick(Sender: TObject);
    procedure ToolButtonSettingsClick(Sender: TObject);
  private
    { Private declarations }
    FDataLoaded: boolean;
    FItem:      TListitem;
    FrmWMIExplorer  : TFrmWMITree;
    FrmWmiClassTree : TFrmWmiClassTree;
    Settings : TSettings;

    procedure UMEditValueParam(var msg: TMessage); message UM_EDITPARAMVALUE;
    procedure UMEditEventValue(var msg: TMessage); message UM_EDITEVENTVALUE;
    procedure UMEditEventCond(var msg: TMessage); message UM_EDITEVENTCOND;

    procedure LoadWmiMetaData;
    procedure LoadWmiEvents(const Namespace: string);
    procedure LoadWmiMethods(const Namespace: string);
    procedure LoadWmiProperties(const Namespace, WmiClass: string);


    procedure GenerateMethodInvoker;
    procedure GenerateEventCode;

    procedure LoadEventsInfo;
    procedure LoadMethodInfo;
    procedure LoadParametersMethodInfo;

    procedure SetToolBar;
    procedure ScrollMemoConsole;

    function ExistWmiNameSpaceCache: boolean;
    procedure LoadWMINameSpacesFromCache(List: TStrings);
    procedure SaveWMINameSpacesToCache(List: TStrings);

    function ExistWmiClassesCache(const namespace: string): boolean;
    function ExistWmiClassesMethodsCache(const namespace: string): boolean;
    procedure LoadWMIClassesFromCache(const namespace: string; List: TStrings);
    procedure LoadWMIClassesMethodsFromCache(const namespace: string; List: TStrings);

    procedure SaveWMIClassesToCache(const namespace: string; List: TStrings);
    procedure SaveWMIClassesMethodsToCache(const namespace: string; List: TStrings);


  public
    procedure SetMsg(const Msg: string);
    procedure LoadWmiClasses(const Namespace: string);
    procedure LoadClassInfo;
    procedure GenerateConsoleCode;
    procedure GetValuesWmiProperties(const Namespace, WmiClass: string);
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  ComObj,
  ShellApi,
  CommCtrl,
  StrUtils,
  uWmi_About,
  uWmi_Metadata,
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
  uWmiDatabase,
  uMisc;

const
  VALUE_METHODPARAM_COLUMN = 2;
  COND_EVENTPARAM_COLUMN   = 2;
  VALUE_EVENTPARAM_COLUMN  = 3;

  PBS_MARQUEE    = $08;
  PBM_SETMARQUEE = (WM_USER + 10);

  WmiTableType_Class = 1;

  ListCompilerLanguages: array[TSourceLanguages] of
    TCompilerType = (Ct_Delphi, Ct_Lazarus_FPC, Ct_Oxygene, Ct_BorlandCpp);



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
  GenerateMethodInvoker;
end;

procedure TFrmMain.ButtonGenerateEventCodeClick(Sender: TObject);
begin
  GenerateEventCode;
end;

procedure TFrmMain.ButtonGetValuesClick(Sender: TObject);
begin
  GetValuesWmiProperties(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

procedure TFrmMain.CheckBoxPathClick(Sender: TObject);
begin
  LoadParametersMethodInfo;
end;

procedure TFrmMain.CheckBoxSelAllPropsClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ListViewProperties.Items.Count - 1 do
    ListViewProperties.Items[i].Checked := CheckBoxSelAllProps.Checked;
  GenerateConsoleCode;
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

procedure TFrmMain.ComboBoxLanguageSelChange(Sender: TObject);
begin

  if TSourceLanguages(ComboBoxLanguageSel.ItemIndex)=Lng_BorlandCpp then
  begin
    SynEditWMIClassCode.Highlighter:=SynCppSyn1;
    SynEditWMIMethodCode.Highlighter:=SynCppSyn1;
  end
  else
  begin
    SynEditWMIClassCode.Highlighter:=SynPasSyn1;
    SynEditWMIMethodCode.Highlighter:=SynPasSyn1;
  end;

  LoadCurrentTheme(Self,Settings.CurrentTheme);

  TabSheetWmiClassCode.Caption:=Format('%s Code',[ComboBoxLanguageSel.Text]);
  TabSheetWmiMethodCode.Caption:=Format('%s Code',[ComboBoxLanguageSel.Text]);


  GenerateConsoleCode;
  GenerateMethodInvoker;
  GenerateEventCode;
end;

procedure TFrmMain.ComboBoxMethodsChange(Sender: TObject);
begin
  LoadParametersMethodInfo;
  GenerateMethodInvoker;
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
  GenerateMethodInvoker;
end;

procedure TFrmMain.ComboBoxTargetInstanceChange(Sender: TObject);
var
  i:    integer;
  List: TStringList;
  Namespace: string;
  WmiClass: string;
  Item: TListItem;
begin
  Namespace := ComboBoxNamespacesEvents.Text;
  WmiClass  := ComboBoxTargetInstance.Text;

  ListVieweventsConds.Items.BeginUpdate;
  try
    for i := ListVieweventsConds.Items.Count - 1 downto 0 do
    begin
      if AnsiStartsStr(wbemTargetInstance, ListVieweventsConds.Items[i].Caption) then
        ListVieweventsConds.Items.Delete(i);
    end;

    if WmiClass <> '' then
    begin
      List := TStringList.Create;
      try
        GetListWmiClassPropertiesTypes(Namespace, WmiClass, List);
        for i := 0 to List.Count - 1 do
        begin
          Item := ListVieweventsConds.Items.Add;
          Item.Caption := Format('%s.%s', [wbemTargetInstance, List.Names[i]]);
          Item.SubItems.Add(List.ValueFromIndex[i]);
          Item.SubItems.Add('');
          Item.SubItems.Add(GetDefaultValueWmiType(List.ValueFromIndex[i]));
        end;
      finally
        List.Free;
      end;
    end;

  finally
    ListVieweventsConds.Items.EndUpdate;
    {
    ListVieweventsConds.Column[0].Width:=0;
    ListVieweventsConds.Column[0].Width:=-1;
    }
  end;

   {
   AutoResizeColumn(ListViewEventsConds.Column[0]);
   AutoResizeColumn(ListViewEventsConds.Column[1]);
   AutoResizeColumn(ListViewEventsConds.Column[2]);
    }
  AutoResizeColumns([ListViewEventsConds.Column[0], ListViewEventsConds.Column[1],
    ListViewEventsConds.Column[2]]);


  GenerateEventCode;
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

  GenerateMethodInvoker;
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

procedure TFrmMain.FormCreate(Sender: TObject);
var
  i:   TSourceLanguages;
  ProgressBarStyle: integer;
  Frm: TFrmWmiDatabase;
begin
  Settings :=TSettings.Create;
  SetToolBar;

  ReadSettings(Settings);
  LoadCurrentTheme(Self,Settings.CurrentTheme);
  LoadCurrentThemeFont(Self,Settings.FontName,Settings.FontSize);

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

  for i := Low(TSourceLanguages) to High(TSourceLanguages) do
    ComboBoxLanguageSel.Items.AddObject(ListSourceLanguages[i], TObject(i));
  ComboBoxLanguageSel.ItemIndex := 0;


  Frm := TFrmWmiDatabase.Create(Self);
  Frm.Parent := TabSheetWmiDatabase;
  Frm.BorderStyle := bsNone;
  Frm.Align := alClient;
  Frm.Show;

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
end;



procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FrmWMIExplorer.Free;
  FrmWmiClassTree.Free;
  Settings.Free;
end;

procedure TFrmMain.GenerateConsoleCode;
var
  Namespace: string;
  WmiClass: string;
  i,j:     integer;
  Props: TStrings;
  Str:  string;
  DelphiWmiCodeGenerator : TDelphiWmiClassCodeGenerator;
  FPCWmiCodeGenerator    : TFPCWmiClassCodeGenerator;
  OxygenWmiCodeGenerator : TOxygenWmiClassCodeGenerator;
  CppWmiCodeGenerator    : TBorlandCppWmiClassCodeGenerator;

begin
  Namespace := ComboBoxNameSpaces.Text;
  WmiClass  := ComboBoxClasses.Text;

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


    case TSourceLanguages(ComboBoxLanguageSel.ItemIndex) of
      Lng_Delphi:
                  begin
                    DelphiWmiCodeGenerator:=TDelphiWmiClassCodeGenerator.Create;
                    try
                      DelphiWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      DelphiWmiCodeGenerator.WmiNameSpace:=Namespace;
                      DelphiWmiCodeGenerator.WmiClass    :=WmiClass;
                      DelphiWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      DelphiWmiCodeGenerator.GenerateCode(Props);
                      SynEditWMIClassCode.Lines.Clear;
                      SynEditWMIClassCode.Lines.AddStrings(DelphiWmiCodeGenerator.OutPutCode);
                    finally
                      DelphiWmiCodeGenerator.Free;
                    end;
                  end;


      Lng_FPC:
                  begin
                    FPCWmiCodeGenerator:=TFPCWmiClassCodeGenerator.Create;
                    try
                      FPCWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      FPCWmiCodeGenerator.WmiNameSpace:=Namespace;
                      FPCWmiCodeGenerator.WmiClass    :=WmiClass;
                      FPCWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      FPCWmiCodeGenerator.GenerateCode(Props);
                      SynEditWMIClassCode.Lines.Clear;
                      SynEditWMIClassCode.Lines.AddStrings(FPCWmiCodeGenerator.OutPutCode);
                    finally
                      FPCWmiCodeGenerator.Free;
                    end;
                  end;


      Lng_Oxygen:
                  begin
                    OxygenWmiCodeGenerator:=TOxygenWmiClassCodeGenerator.Create;
                    try
                      OxygenWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      OxygenWmiCodeGenerator.WmiNameSpace:=Namespace;
                      OxygenWmiCodeGenerator.WmiClass    :=WmiClass;
                      OxygenWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      OxygenWmiCodeGenerator.GenerateCode(Props);
                      SynEditWMIClassCode.Lines.Clear;
                      SynEditWMIClassCode.Lines.AddStrings(OxygenWmiCodeGenerator.OutPutCode);
                    finally
                      OxygenWmiCodeGenerator.Free;
                    end;
                  end;

      Lng_BorlandCpp:
                  begin
                    CppWmiCodeGenerator:=TBorlandCppWmiClassCodeGenerator.Create;
                    try
                      CppWmiCodeGenerator.UseHelperFunctions:=false;//Settings.DelphiWmiClassHelperFuncts;
                      CppWmiCodeGenerator.WmiNameSpace:=Namespace;
                      CppWmiCodeGenerator.WmiClass    :=WmiClass;
                      CppWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      CppWmiCodeGenerator.GenerateCode(Props);
                      SynEditWMIClassCode.Lines.Clear;
                      SynEditWMIClassCode.Lines.AddStrings(CppWmiCodeGenerator.OutPutCode);
                    finally
                      CppWmiCodeGenerator.Free;
                    end;
                  end;


      {
      Lng_Oxygen: GenerateOxygenWmiConsoleCode(
          SynEditDelphiCode.Lines, Props, Namespace, WmiClass, Settings.DelphiWmiClassHelperFuncts);
      }
    end;

    SynEditWMIClassCode.SelStart  := SynEditWMIClassCode.GetTextLen;
    SynEditWMIClassCode.SelLength := 0;
    SendMessage(SynEditWMIClassCode.Handle, EM_SCROLLCARET, 0, 0);
  finally
    Props.Free;
  end;
end;

procedure TFrmMain.GenerateMethodInvoker;
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

    case TSourceLanguages(ComboBoxLanguageSel.ItemIndex) of
      Lng_Delphi:
                 begin
                  DelphiWmiCodeGenerator :=TDelphiWmiMethodCodeGenerator.Create;
                  try
                    DelphiWmiCodeGenerator.WmiNameSpace:=Namespace;
                    DelphiWmiCodeGenerator.WmiClass:=WmiClass;
                    DelphiWmiCodeGenerator.WmiMethod:=WmiMethod;
                    DelphiWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    DelphiWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    DelphiWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    DelphiWmiCodeGenerator.GenerateCode(Params, Values);
                    SynEditWMIMethodCode.Lines.Clear;
                    SynEditWMIMethodCode.Lines.AddStrings(DelphiWmiCodeGenerator.OutPutCode);
                  finally
                    DelphiWmiCodeGenerator.Free;
                  end;
                 end;

      Lng_BorlandCpp:
                 begin
                  BorlandCppWmiCodeGenerator :=TBorlandCppWmiMethodCodeGenerator.Create;
                  try
                    BorlandCppWmiCodeGenerator.WmiNameSpace:=Namespace;
                    BorlandCppWmiCodeGenerator.WmiClass:=WmiClass;
                    BorlandCppWmiCodeGenerator.WmiMethod:=WmiMethod;
                    BorlandCppWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    BorlandCppWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    BorlandCppWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    BorlandCppWmiCodeGenerator.GenerateCode(Params, Values);
                    SynEditWMIMethodCode.Lines.Clear;
                    SynEditWMIMethodCode.Lines.AddStrings(BorlandCppWmiCodeGenerator.OutPutCode);
                  finally
                    BorlandCppWmiCodeGenerator.Free;
                  end;
                 end;

      Lng_FPC:
                 begin
                  FPCWmiCodeGenerator :=TFPCWmiMethodCodeGenerator.Create;
                  try
                    FPCWmiCodeGenerator.WmiNameSpace:=Namespace;
                    FPCWmiCodeGenerator.WmiClass:=WmiClass;
                    FPCWmiCodeGenerator.WmiMethod:=WmiMethod;
                    FPCWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    FPCWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    FPCWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    FPCWmiCodeGenerator.GenerateCode(Params, Values);
                    SynEditWMIMethodCode.Lines.Clear;
                    SynEditWMIMethodCode.Lines.AddStrings(FPCWmiCodeGenerator.OutPutCode);
                  finally
                    FPCWmiCodeGenerator.Free;
                  end;
                 end;

      Lng_Oxygen:
                 begin
                  OxygenWmiCodeGenerator :=TOxygenWmiMethodCodeGenerator.Create;
                  try
                    OxygenWmiCodeGenerator.WmiNameSpace:=Namespace;
                    OxygenWmiCodeGenerator.WmiClass:=WmiClass;
                    OxygenWmiCodeGenerator.WmiMethod:=WmiMethod;
                    OxygenWmiCodeGenerator.WmiPath:=ComboBoxPaths.Text;
                    OxygenWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                    OxygenWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
                    OxygenWmiCodeGenerator.GenerateCode(Params, Values);
                    SynEditWMIMethodCode.Lines.Clear;
                    SynEditWMIMethodCode.Lines.AddStrings(OxygenWmiCodeGenerator.OutPutCode);
                  finally
                    OxygenWmiCodeGenerator.Free;
                  end;
                 end;
    end;


    SynEditWMIMethodCode.SelStart  := SynEditWMIMethodCode.GetTextLen;
    SynEditWMIMethodCode.SelLength := 0;
    SendMessage(SynEditWMIMethodCode.Handle, EM_SCROLLCARET, 0, 0);
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

    case TSourceLanguages(ComboBoxLanguageSel.ItemIndex) of


      Lng_Delphi:
                 begin
                   DelphiWmiCodeGenerator := TDelphiWmiEventCodeGenerator.Create;
                   try
                      DelphiWmiCodeGenerator.WmiNameSpace:=Namespace;
                      DelphiWmiCodeGenerator.WmiClass    :=WmiEvent;
                      DelphiWmiCodeGenerator.WmiTargetInstance    := WmiTargetInstance;
                      DelphiWmiCodeGenerator.PollSeconds          := PollSeconds;
                      DelphiWmiCodeGenerator.ModeCodeGeneration   := TWmiCode(Settings.DelphiWmiEventCodeGenMode);
                      //RadioButtonIntrinsic.Checked
                      DelphiWmiCodeGenerator.GenerateCode(Params, Values, Conds, PropsOut);
                      SynEditEventCode.Lines.Clear;
                      SynEditEventCode.Lines.AddStrings(DelphiWmiCodeGenerator.OutPutCode);
                   finally
                      DelphiWmiCodeGenerator.Free;
                   end;
                 end;

      Lng_FPC:
                 begin
                   FPCWmiCodeGenerator := TFPCWmiEventCodeGenerator.Create;
                   try
                      FPCWmiCodeGenerator.WmiNameSpace:=Namespace;
                      FPCWmiCodeGenerator.WmiClass    :=WmiEvent;
                      FPCWmiCodeGenerator.WmiTargetInstance    := WmiTargetInstance;
                      FPCWmiCodeGenerator.PollSeconds          := PollSeconds;
                      FPCWmiCodeGenerator.ModeCodeGeneration   := TWmiCode(Settings.DelphiWmiEventCodeGenMode);
                      //RadioButtonIntrinsic.Checked
                      FPCWmiCodeGenerator.GenerateCode(Params, Values, Conds, PropsOut);
                      SynEditEventCode.Lines.Clear;
                      SynEditEventCode.Lines.AddStrings(FPCWmiCodeGenerator.OutPutCode);
                   finally
                      FPCWmiCodeGenerator.Free;
                   end;
                 end;

      Lng_Oxygen:
                 begin
                   OxygenWmiCodeGenerator := TOxygenWmiEventCodeGenerator.Create;
                   try
                      OxygenWmiCodeGenerator.WmiNameSpace:=Namespace;
                      OxygenWmiCodeGenerator.WmiClass    :=WmiEvent;
                      OxygenWmiCodeGenerator.WmiTargetInstance    := WmiTargetInstance;
                      OxygenWmiCodeGenerator.PollSeconds          := PollSeconds;
                      OxygenWmiCodeGenerator.ModeCodeGeneration   := TWmiCode(Settings.DelphiWmiEventCodeGenMode);
                      OxygenWmiCodeGenerator.GenerateCode(Params, Values, Conds, PropsOut);
                      SynEditEventCode.Lines.Clear;
                      SynEditEventCode.Lines.AddStrings(OxygenWmiCodeGenerator.OutPutCode);
                   finally
                      OxygenWmiCodeGenerator.Free;
                   end;
                 end;

    end;

    SynEditEventCode.SelStart  := SynEditEventCode.GetTextLen;
    SynEditEventCode.SelLength := 0;
    SendMessage(SynEditEventCode.Handle, EM_SCROLLCARET, 0, 0);
  finally
    Conds.Free;
    Params.Free;
    Values.Free;
    PropsOut.Free;
  end;
end;


procedure TFrmMain.GetValuesWmiProperties(const Namespace, WmiClass: string);
var
  Frm: TFrmWmiVwProps;
  i:   integer;

begin
  if (ListViewProperties.Items.Count > 0) and (WmiClass <> '') and (Namespace <> '') then
  begin
    ButtonGetValues.Enabled := False;
    Frm := TFrmWmiVwProps.Create(Self);
    ProgressBarWmi.Visible := True;
    Self.Enabled := False;
    SetMsg('Loading values...Wait');

    try
      Frm.WmiClass     := WmiClass;
      Frm.WmiNamespace := Namespace;
      Frm.Caption      := 'Properties Values for the class ' + WmiClass;

      for i := 0 to ListViewProperties.Items.Count - 1 do
        if ListViewProperties.Items[i].Checked then
          Frm.Wmiproperties.Add(ListViewProperties.Items[i].Caption);

      Frm.LoadValues;
      Frm.Show();


    finally
      SetMsg('');
      ProgressBarWmi.Visible := False;
      ButtonGetValues.Enabled := True;
      Self.Enabled := True;
    end;
  end;
end;


procedure TFrmMain.ListBoxPropertiesClick(Sender: TObject);
begin
  CheckBoxSelAllProps.Checked := False;
  GenerateConsoleCode;
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

  GenerateEventCode;
end;

procedure TFrmMain.ListViewMethodsParamsClick(Sender: TObject);
var
  pt: TPoint;
  HitTestInfo: TLVHitTestInfo;
begin
  EditValueMethodParam.Visible := False;
  pt := TListView(Sender).ScreenToClient(Mouse.CursorPos);
  FillChar(HitTestInfo, sizeof(HitTestInfo), 0);
  HitTestInfo.pt := pt;
  if (-1 <> TListView(Sender).Perform(LVM_SUBITEMHITTEST, 0,
    lparam(@HitTestInfo))) and
    (HitTestInfo.iSubItem = VALUE_METHODPARAM_COLUMN) then
    PostMessage(Self.Handle, UM_EDITPARAMVALUE, HitTestInfo.iItem, 0);

  GenerateMethodInvoker;
end;

procedure TFrmMain.LoadClassInfo;
var
  Namespace: string;
  WmiClass:  string;
begin
  ProgressBarWmi.Visible := True;
  try
    Namespace := ComboBoxNameSpaces.Text;
    WmiClass  := ComboBoxClasses.Text;
    if (Namespace <> '') and (WmiClass <> '') then
    begin
      SetMsg(Format('Loading Info Class %s:%s', [Namespace, WmiClass]));
      MemoClassDescr.Text := GetWmiClassDescription(Namespace, WmiClass);
      if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';
      LoadWmiProperties(Namespace, WmiClass);

      FrmWMIExplorer.LoadClassInfo;
    end;
  finally
    SetMsg('');
    ProgressBarWmi.Visible := False;
  end;
end;


procedure TFrmMain.LoadEventsInfo;
var
  Namespace: string;
  EventClass: string;
  Item: TListItem;
  List: TStringList;
  i:    integer;
begin
  Namespace  := ComboBoxNamespacesEvents.Text;
  EventClass := ComboBoxEvents.Text;

  StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [Namespace, EventClass]);
  //ListVieweventsConds
  List := TStringList.Create;
  ListVieweventsConds.Items.BeginUpdate;
  try
    ListVieweventsConds.Items.Clear;
    GetListWmiClassPropertiesTypes(NameSpace, EventClass, List);
    LabelEventsConds.Caption :=
      Format('%d Properties of %s:%s', [ListViewProperties.Items.Count, Namespace, EventClass]);


    for i := 0 to List.Count - 1 do
    begin
      Item := ListVieweventsConds.Items.Add;
      Item.Checked := False;
      Item.Caption := List.Names[i];
      Item.SubItems.Add(List.ValueFromIndex[i]);
      Item.SubItems.Add('');
      Item.SubItems.Add(GetDefaultValueWmiType(List.ValueFromIndex[i]));
    end;
  finally
    ListVieweventsConds.Items.EndUpdate;
    List.Free;
    SetMsg('');
  end;
  {
  if CheckBoxSelAllProps.Checked then
  ListBoxProperties.SelectAll;
  }
  AutoResizeColumn(ListViewEventsConds.Column[0]);
  AutoResizeColumn(ListViewEventsConds.Column[1]);
  AutoResizeColumn(ListViewEventsConds.Column[2]);

  GenerateEventCode;
end;

procedure TFrmMain.LoadMethodInfo;
begin
  ComboBoxMethods.Items.BeginUpdate;
  try
    ComboBoxMethods.Items.Clear;
    if ComboBoxClassesMethods.Text <> '' then
    begin
      if Settings.ShowImplementedMethods then
        GetListWmiClassImplementedMethods(ComboBoxNamespaceMethods.Text,
          ComboBoxClassesMethods.Text, ComboBoxMethods.Items)
      else
        GetListWmiClassMethods(ComboBoxNamespaceMethods.Text,
          ComboBoxClassesMethods.Text, ComboBoxMethods.Items);

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

  LoadParametersMethodInfo;
  GenerateMethodInvoker;
end;

procedure TFrmMain.LoadParametersMethodInfo;
var
  ParamsList, ParamsTypes, ParamsDescr: TStringList;
  i:    integer;
  Item: TListItem;
begin
  ParamsList  := TStringList.Create;
  ParamsTypes := TStringList.Create;
  ParamsDescr := TStringList.Create;
  ListViewMethodsParams.Items.BeginUpdate;
  try
    ListViewMethodsParams.Items.Clear;
    if (ComboBoxClassesMethods.Text <> '') and (ComboBoxMethods.Text <> '') then
    begin

      if not WmiMethodIsStatic(ComboBoxNamespaceMethods.Text,
        ComboBoxClassesMethods.Text, ComboBoxMethods.Text) and CheckBoxPath.Checked then
      begin
        GetWmiClassPath(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text,
          ComboBoxPaths.Items);
        if ComboBoxPaths.Items.Count > 0 then
          ComboBoxPaths.ItemIndex := 0;

        //ComboBoxPaths.Visible:=True;
        //CheckBoxPath.Visible:=True;
      end
      else
      begin
        //ComboBoxPaths.Visible:=False;
        //CheckBoxPath.Visible:=False;
        ComboBoxPaths.Items.Clear;
      end;


      MemoMethodDescr.Text := GetWmiMethodDescription(
        ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text, ComboBoxMethods.Text);

      if MemoMethodDescr.Text = '' then
        MemoMethodDescr.Text := 'Method without description available';

      GetListWmiMethodInParameters(ComboBoxNamespaceMethods.Text,
        ComboBoxClassesMethods.Text, ComboBoxMethods.Text, ParamsList, ParamsTypes, ParamsDescr);
    end;

    for i := 0 to ParamsList.Count - 1 do
    begin
      Item := ListViewMethodsParams.Items.Add;
      Item.Caption := ParamsList[i];
      Item.Data:=ParamsTypes.Objects[i];
      Item.SubItems.Add(ParamsTypes[i]);
      Item.SubItems.Add(GetDefaultValueWmiType(ParamsTypes[i]));
    end;
  finally
    ListViewMethodsParams.Items.EndUpdate;
    ParamsList.Free;
    ParamsTypes.Free;
    ParamsDescr.Free;
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
              MemoLog.Lines.Add(
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
begin
  ComboBoxEvents.Items.BeginUpdate;
  try
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
    if DebugHook=0 then
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
            MemoLog.Lines.Add(
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

    ComboBoxNameSpaces.ItemIndex := 0;
    LoadWmiClasses(ComboBoxNameSpaces.Text);
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
begin
  SetMsg(Format('Loading classes with methods in %s', [Namespace]));
  try


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

procedure TFrmMain.LoadWmiProperties(const Namespace, WmiClass: string);
var
  i:     integer;
  Props: TStringList;
  item:  TListItem;
begin
  StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [Namespace, WmiClass]);
  ListViewProperties.Items.BeginUpdate;
  Props := TStringList.Create;
  try
    ListViewProperties.Items.Clear;
    GetListWmiClassPropertiesTypes(NameSpace, WmiClass, Props);

    for i := 0 to Props.Count - 1 do
    begin
      item := ListViewProperties.Items.Add;
      item.Caption := Props.Names[i];
      item.SubItems.Add(Props.ValueFromIndex[i]);
      item.Checked := CheckBoxSelAllProps.Checked;
      item.Data    := Props.Objects[i]; //Cimtype
    end;

    LabelProperties.Caption := Format('%d Properties of %s:%s',
      [ListViewProperties.Items.Count, Namespace, WmiClass]);
  finally
    ListViewProperties.Items.EndUpdate;
    Props.Free;
  end;
  SetMsg('');

  for i := 0 to ListViewProperties.Columns.Count - 1 do
    AutoResizeColumn(ListViewProperties.Column[i]);

  GenerateConsoleCode;
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

procedure TFrmMain.ScrollMemoConsole;
begin
  MemoConsole.SelStart  := MemoConsole.GetTextLen;
  MemoConsole.SelLength := 0;
  SendMessage(MemoConsole.Handle, EM_SCROLLCARET, 0, 0);
end;


procedure TFrmMain.SetMsg(const Msg: string);
begin
  StatusBar1.Panels[0].Text := Msg;
end;

procedure TFrmMain.SetToolBar;
begin
  ToolButtonRun.Enabled    := (PageControlMain.ActivePage = TabSheetCodeGen);
  ToolButtonSave.Enabled   := (PageControlMain.ActivePage = TabSheetCodeGen);
  ToolButtonSearch.Enabled := (PageControlMain.ActivePage = TabSheetWmiExplorer);
  ToolButtonGetValues.Enabled := (PageControlMain.ActivePage = TabSheetWmiExplorer);
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


procedure TFrmMain.ToolButtonRunClick(Sender: TObject);
var
  Frm: TFrmSelCompilerVer;
  item: TListItem;
  FileName: string;
  CompilerName: string;
  Ct: TCompilerType;
begin
  Frm := TFrmSelCompilerVer.Create(Self);
  try
    Ct := ListCompilerLanguages[TSourceLanguages(
      ComboBoxLanguageSel.Items.Objects[ComboBoxLanguageSel.ItemIndex])];
    Frm.ShowCompiler := True;
    Frm.CompilerType := Ct;
    Frm.LoadInstalledVersions;
    if Frm.ListViewIDEs.Items.Count = 0 then
      MsgWarning(Format('Not exist a %s compiler installed in this system',
        [ListCompilerType[Ct]]))
    else
    if Frm.ShowModal = mrOk then
    begin
      item := Frm.ListViewIDEs.Selected;
      if Assigned(item) then
      begin
        Ct := TCompilerType(integer(item.Data));
        case Ct of
          Ct_Delphi:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.dpr';

            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);

            if CreateDelphiProject(
              ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +'Delphi') then
              CompileAndRunDelphiCode(MemoConsole.Lines,CompilerName, FileName, TComponent(Sender).Tag = 1);

            ScrollMemoConsole;
          end;

          Ct_BorlandCpp:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cpp';

            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);

              {
            if CreateDelphiProject(
              ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +'Delphi') then
              }
              CompileAndRunBorlandCppCode(MemoConsole.Lines,CompilerName, FileName, TComponent(Sender).Tag = 1);

            ScrollMemoConsole;
          end;


          Ct_Lazarus_FPC:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.lpr';

            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);

            if CreateLazarusProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), IncludeTrailingPathDelimiter(
              ExtractFilePath(ParamStr(0))) + 'Lazarus\TemplateConsole.lpi') then
              CompileAndRunFPCCode(MemoConsole.Lines,CompilerName, FileName,
                TComponent(Sender).Tag = 1);

             ScrollMemoConsole;
          end;

          Ct_Oxygene:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     := FileName + 'Program.pas';

            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);

            if CreateOxygeneProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), IncludeTrailingPathDelimiter(
              ExtractFilePath(ParamStr(0))) + 'Oxygene\VS2008\GetWMI_Info.oxygene', FileName) then
              CompileAndRunOxygenCode(MemoConsole.Lines,CompilerName, FileName,
                TComponent(Sender).Tag = 1);

             ScrollMemoConsole;
          end;
        end;

      end;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmMain.OpeninDelphi1Click(Sender: TObject);
var
  Frm: TFrmSelCompilerVer;
  item: TListItem;
  FileName: string;
  IdeName: string;
  Ct: TCompilerType;
begin
  Frm := TFrmSelCompilerVer.Create(Self);
  try
    Ct := ListCompilerLanguages[TSourceLanguages(
      ComboBoxLanguageSel.Items.Objects[ComboBoxLanguageSel.ItemIndex])];
    Frm.CompilerType := Ct;
    Frm.Show64BitsCompiler:=False;
    Frm.LoadInstalledVersions;
    if Frm.ListViewIDEs.Items.Count = 0 then
      MsgWarning('Does not exist a Object Pascal IDEs installed in this system')
    else
    if Frm.ShowModal = mrOk then
    begin
      item := Frm.ListViewIDEs.Selected;
      if Assigned(item) then
      begin
        Ct      := TCompilerType(integer(item.Data));
        IdeName := item.SubItems[0];
        FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);


        case ct of
          Ct_Delphi:
          begin
            FileName :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.dpr';
            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;

          Ct_BorlandCpp:
          begin
            FileName :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cpp';
            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;


          Ct_Lazarus_FPC:
          begin
            FileName :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.lpr';
            if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);

            if CreateLazarusProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), IncludeTrailingPathDelimiter(
              ExtractFilePath(ParamStr(0))) + 'Lazarus\TemplateConsole.lpi') then
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;
          Ct_Oxygene:
          begin
            FileName := FileName + 'Program.pas';

            if PageControlCodeGen.ActivePage =
              TabSheetWmiClasses then
              SynEditWMIClassCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetMethods then
              SynEditWMIMethodCode.Lines.SaveToFile(FileName)
            else
            if PageControlCodeGen.ActivePage = TabSheetEvents then
              SynEditEventCode.Lines.SaveToFile(FileName);

            if StartsText('Monodevelop', item.Caption) and
              CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'Oxygene\Monodevelop\GetWMI_Info.oxygene', FileName) then
            begin
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
            end
            else
            if (Pos('2008', item.Caption) > 0) and
              CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'Oxygene\VS2008\GetWMI_Info.oxygene', FileName) then
            begin
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
            end
            else
            if (Pos('2010', item.Caption) > 0) and
              CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'Oxygene\VS2010\GetWMI_Info.oxygene', FileName) then
            begin
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
            end;

          end;

        end;
      end;
    end;
  finally
    Frm.Free;
  end;
end;

procedure TFrmMain.PageControlMainChange(Sender: TObject);
begin
  SetToolBar;
end;

procedure TFrmMain.RadioButtonIntrinsicClick(Sender: TObject);
begin
  LoadWmiEvents(ComboBoxNamespacesEvents.Text);
end;

procedure TFrmMain.ToolButtonSaveClick(Sender: TObject);
begin
  if PageControlCodeGen.ActivePage = TabSheetWmiClasses then
  begin
    if PageControlCode.ActivePage = TabSheetWmiClassCode then
    begin
      SaveDialog1.FileName := 'GetWMI_Info.dpr';
      SaveDialog1.Filter   := 'Delphi Project files|*.dpr';
      if SaveDialog1.Execute then
        SynEditWMIClassCode.Lines.SaveToFile(SaveDialog1.FileName);
    end;
  end
  else
  if PageControlCodeGen.ActivePage = TabSheetMethods then
  begin
    SaveDialog1.FileName := 'InvokeWMI_Method.dpr';
    SaveDialog1.Filter   := 'Delphi Project files|*.dpr';
    if SaveDialog1.Execute then
      SynEditWMIMethodCode.Lines.SaveToFile(SaveDialog1.FileName);
  end
  else
  if PageControlCodeGen.ActivePage = TabSheetEvents then
  begin
    SaveDialog1.FileName := 'EventWMI_Method.dpr';
    SaveDialog1.Filter   := 'Delphi Project files|*.dpr';
    if SaveDialog1.Execute then
      SynEditEventCode.Lines.SaveToFile(SaveDialog1.FileName);
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



end.