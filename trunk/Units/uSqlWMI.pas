unit uSqlWMI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, Generics.Collections,
  Vcl.DBGrids, Vcl.StdCtrls, SynEditHighlighter, SynHighlighterSQL, uMisc, ActiveX,
  Vcl.ExtCtrls, SynEdit, uSynEditPopupEdit, uComboBox, Vcl.DBCtrls,
  SynCompletionProposal;

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
    SynEdit1: TSynEdit;
    BtnExecuteWQL: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
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
    procedure BtnExecuteWQLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditMachineExit(Sender: TObject);
    procedure EditUserExit(Sender: TObject);
    procedure EditPasswordExit(Sender: TObject);
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
    property User : string read FUser write SetUser;
    property Password : string read FPassword write SetPassWord;
    property Machine  : string read FMachine write SetMachine;
  public
    property Log   : TProcLog read FLog write FLog;
    property NameSpaces : TStrings read GetNameSpaces Write SetNameSpaces;
  end;


implementation

uses
 MidasLib,
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

function TFrmWMISQL.GetNameSpaces: TStrings;
begin
   Result:=CbNameSpaces.Items;
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
      FWbemObjectSet:= FWMIService.ExecQuery(SynEdit1.Lines.Text, 'WQL', wbemFlagForwardOnly);

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

