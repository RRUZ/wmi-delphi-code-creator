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
  TSourceLanguages = (Lng_Delphi, Lng_FPC, Lng_Oxygen);

const
  WbemEmptyParam     = 'VarEmpty';
  sTagVersionApp     = '[VERSIONAPP]';
  sTagWmiClassName   = '[WMICLASSNAME]';
  sTagWmiNameSpace   = '[WMINAMESPACE]';
  sTagWmiClassDescr  = '[WMICLASSDESC]';
  sTagWmiMethodName  = '[WMIMETHOD]';
  sTagWmiMethodDescr = '[WMIMETHODDESC]';
  sTagWmiPath        = '[WMIPATH]';

  ListSourceLanguages: array[TSourceLanguages] of
    string = ('Delphi', 'Free Pascal', 'Delphi Prism');
  ListSourceTemplates: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphi.pas', 'TemplateConsoleAppFPC.pas',
    'TemplateConsoleAppOxygen.pas');
  ListSourceTemplatesHelper: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphiHelper.pas', 'TemplateConsoleAppFPCHelper.pas',
    'TemplateConsoleAppOxygen.pas');

  ListSourceTemplatesSingleton: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphiSingleton.pas', 'TemplateConsoleAppFPCSingleton.pas',
    'TemplateConsoleAppOxygen.pas');
  ListSourceTemplatesSingletonHelper: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphiHelperSingleton.pas',
    'TemplateConsoleAppFPCHelperSingleton.pas', 'TemplateConsoleAppOxygen.pas');


  ListSourceTemplatesStaticInvoker: array[TSourceLanguages] of
    string = ('TemplateStaticMethodInvokerDelphi.pas', 'TemplateStaticMethodInvokerFPC.pas',
    'TemplateStaticMethodInvokerOxygen.pas');
  ListSourceTemplatesStaticInvokerHelper: array[TSourceLanguages] of
    string = ('TemplateStaticMethodInvokerDelphi.pas', 'TemplateStaticMethodInvokerFPC.pas',
    'TemplateStaticMethodInvokerOxygen.pas');    //no helper  for now

  ListSourceTemplatesNonStaticInvoker: array[TSourceLanguages] of
    string = ('TemplateNonStaticMethodInvokerDelphi.pas',
    'TemplateNonStaticMethodInvokerFPC.pas', 'TemplateNonStaticMethodInvokerOxygen.pas');
  ListSourceTemplatesNonStaticInvokerHelper: array[TSourceLanguages] of
    string = ('TemplateNonStaticMethodInvokerDelphi.pas',
    'TemplateNonStaticMethodInvokerFPC.pas', 'TemplateNonStaticMethodInvokerOxygen.pas');

  //no helper  for now
  ListSourceTemplatesEvents: array[TSourceLanguages] of
    string = ('TemplateEventsDelphi.pas', 'TemplateEventsFPC.pas', 'TemplateEventsOxygen.pas');


  function GetMaxLengthItemName(List: TStrings): integer;
  function GetMaxLengthItem(List: TStrings): integer;
  function GetTemplateLocation(const TemplateName: string): string;


var
  FileVersionStr: string;


implementation

Uses
  SysUtils;

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

end.
