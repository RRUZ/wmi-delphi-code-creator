{**************************************************************************************************}
{                                                                                                  }
{ Unit uSelectCompilerVersion                                                                      }
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
{ The Original Code is uSelectCompilerVersion.pas.                                                 }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

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
    { Private declarations }
  public
    { Public declarations }
    procedure LoadInstalledVersions;
    property LanguageSource: TSourceLanguages Read FLanguageSource Write FLanguageSource;
    property ShowCompiler: boolean Read FShowCompiler Write FShowCompiler;
    property Show64BitsCompiler: boolean Read FShow64BitsCompiler Write FShow64BitsCompiler;
  end;


implementation

{$R *.dfm}

uses
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
  item:     TListItem;
  DelphiComp: TDelphiVersions;
  BorlandCppComp: TBorlandCppVersions;
  CSharpComp : TDotNetVersions;

  FileName: string;
  ImageIndex: integer;
  RootKey: HKEY;


  procedure  RegisterVSIDE;
  begin
    if IsVS2008Installed then
    begin
      FileName := GetVS2008IDEFileName;
      item     := ListViewIDEs.Items.Add;
      item.Caption := 'Visual Studio 2008';
      item.SubItems.Add(FileName);
      item.SubItems.Add(GetVS2008CompilerFileName);
      ExtractIconFileToImageList(ImageList1, Filename);
      ImageIndex := ImageList1.Count - 1;
      item.ImageIndex := ImageIndex;
      item.Data := Pointer(Ord(FLanguageSource));
    end;

    if IsVS2010Installed then
    begin
      FileName := GetVS2010IDEFileName;
      item     := ListViewIDEs.Items.Add;
      item.Caption := 'Visual Studio 2010';
      item.SubItems.Add(FileName);
      item.SubItems.Add(GetVS2010CompilerFileName);
      ExtractIconFileToImageList(ImageList1, Filename);
      ImageIndex := ImageList1.Count - 1;
      item.ImageIndex := ImageIndex;
      item.Data := Pointer(Ord(FLanguageSource));
    end;

    if IsVS11Installed then
    begin
      FileName := GetVS11IDEFileName;
      item     := ListViewIDEs.Items.Add;
      item.Caption := 'Visual Studio 11';
      item.SubItems.Add(FileName);
      item.SubItems.Add(GetVS11CompilerFileName);
      ExtractIconFileToImageList(ImageList1, Filename);
      ImageIndex := ImageList1.Count - 1;
      item.ImageIndex := ImageIndex;
      item.Data := Pointer(Ord(FLanguageSource));
    end;
  end;

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
            item := ListViewIDEs.Items.Add;
            item.Caption := DelphiVersionsNames[DelphiComp];
            item.SubItems.Add(FileName);
            item.SubItems.Add(ExtractFilePath(FileName) + 'Dcc32.exe');
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            item.ImageIndex := ImageIndex;
            item.Data := Pointer(Ord(Lng_Delphi));

            if (DelphiComp>=DelphiXE2) and FShow64BitsCompiler then
            begin
              item := ListViewIDEs.Items.Add;
              item.Caption := DelphiVersionsNames[DelphiComp] +' 64 Bits Compiler';
              item.SubItems.Add(FileName);
              item.SubItems.Add(ExtractFilePath(FileName) + 'Dcc64.exe');
              ExtractIconFileToImageList(ImageList1, Filename);
              ImageIndex := ImageList1.Count - 1;
              item.ImageIndex := ImageIndex;
              item.Data := Pointer(Ord(Lng_Delphi));
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
            item := ListViewIDEs.Items.Add;
            item.Caption := BorlandCppVersionsNames[BorlandCppComp];
            item.SubItems.Add(FileName);
            item.SubItems.Add(ExtractFilePath(FileName) + 'bcc32.exe');
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            item.ImageIndex := ImageIndex;
            item.Data := Pointer(Ord(Lng_BorlandCpp));
          end;
      end;

    end;

    Lng_CSharp:
    begin

      RegisterVSIDE;

      if ShowCompiler then
      for CSharpComp :=Low(TDotNetVersions) to High(TDotNetVersions) do
      begin
        FileName:=IncludeTrailingPathDelimiter(NetFrameworkPath(CSharpComp))+'csc.exe';
        if FileExists(FileName) then
        begin
          item := ListViewIDEs.Items.Add;
          item.Caption := DotNetNames[CSharpComp];
          item.SubItems.Add(ExtractFilePath(FileName) );
          item.SubItems.Add(FileName);
          ExtractIconFileToImageList(ImageList1, Filename);
          ImageIndex := ImageList1.Count - 1;
          item.ImageIndex := ImageIndex;
          item.Data := Pointer(Ord(CSharpComp));
        end;
      end;

    end;


    Lng_FPC:
    begin
      if IsLazarusInstalled then
      begin
        FileName := GetLazarusIDEFileName;
        item     := ListViewIDEs.Items.Add;
        item.Caption := 'Lazarus';
        item.SubItems.Add(FileName);
        item.SubItems.Add(GetLazarusCompilerFileName);
        ExtractIconFileToImageList(ImageList1, Filename);
        ImageIndex := ImageList1.Count - 1;
        item.ImageIndex := ImageIndex;
        item.Data := Pointer(Ord(Lng_FPC));
      end;
    end;

    Lng_VSCpp  :
                begin
                  RegisterVSIDE;

                  if ShowCompiler then
                  begin
                    FileName :=GetMicrosoftCppCompiler2008;
                    if FileExists(FileName) then
                    begin
                      item     := ListViewIDEs.Items.Add;
                      item.Caption := 'Microsoft C++ Compiler '+uMisc.GetFileVersion(FileName);
                      item.SubItems.Add(FileName);
                      item.SubItems.Add(FileName);
                      ExtractIconFileToImageList(ImageList1, Filename);
                      ImageIndex := ImageList1.Count - 1;
                      item.ImageIndex := ImageIndex;
                      item.Data := Pointer(Ord(Lng_VSCpp));
                    end;

                    FileName :=GetMicrosoftCppCompiler2010;
                    if FileExists(FileName) then
                    begin
                      item     := ListViewIDEs.Items.Add;
                      item.Caption := 'Microsoft C++ Compiler '+uMisc.GetFileVersion(FileName);
                      item.SubItems.Add(FileName);
                      item.SubItems.Add(FileName);
                      ExtractIconFileToImageList(ImageList1, Filename);
                      ImageIndex := ImageList1.Count - 1;
                      item.ImageIndex := ImageIndex;
                      item.Data := Pointer(Ord(Lng_VSCpp));
                    end;

                    FileName :=GetMicrosoftCppCompiler11;
                    if FileExists(FileName) then
                    begin
                      item     := ListViewIDEs.Items.Add;
                      item.Caption := 'Microsoft C++ Compiler '+uMisc.GetFileVersion(FileName);
                      item.SubItems.Add(FileName);
                      item.SubItems.Add(FileName);
                      ExtractIconFileToImageList(ImageList1, Filename);
                      ImageIndex := ImageList1.Count - 1;
                      item.ImageIndex := ImageIndex;
                      item.Data := Pointer(Ord(Lng_VSCpp));
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
          item     := ListViewIDEs.Items.Add;
          item.Caption := 'Oxygene';
          item.SubItems.Add(FileName);
          item.SubItems.Add(FileName);
          ExtractIconFileToImageList(ImageList1, Filename);
          //ExtractIconFileToImageList(ImageList1,ExtractFilePath(ParamStr(0))+'Extras\MonoDevelop.ico');
          ImageIndex := ImageList1.Count - 1;
          item.ImageIndex := ImageIndex;
          item.Data := Pointer(Ord(Lng_Oxygen));
        end
        else
        begin
          if IsMonoDevelopInstalled and
            IsDelphiPrismAttachedtoMonoDevelop then
          begin
            FileName := GetMonoDevelopIDEFileName;
            item     := ListViewIDEs.Items.Add;
            item.Caption := 'MonoDevelop';
            item.SubItems.Add(FileName);
            item.SubItems.Add(GetDelphiPrismCompilerFileName);
            //ExtractIconFileToImageList(ImageList1,Filename);
            ExtractIconFileToImageList(
              ImageList1, ExtractFilePath(ParamStr(0)) + 'Extras\MonoDevelop.ico');
            ImageIndex := ImageList1.Count - 1;
            item.ImageIndex := ImageIndex;
            item.Data := Pointer(Ord(Lng_Oxygen));
          end;

          if IsVS2008Installed and
            IsDelphiPrismAttachedtoVS2008 then
          begin
            FileName := GetVS2008IDEFileName;
            item     := ListViewIDEs.Items.Add;
            item.Caption := 'Visual Studio 2008';
            item.SubItems.Add(FileName);
            item.SubItems.Add(GetDelphiPrismCompilerFileName);
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            item.ImageIndex := ImageIndex;
            item.Data := Pointer(Ord(Lng_Oxygen));
          end;

          if IsVS2010Installed and
            IsDelphiPrismAttachedtoVS2010 then
          begin
            FileName := GetVS2010IDEFileName;
            item     := ListViewIDEs.Items.Add;
            item.Caption := 'Visual Studio 2010';
            item.SubItems.Add(FileName);
            item.SubItems.Add(GetDelphiPrismCompilerFileName);
            ExtractIconFileToImageList(ImageList1, Filename);
            ImageIndex := ImageList1.Count - 1;
            item.ImageIndex := ImageIndex;
            item.Data := Pointer(Ord(Lng_Oxygen));
          end;

        end;

      end;

    end;
  end;

  if ListViewIDEs.Items.Count>0 then
   ListViewIDEs.Items.Item[0].Selected:=True;
end;

end.
