{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiDatabase                                                                                }
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
{ The Original Code is uWmiDatabase.pas.                                                           }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiDatabase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

type
  TFrmWmiDatabase = class(TForm)
    DataSource1: TDataSource;
    ClientDataSetWmi: TClientDataSet;
    Panel2:    TPanel;
    Label7:    TLabel;
    GroupBoxTypes: TGroupBox;
    RadioButtonDynamic: TRadioButton;
    RadioButtonAll: TRadioButton;
    GroupBoxMode: TGroupBox;
    RadioButtonInsensitive: TRadioButton;
    RadioButtonSensitive: TRadioButton;
    ComboBoxSearch: TComboBox;
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
    procedure DBGridWMIDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure ButtonSearchWmiDatabaseClick(Sender: TObject);
    procedure ComboBoxSearchChange(Sender: TObject);
    procedure ComboBoxSearchExit(Sender: TObject);
    procedure ButtonBuildWmiDatabaseClick(Sender: TObject);
    procedure ButtonSaveBddClick(Sender: TObject);
    procedure ButtonDelBddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDatabaseFile: string;
    FHistoryFile:  string;
    procedure BuildWmiDatabase;
    procedure SearchDatabase(Value: string);
    procedure SaveWmiDatabase;
    procedure DeleteWmiDatabase;
    procedure CreateWmiDatabaseStructure;
  public
  end;

implementation

{$R *.dfm}

uses
  Main,
  ComObj,
  MidasLib,
  uWmi_Metadata,
  AsyncCalls,
  uMisc;

const
  MaxHistory      = 50;
  WmiDatabaseName = 'WmiDatabase.xml';


procedure SetGridColumnWidths(DbGrid: TDBGrid);
const
  DEFBORDER = 10;
var
  temp, n: integer;
  lmax:    array [0..30] of integer;
begin
  with DbGrid do
  begin
    Canvas.Font := Font;
    for n := 0 to Columns.Count - 1 do
      lmax[n] := Canvas.TextWidth(Fields[n].FieldName) + DEFBORDER;
    DbGrid.DataSource.DataSet.First;
    while not DbGrid.DataSource.DataSet.EOF do
    begin
      for n := 0 to Columns.Count - 1 do
      begin
        temp := Canvas.TextWidth(trim(Columns[n].Field.DisplayText)) + DEFBORDER;
        if temp > lmax[n] then
          lmax[n] := temp;
      end; {for}
      DbGrid.DataSource.DataSet.Next;
    end;
    DbGrid.DataSource.DataSet.First;
    for n := 0 to Columns.Count - 1 do
      if lmax[n] > 0 then
        Columns[n].Width := lmax[n];
  end;
end; {SetGridColumnWidths  }


procedure TFrmWmiDatabase.BuildWmiDatabase;
var
  i:     integer;
  j:     integer;
  k:     integer;
  Classes: TStringList;
  Props: TStringList;
  Methods: TStringList;
  Value: string;
begin
  ClientDataSetWmi.DisableControls;
  FrmMain.ProgressBarWmi.Visible := True;
  try
    for i := 0 to FrmMain.ComboBoxNameSpaces.Items.Count - 1 do
    begin
      FrmMain.SetMsg('Scaning namespace ' + FrmMain.ComboBoxNameSpaces.Items[i]);

      Classes := TStringList.Create;
      try
        if RadioButtonAll.Checked then
          GetListWmiClasses(FrmMain.ComboBoxNameSpaces.Items[i], Classes)
        else
        if RadioButtonDynamic.Checked then
          GetListWmiDynamicClasses(FrmMain.ComboBoxNameSpaces.Items[i], Classes);

        for j := 0 to Classes.Count - 1 do
        begin
          FrmMain.SetMsg('Scanning Class ' + Classes[j]);

          try
            Value := GetWmiClassDescription(
              FrmMain.ComboBoxNameSpaces.Items[i], Classes[j]);
          except
            on E: EOleSysError do
            begin
              FrmMain.MemoLog.Lines.Add(
                Format('%s - namespace %s class %s  - message : %s',
                ['GetWmiClassDescription', FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], E.Message]));
              Value := '';
            end;
          end;

          if Value <> '' then
          begin
            ClientDataSetWmi.Append;
            ClientDataSetWmi.Fields[0].AsString :=
              FrmMain.ComboBoxNameSpaces.Items[i]; //namespace
            ClientDataSetWmi.Fields[1].AsString := Classes[j];
            //class
            ClientDataSetWmi.Fields[2].AsString := Classes[j];
            //name
            //ClientDataSetWmi.Fields[3].AsInteger:= WmiTableType_Class;          //type
            ClientDataSetWmi.Fields[3].AsString := 'Class';          //type
            ClientDataSetWmi.Fields[4].AsString := Value;          //value
            ClientDataSetWmi.Post;
          end;


          if CheckBoxProperties.Checked then
          begin
            Props := TStringList.Create;
            try

              try
                GetListWmiClassProperties(
                  FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], Props);
              except
                on E: EOleSysError do
                begin
                  FrmMain.MemoLog.Lines.Add(
                    Format('%s - namespace %s class %s  - message : %s',
                    ['GetListWmiClassProperties', FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], E.Message]));
                end;
              end;


              for k := 0 to Props.Count - 1 do
              begin

                try
                  Value :=
                    GetWmiPropertyDescription(FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], Props[k]);
                except
                  on E: EOleSysError do
                  begin
                    FrmMain.MemoLog.Lines.Add(
                      Format('%s - namespace %s class %s  property %s - message : %s',
                      ['GetWmiPropertyDescription', FrmMain.ComboBoxNameSpaces.Items[i],
                      Classes[j], Props[k], E.Message]));
                    Value := '';
                  end;
                end;


                if Value <> '' then
                begin
                  ClientDataSetWmi.Append;
                  ClientDataSetWmi.Fields[0].AsString :=
                    FrmMain.ComboBoxNameSpaces.Items[i]; //namespace
                  ClientDataSetWmi.Fields[1].AsString := Classes[j];
                  //class
                  ClientDataSetWmi.Fields[2].AsString := Props[k];
                  //name
                  //ClientDataSetWmi.Fields[3].AsInteger:= WmiTableType_Class;          //type
                  ClientDataSetWmi.Fields[3].AsString := 'Property';          //type
                  ClientDataSetWmi.Fields[4].AsString := Value;               //value
                  ClientDataSetWmi.Post;
                end;
              end;
            finally
              Props.Free;
            end;
          end;


          if CheckBoxMethods.Checked then
          begin
            Methods := TStringList.Create;
            try

              try
                GetListWmiClassMethods(
                  FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], Methods);
              except
                on E: EOleSysError do
                begin
                  FrmMain.MemoLog.Lines.Add(
                    Format('%s - namespace %s class %s  - message : %s',
                    ['GetListWmiClassMethods', FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], E.Message]));
                end;
              end;

              for k := 0 to Methods.Count - 1 do
              begin

                try
                  Value :=
                    GetWmiMethodDescription(FrmMain.ComboBoxNameSpaces.Items[i], Classes[j], Methods[k]);
                except
                  on E: EOleSysError do
                  begin
                    FrmMain.MemoLog.Lines.Add(
                      Format('%s - namespace %s class %s  property %s - message : %s',
                      ['GetWmiMethodDescription', FrmMain.ComboBoxNameSpaces.Items[i],
                      Classes[j], Methods[k], E.Message]));
                    Value := '';
                  end;
                end;


                if Value <> '' then
                begin
                  ClientDataSetWmi.Append;
                  ClientDataSetWmi.Fields[0].AsString :=
                    FrmMain.ComboBoxNameSpaces.Items[i]; //namespace
                  ClientDataSetWmi.Fields[1].AsString := Classes[j];
                  //class
                  ClientDataSetWmi.Fields[2].AsString := Methods[k];
                  //name
                  //ClientDataSetWmi.Fields[3].AsInteger:= WmiTableType_Class;          //type
                  ClientDataSetWmi.Fields[3].AsString := 'Method';          //type
                  ClientDataSetWmi.Fields[4].AsString := Value;             //value
                  ClientDataSetWmi.Post;
                end;
              end;
            finally
              Methods.Free;
            end;
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
    FrmMain.ProgressBarWmi.Visible := False;
    FrmMain.SetMsg('');
  end;

end;


procedure TFrmWmiDatabase.ButtonBuildWmiDatabaseClick(Sender: TObject);
var
  AsyncCall: IAsyncCall;
  d: TDateTime;

  procedure Dummy;
  begin
    BuildWmiDatabase;
  end;

begin
  d := now;
  ButtonBuildWmiDatabase.Enabled := False;
  //BuildWmiDatabase;

  if FileExists(FDatabaseFile) then
  begin
    ClientDataSetWmi.LoadFromFile(FDatabaseFile);
    MsgInformation('The WMI database has been restored from the disk');
  end
  else
  begin
    AsyncCall := LocalAsyncCall(@Dummy);
    while AsyncMultiSync([AsyncCall], True, 1) = WAIT_TIMEOUT do
      Application.ProcessMessages;
    MsgInformation(Format('The WMI database has been created - Elapsed time %s',
      [FormatDateTime('hh:nn:ss.zzz', Now - d)]));

    if MsgQuestion('Do you want store the database in the disk?') then
      SaveWmiDatabase;

  end;

  FrmMain.MemoLog.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now - d));
  DBGridWMI.Enabled      := True;
  ComboBoxSearch.Enabled := True;
  ButtonSearchWmiDatabase.Enabled := True;
  ButtonDelBdd.Enabled   := True;
  ButtonSaveBdd.Enabled  := True;
  GroupBoxMode.Enabled   := True;
  GroupBoxSearchIn.Enabled := True;
  GroupBoxTypes.Enabled  := True;
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
  SearchDatabase(ComboBoxSearch.Text);
end;

procedure TFrmWmiDatabase.ComboBoxSearchChange(Sender: TObject);
begin
  SearchDatabase(ComboBoxSearch.Text);
end;

procedure TFrmWmiDatabase.ComboBoxSearchExit(Sender: TObject);
begin
  if (Trim(ComboBoxSearch.Text) <> '') and
    (ComboBoxSearch.Items.IndexOf(ComboBoxSearch.Text) = -1) then
  begin
    if ComboBoxSearch.Items.Count = MaxHistory then
      ComboBoxSearch.Items.Delete(ComboBoxSearch.Items.Count - 1);
    ComboBoxSearch.Items.Insert(0, ComboBoxSearch.Text);
  end;
end;

procedure TFrmWmiDatabase.CreateWmiDatabaseStructure;
begin
  with ClientDataSetWmi do
  begin
    FieldDefs.Add('Namespace', ftString, 60);
    FieldDefs.Add('Class', ftString, 60);
    FieldDefs.Add('Name', ftString, 60);
    //FieldDefs.Add('Type', ftInteger);
    FieldDefs.Add('Type', ftString, 25);
    FieldDefs.Add('Value', ftString, 1024);
    IndexDefs.Add('IxValue', 'value', [ixCaseInsensitive]);
    //IndexDefs.Add('idx_namespace','namespace',);
    CreateDataSet;
    LogChanges := False;
    //Open;
  end;
end;

procedure TFrmWmiDatabase.DBGridWMIDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
var
  DbGrid: TDBGrid;
  Row:    integer;
begin
  DbGrid := Sender as TDBGrid;
  Row    := DbGrid.DataSource.DataSet.RecNo;

  if (gdSelected in State) then
  begin
    with DbGrid.Canvas do
    begin
      Brush.Color := clHighlight;
      Font.Style  := Font.Style + [fsBold];
      Font.Color  := clHighlightText;
    end;
  end
  else
  if Odd(Row) then
    DbGrid.Canvas.Brush.Color := clWindow
  else
    DbGrid.Canvas.Brush.Color := clBtnFace;

  DbGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFrmWmiDatabase.DeleteWmiDatabase;
begin
  if ClientDataSetWmi.Active then
  begin
    ClientDataSetWmi.EmptyDataSet;
    DeleteFile(FDatabaseFile);

    ComboBoxSearch.Enabled := False;
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

procedure TFrmWmiDatabase.FormCreate(Sender: TObject);
begin
  FDatabaseFile := ExtractFilePath(Application.ExeName) + WmiDatabaseName;
  FHistoryFile  := ExtractFilePath(Application.ExeName) + 'WmiFiltersHistory.txt';
  if FileExists(FHistoryFile) then
    ComboBoxSearch.Items.LoadFromFile(FHistoryFile);

  CreateWmiDatabaseStructure;
end;

procedure TFrmWmiDatabase.FormDestroy(Sender: TObject);
begin
  ComboBoxSearch.Items.SaveToFile(FHistoryFile);
end;

procedure TFrmWmiDatabase.SaveWmiDatabase;
begin

  if ClientDataSetWmi.Active then
  begin
    if FileExists(FDatabaseFile) then
      if not MsgQuestion('Do you want overwrite the database stored in the disk?') then
        exit;

    FrmMain.SetMsg('Storing WMI Database');
    try
      DeleteFile(FDatabaseFile);
      ClientDataSetWmi.SaveToFile(FDatabaseFile, dfXMLUTF8);
      MsgInformation(Format('The WMI Database has been stored to %s', [FDatabaseFile]));
    finally
      FrmMain.SetMsg('');
    end;
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

      //ClientDataSetWmi.Filtered := False;
      if RadioButtonInsensitive.Checked then
        ClientDataSetWmi.FilterOptions := [foCaseInsensitive]
      else
      if RadioButtonSensitive.Checked then
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


      ClientDataSetWmi.Filter   := Filter;
      ClientDataSetWmi.Filtered := True;

      SetGridColumnWidths(DBGridWMI);
      FrmMain.SetMsg('Filter ' + ClientDataSetWmi.Filter);
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

end.
