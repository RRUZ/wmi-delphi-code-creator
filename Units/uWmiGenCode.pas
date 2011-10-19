{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiGenCode                                                                                 }
{ Unit for the WMI Delphi Code Creator                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uWmiGenCode.pas.                                                            }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiGenCode;

interface

uses
  Classes;

type
  TSourceLanguages = (Lng_Delphi, Lng_FPC, Lng_Oxygen, Lng_BorlandCpp);
  TWmiCode        =  (WmiCode_Scripting, WmiCode_LateBinding, WmiCode_COM);

  TWmiCodeGenerator=class
    FUseHelperFunctions: boolean;
    FWmiClass: string;
    FWmiNameSpace: string;
    FModeCodeGeneration: TWmiCode;
    FOutPutCode: TStrings;
    FTemplateCode : string;
  public
    property WmiNameSpace : string read FWmiNameSpace write FWmiNameSpace;
    property WmiClass : string Read FWmiClass write FWmiClass;
    property UseHelperFunctions : boolean read FUseHelperFunctions write  FUseHelperFunctions;
    property ModeCodeGeneration:TWmiCode read FModeCodeGeneration write FModeCodeGeneration;
    property OutPutCode : TStrings read FOutPutCode;
    procedure GenerateCode;virtual;
    constructor Create;
    destructor Destroy; override;
  end;

  TWmiClassCodeGenerator=class(TWmiCodeGenerator)
  public
    function GetWmiClassDescription: string;
  end;


const
  WbemEmptyParam     = 'VarEmpty';
  sTagVersionApp     = '[VERSIONAPP]';
  sTagHelperTemplate = '[HELPER_FUNCTIONS]';
  sTagWmiClassName   = '[WMICLASSNAME]';
  sTagWmiNameSpace   = '[WMINAMESPACE]';
  sTagWmiClassDescr  = '[WMICLASSDESC]';
  sTagWmiMethodName  = '[WMIMETHOD]';
  sTagWmiMethodDescr = '[WMIMETHODDESC]';
  sTagWmiPath        = '[WMIPATH]';

  sTemplateTemplateFuncts = 'TemplateHelperFunctions.pas';

  ListSourceLanguages: array[TSourceLanguages] of
    string = ('Delphi', 'Free Pascal', 'Delphi Prism', 'Borland/Embarcadero C++');

  ListSourceTemplates: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphi.pas', 'TemplateConsoleAppFPC.pas',
    'TemplateConsoleAppOxygen.pas','TemplateConsoleAppBorlandCPP.cpp');

  ListSourceTemplatesSingleton: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphiSingleton.pas', 'TemplateConsoleAppFPCSingleton.pas',
    'TemplateConsoleAppOxygen.pas','');

  ListSourceTemplatesStaticInvoker: array[TSourceLanguages] of
    string = ('TemplateStaticMethodInvokerDelphi.pas', 'TemplateStaticMethodInvokerFPC.pas',
    'TemplateStaticMethodInvokerOxygen.pas','TemplateStaticMethodInvokerBorlandCPP.cpp');

  ListSourceTemplatesNonStaticInvoker: array[TSourceLanguages] of
    string = ('TemplateNonStaticMethodInvokerDelphi.pas',
    'TemplateNonStaticMethodInvokerFPC.pas', 'TemplateNonStaticMethodInvokerOxygen.pas','TemplateNonStaticMethodInvokerBorlandCPP.cpp');

  ListSourceTemplatesEvents: array[TSourceLanguages] of
    string = ('TemplateEventsDelphi.pas', 'TemplateEventsFPC.pas', 'TemplateEventsOxygen.pas','');

  ListWmiCodeName  : array [TWmiCode] of string = ('Microsoft WMI Scripting Library - WbemScripting_TLB','Microsoft WMI Scripting Library - Late Binding', 'WMI COM API');
  ListWmiCodeDescr : array [TWmiCode] of string = ('Generate code using the Microsoft WMI Scripting Library using the WbemScripting_TLB unit',
                                                   'Generate code using the Microsoft WMI Scripting Library using late binding',
                                                   'Generate code using the COM API for WMI uisng the JwaWbemCli (part of the JEDI API Library)');


  function GetMaxLengthItemName(List: TStrings): integer;
  function GetMaxLengthItem(List: TStrings): integer;
  function GetTemplateLocation(const TemplateName: string): string;


var
  FileVersionStr: string;


implementation

Uses
  ComObj,
  uWmi_Metadata,
  SysUtils;

{ TWmiCodeGenerator }

constructor TWmiCodeGenerator.Create;
begin
  inherited;
  FUseHelperFunctions:=False;
  FOutPutCode:=TStringList.Create;
end;

destructor TWmiCodeGenerator.Destroy;
begin
  FOutPutCode.Free;
  inherited;
end;


procedure TWmiCodeGenerator.GenerateCode;
begin
 //Common Code

end;

function GetMaxLengthItem(List: TStrings): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to List.Count - 1 do
    if Length(List[i]) > Result then
      Result := Length(List[i]);
end;

function GetMaxLengthItemName(List: TStrings): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to List.Count - 1 do
    if Length(List.Names[i]) > Result then
      Result := Length(List.Names[i]);
end;

function GetTemplateLocation(const TemplateName: string): string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'Templates\' + TemplateName;
end;

{ TWmiClassCodeGenerator }

function TWmiClassCodeGenerator.GetWmiClassDescription: string;
var
  ClassDescr : TStringList;
  i          : Integer;
begin
  try
    Result := uWmi_Metadata.GetWmiClassDescription(FWmiNameSpace, FWmiClass);
    ClassDescr:=TStringList.Create;
    try
      if Pos(#10, Result) = 0 then //check if the description has format
        ClassDescr.Text := WrapText(Result, 80)
      else
        ClassDescr.Text := Result;//WrapText(Summary,sLineBreak,[#10],80);

      for i := 0 to ClassDescr.Count - 1 do
        ClassDescr[i] := Format('// %s', [ClassDescr[i]]);

      Result:=ClassDescr.Text;
    finally
      ClassDescr.Free;
    end;
  except
    on E: EOleSysError do
      if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
        Result := ''
      else
        raise;
  end;
end;

end.