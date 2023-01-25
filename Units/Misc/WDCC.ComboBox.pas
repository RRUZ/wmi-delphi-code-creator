// **************************************************************************************************
//
// Unit WDCC.ComboBox
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
// The Original Code is WDCC.ComboBox.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.ComboBox;

interface

uses
  Classes,
  StdCtrls;

type
  TComboBox = class(StdCtrls.TComboBox)
  private
    FItemWidth: integer;
    FDropDownFixedWidth: integer;
    procedure SetDropDownFixedWidth(const Value: integer);
    function GetTextWidth(const AValue: string): integer;
  protected
    procedure DropDown; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ItemWidth: integer Read FItemWidth Write FItemWidth;
  published
    property DropDownFixedWidth: integer Read FDropDownFixedWidth Write SetDropDownFixedWidth;
  end;

implementation

uses
  Forms,
  Messages,
  Windows;

{ TComboBox }

constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TComboBox.DropDown;
var
  LIndex: integer;
begin
  inherited DropDown;
  ItemWidth := 0;
  if (FDropDownFixedWidth > 0) then
    Self.Perform(CB_SETDROPPEDWIDTH, FDropDownFixedWidth, 0)
  else
  begin
    for LIndex := 0 to Items.Count - 1 do
      if (GetTextWidth(Items[LIndex]) > ItemWidth) then
        ItemWidth := GetTextWidth(Items[LIndex]) + 8;
    Self.Perform(CB_SETDROPPEDWIDTH, ItemWidth, 0);
  end;
end;

function TComboBox.GetTextWidth(const AValue: string): integer;
begin
  Result := TForm(Owner).Canvas.TextWidth(AValue);
end;

procedure TComboBox.SetDropDownFixedWidth(const Value: integer);
begin
  FDropDownFixedWidth := Value;
end;

end.
