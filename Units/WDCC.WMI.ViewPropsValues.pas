// **************************************************************************************************
//
// Unit WDCC.WMI.ViewPropsValues
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
// The Original Code is WDCC.WMI.ViewPropsValues.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.ViewPropsValues;

interface

{ .$DEFINE USE_ASYNCWMIQUERY }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, SynEdit, ExtCtrls, WDCC.Misc,
  Generics.Collections, uWmi_Metadata,
  ImgList, Contnrs, ActiveX, StdCtrls, Vcl.Menus, {$IFDEF USE_ASYNCWMIQUERY} WbemScripting_TLB, {$ENDIF}
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, Vcl.ActnList, Vcl.ActnMan,
  System.Actions, System.ImageList;

{$IFNDEF USE_ASYNCWMIQUERY}

const
  WM_WMI_THREAD_FINISHED = WM_USER + 666;
{$ENDIF}

type
  TWMIQueryCallbackLog = procedure(const msg: string) of object;
  TWmi_ViewPropsValuesMode = (GridView, TextView);

{$IFNDEF USE_ASYNCWMIQUERY}

  TWMIQueryToCustomView = class(TThread)
  private
    FSuccess: HResult;
    FEnum: IEnumvariant;
    FSWbemLocator: OleVariant;
    FWMIService: OleVariant;
    FWbemObjectSet: OleVariant;
    FWbemObject: OleVariant;
    FWQL: string;
    FServer: string;
    FUser: string;
    FPassword: string;
    FNameSpace: string;
    FListView: TListView;
    FTextOutput: TMemo;
    FProperties: TStrings;
    FCallback: TWMIQueryCallbackLog;
    FMsg: string;
    FValues: TList<TStrings>;
    FParentHandle: THandle;
    FMode: TWmi_ViewPropsValuesMode;
    FTextRecord: string;
    procedure CreateColumns;
    procedure SetListViewSize;
    procedure AdjustColumnsWidth;
    procedure SendMsg;
    procedure AddTextRecord;
  public
    constructor Create(const Server, User, PassWord, NameSpace, WQL: string; ListWMIProperties: TStrings;
      ListView: TListView; CallBack: TWMIQueryCallbackLog; Values: TList<TStrings>; ParentHandle: THandle;
      TextOutput: TMemo; Mode: TWmi_ViewPropsValuesMode); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;
{$ENDIF}

  TFrmWmiVwProps = class(TForm)
    ListViewWmi: TListView;
    PageControl1: TPageControl;
    TabSheetProps: TTabSheet;
    Panel1: TPanel;
    listViewImages: TImageList;
    TabSheet1: TTabSheet;
    ListViewGrid: TListView;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    EditClass: TEdit;
    Label1: TLabel;
    EditNameSpace: TEdit;
    Label2: TLabel;
    BtnUrl: TButton;
    TabSheet2: TTabSheet;
    ListViewPropsLinks: TListView;
    PopupActionBar1: TPopupActionBar;
    Viewdetails1: TMenuItem;
    PopupActionBar2: TPopupActionBar;
    ViewDetails2: TMenuItem;
    Checkforonlinedocumentation1: TMenuItem;
    ActionManager1: TActionManager;
    ActionViewPropDetails: TAction;
    ActionViewDetailsProps: TAction;
    ActionCheckOnlineDocs: TAction;
    ActionOpenRegistry: TAction;
    OpeninWindowsRegistry1: TMenuItem;
    N1: TMenuItem;
    ActionSMBIOS: TAction;
    OpenSMBIOSReferenceSpecification1: TMenuItem;
    MemoInstances: TMemo;
    PopupActionBar3: TPopupActionBar;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnUrlClick(Sender: TObject);
    procedure ListViewGridData(Sender: TObject; Item: TListItem);
    procedure ActionViewPropDetailsUpdate(Sender: TObject);
    procedure ActionViewPropDetailsExecute(Sender: TObject);
    procedure ActionCheckOnlineDocsUpdate(Sender: TObject);
    procedure ActionViewDetailsPropsUpdate(Sender: TObject);
    procedure ActionViewDetailsPropsExecute(Sender: TObject);
    procedure ActionCheckOnlineDocsExecute(Sender: TObject);
    procedure ActionOpenRegistryUpdate(Sender: TObject);
    procedure ActionOpenRegistryExecute(Sender: TObject);
    procedure ActionSMBIOSUpdate(Sender: TObject);
    procedure ActionSMBIOSExecute(Sender: TObject);
  private

{$IFDEF USE_ASYNCWMIQUERY}
    FSWbemLocator: ISWbemLocator;
    FWMIService: ISWbemServices;
    FSink: TSWbemSink;
{$ELSE}
    FThreadFinished: Boolean;
    FThread: TWMIQueryToCustomView;
{$ENDIF}
    FValues: TObjectList<TStrings>;
    FWmiClass: string;
    FWmiNamespace: string;
    FWQL: TStrings;
    FWQLProperties: TStrings;
    FDataLoaded: Boolean;
    FContainValues: Boolean;
    FWMIProperties: TStrings;
    FWmiMetaData: TWMiClassMetaData;
    FSetLog: TProcLog;
    FMode: TWmi_ViewPropsValuesMode;
    procedure Log(const msg: string);
    procedure SetWmiClass(const Value: string);
    procedure SetWmiNamespace(const Value: string);
    procedure ShowDetailsData();

    procedure LoadPropsLinks; // MappedStrings
    procedure ShowDetailsProps;
    procedure CheckOnlineDoc;

{$IFDEF USE_ASYNCWMIQUERY}
    procedure RunAsyncWQL;
    procedure CreateColumns;
    procedure EventReceived(ASender: TObject; const objWbemObject: ISWbemObject;
      const objWbemAsyncContext: ISWbemNamedValueSet);
    procedure EventCompleted(ASender: TObject; iHResult: WbemErrorEnum; const objWbemErrorObject: ISWbemObject;
      const objWbemAsyncContext: ISWbemNamedValueSet);

    procedure EventProgress(ASender: TObject; iUpperBound: Integer; iCurrent: Integer; const strMessage: WideString;
      const objWbemAsyncContext: ISWbemNamedValueSet);
{$ELSE}
    procedure OnWMIThreadFinished(var msg: TMessage); message WM_WMI_THREAD_FINISHED;
    procedure SetMode(const Value: TWmi_ViewPropsValuesMode);
{$ENDIF}
  public
    property ContainValues: Boolean Read FContainValues;
    property WQLProperties: TStrings Read FWQLProperties Write FWQLProperties;
    property WmiClass: string Read FWmiClass Write SetWmiClass;
    property WmiNamespace: string Read FWmiNamespace Write SetWmiNamespace;
    property WQL: TStrings Read FWQL;
    property SetLog: TProcLog read FSetLog Write FSetLog;
    property Mode: TWmi_ViewPropsValuesMode read FMode Write SetMode default GridView;
    procedure LoadValues(Properties: TStringList); cdecl;
  end;

procedure ListValuesWmiProperties(const NameSpace, WmiClass: string; Properties: TStringList; SetLog: TProcLog;
  Mode: TWmi_ViewPropsValuesMode = GridView);

implementation

uses
  WDCC.OnlineResources,
  WDCC.StdActions.PopMenu,
  ComObj,
  CommCtrl,
  StrUtils,
  ShellAPi,
  Registry,
  WDCC.ListView.Helper,
  WDCC.PropValueList;

{$R *.dfm}

procedure AutoResizeVirtualListView(const ListView: TListView; Values: TList<TStrings>; MaxWitdh: Integer = 200);
Var
  i, j: Integer;
  TopIndex: Integer;
  BottomIndex: Integer;
  psz: string;
  cw, lw: Integer;

begin
  if ListView.Items.Count > 0 then
  begin
    TopIndex := ListView.Perform(LVM_GETTOPINDEX, 0, 0);
    BottomIndex := TopIndex + ListView.Perform(LVM_GETCOUNTPERPAGE, 0, 0);
    if BottomIndex > ListView.Items.Count - 1 then
      BottomIndex := ListView.Items.Count;

    for j := 0 to ListView.Columns.Count - 1 do
    begin
      cw := ListView.Columns.Items[j].Width;

      for i := TopIndex to BottomIndex do
      begin
        psz := Values[i].Strings[j];
        lw := ListView_GetStringWidth(ListView.Handle, PChar(psz));
        if lw > cw then
          cw := lw;

        if cw > MaxWitdh then
        begin
          cw := MaxWitdh;
          break;
        end;
      end;

      if ListView.Columns.Items[j].Width <> cw then
        ListView.Columns.Items[j].Width := cw + 20;
    end;
  end;
end;

procedure ListValuesWmiProperties(const NameSpace, WmiClass: string; Properties: TStringList; SetLog: TProcLog;
  Mode: TWmi_ViewPropsValuesMode = GridView);
var
  Frm: TFrmWmiVwProps;
begin
  if (WmiClass <> '') and (NameSpace <> '') then
  begin
    Frm := TFrmWmiVwProps.Create(nil);
    Frm.Mode := Mode;
    Frm.WmiClass := WmiClass;
    Frm.WmiNamespace := NameSpace;
    Frm.Caption := 'Properties Values for the class ' + WmiClass;
    Frm.SetLog := SetLog;
    Frm.LoadValues(Properties);
    Frm.Show();
  end;
end;

procedure TFrmWmiVwProps.ActionCheckOnlineDocsExecute(Sender: TObject);
begin
  CheckOnlineDoc;
end;

procedure TFrmWmiVwProps.ActionCheckOnlineDocsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ListViewPropsLinks.Items.Count > 0;
end;

procedure TFrmWmiVwProps.ActionOpenRegistryExecute(Sender: TObject);
var
  Key: string;
  Reg: TRegistry;
begin
  if (ListViewPropsLinks.Selected <> nil) and (ListViewPropsLinks.Selected.SubItems.Count > 1) and
    (SameText('Win32Registry', ListViewPropsLinks.Selected.SubItems[0])) then
  begin
    Key := ListViewPropsLinks.Selected.SubItems[1];
    Reg := TRegistry.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Applets\Regedit', false) then
      begin
        Reg.WriteString('Lastkey', Key);
      end;
    finally
      Reg.Free;
    end;
    ShellExecute(Handle, 'open', 'regedit.exe', nil, nil, SW_SHOW);
  end;
end;

procedure TFrmWmiVwProps.ActionOpenRegistryUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (ListViewPropsLinks.Selected <> nil) and (ListViewPropsLinks.Selected.SubItems.Count > 0)
    and (SameText('Win32Registry', ListViewPropsLinks.Selected.SubItems[0]));

end;

procedure TFrmWmiVwProps.ActionSMBIOSExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://dmtf.org/sites/default/files/standards/documents/DSP0134_2.7.1.pdf'), nil,
    nil, SW_SHOW);
end;

procedure TFrmWmiVwProps.ActionSMBIOSUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (ListViewPropsLinks.Selected <> nil) and (ListViewPropsLinks.Selected.SubItems.Count > 0)
    and (SameText('SMBIOS', ListViewPropsLinks.Selected.SubItems[0]));
end;

procedure TFrmWmiVwProps.ActionViewDetailsPropsExecute(Sender: TObject);
begin
  ShowDetailsProps;
end;

procedure TFrmWmiVwProps.ActionViewDetailsPropsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := ListViewPropsLinks.Items.Count > 0;
end;

procedure TFrmWmiVwProps.ActionViewPropDetailsExecute(Sender: TObject);
begin
  ShowDetailsData();
end;

procedure TFrmWmiVwProps.ActionViewPropDetailsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FValues.Count > 0;
end;

procedure TFrmWmiVwProps.BtnUrlClick(Sender: TObject);
var
  URL: string;
begin
  // ShellExecute(Handle, 'open', PChar(EditURL.Text), nil, nil, SW_SHOW);
  URL := GetURLBySearchTerm('MSDN WMI ' + EditClass.Text);
  if (URL <> '') and StartsText('http://msdn.microsoft.com', URL) then
    ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOW)
  else
    MsgWarning(Format('MSDN documentation for the %s class was not found', [EditClass.Text]));
end;

procedure TFrmWmiVwProps.CheckOnlineDoc;
Var
  Frm: TFrmOnlineResources;
  s: string;
  i: Integer;
begin
  if ListViewPropsLinks.Selected = nil then
    exit;
  if ListViewPropsLinks.Selected.SubItems.Count < 2 then
    exit;

  Frm := TFrmOnlineResources.Create(nil);
  s := '';
  for i := 1 to ListViewPropsLinks.Selected.SubItems.Count - 1 do
    s := s + ' "' + ListViewPropsLinks.Selected.SubItems[i] + '"';
  Frm.SearchKey := Format('msdn %s', [s]);
  Frm.GetResults;
  if Frm.ListViewURL.Items.Count > 0 then
    Frm.Show
  else if (Frm.ListViewURL.Items.Count = 0) and
    MsgQuestion('Related online information was not found. Do you want try with another search terms?') then
    Frm.Show
  else
    Frm.Free;
end;

{$IFDEF USE_ASYNCWMIQUERY}

procedure TFrmWmiVwProps.CreateColumns;
var
  LIndex: Integer;
  ListColumn: TListColumn;
begin
  ListViewGrid.Items.BeginUpdate;
  try
    for LIndex := 0 to FWMIProperties.Count - 1 do
    begin
      ListColumn := ListViewGrid.Columns.Add;
      ListColumn.Caption := FWMIProperties[LIndex];
      ListColumn.Width := 80;
    end;
  finally
    ListViewGrid.Items.EndUpdate;
  end;
end;

procedure TFrmWmiVwProps.EventCompleted(ASender: TObject; iHResult: WbemErrorEnum;
  const objWbemErrorObject: ISWbemObject; const objWbemAsyncContext: ISWbemNamedValueSet);
begin
  if FValues.Count = 0 then
    Log('Does not exist instances for this wmi class')
  else
  begin
    Log(Format('%d records found', [FValues.Count]));
    AutoResizeVirtualListView(ListViewGrid, FValues);
  end;
end;

procedure TFrmWmiVwProps.EventProgress(ASender: TObject; iUpperBound, iCurrent: Integer; const strMessage: WideString;
  const objWbemAsyncContext: ISWbemNamedValueSet);
begin
  Log(strMessage);
end;

procedure TFrmWmiVwProps.EventReceived(ASender: TObject; const objWbemObject: ISWbemObject;
  const objWbemAsyncContext: ISWbemNamedValueSet);
var
  Props: ISWbemPropertySet;
  PropItem: OleVariant;
  oEnumProp: IEnumvariant;
  iValue: Cardinal;
  CimType: Integer;
  RowData: TStrings;
  i: Integer;
begin
  Props := objWbemObject.Properties_;
  oEnumProp := IUnknown(Props._NewEnum) as IEnumvariant;

  if FWMIProperties.Count = 0 then
  begin
    while oEnumProp.Next(1, PropItem, iValue) = 0 do
    begin
      CimType := PropItem.CimType;
      FWMIProperties.AddObject(PropItem.Name, TObject(CimType));
      PropItem := Unassigned;
    end;

    FWMIProperties.AddObject('Object Path', TObject(wbemCimtypeString));
    if FMode = GridView then
      CreateColumns;
  end;

  RowData := TStringList.Create;
  if Assigned(FValues) then
    FValues.Add(RowData);

  for i := 0 to FWMIProperties.Count - 1 - 1 do
    RowData.Add(FormatWbemValue(Props.Item(FWMIProperties[i], 0).Get_Value, Integer(FWMIProperties.Objects[i])));

  RowData.Add(VarStrNull(objWbemObject.Path_.RelPath));
  ListViewGrid.Items.Count := FValues.Count;

  Log(Format('%d records retrieved', [FValues.Count]));
  Props := nil;
end;
{$ENDIF}

procedure TFrmWmiVwProps.FormActivate(Sender: TObject);
begin
  if not FDataLoaded then
    LoadValues(nil);
end;

procedure TFrmWmiVwProps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmWmiVwProps.FormCreate(Sender: TObject);
begin
{$IFDEF USE_ASYNCWMIQUERY}
  FSWbemLocator := nil;
  FWMIService := nil;
  FSink := nil;
{$ELSE}
  FThreadFinished := false;
  FThread := nil;
{$ENDIF}
  ListViewWmi.Visible := false;
  MemoInstances.Visible := false;
  Mode := GridView;
  FWmiMetaData := nil;
  FDataLoaded := false;
  FWQLProperties := TStringList.Create;
  FWQL := TStringList.Create;
  FContainValues := false;
  ListViewGrid.DoubleBuffered := True;
  FValues := TObjectList<TStrings>.Create(True);
  FWMIProperties := TStringList.Create;
  // NullStrictConvert:=False;

  FillPopupActionBar(PopupActionBar3);
  AssignStdActionsPopUpMenu(Self, PopupActionBar3);

end;

procedure TFrmWmiVwProps.FormDestroy(Sender: TObject);
begin
{$IFDEF USE_ASYNCWMIQUERY}
  if (FSink <> nil) then
  begin
    FSink.Cancel;
    FSink.Disconnect;
    FreeAndNil(FSink);
    FSWbemLocator := nil;
    FWMIService := nil;
  end;
{$ELSE}
  try
    if (not FThreadFinished) and Assigned(FThread) and not FThread.Terminated then
      FThread.Terminate;
  except
    on E: Exception do
      SetLog(Format('Exception  %s %s', ['TFrmWmiVwProps.Terminate', E.Message]));
  end;

{$ENDIF}
  FWMIProperties.Free;
  FWQLProperties.Free;
  FWQL.Free;

  if FWmiMetaData <> nil then
    FWmiMetaData.Free;

  FValues.Free;
end;

procedure TFrmWmiVwProps.ListViewGridData(Sender: TObject; Item: TListItem);
Var
  RowData: TStrings;
  j: Integer;
begin
  if Item.Index <= FValues.Count then
  begin
    RowData := FValues[Item.Index];
    for j := 0 to RowData.Count - 1 do
    begin
      if j = 0 then
        Item.Caption := RowData[j]
      else
        Item.SubItems.Add(RowData[j]);
    end;
  end;
end;

procedure TFrmWmiVwProps.LoadPropsLinks;
var
  i: Integer;
  WMiQualifierMetaData: TWMiQualifierMetaData;
  Item: TListItem;
  s, MappingStrings: string;
begin
  ListViewPropsLinks.Items.BeginUpdate;
  try
    ListViewPropsLinks.Items.Clear;
    for i := 0 to FWmiMetaData.PropertiesCount - 1 do
      for WMiQualifierMetaData in FWmiMetaData.Properties[i].Qualifiers do
        if SameText('MappingStrings', WMiQualifierMetaData.Name) then
        begin
          Item := ListViewPropsLinks.Items.Add;
          Item.Caption := FWmiMetaData.Properties[i].Name;
          // [MIF.DMTF|Operational State|003.5|MIB.IETF|HOST-RESOURCES-MIB.hrDeviceStatus]
          MappingStrings := WMiQualifierMetaData.Value;
          if (MappingStrings <> '') and (MappingStrings[1] = '[') then
            MappingStrings := Copy(MappingStrings, 2, Length(MappingStrings));

          if (MappingStrings <> '') and (MappingStrings[Length(MappingStrings)] = ']') then
            MappingStrings := Copy(MappingStrings, 1, Length(MappingStrings) - 1);

          for s in SplitString(MappingStrings, '|') do
            Item.SubItems.Add(s);

          Item.ImageIndex := -1;
          if Item.SubItems.Count > 0 then
            if MatchText(Item.SubItems[0], ['WMI', 'MIF.DMTF']) then
              Item.ImageIndex := 2
            else if MatchText(Item.SubItems[0], ['Win32Registry']) then
              Item.ImageIndex := 1
            else if MatchText(Item.SubItems[0], ['Win32API', 'Win32']) then
              Item.ImageIndex := 0
            else if MatchText(Item.SubItems[0], ['SMBIOS']) then
              Item.ImageIndex := 3
            else if MatchText(Item.SubItems[0], ['MIB.IETF']) then
              Item.ImageIndex := 4;
        end;
  finally
    ListViewPropsLinks.Items.EndUpdate;
  end;
  AutoResizeListView(ListViewPropsLinks);
end;

procedure TFrmWmiVwProps.LoadValues(Properties: TStringList);
var
  i: Integer;
begin
  FDataLoaded := True;
  FWmiMetaData := TWMiClassMetaData.Create(WmiNamespace, WmiClass);

  FWQLProperties.Clear;
  if (Properties = nil) or (Properties.Count = 0) then
  begin
    for i := 0 to FWmiMetaData.PropertiesCount - 1 do
      FWQLProperties.Add(FWmiMetaData.Properties[i].Name)
  end
  else
    for i := 0 to Properties.Count - 1 do
      FWQLProperties.Add(Properties[i]);

  FWQL.Add('Select');
  if FWQLProperties.Count = 0 then
    FWQL.Add(' * ')
  else
    for i := 0 to FWQLProperties.Count - 1 do
      if i < FWQLProperties.Count - 1 then
        FWQL.Add(FWQLProperties[i] + ',')
      else
        FWQL.Add(FWQLProperties[i]);

  FWQL.Add(' From ' + FWmiClass);

  LoadPropsLinks;
{$IFDEF USE_ASYNCWMIQUERY}
  RunAsyncWQL;
{$ELSE}
  FThread := TWMIQueryToCustomView.Create('.', '', '', FWmiNamespace, FWQL.Text, FWMIProperties, ListViewGrid, Log,
    FValues, Handle, MemoInstances, Mode)
{$ENDIF}
end;

procedure TFrmWmiVwProps.Log(const msg: string);
begin
  StatusBar1.SimpleText := msg;
end;

{$IFNDEF USE_ASYNCWMIQUERY}

procedure TFrmWmiVwProps.OnWMIThreadFinished(var msg: TMessage);
begin
  FThreadFinished := True;
end;
{$ENDIF}
{$IFDEF USE_ASYNCWMIQUERY}

procedure TFrmWmiVwProps.RunAsyncWQL;
begin
  FSWbemLocator := CoSWbemLocator.Create;
  FWMIService := FSWbemLocator.ConnectServer(wbemLocalhost, 'root\CIMV2', '', '', '', '', 0, nil);
  FSink := TSWbemSink.Create(Self);
  FSink.OnObjectReady := EventReceived;
  FSink.OnCompleted := EventCompleted;
  FSink.OnProgress := EventProgress;
  FWMIService.ExecQueryAsync(FSink.DefaultInterface, FWQL.Text, 'WQL', wbemFlagSendStatus, nil, nil);
end;
{$ENDIF}

procedure TFrmWmiVwProps.SetMode(const Value: TWmi_ViewPropsValuesMode);
begin
  FMode := Value;
  if FMode = GridView then
    ListViewWmi.Visible := True
  else if FMode = TextView then
    MemoInstances.Visible := True;
end;

procedure TFrmWmiVwProps.SetWmiClass(const Value: string);
begin
  FWmiClass := Value;
  EditClass.Text := Value;
  // EditURL.Text:=Format(UrlWmiHelp, [Value]);
end;

procedure TFrmWmiVwProps.SetWmiNamespace(const Value: string);
begin
  FWmiNamespace := Value;
  EditNameSpace.Text := Value;
end;

procedure TFrmWmiVwProps.ShowDetailsData;
Var
  Frm: TFrmValueList;
  i: Integer;
  RowData: TStrings;
begin
  if not Assigned(ListViewGrid.Selected) then
    exit;
  RowData := FValues[ListViewGrid.Selected.Index];

  Frm := TFrmValueList.Create(nil);
  Frm.WMIProperties := FWMIProperties;
  Frm.Caption := 'Properties ' + WmiClass;
  for i := 0 to ListViewGrid.Columns.Count - 1 do
    Frm.ValueList.InsertRow(ListViewGrid.Columns[i].Caption, RowData[i], True);

  Frm.Show();
end;

procedure TFrmWmiVwProps.ShowDetailsProps;
Var
  Frm: TFrmValueList;
  i: Integer;
begin
  if not Assigned(ListViewPropsLinks.Selected) then
    exit;

  Frm := TFrmValueList.Create(nil);
  Frm.WMIProperties := nil; // FWMIProperties;
  Frm.Caption := 'Sources ' + WmiClass + '.' + ListViewPropsLinks.Selected.Caption;
  for i := 0 to ListViewPropsLinks.Columns.Count - 1 do
    if i = 0 then
      Frm.ValueList.InsertRow('Name', ListViewPropsLinks.Selected.Caption, True)
    else if (i - 1) < ListViewPropsLinks.Selected.SubItems.Count then
      Frm.ValueList.InsertRow(ListViewPropsLinks.Columns[i].Caption, ListViewPropsLinks.Selected.SubItems[i - 1], True);

  Frm.Show();
end;

{$IFNDEF USE_ASYNCWMIQUERY}

{ TWMIQueryToListView }
procedure TWMIQueryToCustomView.AddTextRecord;
begin
  FTextOutput.Lines.BeginUpdate;
  try
    FTextOutput.Lines.Text := FTextOutput.Lines.Text + FTextRecord;
    {
      FTextOutput.Lines.Add(FTextRecord);
      FTextOutput.Lines.Add('');
    }
  finally
    FTextOutput.Lines.EndUpdate;
  end;
  FTextOutput.SelStart := FTextOutput.GetTextLen;
  FTextOutput.SelLength := 0;
  SendMessage(FTextOutput.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TWMIQueryToCustomView.AdjustColumnsWidth;
begin
  // AutoResizeListView(FListView);
  AutoResizeVirtualListView(FListView, FValues);
end;

constructor TWMIQueryToCustomView.Create(const Server, User, PassWord, NameSpace, WQL: string;
  ListWMIProperties: TStrings; ListView: TListView; CallBack: TWMIQueryCallbackLog; Values: TList<TStrings>;
  ParentHandle: THandle; TextOutput: TMemo; Mode: TWmi_ViewPropsValuesMode);
begin
  inherited Create(false);
  FreeOnTerminate := True;
  FParentHandle := ParentHandle;
  FTextOutput := TextOutput;
  FListView := ListView;
  FMode := Mode;
  FWQL := WQL;
  FServer := Server;
  FUser := User;
  FPassword := PassWord;
  FNameSpace := NameSpace;
  FProperties := ListWMIProperties;
  FCallback := CallBack;
  FValues := Values;
end;

procedure TWMIQueryToCustomView.CreateColumns;
var
  i: Integer;
  Column: TListColumn;
begin
  if FMode <> GridView then
    exit;
  FListView.Items.BeginUpdate;
  try
    for i := 0 to FProperties.Count - 1 do
    begin
      Column := FListView.Columns.Add;
      Column.Caption := FProperties[i];
      // Column.Width   := LVSCW_AUTOSIZE;
      Column.Width := 80;
      // Column.AutoSize:=True;
    end;
  finally
    FListView.Items.EndUpdate;
  end;
end;

destructor TWMIQueryToCustomView.Destroy;
begin
  FSWbemLocator := Unassigned;
  FWMIService := Unassigned;
  FWbemObjectSet := Unassigned;
  FWbemObject := Unassigned;
  inherited;
end;

procedure TWMIQueryToCustomView.Execute;
var
  Props: OleVariant;
  PropItem: OleVariant;
  oEnumProp: IEnumvariant;
  iValue: Cardinal;
  i: Integer;
  FCount: Integer;
  RowData: TStringList;
  CimType: Integer;
begin
  FSuccess := CoInitializeEx(nil, COINIT_MULTITHREADED);
  // CoInitialize(nil); //CoInitializeEx(nil, COINIT_MULTITHREADED);
  try
    FCount := 0;
    FMsg := 'Executing WMI Query';
    Synchronize(SendMsg);
    FProperties.Clear;
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer(wbemLocalhost, FNameSpace, '', '');
    FWbemObjectSet := FWMIService.ExecQuery(FWQL, 'WQL', wbemFlagForwardOnly);
    FEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
    FMsg := 'Fetching results';
    Synchronize(SendMsg);

    while (not Terminated) and (FEnum.Next(1, FWbemObject, iValue) = 0) do
    begin
      Inc(FCount);

      Props := FWbemObject.Properties_;
      oEnumProp := IUnknown(Props._NewEnum) as IEnumvariant;

      if (FProperties.Count = 0) and (FMode = GridView) then
      begin
        while oEnumProp.Next(1, PropItem, iValue) = 0 do
        begin
          CimType := PropItem.CimType;
          FProperties.AddObject(PropItem.Name, TObject(CimType));
          PropItem := Unassigned;
        end;

        FProperties.AddObject('Object Path', TObject(wbemCimtypeString));
        Synchronize(CreateColumns);
      end;

      if FMode = GridView then
      begin
        RowData := TStringList.Create;
        if Assigned(FValues) then
          FValues.Add(RowData);

        for i := 0 to FProperties.Count - 1 - 1 do
          RowData.Add(FormatWbemValue(Props.Item(FProperties[i]).Value, Integer(FProperties.Objects[i])));
        // RowData.Add(VarToStr(Props.Item(FProperties[i]).Value));

        RowData.Add(VarStrNull(FWbemObject.Path_.RelPath));
        Synchronize(SetListViewSize);
      end
      else if FMode = TextView then
      begin
        FTextRecord := FWbemObject.GetObjectText_(0);
        Synchronize(AddTextRecord);
      end;

      if FMode = GridView then
        FMsg := Format('%d records retrieved', [FValues.Count])
      else if FMode = TextView then
        FMsg := Format('%d records retrieved', [FCount]);

      Synchronize(SendMsg);

      FWbemObject := Unassigned;
      Props := Unassigned;
    end;

    if Terminated then
    begin
      FSWbemLocator := Unassigned;
      FWMIService := Unassigned;
      FWbemObjectSet := Unassigned;
    end;

    if not Terminated then
    begin
      if FCount = 0 then
      begin
        FMsg := 'Does not exist instances for this wmi class';
        Synchronize(SendMsg);
      end
      else
      begin
        FMsg := Format('%d records found', [FCount]);
        Synchronize(SendMsg);
        // Synchronize(Fill_ListView);
        if FMode = GridView then
          Synchronize(AdjustColumnsWidth);
      end;
    end;
  finally
    PropItem := Unassigned;
    Props := Unassigned;
    case FSuccess of
      S_OK, S_FALSE:
        CoUninitialize;
    end;
  end;

  SendMessage(FParentHandle, WM_WMI_THREAD_FINISHED, 0, 0);
end;

procedure TWMIQueryToCustomView.SendMsg;
begin
  if not Terminated then
    FCallback(FMsg);
end;

procedure TWMIQueryToCustomView.SetListViewSize;
begin
  FListView.Items.Count := FValues.Count;
end;
{$ENDIF}

end.
