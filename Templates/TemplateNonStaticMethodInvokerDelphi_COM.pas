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
  Variants,
  SysUtils,
  ActiveX,
  JwaWbemCli;

const
  //Impersonation Level Constants
  //http://msdn.microsoft.com/en-us/library/ms693790%28v=vs.85%29.aspx
  RPC_C_AUTHN_LEVEL_DEFAULT   = 0;
  RPC_C_IMP_LEVEL_ANONYMOUS   = 1;
  RPC_C_IMP_LEVEL_IDENTIFY    = 2;
  RPC_C_IMP_LEVEL_IMPERSONATE = 3;
  RPC_C_IMP_LEVEL_DELEGATE    = 4;

  //Authentication Service Constants
  //http://msdn.microsoft.com/en-us/library/ms692656%28v=vs.85%29.aspx
  RPC_C_AUTHN_WINNT      = 10;
  RPC_C_AUTHN_LEVEL_CALL = 3;
  RPC_C_AUTHN_DEFAULT    = Integer($FFFFFFFF);
  EOAC_NONE              = 0;

  //Authorization Constants
  //http://msdn.microsoft.com/en-us/library/ms690276%28v=vs.85%29.aspx
  RPC_C_AUTHZ_NONE       = 0;
  RPC_C_AUTHZ_NAME       = 1;
  RPC_C_AUTHZ_DCE        = 2;
  RPC_C_AUTHZ_DEFAULT    = Integer($FFFFFFFF);

  //Authentication-Level Constants
  //http://msdn.microsoft.com/en-us/library/aa373553%28v=vs.85%29.aspx
  RPC_C_AUTHN_LEVEL_PKT_PRIVACY   = 6;

  SEC_WINNT_AUTH_IDENTITY_ANSI    = 1;
  SEC_WINNT_AUTH_IDENTITY_UNICODE = 2;
 
 //COAUTHIDENTITY Structure
 //http://msdn.microsoft.com/en-us/library/ms693358%28v=vs.85%29.aspx
 type
    PCOAUTHIDENTITY    = ^TCOAUTHIDENTITY;
    _COAUTHIDENTITY    = Record
                          User: PChar;
                          UserLength: ULONG;
                          Domain: PChar;
                          DomainLength: ULONG;
                          Password: PChar;
                          PassWordLength: ULONG;
                          Flags: ULONG;
                          End;

   COAUTHIDENTITY      = _COAUTHIDENTITY;
   TCOAUTHIDENTITY     = _COAUTHIDENTITY;
  
[HELPER_FUNCTIONS]

function GetExtendedErrorInfo(hresErr: HRESULT):Boolean;
var
 pStatus: IWbemStatusCodeText;
 hres: HRESULT;
 MessageText: WideString;
begin
  Result:=False;
    hres := CoCreateInstance(CLSID_WbemStatusCodeText, nil, CLSCTX_INPROC_SERVER, IID_IWbemStatusCodeText, pStatus);
    if (hres = S_OK) then
    begin
     hres := pStatus.GetErrorCodeText(hresErr, 0, 0, MessageText);
     if(hres <> S_OK) then
       MessageText := 'Get last error failed';

     Result:=(hres = S_OK);
     if Result then
      Writeln(Format( 'ErrorCode %x Description %s',[hresErr,MessageText]));
    end;
end;

  
[WMIMETHODDESC]
procedure  Invoke_[WMICLASSNAME]_[WMIMETHOD](const WmiPath :string);
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
  WbemLocale          ='';
  WbemAuthority       ='kERBEROS:'+WbemComputer;
var
  FWbemLocator: IWbemLocator;
  FWbemServices: IWbemServices;
  FUnsecuredApartment: IUnsecuredApartment;
  apObjects: IWbemClassObject;
  pInParamsDefinition: IWbemClassObject;
  pOutMethod: IWbemClassObject;
  pClassInstance: IWbemClassObject;
  ppCallResult: IWbemCallResult;
  ppOutParams: IWbemClassObject;
  pVal: OleVariant;
  pType: Integer;
  plFlavor: Integer;
  OpResult: HRESULT;
  LocalConnection: Boolean;
  AuthInfo: TCOAUTHIDENTITY;  
begin
  ZeroMemory(@AuthInfo, 0);
  with AuthInfo do
  begin
    User           := PChar(WbemUser);
    UserLength     := Length(WbemUser);
    Domain         := '';
    DomainLength   := 0;
    Password       := PChar(WbemPassword);
    PasswordLength := Length(WbemPassword);
    {$IFDEF UNICODE}
    Flags          := SEC_WINNT_AUTH_IDENTITY_UNICODE;
    {$ELSE}
    Flags          := SEC_WINNT_AUTH_IDENTITY_ANSI;
    {$ENDIF}
  end;

  LocalConnection:=(WbemComputer='') or (CompareText(WbemComputer,'localhost')=0);
  if LocalConnection then
   if Failed(CoInitializeSecurity(nil, -1, nil, nil, RPC_C_AUTHN_LEVEL_DEFAULT, RPC_C_IMP_LEVEL_IMPERSONATE, nil, EOAC_NONE, nil)) then Exit
   else
  else
   if Failed(CoInitializeSecurity(nil, -1, nil, nil, RPC_C_AUTHN_LEVEL_DEFAULT, RPC_C_IMP_LEVEL_IDENTIFY, nil, EOAC_NONE, nil)) then Exit;


  OpResult:=CoCreateInstance(CLSID_WbemLocator, nil, CLSCTX_INPROC_SERVER, IID_IWbemLocator, FWbemLocator);
  if Succeeded(OpResult) then
  begin
    try
      Writeln('Connecting to the WMI Service');
      if LocalConnection then
        OpResult:=FWbemLocator.ConnectServer(Format('\\%s\[WMINAMESPACE]',[WbemComputer]), WbemUser, WbemPassword, WbemLocale,  WBEM_FLAG_CONNECT_USE_MAX_WAIT, '', nil, FWbemServices)
      else
        OpResult:=FWbemLocator.ConnectServer(Format('\\%s\[WMINAMESPACE]',[WbemComputer]), WbemUser, WbemPassword, WbemLocale,  WBEM_FLAG_CONNECT_USE_MAX_WAIT, '', nil, FWbemServices);


      if Succeeded(OpResult) then
      begin
        Writeln('Connected');
        try
          // Set security levels on a WMI connection
          if LocalConnection then
            if Failed(CoSetProxyBlanket(FWbemServices, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, nil, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, nil, EOAC_NONE)) then Exit
             else
          else
            if Failed(CoSetProxyBlanket(FWbemServices,  RPC_C_AUTHN_DEFAULT, RPC_C_AUTHZ_DEFAULT, PWideChar(Format('\\%s',[WbemComputer])), RPC_C_AUTHN_LEVEL_PKT_PRIVACY, RPC_C_IMP_LEVEL_IMPERSONATE, @AuthInfo, EOAC_NONE)) then Exit;

          if Succeeded(CoCreateInstance(CLSID_UnsecuredApartment, nil, CLSCTX_LOCAL_SERVER, IID_IUnsecuredApartment, FUnsecuredApartment)) then
          try
             OpResult := FWbemServices.GetObject('[WMICLASSNAME]', 0, nil, apObjects, ppCallResult);

            if Succeeded(OpResult) then
            begin
               pInParamsDefinition := nil;
               pOutMethod := nil;
               OpResult := apObjects.GetMethod('[WMIMETHOD]', 0,pInParamsDefinition, pOutMethod);
               if Succeeded(OpResult) then
               begin
                    OpResult:= pInParamsDefinition.SpawnInstance(0, pClassInstance);
                    if Succeeded(OpResult) then
                    begin
[DELPHICODEINPARAMS]  					   
                       OpResult := FWbemServices.ExecMethod(WmiPath, '[WMIMETHOD]', 0, nil, pClassInstance, ppOutParams, ppCallResult);
                       if Succeeded(OpResult) then
                       begin
[DELPHICODEOUTPARAMS]
                       end
                       else
                       if not GetExtendedErrorInfo(OpResult) then
                       Writeln(Format('Error ExecMethod %x',[OpResult]));

                    end
                    else
                    if not GetExtendedErrorInfo(OpResult) then
                    Writeln(Format('Error SpawnInstance %x',[OpResult]));
               end
               else
               if not GetExtendedErrorInfo(OpResult) then
               Writeln(Format('Error GetMethod %x',[OpResult]));
            end
            else
            if not GetExtendedErrorInfo(OpResult) then
            Writeln(Format('Error GetObject %x',[OpResult]));
          finally
            FUnsecuredApartment := nil;
          end;
        finally
          FWbemServices := nil;
        end;
      end
      else
        if not GetExtendedErrorInfo(OpResult) then
        Writeln(Format('Error Connecting to the Server %x',[OpResult]));
    finally
      FWbemLocator := nil;
    end;
  end
  else
   if not GetExtendedErrorInfo(OpResult) then
     Writeln(Format('Failed to create IWbemLocator object %x',[OpResult]));

end;


begin
 try
    CoInitialize(nil);
    try
      Invoke_[WMICLASSNAME]_[WMIMETHOD]('[WMIPATH]');
    finally
      CoUninitialize;
    end;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;   
end.