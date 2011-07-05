{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiDelphiCode                                                                              }
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
{ The Original Code is uWmiDelphiCode.pas.                                                         }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiDelphiCode;

interface

uses
  uWmiGenCode,
  Classes;

const
  sTagDelphiCodeParamsIn  = '[DELPHICODEINPARAMS]';
  sTagDelphiCodeParamsOut = '[DELPHICODEOUTPARAMS]';
  sTagDelphiCode          = '[DELPHICODE]';
  sTagDelphiEventsWql     = '[DELPHIEVENTSWQL]';
  sTagDelphiEventsOut     = '[DELPHIEVENTSOUT]';
  sTagDelphiEventsOut2    = '[DELPHIEVENTSOUT2]';

  DelphiMaxTypesClassCodeGen   =3;
  DelphiWmiClassCodeSupported  : Array [0..DelphiMaxTypesClassCodeGen-1] of TWmiCode = (WmiCode_Scripting, WmiCode_LateBinding, WmiCode_COM);

  ListDelphiWmiClassTemplates           : Array [0..DelphiMaxTypesClassCodeGen-1] of  string = ('TemplateConsoleAppDelphi_TLB.pas', 'TemplateConsoleAppDelphi.pas', 'TemplateConsoleAppDelphi_COM.pas');
  ListDelphiWmiClassSingletonTemplates  : Array [0..DelphiMaxTypesClassCodeGen-1] of  string = ('TemplateConsoleAppDelphiSingleton_TLB.pas', 'TemplateConsoleAppDelphiSingleton.pas', 'TemplateConsoleAppDelphi_COM.pas');

  DelphiMaxTypesEventsCodeGen   =2;
  DelphiWmiEventCodeSupported  : Array [0..DelphiMaxTypesEventsCodeGen-1] of TWmiCode = (WmiCode_Scripting, WmiCode_COM);

  DelphiMaxTypesMethodCodeGen   =3;
  DelphiWmiMethodCodeSupported  : Array [0..DelphiMaxTypesMethodCodeGen-1] of TWmiCode = (WmiCode_Scripting, WmiCode_LateBinding, WmiCode_COM);


  ListDelphiWmiEventsTemplates : Array [0..DelphiMaxTypesEventsCodeGen-1] of  string = ('TemplateEventsDelphi.pas', 'TemplateEventsDelphi_COM.pas');

  ListDelphiWmiMethodsStaticTemplates    : Array [0..DelphiMaxTypesMethodCodeGen-1] of  string = ('TemplateStaticMethodInvokerDelphi_TLB.pas', 'TemplateStaticMethodInvokerDelphi.pas','');
  ListDelphiWmiMethodsNonStaticTemplates : Array [0..DelphiMaxTypesMethodCodeGen-1] of  string = ('TemplateNonStaticMethodInvokerDelphi_TLB.pas', 'TemplateNonStaticMethodInvokerDelphi.pas','');



procedure GenerateDelphiWmiConsoleCode(const DestList, Props: TStrings; const Namespace, WmiClass: string; UseHelperFunct: boolean;Mode:TWmiCode);

procedure GenerateDelphiWmiEventCode(
  const DestList, ParamsIn, Values, Conds, PropsOut: TStrings;
  const Namespace, WmiEvent, WmiTargetInstance: string; PollSeconds: integer;
  UseHelperFunct, Intrinsic: boolean;Mode:TWmiCode);

procedure GenerateDelphiWmiInvokerCode(const DestList, ParamsIn, Values: TStrings;
  const Namespace, WmiClass, WmiMethod, WmiPath: string; UseHelperFunct: boolean;Mode:TWmiCode);

implementation

uses
  IOUtils,
  ComObj,
  SysUtils,
  Windows,
  ShellApi,
  StrUtils,
  Forms,
  uMisc,
  uWmi_Metadata;



//Delphi console Code
procedure GenerateDelphiWmiConsoleCode(const DestList, Props: TStrings;
  const Namespace, WmiClass: string; UseHelperFunct: boolean;Mode:TWmiCode);
var
  StrCode: string;
  Descr: string;
  ClassDescr: TStrings;
  DynCode: TStrings;
  i:   integer;
  Len: integer;
  Singleton: boolean;
  Padding: string;

  TemplateCode : string;
begin
  Singleton := WmiClassIsSingleton(Namespace, WmiClass);

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

    if Singleton then
    begin
      Padding := '';

      if UseHelperFunct then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiClassSingletonTemplates[Integer(Mode)]));
    end
    else
    begin
      Padding := '  ';
      if UseHelperFunct then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiClassTemplates[Integer(Mode)]));
    end;


    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);

    Len := GetMaxLengthItemName(Props) + 3;

    case Mode of
      WmiCode_Scripting:
                          begin
                            if Props.Count > 0 then
                              for i := 0 to Props.Count - 1 do
                                if UseHelperFunct then
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[VarStrNull(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]))
                                else
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[FWbemPropertySet.Item(%s, 0).Get_Value]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
                          end;

      WmiCode_LateBinding:
                          begin
                            if Props.Count > 0 then
                              for i := 0 to Props.Count - 1 do
                                if UseHelperFunct then
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[VarStrNull(FWbemObject.%s)]));// %s',
                                    [Props.Names[i], Props.Names[i], Props.ValueFromIndex[i]]))
                                else
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[FWbemObject.%s]));// %s', [Props.Names[i], Props.Names[i],
                                    Props.ValueFromIndex[i]]));
                          end;



      WmiCode_COM:
                          begin

                                 {
                                 apObjects.Get('Caption', 0, pVal, pType, plFlavor);
                                       Writeln(pVal);
                                       VarClear(pVal);
                                 }
                            Padding:= Padding + StringOfChar(' ',15);
                            if Props.Count > 0 then
                              for i := 0 to Props.Count - 1 do
                              begin
                                  DynCode.Add(Padding + Format('apObjects.Get(%s, 0, pVal, pType, plFlavor);// %s',[QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
                                if UseHelperFunct then
                                  DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[VarStrNull(pVal)]));', [Props.Names[i]]))
                                else
                                  DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[pVal]));', [Props.Names[i]]));
                                  DynCode.Add(Padding + 'VarClear(pVal);');
                                  DynCode.Add('');
                              end;
                          end;
    end;



    StrCode := StringReplace(StrCode, sTagDelphiCode, DynCode.Text, [rfReplaceAll]);

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

procedure GenerateDelphiWmiEventCode(
  const DestList, ParamsIn, Values, Conds, PropsOut: TStrings;
  const Namespace, WmiEvent, WmiTargetInstance: string; PollSeconds: integer;
  UseHelperFunct, Intrinsic: boolean;Mode:TWmiCode);
var
  StrCode: string;
  sValue:  string;
  Wql:     string;
  i, Len:  integer;
  Props:   TStrings;
  TemplateCode : string;
begin

  if UseHelperFunct then
    TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
  else
    TemplateCode:='';

   for i:=0  to DelphiMaxTypesEventsCodeGen-1 do
    if DelphiWmiEventCodeSupported[i]=Mode then
      break;

    StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiEventsTemplates[i]));

    case Mode of
     WmiCode_Scripting :
                         begin
                              WQL := Format('Select * From %s Within %d ', [WmiEvent, PollSeconds,
                                WmiTargetInstance]);
                              WQL := Format('  FWQL:=%s+%s', [QuotedStr(WQL), sLineBreak]);

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


                              Len   := GetMaxLengthItem(PropsOut) + 3;
                              Props := TStringList.Create;
                              try
                                for i := 0 to PropsOut.Count - 1 do
                                  Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) +
                                    's : %%s '',[PropVal.%s]));', [PropsOut[i], PropsOut[i]]));

                                StrCode := StringReplace(StrCode, sTagDelphiEventsOut, Props.Text, [rfReplaceAll]);
                              finally
                                props.Free;
                              end;


                              StrCode := StringReplace(StrCode, sTagDelphiEventsWql, WQL, [rfReplaceAll]);
                              StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
                              StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
                         end;
     WmiCode_LateBinding:;
     WmiCode_COM:        begin

                            WQL := Format('Select * From %s Within %d ', [WmiEvent, PollSeconds,
                              WmiTargetInstance]);
                            WQL := Format('  WQL =%s+%s', [QuotedStr(WQL), sLineBreak]);

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


                            //not wbemTargetInstance
                            Props := TStringList.Create;
                            try
                              for i := 0 to PropsOut.Count - 1 do
                               if not StartsText(wbemTargetInstance,PropsOut[i]) then
                               begin
                                {
                                if Succeeded(apObjArray.Get('TIME_CREATED', lFlags, pVal, pType, plFlavor)) then
                                  begin
                                    sValue:=pVal;
                                    VarClear(pVal);
                                    Writeln(Format('TIME_CREATED %s',[sValue]));
                                  end;
                                }
                                Props.Add('    //You must convert to string the next types manually -> CIM_OBJECT, CIM_EMPTY, CIM_DATETIME, CIM_REFERENCE');
                                Props.Add(Format('    if Succeeded(apObjArray.Get(%s, lFlags, pVal, pType, plFlavor)) and ((pType<>CIM_OBJECT) and (pType<>CIM_EMPTY) and (pType<>CIM_DATETIME) and (pType<>CIM_REFERENCE) )  then',[QuotedStr(PropsOut[i])]));
                                Props.Add('    begin');
                                Props.Add('      sValue:=pVal;');
                                Props.Add('      VarClear(pVal);');
                                Props.Add(Format('      Writeln(Format(''%s %%s'',[sValue]));',[PropsOut[i]]));
                                Props.Add('    end;');
                                Props.Add('');
                               end;
                              StrCode := StringReplace(StrCode, sTagDelphiEventsOut, Props.Text, [rfReplaceAll]);
                            finally
                              props.Free;
                            end;

                            Props := TStringList.Create;
                            try
                              for i := 0 to PropsOut.Count - 1 do
                               if StartsText(wbemTargetInstance,PropsOut[i]) then
                               begin
                                {
                                  Instance.Get('Caption', 0, pVal, pType, plFlavor);
                                  sValue:=pVal;
                                  VarClear(pVal);
                                  Writeln(Format('Caption %s',[sValue]));
                                }
                                sValue:= StringReplace(PropsOut[i],wbemTargetInstance+'.','',[rfReplaceAll]);

                                Props.Add('        //You must convert to string the next types manually -> CIM_OBJECT, CIM_EMPTY, CIM_DATETIME, CIM_REFERENCE');
                                Props.Add(Format('        if Succeeded(Instance.Get(%s, 0, pVal, pType, plFlavor)) and ((pType<>CIM_OBJECT) and (pType<>CIM_EMPTY) and (pType<>CIM_DATETIME) and (pType<>CIM_REFERENCE) ) then ',[QuotedStr(sValue)]));
                                Props.Add('        begin');
                                Props.Add('          sValue:=pVal;');
                                Props.Add('          VarClear(pVal);');
                                Props.Add(Format('          Writeln(Format(''%s %%s'',[sValue]));',[sValue]));
                                Props.Add('        end;');
                                Props.Add('');
                               end;
                              StrCode := StringReplace(StrCode, sTagDelphiEventsOut2, Props.Text, [rfReplaceAll]);
                            finally
                              props.Free;
                            end;


                            StrCode := StringReplace(StrCode, sTagDelphiEventsWql, WQL, [rfReplaceAll]);
                            StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
                            StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
                         end;

    end;

  StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);


  DestList.Text := StrCode;
end;


procedure GenerateDelphiWmiInvokerCode(const DestList, ParamsIn, Values: TStrings;
  const Namespace, WmiClass, WmiMethod, WmiPath: string; UseHelperFunct: boolean;Mode:TWmiCode);
var
  StrCode: string;
  Descr: string;
  ClassDescr: TStrings;
  DynCodeInParams: TStrings;
  DynCodeOutParams: TStrings;
  Index: integer;

  OutParamsList:  TStringList;
  OutParamsTypes: TStringList;
  OutParamsDescr: TStringList;

  InParamsList:  TStringList;
  InParamsTypes: TStringList;
  InParamsDescr: TStringList;

  IsStatic:  boolean;
  ParamsStr: string;

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

    if UseHelperFunct then
      TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
    else
      TemplateCode:='';

   for Index:=0  to DelphiMaxTypesMethodCodeGen-1 do
    if DelphiWmiMethodCodeSupported[Index]=Mode then
      break;


    if IsStatic then
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiMethodsStaticTemplates[Index]))
    else
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiMethodsNonStaticTemplates[Index]));

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);

     case Mode of
      WmiCode_COM         : ;


      WmiCode_Scripting   :
                            begin
                              if IsStatic then
                              begin
                                //In Params
                                if ParamsIn.Count > 0 then
                                  for Index := 0 to ParamsIn.Count - 1 do
                                    if Values[Index] <> WbemEmptyParam then
                                    begin
                                      if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                                      begin
                                          DynCodeInParams.Add(Format('  varValue :=%s;', [QuotedStr(Values[Index])]));
                                          DynCodeInParams.Add(Format('  FInParams.Properties_.Item(%s, 0).Set_Value(varValue);', [QuotedStr(ParamsIn.Names[Index])]));
                                      end
                                      else
                                      begin
                                          DynCodeInParams.Add(Format('  varValue :=%s;', [Values[Index]]));
                                          DynCodeInParams.Add(Format('  FInParams.Properties_.Item(%s, 0).Set_Value(varValue);', [QuotedStr(ParamsIn.Names[Index])]));
                                      end
                                    end;
                              end
                              else
                              begin

                                //varValue      := 'notepad.exe';
                                //FInParams.Properties_.Item('CommandLine', 0).Set_Value(varValue);
                                //In Params
                                if ParamsIn.Count > 0 then
                                  for Index := 0 to ParamsIn.Count - 1 do
                                    if Values[Index] <> WbemEmptyParam then
                                    begin
                                      if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                                      begin
                                          DynCodeInParams.Add(Format('  varValue :=%s;', [QuotedStr(Values[Index])]));
                                          DynCodeInParams.Add(Format('  FInParams.Properties_.Item(%s, 0).Set_Value(varValue);', [QuotedStr(ParamsIn.Names[Index])]));
                                      end
                                      else
                                      begin
                                          DynCodeInParams.Add(Format('  varValue :=%s;', [Values[Index]]));
                                          DynCodeInParams.Add(Format('  FInParams.Properties_.Item(%s, 0).Set_Value(varValue);', [QuotedStr(ParamsIn.Names[Index])]));
                                      end
                                    end;

                              end;
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text,
                                [rfReplaceAll]);

                              //Writeln(Format('ProcessId             %s',[FOutParams.Properties_.Item('ProcessId', 0).Get_Value]));
                              //Out Params
                              if OutParamsList.Count > 1 then
                              begin
                                for Index := 0 to OutParamsList.Count - 1 do
                                  if UseHelperFunct then
                                    DynCodeOutParams.Add(
                                      Format('  Writeln(Format(''%-20s  %%s'',[VarStrNull(FOutParams.Properties_.Item(%s,0).Get_Value)]));',[OutParamsList[Index], QuotedStr(OutParamsList[Index])]))
                                  else
                                    DynCodeOutParams.Add(Format('  Writeln(Format(''%-20s  %%s'',[FOutParams.Properties_.Item(%s,0).Get_Value]));',[OutParamsList[Index], QuotedStr(OutParamsList[Index])]));
                              end
                              else
                              if OutParamsList.Count = 1 then
                              begin
                                if UseHelperFunct then
                                  DynCodeOutParams.Add('  Writeln(Format(''ReturnValue  %s'',[VarStrNull(FOutParams.Properties_.Item(''ReturnValue'',0).Get_Value)]));')
                                else
                                  DynCodeOutParams.Add('  Writeln(Format(''ReturnValue  %s'',[FOutParams.Properties_.Item(''ReturnValue'',0).Get_Value]));');
                              end;
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut,
                                DynCodeOutParams.Text, [rfReplaceAll]);

                            end;
      WmiCode_LateBinding :
                            begin
                              if IsStatic then
                              begin
                                //In Params
                                if ParamsIn.Count > 0 then
                                  for Index := 0 to ParamsIn.Count - 1 do
                                    if Values[Index] <> WbemEmptyParam then
                                      if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                                        DynCodeInParams.Add(
                                          Format('  FInParams.%s:=%s;', [ParamsIn.Names[Index], QuotedStr(Values[Index])]))
                                      else
                                        DynCodeInParams.Add(
                                          Format('  FInParams.%s:=%s;', [ParamsIn.Names[Index], Values[Index]]));
                              end
                              else
                              begin
                               if InParamsList.Count = 0 then
                                begin
                                  //DynCodeInParams.Add(Format('  FWbemObjectSet:= FWMIService.Get(%s);',[QuotedStr(WmiPath)]));
                                  DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s();', [WmiMethod]));
                                end
                                else
                                begin
                                  ParamsStr := '';
                                  for Index := 0 to InParamsList.Count - 1 do
                                    ParamsStr := ParamsStr + Values[Index] + ',';
                                  Delete(ParamsStr, length(ParamsStr), 1);
                                  DynCodeInParams.Add(
                                    Format('  FOutParams:=FWbemObjectSet.%s(%s);', [WmiMethod, ParamsStr]));
                                end;
                              end;
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text,
                                [rfReplaceAll]);


                              //Out Params
                              if OutParamsList.Count > 1 then
                              begin
                                for Index := 0 to OutParamsList.Count - 1 do
                                  if UseHelperFunct then
                                    DynCodeOutParams.Add(
                                      Format('  Writeln(Format(''%-20s  %%s'',[VarStrNull(FOutParams.%s)]));',
                                      [OutParamsList[Index], OutParamsList[Index]]))
                                  else
                                    DynCodeOutParams.Add(
                                      Format('  Writeln(Format(''%-20s  %%s'',[FOutParams.%s]));',
                                      [OutParamsList[Index], OutParamsList[Index]]));
                              end
                              else
                              if OutParamsList.Count = 1 then
                              begin
                                if UseHelperFunct then
                                  DynCodeOutParams.Add(
                                    '  Writeln(Format(''ReturnValue           %s'',[VarStrNull(FOutParams)]));')
                                else
                                  DynCodeOutParams.Add(
                                    '  Writeln(Format(''ReturnValue           %s'',[FOutParams]));');
                              end;
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut,
                                DynCodeOutParams.Text, [rfReplaceAll]);
                            end;

     end;


    if Pos(#10, Descr) = 0 then //check if the description has format
      ClassDescr.Text := WrapText(Descr, 80)
    else
      ClassDescr.Text := Descr;//WrapText(Summary,sLineBreak,[#10],80);

    for Index := 0 to ClassDescr.Count - 1 do
      ClassDescr[Index] := Format('// %s', [ClassDescr[Index]]);

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


initialization
  FileVersionStr := GetFileVersion(Application.ExeName);

end.
