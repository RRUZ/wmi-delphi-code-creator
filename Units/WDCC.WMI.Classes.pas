// **************************************************************************************************
//
// Unit WDCC.WMI.Classes
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
// The Original Code is WDCC.WMI.Classes.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.Classes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, WDCC.Misc,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, uWmi_Metadata, WDCC.CodeEditor, WDCC.Settings,
  WDCC.ComboBox,
  Vcl.ImgList, Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup,
  System.ImageList;

type
  TFrmWmiClasses = class(TForm)
    PanelMetaWmiInfo: TPanel;
    LabelProperties: TLabel;
    LabelClasses: TLabel;
    LabelNamespace: TLabel;
    ComboBoxClasses: TComboBox;
    ComboBoxNameSpaces: TComboBox;
    CheckBoxSelAllProps: TCheckBox;
    MemoClassDescr: TMemo;
    ListViewProperties: TListView;
    ButtonGetValues: TButton;
    PanelCode: TPanel;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    PopupActionBar1: TPopupActionBar;
    GridInstances: TMenuItem;
    TextInstances: TMenuItem;
    procedure ComboBoxNameSpacesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxClassesChange(Sender: TObject);
    procedure ListViewPropertiesClick(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure GridInstancesClick(Sender: TObject);
    procedure TextInstancesClick(Sender: TObject);
    procedure ButtonGetValuesClick(Sender: TObject);
  private
    FDataLoaded: Boolean;
    FSetMsg: TProcLog;
    FSetLog: TProcLog;
    FrmCodeEditor: TFrmCodeEditor;
    FSettings: TSettings;
    FConsole: TMemo;
    procedure GenerateCode;
    procedure SetConsole(const Value: TMemo);
    procedure SetSettings(const Value: TSettings);
    procedure LoadWmiProperties(WmiMetaClassInfo: TWMiClassMetaData);
    procedure LoadNameSpaces;
    procedure SaveCurrentSettings;
  public
    property SetMsg: TProcLog read FSetMsg Write FSetMsg;
    property SetLog: TProcLog read FSetLog Write FSetLog;
    property Console: TMemo read FConsole write SetConsole;

    property Settings: TSettings read FSettings Write SetSettings;
    procedure LoadWmiClasses(const Namespace: string);
    procedure LoadClassInfo;
    procedure GetValuesWmiPropertiesGrid(const Namespace, WmiClass: string);
    procedure GetValuesWmiPropertiesText(const Namespace, WmiClass: string);
    procedure GenerateConsoleCode(WmiMetaClassInfo: TWMiClassMetaData);
  end;

implementation

{$R *.dfm}

uses
  WDCC.Globals,
  Vcl.Styles,
  Vcl.Themes,
  Winapi.CommCtrl,
  System.Win.ComObj,
  WDCC.WMI.ViewPropsValues,
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

procedure TFrmWmiClasses.GridInstancesClick(Sender: TObject);
begin
  GetValuesWmiPropertiesGrid(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

procedure TFrmWmiClasses.ButtonGetValuesClick(Sender: TObject);
var
  LPoint: TPoint;
begin
  if Win32MajorVersion < 6 then
  begin
    LPoint.X := ButtonGetValues.Left;
    LPoint.Y := ButtonGetValues.Top + ButtonGetValues.Height;
    LPoint := ClientToScreen(LPoint);
    PopupActionBar1.Popup(LPoint.X, LPoint.Y);
  end
  else
    GridInstancesClick(Sender);
end;

procedure TFrmWmiClasses.CheckBoxSelAllPropsClick(Sender: TObject);
var
  LIndex: integer;
begin
  for LIndex := 0 to ListViewProperties.Items.Count - 1 do
    ListViewProperties.Items[LIndex].Checked := CheckBoxSelAllProps.Checked;

  GenerateCode;
end;

procedure TFrmWmiClasses.ComboBoxClassesChange(Sender: TObject);
begin
  LoadClassInfo;
  SaveCurrentSettings;
end;

procedure TFrmWmiClasses.ComboBoxNameSpacesChange(Sender: TObject);
begin
  LoadWmiClasses(TComboBox(Sender).Text);
  ComboBoxClasses.ItemIndex := 0;
  LoadClassInfo;
  SaveCurrentSettings;
end;

procedure TFrmWmiClasses.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveCurrentSettings;
end;

procedure TFrmWmiClasses.FormCreate(Sender: TObject);
begin
  FDataLoaded := False;
  FrmCodeEditor := TFrmCodeEditor.Create(Self);
  FrmCodeEditor.CodeGenerator := GenerateCode;
  FrmCodeEditor.Parent := PanelCode;
  FrmCodeEditor.OldParent := PanelCode;
  FrmCodeEditor.Show;
  // FrmCodeEditor.Dock(PanelCode, PanelCode.BoundsRect);

  // FrmCodeEditor.Settings:=Settings;
  // FrmCodeEditor.Console:=MemoConsole;
  FrmCodeEditor.SourceLanguage := Lng_Delphi;
end;

procedure TFrmWmiClasses.FormShow(Sender: TObject);
begin
  if not FDataLoaded then
    LoadNameSpaces;
end;

procedure TFrmWmiClasses.GenerateCode;
begin
  if (Parent <> nil) and (Parent is TTabSheet) then
    TTabSheet(Parent).Caption := Format('WMI Class %s CodeGen      ', [FrmCodeEditor.ComboBoxLanguageSel.Text]);;

  if ComboBoxClasses.ItemIndex >= 0 then
    GenerateConsoleCode(CachedWMIClasses.GetWmiClass(ComboBoxNameSpaces.Text, ComboBoxClasses.Text));
end;

procedure TFrmWmiClasses.GenerateConsoleCode(WmiMetaClassInfo: TWMiClassMetaData);
var
  i, j: integer;
  Props: TStrings;
  Str: string;
  WmiCodeGenerator: TWmiClassCodeGenerator;
begin
  if not Assigned(WmiMetaClassInfo) then
    Exit;

  if @FSetLog <> nil then
    SetLog(Format('Generating code for %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

  // Object Pascal console Code
  Props := TStringList.Create;
  try
    Str := '';
    for i := 0 to ListViewProperties.Items.Count - 1 do
      if ListViewProperties.Items[i].Checked then
        Str := Str + Format('%s=%s, ', [ListViewProperties.Items[i].Caption, ListViewProperties.Items[i].SubItems[0]]);

    Props.CommaText := Str;

    j := 0;
    for i := 0 to ListViewProperties.Items.Count - 1 do
      if ListViewProperties.Items[i].Checked then
      begin
        Props.Objects[j] := ListViewProperties.Items[i].Data; // CimType
        inc(j);
      end;

    case FrmCodeEditor.SourceLanguage of
      Lng_Delphi:
        begin
          WmiCodeGenerator := TDelphiWmiClassCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.UseHelperFunctions := FSettings.DelphiWmiClassHelperFuncts;
            WmiCodeGenerator.ModeCodeGeneration := TWmiCode(FSettings.DelphiWmiClassCodeGenMode);
            WmiCodeGenerator.GenerateCode(Props);
            FrmCodeEditor.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_FPC:
        begin
          WmiCodeGenerator := TFPCWmiClassCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.UseHelperFunctions := FSettings.FPCWmiClassHelperFuncts;
            WmiCodeGenerator.GenerateCode(Props);
            FrmCodeEditor.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_Oxygen:
        begin
          WmiCodeGenerator := TOxygenWmiClassCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Props);
            FrmCodeEditor.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_BorlandCpp:
        begin
          WmiCodeGenerator := TBorlandCppWmiClassCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Props);
            FrmCodeEditor.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_VSCpp:
        begin
          WmiCodeGenerator := TVsCppWmiClassCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Props);
            FrmCodeEditor.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;

      Lng_CSharp:
        begin
          WmiCodeGenerator := TCSharpWmiClassCodeGenerator.Create;
          try
            WmiCodeGenerator.WMiClassMetaData := WmiMetaClassInfo;
            WmiCodeGenerator.UseHelperFunctions := False;
            WmiCodeGenerator.GenerateCode(Props);
            FrmCodeEditor.SourceCode := WmiCodeGenerator.OutPutCode;
          finally
            WmiCodeGenerator.Free;
          end;
        end;
    end;

  finally
    Props.Free;
  end;
end;

procedure TFrmWmiClasses.GetValuesWmiPropertiesGrid(const Namespace, WmiClass: string);
var
  Props: TStringList;
  i: integer;
begin
  if (ListViewProperties.Items.Count > 0) and (WmiClass <> '') and (Namespace <> '') then
  begin
    Props := TStringList.Create;
    try
      for i := 0 to ListViewProperties.Items.Count - 1 do
        if ListViewProperties.Items[i].Checked then
          Props.Add(ListViewProperties.Items[i].Caption);

      ListValuesWmiProperties(Namespace, WmiClass, Props, SetLog, GridView);
    finally
      Props.Free;
    end;
  end;
end;

procedure TFrmWmiClasses.GetValuesWmiPropertiesText(const Namespace, WmiClass: string);
var
  Props: TStringList;
  i: integer;
begin
  if (ListViewProperties.Items.Count > 0) and (WmiClass <> '') and (Namespace <> '') then
  begin
    Props := TStringList.Create;
    try
      for i := 0 to ListViewProperties.Items.Count - 1 do
        if ListViewProperties.Items[i].Checked then
          Props.Add(ListViewProperties.Items[i].Caption);

      ListValuesWmiProperties(Namespace, WmiClass, Props, SetLog, TextView);
    finally
      Props.Free;
    end;
  end;
end;

procedure TFrmWmiClasses.ListViewPropertiesClick(Sender: TObject);

  procedure SetCheck(const CheckBox: TCheckBox; const Value: Boolean);
  var
    NotifyEvent: TNotifyEvent;
  begin
    with CheckBox do
    begin
      NotifyEvent := OnClick;
      OnClick := nil;
      Checked := Value;
      OnClick := NotifyEvent;
    end;
  end;

begin
  if CheckBoxSelAllProps.Checked then
    SetCheck(CheckBoxSelAllProps, False);
  GenerateCode;
end;

procedure TFrmWmiClasses.LoadClassInfo;
var
  WmiMetaClassInfo: TWMiClassMetaData;
begin
  if ComboBoxClasses.ItemIndex = -1 then
    Exit;
  try
    WmiMetaClassInfo := CachedWMIClasses.GetWmiClass(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);

    if Assigned(WmiMetaClassInfo) then
    begin
      SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));
      MemoClassDescr.Text := WmiMetaClassInfo.Description;
      if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';

      LoadWmiProperties(WmiMetaClassInfo);
    end;
  finally
    if @FSetMsg <> nil then
      SetMsg('');
  end;
end;

procedure TFrmWmiClasses.LoadNameSpaces;
var
  FNameSpaces: TStrings;
begin
  FNameSpaces := TStringList.Create;
  try
    FNameSpaces.AddStrings(CachedWMIClasses.NameSpaces);
    ComboBoxNameSpaces.Items.AddStrings(FNameSpaces);

    if FSettings.LastWmiNameSpace <> '' then
      ComboBoxNameSpaces.ItemIndex := ComboBoxNameSpaces.Items.IndexOf(FSettings.LastWmiNameSpace)
    else
      ComboBoxNameSpaces.ItemIndex := 0;

    LoadWmiClasses(ComboBoxNameSpaces.Text);
    if FSettings.LastWmiClass <> '' then
      ComboBoxClasses.ItemIndex := ComboBoxClasses.Items.IndexOf(FSettings.LastWmiClass)
    else
      ComboBoxClasses.ItemIndex := 0;

    LoadClassInfo;
  finally
    FNameSpaces.Free;
  end;
  FDataLoaded := True;
end;

procedure TFrmWmiClasses.LoadWmiClasses(const Namespace: string);
var
  FClasses: TStringList;
begin
  SetMsg(Format('Loading Classes of %s', [Namespace]));

  FClasses := TStringList.Create;
  try
    FClasses.Sorted := True;
    FClasses.BeginUpdate;
    try
      try
        if not ExistWmiClassesCache(Namespace) then
        begin
          GetListWmiClasses(Namespace, FClasses, [], ['abstract'], True);
          SaveWMIClassesToCache(Namespace, FClasses);
        end
        else
          LoadWMIClassesFromCache(Namespace, FClasses);
      except
        on E: EOleSysError do
          if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
          begin
            if @FSetLog <> nil then
              SetLog(Format('Access denied  %s %s  Code : %x', ['GetListWmiClasses', E.Message, E.ErrorCode]))
          end
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
  finally
    FClasses.Free; // New ¡¡¡ Added without FrmWMIExplorer
  end;
  SetMsg('');
end;

procedure TFrmWmiClasses.LoadWmiProperties(WmiMetaClassInfo: TWMiClassMetaData);
var
  LIndex: integer;
  LItem: TListItem;
begin
  // StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
  ListViewProperties.Items.BeginUpdate;
  try
    ListViewProperties.Items.Clear;

    for LIndex := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
    begin
      LItem := ListViewProperties.Items.Add;
      LItem.Caption := WmiMetaClassInfo.Properties[LIndex].Name;
      LItem.SubItems.Add(WmiMetaClassInfo.Properties[LIndex].&Type);
      LItem.SubItems.Add(WmiMetaClassInfo.Properties[LIndex].Description);
      LItem.Checked := CheckBoxSelAllProps.Checked;
      LItem.Data := Pointer(WmiMetaClassInfo.Properties[LIndex].CimType); // Cimtype
    end;

    LabelProperties.Caption := Format('%d Properties of %s:%s', [ListViewProperties.Items.Count,
      WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
  finally
    ListViewProperties.Items.EndUpdate;
  end;

  SetMsg('');

  for LIndex := 0 to ListViewProperties.Columns.Count - 1 do
    AutoResizeColumn(ListViewProperties.Column[LIndex]);

  ListViewProperties.Repaint;

  GenerateCode;
end;

procedure TFrmWmiClasses.SaveCurrentSettings;
begin
  FSettings.LastWmiNameSpace := ComboBoxNameSpaces.Text;
  FSettings.LastWmiClass := ComboBoxClasses.Text;
end;

procedure TFrmWmiClasses.SetConsole(const Value: TMemo);
begin
  FConsole := Value;
  FrmCodeEditor.Console := Value;
end;

procedure TFrmWmiClasses.SetSettings(const Value: TSettings);
begin
  FSettings := Value;
  FrmCodeEditor.Settings := Value;
  FrmCodeEditor.SourceLanguage := TSourceLanguages(Value.DefaultLanguage);

  LoadCurrentTheme(FrmCodeEditor, FSettings.CurrentTheme);
  LoadCurrentThemeFont(FrmCodeEditor, FSettings.FontName, FSettings.FontSize);
end;

procedure TFrmWmiClasses.TextInstancesClick(Sender: TObject);
begin
  GetValuesWmiPropertiesText(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

end.
