unit uDelphiIDE;

interface

Uses
  Classes;

type
  TDelphiVersions =
    (
    Delphi4,
    Delphi5,
    Delphi6,
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
    'Delphi 4',
    'Delphi 5',
    'Delphi 6',
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
    '\Software\Borland\Delphi\4.0',
    '\Software\Borland\Delphi\5.0',
    '\Software\Borland\Delphi\6.0',
    '\Software\Borland\Delphi\7.0',
    '\Software\Borland\BDS\2.0',
    '\Software\Borland\BDS\3.0',
    '\Software\Borland\BDS\4.0',
    '\Software\Borland\BDS\5.0',
    '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0',
    '\Software\Embarcadero\BDS\8.0');

function  CreateDelphiProject(const DestPath, SourcePath: string): boolean;
procedure CompileAndRunDelphiCode(Console:TStrings; const CompilerName, ProjectFile: string; Run: boolean = True);

implementation

uses
  SysUtils,
  Windows,
  ShellApi, uMisc;


procedure CompileAndRunDelphiCode(Console:TStrings; const CompilerName, ProjectFile: string; Run: boolean = True);
var
  ExeFile: string;
begin
  Console.Add('');
  CaptureConsoleOutput(CompilerName + ' ' + Format(' -B -CC %s', [ProjectFile]), Console);
  if Run then
  begin
    ExeFile := ChangeFileExt(ProjectFile, '.exe');
    if FileExists(ExeFile) then
      ShellExecute(0, nil, PChar(ExeFile), nil, nil, SW_SHOWNORMAL)
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
