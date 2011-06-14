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
