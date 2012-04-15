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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SynEditHighlighter, ImgList, uWmi_Metadata, uMisc, uSettings,
  XMLDoc,  XMLIntf, OleCtrls, SHDocVw, SynEdit, ComCtrls, StdCtrls, ExtCtrls, Vcl.Styles.WebBrowser;

const
  //NamespaceImageIndex = 0;
  ClassImageIndex     = 1;
  MethodImageIndex    = 2;
  PropertyImageIndex  = 3;
  QualifierImageIndex = 4;
  ParameterInImageIndex = 5;
  ParameterOutImageIndex = 6;

  //LevelNameSpace = 0;
  LevelClass     = 0;
  LevelPropertyMethod = 1;

type
  TWebBrowser=class(TVclStylesWebBrowser);
  TFrmWMITree = class(TForm)
    Splitter3:      TSplitter;
    PanelLegend:    TPanel;
    TreeViewWmiClasses: TTreeView;
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
    procedure FormShow(Sender: TObject);
  private
    DataLoaded : Boolean;
    FSetMsg: TProcLog;
    FSetLog: TProcLog;
    FNamespace: string;
    FSettings: TSettings;
    procedure LoadXMLWMIClass(const Xml: string);
    procedure DOMShow(ATree: TTreeView; Anode: IXMLNode; TNode: TTreeNode);
    procedure LoadWMIClasses;
    procedure SetSettings(const Value: TSettings);
  public
    procedure LoadClassInfo(WmiMetaClassInfo : TWMiClassMetaData);
    property SetMsg : TProcLog read FSetMsg Write FSetMsg;
    property SetLog : TProcLog read FSetLog Write FSetLog;
    property Namespace : string read FNamespace write FNamespace;
    property Settings : TSettings read FSettings Write SetSettings;
  end;

function FindTextTreeView(const AText: string;
  ATree: TTreeView; StartNode: TTreeNode = nil): TTreeNode;

implementation

uses
  uxtheme,
  uGlobals,
  ComObj,
  StrUtils;

{$R *.dfm}

function FindTextTreeView(const AText: string;  ATree: TTreeView; StartNode: TTreeNode = nil): TTreeNode;
var
  LNode: TTreeNode;
begin
  Result := nil;
  if ATree.Items.Count = 0 then
    Exit;

  if StartNode = nil then
    LNode := ATree.Items[0]
  else
    LNode := StartNode;

  while LNode <> nil do
  begin
    if SameText(LNode.Text, AText) then
    begin
      Result := LNode;
      Break;
    end;
    LNode := LNode.GetNext;
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
    //ImageList1.GetBitmap(index, dImage.Picture.Bitmap);
    ImageList1.GetIcon(index, dImage.Picture.Icon);

    dLabel      := TLabel.Create(Self);
    dLabel.Parent := PanelLegend;
    dLabel.Top  := 5;
    dLabel.Left := (delta - 1) * 100 + 30;
    dLabel.Caption := Text;
    dLabel.Transparent := True;
  end;

begin
  DataLoaded :=False;
  //AddImage(1, NamespaceImageIndex, 'Namespace');
  AddImage(1, ClassImageIndex, 'WMI Class');
  AddImage(2, MethodImageIndex, 'WMI Method');
  AddImage(3, PropertyImageIndex, 'WMI Property');
  AddImage(4, QualifierImageIndex, 'Qualifier');
  AddImage(5, ParameterInImageIndex, 'In Parameter');
  AddImage(6, ParameterOutImageIndex, 'Out Parameter');

  PanelClassInfo.Height := 0;
end;

procedure TFrmWMITree.FormShow(Sender: TObject);
begin
 if not DataLoaded then
  LoadWMIClasses;
end;

procedure TFrmWMITree.LoadClassInfo(WmiMetaClassInfo : TWMiClassMetaData);
var
  i, j: integer;
  Node: TTreeNode;
  NodeC: TTreeNode;
  NodeQ: TTreeNode;
  Xml: string;
begin
  //FrmMain.ProgressBarWmi.Visible := True;
  try
    if Assigned(WmiMetaClassInfo)  then
    begin
      SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

      WebBrowserWmi.HandleNeeded;
      WebBrowserWmi.Navigate(Format(UrlWmiHelp, [WmiMetaClassInfo.WmiClass]));
      {
      while WebBrowserWmi.ReadyState <> READYSTATE_COMPLETE do
        Application.ProcessMessages;
      }
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

      Node := FindTextTreeView(WmiMetaClassInfo.WmiClass, TreeViewWmiClasses, nil);

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
                for j := 0 to WmiMetaClassInfo.Methods[i].InParameters.Count - 1 do
                begin
                  NodeQ :=
                    TreeViewWmiClasses.Items.AddChild(
                    NodeC, Format('[In] %s:%s', [WmiMetaClassInfo.Methods[i].InParameters[j].Name, WmiMetaClassInfo.Methods[i].InParameters[j].&Type]));
                  NodeQ.ImageIndex := ParameterInImageIndex;
                  NodeQ.SelectedIndex := ParameterInImageIndex;
                end;

              //Add methods Out parameters
                for j := 0 to WmiMetaClassInfo.Methods[i].OutParameters.Count- 1 do
                begin
                  NodeQ :=
                    TreeViewWmiClasses.Items.AddChild(
                    NodeC, Format('[Out] %s:%s', [WmiMetaClassInfo.Methods[i].OutParameters[j].Name, WmiMetaClassInfo.Methods[i].OutParameters[j].&Type]));
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
    if @FSetMsg<>nil then
      SetMsg('');
    //FrmMain.ProgressBarWmi.Visible := False;
  end;
end;

procedure TFrmWMITree.LoadWMIClasses;
var
  LClasses : TStringList;
  LIndex   : integer;
  LNode    : TTreeNode;
begin
  PanelClassInfo.Height := 0;
  LClasses := TStringList.Create;
  try
    LClasses.Sorted := True;
    LClasses.BeginUpdate;
    try
      try
        if not ExistWmiClassesCache(FNamespace) then
        begin
          GetListWmiClasses(FNamespace, LClasses, [], ['abstract'], True);
          SaveWMIClassesToCache(FNamespace , LClasses);
        end
        else
          LoadWMIClassesFromCache(FNamespace, LClasses);
      except
        on E: EOleSysError do
          if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
            SetLog(Format('Access denied  %s %s  Code : %x', ['GetListWmiClasses', E.Message, E.ErrorCode]))
          else
            raise;
      end;

    finally
      LClasses.EndUpdate;
    end;

    TreeViewWmiClasses.Items.BeginUpdate;
    try
      for LIndex := 0 to LClasses.Count - 1 do
      begin
        LNode := TreeViewWmiClasses.Items.AddChild(nil, LClasses[LIndex]);
        LNode.ImageIndex := ClassImageIndex;
        LNode.SelectedIndex := ClassImageIndex;
      end;
    finally
      TreeViewWmiClasses.Items.EndUpdate;
    end;

    if TreeViewWmiClasses.Items.Count>0 then
    begin
     TreeViewWmiClasses.Selected:=TreeViewWmiClasses.Items.Item[0];
     TreeViewWmiClasses.Selected.Expand(True);
    end;


  finally
    LClasses.Free;
  end;
    DataLoaded:=True;
end;


procedure TFrmWMITree.DOMShow(ATree: TTreeView; Anode: IXMLNode; TNode: TTreeNode);
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
    sValue   := sValue + AttrNode.NodeName + ' = �' + AttrNode.Text + '� ';
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
        SetLog(Format('A error ocurred parsing the WMI XML Definition %s', [e.Message]));
    end;
  finally
    oXmlDoc := nil;
  end;
end;

procedure TFrmWMITree.SetSettings(const Value: TSettings);
begin
  FSettings := Value;
  MemoWmiMOF.Color:=FSettings.BackGroundColor;
  MemoWmiMOF.Font.Color:=FSettings.ForeGroundColor;
  MemoQualifiers.Color:=MemoWmiMOF.Color;
  MemoQualifiers.Font.Color:=MemoWmiMOF.Font.Color;
end;

procedure TFrmWMITree.TreeViewWmiClassesChange(Sender: TObject; xNode: TTreeNode);
var
  Node :   TTreeNode;
  WMiClassMetaData : TWMiClassMetaData;
begin
  Node := TreeViewWmiClasses.Selected;
  if Assigned(Node) and (Node.Level = LevelClass)  then
  begin
    PanelClassInfo.Height := 220;
    WMiClassMetaData:= CachedWMIClasses.GetWmiClass(FNamespace, Node.Text);
    LoadClassInfo(WMiClassMetaData);
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
  if Assigned(Node) and (Node.Level < LevelClass) then
    PanelClassInfo.Height := 0
  else
    PanelClassInfo.Height := 220;
end;


end.
