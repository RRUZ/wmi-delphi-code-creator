unit uWmiInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ValEdit, uHostsAdmin, uMisc,
  Vcl.ComCtrls;

type
  TFrmWMIInfo = class(TForm)
    ValueListEditorWMI: TValueListEditor;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ValueListEditorOS: TValueListEditor;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FWMIHost: TWMIHost;
    Dataloaded : Boolean;
    FSetLog: TProcLog;
    procedure LoadData;
  public
    property SetLog : TProcLog read FSetLog Write FSetLog;
    property  WMIHost : TWMIHost read FWMIHost Write FWMIHost;
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
 FWMIHost:=nil;
 Dataloaded:=False;
end;

procedure TFrmWMIInfo.FormShow(Sender: TObject);
begin
 if not Dataloaded then
   LoadData;
end;

procedure TFrmWMIInfo.LoadData;
const
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
  SetLog('Getting WMI Metadata');
  try
    if FWMIHost=nil then
     LWMiClassMetaData:=TWMiClassMetaData.Create('root\CIMV2', 'Win32_WMISetting')
    else
     LWMiClassMetaData:=TWMiClassMetaData.Create('root\CIMV2', 'Win32_WMISetting', FWMIHost.Host, FWMIHost.User, FWMIHost.PassWord);

    try
      FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');

      if FWMIHost=nil then
       FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '')
      else
      begin
       SetLog(Format('Connecting to [%s]',[FWMIHost.Host]));
       FWMIService   := FSWbemLocator.ConnectServer(FWMIHost.Host, 'root\CIMV2', FWMIHost.User, FWMIHost.PassWord);
       SetLog('Done');
      end;

      FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_WMISetting','WQL',wbemFlagForwardOnly);
      oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
      if oEnum.Next(1, FWbemObject, iValue) = S_OK then
      begin
       for LIndex := 0 to LWMiClassMetaData.PropertiesCount-1 do
       begin
        ValueListEditorWMI.InsertRow(LWMiClassMetaData.Properties[LIndex].Name,
        FormatWbemValue(FWbemObject.Properties_.Item(LWMiClassMetaData.Properties[LIndex].Name).Value, LWMiClassMetaData.Properties[LIndex].CimType), True);
       end;
      end;
      Dataloaded:=True;
    finally
      LWMiClassMetaData.Free;
    end;

    if FWMIHost=nil then
     LWMiClassMetaData:=TWMiClassMetaData.Create('root\CIMV2', 'Win32_OperatingSystem')
    else
     LWMiClassMetaData:=TWMiClassMetaData.Create('root\CIMV2', 'Win32_OperatingSystem', FWMIHost.Host, FWMIHost.User, FWMIHost.PassWord);

    try
      FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_OperatingSystem','WQL',wbemFlagForwardOnly);
      oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
      if oEnum.Next(1, FWbemObject, iValue) = S_OK then
      begin
       for LIndex := 0 to LWMiClassMetaData.PropertiesCount-1 do
       begin
        ValueListEditorOS.InsertRow(LWMiClassMetaData.Properties[LIndex].Name,
        FormatWbemValue(FWbemObject.Properties_.Item(LWMiClassMetaData.Properties[LIndex].Name).Value, LWMiClassMetaData.Properties[LIndex].CimType), True);
       end;
      end;
      Dataloaded:=True;
    finally
      LWMiClassMetaData.Free;
    end;
  except
    on E: EOleSysError do
        SetLog(Format('EOleSysError  %s  Code : %x', [E.Message, E.ErrorCode]));
    on E: Exception do
        SetLog(Format('Exception %s ', [E.Message]));
  end;

end;


end.
