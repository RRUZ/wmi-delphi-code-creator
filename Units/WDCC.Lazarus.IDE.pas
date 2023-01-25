// **************************************************************************************************
//
// Unit WDCC.Lazarus.IDE
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
// The Original Code is WDCC.Lazarus.IDE.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.Lazarus.IDE;

interface

uses
  ShlObj,
  ComObj,
  ActiveX,
  Classes,
  Windows,
  Variants,
  SysUtils;

function GetLazarusLocalFolder: string;
function GetLazarusIDEFolder: string;
function GetLazarusIDEFileName: string;
function GetLazarusCompilerFileName: string;
function IsLazarusInstalled: boolean;

function CreateLazarusProject(const FileName, Path, ProjectTemplate: string): boolean;
procedure CompileAndRunFPCCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: boolean);

implementation

uses
  ShellAPI,
  WDCC.Misc;

const
  LazarusConfigFile = 'environmentoptions.xml';
  LazarusIDEName = 'lazarus.exe';

procedure CompileAndRunFPCCode(Console: TStrings; const CompilerName, ProjectFile: string; Run: boolean);
var
  ExeFile: string;
begin
  Console.Add('');
  CaptureConsoleOutput(Format('"%s" "%s"', [CompilerName, ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ChangeFileExt(ProjectFile, '.exe');
    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(Format('"%s"', [ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
  end;
end;

function CreateLazarusProject(const FileName, Path, ProjectTemplate: string): boolean;
var
  XmlDoc: olevariant;
  Node: olevariant;
  LpiFileName: string;
begin
  Result := False;

  LpiFileName := IncludeTrailingPathDelimiter(Path) + ChangeFileExt(FileName, '.lpi');
  CopyFile(PChar(ProjectTemplate), PChar(LpiFileName), False);

  XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
  try
    XmlDoc.Async := False;
    XmlDoc.Load(LpiFileName);
    XmlDoc.SetProperty('SelectionLanguage', 'XPath');

    if (XmlDoc.parseError.errorCode <> 0) then
      raise Exception.CreateFmt('Error in Xml Data %s', [XmlDoc.parseError]);

    Node := XmlDoc.selectSingleNode('//CONFIG/ProjectOptions/Units/Unit0/Filename/@Value');
    if not VarIsClear(Node) then
      Node.Text := FileName;

    Node := XmlDoc.selectSingleNode('//CONFIG/ProjectOptions/JumpHistory/Position1/Filename/@Value');
    if not VarIsClear(Node) then
      Node.Text := FileName;
    {
      Node  :=XmlDoc.selectSingleNode('//CONFIG/CompilerOptions/Target/Filename/@Value');
      if not VarIsClear(Node) then
      Node.Text:=ChangeFileExt(FileName,'');
    }
    XmlDoc.Save(LpiFileName);
    Result := True;
  finally
    XmlDoc := Unassigned;
  end;
end;

function GetLazarusLocalFolder: string;
begin
  Result := Format('%slazarus', [IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_LOCAL_APPDATA))]);
  if not DirectoryExists(Result) then
    Result := '';
end;

function GetConfigLazarusValue(const AValue: string): string;
var
  LocalFolder: TFileName;
  FileName: TFileName;
  XmlDoc: olevariant;
  Node: olevariant;
begin
  Result := '';
  LocalFolder := GetLazarusLocalFolder;
  if LocalFolder <> '' then
  begin
    FileName := Format('%s%s', [IncludeTrailingPathDelimiter(LocalFolder), LazarusConfigFile]);
    if FileExists(FileName) then
    begin
      XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
      try
        XmlDoc.Async := False;
        XmlDoc.Load(FileName);
        XmlDoc.SetProperty('SelectionLanguage', 'XPath');

        if (XmlDoc.parseError.errorCode <> 0) then
          raise Exception.CreateFmt('Error in Xml Data %s', [XmlDoc.parseError]);

        Node := XmlDoc.selectSingleNode(AValue);
        if not VarIsClear(Node) then
          Result := Node.Text;
      finally
        XmlDoc := Unassigned;
      end;
    end;
  end;
end;

function GetLazarusIDEFolder: string;
begin
  Result := GetConfigLazarusValue('//CONFIG/EnvironmentOptions/LazarusDirectory/@Value');
end;

function GetLazarusIDEFileName: string;
begin
  Result := Format('%s%s', [IncludeTrailingPathDelimiter(GetLazarusIDEFolder), LazarusIDEName]);
end;

function GetLazarusCompilerFileName: string;
begin
  Result := GetConfigLazarusValue('//CONFIG/EnvironmentOptions/CompilerFilename/@Value');
end;

function IsLazarusInstalled: boolean;
begin
  Result := FileExists(GetLazarusIDEFileName);
end;

end.
