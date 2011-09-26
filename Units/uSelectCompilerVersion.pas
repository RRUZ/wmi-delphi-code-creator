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
  Dialogs, StdCtrls, ImgList, ComCtrls;

type
  TCompilerType = (Ct_Delphi, Ct_Lazarus_FPC, Ct_Oxygene);

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
    FCompilerType: TCompilerType;
    FShowCompiler: boolean;
    FShow64BitsCompiler: boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure LoadInstalledVersions;
    property CompilerType: TCompilerType Read FCompilerType Write FCompilerType;
    property ShowCompiler: boolean Read FShowCompiler Write FShowCompiler;
    property Show64BitsCompiler: boolean Read FShow64BitsCompiler Write FShow64BitsCompiler;
  end;

const
  ListCompilerType: array[TCompilerType] of string = ('Delphi', 'Lazarus', 'Oxygene');

implementation

{$R *.dfm}

uses
  uRegistry,
  uLazarusIDE,
  uDelphiIDE,
  uDelphiVersions,
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
  LabelText.Caption := Format('%s compilers installed', [ListCompilerType[FCompilerType]]);
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
  FileName: string;
  ImageIndex: integer;
begin
  case FCompilerType of
    Ct_Delphi:
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
            item.Data := Pointer(Ord(Ct_Delphi));

            if (DelphiComp>=DelphiXE2) and FShow64BitsCompiler then
            begin
              item := ListViewIDEs.Items.Add;
              item.Caption := DelphiVersionsNames[DelphiComp] +' 64 Bits Compiler';
              item.SubItems.Add(FileName);
              item.SubItems.Add(ExtractFilePath(FileName) + 'Dcc64.exe');
              ExtractIconFileToImageList(ImageList1, Filename);
              ImageIndex := ImageList1.Count - 1;
              item.ImageIndex := ImageIndex;
              item.Data := Pointer(Ord(Ct_Delphi));
            end;

          end;

    end;
    Ct_Lazarus_FPC:
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
        item.Data := Pointer(Ord(Ct_Lazarus_FPC));
      end;
    end;

    Ct_Oxygene:
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
          item.Data := Pointer(Ord(Ct_Oxygene));
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
            item.Data := Pointer(Ord(Ct_Oxygene));
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
            item.Data := Pointer(Ord(Ct_Oxygene));
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
            item.Data := Pointer(Ord(Ct_Oxygene));
          end;

        end;

      end;

    end;
  end;

  if ListViewIDEs.Items.Count>0 then
   ListViewIDEs.Items.Item[0].Selected:=True;
end;

end.
