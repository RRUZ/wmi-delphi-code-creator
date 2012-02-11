{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiEvents                                                                                  }
{ unit for the WMI Delphi Code Creator                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uWmiEvents.pas.                                                             }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiEvents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, uMisc,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, uCodeEditor, uSettings, uWmi_Metadata, uComboBox;

const
  UM_EDITEVENTVALUE = WM_USER + 112;
  UM_EDITEVENTCOND  = WM_USER + 113;

type
  TFrmWmiEvents = class(TForm)
    Panel1: TPanel;
    LabelEventsConds: TLabel;
    LabelTargetInstance: TLabel;
    LabelEvents: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    ListViewEventsConds: TListView;
    EditValueEvent: TEdit;
    ComboBoxCond: TComboBox;
    ComboBoxNamespacesEvents: TComboBox;
    ComboBoxEvents: TComboBox;
    ComboBoxTargetInstance: TComboBox;
    EditEventWait: TEdit;
    ButtonGenerateEventCode: TButton;
    RadioButtonIntrinsic: TRadioButton;
    RadioButtonExtrinsic: TRadioButton;
    Splitter6: TSplitter;
    PanelEventCode: TPanel;
    procedure ComboBoxNamespacesEventsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonIntrinsicClick(Sender: TObject);
    procedure ComboBoxEventsChange(Sender: TObject);
    procedure ComboBoxTargetInstanceChange(Sender: TObject);
    procedure ListViewEventsCondsClick(Sender: TObject);
    procedure ButtonGenerateEventCodeClick(Sender: TObject);
    procedure ComboBoxCondExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FItem:      TListitem;
    FrmCodeEditorEvent  : TFrmCodeEditor;
    FSettings : TSettings;
    FSetLog: TProcLog;
    FConsole: TMemo;
    procedure UMEditEventValue(var msg: TMessage); message UM_EDITEVENTVALUE;
    procedure UMEditEventCond(var msg: TMessage); message UM_EDITEVENTCOND;
    procedure LoadEventsInfo;
    procedure LoadTargetInstanceProps;
    procedure GenerateEventCode(WmiMetaClassInfo : TWMiClassMetaData);
    procedure GenerateCode;
    procedure SetSettings(const Value: TSettings);
    procedure SetConsole(const Value: TMemo);
  public
    procedure LoadWmiEvents(const Namespace: string; FirstTime : Boolean=False);
    property Settings : TSettings read FSettings Write SetSettings;
    property SetLog : TProcLog read FSetLog Write FSetLog;
    property Console : TMemo read FConsole write SetConsole;
  end;

implementation

{$R *.dfm}

uses
  uGlobals,
  Winapi.CommCtrl,
  StrUtils,
  uSelectCompilerVersion,
  uWmiGenCode,
  uWmiOxygenCode,
  uWmiFPCCode,
  uWmiDelphiCode,
  uListView_Helper,
  uWmiClassTree;

const
  COND_EVENTPARAM_COLUMN   = 2;
  VALUE_EVENTPARAM_COLUMN  = 3;

procedure TFrmWmiEvents.ButtonGenerateEventCodeClick(Sender: TObject);
begin
  GenerateCode;
end;

procedure TFrmWmiEvents.ComboBoxCondExit(Sender: TObject);
begin
  if Assigned(FItem) then
  begin
    FItem.SubItems[COND_EVENTPARAM_COLUMN - 1] := TComboBox(Sender).Text;
    FItem := nil;
  end;
  PostMessage(handle, WM_NEXTDLGCTL, ListViewEventsConds.Handle, 1);
  TComboBox(Sender).Visible := True;
end;

procedure TFrmWmiEvents.ComboBoxEventsChange(Sender: TObject);
begin
  LoadEventsInfo;
end;

procedure TFrmWmiEvents.ComboBoxNamespacesEventsChange(Sender: TObject);
begin
  LoadWmiEvents(ComboBoxNamespacesEvents.Text);
end;

procedure TFrmWmiEvents.ComboBoxTargetInstanceChange(Sender: TObject);
begin
  LoadTargetInstanceProps;
end;

procedure TFrmWmiEvents.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Settings.LastWmiNameSpaceEvents:=ComboBoxNamespacesEvents.Text;
  Settings.LastWmiEvent:=ComboBoxEvents.Text;
  Settings.LastWmiEventIntrinsic:=RadioButtonIntrinsic.Checked;
  if RadioButtonIntrinsic.Checked then
   Settings.LastWmiEventTargetInstance:=ComboBoxTargetInstance.Text;

end;

procedure TFrmWmiEvents.FormCreate(Sender: TObject);
begin
  FrmCodeEditorEvent  := TFrmCodeEditor.Create(Self);
  FrmCodeEditorEvent.CodeGenerator:=GenerateCode;
  FrmCodeEditorEvent.Parent := PanelEventCode;
  FrmCodeEditorEvent.Show;
  FrmCodeEditorEvent.CompilerType:=Ct_Delphi;
end;

procedure TFrmWmiEvents.GenerateCode;
begin
 if ComboBoxEvents.ItemIndex>=0 then
  GenerateEventCode(CachedWMIClasses.GetWmiClass(ComboBoxNamespacesEvents.Text , ComboBoxEvents.Text));
end;

procedure TFrmWmiEvents.GenerateEventCode(WmiMetaClassInfo: TWMiClassMetaData);
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
        PropsOut.AddObject(ListViewEventsConds.Items[i].Caption, ListViewEventsConds.Items[i].Data);

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


procedure TFrmWmiEvents.ListViewEventsCondsClick(Sender: TObject);
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

  GenerateCode;
end;

procedure TFrmWmiEvents.LoadEventsInfo;
var
  Item: TListItem;
  i:    integer;
  WmiMetaClassInfo : TWMiClassMetaData;
begin
  //StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [ComboBoxNamespacesEvents.Text, ComboBoxEvents.Text]);

  ListVieweventsConds.Items.BeginUpdate;
  try
    ListVieweventsConds.Items.Clear;
    WmiMetaClassInfo:=CachedWMIClasses.GetWmiClass(ComboBoxNamespacesEvents.Text , ComboBoxEvents.Text);

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
    //SetMsg('');
  end;
  {
  if CheckBoxSelAllProps.Checked then
  ListBoxProperties.SelectAll;
  }
  AutoResizeColumn(ListViewEventsConds.Column[0]);
  AutoResizeColumn(ListViewEventsConds.Column[1]);
  AutoResizeColumn(ListViewEventsConds.Column[2]);

  if ComboBoxTargetInstance.Text<>'' then
   LoadTargetInstanceProps
  else
   GenerateCode;
end;


procedure TFrmWmiEvents.LoadTargetInstanceProps;
var
  i:    integer;
  Item: TListItem;
  WmiMetaClassInfo : TWMiClassMetaData;
begin

  ListVieweventsConds.Items.BeginUpdate;
  try
    for i := ListVieweventsConds.Items.Count - 1 downto 0 do
      if StartsStr(wbemTargetInstance, ListVieweventsConds.Items[i].Caption) then
        ListVieweventsConds.Items.Delete(i);

    if ComboBoxTargetInstance.Text <> '' then
    begin
      WmiMetaClassInfo := CachedWMIClasses.GetWmiClass(ComboBoxNamespacesEvents.Text , ComboBoxTargetInstance.Text);
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
    end;
  finally
    ListVieweventsConds.Items.EndUpdate;
  end;

  AutoResizeColumns([ListViewEventsConds.Column[0], ListViewEventsConds.Column[1],
    ListViewEventsConds.Column[2]]);

  GenerateCode;
end;

procedure TFrmWmiEvents.LoadWmiEvents(const Namespace: string; FirstTime: Boolean);
begin
  ComboBoxEvents.Items.BeginUpdate;
  try
    if FirstTime then
      RadioButtonIntrinsic.Checked:=Settings.LastWmiEventIntrinsic;

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
      GetListWmiClasses(Namespace, ComboBoxTargetInstance.Items, [], ['abstract'], True);
      SaveWMIClassesToCache(Namespace, ComboBoxTargetInstance.Items);
    end;

    ComboBoxTargetInstance.Items.Insert(0, '');
  finally
    ComboBoxTargetInstance.Items.EndUpdate;
  end;

  if ComboBoxTargetInstance.Items.Count > 0 then
  begin
    if FirstTime then
    begin
      if Settings.LastWmiEventTargetInstance<>'' then
        ComboBoxTargetInstance.ItemIndex := ComboBoxTargetInstance.Items.IndexOf(Settings.LastWmiEventTargetInstance)
      else
        ComboBoxTargetInstance.ItemIndex := 0;
    end
    else
    ComboBoxTargetInstance.ItemIndex := 0;
  end;

  if ComboBoxEvents.Items.Count > 0 then
  begin
    if FirstTime then
    begin
      if Settings.LastWmiEvent<>'' then
        ComboBoxEvents.ItemIndex := ComboBoxEvents.Items.IndexOf(Settings.LastWmiEvent)
      else
        ComboBoxEvents.ItemIndex := 0;
    end
    else
    ComboBoxEvents.ItemIndex := 0;
  end;

  LoadEventsInfo;
end;



procedure TFrmWmiEvents.RadioButtonIntrinsicClick(Sender: TObject);
begin
  LoadWmiEvents(ComboBoxNamespacesEvents.Text);
end;

procedure TFrmWmiEvents.SetConsole(const Value: TMemo);
begin
  FConsole := Value;
  FrmCodeEditorEvent.Console:=Value;
end;

procedure TFrmWmiEvents.SetSettings(const Value: TSettings);
begin
  FSettings := Value;
  FrmCodeEditorEvent.Settings:=Value;

  LoadCurrentTheme(FrmCodeEditorEvent, Settings.CurrentTheme);
  LoadCurrentThemeFont(FrmCodeEditorEvent ,Settings.FontName,Settings.FontSize);
end;

procedure TFrmWmiEvents.UMEditEventCond(var msg: TMessage);
var
  SubItemRect: TRect;
begin
  ComboBoxCond.Visible := True;
  ComboBoxCond.BringToFront;

  SubItemRect.Top  := COND_EVENTPARAM_COLUMN;
  SubItemRect.Left := LVIR_BOUNDS;
  ListViewEventsConds.Perform(LVM_GETSUBITEMRECT, msg.wparam, lparam(@SubItemRect));
  MapWindowPoints(ListViewEventsConds.Handle, ComboBoxCond.Parent.Handle, SubItemRect, 2);
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


procedure TFrmWmiEvents.UMEditEventValue(var msg: TMessage);
var
  SubItemRect: TRect;
begin
  EditValueEvent.Visible := True;
  EditValueEvent.BringToFront;
  SubItemRect.Top  := VALUE_EVENTPARAM_COLUMN;
  SubItemRect.Left := LVIR_BOUNDS;
  ListViewEventsConds.Perform(LVM_GETSUBITEMRECT, msg.wparam, lparam(@SubItemRect));
  MapWindowPoints(ListViewEventsConds.Handle, EditValueEvent.Parent.Handle, SubItemRect, 2);
  FItem := ListViewEventsConds.Items[msg.wparam];
  EditValueEvent.Text := Fitem.Subitems[VALUE_EVENTPARAM_COLUMN - 1];
  EditValueEvent.BoundsRect := SubItemRect;
  EditValueEvent.SetFocus;
end;
end.