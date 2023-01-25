// **************************************************************************************************
//
// Unit WDCC.DelphiPrism.Helper
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
// The Original Code is WDCC.DelphiPrism.Helper.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.DelphiPrism.Helper;

interface

function CreateOxygeneProject(const FileName, Path, ProjectTemplate: string; var NewFileName: string): boolean;

implementation

uses
  WDCC.Misc,
  SysUtils,
  Windows;

function CreateOxygeneProject(const FileName, Path, ProjectTemplate: string; var NewFileName: string): boolean;
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
    NewFileName := ExtractFilePath(NewFileName) + 'GetWMI_Info.oxygene';
  end;
end;

end.
