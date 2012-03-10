{**************************************************************************************************}
{                                                                                                  }
{ Unit uCodeEditor                                                                                 }
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
{ The Original Code is uCodeEditor.pas.                                                            }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2012 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uCodeEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls, uSelectCompilerVersion,
  uSettings,Vcl.StdCtrls,  Vcl.ToolWin, SynHighlighterPas, SynEditHighlighter,
  SynHighlighterCpp, Vcl.ActnMenus, Vcl.ExtCtrls, uSynEditPopupEdit;

type
  //TProcWMiCodeGen = procedure (WmiMetaClassInfo : TWMiClassMetaData) of object;
  TProcWMiCodeGen = procedure of object;
  TFrmCodeEditor = class(TForm)
    PageControlCode: TPageControl;
    TabSheetWmiClassCode: TTabSheet;
    SynEditCode: TSynEdit;
    ActionManager1: TActionManager;
    ActionRun: TAction;
    ActionCompile: TAction;
    ActionSave: TAction;
    ActionFormat: TAction;
    ImageList1: TImageList;
    SynCppSyn1: TSynCppSyn;
    SynPasSyn1: TSynPasSyn;
    ActionOpenIDE: TAction;
    SaveDialog1: TSaveDialog;
    ActionToolBar1: TActionToolBar;
    PanelLanguageSet: TPanel;
    Label8: TLabel;
    ComboBoxLanguageSel: TComboBox;
    procedure ActionRunExecute(Sender: TObject);
    procedure ActionFormatExecute(Sender: TObject);
    procedure ActionFormatUpdate(Sender: TObject);
    procedure ActionOpenIDEExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxLanguageSelChange(Sender: TObject);
  private
    FCompilerType: TCompilerType;
    FSettings: TSettings;
    FConsole: TMemo;
    FCodeGenerator: TProcWMiCodeGen;
    procedure ScrollMemo(Memo : TMemo);overload;
    procedure ScrollMemo(Memo : TSynEdit);overload;
    function GetSourceCode: TStrings;
    procedure SetSourceCode(const Value: TStrings);
    procedure SetCompilerType(const Value: TCompilerType);
    procedure GenerateCode;
  public
    property CompilerType : TCompilerType read FCompilerType write SetCompilerType;
    property Settings : TSettings read FSettings write FSettings;
    property Console : TMemo read FConsole write FConsole;
    property SourceCode : TStrings read GetSourceCode write SetSourceCode;
    property CodeGenerator : TProcWMiCodeGen read FCodeGenerator write FCodeGenerator;
  end;


implementation

uses
 ShellApi,
 uWmiGenCode,
 uDelphiIDE,
 uLazarusIDE,
 uBorlandCppIDE,
 uDelphiPrismIDE,
 uDelphiPrismHelper,
 uVisualStudio,
 StrUtils,
 uMisc;

{$R *.dfm}

procedure TFrmCodeEditor.GenerateCode;
begin
  if Assigned(FCodeGenerator) then
    FCodeGenerator();
end;

function TFrmCodeEditor.GetSourceCode: TStrings;
begin
   Result:=SynEditCode.Lines;
end;

procedure TFrmCodeEditor.ScrollMemo(Memo : TMemo);
begin
  Memo.SelStart  := Memo.GetTextLen;
  Memo.SelLength := 0;
  SendMessage(Memo.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TFrmCodeEditor.ScrollMemo(Memo: TSynEdit);
begin
  Memo.SelStart  := Memo.GetTextLen;
end;

procedure TFrmCodeEditor.SetCompilerType(const Value: TCompilerType);
begin
  FCompilerType := Value;
  case FCompilerType of
    Ct_BorlandCpp,
    Ct_VSCpp   :  SynEditCode.Highlighter:=SynCppSyn1;
  else
    SynEditCode.Highlighter:=SynPasSyn1;
  end;
  if Assigned(Settings) then
    LoadCurrentTheme(Self,Settings.CurrentTheme);
end;

procedure TFrmCodeEditor.SetSourceCode(const Value: TStrings);
begin
 SynEditCode.Lines.BeginUpdate;
 try
   SynEditCode.Lines.Clear;
   SynEditCode.Lines.AddStrings(Value);
 finally
  SynEditCode.Lines.EndUpdate;
 end;
 ScrollMemo(SynEditCode);
end;

procedure TFrmCodeEditor.ActionFormatExecute(Sender: TObject);
begin
  if not FileExists(Settings.Formatter) then
    MsgWarning('Before to continue, you must set a source code formatter in the settings')
  else
  case FCompilerType of
    Ct_VSCpp,
    Ct_BorlandCpp  : FormatBorlandCppCode(Console.Lines, SourceCode, Settings.Formatter);

    Ct_Delphi,
    Ct_Lazarus_FPC : FormatDelphiCode(Console.Lines, SourceCode, Settings.Formatter);

    Ct_Oxygene     : ;
  end;
end;

procedure TFrmCodeEditor.ActionFormatUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCompilerType in [Ct_Delphi, Ct_Lazarus_FPC, Ct_BorlandCpp, Ct_VSCpp];
end;

procedure TFrmCodeEditor.ActionOpenIDEExecute(Sender: TObject);
var
  Frm: TFrmSelCompilerVer;
  item: TListItem;
  FileName: string;
  IdeName: string;
  TargetFile: string;
begin
  Frm := TFrmSelCompilerVer.Create(Self);
  try
    Frm.CompilerType := CompilerType;
    Frm.Show64BitsCompiler:=False;
    Frm.LoadInstalledVersions;
    if Frm.ListViewIDEs.Items.Count = 0 then
      MsgWarning('Does not exist a Object Pascal IDEs installed in this system')
    else
    if Frm.ShowModal = mrOk then
    begin
      item := Frm.ListViewIDEs.Selected;
      if Assigned(item) then
      begin
        IdeName := item.SubItems[0];
        FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);

        case CompilerType of
          Ct_Delphi:
          begin
            FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.dpr';
            SynEditCode.Lines.SaveToFile(FileName);
            ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;

          Ct_BorlandCpp:
          begin
            FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cpp';
            SynEditCode.Lines.SaveToFile(FileName);
            ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;

          Ct_Lazarus_FPC:
          begin
            FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.lpr';
            SynEditCode.Lines.SaveToFile(FileName);

            if CreateLazarusProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), IncludeTrailingPathDelimiter(
              ExtractFilePath(ParamStr(0))) + 'Lazarus\TemplateConsole.lpi') then
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;

          Ct_Oxygene:
          begin
            FileName := FileName + 'Program.pas';
            SynEditCode.Lines.SaveToFile(FileName);

            if StartsText('Monodevelop', item.Caption) and
              CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'Oxygene\Monodevelop\GetWMI_Info.oxygene', FileName) then
            begin
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
            end
            else
            if (Pos('2008', item.Caption) > 0) and
              CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'Oxygene\VS2008\GetWMI_Info.oxygene', FileName) then
            begin
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
            end
            else
            if (Pos('2010', item.Caption) > 0) and
              CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              'Oxygene\VS2010\GetWMI_Info.oxygene', FileName) then
            begin
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
            end;

          end;

          Ct_VSCpp:
          begin
            FileName := FileName + 'main.cpp';
            SynEditCode.Lines.SaveToFile(FileName);

            if Pos('2008', item.Caption)>0 then
             TargetFile:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Microsoft_C++\VS2008\GetWMI_Info.sln'
            else
            if Pos('2010', item.Caption)>0 then
             TargetFile:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Microsoft_C++\VS2010\GetWMI_Info.sln'
            else
            if Pos('11', item.Caption)>0 then
             TargetFile:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Microsoft_C++\VS11\GetWMI_Info.sln';


             CreateVsProject(ExtractFileName(FileName), ExtractFilePath(FileName), TargetFile, FileName);
             FileName := ChangeFileExt(FileName, '.sln');
             ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
          end;

        end;
      end;
    end;
  finally
    Frm.Free;
  end;
end;


procedure TFrmCodeEditor.ActionRunExecute(Sender: TObject);
var
  Frm: TFrmSelCompilerVer;
  item: TListItem;
  FileName: string;
  CompilerName: string;
  TargetFile: string;
begin
  Frm := TFrmSelCompilerVer.Create(Self);
  try
    Frm.ShowCompiler := True;
    Frm.CompilerType := CompilerType;
    Frm.LoadInstalledVersions;
    if Frm.ListViewIDEs.Items.Count = 0 then
      MsgWarning(Format('Not exist a %s compiler installed in this system', [ListCompilerType[CompilerType]]))
    else
    if Frm.ShowModal = mrOk then
    begin
      item := Frm.ListViewIDEs.Selected;
      if Assigned(item) then
      begin
        case CompilerType of
          Ct_Delphi:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.dpr';
            SynEditCode.Lines.SaveToFile(FileName);

            if CreateDelphiProject(
              ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +'Delphi') then
              CompileAndRunDelphiCode(Console.Lines,CompilerName, FileName, TComponent(Sender).Tag = 1);

            ScrollMemo(Console);
          end;

          Ct_BorlandCpp:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cpp';

            SynEditCode.Lines.SaveToFile(FileName);
            CompileAndRunBorlandCppCode(Console.Lines,CompilerName, FileName, TComponent(Sender).Tag = 1);
            ScrollMemo(Console);
          end;


          Ct_Lazarus_FPC:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     :=
              FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.lpr';

            SynEditCode.Lines.SaveToFile(FileName);
            if CreateLazarusProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), IncludeTrailingPathDelimiter(
              ExtractFilePath(ParamStr(0))) + 'Lazarus\TemplateConsole.lpi') then
              CompileAndRunFPCCode(Console.Lines,CompilerName, FileName, TComponent(Sender).Tag = 1);

             ScrollMemo(Console);
          end;


          Ct_VSCpp:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     := FileName + 'main.cpp';

            if Pos('2008', item.Caption)>0 then
             TargetFile:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Microsoft_C++\VS2008\GetWMI_Info.sln'
            else
            if Pos('2010', item.Caption)>0 then
             TargetFile:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Microsoft_C++\VS2010\GetWMI_Info.sln'
            else
            if Pos('11', item.Caption)>0 then
             TargetFile:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Microsoft_C++\VS11\GetWMI_Info.sln';

            SynEditCode.Lines.SaveToFile(FileName);


            if CreateVsProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), TargetFile, FileName) then
              CompileAndRunVsCode(Console.Lines,CompilerName, FileName,
                TComponent(Sender).Tag = 1);


            ScrollMemo(Console);
          end;

          Ct_Oxygene:
          begin
            CompilerName := item.SubItems[1];
            FileName     := IncludeTrailingPathDelimiter(Settings.OutputFolder);
            FileName     := FileName + 'Program.pas';

            SynEditCode.Lines.SaveToFile(FileName);

            if CreateOxygeneProject(
              ExtractFileName(FileName), ExtractFilePath(FileName), IncludeTrailingPathDelimiter(
              ExtractFilePath(ParamStr(0))) + 'Oxygene\VS2008\GetWMI_Info.oxygene', FileName) then
              CompileAndRunOxygenCode(Console.Lines,CompilerName, FileName,
                TComponent(Sender).Tag = 1);

             ScrollMemo(Console);
          end;

        end;

      end;
    end;
  finally
    Frm.Free;
  end;
end;
procedure TFrmCodeEditor.ActionSaveExecute(Sender: TObject);
begin
   case CompilerType of
    Ct_Delphi      :
                begin
                  SaveDialog1.FileName := 'GetWMI_Info.dpr';
                  SaveDialog1.Filter   := 'Delphi Project files|*.dpr';
                end;
    Ct_Lazarus_FPC :
                begin
                  SaveDialog1.FileName := 'GetWMI_Info.pas';
                  SaveDialog1.Filter   := 'Lazarus Source Code files|*.pas';
                end;
    Ct_Oxygene     :
                begin
                  SaveDialog1.FileName := 'GetWMI_Info.pas';
                  SaveDialog1.Filter   := 'Oxygen Source Code files|*.pas';
                end;
    Ct_BorlandCpp :
                begin
                  SaveDialog1.FileName := 'GetWMI_Info.cpp';
                  SaveDialog1.Filter   := 'C++ Source Code files|*.pas';
                end;
   end;

    if SaveDialog1.Execute then
      SynEditCode.Lines.SaveToFile(SaveDialog1.FileName);
end;



procedure TFrmCodeEditor.ComboBoxLanguageSelChange(Sender: TObject);
begin
   CompilerType:=ListCompilerLanguages[TSourceLanguages(ComboBoxLanguageSel.Items.Objects[ComboBoxLanguageSel.ItemIndex])];
   GenerateCode;
end;

procedure TFrmCodeEditor.FormCreate(Sender: TObject);
var
  i : TSourceLanguages;
begin
  FCodeGenerator :=nil;

  for i := Low(TSourceLanguages) to High(TSourceLanguages) do
    ComboBoxLanguageSel.Items.AddObject(ListSourceLanguages[i], TObject(i));
  ComboBoxLanguageSel.ItemIndex := 0;

  GenerateCode;
end;

end.
