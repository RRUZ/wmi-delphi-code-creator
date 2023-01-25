// **************************************************************************************************
//
// Unit WDCC.Sql.WMI
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
// The Original Code is WDCC.Sql.WMI.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.Sql.WMI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, Generics.Collections,
  Vcl.DBGrids, Vcl.StdCtrls, SynEditHighlighter, SynHighlighterSQL, WDCC.Misc, ActiveX,
  Vcl.ExtCtrls, SynEdit, WDCC.SynEdit.PopupEdit, WDCC.ComboBox, Vcl.DBCtrls, WDCC.HostsAdmin,
  SynCompletionProposal, Vcl.ComCtrls, uWmi_Metadata, WDCC.Settings,
  Vcl.ImgList, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.Menus, Vcl.ActnPopup, System.Actions, System.ImageList;

type

  TColumnWidthHelper = record
    Index: integer;
    MaxWidth: integer;
  end;

  TFrmWMISQL = class(TForm)
    CbHosts: TComboBox;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MemoWMI: TMemo;
    PopupActionBar3: TPopupActionBar;
    procedure FormShow(Sender: TObject);
    procedure CbHostsChange(Sender: TObject);

  type
    TWMIPropData = class
    private
      FName: string;
      FCimType: integer;
      FIsArray: Boolean;
    public
      property Name: string read FName write FName;
      property CimType: integer read FCimType write FCimType;
      property IsArray: Boolean read FIsArray write FIsArray;
    end;

  var
    SynEditWQL: TSynEdit;
    BtnExecuteWQL: TButton;
    PanelTop: TPanel;
    PanelNav: TPanel;
    SynSQLSyn1: TSynSQLSyn;
    CbNameSpaces: TComboBox;
    Label1: TLabel;
    DBGridWMI: TDBGrid;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Label2: TLabel;
    Label3: TLabel;
    EditUser: TEdit;
    EditPassword: TEdit;
    Label4: TLabel;
    SynCompletionProposal1: TSynCompletionProposal;
    Splitter1: TSplitter;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    Splitter2: TSplitter;
    CheckBoxAutoWQL: TCheckBox;
    ComboBoxClasses: TComboBox;
    LabelClasses: TLabel;
    ListViewProperties: TListView;
    LabelProperties: TLabel;
    CheckBoxSelAllProps: TCheckBox;
    ImageList1: TImageList;
    ActionManager1: TActionManager;
    ActionRunWQL: TAction;
    PopupActionBar1: TPopupActionBar;
    ExecuteWQL1: TMenuItem;
    Panel1: TPanel;
    Memo1: TMemo;
    Splitter3: TSplitter;
    CheckBoxAsync: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditMachineExit(Sender: TObject);
    procedure EditUserExit(Sender: TObject);
    procedure EditPasswordExit(Sender: TObject);
    procedure CbNameSpacesChange(Sender: TObject);
    procedure CheckBoxAutoWQLClick(Sender: TObject);
    procedure ListViewPropertiesClick(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
    procedure ComboBoxClassesChange(Sender: TObject);
    procedure SynCompletionProposal1Execute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string;
      var x, y: integer; var CanExecute: Boolean);
    procedure DBGridWMIDblClick(Sender: TObject);
    procedure DBGridWMIDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn;
      State: TGridDrawState);
    procedure ActionRunWQLExecute(Sender: TObject);
    procedure ActionRunWQLUpdate(Sender: TObject);
  private
    FColumnWidthHelper: TColumnWidthHelper;
    FSWbemLocator: OLEVariant;
    FWMIService: OLEVariant;
    FWbemObjectSet: OLEVariant;
    FWbemObject: OLEVariant;
    FFields: TObjectList<TWMIPropData>;
    FEnum: IEnumvariant;
    FiValue: LongWord;
    FRunningWQL: Boolean;
    FDataLoaded: Boolean;
    FUser: string;
    FHost: string;
    FPassword: string;
    FSettings: TSettings;
    FSetLog: TProcLog;
    FListWINHosts: TObjectList<TWMIHost>;
    procedure SetNameSpaces(const Value: TStrings);
    function GetNameSpaces: TStrings;
    procedure CreateStructure;
    procedure RunWQL;
    procedure SetHost(const Value: string);
    procedure SetPassWord(const Value: string);
    procedure SetUser(const Value: string);
    procedure LoadClassInfo;
    procedure LoadWmiClasses(const Namespace: string);
    procedure GenerateSqlCode;
    procedure LoadProposal(WmiMetaClassInfo: TWMiClassMetaData);
    procedure SetMsg(const Msg: string);
    procedure LoadNamespaces;
  public
    property SetLog: TProcLog read FSetLog Write FSetLog;
    property NameSpaces: TStrings read GetNameSpaces Write SetNameSpaces;
    property User: string read FUser write SetUser;
    property Password: string read FPassword write SetPassWord;
    property Host: string read FHost write SetHost;
    procedure SetNameSpaceIndex(Index: integer);
  end;

implementation

uses
  Math,
  AsyncCalls,
  WDCC.StdActions.PopMenu,
  WDCC.Globals,
  WDCC.ListView.Helper,
  MidasLib,
  WDCC.OleVariant.Enum,
  Vcl.Styles,
  Vcl.Themes,
  System.Win.ComObj;

{$R *.dfm}
{ TFrmWMISQL }

procedure TFrmWMISQL.ActionRunWQLExecute(Sender: TObject);
var
  AsyncCall: IAsyncCall;

  procedure LRunWQL;
  begin
    RunWQL;
  end;

begin
  FRunningWQL := True;
  try
    if not CheckBoxAsync.Checked then
      RunWQL
    else
    begin
{$IFNDEF CPUX64}
      AsyncCall := LocalAsyncCall(@LRunWQL);
      while AsyncMultiSync([AsyncCall], True, 1) = WAIT_TIMEOUT do
        Application.ProcessMessages;
{$ELSE}
      RunWQL
{$ENDIF ~CPUX64}
    end;
  finally
    FRunningWQL := False;
  end;
end;

procedure TFrmWMISQL.ActionRunWQLUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (Length(SynEditWQL.Text) > 0) and (FRunningWQL = False);
end;

procedure TFrmWMISQL.CbHostsChange(Sender: TObject);
var
  LWMIHost: TWMIHost;
begin

  if SameText(trim(CbHosts.Text), 'localhost') then
  begin
    EditUser.Text := '';
    FUser := '';
    EditPassword.Text := '';
    FPassword := '';
    FHost := 'localhost';
    LoadNamespaces;
  end
  else
    for LWMIHost in FListWINHosts do
      if SameText(CbHosts.Text, LWMIHost.Host) then
      begin
        EditUser.Text := LWMIHost.User;
        FUser := LWMIHost.User;
        EditPassword.Text := LWMIHost.Password;
        FPassword := LWMIHost.Password;
        FHost := LWMIHost.Host;
        LoadNamespaces;
        break;
      end;

end;

procedure TFrmWMISQL.CbNameSpacesChange(Sender: TObject);
begin
  LoadWmiClasses(TComboBox(Sender).Text);
  ComboBoxClasses.ItemIndex := 0;
  LoadClassInfo;
end;

procedure TFrmWMISQL.CheckBoxAutoWQLClick(Sender: TObject);
begin
  if CheckBoxAutoWQL.Checked then
    GenerateSqlCode;
end;

procedure TFrmWMISQL.CheckBoxSelAllPropsClick(Sender: TObject);
var
  LIndex: integer;
begin
  for LIndex := 0 to ListViewProperties.Items.Count - 1 do
    ListViewProperties.Items[LIndex].Checked := CheckBoxSelAllProps.Checked;

  if CheckBoxAutoWQL.Checked then
    GenerateSqlCode;
end;

procedure TFrmWMISQL.ComboBoxClassesChange(Sender: TObject);
begin
  LoadClassInfo;
end;

procedure TFrmWMISQL.CreateStructure;
var
  colItems: OLEVariant;
  colItem: OLEVariant;
begin
  if ClientDataSet1.Active then
    ClientDataSet1.Close;

  ClientDataSet1.FieldDefs.Clear;
  FFields.Clear;

  colItems := FWbemObject.Properties_;
  for colItem in GetOleVariantEnum(colItems) do
  begin
    FFields.Add(TWMIPropData.Create);
    FFields.Items[FFields.Count - 1].Name := colItem.Name;
    FFields.Items[FFields.Count - 1].CimType := colItem.CimType;
    FFields.Items[FFields.Count - 1].IsArray := colItem.IsArray;

    if FFields.Items[FFields.Count - 1].IsArray then
      ClientDataSet1.FieldDefs.Add(colItem.Name, ftString, 255)
    else
      with ClientDataSet1 do
        case FFields.Items[FFields.Count - 1].CimType of

          wbemCimtypeSint8, wbemCimtypeUint8, wbemCimtypeSint16, wbemCimtypeUint16, wbemCimtypeSint32,
            wbemCimtypeUint32:
            FieldDefs.Add(colItem.Name, ftInteger);

          wbemCimtypeSint64, wbemCimtypeUint64:
            FieldDefs.Add(colItem.Name, ftLargeint);

          wbemCimtypeReal32, wbemCimtypeReal64:
            FieldDefs.Add(colItem.Name, ftFloat);
          wbemCimtypeBoolean:
            FieldDefs.Add(colItem.Name, ftBoolean);

          wbemCimtypeString:
            FieldDefs.Add(colItem.Name, ftString, 255);
          wbemCimtypeDatetime:
            FieldDefs.Add(colItem.Name, ftDateTime);

          wbemCimtypeReference:
            FieldDefs.Add(colItem.Name, ftString, 255);
          wbemCimtypeChar16:
            FieldDefs.Add(colItem.Name, ftString, 255);
          wbemCimtypeObject:
            FieldDefs.Add(colItem.Name, ftString, 255);
        else
          FieldDefs.Add(colItem.Name, ftString, 255);
        end;

  end;

  ClientDataSet1.CreateDataSet;
end;

procedure TFrmWMISQL.DBGridWMIDblClick(Sender: TObject);
var
  LPoint: TPoint;
  LGridCoord: TGridCoord;
begin
  if not(dgTitles in DBGridWMI.Options) then
    Exit;
  LPoint := DBGridWMI.ScreenToClient(Mouse.CursorPos);

  LGridCoord := DBGridWMI.MouseCoord(LPoint.x, LPoint.y);
  if LGridCoord.y <> 0 then
    Exit;

  if dgIndicator in DBGridWMI.Options then
    FColumnWidthHelper.Index := -1 + LGridCoord.x
  else
    FColumnWidthHelper.Index := LGridCoord.x;

  if FColumnWidthHelper.Index < 0 then
    Exit;
  FColumnWidthHelper.MaxWidth := -1;

  DBGridWMI.Repaint;
  DBGridWMI.Columns[FColumnWidthHelper.Index].Width := 4 + FColumnWidthHelper.MaxWidth;
end;

procedure TFrmWMISQL.DBGridWMIDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: integer; Column: TColumn;
  State: TGridDrawState);
begin
  if (DataCol = FColumnWidthHelper.Index) and Assigned(Column.Field) then
    FColumnWidthHelper.MaxWidth := Max(FColumnWidthHelper.MaxWidth,
      DBGridWMI.Canvas.TextWidth(Column.Field.DisplayText));
end;

procedure TFrmWMISQL.EditMachineExit(Sender: TObject);
begin
  FHost := CbHosts.Text;
end;

procedure TFrmWMISQL.EditPasswordExit(Sender: TObject);
begin
  FPassword := EditPassword.Text;
end;

procedure TFrmWMISQL.EditUserExit(Sender: TObject);
begin
  FUser := EditUser.Text;
end;

procedure TFrmWMISQL.FormCreate(Sender: TObject);
var
  LWMIHost: TWMIHost;
begin
  FillPopupActionBar(PopupActionBar3);
  AssignStdActionsPopUpMenu(Self, PopupActionBar3);

  FListWINHosts := GetListWMIRegisteredHosts;
  FDataLoaded := False;
  FSettings := TSettings.Create;
  FRunningWQL := False;
  FUser := '';
  FPassword := '';
  FHost := 'localhost';
  FFields := TObjectList<TWMIPropData>.Create(True);

  CbHosts.Items.Add('localhost');
  for LWMIHost in FListWINHosts do
    CbHosts.Items.Add(LWMIHost.Host);
  CbHosts.ItemIndex := 0;

  ReadSettings(FSettings);
  LoadCurrentTheme(Self, FSettings.CurrentTheme);
  LoadCurrentThemeFont(Self, FSettings.FontName, FSettings.FontSize);
end;

procedure TFrmWMISQL.FormDestroy(Sender: TObject);
begin
  FSettings.Free;
  FFields.Free;
  if FListWINHosts <> nil then
    FreeAndNil(FListWINHosts);
end;

procedure TFrmWMISQL.FormShow(Sender: TObject);
begin
  if not FDataLoaded then
    LoadNamespaces;
end;

procedure TFrmWMISQL.GenerateSqlCode;
Var
  c, LIndex: integer;
  LFields: string;
begin
  LFields := '';
  c := 0;
  for LIndex := 0 to ListViewProperties.Items.Count - 1 do
    if ListViewProperties.Items.Item[LIndex].Checked then
    begin
      LFields := LFields + ListViewProperties.Items.Item[LIndex].Caption + ',';
      inc(c);
    end;

  if (LFields = '') or (CheckBoxSelAllProps.Checked) or (c = ListViewProperties.Items.Count) then
    LFields := '*'
  else
    Delete(LFields, Length(LFields), 1);

  SynEditWQL.Lines.Text := Format('Select %s from %s', [LFields, ComboBoxClasses.Text]);
end;

function TFrmWMISQL.GetNameSpaces: TStrings;
begin
  Result := CbNameSpaces.Items;
end;

procedure TFrmWMISQL.ListViewPropertiesClick(Sender: TObject);

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

  if CheckBoxAutoWQL.Checked then
    GenerateSqlCode;
end;

procedure TFrmWMISQL.LoadClassInfo;
var
  WmiMetaClassInfo: TWMiClassMetaData;
  LIndex: integer;
  LItem: TListItem;
begin
  if ComboBoxClasses.ItemIndex = -1 then
    Exit;

  try
    WmiMetaClassInfo := CachedWMIClasses.GetWmiClass(CbNameSpaces.Text, ComboBoxClasses.Text);

    if Assigned(WmiMetaClassInfo) then
    begin
      // SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));
      {
        MemoClassDescr.Text :=  WmiMetaClassInfo.Description;
        if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';

        LoadWmiProperties(WmiMetaClassInfo);
      }

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

        LabelProperties.Caption := Format('%d Properties of %s:%s',
          [ListViewProperties.Items.Count, WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);

      finally
        ListViewProperties.Items.EndUpdate;
      end;
      // SetMsg('');

      for LIndex := 0 to ListViewProperties.Columns.Count - 1 do
        AutoResizeColumn(ListViewProperties.Column[LIndex]);

      LoadProposal(WmiMetaClassInfo);

      ListViewProperties.Repaint;
      if CheckBoxAutoWQL.Checked then
        GenerateSqlCode;
    end;
  finally
    // SetMsg('');
  end;
end;

procedure TFrmWMISQL.LoadNamespaces;
begin
  SetLog(Format('Loading Namespaces for %s', [FHost]));
  if SameText('localhost', FHost) then
    NameSpaces := CachedWMIClasses.NameSpaces
  else
    NameSpaces := CachedWMIClasses.GetNameSpacesHost(CbHosts.Text, FUser, FPassword);

  if NameSpaces.Count > 0 then
    SetNameSpaceIndex(0);

  FDataLoaded := True;
end;

procedure TFrmWMISQL.LoadProposal(WmiMetaClassInfo: TWMiClassMetaData);
var
  i: integer;
begin
  SynCompletionProposal1.ItemList.Clear;
  SynCompletionProposal1.ItemList.Add('Select');

  // SynCompletionProposal1.ItemList.AddStrings(ComboBoxClasses.Items);
  for i := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
    SynCompletionProposal1.ItemList.Add(WmiMetaClassInfo.Properties[i].Name);
end;

procedure TFrmWMISQL.LoadWmiClasses(const Namespace: string);
var
  FClasses: TStringList;
begin
  // SetMsg(Format('Loading Classes of %s', [Namespace]));

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
            SetLog(Format('Access denied  %s %s  Code : %x', ['GetListWmiClasses', E.Message, E.ErrorCode]))
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
      {
        if ComboBoxClasses.Items.Count>0 then
        ComboBoxClasses.ItemIndex:=0;
      }
      LabelClasses.Caption := Format('Classes (%d)', [FClasses.Count]);
    finally
      ComboBoxClasses.Items.EndUpdate;
    end;
  finally
    FClasses.Free;
  end;

  // SetMsg('');
end;

procedure TFrmWMISQL.RunWQL;
const
  wbemFlagForwardOnly = $00000020;
Var
  FirstRecord: Boolean;
  F: TWMIPropData;
  FWbemPropertySet: OLEVariant;
begin
  FirstRecord := True;

  if ClientDataSet1.Active then
    ClientDataSet1.Close;
  ClientDataSet1.FieldDefs.Clear;

  ClientDataSet1.DisableControls;
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    try
      SetMsg(Format('Connecting to %s server', [FHost]));
      FWMIService := FSWbemLocator.ConnectServer(FHost, CbNameSpaces.Text, FUser, FPassword);
      SetMsg('Done');
      SetMsg('Running WQL sentence');
      FWbemObjectSet := FWMIService.ExecQuery(SynEditWQL.Lines.Text, 'WQL', wbemFlagForwardOnly);
      SetMsg('Done');

      FEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumvariant;
      while FEnum.Next(1, FWbemObject, FiValue) = 0 do
      begin
        if FirstRecord then
        begin
          MemoWMI.Lines.Clear;

          ClientDataSet1.EnableControls;
          try
            SetMsg('Creating dataset');
            CreateStructure();
            SetMsg('Done');
            SetGridColumnWidths(DBGridWMI);
          finally
            ClientDataSet1.DisableControls;
          end;
          FirstRecord := False;
          if not ClientDataSet1.Active then
            ClientDataSet1.Open;
        end;

        FWbemPropertySet := FWbemObject.Properties_;
        ClientDataSet1.Append;
        for F in FFields do
          if F.IsArray then
            ClientDataSet1.FieldByName(F.Name).AsString := '[ARRAY]'
          else if F.CimType = wbemCimtypeDatetime then
            ClientDataSet1.FieldByName(F.Name).Value := WbemDateToDateTime(FWbemPropertySet.Item(F.Name, 0).Value)
          else
            ClientDataSet1.FieldByName(F.Name).Value := FWbemPropertySet.Item(F.Name, 0).Value;

        ClientDataSet1.Post;

        MemoWMI.Lines.BeginUpdate;
        try
          MemoWMI.Lines.Text := MemoWMI.Lines.Text + FWbemObject.GetObjectText_(0);
        finally
          MemoWMI.Lines.EndUpdate;
        end;

        MemoWMI.SelStart := MemoWMI.GetTextLen;
        MemoWMI.SelLength := 0;
        SendMessage(MemoWMI.Handle, EM_SCROLLCARET, 0, 0);

        FWbemObject := Unassigned;
      end;

      if not FirstRecord then
        ClientDataSet1.EnableControls;

    except
      on E: EOleException do
      begin
        Perform(WM_PAINT, 0, 0);
        MsgWarning(Format('EOleException %s %x', [E.Message, E.ErrorCode]));
        SetLog(Format('EOleException %s %x', [E.Message, E.ErrorCode]));
      end;
      on E: Exception do
      begin
        Perform(WM_PAINT, 0, 0);
        MsgWarning(E.Classname + ':' + E.Message);
        SetLog(E.Classname + ':' + E.Message);
      end;
    end;

    if not FirstRecord then
    begin
      ClientDataSet1.DisableControls;
      try
        SetMsg('Adjusting grid widths');
        if not ClientDataSet1.Active then
          ClientDataSet1.Open;
        SetGridColumnWidths(DBGridWMI);
        SetMsg('Done');
      finally
        ClientDataSet1.EnableControls;
      end;
    end;

  finally
    ClientDataSet1.EnableControls;
  end;
end;

procedure TFrmWMISQL.SetHost(const Value: string);
begin
  FHost := Value;
  CbHosts.Text := Value;
end;

procedure TFrmWMISQL.SetMsg(const Msg: string);
begin
  Memo1.Lines.Add(Format('%s %s', [FormatDateTime('hh:nn:ss.zzz', Now), Msg]));
end;

procedure TFrmWMISQL.SetNameSpaceIndex(Index: integer);
begin
  CbNameSpaces.ItemIndex := Index;
  CbNameSpacesChange(CbNameSpaces);
end;

procedure TFrmWMISQL.SetNameSpaces(const Value: TStrings);
begin
  CbNameSpaces.Items.Clear;
  CbNameSpaces.Items.AddStrings(Value);
end;

procedure TFrmWMISQL.SetPassWord(const Value: string);
begin
  FPassword := Value;
  EditPassword.Text := Value;
end;

procedure TFrmWMISQL.SetUser(const Value: string);
begin
  FUser := Value;
  EditUser.Text := Value;
end;

procedure TFrmWMISQL.SynCompletionProposal1Execute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: string;
  var x, y: integer; var CanExecute: Boolean);
begin
  SynCompletionProposal1.ClBackground := SynSQLSyn1.WhitespaceAttribute.Background;
  SynCompletionProposal1.ClSelect := SynEditWQL.ActiveLineColor;
  SynCompletionProposal1.ClSelectedText := SynSQLSyn1.TableNameAttri.Foreground;
  SynCompletionProposal1.ClTitleBackground := SynSQLSyn1.WhitespaceAttribute.Background;
  SynCompletionProposal1.Font.Assign(SynEditWQL.Font);
  SynCompletionProposal1.Font.Color := SynSQLSyn1.SymbolAttri.Foreground;
  SynCompletionProposal1.TitleFont.Assign(SynEditWQL.Font);
end;
{
  initialization
  TStyleManager.Engine.RegisterStyleHook(TSynBaseCompletionProposalForm, TFormStyleHook);
}

end.
