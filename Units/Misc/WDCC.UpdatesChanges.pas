// **************************************************************************************************
//
// Unit WDCC.UpdatesChanges
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
// The Original Code is WDCC.UpdatesChanges.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************
unit WDCC.UpdatesChanges;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw, Vcl.Styles.WebBrowser;

type
  TWebBrowser = class(TVclStylesWebBrowser);

  TFrmUpdateChanges = class(TForm)
    ImageUpdate: TImage;
    LabelMsg: TLabel;
    BtnOk: TButton;
    BtnCancel: TButton;
    WebBrowser1: TWebBrowser;
    btnDetails: TButton;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
  private
    { Private declarations }
    FExecute: Boolean;
    FURLFeed: string;
    procedure Load;
  public
    { Public declarations }
    property URLFeed: string read FURLFeed write FURLFeed;
    function Execute: Boolean;
  end;

function CheckChangesUpdates(const msg: string): Boolean;

implementation

uses
  Vcl.Styles,
  Vcl.Themes,
  Vcl.GraphUtil,
  MsHtml,
  System.Win.ComObj,
  Winapi.ActiveX,
  Winapi.msxml;

{$R *.dfm}

function CheckChangesUpdates(const msg: string): Boolean;
var
  Frm: TFrmUpdateChanges;
begin
  Frm := TFrmUpdateChanges.Create(nil);
  try
    Frm.LabelMsg.Caption := msg;
    Frm.URLFeed := 'http://code.google.com/feeds/p/wmi-delphi-code-creator/svnchanges/basic';
    Frm.ShowModal;
    Result := Frm.FExecute;
  finally
    Frm.Free;
  end;
end;

procedure TFrmUpdateChanges.BtnCancelClick(Sender: TObject);
begin
  FExecute := False;
  Close;
end;

procedure TFrmUpdateChanges.BtnOkClick(Sender: TObject);
begin
  FExecute := True;
  Close;
end;

procedure TFrmUpdateChanges.btnDetailsClick(Sender: TObject);
begin
  if ClientHeight < 200 then
  begin
    Height := Height + 210;
    Load;
  end
  else
    Height := Height - 210;
end;

function TFrmUpdateChanges.Execute: Boolean;
begin
  ShowModal;
  Result := Execute;
end;

procedure TFrmUpdateChanges.FormCreate(Sender: TObject);
begin
  FExecute := False;
end;

procedure TFrmUpdateChanges.Load;
const
  COMPLETED = 4;
  OK = 200;
  XslRss = '<xsl:stylesheet version="1.0"' +

    '  xmlns:atom="http://www.w3.org/2005/Atom"' + '  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"' +
    '  xmlns:dc="http://purl.org/dc/elements/1.1/">' +

    '    <xsl:output method="html"/>' + '    <xsl:template match="/">' +

    '    <xsl:apply-templates select="/atom:feed/atom:head"/>' + '        <xsl:apply-templates select="/atom:feed"/>' +
    '    </xsl:template>' +

    '    <xsl:template match="atom:feed/atom:head">' + '        <h3><xsl:value-of select="atom:title"/></h3>' +
    '        <xsl:if test="atom:tagline"><p><xsl:value-of select="atom:tagline"/></p></xsl:if>' +
    '        <xsl:if test="atom:subtitle"><p><xsl:value-of select="atom:subtitle"/></p></xsl:if>' +
    '    </xsl:template>' +

    '    <xsl:template match="/atom:feed">' + '    <html xmlns="http://www.w3.org/1999/xhtml">' +
    '      <body style="font-family:Arial;font-size:12pt;background-color:%s">' +
    '       <div style="background-color:%s;color:%s;font-family: Tahoma;font-size:12px">' +
    '          <h3><xsl:value-of select="atom:title"/></h3>' + '       </div>' +
    '        <xsl:if test="atom:tagline"><p><xsl:value-of select="atom:tagline"/></p></xsl:if>' +
    '        <xsl:if test="atom:subtitle"><p><xsl:value-of select="atom:subtitle"/></p></xsl:if>' + '        <ul>' +
    '            <xsl:apply-templates select="atom:entry"/>' + '        </ul>' + '      </body>' + '    </html>' +
    '    </xsl:template>' +

    '    <xsl:template match="atom:entry">' +
    '    <div style="background-color:%s;color:%s;font-family: monospace;font-size:12px">' +
    '            <a href="{atom:link[@rel=''related'']/@href}" title="{substring(atom:published, 0, 11)}"><xsl:value-of select="atom:title"/></a>'
    + '            <xsl:choose>' + '                <xsl:when test="atom:content != ''''">' +
    '                    <p><xsl:value-of select="atom:content" disable-output-escaping="yes" /></p>' +
    '                </xsl:when>' + '                <xsl:otherwise>' +
    '                    <p><xsl:value-of select="atom:summary" disable-output-escaping="yes" /></p>' +
    '                </xsl:otherwise>' + '            </xsl:choose>' + '    </div>' + '    </xsl:template>' +
    '</xsl:stylesheet>';

var
  XMLHTTPRequest: IXMLHTTPRequest;
  StringStream: TStringStream;
  StreamAdapter: IStream;
  PersistStreamInit: IPersistStreamInit;
  XmlStr: string;
  XMLDOMDocument: IXMLDOMDocument;
  Xsl: IXMLDOMDocument;
  FontColor: string;
  BackColor: string;
  LColor: TColor;
begin

  if not TStyleManager.IsCustomStyleActive then
    LColor := clWhite
  else
    LColor := StyleServices.GetSystemColor(clWindow);
  BackColor := ColorToWebColorStr(LColor);

  if not TStyleManager.IsCustomStyleActive then
    LColor := clBlack
  else
    LColor := StyleServices.GetSystemColor(clWindowText);
  FontColor := ColorToWebColorStr(LColor);

  WebBrowser1.HandleNeeded;
  WebBrowser1.Navigate('about:blank');
  while WebBrowser1.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

  if Assigned(WebBrowser1.Document) then
  begin
    XMLHTTPRequest := CreateOleObject('MSXML2.XMLHTTP') As IXMLHTTPRequest;
    try
      XMLHTTPRequest.open('GET', FURLFeed, False, EmptyParam, EmptyParam);
      XMLHTTPRequest.send('');
      if (XMLHTTPRequest.ReadyState = COMPLETED) and (XMLHTTPRequest.status = OK) then
      begin
        XmlStr := XMLHTTPRequest.responseText;
        XMLDOMDocument := CoDOMDocument.Create();
        XMLDOMDocument.async := False;
        XMLDOMDocument.loadXML(XmlStr);
        Xsl := CoDOMDocument.Create();
        Xsl.async := False;
        Xsl.loadXML(Format(XslRss, [BackColor, BackColor, FontColor, BackColor, FontColor]));
        XmlStr := XMLDOMDocument.transformNode(Xsl);

        StringStream := TStringStream.Create(XmlStr);
        try
          if WebBrowser1.Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
          begin
            StringStream.Seek(0, 0);
            StreamAdapter := TStreamAdapter.Create(StringStream);
            PersistStreamInit.Load(StreamAdapter);
          end;
        finally
          StringStream.Free;
        end;
      end;
    finally
      XMLHTTPRequest := nil;
    end;
  end;
end;

end.
