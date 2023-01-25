// **************************************************************************************************
//
// Unit WDCC.SelectCompilerVersion
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
// The Original Code is WDCC.SelectCompilerVersion.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.SelectCompilerVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, WDCC.WMI.GenCode, System.ImageList;

type
  TFrmSelCompilerVer = class(TForm)
    LabelText: TLabel;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    ImageList1: TImageList;
    ListViewIDEs: TListView;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewIDEsDblClick(Sender: TObject);
    procedure ListViewIDEsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
  private
    FLanguageSource: TSourceLanguages;
    FShowCompiler: Boolean;
    FShow64BitsCompiler: Boolean;
  public
    procedure LoadInstalledVersions;
    property LanguageSource: TSourceLanguages Read FLanguageSource Write FLanguageSource;
    property ShowCompiler: Boolean Read FShowCompiler Write FShowCompiler;
    property Show64BitsCompiler: Boolean Read FShow64BitsCompiler Write FShow64BitsCompiler;
  end;

implementation

{$R *.dfm}

uses
  System.Generics.Collections,
  WDCC.Misc,
  WDCC.VisualStudio,
  WDCC.Registry,
  WDCC.DotNetFrameWork,
  WDCC.Lazarus.IDE,
  WDCC.Delphi.IDE,
  WDCC.Delphi.Versions,
  WDCC.Borland.Cpp.Versions,
  CommCtrl,
  ShellAPI,
  WDCC.DelphiPrism.IDE;

procedure ExtractIconFileToImageList(ImageList: TImageList; const Filename: string);
var
  FileInfo: TShFileInfo;
begin
  if FileExists(Filename) then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    SHGetFileInfo(PChar(Filename), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON or SHGFI_SMALLICON);
    if FileInfo.hIcon <> 0 then
    begin
      ImageList_AddIcon(ImageList.Handle, FileInfo.hIcon);
      DestroyIcon(FileInfo.hIcon);
    end;
  end;
end;

{ TFrmSelDelphiVer }

procedure TFrmSelCompilerVer.FormActivate(Sender: TObject);
begin
  LabelText.Caption := Format('%s compilers installed', [ListSourceLanguages[FLanguageSource]]);
end;

procedure TFrmSelCompilerVer.FormCreate(Sender: TObject);
begin
  FShowCompiler := False;
  FShow64BitsCompiler := True;
end;

procedure TFrmSelCompilerVer.ListViewIDEsDblClick(Sender: TObject);
begin
  ButtonOk.Click;
end;

procedure TFrmSelCompilerVer.ListViewIDEsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  ButtonOk.Enabled := Selected;
end;

procedure TFrmSelCompilerVer.LoadInstalledVersions;
var
  LItem: TListItem;
  DelphiComp: TDelphiVersions;
  BorlandCppComp: TBorlandCppVersions;
  CSharpComp: TDotNetVersions;

  Filename: string;
  ImageIndex: integer;
  RootKey: HKEY;

  //LVisualStudioInfo: TVisualStudioInfo;
  LVSIDEList: TObjectList<TVisualStudioInfo>;
  i: integer;

begin
  case FLanguageSource of

    Lng_Delphi:
      begin
        for DelphiComp := Low(TDelphiVersions) to High(TDelphiVersions) do
          if RegKeyExists(DelphiRegPaths[DelphiComp], HKEY_CURRENT_USER) then
            if RegReadStr(DelphiRegPaths[DelphiComp], 'App', Filename, HKEY_CURRENT_USER) and FileExists(Filename) then
            begin
              LItem := ListViewIDEs.Items.Add;
              LItem.Caption := DelphiVersionsNames[DelphiComp];
              LItem.SubItems.Add(Filename);
              LItem.SubItems.Add(ExtractFilePath(Filename) + 'Dcc32.exe');
              ExtractIconFileToImageList(ImageList1, Filename);
              ImageIndex := ImageList1.Count - 1;
              LItem.ImageIndex := ImageIndex;
              LItem.Data := Pointer(Ord(Lng_Delphi));

              if (DelphiComp >= DelphiXE2) and FShow64BitsCompiler then
              begin
                LItem := ListViewIDEs.Items.Add;
                LItem.Caption := DelphiVersionsNames[DelphiComp] + ' 64 Bits Compiler';
                LItem.SubItems.Add(Filename);
                LItem.SubItems.Add(ExtractFilePath(Filename) + 'Dcc64.exe');
                ExtractIconFileToImageList(ImageList1, Filename);
                ImageIndex := ImageList1.Count - 1;
                LItem.ImageIndex := ImageIndex;
                LItem.Data := Pointer(Ord(Lng_Delphi));
              end;

            end;
      end;

    Lng_BorlandCpp:
      begin
        for BorlandCppComp := Low(TBorlandCppVersions) to High(TBorlandCppVersions) do
        begin
          RootKey := HKEY_CURRENT_USER;
          if not(RegReadStr(BorlandCppRegPaths[BorlandCppComp], 'App', Filename, RootKey) and FileExists(Filename)) then
            RootKey := HKEY_LOCAL_MACHINE;

          if RegReadStr(BorlandCppRegPaths[BorlandCppComp], 'App', Filename, RootKey) and FileExists(Filename) then
          begin
            LItem := ListViewIDEs.Items.Add;
            LItem.Caption := BorlandCppVersionsNames[BorlandCppComp];
            LItem.SubItems.Add(Filename);
            LItem.SubItems.Add(ExtractFilePath(Filename) + 'bcc32.exe');
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            LItem.ImageIndex := ImageIndex;
            LItem.Data := Pointer(Ord(Lng_BorlandCpp));
          end;
        end;

      end;

    Lng_CSharp:
      begin
        LVSIDEList := GetVSIDEList;

        for i := 0 to LVSIDEList.Count - 1 do
          if LVSIDEList[i].CSharpInstalled then
          begin
            LItem := ListViewIDEs.Items.Add;
            Filename := LVSIDEList[i].IDEFileName;
            LItem.Caption := LVSIDEList[i].IDEDescription;
            LItem.SubItems.Add(Filename);
            LItem.SubItems.Add(LVSIDEList[i].CompilerFileName);
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            LItem.ImageIndex := ImageIndex;
            LItem.Data := Pointer(LVSIDEList[i]);
          end;

        if ShowCompiler then
          for CSharpComp := Low(TDotNetVersions) to High(TDotNetVersions) do
          begin
            Filename := IncludeTrailingPathDelimiter(NetFrameworkPath(CSharpComp)) + 'csc.exe';
            if FileExists(Filename) then
            begin
              LItem := ListViewIDEs.Items.Add;
              LItem.Caption := DotNetNames[CSharpComp];
              LItem.SubItems.Add(ExtractFilePath(Filename));
              LItem.SubItems.Add(Filename);
              ExtractIconFileToImageList(ImageList1, Filename);
              ImageIndex := ImageList1.Count - 1;
              LItem.ImageIndex := ImageIndex;
              LItem.Data := Pointer(Ord(CSharpComp));
            end;
          end;

      end;

    Lng_FPC:
      begin
        if IsLazarusInstalled then
        begin
          Filename := GetLazarusIDEFileName;
          LItem := ListViewIDEs.Items.Add;
          LItem.Caption := 'Lazarus';
          LItem.SubItems.Add(Filename);
          LItem.SubItems.Add(GetLazarusCompilerFileName);
          ExtractIconFileToImageList(ImageList1, Filename);
          ImageIndex := ImageList1.Count - 1;
          LItem.ImageIndex := ImageIndex;
          LItem.Data := Pointer(Ord(Lng_FPC));
        end;
      end;

    Lng_VSCpp:
      begin
        LVSIDEList := GetVSIDEList;
        for i := 0 to LVSIDEList.Count - 1 do
          if LVSIDEList[i].CPPInstalled then
          begin
            LItem := ListViewIDEs.Items.Add;
            Filename := LVSIDEList[i].IDEFileName;
            LItem.Caption := LVSIDEList[i].IDEDescription;
            LItem.SubItems.Add(Filename);
            LItem.SubItems.Add(LVSIDEList[i].CompilerFileName);
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            LItem.ImageIndex := ImageIndex;
            LItem.Data := Pointer(LVSIDEList[i]);
          end;

        if ShowCompiler then
        begin
          LVSIDEList := GetVSIDEList;
          for i := 0 to LVSIDEList.Count - 1 do
          begin
            Filename := LVSIDEList[i].CppCompiler;
            if FileExists(Filename) then
            begin
              LItem := ListViewIDEs.Items.Add;
              LItem.Caption := 'Microsoft C++ Compiler ' + WDCC.Misc.GetFileVersion(Filename);
              LItem.SubItems.Add(Filename);
              LItem.SubItems.Add(Filename);
              ExtractIconFileToImageList(ImageList1, Filename);
              ImageIndex := ImageList1.Count - 1;
              LItem.ImageIndex := ImageIndex;
              LItem.Data := Pointer(LVSIDEList[i]);
            end;
          end;
        end;

      end;

    Lng_Oxygen:
      begin

        if IsDelphiPrismInstalled then
        begin
          if FShowCompiler then
          begin
            Filename := GetDelphiPrismCompilerFileName;
            LItem := ListViewIDEs.Items.Add;
            LItem.Caption := 'Oxygene';
            LItem.SubItems.Add(Filename);
            LItem.SubItems.Add(Filename);
            ExtractIconFileToImageList(ImageList1, Filename);
            // ExtractIconFileToImageList(ImageList1,ExtractFilePath(ParamStr(0))+'Extras\MonoDevelop.ico');
            ImageIndex := ImageList1.Count - 1;
            LItem.ImageIndex := ImageIndex;
            LItem.Data := Pointer(Ord(Lng_Oxygen));
          end
          else
          begin
            // if IsMonoDevelopInstalled and
            // IsDelphiPrismAttachedtoMonoDevelop then
            // begin
            // FileName := GetMonoDevelopIDEFileName;
            // item     := ListViewIDEs.Items.Add;
            // item.Caption := 'MonoDevelop';
            // item.SubItems.Add(FileName);
            // item.SubItems.Add(GetDelphiPrismCompilerFileName);
            // //ExtractIconFileToImageList(ImageList1,Filename);
            // ExtractIconFileToImageList(
            // ImageList1, ExtractFilePath(ParamStr(0)) + 'Extras\MonoDevelop.ico');
            // ImageIndex := ImageList1.Count - 1;
            // item.ImageIndex := ImageIndex;
            // item.Data := Pointer(Ord(Lng_Oxygen));
            // end;

            LVSIDEList := GetVSIDEList;
            for i := 0 to LVSIDEList.Count - 1 do
              if RegKeyExists(LVSIDEList[i].BaseRegistryKey + 'InstalledProducts\RemObjects Oxygene', HKEY_LOCAL_MACHINE)
              then
              begin
                Filename := LVSIDEList[i].IDEFileName;
                LItem := ListViewIDEs.Items.Add;
                LItem.Caption := LVSIDEList[i].IDEDescription;
                LItem.SubItems.Add(Filename);
                LItem.SubItems.Add(GetDelphiPrismCompilerFileName);
                ExtractIconFileToImageList(ImageList1, Filename);
                ImageIndex := ImageList1.Count - 1;
                LItem.ImageIndex := ImageIndex;
                LItem.Data := Pointer(LVSIDEList[i]);
              end;
          end;

        end;

      end;
  end;

  if ListViewIDEs.Items.Count > 0 then
    ListViewIDEs.Items.Item[0].Selected := True;
end;

end.
