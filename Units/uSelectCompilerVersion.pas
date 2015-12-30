//**************************************************************************************************
//
// Unit uSelectCompilerVersion
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
// The Original Code is uSelectCompilerVersion.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2015 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************


unit uSelectCompilerVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, uWmiGenCode;


type
  TFrmSelCompilerVer = class(TForm)
    LabelText:    TLabel;
    ButtonOk:     TButton;
    ButtonCancel: TButton;
    ImageList1:   TImageList;
    ListViewIDEs: TListView;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListViewIDEsDblClick(Sender: TObject);
    procedure ListViewIDEsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FLanguageSource: TSourceLanguages;
    FShowCompiler: boolean;
    FShow64BitsCompiler: boolean;
  public
    procedure LoadInstalledVersions;
    property LanguageSource: TSourceLanguages Read FLanguageSource Write FLanguageSource;
    property ShowCompiler: boolean Read FShowCompiler Write FShowCompiler;
    property Show64BitsCompiler: boolean Read FShow64BitsCompiler Write FShow64BitsCompiler;
  end;


implementation

{$R *.dfm}

uses
  System.Generics.Collections,
  uMisc,
  uVisualStudio,
  uRegistry,
  uDotNetFrameWork,
  uLazarusIDE,
  uDelphiIDE,
  uDelphiVersions,
  uBorlandCppVersions,
  CommCtrl,
  ShellAPI,
  uDelphiPrismIDE;

procedure ExtractIconFileToImageList(ImageList: TImageList; const Filename: string);
var
  FileInfo: TShFileInfo;
begin
  if FileExists(Filename) then
  begin
    FillChar(FileInfo, SizeOf(FileInfo), 0);
    SHGetFileInfo(PChar(Filename), 0, FileInfo, SizeOf(FileInfo),
      SHGFI_ICON or SHGFI_SMALLICON);
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
  FShow64BitsCompiler :=True;
end;

procedure TFrmSelCompilerVer.ListViewIDEsDblClick(Sender: TObject);
begin
  ButtonOk.Click;
end;

procedure TFrmSelCompilerVer.ListViewIDEsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  ButtonOk.Enabled:=Selected;
end;

procedure TFrmSelCompilerVer.LoadInstalledVersions;
var
  LItem:     TListItem;
  DelphiComp: TDelphiVersions;
  BorlandCppComp: TBorlandCppVersions;
  CSharpComp : TDotNetVersions;

  FileName: string;
  ImageIndex: integer;
  RootKey: HKEY;

  LVisualStudioInfo : TVisualStudioInfo;
  LVSVersion  : TVSVersion;
  LVSIDEList  : TObjectList<TVisualStudioInfo>;
  i : Integer;


begin
  case FLanguageSource of

    Lng_Delphi:
    begin
      for DelphiComp :=
        Low(TDelphiVersions) to High(TDelphiVersions) do
        if RegKeyExists(DelphiRegPaths[DelphiComp],
          HKEY_CURRENT_USER) then
          if RegReadStr(DelphiRegPaths[DelphiComp],
            'App', FileName, HKEY_CURRENT_USER) and FileExists(FileName) then
          begin
            LItem := ListViewIDEs.Items.Add;
            LItem.Caption := DelphiVersionsNames[DelphiComp];
            LItem.SubItems.Add(FileName);
            LItem.SubItems.Add(ExtractFilePath(FileName) + 'Dcc32.exe');
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            LItem.ImageIndex := ImageIndex;
            LItem.Data := Pointer(Ord(Lng_Delphi));

            if (DelphiComp>=DelphiXE2) and FShow64BitsCompiler then
            begin
              LItem := ListViewIDEs.Items.Add;
              LItem.Caption := DelphiVersionsNames[DelphiComp] +' 64 Bits Compiler';
              LItem.SubItems.Add(FileName);
              LItem.SubItems.Add(ExtractFilePath(FileName) + 'Dcc64.exe');
              ExtractIconFileToImageList(ImageList1, Filename);
              ImageIndex := ImageList1.Count - 1;
              LItem.ImageIndex := ImageIndex;
              LItem.Data := Pointer(Ord(Lng_Delphi));
            end;

          end;
    end;

    Lng_BorlandCpp:
    begin
      for BorlandCppComp :=Low(TBorlandCppVersions) to High(TBorlandCppVersions) do
      begin
        RootKey:=HKEY_CURRENT_USER;
        if not (RegReadStr(BorlandCppRegPaths[BorlandCppComp],'App', FileName, RootKey) and FileExists(FileName)) then
          RootKey:=HKEY_LOCAL_MACHINE;

          if RegReadStr(BorlandCppRegPaths[BorlandCppComp],
            'App', FileName, RootKey) and FileExists(FileName) then
          begin
            LItem := ListViewIDEs.Items.Add;
            LItem.Caption := BorlandCppVersionsNames[BorlandCppComp];
            LItem.SubItems.Add(FileName);
            LItem.SubItems.Add(ExtractFilePath(FileName) + 'bcc32.exe');
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            LItem.ImageIndex := ImageIndex;
            LItem.Data := Pointer(Ord(Lng_BorlandCpp));
          end;
      end;

    end;

    Lng_CSharp:
    begin
      LVSIDEList:=GetVSIDEList;

      for i:=0 to LVSIDEList.Count-1 do
      if LVSIDEList[i].CSharpInstalled then
      begin
        LItem     := ListViewIDEs.Items.Add;
        Filename := LVSIDEList[i].IDEFileName;
        LItem.Caption := LVSIDEList[i].IDEDescription;
        LItem.SubItems.Add(FileName);
        LItem.SubItems.Add(LVSIDEList[i].CompilerFileName);
        ExtractIconFileToImageList(ImageList1, Filename);
        ImageIndex := ImageList1.Count - 1;
        LItem.ImageIndex := ImageIndex;
        LItem.Data := Pointer(LVSIDEList[i]);
      end;

      if ShowCompiler then
      for CSharpComp :=Low(TDotNetVersions) to High(TDotNetVersions) do
      begin
        FileName:=IncludeTrailingPathDelimiter(NetFrameworkPath(CSharpComp))+'csc.exe';
        if FileExists(FileName) then
        begin
          LItem := ListViewIDEs.Items.Add;
          LItem.Caption := DotNetNames[CSharpComp];
          LItem.SubItems.Add(ExtractFilePath(FileName) );
          LItem.SubItems.Add(FileName);
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
        FileName := GetLazarusIDEFileName;
        LItem     := ListViewIDEs.Items.Add;
        LItem.Caption := 'Lazarus';
        LItem.SubItems.Add(FileName);
        LItem.SubItems.Add(GetLazarusCompilerFileName);
        ExtractIconFileToImageList(ImageList1, Filename);
        ImageIndex := ImageList1.Count - 1;
        LItem.ImageIndex := ImageIndex;
        LItem.Data := Pointer(Ord(Lng_FPC));
      end;
    end;

    Lng_VSCpp  :
    begin
      LVSIDEList:=GetVSIDEList;
      for i:=0 to LVSIDEList.Count-1 do
      if LVSIDEList[i].CPPInstalled then
      begin
        LItem     := ListViewIDEs.Items.Add;
        Filename := LVSIDEList[i].IDEFileName;
        LItem.Caption := LVSIDEList[i].IDEDescription;
        LItem.SubItems.Add(FileName);
        LItem.SubItems.Add(LVSIDEList[i].CompilerFileName);
        ExtractIconFileToImageList(ImageList1, Filename);
        ImageIndex := ImageList1.Count - 1;
        LItem.ImageIndex := ImageIndex;
        LItem.Data := Pointer(LVSIDEList[i]);
      end;

      if ShowCompiler then
      begin
        LVSIDEList := GetVSIDEList;
        for i:=0 to LVSIDEList.Count-1 do
        begin
          FileName :=LVSIDEList[i].CppCompiler;
          if FileExists(FileName) then
          begin
            LItem     := ListViewIDEs.Items.Add;
            LItem.Caption := 'Microsoft C++ Compiler '+uMisc.GetFileVersion(FileName);
            LItem.SubItems.Add(FileName);
            LItem.SubItems.Add(FileName);
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
          FileName := GetDelphiPrismCompilerFileName;
          LItem     := ListViewIDEs.Items.Add;
          LItem.Caption := 'Oxygene';
          LItem.SubItems.Add(FileName);
          LItem.SubItems.Add(FileName);
          ExtractIconFileToImageList(ImageList1, Filename);
          //ExtractIconFileToImageList(ImageList1,ExtractFilePath(ParamStr(0))+'Extras\MonoDevelop.ico');
          ImageIndex := ImageList1.Count - 1;
          LItem.ImageIndex := ImageIndex;
          LItem.Data := Pointer(Ord(Lng_Oxygen));
        end
        else
        begin
//          if IsMonoDevelopInstalled and
//            IsDelphiPrismAttachedtoMonoDevelop then
//          begin
//            FileName := GetMonoDevelopIDEFileName;
//            item     := ListViewIDEs.Items.Add;
//            item.Caption := 'MonoDevelop';
//            item.SubItems.Add(FileName);
//            item.SubItems.Add(GetDelphiPrismCompilerFileName);
//            //ExtractIconFileToImageList(ImageList1,Filename);
//            ExtractIconFileToImageList(
//              ImageList1, ExtractFilePath(ParamStr(0)) + 'Extras\MonoDevelop.ico');
//            ImageIndex := ImageList1.Count - 1;
//            item.ImageIndex := ImageIndex;
//            item.Data := Pointer(Ord(Lng_Oxygen));
//          end;


          LVSIDEList := GetVSIDEList;
          for i:=0 to LVSIDEList.Count-1 do
          if RegKeyExists(LVSIDEList[i].BaseRegistryKey + 'InstalledProducts\RemObjects Oxygene', HKEY_LOCAL_MACHINE) then
          begin
            FileName := LVSIDEList[i].IDEFileName;
            LItem     := ListViewIDEs.Items.Add;
            LItem.Caption := LVSIDEList[i].IDEDescription;
            LItem.SubItems.Add(FileName);
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

  if ListViewIDEs.Items.Count>0 then
   ListViewIDEs.Items.Item[0].Selected:=True;
end;


end.
