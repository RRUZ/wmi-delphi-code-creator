// **************************************************************************************************
//
// Unit WDCC.Globals
// unit for the WMI Delphi Code Creator
// https://github.com/RRUZ/wmi-delphi-code-creator
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is WDCC.Globals.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************
unit WDCC.Globals;

interface

uses
  uWmi_Metadata,
  Classes,
  Generics.Collections;

type
  TWmiClassesList = TObjectList<TWMiClassMetaData>;

  TWmiClassesDictionary = TDictionary<string, TWmiClassesList>;
  TWmiNameSpacesDictionary = TDictionary<string, TStrings>;

  TCachedWMIClasses = class
  strict private
    class var FNameSpaces: TStrings;
    class var FHostNameSpaces: TWmiNameSpacesDictionary;
    class var FRegisteredNameSpaces: TWmiClassesDictionary;
    class constructor Create;
    class destructor Destroy;
    class function RegisterWmiClass(const Host, User, Password, NameSpace, WmiClass: string)
      : TWMiClassMetaData; overload;
    class function RegisterWmiClass(const NameSpace, WmiClass: string): TWMiClassMetaData; overload;

  private
    class function GetNameSpaces: TStrings; static;
  public
    class property RegisteredNameSpaces: TWmiClassesDictionary read FRegisteredNameSpaces;
    class function GetWmiClass(const NameSpace, WmiClass: string): TWMiClassMetaData; overload;
    class function GetWmiClass(const Host, User, Password, NameSpace, WmiClass: string): TWMiClassMetaData; overload;

    class property NameSpaces: TStrings read GetNameSpaces;
    class function GetNameSpacesHost(const Host, User, Password: string): TStrings; static;
  end;

var
  CachedWMIClasses: TCachedWMIClasses;

implementation

uses
  WDCC.Settings,
  SysUtils;

{ TCachedWMIWmiNameSpaces }
class constructor TCachedWMIClasses.Create;
begin
  FNameSpaces := TStringList.Create;
  FHostNameSpaces := TWmiNameSpacesDictionary.Create;
  FRegisteredNameSpaces := nil;
end;

class destructor TCachedWMIClasses.Destroy;
var
  LItem: TPair<string, TWmiClassesList>;
  LPair: TPair<string, TStrings>;
begin
  FNameSpaces.Free;

  if FRegisteredNameSpaces <> nil then
    for LItem in FRegisteredNameSpaces do
      LItem.Value.Free;
  FreeAndNil(FRegisteredNameSpaces);

  if FHostNameSpaces <> nil then
    for LPair in FHostNameSpaces do
      LPair.Value.Free;
  FreeAndNil(FHostNameSpaces);
end;

class function TCachedWMIClasses.GetNameSpaces: TStrings;
begin
  if not ExistWmiNameSpaceCache then
  begin
    GetListWMINameSpaces('root', FNameSpaces);
    SaveWMINameSpacesToCache(FNameSpaces);
  end
  else
    LoadWMINameSpacesFromCache(FNameSpaces);

  Result := FNameSpaces;
end;

class function TCachedWMIClasses.GetNameSpacesHost(const Host, User, Password: string): TStrings;
Var
  LNameSpaces: TStrings;
begin

  if FHostNameSpaces.ContainsKey(Host) then
    LNameSpaces := FHostNameSpaces.Items[Host]
  else
  begin
    LNameSpaces := TStringList.Create;
    TStringList(LNameSpaces).Sorted := True;
    FHostNameSpaces.Add(Host, LNameSpaces);
  end;

  if not ExistWmiNameSpaceCache(Host) then
  begin
    GetListWMINameSpaces('root', Host, User, Password, LNameSpaces, False);
    SaveWMINameSpacesToCache(Host, FNameSpaces);
  end
  else
    LoadWMINameSpacesFromCache(Host, LNameSpaces);

  Result := LNameSpaces;
end;

class function TCachedWMIClasses.GetWmiClass(const Host, User, Password, NameSpace, WmiClass: string)
  : TWMiClassMetaData;
begin
  Result := RegisterWmiClass(Host, User, Password, NameSpace, WmiClass);
end;

class function TCachedWMIClasses.GetWmiClass(const NameSpace, WmiClass: string): TWMiClassMetaData;
begin
  Result := RegisterWmiClass(NameSpace, WmiClass);
end;

class function TCachedWMIClasses.RegisterWmiClass(const Host, User, Password, NameSpace, WmiClass: string)
  : TWMiClassMetaData;
var
  List: TWmiClassesList;
  Found: Boolean;
  WmiC: TWMiClassMetaData;
begin
  Result := nil;
  if FRegisteredNameSpaces = nil then
    FRegisteredNameSpaces := TWmiClassesDictionary.Create;

  if not FRegisteredNameSpaces.ContainsKey(Host + NameSpace) then
  begin
    List := TWmiClassesList.Create;
    Result := TWMiClassMetaData.Create(NameSpace, WmiClass, Host, User, Password);
    List.Add(Result);
    FRegisteredNameSpaces.Add(Host + NameSpace, List);
  end
  else
  begin
    Found := False;
    List := FRegisteredNameSpaces[Host + NameSpace];
    for WmiC in List do
      if Assigned(WmiC) and SameText(WmiC.WmiClass, WmiClass) then
      begin
        Result := WmiC;
        Found := True;
        break;
      end;

    if not Found then
    begin
      Result := TWMiClassMetaData.Create(NameSpace, WmiClass, Host, User, Password);
      if Result <> nil then
        List.Add(Result);
    end;
  end;

end;

class function TCachedWMIClasses.RegisterWmiClass(const NameSpace, WmiClass: string): TWMiClassMetaData;
var
  List: TWmiClassesList;
  Found: Boolean;
  WmiC: TWMiClassMetaData;
begin
  Result := nil;
  if FRegisteredNameSpaces = nil then
    FRegisteredNameSpaces := TWmiClassesDictionary.Create;

  if not FRegisteredNameSpaces.ContainsKey(NameSpace) then
  begin
    List := TWmiClassesList.Create;
    Result := TWMiClassMetaData.Create(NameSpace, WmiClass);
    List.Add(Result);
    FRegisteredNameSpaces.Add(NameSpace, List);
  end
  else
  begin
    Found := False;
    List := FRegisteredNameSpaces[NameSpace];
    for WmiC in List do
      if Assigned(WmiC) and SameText(WmiC.WmiClass, WmiClass) then
      begin
        Result := WmiC;
        Found := True;
        break;
      end;

    if not Found then
    begin
      Result := TWMiClassMetaData.Create(NameSpace, WmiClass);
      if Result <> nil then
        List.Add(Result);
    end;
  end;

end;

{
  if not ExistWmiNameSpaceCache then
  begin
  GetListWMINameSpaces('root', FNameSpaces);
  SaveWMINameSpacesToCache(FNameSpaces);
  end
  else
  LoadWMINameSpacesFromCache(FNameSpaces);

}

initialization

CachedWMIClasses := TCachedWMIClasses.Create;

finalization

CachedWMIClasses.Free;

end.
