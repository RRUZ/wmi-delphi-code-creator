// **************************************************************************************************
//
// Unit WDCC.VisualStudio
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
// The Original Code is WDCC.VisualStudio.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.VisualStudio;

interface

uses
  System.Generics.Collections,
  System.Classes;

type
  TVSVersion = (vs2005, // 8.0     'Visual Studio 2005',
    vs2008, // 9.0     'Visual Studio 2008',
    vs2010, // 10.0    'Visual Studio 2010',
    vs2012, // 11.0    'Visual Studio 2012',
    vs2013, // 12.0    'Visual Studio 2013',
    vs2015 // 14.0    'Visual Studio 2015'
    );

  TVisualStudioInfo = class
  private
    FIDEFileName: string;
    FCompilerFileName: string;
    FCppCompiler: string;
    FIDEDescription: string;
    FVSVersion: TVSVersion;
    FBaseRegistryKey: string;
  public
    property IDEFileName: string read FIDEFileName write FIDEFileName;
    property IDEDescription: string read FIDEDescription write FIDEDescription;
    property CompilerFileName: string read FCompilerFileName write FCompilerFileName;
    property CppCompiler: string read FCppCompiler write FCppCompiler;
    property Version: TVSVersion read FVSVersion write FVSVersion;
    property BaseRegistryKey: string read FBaseRegistryKey write FBaseRegistryKey;
    function CSharpInstalled: Boolean;
    function CPPInstalled: Boolean;
  end;

function GetVSIDEList: TObjectList<TVisualStudioInfo>;
function CreateVsProject(const FileName, Path, ProjectTemplate: string; var NewFileName: string): Boolean;

procedure CompileAndRunVsCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: Boolean);
procedure CompileAndRunMicrosoftCppCode(Console: TStrings; const CompilerName, ProjectFile, SwitchOpts: string;
  Run: Boolean);

implementation

uses
  ShellAPi,
  SysUtils,
  Windows,
  WDCC.Registry,
  IOUtils,
  WDCC.Misc;

const

  // VSVersionsNames: array[TVSVersion] of string = (
  // 'Visual Studio 2005',
  // 'Visual Studio 2008',
  // 'Visual Studio 2010',
  // 'Visual Studio 2012',
  // 'Visual Studio 2013',
  // 'Visual Studio 2015'
  // );

  VSRegBasePathsx86: array [TVSVersion] of string = ('\SOFTWARE\Microsoft\VisualStudio\8.0\',
    '\SOFTWARE\Microsoft\VisualStudio\9.0\', '\SOFTWARE\Microsoft\VisualStudio\10.0\',
    '\SOFTWARE\Microsoft\VisualStudio\11.0\', '\SOFTWARE\Microsoft\VisualStudio\12.0\',
    '\SOFTWARE\Microsoft\VisualStudio\14.0\');

  VSRegBasePathsx64: array [TVSVersion] of string = ('\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\8.0\',
    '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\9.0\', '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\10.0\',
    '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\11.0\', '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\12.0\',
    '\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\14.0\');

  VSKeyInstalled = 'Setup\VS';
  VSKeyCSharpInstalled = 'Languages\Language Services\CSharp';
  VSKeyCPPInstalled = 'InstalledProducts\Microsoft Visual C++';

var
  VSIDEList: TObjectList<TVisualStudioInfo>;

function GetVSIDEList: TObjectList<TVisualStudioInfo>;
begin
  Result := VSIDEList;
end;

function CreateVsProject(const FileName, Path, ProjectTemplate: string; var NewFileName: string): Boolean;
var
  PathTemplate: string;
  DestFolder: string;
begin
  NewFileName := '';
  PathTemplate := ExtractFilePath(ProjectTemplate);
  DestFolder := IncludeTrailingPathDelimiter(Path) + FormatDateTime('YYYYMMDDHHNNSS', Now);
  ForceDirectories(DestFolder);
  Result := CopyDir(IncludeTrailingPathDelimiter(PathTemplate) + '*.*', DestFolder);
  if Result then
  begin
    NewFileName := IncludeTrailingPathDelimiter(DestFolder) + FileName;
    Result := CopyFile(PChar(IncludeTrailingPathDelimiter(Path) + FileName), PChar(NewFileName), False);
    NewFileName := ExtractFilePath(NewFileName) + 'GetWMI_Info.sln';
  end;
end;

procedure CompileAndRunVsCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: Boolean);
var
  ExeFile: string;
begin
  Console.Add('');
  CaptureConsoleOutput(Format('"%s" "%s" /rebuild release', [CompilerName, ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ExtractFilePath(ProjectFile) + 'release\' + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');
    if not FileExists(ExeFile) then
      ExeFile := ExtractFilePath(ProjectFile) + 'bin\release\' + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');

    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(Format('"%s"', [ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
  end;
end;

procedure CompileAndRunMicrosoftCppCode(Console: TStrings; const CompilerName, ProjectFile, SwitchOpts: string;
  Run: Boolean);
var
  ExeFile: string;
  CmdLine: string;
  vcvars32: string;

  Bat: TStringList;
  BatFile: string;
  CmdBuffer: array [0 .. MAX_PATH] of Char;
begin
  Bat := TStringList.Create;
  try
    Console.Add('');
    vcvars32 := ExtractFilePath(CompilerName) + 'vcvars32.bat';
    Bat.Add('CALL ' + TFile.ReadAllText(vcvars32));

    { /EHsc /Fe"[OutPutPath][FileName].exe" /Fo"[OutPutPath][FileName].obj" "[OutPutPath][FileName].cpp" }
    CmdLine := Format('"%s" %s', [CompilerName, SwitchOpts]);
    CmdLine := StringReplace(CmdLine, '[OutPutPath]', ExtractFilePath(ProjectFile), [rfReplaceAll]);
    CmdLine := StringReplace(CmdLine, '[FileName]', ChangeFileExt(ExtractFileName(ProjectFile), ''), [rfReplaceAll]);
    Bat.Add(CmdLine);
    BatFile := ChangeFileExt(ProjectFile, '.bat');
    Bat.SaveToFile(BatFile);

    GetEnvironmentVariable('COMSPEC', CmdBuffer, MAX_PATH + 1);
    CmdLine := Format('%s /C "%s"', [CmdBuffer, BatFile]);
    CaptureConsoleOutput(CmdLine, Console);
    if Run then
    begin
      ExeFile := ExtractFilePath(ProjectFile) + ChangeFileExt(ExtractFileName(ProjectFile), '.exe');
      if FileExists(ExeFile) then
        ShellExecute(0, nil, PChar(Format('"%s"', [ExeFile])), nil, nil, SW_SHOWNORMAL)
      else
        MsgWarning(Format('Could not find %s', [ExeFile]));
    end;
  finally
    Bat.Free;
  end;
end;

procedure LoadVSIDEList;
Var
  LVisualStudioInfo: TVisualStudioInfo;
  LVSVersion: TVSVersion;
  FileName: string;
  LWow64, Found: Boolean;
begin
  VSIDEList.Clear;
  LWow64 := IsWow64;
  for LVSVersion := Low(TVSVersion) to High(TVSVersion) do
  begin
    FileName := '';

    if LWow64 then
      Found := RegKeyExists(VSRegBasePathsx64[LVSVersion] + VSKeyInstalled, HKEY_LOCAL_MACHINE)
    else
      Found := RegKeyExists(VSRegBasePathsx86[LVSVersion] + VSKeyInstalled, HKEY_LOCAL_MACHINE);

    if Found and LWow64 then
      Found := RegReadStr(VSRegBasePathsx64[LVSVersion] + VSKeyInstalled, 'EnvironmentPath', FileName,
        HKEY_LOCAL_MACHINE) and FileExists(FileName)
    else
      Found := RegReadStr(VSRegBasePathsx86[LVSVersion] + VSKeyInstalled, 'EnvironmentPath', FileName,
        HKEY_LOCAL_MACHINE) and FileExists(FileName);

    if Found then
    begin
      LVisualStudioInfo := TVisualStudioInfo.Create;
      LVisualStudioInfo.IDEFileName := FileName;
      LVisualStudioInfo.Version := LVSVersion;
      LVisualStudioInfo.IDEDescription := GetFileDescription(FileName); // VSVersionsNames[LVSVersion];
      if LWow64 then
        LVisualStudioInfo.BaseRegistryKey := VSRegBasePathsx64[LVSVersion]
      else
        LVisualStudioInfo.BaseRegistryKey := VSRegBasePathsx86[LVSVersion];

      LVisualStudioInfo.CompilerFileName := ChangeFileExt(LVisualStudioInfo.IDEFileName, '.com');
      LVisualStudioInfo.CppCompiler := ExpandFileName(ExtractFilePath(LVisualStudioInfo.IDEFileName) + '\..\..') +
        '\VC\bin\cl.exe';
      VSIDEList.Add(LVisualStudioInfo);
    end;
  end;

end;

{ TVisualStudioInfo }

function TVisualStudioInfo.CPPInstalled: Boolean;
begin
  if IsWow64 then
    Result := RegKeyExists(VSRegBasePathsx64[Version] + VSKeyCPPInstalled, HKEY_LOCAL_MACHINE)
  else
    Result := RegKeyExists(VSRegBasePathsx86[Version] + VSKeyCPPInstalled, HKEY_LOCAL_MACHINE);
end;

function TVisualStudioInfo.CSharpInstalled: Boolean;
begin
  if IsWow64 then
    Result := RegKeyExists(VSRegBasePathsx64[Version] + VSKeyCSharpInstalled, HKEY_LOCAL_MACHINE)
  else
    Result := RegKeyExists(VSRegBasePathsx86[Version] + VSKeyCSharpInstalled, HKEY_LOCAL_MACHINE);
end;

initialization

VSIDEList := TObjectList<TVisualStudioInfo>.Create(True);
LoadVSIDEList;

finalization

VSIDEList.Free;

end.
