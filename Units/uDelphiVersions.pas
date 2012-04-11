{**************************************************************************************************}
{                                                                                                  }
{ Unit uDelphiVersions                                                                             }
{ unit retrieves the delphi ide installed versions  for the Delphi IDE Theme Editor                }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uDelphiVersions.pas.                                                        }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uDelphiVersions;

interface

uses
  Graphics,
  SysUtils,
  Classes,
  ComCtrls;

{$DEFINE OLDEVERSIONS_SUPPORT}

type
  TDelphiVersions =
    (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    Delphi5,
    Delphi6,
  {$ENDIF}
    Delphi7,
    Delphi8,
    Delphi2005,
    Delphi2006,
    Delphi2007,
    Delphi2009,
    Delphi2010,
    DelphiXE,
    DelphiXE2
    );


const
  {$IFDEF OLDEVERSIONS_SUPPORT}
  DelphiOldVersions = 2;
  DelphiOldVersionNumbers: array[0..DelphiOldVersions-1] of TDelphiVersions =(Delphi5,Delphi6);

  DelphiOldColorsCount =16;


  DelphiOldColorsList: array[0..DelphiOldColorsCount-1] of TColor =
  (
    $000000,$000080,$008000,$008080,
    $800000,$800080,$808000,$C0C0C0,
    $808080,$0000FF,$00FF00,$00FFFF,
    $FF0000,$FF00FF,$FFFF00,$FFFFFF
  )
  ;
  {$ENDIF}

  DelphiVersionsNames: array[TDelphiVersions] of string = (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    'Delphi 5',
    'Delphi 6',
  {$ENDIF}
    'Delphi 7',
    'Delphi 8',
    'BDS 2005',
    'BDS 2006',
    'RAD Studio 2007',
    'RAD Studio 2009',
    'RAD Studio 2010',
    'RAD Studio XE',
    'RAD Studio XE2'
    );

  DelphiVersionNumbers: array[TDelphiVersions] of double =
    (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    13,      // 'Delphi 5',
    14,      // 'Delphi 6',
  {$ENDIF}
    15,      // 'Delphi 7',
    16,      // 'Delphi 8',
    17,      // 'BDS 2005',
    18,      // 'BDS 2006',
    18.5,    // 'RAD Studio 2007',
    20,      // 'RAD Studio 2009',
    21,      // 'RAD Studio 2010',
    22,      // 'RAD Studio XE'
    23       // 'RAD Studio XE2'
    );



  DelphiRegPaths: array[TDelphiVersions] of string = (
  {$IFDEF OLDEVERSIONS_SUPPORT}
    '\Software\Borland\Delphi\5.0',
    '\Software\Borland\Delphi\6.0',
  {$ENDIF}
    '\Software\Borland\Delphi\7.0',
    '\Software\Borland\BDS\2.0',
    '\Software\Borland\BDS\3.0', //2005
    '\Software\Borland\BDS\4.0',
    '\Software\Borland\BDS\5.0',
    '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0',
    '\Software\Embarcadero\BDS\8.0',
    '\Software\Embarcadero\BDS\9.0'
    );


procedure FillListViewDelphiVersions(ListView: TListView);
function IsDelphiIDERunning(const DelphiIDEPath: TFileName): boolean;
{$IFDEF OLDEVERSIONS_SUPPORT}
function DelphiIsOldVersion(DelphiVersion:TDelphiVersions) : Boolean;
function GetIndexClosestColor(AColor:TColor) : Integer;
{$ENDIF}

function GetDelphiVersionMappedColor(AColor:TColor;DelphiVersion:TDelphiVersions) : TColor;
function GetDelphiInstallPath(DelphiComp: TDelphiVersions):string;

{

[HKEY_CURRENT_USER\Software\Embarcadero\BDS\8.0\Editor\Highlight\Attribute Names]
"Bold"="False"
"Italic"="False"
"Underline"="False"
"Default Foreground"="False"
"Default Background"="False"
"Foreground Color New"="$00DE4841"
"Background Color New"="$00272727"
}



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
function DelphiIsOldVersion(DelphiVersion:TDelphiVersions) : Boolean;
var
 LIndex  : integer;
begin
 Result:=False;
  for LIndex:=0  to DelphiOldVersions-1 do
    if DelphiVersion=DelphiOldVersionNumbers[LIndex] then
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

    for i := 0 to DelphiOldColorsCount-1 do
    begin
      R2 := GetRValue(DelphiOldColorsList[i]);
      G2 := GetGValue(DelphiOldColorsList[i]);
      B2 := GetBValue(DelphiOldColorsList[i]);
      SqrDist := Sqrt(SQR(R1 - R2) + SQR(G1 - G2) + SQR(B1 - B2));
      if SqrDist < SmallSqrDist then
      begin
       Result := i;
       SmallSqrDist := SqrDist;
      end
    end
end;

{$ENDIF}


function GetDelphiVersionMappedColor(AColor:TColor;DelphiVersion:TDelphiVersions) : TColor;
begin
 Result:=AColor;
{$IFDEF OLDEVERSIONS_SUPPORT}
  if DelphiIsOldVersion(DelphiVersion) then
  Result:= DelphiOldColorsList[GetIndexClosestColor(AColor)];
{$ENDIF}
end;


function ProcessFileName(PID: DWORD): string;
var
  hProcess: THandle;
begin
  Result := '';
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if hProcess <> 0 then
    try
      SetLength(Result, MAX_PATH);
      if GetModuleFileNameEx(hProcess, 0, PChar(Result), MAX_PATH) > 0 then
        SetLength(Result, StrLen(PChar(Result)))
      else
        Result := '';
    finally
      CloseHandle(hProcess);
    end;
end;

function IsDelphiIDERunning(const DelphiIDEPath: TFileName): boolean;
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
        if CompareText(ExtractFileName(DelphiIDEPath), EntryParentProc.szExeFile) = 0 then
          if CompareText(ProcessFileName(EntryParentProc.th32ProcessID),  DelphiIDEPath) = 0 then
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

procedure FillListViewDelphiVersions(ListView: TListView);
var
  DelphiComp: TDelphiVersions;
  FileName: string;
  Found: boolean;
  Item: TListItem;
begin
  for DelphiComp := Low(TDelphiVersions) to High(TDelphiVersions) do
  begin
    Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_CURRENT_USER);
    if Found then
      Found := RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName,
        HKEY_CURRENT_USER) and
        FileExists(FileName);

    if not Found then
    begin
      Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_LOCAL_MACHINE);
      if Found then
        Found := RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName,
          HKEY_LOCAL_MACHINE) and FileExists(FileName);
    end;

    if Found then
    begin
      ExtractIconFileToImageList(ListView.SmallImages, Filename);
      Item := ListView.Items.Add;
      Item.ImageIndex := ListView.SmallImages.Count - 1;
      Item.Caption := DelphiVersionsNames[DelphiComp];
      item.SubItems.Add(FileName);
      Item.Data := Pointer(Ord(DelphiComp));
    end;
  end;
end;

function GetDelphiInstallPath(DelphiComp: TDelphiVersions):string;
var
  FileName: string;
  Found: boolean;
begin
  Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_CURRENT_USER);
  if Found then
    Found := RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName,
      HKEY_CURRENT_USER) and
      FileExists(FileName);

  if not Found then
  begin
    Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_LOCAL_MACHINE);
    if Found then
       RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName,
        HKEY_LOCAL_MACHINE);
  end;

  Result:=ExtractFilePath(FileName);
end;

end.
