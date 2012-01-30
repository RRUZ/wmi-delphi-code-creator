unit uWmiClasses;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, uWmi_Metadata, uCodeEditor, uSettings, uWmiTree, uComboBox;

type
  TWmiProcClassesLog = procedure (const Msg : string) of object;
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
    procedure ComboBoxNameSpacesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxClassesChange(Sender: TObject);
    procedure ButtonGetValuesClick(Sender: TObject);
    procedure ListViewPropertiesClick(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FSetMsg: TWmiProcClassesLog;
    FSetLog: TWmiProcClassesLog;
    FrmCodeEditor         : TFrmCodeEditor;
    FSettings: TSettings;
    FConsole: TMemo;
    procedure GenerateCode;
    procedure SetConsole(const Value: TMemo);
    procedure SetSettings(const Value: TSettings);
    procedure LoadWmiProperties(WmiMetaClassInfo : TWMiClassMetaData);
  public
    FrmWMIExplorer  : TFrmWMITree;
    property SetMsg : TWmiProcClassesLog read FSetMsg Write FSetMsg;
    property SetLog : TWmiProcClassesLog read FSetLog Write FSetLog;
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
  Winapi.CommCtrl,
  System.Win.ComObj,
  uWmi_ViewPropsValues,
  uMisc,
  StrUtils,
  uSelectCompilerVersion,
  uWmiGenCode,
  uWmiOxygenCode,
  uWmiFPCCode,
  uWmiDelphiCode,
  uWmiBorlandCppCode,
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

  GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));
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
  FrmCodeEditor.CompilerType:=Ct_Delphi;
end;

procedure TFrmWmiClasses.FormDestroy(Sender: TObject);
var
 i : Integer;
begin
  for i := 0 to ComboBoxClasses.Items.Count-1 do
   if ComboBoxClasses.Items.Objects[i]<>nil then
   begin
    TWMiClassMetaData(ComboBoxClasses.Items.Objects[i]).Free;
    ComboBoxClasses.Items.Objects[i]:=nil;
   end;

end;

procedure TFrmWmiClasses.GenerateCode;
begin
   if ComboBoxClasses.ItemIndex>=0 then
     GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));

end;

procedure TFrmWmiClasses.GenerateConsoleCode(
  WmiMetaClassInfo: TWMiClassMetaData);
var
  i,j:     integer;
  Props: TStrings;
  Str:  string;
  DelphiWmiCodeGenerator : TDelphiWmiClassCodeGenerator;
  FPCWmiCodeGenerator    : TFPCWmiClassCodeGenerator;
  OxygenWmiCodeGenerator : TOxygenWmiClassCodeGenerator;
  CppWmiCodeGenerator    : TBorlandCppWmiClassCodeGenerator;

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

    case FrmCodeEditor.CompilerType of
      Ct_Delphi:
                  begin
                    DelphiWmiCodeGenerator:=TDelphiWmiClassCodeGenerator.Create;
                    try
                      DelphiWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      DelphiWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      DelphiWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      DelphiWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=DelphiWmiCodeGenerator.OutPutCode;
                    finally
                      DelphiWmiCodeGenerator.Free;
                    end;
                  end;


      Ct_Lazarus_FPC:
                  begin
                    FPCWmiCodeGenerator:=TFPCWmiClassCodeGenerator.Create;
                    try
                      FPCWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      FPCWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      FPCWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      FPCWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=FPCWmiCodeGenerator.OutPutCode;
                    finally
                      FPCWmiCodeGenerator.Free;
                    end;
                  end;


      Ct_Oxygene:
                  begin
                    OxygenWmiCodeGenerator:=TOxygenWmiClassCodeGenerator.Create;
                    try
                      OxygenWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      OxygenWmiCodeGenerator.UseHelperFunctions:=Settings.DelphiWmiClassHelperFuncts;
                      OxygenWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      OxygenWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=OxygenWmiCodeGenerator.OutPutCode;
                    finally
                      OxygenWmiCodeGenerator.Free;
                    end;
                  end;

      Ct_BorlandCpp:
                  begin
                    CppWmiCodeGenerator:=TBorlandCppWmiClassCodeGenerator.Create;
                    try
                      CppWmiCodeGenerator.WMiClassMetaData  :=WmiMetaClassInfo;
                      CppWmiCodeGenerator.UseHelperFunctions:=false;
                      CppWmiCodeGenerator.ModeCodeGeneration :=TWmiCode(Settings.DelphiWmiClassCodeGenMode);
                      CppWmiCodeGenerator.GenerateCode(Props);
                      FrmCodeEditor.SourceCode:=CppWmiCodeGenerator.OutPutCode;
                    finally
                      CppWmiCodeGenerator.Free;
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
  GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));

end;

procedure TFrmWmiClasses.LoadClassInfo;
var
  WmiMetaClassInfo : TWMiClassMetaData;
begin
  if ComboBoxClasses.ItemIndex=-1 then exit;

  //ProgressBarWmi.Visible := True;
  try
    if ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]=nil then
    begin
      WmiMetaClassInfo:=TWMiClassMetaData.Create(ComboBoxNameSpaces.Text, ComboBoxClasses.Text);
      ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]:= WmiMetaClassInfo;
    end
    else
      WmiMetaClassInfo:=TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]);

    if Assigned(WmiMetaClassInfo) then
    begin
      SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));
      MemoClassDescr.Text :=  WmiMetaClassInfo.Description;
      if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';

      LoadWmiProperties(WmiMetaClassInfo);
      //FrmWMIExplorer.LoadClassInfo(WmiMetaClassInfo);
    end;
  finally
    SetMsg('');
    //ProgressBarWmi.Visible := False;
  end;
end;

procedure TFrmWmiClasses.LoadWmiClasses(const Namespace: string);
var
  Node: TTreeNode;
  NodeC: TTreeNode;
  FClasses: TStringList;
  i: integer;
begin
  SetMsg(Format('Loading Classes of %s', [Namespace]));
  Node := FindTextTreeView(Namespace, FrmWMIExplorer.TreeViewWmiClasses);
  if Assigned(Node) then
  begin

    for i := 0 to ComboBoxClasses.Items.Count-1 do
     if ComboBoxClasses.Items.Objects[i]<>nil then
     begin
      TWMiClassMetaData(ComboBoxClasses.Items.Objects[i]).Free;
      ComboBoxClasses.Items.Objects[i]:=nil;
     end;


    if Assigned(Node.Data) then
    begin
      FClasses := TStringList(Node.Data);
      ComboBoxClasses.Items.BeginUpdate;
      try
        ComboBoxClasses.Items.Clear;
        ComboBoxClasses.Items.AddStrings(FClasses);
        LabelClasses.Caption := Format('Classes (%d)', [FClasses.Count]);
      finally
        ComboBoxClasses.Items.EndUpdate;
      end;
    end
    else
    begin
      FClasses := TStringList.Create;
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


      FrmWMIExplorer.TreeViewWmiClasses.Items.BeginUpdate;
      Node.Data := FClasses;
      try
        for i := 0 to FClasses.Count - 1 do
        begin
          NodeC := FrmWMIExplorer.TreeViewWmiClasses.Items.AddChild(Node, FClasses[i]);
          NodeC.ImageIndex := ClassImageIndex;
          NodeC.SelectedIndex := ClassImageIndex;
        end;
      finally
        FrmWMIExplorer.TreeViewWmiClasses.Items.EndUpdate;
      end;

    end;
  end
  else
    MsgWarning(Namespace + ' not found');

  SetMsg('');
end;


procedure TFrmWmiClasses.LoadWmiProperties(WmiMetaClassInfo: TWMiClassMetaData);
var
  i:     integer;
  //Props: TStringList;
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

  GenerateConsoleCode(TWMiClassMetaData(ComboBoxClasses.Items.Objects[ComboBoxClasses.ItemIndex]));
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

  LoadCurrentTheme(FrmCodeEditor, Settings.CurrentTheme);
  LoadCurrentThemeFont(FrmCodeEditor ,Settings.FontName,Settings.FontSize);
end;

end.
