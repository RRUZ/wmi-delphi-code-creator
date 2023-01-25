// **************************************************************************************************
//
// Unit WDCC.Borland.Cpp.IDE
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
// The Original Code is WDCC.Borland.Cpp.IDE.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.Borland.Cpp.IDE;

interface

Uses
  Classes;

function CreateBorlandCppiProject(const DestPath, SourcePath: string): boolean;
procedure CompileAndRunBorlandCppCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: boolean = True);
procedure FormatBorlandCppCode(Console, DelphiCode: TStrings; const FormatterPath: string);

implementation

uses
  SysUtils,
  Windows,
  ShellApi,
  WDCC.Misc;

procedure FormatBorlandCppCode(Console, DelphiCode: TStrings; const FormatterPath: string);
var
  TempFile: string;
begin
  Console.Add('');
  if FileExists(FormatterPath) then
  begin
    TempFile := IncludeTrailingPathDelimiter(GetTempDirectory) + FormatDateTime('hhnnss.zzz', Now) + '.cpp';
    DelphiCode.SaveToFile(TempFile);
    CaptureConsoleOutput(Format('"%s" -cpp "%s"', [FormatterPath, TempFile]), Console);
    DelphiCode.LoadFromFile(TempFile);
  end;
end;

procedure CompileAndRunBorlandCppCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: boolean = True);
var
  ExeFile: string;
begin
  Console.Add('');
  // CaptureConsoleOutput(Format('"%s" -B -CC -NSsystem;vcl;Winapi;System.Win "%s"', [CompilerName,ProjectFile]), Console);
  CaptureConsoleOutput(Format('"%s" -n"%s" "%s"',
    [CompilerName, ExcludeTrailingPathDelimiter(ExtractFilePath(ProjectFile)), ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ChangeFileExt(ProjectFile, '.exe');
    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(Format('"%s"', [ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
  end;
end;

function CreateBorlandCppiProject(const DestPath, SourcePath: string): boolean;
begin
  Result := CopyDir(IncludeTrailingPathDelimiter(SourcePath) + '*.*', DestPath);
end;

end.
