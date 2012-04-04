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
  Generics.Collections, uWmi_Metadata,
  ImgList, Contnrs, ActiveX, StdCtrls, Vcl.Menus,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup;

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
      ListWMIProperties : TStrings;
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
    TabSheet2: TTabSheet;
    ListViewPropsLinks: TListView;
    PopupActionBar1: TPopupActionBar;
    Viewdetails1: TMenuItem;
    PopupActionBar2: TPopupActionBar;
    ViewDetails2: TMenuItem;
    Checkforonlinedocumentation1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnUrlClick(Sender: TObject);
    procedure ListViewGridData(Sender: TObject; Item: TListItem);
    procedure ListViewGridDblClick(Sender: TObject);
    procedure ListViewPropsLinksDblClick(Sender: TObject);
  private
    FValues:   TList<TStrings>;
    FWmiClass: string;
    FWmiNamespace: string;
    FWQL:    TStrings;
    FWQLProperties: TStrings;
    FDataLoaded: boolean;
    FContainValues: boolean;
    FThread: TWMIQueryToListView;
    FWMIProperties: TStrings;
    WmiMetaData : TWMiClassMetaData;
    procedure Log(const msg: string);
    procedure SetWmiClass(const Value: string);
    procedure SetWmiNamespace(const Value: string);
    procedure ShowDetailsData();

    procedure LoadPropsLinks;//MappedStrings
    procedure ShowDetailsProps;
  public
    property ContainValues: boolean Read FContainValues;
    property WQLProperties: TStrings Read FWQLProperties Write FWQLProperties;
    property WmiClass: string Read FWmiClass Write SetWmiClass;
    property WmiNamespace: string Read FWmiNamespace Write SetWmiNamespace;
    property WQL: TStrings Read FWQL;
    procedure LoadValues(Properties : TStringList); cdecl;
  end;

  procedure ListValuesWmiProperties(const Namespace, WmiClass: string; Properties : TStringList);

implementation

uses
  ComObj,
  CommCtrl,
  StrUtils,
  ShellAPi,
  MSXML,
  uListView_Helper,
  uPropValueList;

{$R *.dfm}


procedure ListValuesWmiProperties(const Namespace, WmiClass: string; Properties : TStringList);
var
  Frm: TFrmWmiVwProps;
  {
  WmiMetaData : TWMiClassMetaData;
  i           : Integer;
  }
begin
  if (WmiClass <> '') and (Namespace <> '') then
  begin
    Frm := TFrmWmiVwProps.Create(nil);
    Frm.WmiClass     := WmiClass;
    Frm.WmiNamespace := Namespace;
    Frm.Caption      := 'Properties Values for the class ' + WmiClass;
       {
    Frm.WQLProperties.Clear;
    if (Properties=nil) or (Properties.Count=0) then
    begin
     WmiMetaData:=TWMiClassMetaData.Create(NameSpace,WmiClass);
     try
      for i:=0 to WmiMetaData.PropertiesCount-1 do
        Frm.WQLProperties.Add(WmiMetaData.Properties[i].Name)
     finally
      WmiMetaData.Free;
     end;
    end
    else
      for i:=0 to Properties.Count-1 do
        Frm.WQLProperties.Add(Properties[i]);
    }
    Frm.LoadValues(Properties);
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
    LoadValues(nil);
end;

procedure TFrmWmiVwProps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmWmiVwProps.FormCreate(Sender: TObject);
begin
  WmiMetaData:=nil;
  FDataLoaded := False;
  FWQLProperties := TStringList.Create;
  FWQL    := TStringList.Create;
  FContainValues := False;
  FThread := nil;
  ListViewGrid.DoubleBuffered := True;
  FValues:=TList<TStrings>.Create;
  FWMIProperties:=TStringList.Create;
  //NullStrictConvert:=False;
end;

procedure TFrmWmiVwProps.FormDestroy(Sender: TObject);
Var
 i : integer;
begin
  FWMIProperties.Free;
  FWQLProperties.Free;
  FWQL.Free;
  if WmiMetaData<>nil then
    WmiMetaData.Free;

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
  ShowDetailsData();
end;

function GetURL(const SearchKey : string;NumberOfResults:integer=1) : string;
const
 ApplicationID= '73C8F474CA4D1202AD60747126813B731199ECEA';
 URI='http://api.bing.net/xml.aspx?AppId=%s&Verstion=2.2&Market=en-US&Query=%s&Sources=web&web.count=%d&xmltype=elementbased';
 COMPLETED=4;
 OK       =200;
var
  XMLHTTPRequest  : IXMLHTTPRequest;
  XMLDOMDocument2 : IXMLDOMDocument2;
  XMLDOMNode      : IXMLDOMNode;
  XMLDOMNodeList  : IXMLDOMNodeList;
begin
    Result:='';
    XMLHTTPRequest := CreateOleObject('MSXML2.XMLHTTP') As XMLHTTP;
  try
    XMLHTTPRequest.open('GET', Format(URI,[ApplicationID, SearchKey, NumberOfResults]), False, EmptyParam, EmptyParam);
    XMLHTTPRequest.send('');
    if (XMLHTTPRequest.readyState = COMPLETED) and (XMLHTTPRequest.status = OK) then
    begin
      XMLDOMDocument2 := XMLHTTPRequest.responseXML  As IXMLDOMDocument2;
      XMLDOMDocument2.setProperty('SelectionNamespaces', 'xmlns:web="http://schemas.microsoft.com/LiveSearch/2008/04/XML/web"');
      XMLDOMNodeList := XMLDOMDocument2.selectNodes('//web:WebResult');
      if XMLDOMNodeList.length>0 then
      begin
        XMLDOMNode:=XMLDOMNodeList.item[0];
        Result:= XMLDOMNode.selectSingleNode('./web:Url').Text
      end;
    end;
  finally
    XMLHTTPRequest := nil;
  end;
end;


procedure TFrmWmiVwProps.ListViewPropsLinksDblClick(Sender: TObject);
begin
  ShowDetailsProps;
end;
{
Var
  Key, URL :string;
begin
 if (ListViewPropsLinks.Selected<>nil) and (ListViewPropsLinks.Selected.SubItems.Count>2) then
 begin
   //agregar lista de leccion de urls ? + twebrowser?

   URL:= GetURL(Format('msdn "%s"  %s',[ListViewPropsLinks.Selected.SubItems[1], ListViewPropsLinks.Selected.SubItems[2]]));
   if URL<>'' then
    ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOW);
 end;

end;
}

procedure TFrmWmiVwProps.LoadPropsLinks;
var
  i, j : integer;
  WMiQualifierMetaData : TWMiQualifierMetaData;
  Item : TListItem;
  s, MappingStrings : string;
begin
  ListViewPropsLinks.Items.BeginUpdate;
  try
    ListViewPropsLinks.Items.Clear;
    for i:=0 to WmiMetaData.PropertiesCount-1 do
    for WMiQualifierMetaData in WmiMetaData.Properties[i].Qualifiers do
      if SameText('MappingStrings',WMiQualifierMetaData.Name) then
      begin
        Item:=ListViewPropsLinks.Items.Add;
        Item.Caption:=WmiMetaData.Properties[i].Name;
        //[MIF.DMTF|Operational State|003.5|MIB.IETF|HOST-RESOURCES-MIB.hrDeviceStatus]
        MappingStrings:=WMiQualifierMetaData.Value;
        if (MappingStrings<>'') and (MappingStrings[1]='[') then
         MappingStrings:=Copy(MappingStrings, 2, Length(MappingStrings));

        if (MappingStrings<>'') and (MappingStrings[Length(MappingStrings)]=']') then
         MappingStrings:=Copy(MappingStrings, 1, Length(MappingStrings)-1);

        for s in SplitString(MappingStrings,'|') do
         Item.SubItems.Add(s);

        Item.ImageIndex:=-1;
        if Item.SubItems.Count>0 then
         if MatchText(Item.SubItems[0], ['WMI','MIF.DMTF']) then
           Item.ImageIndex:=2
         else
         if MatchText(Item.SubItems[0], ['Win32Registry']) then
           Item.ImageIndex:=1
         else
         if MatchText(Item.SubItems[0],['Win32API','Win32']) then
           Item.ImageIndex:=0
         else
         if MatchText(Item.SubItems[0],['SMBIOS']) then
           Item.ImageIndex:=3
         else
         if MatchText(Item.SubItems[0],['MIB.IETF']) then
           Item.ImageIndex:=4;
      end;
  finally
    ListViewPropsLinks.Items.EndUpdate;
  end;
  AutoResizeListView(ListViewPropsLinks);
end;

procedure TFrmWmiVwProps.LoadValues(Properties : TStringList);
var
  i: integer;
begin
  FDataLoaded := True;
  WmiMetaData:=TWMiClassMetaData.Create(WmiNamespace, WmiClass);

  FWQLProperties.Clear;
  if (Properties=nil) or (Properties.Count=0) then
  begin
    for i:=0 to WmiMetaData.PropertiesCount-1 do
      FWQLProperties.Add(WmiMetaData.Properties[i].Name)
  end
  else
    for i:=0 to Properties.Count-1 do
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

  FThread := TWMIQueryToListView.Create('.', '', '', FWmiNamespace, FWQL.Text, FWMIProperties, ListViewGrid, Log, FValues);
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


procedure TFrmWmiVwProps.ShowDetailsData;
Var
 Frm  : TFrmValueList;
 i    : Integer;
  RowData : TStrings;
begin
 if not Assigned(ListViewGrid.Selected) then exit;
 RowData:=FValues[ListViewGrid.Selected.Index];

 Frm:=TFrmValueList.Create(nil);
 Frm.WMIProperties:=FWMIProperties;
 Frm.Caption:='Properties '+WmiClass;
  for i := 0 to ListViewGrid.Columns.Count-1 do
    Frm.ValueList.InsertRow(ListViewGrid.Columns[i].Caption, RowData[i], True);

 Frm.Show();
end;


procedure TFrmWmiVwProps.ShowDetailsProps;
Var
 Frm  : TFrmValueList;
 i    : Integer;
begin
 if not Assigned(ListViewPropsLinks.Selected) then exit;

 Frm:=TFrmValueList.Create(nil);
 Frm.WMIProperties:=nil;//FWMIProperties;
 Frm.Caption:='Sources '+WmiClass+'.'+ListViewPropsLinks.Selected.Caption;
  for i := 0 to ListViewPropsLinks.Columns.Count-1 do
   if i=0 then
    Frm.ValueList.InsertRow('Name', ListViewPropsLinks.Selected.Caption, True)
   else
   if (i-1)<ListViewPropsLinks.Selected.SubItems.Count then
    Frm.ValueList.InsertRow(ListViewPropsLinks.Columns[i].Caption, ListViewPropsLinks.Selected.SubItems[i-1], True);

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
      ListWMIProperties : TStrings;
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
  FProperties := ListWMIProperties;
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
  //FProperties.Free;
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


        FProperties.AddObject('Object Path', TObject(wbemCimtypeString));
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
