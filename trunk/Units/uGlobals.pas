{**************************************************************************************************}
{                                                                                                  }
{ Unit uGlobals                                                                                    }
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
{ The Original Code is uGlobals.pas.                                                               }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit uGlobals;

interface

uses
 uWmi_Metadata,
 Classes,
 Generics.Collections;

type
 TWmiNameSpacesList = TObjectList<TWMiClassMetaData>;

 TWmiNameSpaceDictionary = TDictionary<string, TWmiNameSpacesList>;
 TCachedWMIWmiNameSpaces=class
  strict private
    class var FRegisteredNameSpaces: TWmiNameSpaceDictionary;
    class destructor Destroy;
    class function RegisterWmiClass(const NameSpace, WmiClass: string): TWMiClassMetaData;
  public
    class property RegisteredNameSpaces: TWmiNameSpaceDictionary read FRegisteredNameSpaces;
    class function GetWmiClass(const NameSpace, WmiClass: string) : TWMiClassMetaData;
 end;

var
  CachedWMIWmiNameSpaces : TCachedWMIWmiNameSpaces;

implementation

uses
 SysUtils;


{ TCachedWMIWmiNameSpaces }
class destructor TCachedWMIWmiNameSpaces.Destroy;
var
  LItem: TPair<string, TWmiNameSpacesList>;
begin
  for LItem in FRegisteredNameSpaces do
    LItem.Value.Free;
  FreeAndNil(FRegisteredNameSpaces);
end;

class function TCachedWMIWmiNameSpaces.GetWmiClass(
  const NameSpace, WmiClass: string): TWMiClassMetaData;
begin
  Result:=RegisterWmiClass(NameSpace, WmiClass);
end;

class function TCachedWMIWmiNameSpaces.RegisterWmiClass(const NameSpace,
  WmiClass: string) : TWMiClassMetaData;
var
  List : TWmiNameSpacesList;
  Found: Boolean;
  WmiC : TWMiClassMetaData;
begin
  Result:=nil;
  if FRegisteredNameSpaces = nil then
    FRegisteredNameSpaces := TWmiNameSpaceDictionary.Create;

  if not FRegisteredNameSpaces.ContainsKey(NameSpace) then
  begin
    List := TWmiNameSpacesList.Create;
    Result:=TWMiClassMetaData.Create(NameSpace, WmiClass);
    List.Add(Result);
    FRegisteredNameSpaces.Add(NameSpace, List);
  end
  else
  begin
    Found:= False;
    List := FRegisteredNameSpaces[NameSpace];
    for WmiC in List do
     if Assigned(WmiC) and SameText(WmiC.WmiClass,WmiClass) then
     begin
       Result:=WmiC;
       Found:=True;
       break;
     end;

    if not Found then
    begin
      Result:=TWMiClassMetaData.Create(NameSpace, WmiClass);
      if Result<>nil then
       List.Add(Result);
    end;
  end;

end;

initialization
  CachedWMIWmiNameSpaces:=TCachedWMIWmiNameSpaces.Create;
finalization
  CachedWMIWmiNameSpaces.Free;

end.
