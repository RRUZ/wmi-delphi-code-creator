{**************************************************************************************************}
{                                                                                                  }
{ Unit uSynEditPopupEdit                                                                           }
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
{ The Original Code is uSynEditPopupEdit.pas.                                                      }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uSynEditPopupEdit;

interface

uses
 ActnList,
 Menus,
 Classes,
 SynEdit;

type
  TSynEdit = class(SynEdit.TSynEdit)
  private
    FActnList: TActionList;
    FPopMenu : TPopupMenu;
    procedure FillPopupMenu;
    procedure CutExecute(Sender: TObject);
    procedure CutUpdate(Sender: TObject);
    procedure CopyExecute(Sender: TObject);
    procedure CopyUpdate(Sender: TObject);
    procedure PasteExecute(Sender: TObject);
    procedure PasteUpdate(Sender: TObject);
    procedure DeleteExecute(Sender: TObject);
    procedure DeleteUpdate(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure SelectAllUpdate(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure RedoUpdate(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure UndoUpdate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

procedure TSynEdit.CopyExecute(Sender: TObject);
begin
  Self.CopyToClipboard;
end;

procedure TSynEdit.CopyUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=Self.SelAvail;
end;

procedure TSynEdit.CutExecute(Sender: TObject);
begin
  Self.CutToClipboard;
end;

procedure TSynEdit.CutUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=Self.SelAvail and not Self.ReadOnly;
end;

procedure TSynEdit.DeleteExecute(Sender: TObject);
begin
  Self.SelText := '';
end;

procedure TSynEdit.DeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=Self.SelAvail and not Self.ReadOnly;
end;

procedure TSynEdit.PasteExecute(Sender: TObject);
begin
 Self.PasteFromClipboard;
end;

procedure TSynEdit.PasteUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.CanPaste;
end;

procedure TSynEdit.RedoExecute(Sender: TObject);
begin
 Self.Redo;
end;

procedure TSynEdit.RedoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.CanRedo;
end;

procedure TSynEdit.SelectAllExecute(Sender: TObject);
begin
 Self.SelectAll;
end;

procedure TSynEdit.SelectAllUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.Lines.Text<>'';
end;

procedure TSynEdit.UndoExecute(Sender: TObject);
begin
 Self.Undo;
end;

procedure TSynEdit.UndoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.CanUndo;
end;

constructor TSynEdit.Create(AOwner: TComponent);
begin
  inherited;
  FActnList:=TActionList.Create(Self);
  FPopMenu:=TPopupMenu.Create(Self);
  FillPopupMenu;
  PopupMenu:=FPopMenu;
end;

destructor TSynEdit.Destroy;
begin
  FPopMenu.Free;
  FActnList.Free;
  inherited;
end;

procedure TSynEdit.FillPopupMenu;

 procedure AddMenuItem(const AText:string;AShortCut : TShortCut;AEnabled:Boolean;OnExecute,OnUpdate:TNotifyEvent);
 Var
    MenuItem    : TMenuItem;
    ActionItem  : TAction;
  begin
    ActionItem:=TAction.Create(FActnList);
    ActionItem.ActionList:=FActnList;
    ActionItem.Caption:=AText;
    ActionItem.ShortCut:=AShortCut;
    ActionItem.Enabled :=AEnabled;
    ActionItem.OnExecute :=OnExecute;
    ActionItem.OnUpdate  :=OnUpdate;


    MenuItem:=TMenuItem.Create(FPopMenu);
    MenuItem.Action  :=ActionItem;
    FPopMenu.Items.Add(MenuItem);
  end;

begin
  AddMenuItem('&Undo',Menus.ShortCut(Word('Z'), [ssCtrl]),False,UndoExecute, UndoUpdate);
  AddMenuItem('&Redo',Menus.ShortCut(Word('Z'), [ssCtrl,ssShift]),False,RedoExecute, RedoUpdate);
  AddMenuItem('-',0,False,nil,nil);
  AddMenuItem('Cu&t',Menus.ShortCut(Word('X'), [ssCtrl]),False,CutExecute, CutUpdate);
  AddMenuItem('&Copy',Menus.ShortCut(Word('C'), [ssCtrl]),False,CopyExecute, CopyUpdate);
  AddMenuItem('&Paste',Menus.ShortCut(Word('V'), [ssCtrl]),False,PasteExecute, PasteUpdate);
  AddMenuItem('De&lete',0,False,DeleteExecute, DeleteUpdate);
  AddMenuItem('-',0,False,nil,nil);
  AddMenuItem('Select &All',Menus.ShortCut(Word('A'), [ssCtrl]),False,SelectAllExecute, SelectAllUpdate);
end;


end.
