{**************************************************************************************************}
{                                                                                                  }
{ Unit uDelphiPrismHelper                                                                          }
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
{ The Original Code is uDelphiPrismHelper.pas.                                                     }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uDelphiPrismHelper;

interface

function CreateOxygeneProject(const FileName, Path, ProjectTemplate: string;
  var NewFileName: string): boolean;


implementation

uses
  SysUtils,
  Windows,
  ShellApi;

function CopyDir(const fromDir, toDir: string): boolean;
var
  lpFileOp: TSHFileOpStruct;
begin
  ZeroMemory(@lpFileOp, SizeOf(lpFileOp));
  with lpFileOp do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_NOCONFIRMMKDIR;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir);
  end;
  Result := (ShFileOperation(lpFileOp) = S_OK);
end;


function CreateOxygeneProject(const FileName, Path, ProjectTemplate: string;
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
    NewFileName := ExtractFilePath(NewFileName) + 'GetWMI_Info.oxygene';
  end;
end;


end.
