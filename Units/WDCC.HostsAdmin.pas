// **************************************************************************************************
//
// Unit WDCC.HostsAdmin
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
// The Original Code is WDCC.HostsAdmin.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************
unit WDCC.HostsAdmin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, System.Types, Generics.Collections,
  Data.DB, Datasnap.DBClient, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TFrmHostAdmin = class(TForm)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    DBEdit4: TDBEdit;
    Label4: TLabel;
    DBNavigator1: TDBNavigator;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientDataSet1PostError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
  private
    { Private declarations }
    procedure CreateStructure;
  public
    { Public declarations }
  end;

  TWMIHost = class
  private
    FHost: string;
    FPassWord: string;
    FDescription: string;
    FUser: string;
    FForm: TForm;
  public
    property Host: string read FHost;
    property PassWord: string read FPassWord;
    property User: string read FUser;
    property Description: string read FDescription;
    property Form: TForm read FForm write FForm;
  end;

function ExistWMIHostDb: Boolean;
function GetWMIHostDbName: String;
function GetWMIRegisteredHosts: TStringDynArray; overload;
function GetListWMIRegisteredHosts: TObjectList<TWMIHost>; overload;

implementation

uses
  IOUtils,
  WDCC.Misc,
  WDCC.Settings,
  MidasLib;

{$R *.dfm}

function GetWMIRegisteredHosts: TStringDynArray;
var
  LClientDataSet: TClientDataSet;
  ResultArray: TStringDynArray;
  LIndex: Integer;
begin
  Result := nil;
  ResultArray := nil;

  if ExistWMIHostDb then
  begin
    LClientDataSet := TClientDataSet.Create(nil);
    try
      LClientDataSet.LoadFromFile(GetWMIHostDbName);
      LClientDataSet.Open;
      SetLength(ResultArray, LClientDataSet.RecordCount + 1);
      ResultArray[0] := 'localhost';
      LIndex := 1;
      while not LClientDataSet.Eof do
      begin
        ResultArray[LIndex] := LClientDataSet.FieldByName('Host').AsString;
        Inc(LIndex);

        LClientDataSet.Next;
      end;
      LClientDataSet.Close;
    finally
      LClientDataSet.Free;
    end;
  end
  else
  begin
    SetLength(ResultArray, 1);
    ResultArray[0] := 'localhost';
  end;

  Result := ResultArray;
end;

function GetListWMIRegisteredHosts: TObjectList<TWMIHost>;
var
  LClientDataSet: TClientDataSet;
begin
  Result := TObjectList<TWMIHost>.Create;
  {
    Result.Add(TWMIHost.Create);
    Result[Result.Count-1].FHost:='localhost';
    Result[Result.Count-1].FPassWord:='';
    Result[Result.Count-1].FUser:='';
    Result[Result.Count-1].FDescription:='localhost';
    Result[Result.Count-1].FForm:=nil;
  }
  if ExistWMIHostDb then
  begin
    LClientDataSet := TClientDataSet.Create(nil);
    try
      LClientDataSet.LoadFromFile(GetWMIHostDbName);
      LClientDataSet.Open;
      while not LClientDataSet.Eof do
      begin
        Result.Add(TWMIHost.Create);
        Result[Result.Count - 1].FHost := LClientDataSet.FieldByName('Host').AsString;
        Result[Result.Count - 1].FPassWord := LClientDataSet.FieldByName('Password').AsString;
        Result[Result.Count - 1].FUser := LClientDataSet.FieldByName('User').AsString;
        Result[Result.Count - 1].FDescription := LClientDataSet.FieldByName('Description').AsString;
        Result[Result.Count - 1].FForm := nil;
        LClientDataSet.Next;
      end;
      LClientDataSet.Close;
    finally
      LClientDataSet.Free;
    end;
  end;
end;

function GetWMIHostDbName: String;
begin
  Result := GetWMICFolderCache + 'WMIhosts.xml';
end;

function ExistWMIHostDb: Boolean;
begin
  Result := TFile.Exists(GetWMIHostDbName);
end;

{ TFrmHostAdmin }

procedure TFrmHostAdmin.ClientDataSet1PostError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
begin
  Action := daAbort;
  MsgWarning(Format('The host %s was previously registered [%s]', [ClientDataSet1.FieldByName('Host').AsString,
    E.Message]));
end;

procedure TFrmHostAdmin.CreateStructure;
begin
  if ClientDataSet1.Active then
    ClientDataSet1.Close;
  ClientDataSet1.FieldDefs.Clear;
  ClientDataSet1.FieldDefs.Add('Host', ftString, 40, True);
  ClientDataSet1.FieldDefs.Add('User', ftString, 40, True);
  ClientDataSet1.FieldDefs.Add('Password', ftString, 40, True);
  ClientDataSet1.FieldDefs.Add('Description', ftString, 255, True);
  ClientDataSet1.IndexDefs.Add('Host', 'Host', [ixPrimary, ixUnique, ixCaseInsensitive]);
  ClientDataSet1.IndexName := 'Host';
  ClientDataSet1.CreateDataSet;
end;

procedure TFrmHostAdmin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientDataSet1.SaveToFile(GetWMIHostDbName);
end;

procedure TFrmHostAdmin.FormCreate(Sender: TObject);
begin
  if not ExistWMIHostDb then
    CreateStructure
  else
  begin
    ClientDataSet1.LoadFromFile(GetWMIHostDbName);
    ClientDataSet1.IndexDefs.Add('Host', 'Host', [ixPrimary, ixUnique, ixCaseInsensitive]);
    ClientDataSet1.IndexName := 'Host';
  end;
  ClientDataSet1.Open;
end;

end.
