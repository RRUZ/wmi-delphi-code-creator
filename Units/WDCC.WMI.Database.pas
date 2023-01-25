// **************************************************************************************************
//
// Unit WDCC.WMI.Database
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
// The Original Code is WDCC.WMI.Database.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.Database;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, WDCC.Misc,
  Vcl.ComCtrls;

type

  TFrmWmiDatabase = class(TForm)
    DataSource1: TDataSource;
    ClientDataSetWmi: TClientDataSet;
    PanelMain: TPanel;
    Label7: TLabel;
    GroupBoxTypes: TGroupBox;
    RadioButtonDynamic: TRadioButton;
    RadioButtonAll: TRadioButton;
    GroupBoxMode: TGroupBox;
    RadioButtonInsensitive: TRadioButton;
    RadioButtonSensitive: TRadioButton;
    ComboBoxSearch2: TComboBox;
    GroupBox1: TGroupBox;
    CheckBoxProperties: TCheckBox;
    CheckBoxMethods: TCheckBox;
    CheckBox1: TCheckBox;
    GroupBoxSearchIn: TGroupBox;
    CheckBoxNamespace: TCheckBox;
    CheckBoxClasses: TCheckBox;
    CheckBoxClassDescr: TCheckBox;
    DBGridWMI: TDBGrid;
    ButtonSearchWmiDatabase: TButton;
    ButtonBuildWmiDatabase: TButton;
    ButtonSaveBdd: TButton;
    ButtonDelBdd: TButton;
    ProgressBarNamespaces: TProgressBar;
    ProgressBarClasses: TProgressBar;
    PanelStatus: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LabelMsg: TLabel;
    EditSearch: TEdit;
    procedure ButtonSearchWmiDatabaseClick(Sender: TObject);
    procedure ComboBoxSearch2Change(Sender: TObject);
    procedure ComboBoxSearch2Exit(Sender: TObject);
    procedure ButtonBuildWmiDatabaseClick(Sender: TObject);
    procedure ButtonSaveBddClick(Sender: TObject);
    procedure ButtonDelBddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridWMIDblClick(Sender: TObject);
    procedure EditSearchChange(Sender: TObject);
  private
    FDatabaseFile: string;
    FHistoryFile: string;
    FNameSpaces: TStrings;
    FLog: TProcLog;
    procedure BuildWmiDatabase;
    procedure SearchDatabase(Value: string);
    procedure SaveWmiDatabase;
    procedure DeleteWmiDatabase;
    procedure CreateWmiDatabaseStructure;
    procedure Status(const Msg: string);
    // procedure SetNameSpaces(const Value: TStrings);
  public
    property SetLog: TProcLog read FLog write FLog;
  end;

implementation

{$R *.dfm}

uses
  ComObj,
  MidasLib,
  WDCC.Globals,
  uWmi_Metadata,
  WDCC.WMI.ViewPropsValues,
  AsyncCalls,
  WDCC.Settings;

const
  MaxHistory = 50;
  WmiDatabaseName = 'WmiDatabase.xml';

procedure TFrmWmiDatabase.BuildWmiDatabase;
var
  NameSpaceIndex: integer;
  ClassesIndex: integer;
  k: integer;
  Classes: TStringList;
  Value: string;
  WMIMetaData: TWMiClassMetaData;
begin
  ClientDataSetWmi.DisableControls;
  ProgressBarClasses.Position := 0;
  ProgressBarNamespaces.Max := FNameSpaces.Count;
  try
    for NameSpaceIndex := 0 to FNameSpaces.Count - 1 do
    begin
      ProgressBarNamespaces.Position := NameSpaceIndex + 1;
      Status('Scanning namespace ' + FNameSpaces[NameSpaceIndex]);

      Classes := TStringList.Create;
      try
        if RadioButtonAll.Checked then
          GetListWmiClasses(FNameSpaces[NameSpaceIndex], Classes)
        else if RadioButtonDynamic.Checked then
          GetListWmiDynamicClasses(FNameSpaces[NameSpaceIndex], Classes);

        ProgressBarClasses.Max := Classes.Count;
        for ClassesIndex := 0 to Classes.Count - 1 do
        begin
          WMIMetaData := TWMiClassMetaData.Create(FNameSpaces[NameSpaceIndex], Classes[ClassesIndex]);
          ProgressBarClasses.Position := ClassesIndex + 1;
          try
            Status(Format('%s Scanning Class %s', [FNameSpaces[NameSpaceIndex], Classes[ClassesIndex]]));
            Value := WMIMetaData.Description;

            if Value <> '' then
            begin
              ClientDataSetWmi.Append;
              ClientDataSetWmi.Fields[0].AsString := FNameSpaces[NameSpaceIndex]; // namespace
              ClientDataSetWmi.Fields[1].AsString := Classes[ClassesIndex];
              // class
              ClientDataSetWmi.Fields[2].AsString := Classes[ClassesIndex];
              // name
              // ClientDataSetWmi.Fields[3].AsInteger:= WmiTableType_Class;          //type
              ClientDataSetWmi.Fields[3].AsString := 'Class'; // type
              ClientDataSetWmi.Fields[4].AsString := Value; // value
              ClientDataSetWmi.Post;
            end;

            if CheckBoxProperties.Checked then
            begin
              for k := 0 to WMIMetaData.PropertiesCount - 1 do
              begin
                Value := WMIMetaData.Properties[k].Description;
                if Value <> '' then
                begin
                  ClientDataSetWmi.Append;
                  ClientDataSetWmi.Fields[0].AsString := FNameSpaces[NameSpaceIndex]; // namespace
                  ClientDataSetWmi.Fields[1].AsString := Classes[ClassesIndex];
                  // class
                  ClientDataSetWmi.Fields[2].AsString := WMIMetaData.Properties[k].Name;
                  // name
                  // ClientDataSetWmi.Fields[3].AsInteger:= WmiTableType_Class;          //type
                  ClientDataSetWmi.Fields[3].AsString := 'Property'; // type
                  ClientDataSetWmi.Fields[4].AsString := Value; // value
                  ClientDataSetWmi.Post;
                end;
              end;
            end;

            if CheckBoxMethods.Checked then
            begin
              for k := 0 to WMIMetaData.MethodsCount - 1 do
              begin
                Value := WMIMetaData.Methods[k].Description;
                if Value <> '' then
                begin
                  ClientDataSetWmi.Append;
                  ClientDataSetWmi.Fields[0].AsString := FNameSpaces[NameSpaceIndex]; // namespace
                  ClientDataSetWmi.Fields[1].AsString := Classes[ClassesIndex];
                  // class
                  ClientDataSetWmi.Fields[2].AsString := WMIMetaData.Methods[k].Name;
                  // name
                  // ClientDataSetWmi.Fields[3].AsInteger:= WmiTableType_Class;          //type
                  ClientDataSetWmi.Fields[3].AsString := 'Method'; // type
                  ClientDataSetWmi.Fields[4].AsString := Value; // value
                  ClientDataSetWmi.Post;
                end;
              end;
            end;
          finally
            WMIMetaData.Free;
          end;
        end;
      finally
        Classes.Free;
      end;

      Application.ProcessMessages;
    end;

    ClientDataSetWmi.Open;
  finally
    ClientDataSetWmi.EnableControls;
    Status('');
  end;

end;

function SortClientDataSet(ClientDataSet: TClientDataSet; const FieldName: String): Boolean;
var
  i: integer;
  NewIndexName: String;
  IndexOptions: TIndexOptions;
  Field: TField;
begin
  Result := False;
  Field := ClientDataSet.Fields.FindField(FieldName);
  // If invalid field name, exit.
  if Field = nil then
    Exit;
  // if invalid field type, exit.
  if (Field is TObjectField) or (Field is TBlobField) or (Field is TAggregateField) or (Field is TVariantField) or
    (Field is TBinaryField) then
    Exit;
  // Get IndexDefs and IndexName using RTTI
  // Ensure IndexDefs is up-to-date
  ClientDataSet.IndexDefs.Update;
  // If an ascending index is already in use,
  // switch to a descending index
  if ClientDataSet.IndexName = FieldName + '__IdxA' then
  begin
    NewIndexName := FieldName + '__IdxD';
    IndexOptions := [ixDescending];
  end
  else
  begin
    NewIndexName := FieldName + '__IdxA';
    IndexOptions := [];
  end;
  // Look for existing index
  for i := 0 to Pred(ClientDataSet.IndexDefs.Count) do
  begin
    if ClientDataSet.IndexDefs[i].Name = NewIndexName then
    begin
      Result := True;
      Break
    end; // if
  end; // for
  // If existing index not found, create one
  if not Result then
  begin
    ClientDataSet.AddIndex(NewIndexName, FieldName, IndexOptions);
    Result := True;
  end; // if not
  // Set the index
  ClientDataSet.IndexName := NewIndexName;
end;

procedure TFrmWmiDatabase.ButtonBuildWmiDatabaseClick(Sender: TObject);
var
  LAsyncCall: IAsyncCall;
  d: TDateTime;

  procedure Dummy;
  begin
    BuildWmiDatabase;
  end;

begin
  d := now;
  ButtonBuildWmiDatabase.Enabled := False;
  // BuildWmiDatabase;

  if FileExists(FDatabaseFile) then
  begin
    ClientDataSetWmi.LoadFromFile(FDatabaseFile);
    ClientDataSetWmi.DisableControls;
    SetGridColumnWidths(DBGridWMI);
    ClientDataSetWmi.EnableControls;

    MsgInformation('The WMI database has been restored from the disk');
  end
  else
  begin
    PanelStatus.Height := 90;
{$IFNDEF CPUX64}
    LAsyncCall := LocalAsyncCall(@Dummy);
{$ELSE}
    LAsyncCall := AsyncCall(@Dummy, nil);
{$ENDIF ~CPUX64}
    while AsyncMultiSync([LAsyncCall], True, 1) = WAIT_TIMEOUT do
      Application.ProcessMessages;

    MsgInformation(Format('The WMI database has been created - Elapsed time %s',
      [FormatDateTime('hh:nn:ss.zzz', now - d)]));

    if MsgQuestion('Do you want store the database in the disk?') then
      SaveWmiDatabase;

    PanelStatus.Height := 0;
  end;

  SetLog(FormatDateTime('hh:nn:ss.zzz', now - d));
  DBGridWMI.Enabled := True;
  ComboBoxSearch2.Enabled := True;
  EditSearch.Enabled := True;
  ButtonSearchWmiDatabase.Enabled := True;
  ButtonDelBdd.Enabled := True;
  ButtonSaveBdd.Enabled := True;
  GroupBoxMode.Enabled := True;
  GroupBoxSearchIn.Enabled := True;
  GroupBoxTypes.Enabled := True;
end;

procedure TFrmWmiDatabase.ButtonDelBddClick(Sender: TObject);
begin
  DeleteWmiDatabase;
end;

procedure TFrmWmiDatabase.ButtonSaveBddClick(Sender: TObject);
begin
  SaveWmiDatabase;
end;

procedure TFrmWmiDatabase.ButtonSearchWmiDatabaseClick(Sender: TObject);
begin
  SearchDatabase(EditSearch.Text);
end;

procedure TFrmWmiDatabase.ComboBoxSearch2Change(Sender: TObject);
begin
  SearchDatabase(ComboBoxSearch2.Text);
end;

procedure TFrmWmiDatabase.ComboBoxSearch2Exit(Sender: TObject);
begin
  if (Trim(ComboBoxSearch2.Text) <> '') and (ComboBoxSearch2.Items.IndexOf(ComboBoxSearch2.Text) = -1) then
  begin
    if ComboBoxSearch2.Items.Count = MaxHistory then
      ComboBoxSearch2.Items.Delete(ComboBoxSearch2.Items.Count - 1);
    ComboBoxSearch2.Items.Insert(0, ComboBoxSearch2.Text);
  end;
end;

procedure TFrmWmiDatabase.CreateWmiDatabaseStructure;
begin
  with ClientDataSetWmi do
  begin
    FieldDefs.Add('Namespace', ftString, 60);
    FieldDefs.Add('Class', ftString, 60);
    FieldDefs.Add('Name', ftString, 60);
    FieldDefs.Add('Type', ftString, 25);
    FieldDefs.Add('Value', ftString, 1024);
    IndexDefs.Add('IxValue', 'value', [ixCaseInsensitive]);
    // IndexDefs.Add('idx_namespace','namespace',);
    CreateDataSet;
    LogChanges := False;
    // Open;
  end;
end;

procedure TFrmWmiDatabase.DBGridWMIDblClick(Sender: TObject);
begin
  if ClientDataSetWmi.Active then
    ListValuesWmiProperties(ClientDataSetWmi.FieldByName('Namespace').AsString, ClientDataSetWmi.FieldByName('Class')
      .AsString, nil, SetLog);
end;

procedure TFrmWmiDatabase.DeleteWmiDatabase;
begin
  if ClientDataSetWmi.Active then
  begin
    ClientDataSetWmi.EmptyDataSet;
    DeleteFile(FDatabaseFile);
    ComboBoxSearch2.Enabled := False;
    EditSearch.Enabled := False;
    ButtonBuildWmiDatabase.Enabled := True;
    ButtonSearchWmiDatabase.Enabled := False;
    ButtonDelBdd.Enabled := False;
    ButtonSaveBdd.Enabled := False;
    GroupBoxMode.Enabled := False;
    GroupBoxSearchIn.Enabled := False;
    GroupBoxTypes.Enabled := False;
    DBGridWMI.Enabled := False;
    MsgInformation(Format('The WMI Database has been deleted', []));
  end;
end;

procedure TFrmWmiDatabase.EditSearchChange(Sender: TObject);
begin
  SearchDatabase(EditSearch.Text);
end;

procedure TFrmWmiDatabase.FormCreate(Sender: TObject);
begin
  PanelStatus.Height := 0;
  FNameSpaces := TStringList.Create;
  FNameSpaces.AddStrings(CachedWMIClasses.NameSpaces);
  FDatabaseFile := GetWMICFolderCache + WmiDatabaseName;
  FHistoryFile := GetWMICFolderCache + 'WmiFiltersHistory.txt';

  if FileExists(FHistoryFile) then
    ComboBoxSearch2.Items.LoadFromFile(FHistoryFile);

  CreateWmiDatabaseStructure;
end;

procedure TFrmWmiDatabase.FormDestroy(Sender: TObject);
begin
  ComboBoxSearch2.Items.SaveToFile(FHistoryFile);
  FNameSpaces.Free;
end;

procedure TFrmWmiDatabase.SaveWmiDatabase;
begin
  if ClientDataSetWmi.Active then
  begin
    if FileExists(FDatabaseFile) then
      if not MsgQuestion('Do you want overwrite the database stored in the disk?') then
        Exit;

    DeleteFile(FDatabaseFile);
    ClientDataSetWmi.SaveToFile(FDatabaseFile, dfXMLUTF8);
    MsgInformation(Format('The WMI Database has been stored to %s', [FDatabaseFile]));
  end;
end;

procedure TFrmWmiDatabase.SearchDatabase(Value: string);
var
  Filter: string;
begin
  Value := Trim(Value);
  if Value <> '' then
  begin
    ClientDataSetWmi.DisableControls;
    try

      // ClientDataSetWmi.Filtered := False;
      if RadioButtonInsensitive.Checked then
        ClientDataSetWmi.FilterOptions := [foCaseInsensitive]
      else if RadioButtonSensitive.Checked then
        ClientDataSetWmi.FilterOptions := [];

      Filter := '';
      if CheckBoxClassDescr.Checked then
        Filter := ' (Value LIKE ' + QuotedStr('%' + Value + '%') + ')';

      if CheckBoxClasses.Checked then
      begin
        if Filter <> '' then
          Filter := Filter + ' OR ';
        Filter := Filter + ' (class LIKE ' + QuotedStr('%' + Value + '%') + ')';
      end;

      if CheckBoxNamespace.Checked then
      begin
        if Filter <> '' then
          Filter := Filter + ' OR ';
        Filter := Filter + ' (namespace LIKE ' + QuotedStr('%' + Value + '%') + ')';
      end;

      ClientDataSetWmi.Filter := Filter;
      ClientDataSetWmi.Filtered := True;

      SetGridColumnWidths(DBGridWMI);
      Status('Filter ' + ClientDataSetWmi.Filter);
    finally
      ClientDataSetWmi.EnableControls;
    end;
  end
  else
  begin
    ClientDataSetWmi.DisableControls;
    try
      ClientDataSetWmi.Filtered := False;
    finally
      ClientDataSetWmi.EnableControls;
    end;
  end;
end;

{
  procedure TFrmWmiDatabase.SetNameSpaces(const Value: TStrings);
  begin
  FNameSpaces.Clear;
  FNameSpaces.AddStrings(Value);
  end;
}
procedure TFrmWmiDatabase.Status(const Msg: string);
begin
  LabelMsg.Caption := Msg;
  LabelMsg.Update;
end;

end.
