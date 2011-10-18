{**************************************************************************************************}
{                                                                                                  }
{ Unit uBorlandCppVersions                                                                         }
{ unit retrieves the Borland/Embaradero cpp ide installed versions for the WMI Delphi Code Creator }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uBorlandCppVersions.pas.                                                    }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uBorlandCppVersions;

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
  {$IFDEF OLDEVERSIONS_SUPPORT}
    BorlandCpp5,
  {$ENDIF}
    BorlandCpp6,
    BorlandCppX,
    BorlandCpp2006,
    BorlandCpp2007,
    BorlandCpp2009,
    BorlandCpp2010,
    BorlandCppXE,
    BorlandCppXE2
    );


const
  {$IFDEF OLDEVERSIONS_SUPPORT}
  BorlandCppOldVersions = 1;
  BorlandCppOldVersionNumbers: array[0..BorlandCppOldVersions-1] of TBorlandCppVersions =(BorlandCpp5);

  BorlandCppOldColorsCount =16;


  BorlandCppOldColorsList: array[0..BorlandCppOldColorsCount-1] of TColor =
  (
    $000000,$000080,$008000,$008080,
    $800000,$800080,$808000,$C0C0C0,
    $808080,$0000FF,$00FF00,$00FFFF,
    $FF0000,$FF00FF,$FFFF00,$FFFFFF
  )
  ;
  {$ENDIF}

  BorlandCppVersionsNames: array[TBorlandCppVersions] of string = (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    'C++ Builder 5',
  {$ENDIF}
    'C++ Builder 6',
    'C++ Builder X',
    'BDS 2006',
    'RAD Studio 2007',
    'RAD Studio 2009',
    'RAD Studio 2010',
    'RAD Studio XE',
    'RAD Studio XE2'
    );

  BorlandCppVersionNumbers: array[TBorlandCppVersions] of double =
    (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    5,
  {$ENDIF}
    6,
    7,
    10,
    11,
    12,
    14,
    15,
    16
    );



  BorlandCppRegPaths: array[TBorlandCppVersions] of string = (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    '\Software\Borland\C++Builder\5.0',
  {$ENDIF}
    '\Software\Borland\C++Builder\6.0',
    '\Software\Borland\C++Builder\X',
    '\Software\Borland\BDS\4.0', //2006
    '\Software\Borland\BDS\5.0',
    '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0',
    '\Software\Embarcadero\BDS\8.0',
    '\Software\Embarcadero\BDS\9.0'
    );


procedure FillListViewBorlandCppVersions(ListView: TListView);
function IsBorlandCppIDERunning(const BorlandCppIDEPath: TFileName): boolean;
{$IFDEF OLDEVERSIONS_SUPPORT}
function BorlandCppIsOldVersion(DelphiVersion:TBorlandCppVersions) : Boolean;
function GetIndexClosestColor(AColor:TColor) : Integer;
{$ENDIF}

function GetBorlandCppVersionMappedColor(AColor:TColor;BorlandCppVersion:TBorlandCppVersions) : TColor;


implementation

uses
  PsAPI,
  tlhelp32,
  Controls,
  ImgList,
  CommCtrl,
  ShellAPI,
  Windows,
  uRegistry,
  Registry;

{$IFDEF OLDEVERSIONS_SUPPORT}
function BorlandCppIsOldVersion(DelphiVersion:TBorlandCppVersions) : Boolean;
var
 i  : integer;
begin
 Result:=False;
  for i:=0  to BorlandCppOldVersions-1 do
    if DelphiVersion=BorlandCppOldVersionNumbers[i] then
    begin
       Result:=True;
       exit;
    end;
end;

function GetIndexClosestColor(AColor:TColor) : Integer;
var
  SqrDist,SmallSqrDist  : Double;
  i,R1,G1,B1,R2,G2,B2   : Integer;
begin
  Result:=0;
  SmallSqrDist := Sqrt(SQR(255)*3);
  R1 := GetRValue(AColor);
  G1 := GetGValue(AColor);
  B1 := GetBValue(AColor);

    for i := 0 to BorlandCppOldColorsCount-1 do
    begin
      R2 := GetRValue(BorlandCppOldColorsList[i]);
      G2 := GetGValue(BorlandCppOldColorsList[i]);
      B2 := GetBValue(BorlandCppOldColorsList[i]);
      SqrDist := Sqrt(SQR(R1 - R2) + SQR(G1 - G2) + SQR(B1 - B2));
      if SqrDist < SmallSqrDist then
      begin
       Result := i;
       SmallSqrDist := SqrDist;
      end
    end
end;

{$ENDIF}


function GetBorlandCppVersionMappedColor(AColor:TColor;BorlandCppVersion:TBorlandCppVersions) : TColor;
begin
 Result:=AColor;
{$IFDEF OLDEVERSIONS_SUPPORT}
  if BorlandCppIsOldVersion(BorlandCppVersion) then
  Result:= BorlandCppOldColorsList[GetIndexClosestColor(AColor)];
{$ENDIF}
end;


function ProcessFileName(PID: DWORD): string;
var
  Handle: THandle;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then
    try
      SetLength(Result, MAX_PATH);
      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
        SetLength(Result, StrLen(PChar(Result)))
      else
        Result := '';
    finally
      CloseHandle(Handle);
    end;
end;

function IsBorlandCppIDERunning(const BorlandCppIDEPath: TFileName): boolean;
var
  HandleSnapShot : Cardinal;
  EntryParentProc: TProcessEntry32;
begin
  Result := False;
  HandleSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HandleSnapShot = INVALID_HANDLE_VALUE then
    exit;
  try
    EntryParentProc.dwSize := SizeOf(EntryParentProc);
    if Process32First(HandleSnapShot, EntryParentProc) then
      repeat
        if CompareText(ExtractFileName(BorlandCppIDEPath), EntryParentProc.szExeFile) = 0 then
          if CompareText(ProcessFileName(EntryParentProc.th32ProcessID),  BorlandCppIDEPath) = 0 then
          begin
            Result := True;
            break;
          end;
      until not Process32Next(HandleSnapShot, EntryParentProc);
  finally
    CloseHandle(HandleSnapShot);
  end;
end;

procedure ExtractIconFileToImageList(ImageList: TCustomImageList; const Filename: string);
var
  FileInfo: TShFileInfo;
begin
  if FileExists(Filename) then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    SHGetFileInfo(PChar(Filename), 0, FileInfo, SizeOf(FileInfo),
      SHGFI_ICON or SHGFI_SMALLICON);
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
  FileName: string;
  Found: boolean;
  Item: TListItem;
begin
  for BorlandCppComp := Low(TBorlandCppVersions) to High(TBorlandCppVersions) do
  begin
    Found := RegKeyExists(BorlandCppRegPaths[BorlandCppComp], HKEY_CURRENT_USER);
    if Found then
      Found := RegReadStr(BorlandCppRegPaths[BorlandCppComp], 'App', FileName,
        HKEY_CURRENT_USER) and
        FileExists(FileName);

    if not Found then
    begin
      Found := RegKeyExists(BorlandCppRegPaths[BorlandCppComp], HKEY_LOCAL_MACHINE);
      if Found then
        Found := RegReadStr(BorlandCppRegPaths[BorlandCppComp], 'App', FileName,
          HKEY_LOCAL_MACHINE) and FileExists(FileName);
    end;

    if Found then
    begin
      ExtractIconFileToImageList(ListView.SmallImages, Filename);
      Item := ListView.Items.Add;
      Item.ImageIndex := ListView.SmallImages.Count - 1;
      Item.Caption := BorlandCppVersionsNames[BorlandCppComp];
      item.SubItems.Add(FileName);
      Item.Data := Pointer(Ord(BorlandCppComp));
    end;
  end;
end;


end.
