// **************************************************************************************************
//
// Unit WDCC.Delphi.Versions
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
// The Original Code is WDCC.Delphi.Versions.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2013-2019 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.Delphi.Versions;

interface

uses
  Generics.Defaults,
  Generics.Collections,
  WDCC.SupportedIDEs,
  Windows,
  Graphics,
  SysUtils,
  Classes;

{$DEFINE DELPHI_OLDER_VERSIONS_SUPPORT}

type
  TDelphiVersions = (
    {$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
    Delphi5, Delphi6,
    {$ENDIF}
    Delphi7, Delphi8, Delphi2005, Delphi2006, Delphi2007, Delphi2009, Delphi2010,
    DelphiXE, DelphiXE2, DelphiXE3, DelphiXE4, DelphiXE5, Appmethod, DelphiXE6,
    DelphiXE7, DelphiXE8, Delphi10Seattle, Delphi10Berlin, Delphi10Tokyo, Delphi10Rio);

  SetDelphiVersions = TArray<TDelphiVersions>;

  TDelphiVersionData = Class
  private
    FVersion: TDelphiVersions;
    FName: string;
    FPath: string;
    FIcon: TIcon;
    FIDEType: TSupportedIDEs;
    FBitmap: TBitmap;
  public
    property Version: TDelphiVersions read FVersion;
    property Path: string read FPath write FPath;
    property Name: string read FName write FName;
    property Icon: TIcon read FIcon write FIcon;
    property IDEType: TSupportedIDEs read FIDEType write FIDEType;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    constructor Create;
    Destructor Destroy; override;
  end;

  TInstalledDelphiVerions = class(TDictionary<TDelphiVersions, TDelphiVersionData>)
  private
    function GetValuesSorted: TArray<TDelphiVersionData>;
  public
    property ValuesSorted: TArray<TDelphiVersionData> read GetValuesSorted;
  end;

  TMSBuildDProj = class
  private
    FFrameworkType: string;
    FProjectFile: string;
    FTargetPlatforms: TStrings;
    FGUID: string;
    FAppType: string;
    FDelphiVersion: TDelphiVersions;
    FDefaultConfiguration: string;
    FDefaultPlatForm: string;
    FValidData: Boolean;
    FBuildConfigurations: TStrings;
    procedure LoadInfo;
  public
    property FrameworkType: string read FFrameworkType;
    property TargetPlatforms: TStrings read FTargetPlatforms write FTargetPlatforms;
    property BuildConfigurations: TStrings read FBuildConfigurations write FBuildConfigurations;
    property GUID: string read FGUID;
    property AppType: string read FAppType;
    property DelphiVersion: TDelphiVersions read FDelphiVersion;
    property DefaultConfiguration: string read FDefaultConfiguration; // Release, Debug
    property DefaultPlatForm: string read FDefaultPlatForm; // Win32, OSX
    property ValidData: Boolean read FValidData;
    property ProjectFile: string read FProjectFile;
    constructor Create(const _ProjectFile: string);
    Destructor Destroy; override;
  end;

  TMSBuildGroupProj = class
  private
    FGroupProjectFile: string;
    FGUID: string;
    FDelphiVersion: TDelphiVersions;
    FValidData: Boolean;
    FProjects: TObjectList<TMSBuildDProj>;
    procedure LoadInfo;
  public
    property Projects: TObjectList<TMSBuildDProj> read FProjects;
    property GUID: string read FGUID;
    property DelphiVersion: TDelphiVersions read FDelphiVersion;
    property ValidData: Boolean read FValidData;
    constructor Create(const GroupProjectFile: string);
    Destructor Destroy; override;
  end;

  TPAClientProfile = class
  private
    FPlatform: string;
    FHost: string;
    FPort: Integer;
    FName: string;
    FFileName: string;
    FRADStudioVersion: TDelphiVersions;
  public
    property Platform: string read FPlatform;
    property Host: string read FHost;
    property Port: Integer read FPort;
    property Name: string read FName;
    property FileName: string read FFileName;
    property RADStudioVersion: TDelphiVersions read FRADStudioVersion;
  end;

  TPAClientProfileList = class
  private
    FProfiles: TObjectList<TPAClientProfile>;
    FListDelphiVersions: TDictionary<TDelphiVersions, TDelphiVersionData>;
    procedure LoadData;
  public
    property Profiles: TObjectList<TPAClientProfile> read FProfiles;
    constructor Create(ListDelphiVersions: TDictionary<TDelphiVersions, TDelphiVersionData>);
    Destructor Destroy; override;
  end;

const
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
  DelphiOldVersions = 2;
  DelphiOldVersionNumbers: array [0 .. DelphiOldVersions - 1] of TDelphiVersions = (Delphi5, Delphi6);

  DelphiOldColorsCount = 16;

  DelphiOldColorsList: array [0 .. DelphiOldColorsCount - 1] of TColor = ($000000, $000080, $008000, $008080, $800000,
    $800080, $808000, $C0C0C0, $808080, $0000FF, $00FF00, $00FFFF, $FF0000, $FF00FF, $FFFF00, $FFFFFF);
{$ENDIF}
  DelphiVersionsNames: array [TDelphiVersions] of string = (
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
    'Delphi 5', 'Delphi 6',
{$ENDIF}
    'Delphi 7', 'Delphi 8', 'BDS 2005', 'BDS 2006', 'RAD Studio 2007', 'RAD Studio 2009', 'RAD Studio 2010',
    'RAD Studio XE', 'RAD Studio XE2', 'RAD Studio XE3', 'RAD Studio XE4', 'RAD Studio XE5', 'Appmethod 1.13',
    'RAD Studio XE6', 'RAD Studio XE7', 'RAD Studio XE8', 'RAD Studio 10 Seattle', 'RAD Studio 10.1 Berlin',
    'RAD Studio 10.2 Tokyo', 'RAD Studio 10.3 Rio');

  DelphiRegPaths: array [TDelphiVersions] of string = (
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
    '\Software\Borland\Delphi\5.0', '\Software\Borland\Delphi\6.0',
{$ENDIF}
    '\Software\Borland\Delphi\7.0', '\Software\Borland\BDS\2.0', '\Software\Borland\BDS\3.0',
    '\Software\Borland\BDS\4.0', '\Software\Borland\BDS\5.0', '\Software\CodeGear\BDS\6.0',
    '\Software\CodeGear\BDS\7.0', '\Software\Embarcadero\BDS\8.0', '\Software\Embarcadero\BDS\9.0',
    '\Software\Embarcadero\BDS\10.0', '\Software\Embarcadero\BDS\11.0', '\Software\Embarcadero\BDS\12.0',
    '\Software\Embarcadero\BDS\13.0', '\Software\Embarcadero\BDS\14.0', '\Software\Embarcadero\BDS\15.0',
    '\Software\Embarcadero\BDS\16.0', '\Software\Embarcadero\BDS\17.0', '\Software\Embarcadero\BDS\18.0',
    '\Software\Embarcadero\BDS\19.0',
    '\Software\Embarcadero\BDS\20.0');

  PAClientProfilesPaths: array [TDelphiVersions] of string = (
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
    '', '',
{$ENDIF}
    '', '', '', '', '', '', '', '', '\Embarcadero\BDS\9.0', '\Embarcadero\BDS\10.0', '\Embarcadero\BDS\11.0',
    '\Embarcadero\BDS\12.0', '\Embarcadero\BDS\13.0', '\Embarcadero\BDS\14.0', '\Embarcadero\BDS\15.0',
    '\Embarcadero\BDS\16.0', '\Embarcadero\BDS\17.0', '\Embarcadero\BDS\18.0', '\Embarcadero\BDS\19.0', '\Embarcadero\BDS\20.0');

  DelphiVersionNumbers: array [TDelphiVersions] of double = (
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
    13, // 'Delphi 5',
    14, // 'Delphi 6',
{$ENDIF}
    15, // 'Delphi 7',
    16, // 'Delphi 8',
    17, // 'BDS 2005',
    18, // 'BDS 2006',
    18.5, // 'RAD Studio 2007',
    20, // 'RAD Studio 2009',
    21, // 'RAD Studio 2010',
    22, // 'RAD Studio XE'
    23, // 'RAD Studio XE2'
    24, // 'RAD Studio XE3'
    25, // 'RAD Studio XE4'
    26, // 'RAD Studio XE5'
    27, // 'RAD Studio XE6'
    27, // ' Appmethod
    28, // 'RAD Studio XE7'
    29, // 'RAD Studio XE8'
    30, // 'RAD Studio 10 Seattle
    31, // 'RAD Studio 10.1 Berlin'
    32, // 'RAD Studio 10.2 Tokyo'
    33  // 'RAD Studio 10.3 Rio'
    );

function GetListInstalledDelphiVersions: TInstalledDelphiVerions;
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
function DelphiIsOldVersion(DelphiVersion: TDelphiVersions): Boolean;
function GetIndexClosestColor(AColor: TColor): Integer;
{$ENDIF}
procedure ReplaceColor(ABitmap: TBitmap; SourceColor, TargetColor: TColor);
procedure MakeBitmapMenuTransparent(ABitmap: TBitmap);
function GetDelphiVersions(const ProjectFile: string): SetDelphiVersions;
function GetDelphiVersionMappedColor(AColor: TColor; DelphiVersion: TDelphiVersions): TColor;
function GetDelphiInstallPath(DelphiComp: TDelphiVersions): string;

implementation

uses
  WDCC.Misc,
  Winapi.PsAPI,
  Controls,
  System.Variants,
  ComObj,
  ActiveX,
  System.StrUtils,
  ImgList,
  GraphUtil,
  CommCtrl,
  Typinfo,
  ShellAPI,
  Winapi.ShlObj,
  IOUtils,
  WDCC.Registry,
  System.Types,
  Registry;

function GetDelphiInstallPath(DelphiComp: TDelphiVersions): string;
var
  FileName: string;
  Found: Boolean;
begin
  Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_CURRENT_USER);
  if Found then
    Found := RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName, HKEY_CURRENT_USER) and FileExists(FileName);

  if not Found then
  begin
    Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_LOCAL_MACHINE);
    if Found then
      RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName, HKEY_LOCAL_MACHINE);
  end;

  Result := ExtractFilePath(FileName);
end;

function GetDelphiVersionMappedColor(AColor: TColor; DelphiVersion: TDelphiVersions): TColor;
begin
  Result := AColor;
{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}
  if DelphiIsOldVersion(DelphiVersion) then
    Result := DelphiOldColorsList[GetIndexClosestColor(AColor)];
{$ENDIF}
end;

constructor TMSBuildDProj.Create(const _ProjectFile: string);
begin
  inherited Create;
  FProjectFile := _ProjectFile;
  FTargetPlatforms := TStringList.Create;
  FBuildConfigurations := TStringList.Create;
  FValidData := False;
  if FileExists(ProjectFile) then
    LoadInfo;
end;

destructor TMSBuildDProj.Destroy;
begin
  FTargetPlatforms.Free;
  FBuildConfigurations.Free;
  inherited;
end;

procedure TMSBuildDProj.LoadInfo;
var
  ns: string;
  XmlDoc: OleVariant;
  Nodes, Node: OleVariant;
  i, lNodes: Integer;
  sdv: SetDelphiVersions;
  LDelphiVersion: TDelphiVersions;
begin

  sdv := GetDelphiVersions(FProjectFile);
  for LDelphiVersion in sdv do
    if LDelphiVersion <= TDelphiVersions.DelphiXE then
    begin
      FDelphiVersion := LDelphiVersion;
      FFrameworkType := 'VCL';
      FTargetPlatforms.Add('Win32');

      CoInitialize(nil);
      try
        XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
        try
          XmlDoc.Async := False;
          XmlDoc.Load(FProjectFile);

          if (XmlDoc.parseError.errorCode <> 0) then
          begin
            FValidData := False;
            Exit;
          end
          else
            FValidData := True;

          XmlDoc.SetProperty('SelectionLanguage', 'XPath');
          ns := Format('xmlns:a=%s', [QuotedStr('http://schemas.microsoft.com/developer/msbuild/2003')]);
          XmlDoc.SetProperty('SelectionNamespaces', ns);

          FDefaultPlatForm := 'Win32';

          if LDelphiVersion = Delphi2007 then
          begin
            Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:Configuration');
            if not VarIsClear(Node) then
              FDefaultConfiguration := Node.Text;
          end
          else
          begin
            Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:Config');
            if not VarIsClear(Node) then
              FDefaultConfiguration := Node.Text;
          end;

          Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:ProjectGuid');
          if not VarIsClear(Node) then
            FGUID := Node.Text;

          Node := XmlDoc.selectSingleNode('/a:Project/a:ProjectExtensions/a:Borland.ProjectType');
          if not VarIsClear(Node) then
            FAppType := Node.Text;

          FBuildConfigurations.Add('Debug');
          FBuildConfigurations.Add('Release');
        finally
          XmlDoc := Unassigned;
        end;
      finally
        CoUninitialize;
      end;

      break;
    end
    else
    begin
      FDelphiVersion := LDelphiVersion;
      CoInitialize(nil);
      try
        XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
        try
          XmlDoc.Async := False;
          XmlDoc.Load(FProjectFile);

          if (XmlDoc.parseError.errorCode <> 0) then
          begin
            FValidData := False;
            Exit;
          end
          else
            FValidData := True;

          XmlDoc.SetProperty('SelectionLanguage', 'XPath');
          ns := Format('xmlns:a=%s', [QuotedStr('http://schemas.microsoft.com/developer/msbuild/2003')]);
          XmlDoc.SetProperty('SelectionNamespaces', ns);

          Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:Config');
          if not VarIsClear(Node) then
            FDefaultConfiguration := Node.Text;

          Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:FrameworkType');
          if not VarIsClear(Node) then
            FFrameworkType := Node.Text;

          Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:ProjectGuid');
          if not VarIsClear(Node) then
            FGUID := Node.Text;

          Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:AppType');
          if not VarIsClear(Node) then
            FAppType := Node.Text;

          Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:Platform');
          if not VarIsClear(Node) then
            FDefaultPlatForm := Node.Text;

          Nodes := XmlDoc.selectNodes('//a:Project/a:ProjectExtensions/a:BorlandProject/a:Platforms/a:Platform');
          lNodes := Nodes.Length;
          for i := 0 to lNodes - 1 do
            if SameText(Nodes.Item(i).Text, 'True') then
              FTargetPlatforms.Add(Nodes.Item(i).getAttribute('value'));

          Nodes := XmlDoc.selectNodes('//a:Project/a:ItemGroup/a:BuildConfiguration');
          lNodes := Nodes.Length;
          for i := 0 to lNodes - 1 do
            if not SameText(Nodes.Item(i).getAttribute('Include'), 'Base') then
              FBuildConfigurations.Add(Nodes.Item(i).getAttribute('Include'));

        finally
          XmlDoc := Unassigned;
        end;
      finally
        CoUninitialize;
      end;
      break;
    end;
end;

function GetDelphiVersions(const ProjectFile: string): SetDelphiVersions;
var
  sVersion, ns, ProjectExt, ProjectPath: string;
  XmlDoc: OleVariant;
  Node: OleVariant;
begin
  SetLength(Result, 0);
  CoInitialize(nil);
  try
    ProjectExt := ExtractFileExt(ProjectFile);
    ProjectPath := ExtractFilePath(ProjectFile);
    if SameText(ProjectExt, '.dproj') then
    begin
      XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
      try
        XmlDoc.Async := False;
        XmlDoc.Load(ProjectFile);
        XmlDoc.SetProperty('SelectionLanguage', 'XPath');
        ns := Format('xmlns:a=%s', [QuotedStr('http://schemas.microsoft.com/developer/msbuild/2003')]);
        XmlDoc.SetProperty('SelectionNamespaces', ns);

        if (XmlDoc.parseError.errorCode <> 0) then
          Exit; // raise Exception.CreateFmt('Error in Xml Data %s', [XmlDoc.parseError]);

        Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:ProjectVersion');
        if not VarIsClear(Node) then
        begin
          sVersion := Node.Text;
          if MatchText(sVersion, ['17.0', '17.1', '17.2']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE8))
          else if MatchText(sVersion, ['16.0', '16.1']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE7))
          else if MatchText(sVersion, ['15.4']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE6))
          //else if MatchText(sVersion, ['15.2']) then
          //  Exit(TArray<TDelphiVersions>.Create(Appmethod113))
          else if MatchText(sVersion, ['15.3', '15.1', '15.0']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE5))
          else if MatchText(sVersion, ['14.6']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE4))
          else if MatchText(sVersion, ['14.3', '14.4']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE3))
          else if MatchText(sVersion, ['13.4']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE2))
          else if MatchText(sVersion, ['12.2', '12.3']) then
            Exit(TArray<TDelphiVersions>.Create(DelphiXE))
          else if MatchText(sVersion, ['12.0']) then
            Exit(TArray<TDelphiVersions>.Create(Delphi2009, Delphi2010));
        end
        else
        begin
          Exit(TArray<TDelphiVersions>.Create(Delphi2007))
        end;
      finally
        XmlDoc := Unassigned;
      end;
    end
    else if SameText(ProjectExt, '.bdsproj') then
      Exit(TArray<TDelphiVersions>.Create(Delphi2005, Delphi2006))
  finally
    CoUninitialize;
  end;
end;

{$IFDEF DELPHI_OLDER_VERSIONS_SUPPORT}

function DelphiIsOldVersion(DelphiVersion: TDelphiVersions): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to DelphiOldVersions - 1 do
    if DelphiVersion = DelphiOldVersionNumbers[i] then
    begin
      Result := True;
      Exit;
    end;
end;

function GetIndexClosestColor(AColor: TColor): Integer;
var
  SqrDist, SmallSqrDist: double;
  i, R1, G1, B1, R2, G2, B2: Integer;
begin
  Result := 0;
  SmallSqrDist := Sqrt(SQR(255) * 3);
  R1 := GetRValue(AColor);
  G1 := GetGValue(AColor);
  B1 := GetBValue(AColor);

  for i := 0 to DelphiOldColorsCount - 1 do
  begin
    R2 := GetRValue(DelphiOldColorsList[i]);
    G2 := GetGValue(DelphiOldColorsList[i]);
    B2 := GetBValue(DelphiOldColorsList[i]);
    SqrDist := Sqrt(SQR(R1 - R2) + SQR(G1 - G2) + SQR(B1 - B2));
    if SqrDist < SmallSqrDist then
    begin
      Result := i;
      SmallSqrDist := SqrDist;
    end
  end
end;

{$ENDIF}

procedure ReplaceColor(ABitmap: TBitmap; SourceColor, TargetColor: TColor);
type
  TRGBBytes = array [0 .. 2] of Byte;
var
  i: Integer;
  X: Integer;
  Y: Integer;
  Size: Integer;
  Pixels: PByteArray;
  LSourceColor: TRGBBytes;
  LTargetColor: TRGBBytes;
const
  TripleSize = SizeOf(TRGBBytes);
begin
  case ABitmap.PixelFormat of
    pf24bit:
      Size := SizeOf(TRGBTriple);
    pf32bit:
      Size := SizeOf(TRGBQuad);
  else
    Exit;
  end;

  for i := 0 to TripleSize - 1 do
  begin
    LSourceColor[i] := Byte(SourceColor shr (16 - (i * 8)));
    LTargetColor[i] := Byte(TargetColor shr (16 - (i * 8)));
  end;

  for Y := 0 to ABitmap.Height - 1 do
  begin
    Pixels := ABitmap.ScanLine[Y];
    for X := 0 to ABitmap.Width - 1 do
      if CompareMem(@Pixels[(X * Size)], @LSourceColor, TripleSize) then
        Move(LTargetColor, Pixels[(X * Size)], TripleSize);
  end;
end;

procedure MakeBitmapMenuTransparent(ABitmap: TBitmap);
var
  ColorLeftCorner, ColorBackMenu: TColor;
begin
  ColorBackMenu := GetSysColor(COLOR_MENU);
  ColorLeftCorner := ABitmap.Canvas.Pixels[0, 0];
  ReplaceColor(ABitmap, ColorLeftCorner, ColorBackMenu);
end;

function GetListInstalledDelphiVersions: TInstalledDelphiVerions;
Var
  Factor: double;
  VersionData: TDelphiVersionData;
  DelphiComp: TDelphiVersions;
  FileName: string;
  Found: Boolean;
  ColorLeftCorner, ColorBackMenu: TColor;
  TempBitmap: TBitmap;
  CX: Integer;
begin
  Result := TInstalledDelphiVerions.Create;
  ColorBackMenu := GetSysColor(COLOR_MENU);
  CX := GetSystemMetrics(SM_CXMENUCHECK);

  for DelphiComp := Low(TDelphiVersions) to High(TDelphiVersions) do
  begin
    Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_CURRENT_USER);
    if Found then
      Found := RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName, HKEY_CURRENT_USER) and FileExists(FileName);

    if not Found then
    begin
      Found := RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_LOCAL_MACHINE);
      if Found then
        Found := RegReadStr(DelphiRegPaths[DelphiComp], 'App', FileName, HKEY_LOCAL_MACHINE) and FileExists(FileName);
    end;

    if Found then
    begin
      VersionData := TDelphiVersionData.Create;
      VersionData.FPath := FileName;
      VersionData.FVersion := DelphiComp;
      VersionData.FName := DelphiVersionsNames[DelphiComp];
      VersionData.FIDEType := TSupportedIDEs.DelphiIDE;
      VersionData.Icon := TIcon.Create;
      ExtractIconFile(VersionData.FIcon, FileName, SHGFI_SMALLICON);

      if CX >= 16 then
      begin
        VersionData.FBitmap := Graphics.TBitmap.Create;
        ExtractBitmapFile32(VersionData.FBitmap, FileName, SHGFI_SMALLICON);
      end
      else
      begin
        TempBitmap := TBitmap.Create;
        try
          VersionData.FBitmap := Graphics.TBitmap.Create;
          ExtractBitmapFile32(TempBitmap, FileName, SHGFI_SMALLICON);
          Factor := CX / 16;
          ScaleImage32(TempBitmap, VersionData.FBitmap, Factor);
        finally
          TempBitmap.Free;
        end;
      end;

      ColorLeftCorner := VersionData.FBitmap.Canvas.Pixels[0, 0];
      ReplaceColor(VersionData.FBitmap, ColorLeftCorner, ColorBackMenu);
      Result.Add(VersionData.Version, VersionData);
    end;
  end;

end;

{ TDelphiVersionData }

constructor TDelphiVersionData.Create;
begin
  inherited;
  FBitmap := nil;
  // FBitmap13:=nil;
  FIcon := nil;
end;

destructor TDelphiVersionData.Destroy;
begin
  if FBitmap <> nil then
    FBitmap.Free;

  if FIcon <> nil then
    FIcon.Free;
  {
    if FBitmap13<>nil then
    FBitmap13.Free;
  }
  inherited;
end;

{ TPAClientProfileList }

constructor TPAClientProfileList.Create(ListDelphiVersions: TDictionary<TDelphiVersions, TDelphiVersionData>);
begin
  inherited Create;
  FListDelphiVersions := ListDelphiVersions;
  FProfiles := TObjectList<TPAClientProfile>.Create(True);
  LoadData;
end;

destructor TPAClientProfileList.Destroy;
begin
  FProfiles.Free;
  inherited;
end;

procedure TPAClientProfileList.LoadData;
var
  LDelphiVersionData: TDelphiVersionData;
  ns, sProfile, sProfilePath: string;
  XmlDoc: OleVariant;
  Node: OleVariant;
begin
  CoInitialize(nil);
  try
    for LDelphiVersionData in FListDelphiVersions.Values do
      if LDelphiVersionData.Version >= DelphiXE2 then
      begin
        sProfilePath := IncludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA)) + PAClientProfilesPaths
          [LDelphiVersionData.Version];
        for sProfile in TDirectory.GetFiles(sProfilePath, '*.profile') do
        begin
          FProfiles.Add(TPAClientProfile.Create);
          FProfiles[FProfiles.Count - 1].FName := ChangeFileExt(ExtractFileName(sProfile), '');
          FProfiles[FProfiles.Count - 1].FFileName := ExtractFileName(sProfile);
          FProfiles[FProfiles.Count - 1].FRADStudioVersion := LDelphiVersionData.Version;

          XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
          try
            XmlDoc.Async := False;
            XmlDoc.Load(sProfile);
            XmlDoc.SetProperty('SelectionLanguage', 'XPath');
            ns := Format('xmlns:a=%s', [QuotedStr('http://schemas.microsoft.com/developer/msbuild/2003')]);
            XmlDoc.SetProperty('SelectionNamespaces', ns);

            if (XmlDoc.parseError.errorCode <> 0) then
              Exit; // raise Exception.CreateFmt('Error in Xml Data %s', [XmlDoc.parseError]);

            Node := XmlDoc.selectSingleNode('/a:Project//a:PropertyGroup/a:Profile_platform');
            if not VarIsClear(Node) then
              FProfiles[FProfiles.Count - 1].FPlatform := Node.Text;

            Node := XmlDoc.selectSingleNode('/a:Project//a:PropertyGroup/a:Profile_host');
            if not VarIsClear(Node) then
              FProfiles[FProfiles.Count - 1].FHost := Node.Text;

            Node := XmlDoc.selectSingleNode('/a:Project//a:PropertyGroup/a:Profile_port');
            if not VarIsClear(Node) then
              TryStrToInt(Node.Text, FProfiles[FProfiles.Count - 1].FPort);

          finally
            XmlDoc := Unassigned;
          end;

        end;
      end;
  finally
    CoUninitialize;
  end;

end;

{ TMSBuildGroupProj }

constructor TMSBuildGroupProj.Create(const GroupProjectFile: string);
begin
  inherited Create;
  FGroupProjectFile := GroupProjectFile;
  FProjects := TObjectList<TMSBuildDProj>.Create(True);
  FValidData := False;
  if FileExists(FGroupProjectFile) then
    LoadInfo;

end;

destructor TMSBuildGroupProj.Destroy;
begin
  FProjects.Free;
  inherited;
end;

function PathCanonicalize(lpszDst: PChar; lpszSrc: PChar): LongBool; stdcall;
  external 'shlwapi.dll' name 'PathCanonicalizeW';

function GetAbsolutePath(const RelativePath, BasePath: string): string;
var
  lpszDst: array [0 .. MAX_PATH - 1] of char;
begin
  PathCanonicalize(@lpszDst[0], PChar(IncludeTrailingPathDelimiter(BasePath) + RelativePath));
  Result := lpszDst;
end;

procedure TMSBuildGroupProj.LoadInfo;
var
  ns: string;
  XmlDoc: OleVariant;
  Nodes, Node: OleVariant;
  i, lNodes: Integer;
  DProjectFileName: string;
begin
  CoInitialize(nil);
  try
    XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
    try
      XmlDoc.Async := False;
      XmlDoc.Load(FGroupProjectFile);

      if (XmlDoc.parseError.errorCode <> 0) then
      begin
        FValidData := False;
        Exit;
      end
      else
        FValidData := True;

      XmlDoc.SetProperty('SelectionLanguage', 'XPath');
      ns := Format('xmlns:a=%s', [QuotedStr('http://schemas.microsoft.com/developer/msbuild/2003')]);
      XmlDoc.SetProperty('SelectionNamespaces', ns);

      Node := XmlDoc.selectSingleNode('/a:Project/a:PropertyGroup/a:ProjectGuid');
      if not VarIsClear(Node) then
        FGUID := Node.Text;

      Nodes := XmlDoc.selectNodes('//a:Project/a:ItemGroup/a:Projects');
      lNodes := Nodes.Length;
      for i := 0 to lNodes - 1 do
      begin
        DProjectFileName := GetAbsolutePath(Nodes.Item(i).getAttribute('Include'), ExtractFilePath(FGroupProjectFile));
        FProjects.Add(TMSBuildDProj.Create(DProjectFileName));
        if (i = 0) and (FProjects[0].ValidData) then
          FDelphiVersion := FProjects[0].DelphiVersion;
      end;

    finally
      XmlDoc := Unassigned;
    end;
  finally
    CoUninitialize;
  end;

end;

{ TInstalledDelphiVerions }

function TInstalledDelphiVerions.GetValuesSorted: TArray<TDelphiVersionData>;
begin
  Result := Values.ToArray;
  TArray.Sort<TDelphiVersionData>(Result, TComparer<TDelphiVersionData>.Construct(
    function(const L, R: TDelphiVersionData): Integer
    begin
      if L.Version = R.Version then
        Result := 0
      else if L.Version < R.Version then
        Result := -1
      else
        Result := 1;
    end));
end;

end.
