// **************************************************************************************************
//
// Unit WDCC.CodeEditor
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
// The Original Code is WDCC.CodeEditor.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.CodeEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls, WDCC.WMI.GenCode,
  WDCC.Settings, Vcl.StdCtrls, Vcl.ToolWin, SynHighlighterPas, SynEditHighlighter,
  SynHighlighterCpp, Vcl.ActnMenus, Vcl.ExtCtrls, WDCC.SynEdit.PopupEdit,
  SynHighlighterCS, Vcl.Menus, Vcl.ActnPopup, System.Actions,
  SynEditCodeFolding, System.ImageList;

type
  TProcWMiCodeGen = procedure of object;

  TFrmCodeEditor = class(TForm)
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
    SynCSSyn1: TSynCSSyn;
    ActionFullScreen: TAction;
    PopupActionBar1: TPopupActionBar;
    Compile1: TMenuItem;
    Run1: TMenuItem;
    OpeninIDE1: TMenuItem;
    FormatCode1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure ActionRunExecute(Sender: TObject);
    procedure ActionFormatExecute(Sender: TObject);
    procedure ActionFormatUpdate(Sender: TObject);
    procedure ActionOpenIDEExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxLanguageSelChange(Sender: TObject);
    procedure ActionFullScreenUpdate(Sender: TObject);
    procedure ActionFullScreenExecute(Sender: TObject);
  private
    FSourceLanguage: TSourceLanguages;
    FSettings: TSettings;
    FConsole: TMemo;
    FCodeGenerator: TProcWMiCodeGen;
    FOldParent: TWinControl;
    procedure ScrollMemo(Memo: TMemo); overload;
    procedure ScrollMemo(Memo: TSynEdit); overload;
    function GetSourceCode: TStrings;
    procedure SetSourceCode(const Value: TStrings);
    procedure SetSourceLanguage(const Value: TSourceLanguages);
    procedure GenerateCode;
  public
    property SourceLanguage: TSourceLanguages read FSourceLanguage write SetSourceLanguage;
    property Settings: TSettings read FSettings write FSettings;
    property Console: TMemo read FConsole write FConsole;
    property SourceCode: TStrings read GetSourceCode write SetSourceCode;
    property CodeGenerator: TProcWMiCodeGen read FCodeGenerator write FCodeGenerator;
    property OldParent: TWinControl read FOldParent Write FOldParent;
  end;

implementation

uses
  ShellApi,
  Vcl.Styles,
  Vcl.Themes,
  System.Generics.Collections,
  WDCC.Misc,
  WDCC.SelectCompilerVersion,
  WDCC.DotNetFrameWork,
  WDCC.Delphi.IDE,
  WDCC.Lazarus.IDE,
  WDCC.Borland.Cpp.IDE,
  WDCC.DelphiPrism.IDE,
  WDCC.DelphiPrism.Helper,
  WDCC.VisualStudio,
  StrUtils;

{$R *.dfm}

procedure TFrmCodeEditor.GenerateCode;
begin
  if Assigned(FCodeGenerator) then
    FCodeGenerator();
end;

function TFrmCodeEditor.GetSourceCode: TStrings;
begin
  Result := SynEditCode.Lines;
end;

procedure TFrmCodeEditor.ScrollMemo(Memo: TMemo);
begin
  Memo.SelStart := Memo.GetTextLen;
  Memo.SelLength := 0;
  SendMessage(Memo.Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TFrmCodeEditor.ScrollMemo(Memo: TSynEdit);
begin
  Memo.SelStart := Memo.GetTextLen;
end;

procedure TFrmCodeEditor.SetSourceLanguage(const Value: TSourceLanguages);
var
  i: integer;
begin
  FSourceLanguage := Value;
  case FSourceLanguage of
    Lng_CSharp:
      SynEditCode.Highlighter := SynCSSyn1;

    Lng_BorlandCpp, Lng_VSCpp:
      SynEditCode.Highlighter := SynCppSyn1;
  else
    SynEditCode.Highlighter := SynPasSyn1;
  end;

  for i := 0 to ComboBoxLanguageSel.Items.Count - 1 do
    if TSourceLanguages(ComboBoxLanguageSel.Items.Objects[i]) = Value then
    begin
      ComboBoxLanguageSel.ItemIndex := i;
      break;
    end;

  if Assigned(Settings) then
    LoadCurrentTheme(Self, Settings.CurrentTheme);
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

procedure FormatAStyle(Console, SourceCode: TStrings; const Ext, AStyleCmdLine: string);
var
  TempFile: string;
  FormatterPath: string;
begin
  Console.Add('');
  FormatterPath := ExtractFilePath(ParamStr(0)) + 'AStyle\bin\AStyle.exe';
  if FileExists(FormatterPath) then
  begin
    TempFile := IncludeTrailingPathDelimiter(GetTempDirectory) + FormatDateTime('hhnnss.zzz', Now) + Ext;
    SourceCode.SaveToFile(TempFile);
    CaptureConsoleOutput(Format('"%s" ' + AStyleCmdLine, [FormatterPath, TempFile]), Console);
    SourceCode.LoadFromFile(TempFile);
  end;
end;

procedure TFrmCodeEditor.ActionFormatExecute(Sender: TObject);
begin
  if not FileExists(Settings.Formatter) and (FSourceLanguage in [Lng_BorlandCpp, Lng_Delphi, Lng_FPC]) then
    MsgWarning('Before to continue, you must set a source code formatter in the settings')
  else
    case FSourceLanguage of
      Lng_BorlandCpp:
        FormatBorlandCppCode(Console.Lines, SourceCode, Settings.Formatter);
      Lng_Delphi, Lng_FPC:
        FormatDelphiCode(Console.Lines, SourceCode, Settings.Formatter);
      Lng_Oxygen:
        ;

      Lng_VSCpp:
        FormatAStyle(Console.Lines, SourceCode, '.cpp', Settings.AStyleCmdLine);
      Lng_CSharp:
        FormatAStyle(Console.Lines, SourceCode, '.cs', Settings.AStyleCmdLine);
    end;
  ScrollMemo(Console);
  ScrollMemo(SynEditCode);
end;

procedure TFrmCodeEditor.ActionFormatUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FSourceLanguage in [Lng_Delphi, Lng_FPC, Lng_BorlandCpp, Lng_VSCpp, Lng_CSharp];
end;

procedure TFrmCodeEditor.ActionFullScreenExecute(Sender: TObject);
begin
  if Parent <> nil then
  begin
    Parent := nil;
    BorderStyle := bsSizeable;
    Align := alNone;
    Position := poScreenCenter;
  end
  else
  begin
    Parent := OldParent;
    BorderStyle := bsNone;
    Align := alClient;
    Position := poScreenCenter;
  end
end;

procedure TFrmCodeEditor.ActionFullScreenUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := True;
end;

procedure TFrmCodeEditor.ActionOpenIDEExecute(Sender: TObject);
var
  Frm: TFrmSelCompilerVer;
  LItem: TListItem;
  FileName: string;
  IdeName: string;
  TargetFile: string;
  UseVS: Boolean;
  LVisualStudioInfo: TVisualStudioInfo;
begin
  Frm := TFrmSelCompilerVer.Create(Self);
  try
    Frm.LanguageSource := SourceLanguage;
    Frm.Show64BitsCompiler := False;
    Frm.LoadInstalledVersions;
    if Frm.ListViewIDEs.Items.Count = 0 then
      MsgWarning(Format('Does not exist a %s IDEs installed in this system', [ListSourceLanguages[SourceLanguage]]))
    else if Frm.ShowModal = mrOk then
    begin
      LItem := Frm.ListViewIDEs.Selected;
      if Assigned(LItem) then
      begin
        IdeName := LItem.SubItems[0];
        FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);

        case SourceLanguage of
          Lng_Delphi:
            begin
              FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.dpr';
              SynEditCode.Lines.SaveToFile(FileName);
              ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                SW_SHOWNORMAL);
            end;

          Lng_BorlandCpp:
            begin
              FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cpp';
              SynEditCode.Lines.SaveToFile(FileName);
              ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                SW_SHOWNORMAL);
            end;

          Lng_FPC:
            begin
              FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.lpr';
              SynEditCode.Lines.SaveToFile(FileName);

              if CreateLazarusProject(ExtractFileName(FileName), ExtractFilePath(FileName),
                IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Lazarus\TemplateConsole.lpi') then
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
            end;

          Lng_Oxygen:
            begin
              LVisualStudioInfo := TVisualStudioInfo(LItem.Data);
              FileName := FileName + 'Program.pas';
              SynEditCode.Lines.SaveToFile(FileName);

              // if StartsText('Monodevelop', LItem.Caption) and
              // CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(
              // FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
              // 'Oxygene\Monodevelop\GetWMI_Info.oxygene', FileName) then
              // begin
              // FileName := ChangeFileExt(FileName, '.sln');
              // ShellExecute(Handle, nil, PChar(Format('"%s"',[IdeName])), PChar(Format('"%s"',[FileName])), nil, SW_SHOWNORMAL);
              // end
              // else

              if (LVisualStudioInfo.Version = vs2008) and CreateOxygeneProject(ExtractFileName(FileName),
                ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                'Oxygene\VS2008\GetWMI_Info.oxygene', FileName) then
              begin
                FileName := ChangeFileExt(FileName, '.sln');
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
              end
              else if (LVisualStudioInfo.Version = vs2010) and CreateOxygeneProject(ExtractFileName(FileName),
                ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                'Oxygene\VS2010\GetWMI_Info.oxygene', FileName) then
              begin
                FileName := ChangeFileExt(FileName, '.sln');
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
              end
              else if (LVisualStudioInfo.Version = vs2012) and CreateOxygeneProject(ExtractFileName(FileName),
                ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                'Oxygene\VS2012\GetWMI_Info.oxygene', FileName) then
              begin
                FileName := ChangeFileExt(FileName, '.sln');
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
              end
              else if (LVisualStudioInfo.Version = vs2013) and CreateOxygeneProject(ExtractFileName(FileName),
                ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                'Oxygene\VS2013\GetWMI_Info.oxygene', FileName) then
              begin
                FileName := ChangeFileExt(FileName, '.sln');
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
              end
              else if (LVisualStudioInfo.Version = vs2015) and CreateOxygeneProject(ExtractFileName(FileName),
                ExtractFilePath(FileName), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                'Oxygene\VS2015\GetWMI_Info.oxygene', FileName) then
              begin
                FileName := ChangeFileExt(FileName, '.sln');
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
              end;

            end;

          Lng_VSCpp:
            begin
              LVisualStudioInfo := TVisualStudioInfo(LItem.Data);
              TargetFile := '';
              FileName := FileName + 'main.cpp';
              SynEditCode.Lines.SaveToFile(FileName);
              UseVS := Pos('Visual Studio', LItem.Caption) > 0;
              if UseVS and (LVisualStudioInfo.Version = vs2005) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS2005\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2008) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS2008\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2010) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS2010\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2012) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS11\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2013) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS13\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2015) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS14\GetWMI_Info.sln';

              if UseVS and (TargetFile <> '') then
              begin
                CreateVsProject(ExtractFileName(FileName), ExtractFilePath(FileName), TargetFile, FileName);
                FileName := ChangeFileExt(FileName, '.sln');
                ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                  SW_SHOWNORMAL);
              end;
            end;

          Lng_CSharp:
            begin
              LVisualStudioInfo := TVisualStudioInfo(LItem.Data);
              FileName := FileName + 'Program.cs';
              SynEditCode.Lines.SaveToFile(FileName);

              if (LVisualStudioInfo.Version = vs2005) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'CSharp\VS2005\GetWMI_Info.sln'
              else if (LVisualStudioInfo.Version = vs2008) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'CSharp\VS2008\GetWMI_Info.sln'
              else if (LVisualStudioInfo.Version = vs2010) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'CSharp\VS2010\GetWMI_Info.sln'
              else if (LVisualStudioInfo.Version = vs2012) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'CSharp\VS11\GetWMI_Info.sln'
              else if (LVisualStudioInfo.Version = vs2013) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'CSharp\VS13\GetWMI_Info.sln'
              else if (LVisualStudioInfo.Version = vs2015) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'CSharp\VS14\GetWMI_Info.sln';

              CreateVsProject(ExtractFileName(FileName), ExtractFilePath(FileName), TargetFile, FileName);
              FileName := ChangeFileExt(FileName, '.sln');
              ShellExecute(Handle, nil, PChar(Format('"%s"', [IdeName])), PChar(Format('"%s"', [FileName])), nil,
                SW_SHOWNORMAL);
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
  LFrmSelCompilerVer: TFrmSelCompilerVer;
  LItem: TListItem;
  FileName: string;
  CompilerName: string;
  TargetFile: string;
  UseVS: Boolean;
  LVisualStudioInfo: TVisualStudioInfo;

begin
  LFrmSelCompilerVer := TFrmSelCompilerVer.Create(Self);
  try
    LFrmSelCompilerVer.ShowCompiler := True;
    LFrmSelCompilerVer.LanguageSource := SourceLanguage;
    LFrmSelCompilerVer.LoadInstalledVersions;
    if LFrmSelCompilerVer.ListViewIDEs.Items.Count = 0 then
      MsgWarning(Format('Not exist a %s compiler installed in this system', [ListSourceLanguages[SourceLanguage]]))
    else if LFrmSelCompilerVer.ShowModal = mrOk then
    begin
      LItem := LFrmSelCompilerVer.ListViewIDEs.Selected;
      if Assigned(LItem) then
      begin
        case SourceLanguage of
          Lng_Delphi:
            begin
              CompilerName := LItem.SubItems[1];
              FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);
              FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.dpr';
              SynEditCode.Lines.SaveToFile(FileName);

              if CreateDelphiProject(ExtractFilePath(FileName),
                IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Delphi') then
                CompileAndRunDelphiCode(Console.Lines, CompilerName, FileName, TComponent(Sender).Tag = 1);

              ScrollMemo(Console);
            end;

          Lng_BorlandCpp:
            begin
              CompilerName := LItem.SubItems[1];
              FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);
              FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cpp';

              SynEditCode.Lines.SaveToFile(FileName);
              CompileAndRunBorlandCppCode(Console.Lines, CompilerName, FileName, TComponent(Sender).Tag = 1);
              ScrollMemo(Console);
            end;

          Lng_FPC:
            begin
              CompilerName := LItem.SubItems[1];
              FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);
              FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.lpr';

              SynEditCode.Lines.SaveToFile(FileName);
              if CreateLazarusProject(ExtractFileName(FileName), ExtractFilePath(FileName),
                IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Lazarus\TemplateConsole.lpi') then
                CompileAndRunFPCCode(Console.Lines, CompilerName, FileName, TComponent(Sender).Tag = 1);

              ScrollMemo(Console);
            end;

          Lng_VSCpp:
            begin
              LVisualStudioInfo := TVisualStudioInfo(LItem.Data);
              CompilerName := LItem.SubItems[1];
              FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);
              UseVS := Pos('Visual Studio', LItem.Caption) > 0;

              if UseVS then
                FileName := FileName + 'main.cpp'
              else
                FileName := FileName + 'GetWMI_Info.cpp';

              if UseVS and (LVisualStudioInfo.Version = vs2005) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS2005\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2008) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS2008\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2010) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS2010\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2012) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS11\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2013) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS13\GetWMI_Info.sln'
              else if UseVS and (LVisualStudioInfo.Version = vs2015) then
                TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                  'Microsoft_C++\VS14\GetWMI_Info.sln';

              SynEditCode.Lines.SaveToFile(FileName);

              if CreateVsProject(ExtractFileName(FileName), ExtractFilePath(FileName), TargetFile, FileName) then
                if UseVS then
                  CompileAndRunVsCode(Console.Lines, CompilerName, FileName, TComponent(Sender).Tag = 1)
                else
                  CompileAndRunMicrosoftCppCode(Console.Lines, CompilerName, FileName, FSettings.MicrosoftCppCmdLine,
                    TComponent(Sender).Tag = 1);

              ScrollMemo(Console);
            end;

          Lng_CSharp:
            begin
              LVisualStudioInfo := TVisualStudioInfo(LItem.Data);
              UseVS := Pos('Visual Studio', LItem.Caption) > 0;
              CompilerName := LItem.SubItems[1];
              FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);

              if UseVS then
                FileName := FileName + 'Program.cs'
              else
                FileName := FileName + 'WMITemp_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '.cs';

              SynEditCode.Lines.SaveToFile(FileName);

              if UseVS then
              begin
                if (LVisualStudioInfo.Version = vs2005) then
                  TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                    'CSharp\VS2005\GetWMI_Info.sln'
                else if (LVisualStudioInfo.Version = vs2008) then
                  TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                    'CSharp\VS2008\GetWMI_Info.sln'
                else if (LVisualStudioInfo.Version = vs2010) then
                  TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                    'CSharp\VS2010\GetWMI_Info.sln'
                else if (LVisualStudioInfo.Version = vs2012) then
                  TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                    'CSharp\VS11\GetWMI_Info.sln'
                else if (LVisualStudioInfo.Version = vs2013) then
                  TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                    'CSharp\VS13\GetWMI_Info.sln'
                else if (LVisualStudioInfo.Version = vs2015) then
                  TargetFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
                    'CSharp\VS14\GetWMI_Info.sln';

                if CreateVsProject(ExtractFileName(FileName), ExtractFilePath(FileName), TargetFile, FileName) then
                  CompileAndRunVsCode(Console.Lines, CompilerName, FileName, TComponent(Sender).Tag = 1);
              end;

              if not UseVS then
                CompileAndRunCSharpCode(Console.Lines, CompilerName, FSettings.CSharpCmdLine, FileName,
                  TComponent(Sender).Tag = 1);

              ScrollMemo(Console);
            end;

          Lng_Oxygen:
            begin
              CompilerName := LItem.SubItems[1];
              FileName := IncludeTrailingPathDelimiter(Settings.OutputFolder);
              FileName := FileName + 'Program.pas';

              SynEditCode.Lines.SaveToFile(FileName);

              if CreateOxygeneProject(ExtractFileName(FileName), ExtractFilePath(FileName),
                IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Oxygene\VS2008\GetWMI_Info.oxygene',
                FileName) then
                CompileAndRunOxygenCode(Console.Lines, CompilerName, FileName, TComponent(Sender).Tag = 1);

              ScrollMemo(Console);
            end;
        end;

      end;
    end;
  finally
    LFrmSelCompilerVer.Free;
  end;
end;

procedure TFrmCodeEditor.ActionSaveExecute(Sender: TObject);
begin
  case SourceLanguage of
    Lng_Delphi:
      begin
        SaveDialog1.FileName := 'GetWMI_Info.dpr';
        SaveDialog1.Filter := 'Delphi Project files|*.dpr';
      end;
    Lng_FPC:
      begin
        SaveDialog1.FileName := 'GetWMI_Info.pas';
        SaveDialog1.Filter := 'Lazarus Source Code files|*.pas';
      end;
    Lng_Oxygen:
      begin
        SaveDialog1.FileName := 'GetWMI_Info.pas';
        SaveDialog1.Filter := 'Oxygen Source Code files|*.pas';
      end;

    Lng_CSharp:
      begin
        SaveDialog1.FileName := 'GetWMI_Info.cs';
        SaveDialog1.Filter := 'C# Source Code files|*.cs';
      end;

    Lng_VSCpp, Lng_BorlandCpp:
      begin
        SaveDialog1.FileName := 'GetWMI_Info.cpp';
        SaveDialog1.Filter := 'C++ Source Code files|*.cpp';
      end;
  end;

  if SaveDialog1.Execute then
    SynEditCode.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TFrmCodeEditor.ComboBoxLanguageSelChange(Sender: TObject);
begin
  SourceLanguage := TSourceLanguages(ComboBoxLanguageSel.Items.Objects[ComboBoxLanguageSel.ItemIndex]);
  GenerateCode;
end;

procedure TFrmCodeEditor.FormCreate(Sender: TObject);
var
  i: TSourceLanguages;
begin
  FCodeGenerator := nil;

  for i := Low(TSourceLanguages) to High(TSourceLanguages) do
    ComboBoxLanguageSel.Items.AddObject(ListSourceLanguages[i], TObject(i));
  ComboBoxLanguageSel.ItemIndex := 0;

  GenerateCode;
end;

end.
