// **************************************************************************************************
//
// Unit WDCC.DotNetFrameWork
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
// The Original Code is WDCC.DotNetFrameWork.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.DotNetFrameWork;

interface

uses
  System.Classes;

type
  TDotNetVersions = (DotNet1, DotNet1_1, DotNet2, DotNet3, DotNet3_5, DotNet4);

const
  DotNetNames: array [TDotNetVersions] of string = ('NET Framework v1.0', 'NET Framework v1.1.4322',
    'NET Framework v2.0.50727', 'NET Framework v3.0', 'NET Framework v3.5', 'NET Framework v4');

function NetFrameworkInstalled(const NetFrameWorkId: TDotNetVersions): Boolean;
function NetFrameworkPath(const NetFrameWorkId: TDotNetVersions): string;
procedure CompileAndRunCSharpCode(Console: TStrings; const CompilerName, SwitchOps, ProjectFile: string; Run: Boolean);

implementation

uses
  WDCC.Misc,
  System.SysUtils,
  Winapi.ShellApi,
  Winapi.ShlObj,
  Winapi.Windows,
  System.Win.Registry;

const

  DotNetRegPaths: array [TDotNetVersions] of string = ('SOFTWARE\Microsoft\.NETFramework\policy\v1.0',
    'SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322', 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727',
    'SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0', 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5',
    'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4');

  DotNetFolders: array [TDotNetVersions] of string = ('Microsoft.NET\Framework\v1.0.3705',
    'Microsoft.NET\Framework\v1.1.4322', 'Microsoft.NET\Framework\v2.0.50727', 'Microsoft.NET\Framework\v3.0',
    'Microsoft.NET\Framework\v3.5', 'Microsoft.NET\Framework\v4.0.30319');

procedure CompileAndRunCSharpCode(Console: TStrings; const CompilerName, SwitchOps, ProjectFile: string; Run: Boolean);
var
  ExeFile: string;
  CmdLine: string;
begin
  Console.Add('');
  CmdLine := Format('"%s" %s', [CompilerName, SwitchOps]);
  CmdLine := StringReplace(CmdLine, '[OutPutPath]', ExtractFilePath(ProjectFile), [rfReplaceAll]);
  CmdLine := StringReplace(CmdLine, '[FileName]', ChangeFileExt(ExtractFileName(ProjectFile), ''), [rfReplaceAll]);

  CaptureConsoleOutput(CmdLine, Console);

  {
    CaptureConsoleOutput(Format(
    //'"%s" /target:exe /r:System.Management.dll /r:System.Data.dll /r:System.Drawing.dll /r:System.Drawing.Design.dll /r:System.Windows.Forms.dll /r:System.dll /out:"%s" "%s"',
    '"%s" /target:exe /r:System.Management.dll /r:System.dll /out:"%s" "%s"',
    [CompilerName, ChangeFileExt(ProjectFile, '.exe'), ProjectFile]), Console);
  }

  if Run then
  begin
    ExeFile := ChangeFileExt(ProjectFile, '.exe');
    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(Format('"%s"', [ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
  end;
end;

function NetFrameworkInstalled(const NetFrameWorkId: TDotNetVersions): Boolean;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Result := Reg.KeyExists(DotNetRegPaths[NetFrameWorkId]);
  finally
    Reg.Free;
  end
end;

function NetFrameworkPath(const NetFrameWorkId: TDotNetVersions): string;
begin
  Result := IncludeTrailingPathDelimiter(WDCC.Misc.GetWindowsDirectory()) + DotNetFolders[NetFrameWorkId];
end;

end.
