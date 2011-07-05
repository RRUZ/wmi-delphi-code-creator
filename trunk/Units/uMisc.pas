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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}


unit uMisc;

interface

uses
 ComObj,
 SysUtils,
 Forms,
 Windows,
 Classes;

procedure CaptureConsoleOutput(const lpCommandLine: string; OutPutList: TStrings);
procedure MsgWarning(const Msg: string);
procedure MsgInformation(const Msg: string);
function  MsgQuestion(const Msg: string):Boolean;
function  GetFileVersion(const FileName: string): string;
function  GetTempDirectory: string;

implementation

function GetTempDirectory: string;
var
  lpBuffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, @lpBuffer);
  Result := StrPas(lpBuffer);
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
  Application.MessageBox(PChar(Msg), 'Warning', MB_OK + MB_ICONWARNING);
end;

procedure MsgInformation(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), 'Information', MB_OK + MB_ICONINFORMATION);
end;

function  MsgQuestion(const Msg: string):Boolean;
begin
  Result:= Application.MessageBox(PChar(Msg), 'Information', MB_YESNO + MB_ICONINFORMATION)=IDYES;
end;


procedure CaptureConsoleOutput(const lpCommandLine: string; OutPutList: TStrings);
const
  ReadBuffer = 1048576;
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
            Inc(TotalBytesRead, BytesRead);
          until (Apprunning <> WAIT_TIMEOUT) or (n > 150);

          Buffer[TotalBytesRead] := #0;
          //OemToCharA(Buffer, Buffer);
          OemToAnsi(Buffer, Buffer);
          OutPutList.Text := OutPutList.Text + AnsiString(Buffer);
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
