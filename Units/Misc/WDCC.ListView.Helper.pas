// **************************************************************************************************
//
// Unit WDCC.ListView.Helper
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
// The Original Code is WDCC.ListView.Helper.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.ListView.Helper;

interface

uses
  Winapi.CommCtrl,
  Vcl.ComCtrls;

const
  LVSCW_AUTOSIZE_BESTFIT = -3;

procedure AutoResizeColumn(const Column: TListColumn; const Mode: integer = LVSCW_AUTOSIZE_BESTFIT);
procedure AutoResizeColumns(const Columns: array of TListColumn; const Mode: integer = LVSCW_AUTOSIZE_BESTFIT);
procedure AutoResizeListView(const ListView: TListView; const Mode: integer = LVSCW_AUTOSIZE_BESTFIT);

implementation

uses
  System.Classes,
  Winapi.Windows;

procedure AutoResizeColumn(const Column: TListColumn; const Mode: integer = LVSCW_AUTOSIZE_BESTFIT);
var
  LWidth: integer;
begin
  case Mode of
    LVSCW_AUTOSIZE_BESTFIT:
      begin
        Column.Width := LVSCW_AUTOSIZE;
        LWidth := Column.Width;
        Column.Width := LVSCW_AUTOSIZE_USEHEADER;
        if LWidth > Column.Width then
          Column.Width := LVSCW_AUTOSIZE;
      end;

    LVSCW_AUTOSIZE:
      Column.Width := LVSCW_AUTOSIZE;
    LVSCW_AUTOSIZE_USEHEADER:
      Column.Width := LVSCW_AUTOSIZE_USEHEADER;
  end;
end;

procedure AutoResizeColumns(const Columns: array of TListColumn; const Mode: integer = LVSCW_AUTOSIZE_BESTFIT);
var
  LIndex: integer;
begin
  for LIndex := Low(Columns) to High(Columns) do
    AutoResizeColumn(Columns[LIndex], Mode);
end;

procedure AutoResizeListView(const ListView: TListView; const Mode: integer = LVSCW_AUTOSIZE_BESTFIT);
var
  LIndex: integer;
begin
  for LIndex := 0 to ListView.Columns.Count - 1 do
    AutoResizeColumn(ListView.Columns[LIndex], Mode);
end;

end.
