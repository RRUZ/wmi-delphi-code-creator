{**************************************************************************************************}
{                                                                                                  }
{ Unit                                                                                      }
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
{ The Original Code is uSqlWMI.pas.                                                                }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uSqlWMI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, Generics.Collections,
  Vcl.DBGrids, Vcl.StdCtrls, SynEditHighlighter, SynHighlighterSQL, uMisc, ActiveX,
  Vcl.ExtCtrls, SynEdit, uSynEditPopupEdit, uComboBox, Vcl.DBCtrls,
  SynCompletionProposal, Vcl.ComCtrls, Vcl.ImgList;

type
  TWMIPropData = class
  private
    FName: string;
    FCimType: Integer;
  public
    property Name : string read FName write FName;
    property CimType : Integer read FCimType write FCimType;
  end;

  TFrmWMISQL = class(TForm)
    SynEditWQL: TSynEdit;
    BtnExecuteWQL: TButton;
    PanelTop: TPanel;
    PanelNav: TPanel;
    SynSQLSyn1: TSynSQLSyn;
    CbNameSpaces: TComboBox;
    Label1: TLabel;
    DBGridWMI: TDBGrid;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBNavigator1: TDBNavigator;
    EditMachine: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    EditUser: TEdit;
    EditPassword: TEdit;
    Label4: TLabel;
    SynCompletionProposal1: TSynCompletionProposal;
    Splitter1: TSplitter;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    Splitter2: TSplitter;
    CheckBoxAutoWQL: TCheckBox;
    ComboBoxClasses: TComboBox;
    LabelClasses: TLabel;
    ListViewProperties: TListView;
    LabelProperties: TLabel;
    CheckBoxSelAllProps: TCheckBox;
    ImageList1: TImageList;
    procedure BtnExecuteWQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditMachineExit(Sender: TObject);
    procedure EditUserExit(Sender: TObject);
    procedure EditPasswordExit(Sender: TObject);
    procedure CbNameSpacesChange(Sender: TObject);
    procedure CheckBoxAutoWQLClick(Sender: TObject);
    procedure ListViewPropertiesClick(Sender: TObject);
    procedure CheckBoxSelAllPropsClick(Sender: TObject);
    procedure ComboBoxClassesChange(Sender: TObject);
  private
    FSWbemLocator : OLEVariant;
    FWMIService   : OLEVariant;
    FWbemObjectSet: OLEVariant;
    FWbemObject   : OLEVariant;
    FFields       : TObjectList<TWMIPropData>;
    oEnum         : IEnumvariant;
    iValue        : LongWord;
    FLog: TProcLog;
    FUser: string;
    FMachine: string;
    FPassword: string;
    procedure SetNameSpaces(const Value: TStrings);
    function GetNameSpaces: TStrings;
    procedure CreateStructure;
    procedure RunWQL;
    procedure SetMachine(const Value: string);
    procedure SetPassWord(const Value: string);
    procedure SetUser(const Value: string);
    procedure LoadClassInfo;
    procedure LoadWmiClasses(const Namespace: string);
    procedure GenerateSqlCode;
  public
    procedure SetNameSpaceIndex(Index : integer);
    property Log   : TProcLog read FLog write FLog;
    property NameSpaces : TStrings read GetNameSpaces Write SetNameSpaces;
    property User : string read FUser write SetUser;
    property Password : string read FPassword write SetPassWord;
    property Machine  : string read FMachine write SetMachine;
  end;


implementation

uses
 uGlobals,
 uListView_Helper,
 MidasLib,
 uSettings,
 uWmi_Metadata,
 uOleVariantEnum,
 System.Win.ComObj;

{$R *.dfm}
  {
type
  TDBGridH = class(TDBGrid);
   }



{ TFrmWMISQL }

procedure TFrmWMISQL.BtnExecuteWQLClick(Sender: TObject);
begin
 RunWQL;
end;

procedure TFrmWMISQL.CbNameSpacesChange(Sender: TObject);
begin
  LoadWmiClasses(TComboBox(Sender).Text);
  ComboBoxClasses.ItemIndex := 0;
  LoadClassInfo;
end;

procedure TFrmWMISQL.CheckBoxAutoWQLClick(Sender: TObject);
begin
 if CheckBoxAutoWQL.Checked then
  GenerateSqlCode;
end;

procedure TFrmWMISQL.CheckBoxSelAllPropsClick(Sender: TObject);
var
  LIndex: integer;
begin
  for LIndex := 0 to ListViewProperties.Items.Count - 1 do
    ListViewProperties.Items[LIndex].Checked := CheckBoxSelAllProps.Checked;

  if CheckBoxAutoWQL.Checked then
    GenerateSqlCode;
end;


procedure TFrmWMISQL.ComboBoxClassesChange(Sender: TObject);
begin
  LoadClassInfo;
end;

procedure TFrmWMISQL.CreateStructure;
var
  colItems : OleVariant;
  colItem  : OleVariant;
begin
  if ClientDataSet1.Active then ClientDataSet1.Close;

  ClientDataSet1.FieldDefs.Clear;
  FFields.Clear;

  colItems := FWbemObject.Properties_;
  for colItem in GetOleVariantEnum(colItems) do
  begin
    FFields.Add(TWMIPropData.Create);
    FFields.Items[FFields.Count-1].Name   :=colItem.Name;
    FFields.Items[FFields.Count-1].CimType:=colItem.cimtype;

    {
    PropertyMetaData:=TWMiPropertyMetaData.Create;
    FCollectionPropertyMetaData.Add(PropertyMetaData);
    PropertyMetaData.FName:=VarStrNull(colItem.Name);
    PropertyMetaData.FType:=CIMTypeStr(colItem.cimtype);
    PropertyMetaData.FCimType:=colItem.cimtype;
    }
    with ClientDataSet1 do
      FieldDefs.Add(colItem.Name, ftString, 255);

  end;

  ClientDataSet1.CreateDataSet;
end;

procedure TFrmWMISQL.EditMachineExit(Sender: TObject);
begin
 FMachine:=EditMachine.Text;
end;

procedure TFrmWMISQL.EditPasswordExit(Sender: TObject);
begin
 FPassword:=EditPassword.Text;
end;

procedure TFrmWMISQL.EditUserExit(Sender: TObject);
begin
 FUser:=EditUser.Text;
end;

procedure TFrmWMISQL.FormCreate(Sender: TObject);
begin
  FUser:='';
  FPassword:='';
  FMachine:='localhost';
  FFields:=TObjectList<TWMIPropData>.Create(True);
end;

procedure TFrmWMISQL.FormDestroy(Sender: TObject);
begin
  FFields.Free;
end;

procedure TFrmWMISQL.GenerateSqlCode;
Var
 c,LIndex : Integer;
 LFields : string;
begin
 LFields:='';
 c:=0;
 for LIndex := 0 to ListViewProperties.Items.Count-1 do
  if ListViewProperties.Items.Item[LIndex].Checked then
  begin
   LFields:=LFields+ListViewProperties.Items.Item[LIndex].Caption+',';
   inc(c);
  end;

 if (LFields='') or (CheckBoxSelAllProps.Checked) or (c=ListViewProperties.Items.Count) then
   LFields:='*'
 else
   Delete(LFields,Length(LFields),1);

  SynEditWQL.Lines.Text:=Format('Select %s from %s',[LFields, ComboBoxClasses.Text]);
end;

function TFrmWMISQL.GetNameSpaces: TStrings;
begin
   Result:=CbNameSpaces.Items;
end;

procedure TFrmWMISQL.ListViewPropertiesClick(Sender: TObject);
   procedure SetCheck(const CheckBox : TCheckBox; const Value : boolean) ;
   var
     NotifyEvent : TNotifyEvent;
   begin
     with CheckBox do
     begin
       NotifyEvent := OnClick;
       OnClick := nil;
       Checked := Value;
       OnClick := NotifyEvent;
     end;
   end;

begin
  if CheckBoxSelAllProps.Checked  then
    SetCheck(CheckBoxSelAllProps, False);

  if CheckBoxAutoWQL.Checked then
    GenerateSqlCode;
end;

procedure TFrmWMISQL.LoadClassInfo;
var
  WmiMetaClassInfo : TWMiClassMetaData;
  LIndex : integer;
  LItem : TListItem;
begin
  if ComboBoxClasses.ItemIndex=-1 then exit;

  try
    WmiMetaClassInfo:=CachedWMIClasses.GetWmiClass(CbNameSpaces.Text, ComboBoxClasses.Text);

    if Assigned(WmiMetaClassInfo) then
    begin
      //SetMsg(Format('Loading Info Class %s:%s', [WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]));
      {
      MemoClassDescr.Text :=  WmiMetaClassInfo.Description;
      if MemoClassDescr.Text = '' then
        MemoClassDescr.Text := 'Class without description available';

      LoadWmiProperties(WmiMetaClassInfo);
      }

      ListViewProperties.Items.BeginUpdate;
      try
        ListViewProperties.Items.Clear;

        for LIndex := 0 to WmiMetaClassInfo.PropertiesCount - 1 do
        begin
          LItem := ListViewProperties.Items.Add;
          LItem.Caption := WmiMetaClassInfo.Properties[LIndex].Name;
          LItem.SubItems.Add(WmiMetaClassInfo.Properties[LIndex].&Type);
          LItem.SubItems.Add(WmiMetaClassInfo.Properties[LIndex].Description);
          LItem.Checked := CheckBoxSelAllProps.Checked;
          LItem.Data    := Pointer(WmiMetaClassInfo.Properties[LIndex].CimType); //Cimtype
        end;

        LabelProperties.Caption := Format('%d Properties of %s:%s',
          [ListViewProperties.Items.Count, WmiMetaClassInfo.WmiNameSpace, WmiMetaClassInfo.WmiClass]);
      finally
        ListViewProperties.Items.EndUpdate;
      end;
      //SetMsg('');

      for LIndex := 0 to ListViewProperties.Columns.Count - 1 do
        AutoResizeColumn(ListViewProperties.Column[LIndex]);

      ListViewProperties.Repaint;
      if CheckBoxAutoWQL.Checked then
        GenerateSqlCode;
    end;
  finally
    //SetMsg('');
  end;
end;
procedure TFrmWMISQL.LoadWmiClasses(const Namespace: string);
var
  FClasses: TStringList;
begin
  //SetMsg(Format('Loading Classes of %s', [Namespace]));

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
            Log(Format('Access denied  %s %s  Code : %x', ['GetListWmiClasses', E.Message, E.ErrorCode]))
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
      {
      if ComboBoxClasses.Items.Count>0 then
       ComboBoxClasses.ItemIndex:=0;
      }
      LabelClasses.Caption := Format('Classes (%d)', [FClasses.Count]);
    finally
      ComboBoxClasses.Items.EndUpdate;
    end;
  finally
    FClasses.Free;
  end;

  //SetMsg('');
end;

procedure TFrmWMISQL.RunWQL;
const
  wbemFlagForwardOnly = $00000020;
Var
 FirstRecord     : Boolean;
 F               : TWMIPropData;
 FWbemPropertySet: OleVariant;
begin
  FirstRecord:=True;
  ClientDataSet1.DisableControls;
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    try
      FWMIService   := FSWbemLocator.ConnectServer(FMachine, CbNameSpaces.Text, FUser, FPassword);
      FWbemObjectSet:= FWMIService.ExecQuery(SynEditWQL.Lines.Text, 'WQL', wbemFlagForwardOnly);

      oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
      while oEnum.Next(1, FWbemObject, iValue) = 0 do
      begin
        if FirstRecord then
        begin
          ClientDataSet1.EnableControls;
          try
            CreateStructure();
            SetGridColumnWidths(DBGridWMI);
          finally
            ClientDataSet1.DisableControls;
          end;
          FirstRecord:=False;
          if not ClientDataSet1.Active then ClientDataSet1.Open;
        end;
        //Writeln(Format('AsyncMDLReadsPersec    %d',[Integer(FWbemObject.AsyncMDLReadsPersec)]));// Uint32
        FWbemPropertySet:= FWbemObject.Properties_;
        ClientDataSet1.Append;
         for F in FFields do
         ClientDataSet1.FieldByName(F.Name).AsString:=FormatWbemValue(FWbemPropertySet.Item(F.Name, 0).Value, F.CimType);
           {
           case F.CimType of
                wbemCimtypeSint8,
                wbemCimtypeUint8,
                wbemCimtypeSint16,
                wbemCimtypeUint16,
                wbemCimtypeSint32,
                wbemCimtypeUint32,
                wbemCimtypeSint64,
                wbemCimtypeUint64   : ClientDataSet1.FieldByName(F.Name).AsString:=VarStrNull(FWbemPropertySet.Item(F.Name, 0).Value);

                wbemCimtypeReal32,
                wbemCimtypeReal64   : ClientDataSet1.FieldByName(F.Name).AsString:=VarStrNull(FWbemPropertySet.Item(F.Name, 0).Value);
                wbemCimtypeBoolean  : ClientDataSet1.FieldByName(F.Name).AsString:=VarStrNull(FWbemPropertySet.Item(F.Name, 0).Value);

                wbemCimtypeString   : ClientDataSet1.FieldByName(F.Name).AsString:=VarStrNull(FWbemPropertySet.Item(F.Name, 0).Value);
                wbemCimtypeDatetime : ClientDataSet1.FieldByName(F.Name).AsString:=VarStrNull(FWbemPropertySet.Item(F.Name, 0).Value);
                wbemCimtypeReference: ;
                wbemCimtypeChar16   : ClientDataSet1.FieldByName(F.Name).AsString:=VarStrNull(FWbemPropertySet.Item(F.Name, 0).Value);
                wbemCimtypeObject   : ;
           else
                ;
           end;
            }
        ClientDataSet1.Post;

        FWbemObject:=Unassigned;
      end;
    except
      on E:EOleException do
      begin
          MsgWarning(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
          Log(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
      end;
      on E:Exception do
      begin
          MsgWarning(E.Classname + ':' + E.Message);
          Log(E.Classname + ':' + E.Message);
      end;
    end;

    if not FirstRecord then
    begin
      if not ClientDataSet1.Active then ClientDataSet1.Open;
      SetGridColumnWidths(DBGridWMI);
    end;

  finally
    ClientDataSet1.EnableControls;
  end;
end;

procedure TFrmWMISQL.SetMachine(const Value: string);
begin
  FMachine := Value;
  EditMachine.Text:=Value;
end;

procedure TFrmWMISQL.SetNameSpaceIndex(Index: integer);
begin
  CbNameSpaces.ItemIndex:=Index;
  CbNameSpacesChange(CbNameSpaces);
end;


procedure TFrmWMISQL.SetNameSpaces(const Value: TStrings);
begin
  CbNameSpaces.Items.Clear;
  CbNameSpaces.Items.AddStrings(Value);
end;


procedure TFrmWMISQL.SetPassWord(const Value: string);
begin
  FPassword := Value;
  EditPassword.Text:=Value;
end;

procedure TFrmWMISQL.SetUser(const Value: string);
begin
  FUser := Value;
  EditUser.Text:=Value;
end;

end.

