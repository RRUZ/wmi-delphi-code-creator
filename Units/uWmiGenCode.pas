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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiGenCode;

interface

uses
  uSelectCompilerVersion,
  uWmi_Metadata,
  Classes;

type
  TWmiCode        =  (WmiCode_Scripting, WmiCode_LateBinding, WmiCode_COM);

  TWmiCodeGenerator=class
  private
    FUseHelperFunctions: boolean;
    FModeCodeGeneration: TWmiCode;
    FOutPutCode: TStrings;
    FTemplateCode : string;
    FWMiClassMetaData: TWMiClassMetaData;
    function GetWmiClass: string;
    function GetWmiNameSpace: string;
  public
    property WmiNameSpace : string read GetWmiNameSpace;
    property WmiClass : string Read GetWmiClass;
    property UseHelperFunctions : boolean read FUseHelperFunctions write  FUseHelperFunctions;
    property ModeCodeGeneration:TWmiCode read FModeCodeGeneration write FModeCodeGeneration;
    property OutPutCode : TStrings read FOutPutCode;
    property WMiClassMetaData : TWMiClassMetaData read FWMiClassMetaData write FWMiClassMetaData;
    property TemplateCode : string read FTemplateCode write FTemplateCode;
    procedure GenerateCode(Props: TStrings);virtual;
    constructor Create;
    destructor Destroy; override;
  end;

  TWmiClassCodeGenerator=class(TWmiCodeGenerator)
  public
    function GetWmiClassDescription: string;
  end;

  TWmiEventCodeGenerator=class(TWmiClassCodeGenerator)
  private
    FWmiTargetInstance: string;
    FPollSeconds: Integer;
  public
    property WmiTargetInstance : string Read FWmiTargetInstance write FWmiTargetInstance;
    property PollSeconds : Integer read FPollSeconds write FPollSeconds;
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);reintroduce;virtual;
  end;

  TWmiMethodCodeGenerator=class(TWmiEventCodeGenerator)
  private
    FWmiPath: string;
    FWmiMethod: string;
  public
    property WmiPath : string Read FWmiPath write FWmiPath;
    property WmiMethod : string Read FWmiMethod write FWmiMethod;
    procedure GenerateCode(ParamsIn, Values: TStrings);reintroduce;virtual;
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
    string = ('Delphi', 'Free Pascal', 'Delphi Prism', 'Borland/Embarcadero C++', 'Microsoft C++', 'C#');

  ListSourceTemplates: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphi.pas', 'TemplateConsoleAppFPC.pas',
    'TemplateConsoleAppOxygen.pas','TemplateConsoleAppBorlandCPP.cpp', 'TemplateConsoleAppMicrosoftCPP.cpp','TemplateConsoleAppCSharp.cs');

  ListSourceTemplatesSingleton: array[TSourceLanguages] of
    string = ('TemplateConsoleAppDelphiSingleton.pas', 'TemplateConsoleAppFPCSingleton.pas',
    'TemplateConsoleAppOxygen.pas','','','');

  ListSourceTemplatesStaticInvoker: array[TSourceLanguages] of
    string = ('TemplateStaticMethodInvokerDelphi.pas', 'TemplateStaticMethodInvokerFPC.pas',
    'TemplateStaticMethodInvokerOxygen.pas','TemplateStaticMethodInvokerBorlandCPP.cpp', 'TemplateStaticMethodInvokerMicrosoftCPP.cpp', '');

  ListSourceTemplatesNonStaticInvoker: array[TSourceLanguages] of
    string = ('TemplateNonStaticMethodInvokerDelphi.pas',
    'TemplateNonStaticMethodInvokerFPC.pas', 'TemplateNonStaticMethodInvokerOxygen.pas','TemplateNonStaticMethodInvokerBorlandCPP.cpp', 'TemplateNonStaticMethodInvokerMicrosoftCPP.cpp','');

  ListSourceTemplatesEvents: array[TSourceLanguages] of
    string = ('TemplateEventsDelphi.pas', 'TemplateEventsFPC.pas', 'TemplateEventsOxygen.pas','TemplateEventsBorlandCpp.cpp', 'TemplateEventsMicrosoft.cpp','');

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


procedure TWmiCodeGenerator.GenerateCode(Props: TStrings);
begin
 //Common Code

end;

function TWmiCodeGenerator.GetWmiClass: string;
begin
  Result:=FWMiClassMetaData.WmiClass;
end;

function TWmiCodeGenerator.GetWmiNameSpace: string;
begin
  Result:=FWMiClassMetaData.WmiNameSpace;
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
  Result := WMiClassMetaData.Description;
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
end;

{ TWmiEventCodeGenerator }

procedure TWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds,
  PropsOut: TStrings);
begin
//
end;

{ TWmiMethodCodeGenerator }

procedure TWmiMethodCodeGenerator.GenerateCode(ParamsIn, Values: TStrings);
begin
//
end;

end.
