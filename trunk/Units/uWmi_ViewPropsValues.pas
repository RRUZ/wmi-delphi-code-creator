{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmi_ViewPropsValues                                                                        }
{ Unit for the WMI Delphi Code Creator                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uWmi_ViewPropsValues.pas.                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmi_ViewPropsValues;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, SynEdit, ExtCtrls,
  ImgList, Contnrs, ActiveX, StdCtrls;

type
  TGroupItem = class
  private
    fItems:    TObjectList;
    fCaption:  string;
    fListItem: TListItem;
    fExpanded: boolean;
    function GetItems: TObjectList;
  public
    constructor Create(const Caption: string; const Props, List: TStrings);
    destructor Destroy; override;

    procedure Expand;
    procedure Collapse;

    property Expanded: boolean Read fExpanded;
    property Caption: string Read fCaption;
    property Items: TObjectList Read GetItems;
    property ListItem: TListItem Read fListItem Write fListItem;
  end;

  TItem = class
  private
    FTitle: string;
    FValue: string;
  public
    constructor Create(const title, Value: string);
    property Title: string Read FTitle;
    property Value: string Read FValue;
  end;

  TWMIQueryCallbackLog = procedure(const msg: string) of object;

  TWMIQueryToListView = class(TThread)
  private
    Success:   HResult;
    FEnum:     IEnumvariant;
    FSWbemLocator: olevariant;
    FWMIService: olevariant;
    FWbemObjectSet: olevariant;
    FWbemObject: olevariant;
    FWQL:      string;
    FServer:   string;
    FUser:     string;
    FPassword: string;
    FNameSpace: string;
    FListView: TListView;
    //FList         : TList;
    FProperties: TStrings;
    FValues:   TStrings;
    FCallback: TWMIQueryCallbackLog;
    FMsg:      string;

    procedure CreateColumns;
    procedure AddRecord;
    procedure AdjustColumnsWidth;
    procedure SendMsg;

    //procedure Fill_ListView;
  public
    constructor Create(const Server, User, PassWord, NameSpace, WQL: string;
      ListView: TListView; CallBack: TWMIQueryCallbackLog); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

  TFrmWmiVwProps = class(TForm)
    ListViewWmi: TListView;
    PageControl1: TPageControl;
    TabSheetProps: TTabSheet;
    Panel1:     TPanel;
    listViewImages: TImageList;
    TabSheet1:  TTabSheet;
    ListViewGrid: TListView;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    EditClass: TEdit;
    Label1: TLabel;
    EditNameSpace: TEdit;
    Label2: TLabel;
    EditURL: TEdit;
    BtnUrl: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewWmiAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: boolean);
    procedure ListViewWmiClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnUrlClick(Sender: TObject);
  private
    FWmiClass: string;
    FWmiNamespace: string;
    FWQL:    TStrings;
    FWmiproperties: TStrings;
    FDataLoaded: boolean;
    FContainValues: boolean;
    FThread: TWMIQueryToListView;
    procedure ClearListViewGroups;
    procedure FillListViewGroups;
    //procedure AddGroupItem(gi : TGroupItem);

    procedure Log(const msg: string);
    procedure SetWmiClass(const Value: string);
    procedure SetWmiNamespace(const Value: string);
  public
    property ContainValues: boolean Read FContainValues;
    property Wmiproperties: TStrings Read FWmiproperties Write FWmiproperties;
    property WmiClass: string Read FWmiClass Write SetWmiClass;
    property WmiNamespace: string Read FWmiNamespace Write SetWmiNamespace;
    property WQL: TStrings Read FWQL;
    procedure LoadValues; cdecl;
  end;




implementation

uses
  CommCtrl,
  uListView_Helper,
  ComObj,
  ShellAPi,
  uWmi_Metadata;

{$R *.dfm}

{
Procedure AddListViewGroup(const ListView: TListView;const GroupName:String;const Index:Integer);
var
  LvGroup: TLVGROUP;
begin
  FillChar(LvGroup, SizeOf(TLVGROUP), 0);
  LvGroup.cbSize    := SizeOf(TLVGROUP);
  LvGroup.mask      := LVGF_HEADER or LVGF_ALIGN or LVGF_GROUPID or LVGF_STATE;
  LvGroup.pszHeader := StringToOleStr(GroupName);
  LvGroup.cchHeader := Length(LvGroup.pszHeader);
  LvGroup.iGroupId  := Index;
  LvGroup.uAlign    := LVGA_HEADER_LEFT;
  LvGroup.state     := LVGS_COLLAPSIBLE;
  SendMessage(ListView.Handle, LVM_INSERTGROUP, 0, Longint(@LvGroup));
end;

procedure AddItemGroup(const ListView: TListView;const Item: TListItem;const Group: integer);
type
  tagLVITEMA = record
    mask: UINT;
    iItem: Integer;
    iSubItem: Integer;
    state: UINT;
    stateMask: UINT;
    pszText: PAnsiChar;
    cchTextMax: Integer;
    iImage: Integer;
    lParam: LPARAM;
    iIndent: Integer;
    iGroupId: Integer;
    cColumns: Integer;
    puColumns: PUINT;
    piColFmt: PInteger;
    iGroup: Integer;
  end;
  TLVItemA   = tagLVITEMA;

var
  LvItemA: TLVItemA;
begin
  FillChar(LvItemA, SizeOf(TLVITEMA), 0);
  LvItemA.mask := LVIF_GROUPID;
  LvItemA.iItem := Item.Index;
  LvItemA.iGroupId := Group;
  SendMessage(ListView.Handle, LVM_SETITEM, 0, Longint(@LvItemA))
end;
 }

procedure TFrmWmiVwProps.BtnUrlClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(EditURL.Text), nil, nil, SW_SHOW);
end;

procedure TFrmWmiVwProps.ClearListViewGroups;
var
  li:  TListItem;
  qng: TGroupItem;
begin
  for li in ListViewWmi.Items do
  begin
    if TObject(li.Data) is TGroupItem then
    begin
      qng := TGroupItem(li.Data);
      FreeAndNil(qng);
    end;
  end;
  ListViewWmi.Clear;
end;


procedure TFrmWmiVwProps.FillListViewGroups;
begin
  ClearListViewGroups;
end;

{
procedure TFrmWmiVwProps.AddGroupItem(gi : TGroupItem);
var
  li : TListItem;
begin
  li            := ListViewWmi.Items.Add;
  li.Caption    := gi.Caption;
  li.ImageIndex := 1; //collapsed
  li.Data       := gi;
  gi.ListItem   := li; //link "back"
end;
}
procedure TFrmWmiVwProps.FormActivate(Sender: TObject);
begin
  if not FDataLoaded then
    LoadValues;
end;

procedure TFrmWmiVwProps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmWmiVwProps.FormCreate(Sender: TObject);
begin
  FillListViewGroups;
  FDataLoaded := False;
  FWmiproperties := TStringList.Create;
  FWQL    := TStringList.Create;
  FContainValues := False;
  FThread := nil;
  ListViewGrid.DoubleBuffered := True;
  //SendMessage(ListViewWmi.Handle, LVM_ENABLEGROUPVIEW, 1, 0);
  //NullStrictConvert:=False;
end;

procedure TFrmWmiVwProps.FormDestroy(Sender: TObject);
begin
  ClearListViewGroups;
  FWmiproperties.Free;
  FWQL.Free;
  if FThread <> nil then
  begin
   if not FThread.Terminated then
    FThread.Terminate;
    //FThread.Free;
  end;
end;

procedure TFrmWmiVwProps.ListViewWmiAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: boolean);
begin
  try
    if Assigned(item.Data) then
      if (TObject(item.Data) is TGroupItem) then   //ugly hack produce exception
        TListView(Sender).Canvas.Font.Style :=
          TListView(Sender).Canvas.Font.Style + [fsBold];
  except

  end;
end;


procedure TFrmWmiVwProps.ListViewWmiClick(Sender: TObject);
var
  hts: THitTests;
  gi:  TGroupItem;
begin
  inherited;

  hts := TListView(Sender).GetHitTestInfoAt(TListView(Sender).ScreenToClient(
    Mouse.CursorPos).X, TListView(Sender).ScreenToClient(Mouse.CursorPos).y);

  if (TListView(Sender).Selected <> nil) then
  begin
    TListView(Sender).Items.BeginUpdate;
    try
      if TObject(TListView(Sender).Selected.Data) is (TGroupItem) then
      begin
        gi := TGroupItem(TListView(Sender).Selected.Data);

        if not gi.Expanded then
          gi.Expand
        else
          gi.Collapse;
      end;
    finally
      TListView(Sender).Items.EndUpdate;
    end;
  end;
end;

procedure TFrmWmiVwProps.LoadValues;
var
  i: integer;
  //Props : TStrings;
  //List  : TList;
  //Gi    : TGroupItem;
  //Column: TListColumn;
  //Item  : TListItem;
begin
  FDataLoaded := True;
  FWQL.Add('Select');
  if FWmiproperties.Count = 0 then
    FWQL.Add(' * ')
  else
    for i := 0 to FWmiproperties.Count - 1 do
      if i < FWmiproperties.Count - 1 then
        FWQL.Add(FWmiproperties[i] + ',')
      else
        FWQL.Add(FWmiproperties[i]);

  FWQL.Add(' From ' + FWmiClass);

  FThread := TWMIQueryToListView.Create('.', '', '', FWmiNamespace,
    FWQL.Text, ListViewGrid, Log);

  //SynEditWQL.Lines.Text:=FWQL.Text;
         {
      List:=TList.Create;
      Props:=TStringList.Create;
      ListViewWmi.Items.BeginUpdate;
      ListViewGrid.Items.BeginUpdate;
      try
          GetListWmiClassPropertiesValues(FWmiNamespace,FWQL.Text,Props,List);

          if List.Count>0 then
          begin

             for i := 0 to Props.Count - 1 do
             begin
               Column:=ListViewGrid.Columns.Add;
               Column.Caption:=Props[i];
             end;

             for i := 0 to List.Count - 1 do
              for j := 0 to Props.Count - 1 do
               begin
                 if j=0 then
                 begin
                  Item:=ListViewGrid.Items.Add;
                  Item.Caption:=TStringList(List[i]).Strings[j];
                 end
                 else
                  Item.SubItems.Add(TStringList(List[i]).Strings[j]);
               end;
          end;


         for i := 0 to List.Count - 1 do
         begin
            Gi:=TGroupItem.Create(Format('Record %d',[i+1]),props,TStringList(List[i]));
            AddGroupItem(Gi);
            if (i=0) and not Gi.Expanded  then
            Gi.Expand;
         end;
         

      finally
         AutoResizeListView(ListViewGrid);
         AutoResizeListView(ListViewWmi);
         ListViewWmi.Items.EndUpdate;
         ListViewGrid.Items.EndUpdate;

         FContainValues:=List.Count>0;
          for i := 0 to List.Count - 1 do
            TStringList(List[i]).Free;

         List.Free;
         Props.Free;
      end;
      }
end;

procedure TFrmWmiVwProps.Log(const msg: string);
begin
  StatusBar1.SimpleText := msg;
end;

procedure TFrmWmiVwProps.SetWmiClass(const Value: string);
begin
  FWmiClass := Value;
  EditClass.Text:=Value;
  EditURL.Text:=Format(UrlWmiHelp, [Value]);
end;

procedure TFrmWmiVwProps.SetWmiNamespace(const Value: string);
begin
  FWmiNamespace := Value;
  EditNameSpace.Text:=Value;
end;

{ TGroupItem }

procedure TGroupItem.Collapse;
var
  li: TListItem;
begin
  if not Expanded then
    Exit;

  ListItem.ImageIndex := 1;
  fExpanded := False;

  li := TListView(ListItem.ListView).Items[ListItem.Index + 1];
  while (li <> nil) and (TObject(li.Data) is TItem) do
  begin
    TListView(ListItem.ListView).Items.Delete(li.Index);
    li := TListView(ListItem.ListView).Items[ListItem.Index + 1];
  end;
end;

constructor TGroupItem.Create(const Caption: string; const Props, List: TStrings);
var
  i: integer;
begin
  fCaption := Caption;
  for i := 0 to List.Count - 1 do
    Items.Add(TItem.Create(Props[i], List[i]));
  //Items.Add(TItem.Create(List.Names[i],List.ValueFromIndex[i]));
end;

destructor TGroupItem.Destroy;
begin
  FreeAndNil(fItems);
  inherited;
end;


procedure TGroupItem.Expand;
var
  cnt:  integer;
  item: TItem;
begin
  if Expanded then
    Exit;

  ListItem.ImageIndex := 0;
  fExpanded := True;

  for cnt := 0 to -1 + Items.Count do
  begin
    item := TItem(Items[cnt]);
    with TListView(ListItem.ListView).Items.Insert(1 + cnt + ListItem.Index) do
    begin
      Caption := item.Title;
      SubItems.Add(item.Value);
      Data := item;
      ImageIndex := -1;
    end;
  end;

end;

function TGroupItem.GetItems: TObjectList;
begin
  if fItems = nil then
    fItems := TObjectList.Create(True);
  Result := fItems;
end;


{ TItem }

constructor TItem.Create(const title, Value: string);
begin
  fTitle := title;
  fValue := Value;
end;

{ TWMIQueryToListView }


procedure TWMIQueryToListView.AdjustColumnsWidth;
begin
  AutoResizeListView(FListView);
end;

constructor TWMIQueryToListView.Create(
  const Server, User, PassWord, NameSpace, WQL: string;
  ListView: TListView; CallBack: TWMIQueryCallbackLog);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FListView := ListView;
  FWQL      := WQL;
  FServer   := Server;
  FUser     := User;
  FPassword := PassWord;
  FNameSpace := NameSpace;
  //FList           := TList.Create;
  FProperties := TStringList.Create;
  FCallback := CallBack;
  FValues   := TStringList.Create;
end;


procedure TWMIQueryToListView.CreateColumns;
var
  i:      integer;
  Column: TListColumn;
begin
  FListView.Items.BeginUpdate;
  try
    for i := 0 to FProperties.Count - 1 do
    begin
      Column := FListView.Columns.Add;
      Column.Caption := FProperties[i];
    end;
  finally
    FListView.Items.EndUpdate;
  end;
end;


destructor TWMIQueryToListView.Destroy;
{
var
  i : integer;
}
begin
  FSWbemLocator  := Unassigned;
  FWMIService    := Unassigned;
  FWbemObjectSet := Unassigned;
  FWbemObject    := Unassigned;
  {
  for i := 0 to FList.Count - 1 do
    TStringList(FList[i]).Free;
  FList.Free;
  }
  FProperties.Free;
  FValues.Free;
  inherited;
end;

procedure TWMIQueryToListView.Execute;
var
  Props:  olevariant;
  PropItem: olevariant;
  oEnumProp: IEnumvariant;
  iValue: cardinal;
  i:      integer;
  FCount: integer;
begin
  Success := CoInitialize(nil); //CoInitializeEx(nil, COINIT_MULTITHREADED);
  try
    FCount := 0;
    FMsg   := 'Executing WMI Query';
    Synchronize(SendMsg);

    FProperties.Clear;
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService := FSWbemLocator.ConnectServer(wbemLocalhost, FNameSpace, '', '');
    FWbemObjectSet := FWMIService.ExecQuery(FWQL, 'WQL', wbemFlagForwardOnly);
    FEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

    FMsg := 'Fetching results';
    Synchronize(SendMsg);

    while (not Terminated) and (FEnum.Next(1, FWbemObject, iValue) = 0) do
    begin
      Inc(FCount);
      //FList.Add(TStringList.Create);
      Props     := FWbemObject.Properties_;
      oEnumProp := IUnknown(Props._NewEnum) as IEnumVariant;


      if FProperties.Count = 0 then
      begin
        while oEnumProp.Next(1, PropItem, iValue) = 0 do
        begin
          FProperties.Add(PropItem.Name);
          PropItem := Unassigned;
        end;
        Synchronize(CreateColumns);
      end;

        {
        for i := 0 to FProperties.Count - 1 do
           TStringList(FList[FList.Count-1]).Add(VarStrNull(Props.Item(FProperties[i]).Value));
        }

      FValues.Clear;
      for i := 0 to FProperties.Count - 1 do
        //FValues.Add(Props.Item(FProperties[i]).Value);
        FValues.Add(VarStrNull(Props.Item(FProperties[i]).Value));

      Synchronize(AddRecord);

        {
        while oEnumProp.Next(1, PropItem, iValue) = 0 do
        begin
          if FProperties.IndexOf(PropItem.Name)<0 then
          FProperties.Add(PropItem.Name);

          TStringList(FList[FList.Count-1]).Add(VarStrNull(PropItem.Value));
          PropItem:=Unassigned;
        end;
        }


      FWbemObject := Unassigned;
      Props := Unassigned;
    end;


    if not Terminated then
    begin
      if FCount = 0 then
      begin
        FMsg := 'Does not exist values for this class';
        Synchronize(SendMsg);
      end
      else
      begin
        FMsg := Format('%d records found', [FCount]);
        Synchronize(SendMsg);
        //Synchronize(Fill_ListView);
        Synchronize(AdjustColumnsWidth);
      end;
    end;
  finally
    PropItem := Unassigned;
    Props    := Unassigned;
    case Success of
      S_OK, S_FALSE: CoUninitialize;
    end;
  end;
end;

procedure TWMIQueryToListView.AddRecord;
var
  j:    integer;
  Item: TListItem;
begin
  if not Terminated then
  begin
    FListView.Items.BeginUpdate;
    try
      for j := 0 to FProperties.Count - 1 do
      begin
        if j = 0 then
        begin
          Item := FListView.Items.Add;
          Item.Caption := FValues[j];
        end
        else
          Item.SubItems.Add(FValues[j]);
      end;

      FCallback(Format('%d records retrieved', [FListView.Items.Count]));
    finally
      FListView.Items.EndUpdate;
    end;
  end;
end;


         {
procedure TWMIQueryToListView.Fill_ListView;
var
  i , j : Integer;
  Column: TListColumn;
  Item  : TListItem;
begin
  if FList.Count>0 then
  begin
    FListView.Items.BeginUpdate;
    try

     for i := 0 to FProperties.Count - 1 do
     begin
       Column:=FListView.Columns.Add;
       Column.Caption:=FProperties[i];
     end;

     for i := 0 to FList.Count - 1 do
      for j := 0 to FProperties.Count - 1 do
       begin
         if j=0 then
         begin
          Item:=FListView.Items.Add;
          Item.Caption:=TStringList(FList[i]).Strings[j];
         end
         else
          Item.SubItems.Add(TStringList(FList[i]).Strings[j]);
       end;
    finally
      AutoResizeListView(FListView);
      FListView.Items.EndUpdate;
    end;
  end;
end;
        }
procedure TWMIQueryToListView.SendMsg;
begin
  FCallback(FMsg);
end;

end.
