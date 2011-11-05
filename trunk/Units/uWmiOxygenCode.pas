{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiOxygenCode                                                                              }
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
{ The Original Code is uWmiOxygenCode.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiOxygenCode;

interface

uses
 uWmiGenCode,
 Classes;

const
  sTagOxygenCode      = '[OXYGENECODE]';
  sTagOxygenEventsWql = '[OXYGENEVENTSWQL]';
  sTagOxygenEventsOut = '[OXYGENEVENTSOUT]';

  sTagOxygenCodeParamsIn  = '[DELPHICODEINPARAMS]';
  sTagOxygenCodeParamsOut = '[DELPHICODEOUTPARAMS]';

type
  TOxygenWmiClassCodeGenerator=class(TWmiClassCodeGenerator)
  public
    procedure GenerateCode(Props: TStrings);reintroduce; overload;
  end;

  TOxygenWmiEventCodeGenerator=class(TOxygenWmiClassCodeGenerator)
  private
    FWmiTargetInstance: string;
    FPollSeconds: Integer;
  public
    property WmiTargetInstance : string Read FWmiTargetInstance write FWmiTargetInstance;
    property PollSeconds : Integer read FPollSeconds write FPollSeconds;
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);overload;
  end;


  TOxygenWmiMethodCodeGenerator=class(TOxygenWmiClassCodeGenerator)
  private
    FWmiPath: string;
    FWmiMethod: string;
    function GetWmiClassDescription: string;
  public
    property WmiPath : string Read FWmiPath write FWmiPath;
    property WmiMethod : string Read FWmiMethod write FWmiMethod;
    procedure GenerateCode(ParamsIn, Values: TStrings);overload;
  end;

implementation

uses
  StrUtils,
  IOUtils,
  ComObj,
  uWmi_Metadata,
  SysUtils;

{ TOxygenWmiClassCodeGenerator }

procedure TOxygenWmiClassCodeGenerator.GenerateCode(Props: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCode: TStrings;
  i: integer;
  TemplateCode : string;
begin
  Descr := GetWmiClassDescription;

  OutPutCode.BeginUpdate;
  DynCode    := TStringList.Create;
  try
    OutPutCode.Clear;

    if UseHelperFunctions then
      TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
    else
      TemplateCode:='';

    StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplates[Lng_Oxygen]));

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNamespace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);

    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
        if UseHelperFunctions then
          DynCode.Add(Format(
            '     Console.WriteLine(''{0,-35} {1,-40}'',%s,WmiObject[%s]);// %s',
            [QuotedStr(Props.Names[i]), QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]))
        else
          DynCode.Add(Format(
            '     Console.WriteLine(''{0,-35} {1,-40}'',%s,WmiObject[%s]);// %s',
            [QuotedStr(Props.Names[i]), QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));

    StrCode := StringReplace(StrCode, sTagOxygenCode, DynCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    OutPutCode.EndUpdate;
    DynCode.Free;
  end;
end;


{ TOxygenWmiEventCodeGenerator }

procedure TOxygenWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds,
  PropsOut: TStrings);
var
  StrCode: string;
  sValue:  string;
  Wql:     string;
  i, Len:  integer;
  Props:   TStrings;
begin
  StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesEvents[Lng_Oxygen]));

  WQL := Format('Select * From %s Within %d ', [WmiClass, PollSeconds,
    WmiTargetInstance]);
  WQL := Format('  WmiQuery:=%s+%s', [QuotedStr(WQL), sLineBreak]);

  if WmiTargetInstance <> '' then
  begin
    sValue := Format('Where TargetInstance ISA "%s" ', [WmiTargetInstance]);
    WQL    := WQL + StringOfChar(' ', 8) + QuotedStr(sValue) + '+' + sLineBreak;
  end;

  for i := 0 to Conds.Count - 1 do
  begin
    sValue := '';
    if (i > 0) or ((i = 0) and (WmiTargetInstance <> '')) then
      sValue := 'AND ';
    sValue := sValue + ' ' + ParamsIn.Names[i] + Conds[i] + Values[i] + ' ';
    WQL := WQL + StringOfChar(' ', 8) + QuotedStr(sValue) + '+' + sLineBreak;
  end;

  i := LastDelimiter('+', Wql);
  if i > 0 then
    Wql[i] := ';';


  Len   := GetMaxLengthItem(PropsOut) + 6;
  Props := TStringList.Create;
  try
    for i := 0 to PropsOut.Count - 1 do
     if StartsText(wbemTargetInstance,PropsOut[i]) then
      Props.Add(Format('  Console.WriteLine(%-'+IntToStr(Len)+'s + ManagementBaseObject(e.NewEvent[%s])[%s]);',
      [QuotedStr(PropsOut[i]+' : '),QuotedStr(wbemTargetInstance), QuotedStr(StringReplace(PropsOut[i],wbemTargetInstance+'.','',[rfReplaceAll]))]))
     else
      Props.Add(Format('  Console.WriteLine(%-'+IntToStr(Len)+'s + e.NewEvent.Properties[%s].Value.ToString());', [QuotedStr(PropsOut[i]+' : '), QuotedStr(PropsOut[i])]));

    StrCode := StringReplace(StrCode, sTagOxygenEventsOut, Props.Text, [rfReplaceAll]);
  finally
    props.Free;
  end;

  StrCode := StringReplace(StrCode, sTagOxygenEventsWql, WQL, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNamespace, [rfReplaceAll]);
  OutPutCode.Text := StrCode;
end;


{ TOxygenWmiMethodCodeGenerator }

procedure TOxygenWmiMethodCodeGenerator.GenerateCode(ParamsIn,
  Values: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCodeInParams: TStrings;
  DynCodeOutParams: TStrings;
  i: integer;

  IsStatic: boolean;
  TemplateCode : string;
begin
  Descr := GetWmiClassDescription;
  OutPutCode.BeginUpdate;
  DynCodeInParams := TStringList.Create;
  DynCodeOutParams := TStringList.Create;
  try
    IsStatic := WMiClassMetaData.MethodByName[WmiMethod].IsStatic;

    OutPutCode.Clear;
    if IsStatic then
    begin
      if UseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesStaticInvoker[Lng_Oxygen]));
    end
    else
    begin

      if UseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesNonStaticInvoker[Lng_Oxygen]));
    end;

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNamespace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);


    //In Params
    if ParamsIn.Count > 0 then
      for i := 0 to ParamsIn.Count - 1 do
        if Values[i] <> WbemEmptyParam then
          if ParamsIn.ValueFromIndex[i] = wbemtypeString then
            DynCodeInParams.Add(
              Format('  inParams[%s]:=%s;', [QuotedStr(ParamsIn.Names[i]), QuotedStr(Values[i])]))
          else
            DynCodeInParams.Add(
              Format('  inParams[%s]:=%s;', [QuotedStr(ParamsIn.Names[i]), Values[i]]));
    StrCode := StringReplace(StrCode, sTagOxygenCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

    //Out Params
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
    begin
      for i := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
        DynCodeOutParams.Add(
          Format('  Console.WriteLine(''{0,-35} {1,-40}'',%s,outParams[%s]);',
          [QuotedStr(WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name), QuotedStr(WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name)]));
    end
    else
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
    begin
      DynCodeOutParams.Add(
        Format('  Console.WriteLine(''{0,-35} {1,-40}'',''Return Value'',%s);',
        ['outParams[''ReturnValue'']']));
    end;

    StrCode := StringReplace(StrCode, sTagOxygenCodeParamsOut,
      DynCodeOutParams.Text, [rfReplaceAll]);

    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    OutPutCode.EndUpdate;
    DynCodeInParams.Free;
    DynCodeOutParams.Free;
  end;
end;


function TOxygenWmiMethodCodeGenerator.GetWmiClassDescription: string;
var
  ClassDescr : TStringList;
  Index      : Integer;
begin
  ClassDescr:=TStringList.Create;
  try
    Result := WMiClassMetaData.MethodByName[WmiMethod].Description;

    if Pos(#10, Result) = 0 then //check if the description has format
      ClassDescr.Text := WrapText(Result, 80)
    else
      ClassDescr.Text := Result;//WrapText(Summary,sLineBreak,[#10],80);

    for Index := 0 to ClassDescr.Count - 1 do
      ClassDescr[Index] := Format('// %s', [ClassDescr[Index]]);

    Result:=ClassDescr.Text;
  finally
     ClassDescr.Free;
  end;
end;

end.
