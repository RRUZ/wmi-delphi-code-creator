// **************************************************************************************************
//
// Unit WDCC.StdActions.PopMenu
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
// The Original Code is WDCC.StdActions.PopMenu.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.StdActions.PopMenu;

interface

uses
  Classes,
  Vcl.ActnPopup,
  Vcl.Menus;

procedure FillPopupActionBar(PopupActionBar: TPopupActionBar);
procedure AssignStdActionsPopUpMenu(ParentComponent: TComponent; PopupMenu: TPopupMenu);

implementation

uses
  Vcl.StdCtrls,
  Vcl.ActnList,
  Vcl.StdActns;

type
  TCustomEditH = class(TCustomEdit);

procedure FillPopupActionBar(PopupActionBar: TPopupActionBar);
var
  MenuItem: TMenuItem;
  Action: TCustomAction;
begin
  MenuItem := TMenuItem.Create(PopupActionBar);
  Action := TEditCut.Create(PopupActionBar);
  Action.Caption := 'Cu&t';
  Action.Hint := 'Cut|Cuts the selection and puts it on the Clipboard';
  Action.ImageIndex := 0;
  Action.ShortCut := 16472;
  MenuItem.Action := Action;
  PopupActionBar.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(PopupActionBar);
  Action := TEditCopy.Create(PopupActionBar);
  Action.Caption := '&Copy';
  Action.Hint := 'Copy|Copies the selection and puts it on the Clipboard';
  Action.ImageIndex := 1;
  Action.ShortCut := 16451;
  MenuItem.Action := Action;
  PopupActionBar.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(PopupActionBar);
  Action := TEditPaste.Create(PopupActionBar);
  Action.Caption := '&Paste';
  Action.Hint := 'Paste|Inserts Clipboard contents';
  Action.ImageIndex := 2;
  Action.ShortCut := 16470;
  MenuItem.Action := Action;
  PopupActionBar.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(PopupActionBar);
  Action := TEditSelectAll.Create(PopupActionBar);
  Action.Caption := 'Select &All';
  Action.Hint := 'Select All|Selects the entire document';
  Action.ImageIndex := 3;
  Action.ShortCut := 16449;
  MenuItem.Action := Action;
  PopupActionBar.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(PopupActionBar);
  Action := TEditUndo.Create(PopupActionBar);
  Action.Caption := '&Undo';
  Action.Hint := 'Undo|Reverts the last action';
  Action.ImageIndex := 4;
  Action.ShortCut := 16474;
  MenuItem.Action := Action;
  PopupActionBar.Items.Add(MenuItem);

  MenuItem := TMenuItem.Create(PopupActionBar);
  Action := TEditDelete.Create(PopupActionBar);
  Action.Caption := '&Delete';
  Action.Hint := 'Delete|Erases the selection';
  Action.ImageIndex := 5;
  Action.ShortCut := 46;
  MenuItem.Action := Action;
  PopupActionBar.Items.Add(MenuItem);
end;

procedure AssignStdActionsPopUpMenu(ParentComponent: TComponent; PopupMenu: TPopupMenu);
var
  Lindex: integer;
begin
  for Lindex := 0 to ParentComponent.ComponentCount - 1 do
    if (ParentComponent.Components[Lindex] is TCustomEdit) and
      (TCustomEditH(ParentComponent.Components[Lindex]).PopupMenu = nil) then
      TCustomEditH(ParentComponent.Components[Lindex]).PopupMenu := PopupMenu
    else
      AssignStdActionsPopUpMenu(ParentComponent.Components[Lindex], PopupMenu);
end;

end.
