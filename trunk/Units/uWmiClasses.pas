{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiClasses                                                                                 }
{ unit for the WMI Delphi Code Creator                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uWmiClasses.pas.                                                            }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit uWmiClasses;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, uMisc,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, uWmi_Metadata, uCodeEditor, uSettings, uComboBox,
  Vcl.ImgList;

type
  TFrmWmiClasses = class(TForm)
    PanelMetaWmiInfo: TPanel;
    LabelProperties: TLabel;
    LabelClasses: TLabel;
    LabelNamespace: TLabel;
    ComboBoxClasses: TComboBox;
    ComboBoxNameSpaces: TComboBox;
    CheckBoxSelAllProps: TCheckBox;
    MemoClassDescr: TMemo;
    ListViewProperties: TListView;
    ButtonGetValues: TButton;
    Splitter1: TSplitter;
    PanelCode: TPanel;
    ImageList1: TImageList;
    procedure ComboBoxNameSpacesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxClassesChange(Sender: TObject);
    procedure ButtonGetValuesClick(Sender: TObject);
    procedure ListViewPropertiesClick(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FSetMsg: TProcLog;
    FSetLog: TProcLog;
    FrmCodeEditor         : TFrmCodeEditor;
    FSettings: TSettings;
    FConsole: TMemo;
    procedure GenerateCode;
    procedure SetConsole(const Value: TMemo);
    procedure SetSettings(const Value: TSettings);
    procedure LoadWmiProperties(WmiMetaClassInfo : TWMiClassMetaData);
  public
    property SetMsg : TProcLog read FSetMsg Write FSetMsg;
    property SetLog : TProcLog read FSetLog Write FSetLog;
    property Settings : TSettings read FSettings Write SetSettings;
    property Console : TMemo read FConsole write SetConsole;

    procedure LoadWmiClasses(const Namespace: string);
    procedure LoadClassInfo;
    procedure GetValuesWmiProperties(const Namespace, WmiClass: string);
    procedure GenerateConsoleCode(WmiMetaClassInfo : TWMiClassMetaData);
  end;



implementation

{$R *.dfm}

uses
  uGlobals,
  Winapi.CommCtrl,
  System.Win.ComObj,
  uWmi_ViewPropsValues,
  StrUtils,
  uSelectCompilerVersion,
  uWmiGenCode,
  uWmiOxygenCode,
  uWmiFPCCode,
  uWmiDelphiCode,
  uWmiBorlandCppCode,
  uWmiVsCppCode,
  uListView_Helper;

procedure TFrmWmiClasses.ButtonGetValuesClick(Sender: TObject);
begin
  GetValuesWmiProperties(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
end;

procedure TFrmWmiClasses.CheckBoxSelAllPropsClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ListViewProperties.Items.Count - 1 do
    ListViewProperties.Items[i].Checked := CheckBoxSelAllProps.Checked;

  GenerateCode;
end;

procedure TFrmWmiClasses.ComboBoxClassesChange(Sender: TObject);
begin
  LoadClassInfo;
end;

procedure TFrmWmiClasses.ComboBoxNameSpacesChange(Sender: TObject);
begin
  LoadWmiClasses(TComboBox(Sender).Text);
  ComboBoxClasses.ItemIndex := 0;
  LoadClassInfo;
end;

procedure TFrmWmiClasses.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Settings.LastWmiNameSpace:=ComboBoxNameSpaces.Text;
  Settings.LastWmiClass:=ComboBoxClasses.Text;
end;

procedure TFrmWmiClasses.FormCreate(Sender: TObject);
begin
  FrmCodeEditor  := TFrmCodeEditor.Create(Self);
  FrmCodeEditor.CodeGenerator:=GenerateCode;
  FrmCodeEditor.Parent := PanelCode;
  FrmCodeEditor.Show;
  //FrmCodeEditor.Settings:=Settings;
  //FrmCodeEditor.Console:=MemoConsole;
  FrmCodeEditor.SourceLanguage:=Lng_Delphi;
end;

procedure TFrmWmiClasses.GenerateCode;
begin
   if ComboBoxClasses.ItemIndex>=0 then
     GenerateConsoleCode(CachedWMIClasses.GetWmiClass(ComboBoxNameSpaces.Text, ComboBoxClasses.Text));
end;

procedure TFrmWmiClasses.GenerateConsoleCode(
  WmiMetaClassInfo: TWMiClassMetaData);
var
  i,j:     integer;
  Props: TStrings;
  Str:  string;
  WmiCodeGenerator       : TWmiClassCodeGenerator;
begin
  if not Assigned(WmiMetaClassInfo) then Exit;

  SetLog(Format('Generating code for %s:%s',[WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));

  //Object Pascal console Code
  Props := TStringList.Create;
  try
    Str := '';
    for i := 0 to ListViewProperties.Items.Count - 1 do
      if ListViewProperties.Items[i].Checked then
        Str := Str + Format('%s=%s, ', [ListViewProperties.Items[i].Caption,
          ListViewProperties.Items[i].SubItems[0]]);

    Props.CommaText := Str;

    j:=0;
    for i := 0 to ListViewProperties.Items.Count - 1 do
      if ListViewProperties.Items[i].Checked then
      begin
        Props.Objects[j]:=ListViewProperties.Items[i].Data;//CimType
        inc(j);
      end;

    case FrmCodeEditor.SourceLanguage of
      Lng_Delphi:
                  begin
                    WmiCodeGenerator:=TDelphiWmiClassCodeGenerator.Create;
                    try
                      WmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      WmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      WmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      WmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=WmiCodeGenerator.OutPutCode;
                    finally
                      WmiCodeGenerator.Free;
                    end;
                  end;


      Lng_FPC:
                  begin
                    WmiCodeGenerator:=TFPCWmiClassCodeGenerator.Create;
                    try
                      WmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      WmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      WmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      WmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=WmiCodeGenerator.OutPutCode;
                    finally
                      WmiCodeGenerator.Free;
                    end;
                  end;


      Lng_Oxygen:
                  begin
                    WmiCodeGenerator:=TOxygenWmiClassCodeGenerator.Create;
                    try
                      WmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      WmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      WmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      WmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=WmiCodeGenerator.OutPutCode;
                    finally
                      WmiCodeGenerator.Free;
                    end;
                  end;

      Lng_BorlandCpp:
                  begin
                    WmiCodeGenerator:=TBorlandCppWmiClassCodeGenerator.Create;
                    try
                      WmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      WmiCodeGenerator.UseHelperFunctions:=false;
                      WmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      WmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=WmiCodeGenerator.OutPutCode;
                    finally
                      WmiCodeGenerator.Free;
                    end;
                  end;

      Lng_VSCpp  :
                  begin
                    WmiCodeGenerator:=TVsCppWmiClassCodeGenerator.Create;
                    try
                      WmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      WmiCodeGenerator.UseHelperFunctions:=false;
                      WmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      WmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=WmiCodeGenerator.OutPutCode;
                    finally
                      WmiCodeGenerator.Free;
                    end;
                  end;

    end;

  finally
    Props.Free;
  end;
end;

procedure TFrmWmiClasses.GetValuesWmiProperties(const Namespace,
  WmiClass: string);
var
  Props: TStringList;
  i    : Integer;
begin
  if (ListViewProperties.Items.Count > 0) and (WmiClass <> '') and (Namespace <> '') then
  begin
    Props:=TStringList.Create;
    try
      for i := 0 to ListViewProperties.Items.Count - 1 do
        if ListViewProperties.Items[i].Checked then
          Props.Add(ListViewProperties.Items[i].Caption);

      ListValuesWmiProperties(Namespace, WmiClass, Props);
    finally
     Props.Free;
    end;
  end;
end;


procedure TFrmWmiClasses.ListViewPropertiesClick(Sender: TObject);
begin
  CheckBoxSelAllProps.Checked := False;
  GenerateCode;
end;

procedure TFrmWmiClasses.LoadClassInfo;
var
  WmiMetaClassInfo : TWMiClassMetaData;
begin
  if ComboBoxClasses.ItemIndex=-1 then exit;

  try
    WmiMetaClassInfo:=CachedWMIClasses.GetWmiClass(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);

    if Assigned(WmiMetaClassInfo) then
    begin
      SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));
      MemoClassDescr.Text :=  WmiMetaClassInfo.Description;
      if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';

      LoadWmiProperties(WmiMetaClassInfo);
    end;
  finally
    SetMsg('');
  end;
end;

procedure TFrmWmiClasses.LoadWmiClasses(const Namespace: string);
var
  FClasses: TStringList;
begin
  SetMsg(Format('Loading Classes of %s', [Namespace]));

  FClasses := TStringList.Create;
  try
    FClasses.Sorted := True;
    FClasses.BeginUpdate;
    try
      try
        if not ExistWmiClassesCache(Namespace) then
        begin
          GetListWmiClasses(Namespace, FClasses, [], ['abstract'], True);
          SaveWMIClassesToCache(Namespace, FClasses);
        end
        else
          LoadWMIClassesFromCache(Namespace, FClasses);
      except
        on E: EOleSysError do
          if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
            SetLog(
              Format('Access denied  %s %s  Code : %x', ['GetListWmiClasses', E.Message, E.ErrorCode]))
          else
            raise;
      end;

    finally
      FClasses.EndUpdate;
    end;

    ComboBoxClasses.Items.BeginUpdate;
    try
      ComboBoxClasses.Items.Clear;
      ComboBoxClasses.Items.AddStrings(FClasses);
      LabelClasses.Caption := Format('Classes (%d)', [FClasses.Count]);
    finally
      ComboBoxClasses.Items.EndUpdate;
    end;
  finally
    FClasses.Free;//New ¡¡¡ Added without FrmWMIExplorer
  end;

  SetMsg('');
end;


procedure TFrmWmiClasses.LoadWmiProperties(WmiMetaClassInfo: TWMiClassMetaData);
var
  i:     integer;
  item:  TListItem;
begin
  //StatusBar1.SimpleText := Format('Loading Properties of %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
  ListViewProperties.Items.BeginUpdate;
  try
    ListViewProperties.Items.Clear;

    for i := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
    begin
      item := ListViewProperties.Items.Add;
      item.Caption := WmiMetaClassInfo.Properties[i].Name;
      item.SubItems.Add(WmiMetaClassInfo.Properties[i].&Type);
      item.SubItems.Add(WmiMetaClassInfo.Properties[i].Description);
      item.Checked := CheckBoxSelAllProps.Checked;
      item.Data    := Pointer(WmiMetaClassInfo.Properties[i].CimType); //Cimtype
    end;

    LabelProperties.Caption := Format('%d Properties of %s:%s',
      [ListViewProperties.Items.Count, WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
  finally
    ListViewProperties.Items.EndUpdate;
  end;
  SetMsg('');

  for i := 0 to ListViewProperties.Columns.Count - 1 do
    AutoResizeColumn(ListViewProperties.Column[i]);

  GenerateCode;
end;

procedure TFrmWmiClasses.SetConsole(const Value: TMemo);
begin
  FConsole := Value;
  FrmCodeEditor.Console:=Value;
end;

procedure TFrmWmiClasses.SetSettings(const Value: TSettings);
begin
  FSettings := Value;
  FrmCodeEditor.Settings:=Value;
  FrmCodeEditor.SourceLanguage:=TSourceLanguages(Value.DefaultLanguage);

  LoadCurrentTheme(FrmCodeEditor, Settings.CurrentTheme);
  LoadCurrentThemeFont(FrmCodeEditor ,Settings.FontName,Settings.FontSize);
end;

end.
