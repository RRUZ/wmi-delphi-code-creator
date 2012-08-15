//-----------------------------------------------------------------------------------------------------
//     This code was generated by the Wmi Delphi Code Creator (WDCC) Version [VERSIONAPP]
//     http://code.google.com/p/wmi-delphi-code-creator/
//     Blog http://theroadtodelphi.wordpress.com/wmi-delphi-code-creator/
//     Author Rodrigo Ruz V. (RRUZ) Copyright (C) 2011-2012 
//----------------------------------------------------------------------------------------------------- 
//
//     LIABILITY DISCLAIMER
//     THIS GENERATED CODE IS DISTRIBUTED "AS IS". NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.
//     YOU USE IT AT YOUR OWN RISK. THE AUTHOR NOT WILL BE LIABLE FOR DATA LOSS,
//     DAMAGES AND LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR MISUSING THIS CODE.
//
//----------------------------------------------------------------------------------------------------
namespace GetWMI_Info;
interface
uses
  System,
  System.Management,
  System.Text;

type
    ConsoleApp = class
    private
        class method Invoke_[WMICLASSNAME]_[WMIMETHOD];
    public
        class method Main;
    end;

implementation

[WMIMETHODDESC]
class method ConsoleApp.Invoke_[WMICLASSNAME]_[WMIMETHOD];
const
  sComputerName = 'localhost';
var
  ClassInstance  : ManagementClass;
  inParams       : ManagementBaseObject; 
  outParams      : ManagementBaseObject; 
  Scope          : ManagementScope;
  Conn           : ConnectionOptions;   
  Path           : ManagementPath;
  Options        : ObjectGetOptions;
begin
  Conn := new ConnectionOptions();
  if sComputerName<>'localhost' then
  begin
    Conn.Username  := '';
    Conn.Password  := '';
    Conn.Authority := 'ntlmdomain:DOMAIN';
    Scope := New ManagementScope(String.Format('\\{0}\[WMINAMESPACE]',sComputerName), Conn);
  end
  else
  Scope := New ManagementScope(String.Format('\\{0}\[WMINAMESPACE]',sComputerName), nil);
  Scope.Connect();
  
  Options := New ObjectGetOptions();
  Path    := New ManagementPath('[WMICLASSNAME]');
  ClassInstance := New ManagementClass(scope, Path, Options);
  inParams       := classInstance.GetMethodParameters('[WMIMETHOD]');
[DELPHICODEINPARAMS]  
  outParams      := classInstance.InvokeMethod('[WMIMETHOD]', inParams ,nil);
[DELPHICODEOUTPARAMS]
end;


class method ConsoleApp.Main;
begin
 try
    Invoke_[WMICLASSNAME]_[WMIMETHOD];
 except on  E: Exception do
   begin
     Console.WriteLine('An error occurred while trying to execute the WMI method: '+E.ToString());
     Console.WriteLine('Trace '+E.StackTrace);
   end;
 end;
 Console.WriteLine('Press Enter to exit');
 Console.Read();
end;


end.

