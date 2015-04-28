//**************************************************************************************************
//
// Unit uVisualStudio
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
// The Original Code is uVisualStudio.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2015 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************


unit uVisualStudio;

interface


uses
 Classes;

function IsVS2008Installed: boolean;
function GetVS2008IDEFileName: string;
function GetVS2008CompilerFileName: string;

function IsVS2010Installed: boolean;
function GetVS2010IDEFileName: string;
function GetVS2010CompilerFileName: string;

function IsVS11Installed: boolean;
function GetVS11IDEFileName: string;
function GetVS11CompilerFileName: string;

function CreateVsProject(const FileName, Path, ProjectTemplate: string;
  var NewFileName: string): boolean;

procedure CompileAndRunVsCode(Console:TStrings;const CompilerName, ProjectFile: string;  Run: boolean);
procedure CompileAndRunMicrosoftCppCode(Console:TStrings;const CompilerName, ProjectFile, SwitchOpts: string;  Run: boolean);

function GetMicrosoftCppCompiler2008 : string;
function GetMicrosoftCppCompiler2010 : string;
function GetMicrosoftCppCompiler11   : string;

implementation



uses
  ShellAPi,
  SysUtils,
  Windows,
  uRegistry,
  IOUtils,
  uMisc;


const
  VS11x64RegEntry        = '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\11.0\Setup\VS';
  VS11x86RegEntry        = '\SOFTWARE\Microsoft\VisualStudio\11.0\Setup\VS';
  VS2010x64RegEntry      = '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\10.0\Setup\VS';
  VS2010x86RegEntry      = '\SOFTWARE\Microsoft\VisualStudio\10.0\Setup\VS';
  VS2008x64RegEntry      = '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\9.0\Setup\VS';
  VS2008x86RegEntry      = '\SOFTWARE\Microsoft\VisualStudio\9.0\Setup\VS';

function CreateVsProject(const FileName, Path, ProjectTemplate: string;
  var NewFileName: string): boolean;
var
  PathTemplate: string;
  DestFolder:   string;
begin
  NewFileName  := '';
  PathTemplate := ExtractFilePath(ProjectTemplate);
  DestFolder   := IncludeTrailingPathDelimiter(Path) + FormatDateTime('YYYYMMDDHHNNSS', Now);
  ForceDirectories(DestFolder);
  Result := CopyDir(IncludeTrailingPathDelimiter(PathTemplate) + '*.*', DestFolder);
  if Result then
  begin
    NewFileName := IncludeTrailingPathDelimiter(DestFolder) + FileName;
    Result      := CopyFile(PChar(IncludeTrailingPathDelimiter(Path) + FileName),
      PChar(NewFileName), False);
    NewFileName := ExtractFilePath(NewFileName) + 'GetWMI_Info.sln';
  end;
end;

procedure CompileAndRunVsCode(Console:TStrings;const CompilerName, ProjectFile: string;
  Run: boolean);
var
  ExeFile: string;
begin
  Console.Add('');
  CaptureConsoleOutput(Format('"%s" "%s" /rebuild release', [CompilerName,ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ExtractFilePath(ProjectFile) + 'release\' + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');
    if not FileExists(ExeFile) then
     ExeFile := ExtractFilePath(ProjectFile) + 'bin\release\' + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');

    if FileExists(ExeFile) then
     ShellExecute(0, nil, PChar(Format('"%s"',[ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
  end;
end;

procedure CompileAndRunMicrosoftCppCode(Console:TStrings;const CompilerName, ProjectFile, SwitchOpts: string;  Run: boolean);
var
  ExeFile : string;
  CmdLine : string;
  vcvars32: string;

  Bat     : TStringList;
  BatFile : string;
  CmdBuffer: array [0..MAX_PATH] of Char;
begin
  Bat:=TStringList.Create;
  try
    Console.Add('');
    vcvars32:=ExtractFilePath(CompilerName)+'vcvars32.bat';
    Bat.Add('CALL '+TFile.ReadAllText(vcvars32));

    {/EHsc /Fe"[OutPutPath][FileName].exe" /Fo"[OutPutPath][FileName].obj" "[OutPutPath][FileName].cpp"}
    CmdLine:=Format('"%s" %s', [CompilerName, SwitchOpts]);
    CmdLine:=StringReplace(CmdLine,'[OutPutPath]',ExtractFilePath(ProjectFile),[rfReplaceAll]);
    CmdLine:=StringReplace(CmdLine,'[FileName]',ChangeFileExt(ExtractFileName(ProjectFile),''),[rfReplaceAll]);
    Bat.Add(CmdLine);
    BatFile:=ChangeFileExt(ProjectFile,'.bat');
    Bat.SaveToFile(BatFile);

    GetEnvironmentVariable('COMSPEC', CmdBuffer, MAX_PATH+1);
    CmdLine:=Format('%s /C "%s"',[CmdBuffer, BatFile]);
    CaptureConsoleOutput(CmdLine, Console);
    if Run then
    begin
      ExeFile := ExtractFilePath(ProjectFile) + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');
      if FileExists(ExeFile) then
        ShellExecute(0, nil, PChar(Format('"%s"',[ExeFile])), nil, nil, SW_SHOWNORMAL)
      else
        MsgWarning(Format('Could not find %s', [ExeFile]));
    end;
  finally
    Bat.Free;
  end;
end;


function GetMicrosoftCppCompiler2008 : string;
begin
 Result:=ExpandFileName(ExtractFilePath(GetVS2008IDEFileName)+'\..\..')+'\VC\bin\cl.exe';
end;

function GetMicrosoftCppCompiler2010 : string;
begin
 Result:=ExpandFileName(ExtractFilePath(GetVS2010IDEFileName)+'\..\..')+'\VC\bin\cl.exe';
end;

function GetMicrosoftCppCompiler11   : string;
begin
 Result:=ExpandFileName(ExtractFilePath(GetVS11IDEFileName)+'\..\..')+'\VC\bin\cl.exe';
end;

function IsVS2008Installed: boolean;
var
  Value: string;
begin
  Result := False;
  if IsWow64 then
  begin
    if RegKeyExists(VS2008x64RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(VS2008x64RegEntry, 'EnvironmentPath', Value, HKEY_LOCAL_MACHINE);
      Result := FileExists(Value);
    end;
  end
  else
  begin
    if RegKeyExists(VS2008x86RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(VS2008x86RegEntry, 'EnvironmentPath', Value, HKEY_LOCAL_MACHINE);
      Result := FileExists(Value);
    end;
  end;
end;

function IsVS2010Installed: boolean;
var
  Value: string;
begin
  Result := False;
  if IsWow64 then
  begin
    if RegKeyExists(VS2010x64RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(VS2010x64RegEntry, 'EnvironmentPath', Value, HKEY_LOCAL_MACHINE);
      Result := FileExists(Value);
    end;
  end
  else
  begin
    if RegKeyExists(VS2010x86RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(VS2010x86RegEntry, 'EnvironmentPath', Value, HKEY_LOCAL_MACHINE);
      Result := FileExists(Value);
    end;
  end;
end;

function GetVS2008IDEFileName: string;
begin
  Result := '';
  if IsWow64 then
  begin
    if RegKeyExists(VS2008x64RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(VS2008x64RegEntry, 'EnvironmentPath', Result, HKEY_LOCAL_MACHINE);
  end
  else
  begin
    if RegKeyExists(VS2008x86RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(VS2008x86RegEntry, 'EnvironmentPath', Result, HKEY_LOCAL_MACHINE);
  end;
end;

function GetVS2008CompilerFileName: string;
begin
 Result:=ChangeFileExt(GetVS2008IDEFileName,'.com');
end;

function GetVS2010IDEFileName: string;
begin
  Result := '';
  if IsWow64 then
  begin
    if RegKeyExists(VS2010x64RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(VS2010x64RegEntry, 'EnvironmentPath', Result, HKEY_LOCAL_MACHINE);
  end
  else
  begin
    if RegKeyExists(VS2010x86RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(VS2010x86RegEntry, 'EnvironmentPath', Result, HKEY_LOCAL_MACHINE);
  end;
end;

function GetVS2010CompilerFileName: string;
begin
 Result:=ChangeFileExt(GetVS2010IDEFileName,'.com');
end;

function IsVS11Installed: boolean;
var
  Value: string;
begin
  Result := False;
  if IsWow64 then
  begin
    if RegKeyExists(VS11x64RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(VS11x64RegEntry, 'EnvironmentPath', Value, HKEY_LOCAL_MACHINE);
      Result := FileExists(Value);
    end;
  end
  else
  begin
    if RegKeyExists(VS11x86RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(VS11x86RegEntry, 'EnvironmentPath', Value, HKEY_LOCAL_MACHINE);
      Result := FileExists(Value);
    end;
  end;
end;


function GetVS11IDEFileName: string;
begin
  Result := '';
  if IsWow64 then
  begin
    if RegKeyExists(VS11x64RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(VS11x64RegEntry, 'EnvironmentPath', Result, HKEY_LOCAL_MACHINE);
  end
  else
  begin
    if RegKeyExists(VS11x86RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(VS11x86RegEntry, 'EnvironmentPath', Result, HKEY_LOCAL_MACHINE);
  end;
end;


function GetVS11CompilerFileName: string;
begin
 Result:=ChangeFileExt(GetVS11IDEFileName,'.com');
end;

end.
