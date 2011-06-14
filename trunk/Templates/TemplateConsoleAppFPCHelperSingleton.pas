//-------------------------------------------------------------------------------------------------
//     This code was generated by the Wmi Delphi Code Creator http://theroadtodelphi.wordpress.com
//     Version: [VERSIONAPP] 
//
//
//
//     LIABILITY DISCLAIMER
//     THIS GENERATED CODE IS DISTRIBUTED "AS IS". NO WARRANTY OF ANY KIND IS EXPRESSED OR IMPLIED.
//     YOU USE IT AT YOUR OWN RISK. THE AUTHOR NOT WILL BE LIABLE FOR DATA LOSS,
//     DAMAGES AND LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR MISUSING THIS CODE.
//
//
//-----------------------------------------------------------------------------------------------
program GetWMI_Info;

{$mode objfpc} {$H+}

uses
  SysUtils,
  ActiveX,
  ComObj,
  Variants;
  
  
function VarArrayToStr(const vArray: variant): string;

    function _VarToStr(const V: variant): string;
    var
    Vt: integer;
    begin
    Vt := VarType(V);
        case Vt of
          varSmallint,
          varInteger  : Result := IntToStr(integer(V));
          varSingle,
          varDouble,
          varCurrency : Result := FloatToStr(Double(V));
          varDate     : Result := VarToStr(V);
          varOleStr   : Result := WideString(V);
          varBoolean  : Result := VarToStr(V);
          varVariant  : Result := VarToStr(Variant(V));
          varByte     : Result := char(byte(V));
          varString   : Result := String(V);
          varArray    : Result := VarArrayToStr(Variant(V));
        end;
    end;

var
i : integer;
begin
    Result := '[';
     if (VarType(vArray) and VarArray)=0 then
       Result := _VarToStr(vArray)
    else
    for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
     if i=VarArrayLowBound(vArray, 1)  then
      Result := Result+_VarToStr(vArray[i])
     else
      Result := Result+'|'+_VarToStr(vArray[i]);

    Result:=Result+']';
end;

function VarStrNull(const V:OleVariant):string; //avoid problems with null variants
begin
  Result:='';
  if not VarIsNull(V) then
  begin
    if VarIsArray(V) then
       Result:=VarArrayToStr(V)
    else
    Result:=VarToStr(V);
  end;
end;        
                
[WMICLASSDESC]
procedure  Get[WMICLASSNAME]Info;
const
  WbemUser            ='';
  WbemPassword        ='';
  WbemComputer        ='localhost';
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObject   : Variant;
  sValue        : string;   
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer(WbemComputer, '[WMINAMESPACE]', WbemUser, WbemPassword);
  FWbemObject   := FWMIService.Get('[WMICLASSNAME]=@');
[DELPHICODE]	    
end;



begin
 try
    Get[WMICLASSNAME]Info;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;  
end.