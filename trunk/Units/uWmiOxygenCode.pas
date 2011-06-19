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
 Classes;

const
  sTagOxygenCode      = '[OXYGENECODE]';
  sTagOxygenEventsWql = '[OXYGENEVENTSWQL]';
  sTagOxygenEventsOut = '[OXYGENEVENTSOUT]';

  sTagOxygenCodeParamsIn  = '[DELPHICODEINPARAMS]';
  sTagOxygenCodeParamsOut = '[DELPHICODEOUTPARAMS]';


procedure GenerateOxygenWmiConsoleCode(const DestList, Props: TStrings;
  const Namespace, WmiClass: string; UseHelperFunct: boolean);

procedure GenerateOxygenWmiInvokerCode(const DestList, ParamsIn, Values: TStrings;
  const Namespace, WmiClass, WmiMethod, WmiPath: string; UseHelperFunct: boolean);

procedure GenerateOxygenWmiEventCode(
  const DestList, ParamsIn, Values, Conds, PropsOut: TStrings;
  const Namespace, WmiEvent, WmiTargetInstance: string; PollSeconds: integer;
  UseHelperFunct, Intrinsic: boolean);


implementation

uses
  StrUtils,
  uWmiGenCode,
  IOUtils,
  ComObj,
  uWmi_Metadata,
  SysUtils;


procedure GenerateOxygenWmiConsoleCode(const DestList, Props: TStrings;
  const Namespace, WmiClass: string; UseHelperFunct: boolean);
var
  StrCode: string;
  Descr: string;
  ClassDescr: TStrings;
  DynCode: TStrings;
  i: integer;
  TemplateCode : string;
begin

  try
    Descr := GetWmiClassDescription(Namespace, WmiClass);
  except
    on E: EOleSysError do
      if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
        Descr := ''
      else
        raise;
  end;

  DestList.BeginUpdate;
  DynCode    := TStringList.Create;
  ClassDescr := TStringList.Create;
  try
    DestList.Clear;

    if UseHelperFunct then
      TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
    else
      TemplateCode:='';

    StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplates[Lng_Oxygen]));


    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);


    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
        if UseHelperFunct then
          DynCode.Add(Format(
            '     Console.WriteLine(''{0,-35} {1,-40}'',%s,WmiObject[%s]);// %s',
            [QuotedStr(Props.Names[i]), QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]))
        else
          DynCode.Add(Format(
            '     Console.WriteLine(''{0,-35} {1,-40}'',%s,WmiObject[%s]);// %s',
            [QuotedStr(Props.Names[i]), QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));

    StrCode := StringReplace(StrCode, sTagOxygenCode, DynCode.Text, [rfReplaceAll]);

    if Pos(#10, Descr) = 0 then //check if the description has format
      ClassDescr.Text := WrapText(Descr, 80)
    else
      ClassDescr.Text := Descr;//WrapText(Summary,sLineBreak,[#10],80);

    for i := 0 to ClassDescr.Count - 1 do
      ClassDescr[i] := Format('// %s', [ClassDescr[i]]);

    StrCode := StringReplace(StrCode, sTagWmiClassDescr, ClassDescr.Text, [rfReplaceAll]);
    DestList.Text := StrCode;
  finally
    ClassDescr.Free;
    DestList.EndUpdate;
    DynCode.Free;
  end;
end;


procedure GenerateOxygenWmiInvokerCode(const DestList, ParamsIn, Values: TStrings;
  const Namespace, WmiClass, WmiMethod, WmiPath: string; UseHelperFunct: boolean);
var
  StrCode: string;
  Descr: string;
  ClassDescr: TStrings;
  DynCodeInParams: TStrings;
  DynCodeOutParams: TStrings;
  i: integer;

  OutParamsList:  TStringList;
  OutParamsTypes: TStringList;
  OutParamsDescr: TStringList;

  InParamsList:  TStringList;
  InParamsTypes: TStringList;
  InParamsDescr: TStringList;

  IsStatic: boolean;
  TemplateCode : string;
begin

  try
    Descr := GetWmiMethodDescription(Namespace, WmiClass, WmiMethod);
  except
    on E: EOleSysError do
      if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
        Descr := ''
      else
        raise;
  end;

  DestList.BeginUpdate;
  DynCodeInParams := TStringList.Create;
  DynCodeOutParams := TStringList.Create;
  ClassDescr     := TStringList.Create;
  OutParamsList  := TStringList.Create;
  OutParamsTypes := TStringList.Create;
  OutParamsDescr := TStringList.Create;
  InParamsList   := TStringList.Create;
  InParamsTypes  := TStringList.Create;
  InParamsDescr  := TStringList.Create;
  try
    IsStatic := WmiMethodIsStatic(Namespace, WmiClass, WmiMethod);
    GetListWmiMethodOutParameters(Namespace, WmiClass, WmiMethod,
      OutParamsList, OutParamsTypes, OutParamsDescr);
    GetListWmiMethodInParameters(Namespace, WmiClass, WmiMethod,
      InParamsList, InParamsTypes, InParamsDescr);

    DestList.Clear;
    if IsStatic then
    begin
      if UseHelperFunct then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesStaticInvoker[Lng_Oxygen]));
    end
    else
    begin

      if UseHelperFunct then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesNonStaticInvoker[Lng_Oxygen]));
    end;

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);


    if IsStatic then
    begin
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
    end
    else
    begin
      if ParamsIn.Count > 0 then
        for i := 0 to ParamsIn.Count - 1 do
          if Values[i] <> WbemEmptyParam then
            if ParamsIn.ValueFromIndex[i] = wbemtypeString then
              DynCodeInParams.Add(
                Format('  inParams[%s]:=%s;', [QuotedStr(ParamsIn.Names[i]), QuotedStr(Values[i])]))
            else
              DynCodeInParams.Add(
                Format('  inParams[%s]:=%s;', [QuotedStr(ParamsIn.Names[i]), Values[i]]));
    end;
    StrCode := StringReplace(StrCode, sTagOxygenCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);


    //Out Params
    if OutParamsList.Count > 1 then
    begin
      for i := 0 to OutParamsList.Count - 1 do
        DynCodeOutParams.Add(
          Format('  Console.WriteLine(''{0,-35} {1,-40}'',%s,outParams[%s]);',
          [QuotedStr(OutParamsList[i]), QuotedStr(OutParamsList[i])]));
    end
    else
    if OutParamsList.Count = 1 then
    begin
      DynCodeOutParams.Add(
        Format('  Console.WriteLine(''{0,-35} {1,-40}'',''Return Value'',%s);',
        ['outParams[''ReturnValue'']']));
    end;

    StrCode := StringReplace(StrCode, sTagOxygenCodeParamsOut,
      DynCodeOutParams.Text, [rfReplaceAll]);


    if Pos(#10, Descr) = 0 then //check if the description has format
      ClassDescr.Text := WrapText(Descr, 80)
    else
      ClassDescr.Text := Descr;//WrapText(Summary,sLineBreak,[#10],80);

    for i := 0 to ClassDescr.Count - 1 do
      ClassDescr[i] := Format('// %s', [ClassDescr[i]]);

    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, ClassDescr.Text, [rfReplaceAll]);
    DestList.Text := StrCode;
  finally
    ClassDescr.Free;
    DestList.EndUpdate;
    DynCodeInParams.Free;
    DynCodeOutParams.Free;
    OutParamsList.Free;
    OutParamsTypes.Free;
    OutParamsDescr.Free;
    InParamsList.Free;
    InParamsTypes.Free;
    InParamsDescr.Free;
  end;
end;

procedure GenerateOxygenWmiEventCode(
  const DestList, ParamsIn, Values, Conds, PropsOut: TStrings;
  const Namespace, WmiEvent, WmiTargetInstance: string; PollSeconds: integer;
  UseHelperFunct, Intrinsic: boolean);
var
  StrCode: string;
  sValue:  string;
  Wql:     string;
  i, Len:  integer;
  Props:   TStrings;
begin
  StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesEvents[Lng_Oxygen]));

  WQL := Format('Select * From %s Within %d ', [WmiEvent, PollSeconds,
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
  StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
  DestList.Text := StrCode;
end;


end.
