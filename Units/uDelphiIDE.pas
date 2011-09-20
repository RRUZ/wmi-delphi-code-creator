{**************************************************************************************************}
{                                                                                                  }
{ Unit uDelphiIDE                                                                                  }
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
{ The Original Code is uDelphiIDE.pas.                                                             }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uDelphiIDE;

interface

Uses
  Classes;
   {
type
  TDelphiVersions =
    (
    Delphi7,
    Delphi8,
    Delphi2005,
    Delphi2006,
    Delphi2007,
    Delphi2009,
    Delphi2010,
    DelphiXE
    );

const
  DelphiVersionsNames: array[TDelphiVersions] of string = (
    'Delphi 7',
    'Delphi 8',
    'BDS 2005',
    'BDS 2006',
    'RAD Studio 2007',
    'RAD Studio 2009',
    'RAD Studio 2010',
    'RAD Studio XE'
    );

  DelphiRegPaths: array[TDelphiVersions] of string = (

    '\Software\Borland\Delphi\7.0',
    '\Software\Borland\BDS\2.0',
    '\Software\Borland\BDS\3.0',
    '\Software\Borland\BDS\4.0',
    '\Software\Borland\BDS\5.0',
    '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0',
    '\Software\Embarcadero\BDS\8.0');
 }
function  CreateDelphiProject(const DestPath, SourcePath: string): boolean;
procedure CompileAndRunDelphiCode(Console:TStrings; const CompilerName, ProjectFile: string; Run: boolean = True);

implementation

uses
  SysUtils,
  Windows,
  ShellApi,
  uMisc;


procedure CompileAndRunDelphiCode(Console:TStrings; const CompilerName, ProjectFile: string; Run: boolean = True);
var
  ExeFile: string;
begin
  Console.Add('');
  CaptureConsoleOutput(Format('"%s" -B -CC -NSsystem;vcl;Winapi;System.Win "%s"', [CompilerName,ProjectFile]), Console);
  //CaptureConsoleOutput(Format('"%s" -B -CC "%s"', [CompilerName,ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ChangeFileExt(ProjectFile, '.exe');
    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(Format('"%s"',[ExeFile])), nil, nil, SW_SHOWNORMAL)
    else
      MsgWarning(Format('Could not find %s', [ExeFile]));
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
    fFlags := FOF_FILESONLY + FOF_NOCONFIRMATION;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir);
  end;
  Result := (ShFileOperation(lpFileOp) = S_OK);
end;


function CreateDelphiProject(const DestPath, SourcePath: string): boolean;
begin
  Result := CopyDir(IncludeTrailingPathDelimiter(SourcePath) + '*.*', DestPath);
end;

end.
