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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2013 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}


unit uMisc;

interface

uses
 Vcl.DBGrids,
 System.Win.ComObj,
 System.SysUtils,
 Vcl.Forms,
 System.Classes;

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
function  Ping(const Address:string;Retries,BufferSize:Word;Log : TStrings) : Boolean;
procedure SetOwnerDrawMethods(Form: TForm);


implementation

Uses
 Vcl.ComCtrls,
 Vcl.StdCtrls,
 Vcl.Themes,
 Vcl.Styles.OwnerDrawFix,
 Winapi.ActiveX,
 System.UITypes,
 System.Variants,
 Winapi.ShlObj,
 Winapi.ShellAPi,
 WinApi.Windows,
 Vcl.Controls,
 Vcl.Dialogs;


procedure SetOwnerDrawMethods(Form: TForm);
var
  i : integer;
begin
 for i :=0 to Form.ComponentCount-1 do
  if Form.Components[i] is TComboBox then
  begin
    TComboBox(Form.Components[i]).Style:=csDropDownList;
    TComboBox(Form.Components[i]).OnDrawItem:=nil;
  end
  else
  if Form.Components[i] is TListView then
  begin
    TListView(Form.Components[i]).OwnerDraw:=false;
    TListView(Form.Components[i]).OnDrawItem:=nil;
    TListView(Form.Components[i]).OnMouseDown:=nil;
  end;

 if not TStyleManager.ActiveStyle.IsSystemStyle then
 for i :=0 to Form.ComponentCount-1 do
  if Form.Components[i] is TComboBox then
  begin
    TComboBox(Form.Components[i]).Style:=csOwnerDrawFixed;
    TComboBox(Form.Components[i]).OnDrawItem:=VclStylesOwnerDrawFix.ComboBoxDrawItem;
  end
  else
  if Form.Components[i] is TListView then
  begin
    TListView(Form.Components[i]).OwnerDraw:=true;
    TListView(Form.Components[i]).OnDrawItem:=VclStylesOwnerDrawFix.ListViewDrawItem;
    TListView(Form.Components[i]).OnMouseDown:=VclStylesOwnerDrawFix.ListViewMouseDown;
  end;

end;

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

function GetStatusCodeStr(statusCode:integer) : string;
begin
  case statusCode of
    0     : Result:='Success';
    11001 : Result:='Buffer Too Small';
    11002 : Result:='Destination Net Unreachable';
    11003 : Result:='Destination Host Unreachable';
    11004 : Result:='Destination Protocol Unreachable';
    11005 : Result:='Destination Port Unreachable';
    11006 : Result:='No Resources';
    11007 : Result:='Bad Option';
    11008 : Result:='Hardware Error';
    11009 : Result:='Packet Too Big';
    11010 : Result:='Request Timed Out';
    11011 : Result:='Bad Request';
    11012 : Result:='Bad Route';
    11013 : Result:='TimeToLive Expired Transit';
    11014 : Result:='TimeToLive Expired Reassembly';
    11015 : Result:='Parameter Problem';
    11016 : Result:='Source Quench';
    11017 : Result:='Option Too Big';
    11018 : Result:='Bad Destination';
    11032 : Result:='Negotiating IPSEC';
    11050 : Result:='General Failure'
    else
    result:='Unknow';
  end;
end;

function  Ping(const Address:string;Retries,BufferSize:Word;Log : TStrings) : Boolean;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  i             : Integer;

  PacketsReceived : Integer;
  Minimum         : Integer;
  Maximum         : Integer;
  Average         : Integer;
begin;
  Result:=False;
  PacketsReceived:=0;
  Minimum        :=0;
  Maximum        :=0;
  Average        :=0;
  Log.Add('');
  Log.Add(Format('Pinging %s with %d bytes of data:',[Address,BufferSize]));
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  //FWMIService   := FSWbemLocator.ConnectServer('192.168.52.130', 'root\CIMV2', 'user', 'password');
  for i := 0 to Retries-1 do
  begin
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',[QuotedStr(Address),BufferSize]),'WQL',0);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if FWbemObject.StatusCode=0 then
      begin
        if FWbemObject.ResponseTime>0 then
          Log.Add(Format('Reply from %s: bytes=%s time=%sms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.ResponseTime,FWbemObject.TimeToLive]))
        else
          Log.Add(Format('Reply from %s: bytes=%s time=<1ms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.TimeToLive]));

        Inc(PacketsReceived);

        if FWbemObject.ResponseTime>Maximum then
        Maximum:=FWbemObject.ResponseTime;

        if Minimum=0 then
        Minimum:=Maximum;

        if FWbemObject.ResponseTime<Minimum then
        Minimum:=FWbemObject.ResponseTime;

        Average:=Average+FWbemObject.ResponseTime;
      end
      else
      if not VarIsNull(FWbemObject.StatusCode) then
        Log.Add(Format('Reply from %s: %s',[FWbemObject.ProtocolAddress,GetStatusCodeStr(FWbemObject.StatusCode)]))
      else
        Log.Add(Format('Reply from %s: %s',[Address,'Error processing request']));
    end;
    FWbemObject:=Unassigned;
    FWbemObjectSet:=Unassigned;
    //Sleep(500);
  end;

  Log.Add('');
  Log.Add(Format('Ping statistics for %s:',[Address]));
  Log.Add(Format('    Packets: Sent = %d, Received = %d, Lost = %d (%d%% loss),',[Retries,PacketsReceived,Retries-PacketsReceived,Round((Retries-PacketsReceived)*100/Retries)]));
  if PacketsReceived>0 then
  begin
   Log.Add('Approximate round trip times in milli-seconds:');
   Log.Add(Format('    Minimum = %dms, Maximum = %dms, Average = %dms',[Minimum,Maximum,Round(Average/PacketsReceived)]));
   Result:=(Retries=PacketsReceived);
  end;
end;
end.
