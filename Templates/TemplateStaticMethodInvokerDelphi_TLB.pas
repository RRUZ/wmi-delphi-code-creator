//-----------------------------------------------------------------------------------------------------
//     This code was generated by the Wmi Delphi Code Creator (WDCC) Version [VERSIONAPP]
//     https://github.com/RRUZ/wmi-delphi-code-creator
//     Blog http://theroadtodelphi.wordpress.com/wmi-delphi-code-creator/
//     Author Rodrigo Ruz V. (RRUZ) Copyright (C) 2011-2021 
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
  SysUtils,
  WbemScripting_TLB,
  Variants,
  ActiveX,
  ComObj;
  
[HELPER_FUNCTIONS]
  
[WMIMETHODDESC]
procedure  Invoke_[WMICLASSNAME]_[WMIMETHOD];
const
  WbemUser    ='';
  WbemPassword='';
  WbemComputer='localhost';
var
  FSWbemLocator: ISWbemLocator;
  FWMIService: ISWbemServices;
  FWbemObject: ISWbemObject;
  FInParams: ISWbemObject;
  FOutParams: ISWbemObject;
  varValue: OleVariant;
begin
  FSWbemLocator := CoSWbemLocator.Create;
  FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, '[WMINAMESPACE]', WbemUser, WbemPassword, '', '', 0, nil);
  FWbemObject   := FWMIService.Get('[WMICLASSNAME]',0,nil);
  FInParams     := FWbemObject.Methods_.Item('[WMIMETHOD]',0).InParameters.SpawnInstance_(0);  
[DELPHICODEINPARAMS]  
  FOutParams    := FWMIService.ExecMethod('[WMICLASSNAME]', '[WMIMETHOD]', FInParams,0 , nil);
[DELPHICODEOUTPARAMS]  
end;


begin
 try
    CoInitialize(nil);
    try
      Invoke_[WMICLASSNAME]_[WMIMETHOD];
    finally
      CoUninitialize;
    end;
 except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));  
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;   
end.