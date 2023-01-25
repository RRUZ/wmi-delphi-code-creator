// **************************************************************************************************
//
// Unit WDCC.Borland.Cpp.Versions
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
// The Original Code is WDCC.Borland.Cpp.Versions.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.Borland.Cpp.Versions;

interface

uses
  Graphics,
  SysUtils,
  Classes,
  ComCtrls;

{$DEFINE OLDEVERSIONS_SUPPORT}
type
  TBorlandCppVersions =
    (
    BorlandCpp5,
    BorlandCpp6,
    BorlandCppX,
    BorlandCpp2006,
    BorlandCpp2007,
    BorlandCpp2009,
    BorlandCpp2010,
    BorlandCppXE,
    BorlandCppXE2,
    BorlandCppXE3,
    BorlandCppXE4,
    BorlandCppXE5
    );

const
  BorlandCppVersionsNames: array[TBorlandCppVersions] of string = (
    'C++ Builder 5',
    'C++ Builder 6',
    'C++ Builder X',
    'BDS 2006',
    'RAD Studio 2007',
    'RAD Studio 2009',
    'RAD Studio 2010',
    'RAD Studio XE',
    'RAD Studio XE2',
    'RAD Studio XE3',
    'RAD Studio XE4',
    'RAD Studio XE5'
    );

  BorlandCppRegPaths: array[TBorlandCppVersions] of string = (
    '\Software\Borland\C++Builder\5.0',
    '\Software\Borland\C++Builder\6.0',
    '\Software\Borland\C++Builder\X',
    '\Software\Borland\BDS\4.0', //2006
    '\Software\Borland\BDS\5.0',
    '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0',
    '\Software\Embarcadero\BDS\8.0',
    '\Software\Embarcadero\BDS\9.0',
    '\Software\Embarcadero\BDS\10.0',
    '\Software\Embarcadero\BDS\11.0',
    '\Software\Embarcadero\BDS\12.0'
    );


procedure FillListViewBorlandCppVersions(ListView: TListView);

implementation

uses
  WDCC.Registry,
  Vcl.ImgList,
  Winapi.CommCtrl,
  Winapi.ShellAPI,
  Winapi.Windows,
  System.Win.Registry;

procedure ExtractIconFileToImageList(ImageList: TCustomImageList; const Filename: string);
var
  FileInfo: TShFileInfo;
begin
  if FileExists(Filename) then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    SHGetFileInfo(PChar(Filename), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON or SHGFI_SMALLICON);
    if FileInfo.hIcon <> 0 then
    begin
      ImageList_AddIcon(ImageList.Handle, FileInfo.hIcon);
      DestroyIcon(FileInfo.hIcon);
    end;
  end;
end;

procedure FillListViewBorlandCppVersions(ListView: TListView);
var
  BorlandCppComp: TBorlandCppVersions;
  Filename: string;
  Found: boolean;
  Item: TListItem;
begin
  for BorlandCppComp := Low(TBorlandCppVersions) to High(TBorlandCppVersions) do
  begin
    Found := RegKeyExists(BorlandCppRegPaths[BorlandCppComp], HKEY_CURRENT_USER);
    if Found then
      Found := RegReadStr(BorlandCppRegPaths[BorlandCppComp], 'App', Filename, HKEY_CURRENT_USER) and
        FileExists(Filename);

    if not Found then
    begin
      Found := RegKeyExists(BorlandCppRegPaths[BorlandCppComp], HKEY_LOCAL_MACHINE);
      if Found then
        Found := RegReadStr(BorlandCppRegPaths[BorlandCppComp], 'App', Filename, HKEY_LOCAL_MACHINE) and
          FileExists(Filename);
    end;

    if Found then
    begin
      ExtractIconFileToImageList(ListView.SmallImages, Filename);
      Item := ListView.Items.Add;
      Item.ImageIndex := ListView.SmallImages.Count - 1;
      Item.Caption := BorlandCppVersionsNames[BorlandCppComp];
      Item.SubItems.Add(Filename);
      Item.Data := Pointer(Ord(BorlandCppComp));
    end;
  end;
end;

end.
