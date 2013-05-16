{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiClassTree                                                                               }
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
{ The Original Code is uWmiClassTree.pas.                                                          }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2013 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit uWmiClassTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFrmWmiClassTree = class(TForm)
    Label1: TLabel;
    CbNamespaces: TComboBox;
    TreeViewClasses: TTreeView;
    BtnFillTree: TButton;
    LabelStatus: TLabel;
    ProgressBar1: TProgressBar;
    procedure BtnFillTreeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeViewClassesCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    Working : Boolean;
    DataLoaded : Boolean;
    procedure FillTree(const Namesoace:string);
    procedure SetStaus(const Msg:string);
    procedure Fill;
    procedure LoadNamespaces;
    procedure SetOwnerDrawMethods;
    procedure CMStyleChanged(var Message: TMessage); message CM_STYLECHANGED;
  public
  end;

implementation

uses
  Vcl.Styles,
  Vcl.Themes,
  AsyncCalls,
  ComObj,
  ActiveX,
  uGLobals,
  uWmi_Metadata,
  uMisc;

{$R *.dfm}

procedure TFrmWmiClassTree.BtnFillTreeClick(Sender: TObject);
begin
 Fill;
end;


procedure TFrmWmiClassTree.CMStyleChanged(var Message: TMessage);
begin
  SetOwnerDrawMethods;
end;

procedure TFrmWmiClassTree.Fill;
var
  LAsyncCall: IAsyncCall;

 Procedure Foo;
 begin
  FillTree(CbNamespaces.Text);
 end;

 Procedure Foo2(const NameSpace:string);
 begin
  FillTree(NameSpace);
 end;

begin
  if Working then exit;
  Working:=True;

  {$IFNDEF CPUX64}
  LAsyncCall := LocalAsyncCall(@Foo);
  {$ELSE}
  LAsyncCall := AsyncCall(@Foo2, CbNamespaces.Text);
  {$ENDIF ~CPUX64}

  while AsyncMultiSync([LAsyncCall], True, 1) = WAIT_TIMEOUT do
    Application.ProcessMessages;

  Working:=False;
end;

procedure TFrmWmiClassTree.FillTree(const Namesoace: string);
Var
  Root        : TTreeNode;
  Node        : TTreeNode;
  WmiClasses  : TStringList;
  WmiClass    : string;
  i           : Integer;


  procedure GetSubClasses(AClass:string;ANode:TTreeNode);
  var
    SubClass    : string;
    lNode       : TTreeNode;
    SubClasses  : TStringList;
  begin
   SubClasses:=TStringList.Create;
   try
    SetStaus(Format('Gettting Sub Classes of %s',[AClass]));
    GetListWmiSubClasses(Namesoace,AClass,SubClasses);
    if SubClasses.Count>0 then
    for SubClass in SubClasses do
    begin
     lNode:=TreeViewClasses.Items.AddChild(ANode,SubClass);
     GetSubClasses(SubClass,lNode);
    end;
   finally
    SubClasses.Free;
   end;
  end;

begin
   WmiClasses:=TStringList.Create;
   try
     SetStaus('Gettting Parent Classes');
     GetListWmiParentClasses(Namesoace,WmiClasses);
     TreeViewClasses.Items.BeginUpdate;
     TreeViewClasses.Items.Clear;
     Root:=TreeViewClasses.Items.Add(nil,Namesoace);
     ProgressBar1.Max:=WmiClasses.Count;
     try
      for i:=0 to WmiClasses.Count-1 do
      begin
        ProgressBar1.Position:=i;
        WmiClass:=WmiClasses[i];
        Node:=TreeViewClasses.Items.AddChild(root,WmiClass);
        GetSubClasses(WmiClass,Node);
      end;

     finally
       TreeViewClasses.Items.EndUpdate;
       TreeViewClasses.Items.Item[0].Expand(True);
     end;
   finally
     WmiClasses.Free;
     SetStaus('');
     ProgressBar1.Position:=0;
   end;
end;

procedure TFrmWmiClassTree.FormCreate(Sender: TObject);
begin
  SetOwnerDrawMethods;
  Working:=False;
  DataLoaded:=False;
end;

procedure TFrmWmiClassTree.FormShow(Sender: TObject);
begin
 if not DataLoaded then
  LoadNamespaces;
end;

procedure TFrmWmiClassTree.LoadNamespaces;
begin
 CbNamespaces.Items.AddStrings(CachedWMIClasses.NameSpaces);
 CbNamespaces.ItemIndex:=0;
 DataLoaded:=True;
end;


procedure TFrmWmiClassTree.SetOwnerDrawMethods;
begin
 uMisc.SetOwnerDrawMethods(Self);
end;

procedure TFrmWmiClassTree.SetStaus(const Msg: string);
begin
  LabelStatus.Caption:=Msg;
  LabelStatus.Update;
end;

procedure TFrmWmiClassTree.TreeViewClassesCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if not StyleServices.IsSystemStyle then
  if cdsSelected in State then
  begin
    TTreeView(Sender).Canvas.Brush.Color := StyleServices.GetSystemColor(clHighlight);
    TTreeView(Sender).Canvas.Font.Color := StyleServices.GetSystemColor(clHighlightText);
  end;
end;

end.
