{**************************************************************************************************}
{                                                                                                  }
{ Unit uMisc                                                                                       }
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
{ The Original Code is uMisc.pas.                                                                  }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}


unit uMisc;

interface

uses
 Vcl.DBGrids,
 ComObj,
 SysUtils,
 Forms,
 Classes;

type
  TProcLog    = procedure (const  Log : string) of object;

procedure CaptureConsoleOutput(const lpCommandLine: string; OutPutList: TStrings);
procedure MsgWarning(const Msg: string);
procedure MsgInformation(const Msg: string);
function  MsgQuestion(const Msg: string):Boolean;
function  GetFileVersion(const FileName: string): string;
function  GetTempDirectory: string;
function  GetWindowsDirectory : string;
function  GetSpecialFolder(const CSIDL: integer) : string;
function  IsWow64: boolean;
function  CopyDir(const fromDir, toDir: string): boolean;
procedure SetGridColumnWidths(DbGrid: TDBGrid);

implementation

Uses
 ShlObj,
 ShellAPi,
 WinApi.Windows,
 Vcl.Controls,
 Vcl.Dialogs;

procedure SetGridColumnWidths(DbGrid: TDBGrid);
const
  BorderWidth = 10;
  MaxWidth=150;
var
  LWidth, LIndex: integer;
  LColumnsW: Array of integer;
begin
  with DbGrid do
  begin
    Canvas.Font := Font;
    SetLength(LColumnsW, Columns.Count);
    for LIndex := 0 to Columns.Count - 1 do
    begin
      LColumnsW[LIndex] := Canvas.TextWidth(Fields[LIndex].FieldName) + BorderWidth;
      if LColumnsW[LIndex]>MaxWidth then
      LColumnsW[LIndex]:=MaxWidth;
    end;

    DataSource.DataSet.First;
    while not DataSource.DataSet.Eof do
    begin
      for LIndex := 0 to Columns.Count - 1 do
      begin
        LWidth := Canvas.TextWidth(trim(Columns[LIndex]. Field.DisplayText)) + BorderWidth;
        //LWidth := Canvas.TextWidth(trim(TDBGridH(DbGrid).GetColField(Index).DisplayText)) + BorderWidth;
        if (LWidth > LColumnsW[LIndex]) and (LWidth<MaxWidth) then
          LColumnsW[LIndex] := LWidth;
      end;
      DataSource.DataSet.Next;
    end;
    DataSource.DataSet.First;
    for LIndex := 0 to Columns.Count - 1 do
      if LColumnsW[LIndex] > 0 then
        Columns[LIndex].Width := LColumnsW[LIndex];

    SetLength(LColumnsW, 0);
  end;
end;


function CopyDir(const fromDir, toDir: string): boolean;
var
  lpFileOp: TSHFileOpStruct;
begin
  ZeroMemory(@lpFileOp, SizeOf(lpFileOp));
  with lpFileOp do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_NOCONFIRMMKDIR or FOF_NOCONFIRMATION;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir);
  end;
  Result := (ShFileOperation(lpFileOp) = S_OK);
end;


function IsWow64: boolean;
type
  TIsWow64Process = function(Handle: WinApi.Windows.THandle;
      var Res: WinApi.Windows.BOOL): WinApi.Windows.BOOL; stdcall;
var
  IsWow64Result:  WinApi.Windows.BOOL;
  IsWow64Process: TIsWow64Process;
begin
  IsWow64Process := WinApi.Windows.GetProcAddress(WinApi.Windows.GetModuleHandle('kernel32.dll'),
    'IsWow64Process');
  if Assigned(IsWow64Process) then
  begin
    if not IsWow64Process(WinApi.Windows.GetCurrentProcess, IsWow64Result) then
      Result := False
    else
      Result := IsWow64Result;
  end
  else
    Result := False;
end;

function GetTempDirectory: string;
var
  lpBuffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @lpBuffer);
  Result := StrPas(lpBuffer);
end;

function GetWindowsDirectory : string;
var
  lpBuffer: array[0..MAX_PATH] of Char;
begin
  WinApi.Windows.GetWindowsDirectory(@lpBuffer, MAX_PATH);
  Result := StrPas(lpBuffer);
end;

function GetSpecialFolder(const CSIDL: integer) : string;
var
  lpszPath : PWideChar;
begin
  lpszPath := StrAlloc(MAX_PATH);
  try
     ZeroMemory(lpszPath, MAX_PATH);
    if SHGetSpecialFolderPath(0, lpszPath, CSIDL, False)  then
      Result := lpszPath
    else
      Result := '';
  finally
    StrDispose(lpszPath);
  end;
end;

function GetFileVersion(const FileName: string): string;
var
  FSO  : OleVariant;
begin
  FSO    := CreateOleObject('Scripting.FileSystemObject');
  Result := FSO.GetFileVersion(FileName);
end;

procedure MsgWarning(const Msg: string);
begin
  MessageDlg(Msg, mtWarning ,[mbOK], 0);
end;

procedure MsgInformation(const Msg: string);
begin
  MessageDlg(Msg,  mtInformation ,[mbOK], 0);
end;

function  MsgQuestion(const Msg: string):Boolean;
begin
  Result:= MessageDlg(Msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure CaptureConsoleOutput(const lpCommandLine: string; OutPutList: TStrings);
const
  ReadBuffer = 1024*1024;
var
  lpPipeAttributes      : TSecurityAttributes;
  ReadPipe              : THandle;
  WritePipe             : THandle;
  lpStartupInfo         : TStartUpInfo;
  lpProcessInformation  : TProcessInformation;
  Buffer                : PAnsiChar;
  TotalBytesRead        : DWORD;
  BytesRead             : DWORD;
  Apprunning            : integer;
  n                     : integer;
  BytesLeftThisMessage  : integer;
  TotalBytesAvail       : integer;
begin
  with lpPipeAttributes do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := True;
    lpsecuritydescriptor := nil;
  end;

  if not CreatePipe(ReadPipe, WritePipe, @lpPipeAttributes, 0) then
    exit;
  try
    Buffer := AllocMem(ReadBuffer + 1);
    try
      ZeroMemory(@lpStartupInfo, Sizeof(lpStartupInfo));
      lpStartupInfo.cb      := SizeOf(lpStartupInfo);
      lpStartupInfo.hStdOutput := WritePipe;
      lpStartupInfo.hStdInput := ReadPipe;
      lpStartupInfo.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
      lpStartupInfo.wShowWindow := SW_HIDE;

      OutPutList.Add(lpCommandLine);
      if CreateProcess(nil, PChar(lpCommandLine), @lpPipeAttributes,
        @lpPipeAttributes, True, CREATE_NO_WINDOW or NORMAL_PRIORITY_CLASS, nil,
        nil, lpStartupInfo, lpProcessInformation) then
      begin
        try
          n := 0;
          TotalBytesRead := 0;
          repeat
            Inc(n);
            Apprunning := WaitForSingleObject(lpProcessInformation.hProcess, 100);
            Application.ProcessMessages;
            if not PeekNamedPipe(ReadPipe, @Buffer[TotalBytesRead],
              ReadBuffer, @BytesRead, @TotalBytesAvail, @BytesLeftThisMessage) then
              break
            else
            if BytesRead > 0 then
              ReadFile(ReadPipe, Buffer[TotalBytesRead], BytesRead, BytesRead, nil);

            //Inc(TotalBytesRead, BytesRead);

            Buffer[BytesRead] := #0;
            OemToAnsi(Buffer, Buffer);
            OutPutList.Text := OutPutList.Text + String(Buffer);

          until (Apprunning <> WAIT_TIMEOUT) or (n > 150);

            {
          Buffer[TotalBytesRead] := #0;
          OemToAnsi(Buffer, Buffer);
          OutPutList.Text := OutPutList.Text + String(Buffer);
            }
        finally
          CloseHandle(lpProcessInformation.hProcess);
          CloseHandle(lpProcessInformation.hThread);
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  finally
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  end;
end;

end.