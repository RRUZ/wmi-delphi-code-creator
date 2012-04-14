unit uWmiInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ValEdit;

type
  TFrmWMIInfo = class(TForm)
    ValueListEditor1: TValueListEditor;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadData;
  public
    { Public declarations }
  end;

implementation

uses
 uWmi_Metadata,
 ComObj,
 ActiveX;

{$R *.dfm}

{ TFrmWMIInfo }

procedure TFrmWMIInfo.FormCreate(Sender: TObject);
begin
 LoadData;
end;

procedure TFrmWMIInfo.LoadData;
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  wbemFlagForwardOnly = $00000020;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  LWMiClassMetaData : TWMiClassMetaData;
  LIndex        : Integer;

begin;
  LWMiClassMetaData:=TWMiClassMetaData.Create('root\CIMV2', 'Win32_WMISetting');
  try
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, 'root\CIMV2', WbemUser, WbemPassword);
    FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_WMISetting','WQL',wbemFlagForwardOnly);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = S_OK then
    begin
     for LIndex := 0 to LWMiClassMetaData.PropertiesCount-1 do
     begin
      ValueListEditor1.InsertRow(LWMiClassMetaData.Properties[LIndex].Name,
      FormatWbemValue(FWbemObject.Properties_.Item(LWMiClassMetaData.Properties[LIndex].Name).Value, LWMiClassMetaData.Properties[LIndex].CimType), True);
     end;
    end;
  finally
    LWMiClassMetaData.Free;
  end;
end;


end.
