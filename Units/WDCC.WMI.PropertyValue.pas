// **************************************************************************************************
//
// Unit WDCC.WMI.PropertyValue
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
// The Original Code is WDCC.WMI.PropertyValue.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.PropertyValue;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.Menus, Vcl.ActnPopup;

type
  TFrmWMIPropValue = class(TForm)
    MemoValue: TMemo;
    PopupActionBar1: TPopupActionBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  WDCC.StdActions.PopMenu;

{$R *.dfm}

procedure TFrmWMIPropValue.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmWMIPropValue.FormCreate(Sender: TObject);
begin
  FillPopupActionBar(PopupActionBar1);
  AssignStdActionsPopUpMenu(Self, PopupActionBar1);
end;

end.
