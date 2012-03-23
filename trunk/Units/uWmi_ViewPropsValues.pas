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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmi_ViewPropsValues;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, SynEdit, ExtCtrls,
  Generics.Collections,
  ImgList, Contnrs, ActiveX, StdCtrls;

type
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
    FProperties: TStrings;
    FCallback: TWMIQueryCallbackLog;
    FMsg:      string;
    FValues:   TList<TStrings>;
    procedure CreateColumns;
    procedure SetListViewSize;
    procedure AdjustColumnsWidth;
    procedure SendMsg;
  public
    constructor Create(const Server, User, PassWord, NameSpace, WQL: string;
      ListView: TListView; CallBack: TWMIQueryCallbackLog;Values: TList<TStrings>); overload;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnUrlClick(Sender: TObject);
    procedure ListViewGridData(Sender: TObject; Item: TListItem);
    procedure ListViewGridDblClick(Sender: TObject);
  private
    FValues:   TList<TStrings>;
    FWmiClass: string;
    FWmiNamespace: string;
    FWQL:    TStrings;
    FWmiproperties: TStrings;
    FDataLoaded: boolean;
    FContainValues: boolean;
    FThread: TWMIQueryToListView;
    procedure Log(const msg: string);
    procedure SetWmiClass(const Value: string);
    procedure SetWmiNamespace(const Value: string);
    procedure ShowDetails();
  public
    property ContainValues: boolean Read FContainValues;
    property Wmiproperties: TStrings Read FWmiproperties Write FWmiproperties;
    property WmiClass: string Read FWmiClass Write SetWmiClass;
    property WmiNamespace: string Read FWmiNamespace Write SetWmiNamespace;
    property WQL: TStrings Read FWQL;
    procedure LoadValues; cdecl;
  end;

  procedure ListValuesWmiProperties(const Namespace, WmiClass: string; Properties : TStringList);

implementation

uses
  ComObj,
  CommCtrl,
  uWmi_Metadata,
  ShellAPi,
  uListView_Helper, uPropValueList;

{$R *.dfm}


procedure ListValuesWmiProperties(const Namespace, WmiClass: string; Properties : TStringList);
var
  Frm: TFrmWmiVwProps;
  WmiMetaData : TWMiClassMetaData;
  i           : Integer;
begin
  if (WmiClass <> '') and (Namespace <> '') then
  begin
    Frm := TFrmWmiVwProps.Create(nil);
    Frm.WmiClass     := WmiClass;
    Frm.WmiNamespace := Namespace;
    Frm.Caption      := 'Properties Values for the class ' + WmiClass;

    Frm.Wmiproperties.Clear;
    if (Properties=nil) or (Properties.Count=0) then
    begin
     WmiMetaData:=TWMiClassMetaData.Create(NameSpace,WmiClass);
     try
      for i:=0 to WmiMetaData.PropertiesCount-1 do
        Frm.Wmiproperties.Add(WmiMetaData.Properties[i].Name)
     finally
      WmiMetaData.Free;
     end;
    end
    else
      for i:=0 to Properties.Count-1 do
        Frm.Wmiproperties.Add(Properties[i]);

    Frm.LoadValues;
    Frm.Show();
  end;
end;

procedure TFrmWmiVwProps.BtnUrlClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(EditURL.Text), nil, nil, SW_SHOW);
end;

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
  FDataLoaded := False;
  FWmiproperties := TStringList.Create;
  FWQL    := TStringList.Create;
  FContainValues := False;
  FThread := nil;
  ListViewGrid.DoubleBuffered := True;
  FValues:=TList<TStrings>.Create;
  //NullStrictConvert:=False;
end;

procedure TFrmWmiVwProps.FormDestroy(Sender: TObject);
Var
 i : integer;
begin
  FWmiproperties.Free;
  FWQL.Free;
   if Assigned(FThread) and not FThread.Terminated then
    FThread.Terminate;
    //FThread.Free;

 for i:=0 to FValues.Count-1 do
   FValues[i].Free;

  FValues.Free;
end;

procedure TFrmWmiVwProps.ListViewGridData(Sender: TObject; Item: TListItem);
Var
  RowData : TStrings;
  j : integer;
begin
  if Item.Index<=FValues.Count then
  begin
    RowData:=FValues[Item.Index];
    for j := 0 to RowData.Count - 1 do
    begin
      if j = 0 then
        Item.Caption := RowData[j]
      else
        Item.SubItems.Add(RowData[j]);
    end;
  end;
end;

procedure TFrmWmiVwProps.ListViewGridDblClick(Sender: TObject);
begin
  ShowDetails();
end;

procedure TFrmWmiVwProps.LoadValues;
var
  i: integer;
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
  FThread := TWMIQueryToListView.Create('.', '', '', FWmiNamespace, FWQL.Text, ListViewGrid, Log, FValues);
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


procedure TFrmWmiVwProps.ShowDetails;
Var
 Frm  : TFrmValueList;
 i    : Integer;
  RowData : TStrings;
begin
 if not Assigned(ListViewGrid.Selected) then exit;
 RowData:=FValues[ListViewGrid.Selected.Index];

 Frm:=TFrmValueList.Create(nil);
 Frm.Caption:='Properties '+WmiClass;
  for i := 0 to ListViewGrid.Columns.Count-1 do
    Frm.ValueList.InsertRow(ListViewGrid.Columns[i].Caption, RowData[i], True);

 Frm.Show();
end;


procedure AutoResizeVirtualListView(const ListView: TListView;Values:TList<TStrings>);
Var
 i, j        : Integer;
 TopIndex    : Integer;
 BottomIndex : Integer;
 psz         : string;
 cw,lw       : Integer;
 //pszText     : Array[0..4096-1] of Char;
 //pItem       : TLVItem;

begin
 if ListView.Items.Count>0 then
 begin
  TopIndex   :=ListView.Perform(LVM_GETTOPINDEX,0,0);
  BottomIndex:=TopIndex+ListView.Perform(LVM_GETCOUNTPERPAGE,0,0);
  if BottomIndex>ListView.Items.Count-1 then
   BottomIndex:=ListView.Items.Count;

  for j:=0 to ListView.Columns.Count-1 do
  begin
    cw:=ListView.Columns.Items[j].Width;

    for i :=TopIndex to BottomIndex do
    begin
      {
     if j=0 then
      psz:=ListView.Items.Item[i].Caption
     else
     begin
      ZeroMemory(@pItem, SizeOf(pItem));
      pItem.pszText    := pszText;
      pItem.cchTextMax := Length(pszText);
      pItem.mask       := LVIF_TEXT;
      pItem.iItem      := i;
      pItem.iSubItem   := j;
      ListView_GetItem(ListView.Handle, pItem);
      psz:=pszText;
      OutputDebugString(pchar(psz));
     end;
       }
     psz:=Values[i].Strings[j];

     lw :=ListView_GetStringWidth(ListView.Handle, PChar(psz));
     if lw>cw then
      cw:=lw;
    end;

    if ListView.Columns.Items[j].Width<>cw then
     ListView.Columns.Items[j].Width:=cw+20;
  end;
 end;
end;

{ TWMIQueryToListView }


procedure TWMIQueryToListView.AdjustColumnsWidth;
begin
  //AutoResizeListView(FListView);
  AutoResizeVirtualListView(FListView, FValues);
end;

constructor TWMIQueryToListView.Create(const Server, User, PassWord, NameSpace, WQL: string;
      ListView: TListView; CallBack: TWMIQueryCallbackLog;Values: TList<TStrings>);
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
  FValues   := Values;
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
      //Column.Width   := LVSCW_AUTOSIZE;
      Column.Width:=80;
      //Column.AutoSize:=True;
    end;
  finally
    FListView.Items.EndUpdate;
  end;
end;


destructor TWMIQueryToListView.Destroy;
begin
  FSWbemLocator  := Unassigned;
  FWMIService    := Unassigned;
  FWbemObjectSet := Unassigned;
  FWbemObject    := Unassigned;
  FProperties.Free;
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
  RowData : TStringList;
  CimType : integer;
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
    //NullStrictConvert:=False;

    while (not Terminated) and (FEnum.Next(1, FWbemObject, iValue) = 0) do
    begin
      Inc(FCount);

      Props     := FWbemObject.Properties_;
      oEnumProp := IUnknown(Props._NewEnum) as IEnumVariant;

      if FProperties.Count = 0 then
      begin
        while oEnumProp.Next(1, PropItem, iValue) = 0 do
        begin
          CimType:=PropItem.CIMType;
          FProperties.AddObject(PropItem.Name, TObject(CimType));
          PropItem := Unassigned;
        end;

        FProperties.Add('Object Path');
        Synchronize(CreateColumns);
      end;

      {
      FValues.Clear;
      for i := 0 to FProperties.Count - 1 -1 do
      //  FValues.Add(Props.Item(FProperties[i]).Value);
      FValues.Add(VarStrNull(Props.Item(FProperties[i]).Value));
      FValues.Add(VarStrNull(FWbemObject.Path_.RelPath));
      }


      RowData:=TStringList.Create;
      if Assigned(FValues) then
        FValues.Add(RowData);

      for i := 0 to FProperties.Count - 1 -1 do
        RowData.Add(FormatWbemValue(Props.Item(FProperties[i]).Value, Integer(FProperties.Objects[i])));
        //RowData.Add(VarToStr(Props.Item(FProperties[i]).Value));

      RowData.Add(VarStrNull(FWbemObject.Path_.RelPath));

      Synchronize(SetListViewSize);

      FMsg :=Format('%d records retrieved', [FValues.Count]);
      Synchronize(SendMsg);

      FWbemObject := Unassigned;
      Props := Unassigned;
    end;
    //NullStrictConvert:=True;

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



procedure TWMIQueryToListView.SendMsg;
begin
  if not Terminated then
  FCallback(FMsg);
end;

procedure TWMIQueryToListView.SetListViewSize;
begin
  FListView.Items.Count:=FValues.Count;
end;

end.
