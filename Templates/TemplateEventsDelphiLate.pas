//-----------------------------------------------------------------------------------------------------
//     This code was generated by the Wmi Delphi Code Creator (WDCC) Version [VERSIONAPP]
//     https://github.com/RRUZ/wmi-delphi-code-creator
//     Blog http://theroadtodelphi.wordpress.com/wmi-delphi-code-creator/
//     Author Rodrigo Ruz V. (RRUZ) Copyright (C) 2011-2023 
//----------------------------------------------------------------------------------------------------- 
//
//     LIABILITY DISCLAIMER
//     THIS GENERATED CODE IS DISTRIBUTED "AS IS". NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.
//     YOU USE IT AT YOUR OWN RISK. THE AUTHOR NOT WILL BE LIABLE FOR DATA LOSS,
//     DAMAGES AND LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR MISUSING THIS CODE.
//
//----------------------------------------------------------------------------------------------------
program GetWMI_Info;

{$APPTYPE CONSOLE}

uses
  Windows,
  {$IF CompilerVersion > 18.5}
  Forms,
  {$IFEND}
  OleServer,
  SysUtils,
  ActiveX,
  ComObj,
  Variants;

type
  TSWbemSinkOnObjectReady = procedure(ASender: TObject; const objWbemObject: OleVariant;
                                                        const objWbemAsyncContext: OleVariant) of object;
  TSWbemSinkOnCompleted = procedure(ASender: TObject; iHResult: TOleEnum;
                                                      const objWbemErrorObject: OleVariant;
                                                      const objWbemAsyncContext: OleVariant) of object;
  TSWbemSinkOnProgress = procedure(ASender: TObject; iUpperBound: Integer; iCurrent: Integer;
                                                     const strMessage: WideString;
                                                     const objWbemAsyncContext: OleVariant) of object;
  TSWbemSinkOnObjectPut = procedure(ASender: TObject; const objWbemObjectPath: OleVariant;
                                                      const objWbemAsyncContext: OleVariant) of object;

  ISWbemSink = interface(IDispatch)
    ['{75718C9F-F029-11D1-A1AC-00C04FB6C223}']
    procedure Cancel; safecall;
  end;

  TSWbemSink = class(TOleServer)
  private
    FOnObjectReady: TSWbemSinkOnObjectReady;
    FOnCompleted: TSWbemSinkOnCompleted;
    FOnProgress: TSWbemSinkOnProgress;
    FOnObjectPut: TSWbemSinkOnObjectPut;
    FIntf: ISWbemSink;
    function GetDefaultInterface: ISWbemSink;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
  public
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemSink);
    procedure Disconnect; override;
    procedure Cancel;
    property DefaultInterface: ISWbemSink read GetDefaultInterface;
  published
    property OnObjectReady: TSWbemSinkOnObjectReady read FOnObjectReady write FOnObjectReady;
    property OnCompleted: TSWbemSinkOnCompleted read FOnCompleted write FOnCompleted;
    property OnProgress: TSWbemSinkOnProgress read FOnProgress write FOnProgress;
    property OnObjectPut: TSWbemSinkOnObjectPut read FOnObjectPut write FOnObjectPut;
  end;


  TWmiAsyncEvent = class
  private
    FWQL: string;
    FSink: TSWbemSink;
    FLocator: OleVariant;
    FServices: OleVariant;
    procedure EventReceived(ASender: TObject; const objWbemObject: OleVariant; const objWbemAsyncContext: OleVariant);
  public
    procedure  Start;
    constructor Create;
    Destructor Destroy;override;
  end;

{ TSWbemSink }

procedure TSWbemSink.Cancel;
begin
 DefaultInterface.Cancel;
end;

procedure TSWbemSink.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as ISWbemSink;
  end;
end;

procedure TSWbemSink.ConnectTo(svrIntf: ISWbemSink);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TSWbemSink.Disconnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TSWbemSink.GetDefaultInterface: ISWbemSink;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

procedure TSWbemSink.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{75718C9A-F029-11D1-A1AC-00C04FB6C223}';
    IntfIID:   '{75718C9F-F029-11D1-A1AC-00C04FB6C223}';
    EventIID:  '{75718CA0-F029-11D1-A1AC-00C04FB6C223}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;


procedure TSWbemSink.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    1: if Assigned(FOnObjectReady) then
         FOnObjectReady(Self,
                        Params[0] {const ISWbemObject},
                        Params[1] {const ISWbemNamedValueSet});
    2: if Assigned(FOnCompleted) then
         FOnCompleted(Self,
                      Params[0] {WbemErrorEnum},
                      Params[1] {const ISWbemObject},
                      Params[2] {const ISWbemNamedValueSet});
    3: if Assigned(FOnProgress) then
         FOnProgress(Self,
                     Params[0] {Integer},
                     Params[1] {Integer},
                     Params[2] {const WideString},
                     Params[3] {const ISWbemNamedValueSet});
    4: if Assigned(FOnObjectPut) then
         FOnObjectPut(Self,
                      Params[0] {const ISWbemObjectPath},
                      Params[1] {const ISWbemNamedValueSet});
  end; {case DispID}

end;

  
//Detect when a key was pressed in the console window
function KeyPressed:Boolean;
var
  lpNumberOfEvents: DWORD;
  lpBuffer: TInputRecord;
  lpNumberOfEventsRead: DWORD;
  nStdHandle: THandle;
begin
  Result:=false;
  nStdHandle := GetStdHandle(STD_INPUT_HANDLE);
  lpNumberOfEvents:=0;
  GetNumberOfConsoleInputEvents(nStdHandle,lpNumberOfEvents);
  if lpNumberOfEvents<> 0 then
  begin
    PeekConsoleInput(nStdHandle,lpBuffer,1,lpNumberOfEventsRead);
    if lpNumberOfEventsRead <> 0 then
    begin
      if lpBuffer.EventType = KEY_EVENT then
      begin
        if lpBuffer.Event.KeyEvent.bKeyDown then
          Result:=true
        else
          FlushConsoleInputBuffer(nStdHandle);
      end
      else
      FlushConsoleInputBuffer(nStdHandle);
    end;
  end;
end;

{ TWmiAsyncEvent }

constructor TWmiAsyncEvent.Create;
const
  strServer    ='localhost';
  strNamespace ='[WMINAMESPACE]';
  strUser      ='';
  strPassword  ='';
begin
  inherited Create;
  CoInitializeEx(nil, COINIT_MULTITHREADED);
  FLocator  := CreateOleObject('WbemScripting.SWbemLocator');
  FServices := FLocator.ConnectServer(strServer, strNamespace, strUser, strPassword);
  FSink     := TSWbemSink.Create(nil);
  FSink.OnObjectReady := EventReceived;
[DELPHIEVENTSWQL]
end;

destructor TWmiAsyncEvent.Destroy;
begin
  if FSink<>nil then
    FSink.Cancel;
  FLocator  :=Unassigned;
  FServices :=Unassigned;
  FSink.Free;
  CoUninitialize;
  inherited;
end;

procedure TWmiAsyncEvent.EventReceived(ASender: TObject;
  const objWbemObject: OleVariant;
  const objWbemAsyncContext: OleVariant);
var
  PropVal: OLEVariant;
begin
  PropVal := objWbemObject;
[DELPHIEVENTSOUT] 
end;

procedure TWmiAsyncEvent.Start;
begin
  Writeln('Listening events...Press Any key to exit');
  FServices.ExecNotificationQueryAsync(FSink.DefaultInterface,FWQL,'WQL', 0);
end;

var
   AsyncEvent: TWmiAsyncEvent;
begin
 try
    AsyncEvent:=TWmiAsyncEvent.Create;
    try
      AsyncEvent.Start;
      //The next loop is only necessary in this sample console sample app
      //In VCL forms Apps you don't need use a loop
      while not KeyPressed do
      begin
          {$IF CompilerVersion > 18.5}
          Sleep(100);
          Application.ProcessMessages;
          {$IFEND}
      end;
    finally
      AsyncEvent.Free;
    end;
 except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));  
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
end.