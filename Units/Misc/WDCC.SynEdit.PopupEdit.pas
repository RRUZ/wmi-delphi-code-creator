// **************************************************************************************************
//
// Unit WDCC.SynEdit.PopupEdit
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
// The Original Code is WDCC.SynEdit.PopupEdit.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.SynEdit.PopupEdit;

interface

uses
  Vcl.ActnList,
  Vcl.ActnPopup,
  Menus,
  Classes,
  SynEdit;

type
  TSynEdit = class(SynEdit.TSynEdit)
  private
    FActnList: TActionList;
    FPopupMenu: TPopupActionBar;
    procedure CreateActns;
    procedure FillPopupMenu(APopupMenu: TPopupMenu);
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
    procedure SetPopupMenu_(const Value: TPopupMenu);
    function GetPopupMenu_: TPopupMenu;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PopupMenu: TPopupMenu read GetPopupMenu_ write SetPopupMenu_;
  end;

implementation

uses
  System.Actions,
  SysUtils;

const
  MenuName = 'uSynEditPopupMenu';

procedure TSynEdit.CopyExecute(Sender: TObject);
begin
  Self.CopyToClipboard;
end;

procedure TSynEdit.CopyUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.SelAvail;
end;

procedure TSynEdit.CutExecute(Sender: TObject);
begin
  Self.CutToClipboard;
end;

procedure TSynEdit.CutUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.SelAvail and not Self.ReadOnly;
end;

procedure TSynEdit.DeleteExecute(Sender: TObject);
begin
  Self.SelText := '';
end;

procedure TSynEdit.DeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.SelAvail and not Self.ReadOnly;
end;

procedure TSynEdit.PasteExecute(Sender: TObject);
begin
  Self.PasteFromClipboard;
end;

procedure TSynEdit.PasteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.CanPaste;
end;

procedure TSynEdit.RedoExecute(Sender: TObject);
begin
  Self.Redo;
end;

procedure TSynEdit.RedoUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.CanRedo;
end;

procedure TSynEdit.SelectAllExecute(Sender: TObject);
begin
  Self.SelectAll;
end;

procedure TSynEdit.SelectAllUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.Lines.Text <> '';
end;

procedure TSynEdit.UndoExecute(Sender: TObject);
begin
  Self.Undo;
end;

procedure TSynEdit.UndoUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := Self.CanUndo;
end;

constructor TSynEdit.Create(AOwner: TComponent);
begin
  inherited;
  FActnList := TActionList.Create(Self);
  FPopupMenu := TPopupActionBar.Create(Self);
  FPopupMenu.Name := MenuName;
  CreateActns;
  FillPopupMenu(FPopupMenu);
  PopupMenu := FPopupMenu;
end;

procedure TSynEdit.CreateActns;

  procedure AddActItem(const AText: string; AShortCut: TShortCut; AEnabled: Boolean; OnExecute, OnUpdate: TNotifyEvent);
  Var
    ActionItem: TAction;
  begin
    ActionItem := TAction.Create(FActnList);
    ActionItem.ActionList := FActnList;
    ActionItem.Caption := AText;
    ActionItem.ShortCut := AShortCut;
    ActionItem.Enabled := AEnabled;
    ActionItem.OnExecute := OnExecute;
    ActionItem.OnUpdate := OnUpdate;
  end;

begin
  AddActItem('&Undo', Menus.ShortCut(Word('Z'), [ssCtrl]), False, UndoExecute, UndoUpdate);
  AddActItem('&Redo', Menus.ShortCut(Word('Z'), [ssCtrl, ssShift]), False, RedoExecute, RedoUpdate);
  AddActItem('-', 0, False, nil, nil);
  AddActItem('Cu&t', Menus.ShortCut(Word('X'), [ssCtrl]), False, CutExecute, CutUpdate);
  AddActItem('&Copy', Menus.ShortCut(Word('C'), [ssCtrl]), False, CopyExecute, CopyUpdate);
  AddActItem('&Paste', Menus.ShortCut(Word('V'), [ssCtrl]), False, PasteExecute, PasteUpdate);
  AddActItem('De&lete', 0, False, DeleteExecute, DeleteUpdate);
  AddActItem('-', 0, False, nil, nil);
  AddActItem('Select &All', Menus.ShortCut(Word('A'), [ssCtrl]), False, SelectAllExecute, SelectAllUpdate);
end;

procedure TSynEdit.SetPopupMenu_(const Value: TPopupMenu);
Var
  MenuItem: TMenuItem;
begin
  SynEdit.TSynEdit(Self).PopupMenu := Value;
  if CompareText(MenuName, Value.Name) <> 0 then
  begin
    MenuItem := TMenuItem.Create(Value);
    MenuItem.Caption := '-';
    Value.Items.Add(MenuItem);
    FillPopupMenu(Value);
  end;
end;

function TSynEdit.GetPopupMenu_: TPopupMenu;
begin
  Result := SynEdit.TSynEdit(Self).PopupMenu;
end;

destructor TSynEdit.Destroy;
begin
  FPopupMenu.Free;
  FActnList.Free;
  inherited;
end;

procedure TSynEdit.FillPopupMenu(APopupMenu: TPopupMenu);
var
  LIndex: integer;
  MenuItem: TMenuItem;
begin
  if Assigned(FActnList) then
    for LIndex := 0 to FActnList.ActionCount - 1 do
    begin
      MenuItem := TMenuItem.Create(APopupMenu);
      MenuItem.Action := FActnList.Actions[LIndex];
      APopupMenu.Items.Add(MenuItem);
    end;
end;

end.
