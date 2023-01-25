// **************************************************************************************************
//
// Unit WDCC.PropValueList
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
// The Original Code is WDCC.PropValueList.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.PropValueList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit;

type
  TFrmValueList = class(TForm)
    ValueList: TValueListEditor;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ValueListDblClick(Sender: TObject);
  private
    FWMIProperties: TStrings;
  public
    property WMIProperties: TStrings Read FWMIProperties Write FWMIProperties;
  end;

implementation

{$R *.dfm}

uses
  uWmi_Metadata,
  WDCC.WMI.PropertyValue;

procedure TFrmValueList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmValueList.ValueListDblClick(Sender: TObject);
Var
  Key: string;
  Index: Integer;
  CimType: Integer;
  Frm: TFrmWMIPropValue;
begin
  if FWMIProperties <> nil then
  begin
    Key := ValueList.Keys[ValueList.Row];
    Index := FWMIProperties.IndexOf(Key);
    CimType := Integer(FWMIProperties.Objects[Index]);
    Frm := TFrmWMIPropValue.Create(nil);
    Frm.Caption := Format('%s Type %s', [Key, CIMTypeStr(CimType)]);
    Frm.MemoValue.Text := ValueList.Values[Key];
    Frm.Show;
  end;
end;

end.
