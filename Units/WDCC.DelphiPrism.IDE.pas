// **************************************************************************************************
//
// Unit WDCC.DelphiPrism.IDE
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
// The Original Code is WDCC.DelphiPrism.IDE.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.DelphiPrism.IDE;

interface

Uses
  Classes;

function IsDelphiPrismInstalled: boolean;
function GetDelphiPrismCompilerFileName: string;
function GetDelphiPrismCompilerFolder: string;

function IsMonoDevelopInstalled: boolean;
function IsDelphiPrismAttachedtoMonoDevelop: boolean;

function GetMonoDevelopIDEFileName: string;

procedure CompileAndRunOxygenCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: boolean);

implementation

uses
  Windows,
  ShellAPI,
  WDCC.Registry,
  WDCC.VisualStudio,
  SysUtils,
  WDCC.Misc;

const
  // HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\RemObjects\Oxygene
  DelphiPrismx86RegEntry = '\Software\RemObjects\Oxygene';
  DelphiPrismx64RegEntry = '\Software\Wow6432Node\RemObjects\Oxygene';

  // HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Novell\MonoDevelop
  MonoDevelopx64RegEntry = '\SOFTWARE\Novell\MonoDevelop';
  MonoDevelopx86RegEntry = '\SOFTWARE\Wow6432Node\Novell\MonoDevelop';

procedure CompileAndRunOxygenCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: boolean);
var
  ExeFile: string;
begin
  Console.Add('');
  CaptureConsoleOutput(Format('"%s" "%s"', [CompilerName, ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ExtractFilePath(ProjectFile) + 'bin\release\' + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');
    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(Format('"%s"', [ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
  end;
end;

function IsMonoDevelopInstalled: boolean;
var
  Value: string;
begin
  Result := False;
  if IsWow64 then
  begin
    if RegKeyExists(MonoDevelopx64RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(MonoDevelopx64RegEntry, 'Path', Value, HKEY_LOCAL_MACHINE);
      Value := IncludeTrailingPathDelimiter(Value) + 'bin\Monodevelop.exe';
      Result := FileExists(Value);
    end;
  end
  else
  begin
    if RegKeyExists(MonoDevelopx86RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(MonoDevelopx86RegEntry, 'Path', Value, HKEY_LOCAL_MACHINE);
      Value := IncludeTrailingPathDelimiter(Value) + 'bin\Monodevelop.exe';
      Result := FileExists(Value);
    end;
  end;
end;

function GetMonoDevelopIDEFileName: string;
begin
  Result := '';
  if IsWow64 then
  begin
    if RegKeyExists(MonoDevelopx64RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(MonoDevelopx64RegEntry, 'Path', Result, HKEY_LOCAL_MACHINE);
      Result := IncludeTrailingPathDelimiter(Result) + 'bin\Monodevelop.exe';
    end;
  end
  else
  begin
    if RegKeyExists(MonoDevelopx86RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(MonoDevelopx86RegEntry, 'Path', Result, HKEY_LOCAL_MACHINE);
      Result := IncludeTrailingPathDelimiter(Result) + 'bin\Monodevelop.exe';
    end;
  end;
end;

function IsDelphiPrismAttachedtoMonoDevelop: boolean;
var
  Value: string;
begin
  Result := False;
  if IsWow64 then
  begin
    if RegKeyExists(MonoDevelopx64RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(MonoDevelopx64RegEntry, 'Path', Value, HKEY_LOCAL_MACHINE);
      Value := IncludeTrailingPathDelimiter(Value) + 'AddIns\Oxygene\RemObjects.Oxygene.Compiler.dll';
      Result := FileExists(Value);
    end;
  end
  else
  begin
    if RegKeyExists(MonoDevelopx86RegEntry, HKEY_LOCAL_MACHINE) then
    begin
      RegReadStr(MonoDevelopx86RegEntry, 'Path', Value, HKEY_LOCAL_MACHINE);
      Value := IncludeTrailingPathDelimiter(Value) + 'AddIns\Oxygene\RemObjects.Oxygene.Compiler.dll';
      Result := FileExists(Value);
    end;
  end;
end;

function GetDelphiPrismRegValue(const Value: string): string;
begin
  if IsWow64 then
  begin
    if RegKeyExists(DelphiPrismx64RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(DelphiPrismx64RegEntry, Value, Result, HKEY_LOCAL_MACHINE);
  end
  else
  begin
    if RegKeyExists(DelphiPrismx86RegEntry, HKEY_LOCAL_MACHINE) then
      RegReadStr(DelphiPrismx86RegEntry, Value, Result, HKEY_LOCAL_MACHINE);
  end;
end;

function GetDelphiPrismCompilerFolder: string;
begin
  Result := IncludeTrailingPathDelimiter(GetDelphiPrismRegValue('InstallDir')) + 'Bin';
end;

function GetDelphiPrismCompilerFileName: string;
begin
  Result := Format('%s%s', [IncludeTrailingPathDelimiter(GetDelphiPrismCompilerFolder), 'oxygene.exe']);
end;

function IsDelphiPrismInstalled: boolean;
begin
  Result := FileExists(GetDelphiPrismCompilerFileName) and (GetDelphiPrismRegValue('Installed') = '1');
end;

end.
