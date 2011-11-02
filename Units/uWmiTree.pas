{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiTree                                                                                    }
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
{ The Original Code is uWmiTree.pas.                                                               }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, ImgList, uWmi_Metadata,
  OleCtrls, SHDocVw, SynEdit, ComCtrls, StdCtrls, ExtCtrls;

const
  NamespaceImageIndex = 0;
  ClassImageIndex     = 1;
  MethodImageIndex    = 2;
  PropertyImageIndex  = 3;
  QualifierImageIndex = 4;
  ParameterInImageIndex = 5;
  ParameterOutImageIndex = 6;

  LevelNameSpace = 0;
  LevelClass     = 1;
  LevelPropertyMethod = 2;

type
  TFrmWMITree = class(TForm)
    PanelTreeMain:  TPanel;
    Splitter7:      TSplitter;
    Splitter3:      TSplitter;
    PanelLegend:    TPanel;
    TreeViewWmiClasses: TTreeView;
    MemoDescr:      TMemo;
    PanelClassInfo: TPanel;
    PageControl2:   TPageControl;
    TabSheetMOFClass: TTabSheet;
    MemoWmiMOF:     TMemo;
    TabSheetXMLClass: TTabSheet;
    TabSheet3:      TTabSheet;
    WebBrowserWmi:  TWebBrowser;
    TabSheet4:      TTabSheet;
    MemoQualifiers: TMemo;
    FindDialog1:    TFindDialog;
    TreeView1:      TTreeView;
    ImageList1:     TImageList;
    procedure FormCreate(Sender: TObject);
    procedure TreeViewWmiClassesChange(Sender: TObject; xNode: TTreeNode);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure FreeTreeClasses;
    procedure LoadXMLWMIClass(const Xml: string);
  public
    { Public declarations }
    procedure LoadClassInfo(WmiMetaClassInfo : TWMiClassMetaData);
  end;

function FindTextTreeView(const AText: string;
  ATree: TTreeView; StartNode: TTreeNode = nil): TTreeNode;

implementation

uses
  XMLDoc,
  XMLIntf,
  StrUtils,
  Main,
  uMisc;

{$R *.dfm}

function FindTextTreeView(const AText: string;
  ATree: TTreeView; StartNode: TTreeNode = nil): TTreeNode;
var
  Node: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then
    Exit;

  if StartNode = nil then
    Node := ATree.Items[0]
  else
    Node := StartNode;

  while Node <> nil do
  begin
    if CompareText(Node.Text, AText) = 0 then
    begin
      Result := Node;
      Break;
    end;
    Node := Node.GetNext;
  end;
end;


procedure TFrmWMITree.FindDialog1Find(Sender: TObject);
var
  Node:     TTreeNode;
  FindText: string;
begin
  FindText := Trim(FindDialog1.FindText);

  if Trim(FindText) = '' then
    exit;

  Node := FindTextTreeView(FindText, TreeViewWmiClasses, TreeViewWmiClasses.Selected);
  if Node <> nil then
  begin
    Node.MakeVisible;
    TreeViewWmiClasses.Selected := Node;
  end
  else
    MsgInformation(Format('%s Not found', [FindText]));
end;

procedure TFrmWMITree.FormCreate(Sender: TObject);

  procedure AddImage(const delta, index: integer; const Text: string);
  var
    dImage: TImage;
    dLabel: TLabel;
  begin
    dImage      := TImage.Create(Self);
    dImage.Parent := PanelLegend;
    dImage.Top  := 5;
    dImage.Left := (delta - 1) * 100 + 10;
    ImageList1.GetBitmap(index, dImage.Picture.Bitmap);

    dLabel      := TLabel.Create(Self);
    dLabel.Parent := PanelLegend;
    dLabel.Top  := 5;
    dLabel.Left := (delta - 1) * 100 + 30;
    dLabel.Caption := Text;
    dLabel.Transparent := True;
  end;

begin

  AddImage(1, NamespaceImageIndex, 'Namespace');
  AddImage(2, ClassImageIndex, 'WMI Class');
  AddImage(3, MethodImageIndex, 'WMI Method');
  AddImage(4, PropertyImageIndex, 'WMI Property');
  AddImage(5, QualifierImageIndex, 'Qualifier');
  AddImage(6, ParameterInImageIndex, 'In Parameter');
  AddImage(7, ParameterOutImageIndex, 'Out Parameter');

  PanelClassInfo.Height := 0;

end;

procedure TFrmWMITree.FormDestroy(Sender: TObject);
begin
  FreeTreeClasses;
end;

procedure TFrmWMITree.FreeTreeClasses;
var
  i: integer;
begin
  for i := 0 to TreeViewWmiClasses.Items.Count - 1 do
    if TreeViewWmiClasses.Items[i].Level = LevelNameSpace then
      if Assigned(TreeViewWmiClasses.Items[i].Data) then
        TStringList(TreeViewWmiClasses.Items[i].Data).Free;
end;


procedure TFrmWMITree.LoadClassInfo(WmiMetaClassInfo : TWMiClassMetaData);
var
  i, j: integer;
  Node: TTreeNode;
  NodeC: TTreeNode;
  NodeQ: TTreeNode;
  Xml: string;
begin
  FrmMain.ProgressBarWmi.Visible := True;
  try
    if Assigned(WmiMetaClassInfo)  then
    begin
      FrmMain.SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

      WebBrowserWmi.Navigate(Format(UrlWmiHelp, [WmiMetaClassInfo.WmiClass]));
      MemoWmiMOF.Lines.Text := WmiMetaClassInfo.WmiClassMOF;
      Xml := WmiMetaClassInfo.WmiClassXML;
      LoadXMLWMIClass(Xml);
      MemoQualifiers.Lines.BeginUpdate;
      MemoQualifiers.Lines.Clear;
      try
        for i := 0 to WmiMetaClassInfo.QualifiersCount - 1 do
          MemoQualifiers.Lines.Add(
            Format('%-30s %s', [WmiMetaClassInfo.Qualifiers[i].Name, WmiMetaClassInfo.Qualifiers[i].Value]));
      finally
        MemoQualifiers.Lines.EndUpdate;
      end;

      Node := FindTextTreeView(WmiMetaClassInfo.WmiNameSpace, TreeViewWmiClasses);
      if Assigned(Node) then
        Node := FindTextTreeView(WmiMetaClassInfo.WmiClass, TreeViewWmiClasses, Node);

      if Assigned(Node) and (Node.Count = 0) then
        //only if not has child node add the info
      begin
        TreeViewWmiClasses.Items.BeginUpdate;
        try
          //add properties and info about it
            for i := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
            begin
              NodeC := TreeViewWmiClasses.Items.AddChild(
                Node, Format('Property %s : %s', [WmiMetaClassInfo.Properties[i].Name, WmiMetaClassInfo.Properties[i].&Type]));
              NodeC.ImageIndex := PropertyImageIndex;
              NodeC.SelectedIndex := PropertyImageIndex;

              //Add props Qualifiers
              //GetWmiClassPropertiesQualifiers( Namespace, WmiClass, Props.Names[i], List);
              for j := 0 to WmiMetaClassInfo.Properties[i].Qualifiers.Count - 1 do
              begin
                NodeQ :=
                  TreeViewWmiClasses.Items.AddChild(
                  NodeC, Format('%s=%s', [WmiMetaClassInfo.Properties[i].Qualifiers[j].Name, WmiMetaClassInfo.Properties[i].Qualifiers[j].Value]));
                NodeQ.ImageIndex := QualifierImageIndex;
                NodeQ.SelectedIndex := QualifierImageIndex;
              end;
            end;

            //add methods and info about it
            for i := 0 to WmiMetaClassInfo.MethodsCount - 1 do
            begin
              NodeC := TreeViewWmiClasses.Items.AddChild(Node, Format('Method %s', [WmiMetaClassInfo.Methods[i].Name]));
              NodeC.ImageIndex := MethodImageIndex;
              NodeC.SelectedIndex := MethodImageIndex;

              //Add methods Qualifiers
                for j := 0 to WmiMetaClassInfo.Methods[i].Qualifiers.Count - 1 do
                begin
                  NodeQ :=
                    TreeViewWmiClasses.Items.AddChild(
                    NodeC, Format('%s=%s', [WmiMetaClassInfo.Methods[i].Qualifiers[j].Name, WmiMetaClassInfo.Methods[i].Qualifiers[j].Value]));
                  NodeQ.ImageIndex := QualifierImageIndex;
                  NodeQ.SelectedIndex := QualifierImageIndex;
                end;

              //Add methods In parameters
                for j := 0 to WmiMetaClassInfo.Methods[i].InParams.Count - 1 do
                begin
                  NodeQ :=
                    TreeViewWmiClasses.Items.AddChild(
                    NodeC, Format('[In] %s:%s', [WmiMetaClassInfo.Methods[i].InParams[j], WmiMetaClassInfo.Methods[i].InParamsTypes[j]]));
                  NodeQ.ImageIndex := ParameterInImageIndex;
                  NodeQ.SelectedIndex := ParameterInImageIndex;
                end;

              //Add methods Out parameters
                for j := 0 to WmiMetaClassInfo.Methods[i].OutParams.Count- 1 do
                begin
                  NodeQ :=
                    TreeViewWmiClasses.Items.AddChild(
                    NodeC, Format('[Out] %s:%s', [WmiMetaClassInfo.Methods[i].OutParams[j], WmiMetaClassInfo.Methods[i].OutParamsTypes[j]]));
                  NodeQ.ImageIndex := ParameterOutImageIndex;
                  NodeQ.SelectedIndex := ParameterOutImageIndex;
                end;
            end;

        finally
          TreeViewWmiClasses.Items.EndUpdate;
        end;
      end;
    end;

  finally
    FrmMain.SetMsg('');
    FrmMain.ProgressBarWmi.Visible := False;
  end;
end;

procedure DOMShow(ATree: TTreeView; Anode: IXMLNode; TNode: TTreeNode);
var
  I:      integer;
  NTNode: TTreeNode;
  NText:  string;
  AttrNode: IXMLNode;
  sValue: string;
begin

  if not (Anode.NodeType = ntElement) then
    Exit;

  NText := '<' + UpperCase(Anode.NodeName) + '>';

  if Anode.IsTextElement then
    NText := NText + '=' + Anode.NodeValue;
  NTNode := ATree.Items.AddChild(TNode, NText);

  sValue := '';
  for I := 0 to Anode.AttributeNodes.Count - 1 do
  begin
    AttrNode := Anode.AttributeNodes.Nodes[I];
    sValue   := sValue + AttrNode.NodeName + ' = “' + AttrNode.Text + '” ';
  end;

  if sValue <> '' then
    NTNode.Text := '<' + UpperCase(Anode.NodeName) + ' ' + sValue + '>';

  if Anode.HasChildNodes then
    for I := 0 to Anode.ChildNodes.Count - 1 do
    begin
      Application.ProcessMessages;
      DOMShow(Atree, Anode.ChildNodes.Nodes[I], NTNode);
    end;
end;


procedure TFrmWMITree.LoadXMLWMIClass(const Xml: string);
var
  oXmlDoc: IXMLDocument;
begin
  oXmlDoc := TXMLDocument.Create(nil);
  try
    try
      oXmlDoc.Options  := [doNodeAutoIndent];
      oXmlDoc.XML.Text := Xml;
      oXmlDoc.Active   := True;

      TreeView1.Items.BeginUpdate;
      TreeView1.Items.Clear;
      try
        DOMShow(TreeView1, oXmlDoc.DocumentElement, nil);
      finally
        TreeView1.Items.EndUpdate;
      end;
    except
      on E: Exception do
        //MsgError(Format('A error ocurred parsing the WMI XML Definition %s',[e.Message]));
        FrmMain.MemoLog.Lines.Add(
          Format('A error ocurred parsing the WMI XML Definition %s', [e.Message]));
    end;
  finally
    oXmlDoc := nil;
  end;
end;

procedure TFrmWMITree.TreeViewWmiClassesChange(Sender: TObject; xNode: TTreeNode);
var
  Node:   TTreeNode;
  WMiClassMetaData : TWMiClassMetaData;
begin
  //MemoDescr.Lines.Clear;
  Node := TreeViewWmiClasses.Selected;
  if Assigned(Node) and (Node.Level = LevelNameSpace) and (Node.Count = 0) then
  begin
    PanelClassInfo.Height := 0;
    FrmMain.ComboBoxNameSpaces.ItemIndex :=
      FrmMain.ComboBoxNameSpaces.Items.IndexOf(Node.Text);
    FrmMain.LoadWmiClasses(FrmMain.ComboBoxNameSpaces.Text);

    FrmMain.ComboBoxClasses.ItemIndex := 0;
    FrmMain.LoadClassInfo;
    FrmMain.GenerateConsoleCode;
  end
  else
  if Assigned(Node) and (Node.Level = LevelClass) and (Assigned(Node.Parent)) then
  begin
    PanelClassInfo.Height := 220;
    FrmMain.ComboBoxNameSpaces.ItemIndex :=
      FrmMain.ComboBoxNameSpaces.Items.IndexOf(Node.Parent.Text);
    FrmMain.LoadWmiClasses(FrmMain.ComboBoxNameSpaces.Text);
    FrmMain.ComboBoxClasses.ItemIndex := FrmMain.ComboBoxClasses.Items.IndexOf(Node.Text);
    FrmMain.ComboBoxClassesChange(FrmMain.ComboBoxClasses);
    WMiClassMetaData:=TWMiClassMetaData(FrmMain.ComboBoxClasses.Items.Objects[FrmMain.ComboBoxClasses.ItemIndex]);
    MemoDescr.Lines.Text :=WMiClassMetaData.DescriptionEx;
    LoadClassInfo(WMiClassMetaData);
    FrmMain.GenerateConsoleCode;
  end
  else
  if Assigned(Node) and (Node.Level = LevelPropertyMethod) then
  begin
    {
    //'Property %s : %s'
    if StartsText('Property', Node.Text) then
    begin
      sValue := StringReplace(Node.Text, 'Property ', '', [rfReplaceAll]);
      sValue := Trim(Copy(sValue, 1, Pos(':', sValue) - 1));
      MemoDescr.Lines.Text := GetWmiPropertyDescription(Node.Parent.Parent.Text, Node.Parent.Text, sValue);
    end
    else
    if StartsText('Method', Node.Text) then
    begin
      sValue := Trim(StringReplace(Node.Text, 'Method', '', [rfReplaceAll]));
      MemoDescr.Lines.Text := GetWmiMethodDescription(
        Node.Parent.Parent.Text, Node.Parent.Text, sValue);
    end;
    }
  end
  else
  if Assigned(Node) and (Node.Level = LevelNameSpace) then
    PanelClassInfo.Height := 0
  else
    PanelClassInfo.Height := 220;
end;

end.
