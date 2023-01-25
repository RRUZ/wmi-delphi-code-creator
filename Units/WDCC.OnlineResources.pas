// **************************************************************************************************
//
// Unit WDCC.OnlineResources
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
// The Original Code is WDCC.OnlineResources.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.OnlineResources;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFrmOnlineResources = class(TForm)
    ListViewURL: TListView;
    Panel1: TPanel;
    EditSearch: TEdit;
    btnSearch: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListViewURLDblClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure EditSearchExit(Sender: TObject);
  private
    FSearchKey: string;
    procedure SetSearchKey(const Value: string);
  public
    property SearchKey: string read FSearchKey write SetSearchKey;
    procedure GetResults;
  end;

function GetURLBySearchTerm(const SearchKey: string): string;

var
  FrmOnlineResources: TFrmOnlineResources;

implementation

uses
  IdURI,
  WDCC.ListView.Helper,
  ShellApi,
  ComObj,
  MSXML;

{$R *.dfm}

function GetURLBySearchTerm(const SearchKey: string): string;
const
  ApplicationID = 'TnirCFpM4B8F8mCECpFxNtF0i0qts/xVKkVJT/iWRig=';
  URI = 'https://api.datamarket.azure.com/Bing/Search/Web?Query=%s&$format=ATOM&$top=%d&$skip=%d';
  COMPLETED = 4;
  OK = 200;
var
  XMLHTTPRequest: IXMLHTTPRequest;
  XMLDOMDocument: IXMLDOMDocument;
  XMLDOMNode: IXMLDOMNode;
  cXMLDOMNode: IXMLDOMNode;
  XMLDOMNodeList: IXMLDOMNodeList;
  LIndex: Integer;
begin
  Result := '';
  XMLHTTPRequest := CreateOleObject('MSXML2.XMLHTTP') As IXMLHTTPRequest;
  try
    XMLHTTPRequest.open('GET', Format(URI, [TIdURI.PathEncode(QuotedStr(SearchKey)), 10, 0]), False, ApplicationID,
      ApplicationID);
    XMLHTTPRequest.send('');
    if (XMLHTTPRequest.readyState = COMPLETED) and (XMLHTTPRequest.status = OK) then
    begin
      XMLDOMDocument := CoDOMDocument.Create;
      try
        XMLDOMDocument.loadXML(XMLHTTPRequest.responseText);
        XMLDOMNode := XMLDOMDocument.selectSingleNode('/feed');
        XMLDOMNodeList := XMLDOMNode.selectNodes('//entry');
        for LIndex := 0 to XMLDOMNodeList.length - 1 do
        begin
          XMLDOMNode := XMLDOMNodeList.item[LIndex];
          cXMLDOMNode := XMLDOMNode.selectSingleNode(Format('//entry[%d]/content/m:properties/d:Url', [LIndex]));
          Result := String(cXMLDOMNode.Text);
          Break;
        end;
      finally
        XMLDOMDocument := nil;
      end;
    end;
  finally
    XMLHTTPRequest := nil;
  end;
end;

procedure TFrmOnlineResources.btnSearchClick(Sender: TObject);
begin
  GetResults;
end;

procedure TFrmOnlineResources.EditSearchExit(Sender: TObject);
begin
  FSearchKey := EditSearch.Text;
end;

procedure TFrmOnlineResources.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmOnlineResources.GetResults;
const
  ApplicationID = 'TnirCFpM4B8F8mCECpFxNtF0i0qts/xVKkVJT/iWRig=';
  URI = 'https://api.datamarket.azure.com/Bing/Search/Web?Query=%s&$format=ATOM&$top=%d&$skip=%d';
  COMPLETED = 4;
  OK = 200;
var
  XMLHTTPRequest: IXMLHTTPRequest;
  XMLDOMDocument: IXMLDOMDocument;
  XMLDOMNode: IXMLDOMNode;
  cXMLDOMNode: IXMLDOMNode;
  XMLDOMNodeList: IXMLDOMNodeList;
  LIndex: Integer;
  item: TListItem;

begin
  ListViewURL.Items.Clear;
  XMLHTTPRequest := CreateOleObject('MSXML2.XMLHTTP') As IXMLHTTPRequest;
  try
    XMLHTTPRequest.open('GET', Format(URI, [TIdURI.PathEncode(QuotedStr(SearchKey)), 10, 0]), False, ApplicationID,
      ApplicationID);
    XMLHTTPRequest.send('');
    if (XMLHTTPRequest.readyState = COMPLETED) and (XMLHTTPRequest.status = OK) then
    begin
      XMLDOMDocument := CoDOMDocument.Create;
      try
        XMLDOMDocument.loadXML(XMLHTTPRequest.responseText);
        XMLDOMNode := XMLDOMDocument.selectSingleNode('/feed');
        XMLDOMNodeList := XMLDOMNode.selectNodes('//entry');
        for LIndex := 0 to XMLDOMNodeList.length - 1 do
        begin
          item := ListViewURL.Items.Add;
          XMLDOMNode := XMLDOMNodeList.item[LIndex];
          cXMLDOMNode := XMLDOMNode.selectSingleNode(Format('//entry[%d]/content/m:properties/d:Title', [LIndex]));
          item.Caption := String(cXMLDOMNode.Text);
          cXMLDOMNode := XMLDOMNode.selectSingleNode(Format('//entry[%d]/content/m:properties/d:Url', [LIndex]));
          item.SubItems.Add(String(cXMLDOMNode.Text));
          cXMLDOMNode := XMLDOMNode.selectSingleNode(Format('//entry[%d]/content/m:properties/d:Description',
            [LIndex]));
          item.SubItems.Add(String(cXMLDOMNode.Text));
        end;
      finally
        XMLDOMDocument := nil;
      end;
    end;
  finally
    XMLHTTPRequest := nil;
  end;
  AutoResizeListView(ListViewURL);
end;
{
  const
  ApplicationID= '73C8F474CA4D1202AD60747126813B731199ECEA';
  URI='http://api.bing.net/xml.aspx?AppId=%s&Version=2.2&Market=en-US&Query=%s&Sources=web&web.count=%d&xmltype=AttributeBased';
  COMPLETED=4;
  OK       =200;
  var
  XMLHTTPRequest  : IXMLHTTPRequest;
  XMLDOMDocument  : IXMLDOMDocument;
  XMLDOMNode      : IXMLDOMNode;
  XMLDOMNodeList  : IXMLDOMNodeList;
  LIndex          : Integer;
  Item            : TListItem;

  begin
  ListViewURL.Items.Clear;
  XMLHTTPRequest := CreateOleObject('MSXML2.XMLHTTP') As XMLHTTP;
  try
  XMLHTTPRequest.open('GET', Format(URI,[ApplicationID, SearchKey, 10]), False, EmptyParam, EmptyParam);
  XMLHTTPRequest.send('');
  if (XMLHTTPRequest.readyState = COMPLETED) and (XMLHTTPRequest.status = OK) then
  begin
  XMLDOMDocument := XMLHTTPRequest.responseXML  As IXMLDOMDocument2;
  XMLDOMNode := XMLDOMDocument.selectSingleNode('//web:Web');
  XMLDOMNodeList := XMLDOMNode.selectNodes('//web:WebResult');
  for LIndex:=0 to  XMLDOMNodeList.length-1 do
  begin
  Item:=ListViewURL.Items.Add;
  XMLDOMNode:=XMLDOMNodeList.item[LIndex];
  Item.Caption:=String(XMLDOMNode.attributes.getNamedItem('Title').Text);
  Item.SubItems.Add(String(XMLDOMNode.attributes.getNamedItem('Url').Text));
  Item.SubItems.Add(String(XMLDOMNode.attributes.getNamedItem('Description').Text));
  end;
  end;
  finally
  XMLHTTPRequest := nil;
  end;
  AutoResizeListView(ListViewURL);
  end;
}

procedure TFrmOnlineResources.ListViewURLDblClick(Sender: TObject);
begin
  if ListViewURL.Selected <> nil then
    ShellExecute(Handle, 'open', PChar(ListViewURL.Selected.SubItems[0]), nil, nil, SW_SHOW);
end;

procedure TFrmOnlineResources.SetSearchKey(const Value: string);
begin
  FSearchKey := Value;
  EditSearch.Text := FSearchKey;
end;

end.
