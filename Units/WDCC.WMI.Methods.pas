// **************************************************************************************************
//
// Unit WDCC.WMI.Methods
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
// The Original Code is WDCC.WMI.Methods.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.Methods;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, WDCC.Misc,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, uWmi_Metadata, WDCC.CodeEditor, WDCC.Settings,
  WDCC.ComboBox;

const
  UM_EDITPARAMVALUE = WM_USER + 111;

type
  TFrmWmiMethods = class(TForm)
    PanelMethodInfo: TPanel;
    Label4: TLabel;
    Label6: TLabel;
    LabelClassesMethods: TLabel;
    LabelMethods: TLabel;
    ComboBoxClassesMethods: TComboBox;
    ComboBoxMethods: TComboBox;
    ComboBoxNamespaceMethods: TComboBox;
    ListViewMethodsParams: TListView;
    MemoMethodDescr: TMemo;
    EditValueMethodParam: TEdit;
    ButtonGenerateCodeInvoker: TButton;
    ComboBoxPaths: TComboBox;
    CheckBoxPath: TCheckBox;
    Splitter5: TSplitter;
    PanelMethodCode: TPanel;
    CheckBoxSelAllProps: TCheckBox;
    procedure ComboBoxNamespaceMethodsChange(Sender: TObject);
    procedure ComboBoxClassesMethodsChange(Sender: TObject);
    procedure ComboBoxMethodsChange(Sender: TObject);
    procedure ComboBoxPathsChange(Sender: TObject);
    procedure CheckBoxPathClick(Sender: TObject);
    procedure ListViewMethodsParamsClick(Sender: TObject);
    procedure ButtonGenerateCodeInvokerClick(Sender: TObject);
    procedure EditValueMethodParamExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
  private
    FSetMsg: TProcLog;
    FSetLog: TProcLog;
    FSettings: TSettings;
    FConsole: TMemo;
    FrmCodeEditorMethod: TFrmCodeEditor;
    FItem: TListitem;
    FDataLoaded: Boolean;
    procedure UMEditValueParam(var msg: TMessage); message UM_EDITPARAMVALUE;
    procedure SetSettings(const Value: TSettings);
    procedure SetConsole(const Value: TMemo);
    procedure LoadMethodInfo(FirstTime: Boolean = False);
    procedure LoadParametersMethodInfo(WmiMetaClassInfo: TWMiClassMetaData);
    procedure GenerateMethodInvoker(WmiMetaClassInfo: TWMiClassMetaData);
    procedure GenerateCode;
    procedure LoadNameSpaces;
    procedure LoadWmiMethods(const Namespace: string; FirstTime: Boolean = False);
    procedure SaveCurrentSettings;
  public
    property SetMsg: TProcLog read FSetMsg Write FSetMsg;
    property SetLog: TProcLog read FSetLog Write FSetLog;
    property Settings: TSettings read FSettings Write SetSettings;
    property Console: TMemo read FConsole write SetConsole;
  end;

implementation

{$R *.dfm}

uses
  WDCC.Globals,
  Winapi.CommCtrl,
  StrUtils,
  WDCC.SelectCompilerVersion,
  WDCC.WMI.GenCode,
  WDCC.WMI.OxygenCode,
  WDCC.WMI.FPCCode,
  WDCC.WMI.DelphiCode,
  WDCC.WMI.Borland.CppCode,
  WDCC.WMI.Microsoft.CppCode,
  WDCC.WMI.CSharpCode,
  WDCC.ListView.Helper;

const
  VALUE_METHODPARAM_COLUMN = 2;

procedure TFrmWmiMethods.ButtonGenerateCodeInvokerClick(Sender: TObject);
begin
  GenerateCode;
end;

procedure TFrmWmiMethods.CheckBoxPathClick(Sender: TObject);
begin
  LoadParametersMethodInfo(CachedWMIClasses.GetWmiClass(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text));
end;

procedure TFrmWmiMethods.CheckBoxSelAllPropsClick(Sender: TObject);
var
  LIndex: integer;
begin
  for LIndex := 0 to ListViewMethodsParams.Items.Count - 1 do
    ListViewMethodsParams.Items[LIndex].Checked := CheckBoxSelAllProps.Checked;

  GenerateCode;
end;

procedure TFrmWmiMethods.ComboBoxClassesMethodsChange(Sender: TObject);
begin
  LoadMethodInfo;
  SaveCurrentSettings;
end;

procedure TFrmWmiMethods.ComboBoxMethodsChange(Sender: TObject);
begin
  LoadParametersMethodInfo(CachedWMIClasses.GetWmiClass(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text));
  GenerateCode;
  SaveCurrentSettings;
end;

procedure TFrmWmiMethods.ComboBoxNamespaceMethodsChange(Sender: TObject);
begin
  LoadWmiMethods(ComboBoxNamespaceMethods.Text);
  SaveCurrentSettings;
end;

procedure TFrmWmiMethods.ComboBoxPathsChange(Sender: TObject);
begin
  GenerateCode;
end;

procedure TFrmWmiMethods.EditValueMethodParamExit(Sender: TObject);
begin
  if Assigned(FItem) then
  begin
    FItem.SubItems[VALUE_METHODPARAM_COLUMN - 1] := TEdit(Sender).Text;
    FItem := nil;
  end;
  PostMessage(handle, WM_NEXTDLGCTL, ListViewMethodsParams.handle, 1);
  TEdit(Sender).Visible := True;

  GenerateMethodInvoker(CachedWMIClasses.GetWmiClass(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text));
end;

procedure TFrmWmiMethods.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveCurrentSettings;
end;

procedure TFrmWmiMethods.FormCreate(Sender: TObject);
begin
  FrmCodeEditorMethod := TFrmCodeEditor.Create(Self);
  FrmCodeEditorMethod.CodeGenerator := GenerateCode;
  FrmCodeEditorMethod.Parent := PanelMethodCode;
  FrmCodeEditorMethod.OldParent := PanelMethodCode;
  FrmCodeEditorMethod.Show;
  // FrmCodeEditorMethod.Settings:=Settings;
  // FrmCodeEditorMethod.Console:=MemoConsole;
  FrmCodeEditorMethod.SourceLanguage := Lng_Delphi;
end;

procedure TFrmWmiMethods.FormShow(Sender: TObject);
begin
  if not FDataLoaded then
    LoadNameSpaces;
end;

procedure TFrmWmiMethods.GenerateCode;
begin
  if (Parent <> nil) and (Parent is TTabSheet) then
    TTabSheet(Parent).Caption := Format('WMI Methods %s CodeGen', [FrmCodeEditorMethod.ComboBoxLanguageSel.Text]);;

  if ComboBoxClassesMethods.ItemIndex >= 0 then
    GenerateMethodInvoker(CachedWMIClasses.GetWmiClass(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text));
end;

procedure TFrmWmiMethods.GenerateMethodInvoker(WmiMetaClassInfo: TWMiClassMetaData);
var
  Namespace: string;
  WmiClass: string;
  WmiMethod: string;
  i: integer;
  Params: TStringList;
  Values: TStringList;
  Str: string;
  WmiCodeGenerator: TWmiMethodCodeGenerator;
begin
  if (ComboBoxClassesMethods.Text = '') or (ComboBoxMethods.Text = '') then
    exit;

  SetLog(Format('Generating code for %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

  Namespace := ComboBoxNamespaceMethods.Text;
  WmiClass := ComboBoxClassesMethods.Text;
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
        Values.AddObject(ListViewMethodsParams.Items[i].SubItems[1], ListViewMethodsParams.Items[i].Data)
      else
        Values.Add(WbemEmptyParam);
    end;

    Params.CommaText := Str;

    case FrmCodeEditorMethod.SourceLanguage of
      Lng_Delphi:
        begin
          WmiCodeGenerator := TDelphiWmiMethodCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.WmiMethod := WmiMethod;
            WmiCodeGenerator.WmiPath := ComboBoxPaths.Text;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.ModeCodeGeneration := TWmiCode(Settings.DelphiWmiMethodCodeGenMode);
            WmiCodeGenerator.GenerateCode(Params, Values);
            FrmCodeEditorMethod.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_BorlandCpp:
        begin
          WmiCodeGenerator := TBorlandCppWmiMethodCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.WmiMethod := WmiMethod;
            WmiCodeGenerator.WmiPath := ComboBoxPaths.Text;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Params, Values);
            FrmCodeEditorMethod.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_VSCpp:
        begin
          WmiCodeGenerator := TVsWmiMethodCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.WmiMethod := WmiMethod;
            WmiCodeGenerator.WmiPath := ComboBoxPaths.Text;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Params, Values);
            FrmCodeEditorMethod.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_FPC:
        begin
          WmiCodeGenerator := TFPCWmiMethodCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.WmiMethod := WmiMethod;
            WmiCodeGenerator.WmiPath := ComboBoxPaths.Text;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Params, Values);
            FrmCodeEditorMethod.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_Oxygen:
        begin
          WmiCodeGenerator := TOxygenWmiMethodCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.WmiMethod := WmiMethod;
            WmiCodeGenerator.WmiPath := ComboBoxPaths.Text;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Params, Values);
            FrmCodeEditorMethod.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_CSharp:
        begin
          WmiCodeGenerator := TCSharpWmiMethodCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.WmiMethod := WmiMethod;
            WmiCodeGenerator.WmiPath := ComboBoxPaths.Text;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Params, Values);
            FrmCodeEditorMethod.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;
    end;

  finally
    Params.Free;
    Values.Free;
  end;
end;

procedure TFrmWmiMethods.ListViewMethodsParamsClick(Sender: TObject);
var
  pt: TPoint;
  HitTestInfo: TLVHitTestInfo;
begin
  if TListView(Sender).Items.Count = 0 then
    exit;

  EditValueMethodParam.Visible := False;
  pt := TListView(Sender).ScreenToClient(Mouse.CursorPos);
  FillChar(HitTestInfo, sizeof(HitTestInfo), 0);
  HitTestInfo.pt := pt;
  if (-1 <> TListView(Sender).Perform(LVM_SUBITEMHITTEST, 0, lparam(@HitTestInfo))) and
    (HitTestInfo.iSubItem = VALUE_METHODPARAM_COLUMN) then
    PostMessage(Self.handle, UM_EDITPARAMVALUE, HitTestInfo.iItem, 0);

  GenerateCode;
end;

procedure TFrmWmiMethods.LoadMethodInfo(FirstTime: Boolean);
Var
  WmiMetaClassInfo: TWMiClassMetaData;
  i: integer;
begin
  if ComboBoxClassesMethods.ItemIndex = -1 then
    exit;

  ComboBoxMethods.Items.BeginUpdate;
  try
    ComboBoxMethods.Items.Clear;
    WmiMetaClassInfo := CachedWMIClasses.GetWmiClass(ComboBoxNamespaceMethods.Text, ComboBoxClassesMethods.Text);

    if ComboBoxClassesMethods.Text <> '' then
    begin

      if Settings.ShowImplementedMethods then
        for i := 0 to WmiMetaClassInfo.MethodsCount - 1 do
        begin
          if WmiMetaClassInfo.Methods[i].Implemented then
            ComboBoxMethods.Items.Add(WmiMetaClassInfo.Methods[i].Name)
        end
      else
        for i := 0 to WmiMetaClassInfo.MethodsCount - 1 do
          ComboBoxMethods.Items.Add(WmiMetaClassInfo.Methods[i].Name);

      ComboBoxPaths.Items.Clear;
    end;

    LabelMethods.Caption := Format('Methods (%d)', [ComboBoxMethods.Items.Count]);
  finally
    ComboBoxMethods.Items.EndUpdate;
  end;

  if ComboBoxMethods.Items.Count > 0 then
    if FirstTime then
    begin
      if Settings.LastWmiMethod <> '' then
        ComboBoxMethods.ItemIndex := ComboBoxMethods.Items.IndexOf(Settings.LastWmiMethod)
      else
        ComboBoxMethods.ItemIndex := 0;
    end
    else
      ComboBoxMethods.ItemIndex := 0
  else
    ComboBoxMethods.ItemIndex := -1;

  LoadParametersMethodInfo(WmiMetaClassInfo);
  GenerateCode;
end;

procedure TFrmWmiMethods.LoadNameSpaces;
begin
  ComboBoxNamespaceMethods.Items.AddStrings(CachedWMIClasses.NameSpaces);

  if FSettings.LastWmiNameSpaceMethods <> '' then
    ComboBoxNamespaceMethods.ItemIndex := ComboBoxNamespaceMethods.Items.IndexOf(Settings.LastWmiNameSpaceEvents)
  else
    ComboBoxNamespaceMethods.ItemIndex := 0;
  LoadWmiMethods(ComboBoxNamespaceMethods.Text, True);

  FDataLoaded := True;
end;

procedure TFrmWmiMethods.LoadParametersMethodInfo(WmiMetaClassInfo: TWMiClassMetaData);
var
  i: integer;
  Item: TListitem;
  s: string;
  LWMiMethodMetaData: TWMiMethodMetaData;
begin
  if not Assigned(WmiMetaClassInfo) then
    exit;
  ListViewMethodsParams.Items.BeginUpdate;
  try
    ListViewMethodsParams.Items.Clear;
    if (ComboBoxClassesMethods.Text <> '') and (ComboBoxMethods.Text <> '') then
    begin

      LWMiMethodMetaData := WmiMetaClassInfo.MethodByName[ComboBoxMethods.Text];
      if not LWMiMethodMetaData.IsStatic and CheckBoxPath.Checked then
      begin
        GetWmiClassPath(WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass, ComboBoxPaths.Items);
        if ComboBoxPaths.Items.Count > 0 then
          ComboBoxPaths.ItemIndex := 0;
      end
      else
        ComboBoxPaths.Items.Clear;

      MemoMethodDescr.Text := LWMiMethodMetaData.Description;

      if MemoMethodDescr.Text = '' then
        MemoMethodDescr.Text := 'Method without description available';

      for i := 0 to LWMiMethodMetaData.InParameters.Count - 1 do
      begin
        Item := ListViewMethodsParams.Items.Add;
        Item.Caption := LWMiMethodMetaData.InParameters[i].Name;
        Item.Data := Pointer(LWMiMethodMetaData.InParameters[i].CimType);

        Item.Checked := CheckBoxSelAllProps.Checked;

        Item.SubItems.Add(LWMiMethodMetaData.InParameters[i].&Type);
        s := GetDefaultValueWmiType(LWMiMethodMetaData.InParameters[i].&Type);
        Item.SubItems.Add(s);
        Item.SubItems.Add(LWMiMethodMetaData.InParameters[i].Description);
      end;

    end;

  finally
    ListViewMethodsParams.Items.EndUpdate;
  end;

  AutoResizeColumn(ListViewMethodsParams.Column[0]);
  AutoResizeColumn(ListViewMethodsParams.Column[1]);
end;

procedure TFrmWmiMethods.LoadWmiMethods(const Namespace: string; FirstTime: Boolean);
begin
  SetMsg(Format('Loading classes with methods in %s', [Namespace]));
  try
    if not ExistWmiClassesMethodsCache(Namespace) then
    begin
      ComboBoxClassesMethods.Items.BeginUpdate;
      try
        GetListWmiClassesWithMethods(Namespace, ComboBoxClassesMethods.Items);
        LabelClassesMethods.Caption := Format('Classes (%d)', [ComboBoxClassesMethods.Items.Count]);
        SaveWMIClassesMethodsToCache(Namespace, ComboBoxClassesMethods.Items);
      finally
        ComboBoxClassesMethods.Items.EndUpdate;
      end
    end
    else
      LoadWMIClassesMethodsFromCache(Namespace, ComboBoxClassesMethods.Items);

    if ComboBoxClassesMethods.Items.Count > 0 then
    begin
      if FirstTime then
      begin
        if Settings.LastWmiClassesMethods <> '' then
          ComboBoxClassesMethods.ItemIndex := ComboBoxClassesMethods.Items.IndexOf(Settings.LastWmiClassesMethods)
        else
          ComboBoxClassesMethods.ItemIndex := 0;
      end
      else
        ComboBoxClassesMethods.ItemIndex := 0
    end
    else
      ComboBoxClassesMethods.ItemIndex := -1;

    LoadMethodInfo(FirstTime);
  finally
    SetMsg('');
  end;
end;

procedure TFrmWmiMethods.SaveCurrentSettings;
begin
  Settings.LastWmiNameSpaceMethods := ComboBoxNamespaceMethods.Text;
  Settings.LastWmiClassesMethods := ComboBoxClassesMethods.Text;
  Settings.LastWmiMethod := ComboBoxMethods.Text;
end;

procedure TFrmWmiMethods.SetConsole(const Value: TMemo);
begin
  FConsole := Value;
  FrmCodeEditorMethod.Console := Value;
end;

procedure TFrmWmiMethods.SetSettings(const Value: TSettings);
begin
  FSettings := Value;
  FrmCodeEditorMethod.Settings := Value;
  FrmCodeEditorMethod.SourceLanguage := TSourceLanguages(Value.DefaultLanguage);

  LoadCurrentTheme(FrmCodeEditorMethod, Settings.CurrentTheme);
  LoadCurrentThemeFont(FrmCodeEditorMethod, Settings.FontName, Settings.FontSize);
end;

procedure TFrmWmiMethods.UMEditValueParam(var msg: TMessage);
var
  SubItemRect: TRect;
begin
  EditValueMethodParam.Visible := True;
  EditValueMethodParam.BringToFront;
  SubItemRect.Top := VALUE_METHODPARAM_COLUMN;
  SubItemRect.Left := LVIR_BOUNDS;
  ListViewMethodsParams.Perform(LVM_GETSUBITEMRECT, msg.wparam, lparam(@SubItemRect));
  MapWindowPoints(ListViewMethodsParams.handle, EditValueMethodParam.Parent.handle, SubItemRect, 2);
  FItem := ListViewMethodsParams.Items[msg.wparam];
  EditValueMethodParam.Text := FItem.SubItems[VALUE_METHODPARAM_COLUMN - 1];
  EditValueMethodParam.BoundsRect := SubItemRect;
  EditValueMethodParam.SetFocus;
end;

end.
