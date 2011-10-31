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
  DelphiMaxTypesClassCodeGen    =3;
  DelphiMaxTypesEventsCodeGen   =2;
  DelphiMaxTypesMethodCodeGen   =3;
  DelphiWmiClassCodeSupported  : Array [0..DelphiMaxTypesClassCodeGen-1]  of TWmiCode = (WmiCode_Scripting, WmiCode_LateBinding, WmiCode_COM);
  DelphiWmiEventCodeSupported  : Array [0..DelphiMaxTypesEventsCodeGen-1] of TWmiCode = (WmiCode_Scripting, WmiCode_COM);
  DelphiWmiMethodCodeSupported : Array [0..DelphiMaxTypesMethodCodeGen-1] of TWmiCode = (WmiCode_Scripting, WmiCode_LateBinding, WmiCode_COM);

type
  TDelphiWmiClassCodeGenerator=class(TWmiClassCodeGenerator)
  public
    procedure GenerateCode(Props: TStrings);reintroduce; overload;
  end;

  TDelphiWmiEventCodeGenerator=class(TDelphiWmiClassCodeGenerator)
  private
    FWmiTargetInstance: string;
    FPollSeconds: Integer;
  public
    property WmiTargetInstance : string Read FWmiTargetInstance write FWmiTargetInstance;
    property PollSeconds : Integer read FPollSeconds write FPollSeconds;
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);overload;
  end;

  TDelphiWmiMethodCodeGenerator=class(TDelphiWmiClassCodeGenerator)
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
  IOUtils,
  ComObj,
  SysUtils,
  Windows,
  ShellApi,
  StrUtils,
  Forms,
  uMisc,
  uWmi_Metadata;

const
  sTagDelphiCodeParamsIn  = '[DELPHICODEINPARAMS]';
  sTagDelphiCodeParamsOut = '[DELPHICODEOUTPARAMS]';
  sTagDelphiCode          = '[DELPHICODE]';
  sTagDelphiEventsWql     = '[DELPHIEVENTSWQL]';
  sTagDelphiEventsOut     = '[DELPHIEVENTSOUT]';
  sTagDelphiEventsOut2    = '[DELPHIEVENTSOUT2]';


  ListDelphiWmiClassTemplates           : Array [0..DelphiMaxTypesClassCodeGen-1] of  string = ('TemplateConsoleAppDelphi_TLB.pas', 'TemplateConsoleAppDelphi.pas', 'TemplateConsoleAppDelphi_COM.pas');
  ListDelphiWmiClassSingletonTemplates  : Array [0..DelphiMaxTypesClassCodeGen-1] of  string = ('TemplateConsoleAppDelphiSingleton_TLB.pas', 'TemplateConsoleAppDelphiSingleton.pas', 'TemplateConsoleAppDelphi_COM.pas');

  ListDelphiWmiEventsTemplates : Array [0..DelphiMaxTypesEventsCodeGen-1] of  string = ('TemplateEventsDelphi.pas', 'TemplateEventsDelphi_COM.pas');
  ListDelphiWmiMethodsStaticTemplates    : Array [0..DelphiMaxTypesMethodCodeGen-1] of  string = ('TemplateStaticMethodInvokerDelphi_TLB.pas', 'TemplateStaticMethodInvokerDelphi.pas','TemplateStaticMethodInvokerDelphi_COM.pas');
  ListDelphiWmiMethodsNonStaticTemplates : Array [0..DelphiMaxTypesMethodCodeGen-1] of  string = ('TemplateNonStaticMethodInvokerDelphi_TLB.pas', 'TemplateNonStaticMethodInvokerDelphi.pas','TemplateNonStaticMethodInvokerDelphi_COM.pas');



{ TDelphiWmiEventCodeGenerator }


procedure TDelphiWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);
var
  StrCode: string;
  sValue:  string;
  Wql:     string;
  i, Len:  integer;
  Props:   TStrings;
begin

  if FUseHelperFunctions then
    FTemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
  else
    FTemplateCode:='';

   for i:=0  to DelphiMaxTypesEventsCodeGen-1 do
    if DelphiWmiEventCodeSupported[i]=FModeCodeGeneration then
      break;

    StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiEventsTemplates[i]));

    case FModeCodeGeneration of
     WmiCode_Scripting :
                         begin
                              WQL := Format('Select * From %s Within %d ', [FWmiClass, PollSeconds,
                                FWmiTargetInstance]);
                              WQL := Format('  FWQL:=%s+%s', [QuotedStr(WQL), sLineBreak]);

                              if FWmiTargetInstance <> '' then
                              begin
                                sValue := Format('Where TargetInstance ISA "%s" ', [FWmiTargetInstance]);
                                WQL    := WQL + StringOfChar(' ', 8) + QuotedStr(sValue) + '+' + sLineBreak;
                              end;

                              for i := 0 to Conds.Count - 1 do
                              begin
                                sValue := '';
                                if (i > 0) or ((i = 0) and (FWmiTargetInstance <> '')) then
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
                                  Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) +'s : %%s '',[PropVal.%s]));', [PropsOut[i], PropsOut[i]]));

                                StrCode := StringReplace(StrCode, sTagDelphiEventsOut, Props.Text, [rfReplaceAll]);
                              finally
                                props.Free;
                              end;


                              StrCode := StringReplace(StrCode, sTagDelphiEventsWql, WQL, [rfReplaceAll]);
                              StrCode := StringReplace(StrCode, sTagWmiNameSpace, FWmiNameSpace, [rfReplaceAll]);
                              StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
                         end;

     WmiCode_LateBinding:;

     WmiCode_COM:        begin

                            WQL := Format('Select * From %s Within %d ', [FWmiClass, PollSeconds,
                              FWmiTargetInstance]);
                            WQL := Format('  WQL =%s+%s', [QuotedStr(WQL), sLineBreak]);

                            if FWmiTargetInstance <> '' then
                            begin
                              sValue := Format('Where TargetInstance ISA "%s" ', [FWmiTargetInstance]);
                              WQL    := WQL + StringOfChar(' ', 8) + QuotedStr(sValue) + '+' + sLineBreak;
                            end;

                            for i := 0 to Conds.Count - 1 do
                            begin
                              sValue := '';
                              if (i > 0) or ((i = 0) and (FWmiTargetInstance <> '')) then
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
                            StrCode := StringReplace(StrCode, sTagWmiNameSpace, FWmiNameSpace, [rfReplaceAll]);
                            StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
                         end;

    end;

  StrCode := StringReplace(StrCode, sTagHelperTemplate, FTemplateCode, [rfReplaceAll]);
  FOutPutCode.Text := StrCode;
end;


{ TDelphiWmiClassCodeGenerator }

procedure TDelphiWmiClassCodeGenerator.GenerateCode(Props: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCode: TStrings;
  i:   integer;
  Len: integer;
  Singleton: boolean;
  Padding: string;
  CimType:Integer;
begin
  Singleton := WmiClassIsSingleton(FWmiNameSpace, FWmiClass);
  Descr :=GetWmiClassDescription;

  DynCode    := TStringList.Create;
  try
    FOutPutCode.Clear;

    if FUseHelperFunctions then
      FTemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
    else
      FTemplateCode:='';

    if Singleton then
    begin
        Padding := '';
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiClassSingletonTemplates[Integer(FModeCodeGeneration)]));
    end
    else
    begin
        Padding := '  ';
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiClassTemplates[Integer(FModeCodeGeneration)]));
    end;


    StrCode := StringReplace(StrCode, sTagHelperTemplate, FTemplateCode, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, FWmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, FWmiNameSpace, [rfReplaceAll]);

    Len := GetMaxLengthItemName(Props) + 3;

    case FModeCodeGeneration of
      WmiCode_Scripting:
                          begin
                            if Props.Count > 0 then
                              for i := 0 to Props.Count - 1 do
                                if FUseHelperFunctions then
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[VarStrNull(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]))
                                else
                                begin
                                  //DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[FWbemPropertySet.Item(%s, 0).Get_Value]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
                                  CimType:=Integer(Props.Objects[i]);
                                  case CimType of

                                      wbemCimtypeSint8,
                                      wbemCimtypeUint8,
                                      wbemCimtypeSint16,
                                      wbemCimtypeUint16,
                                      wbemCimtypeSint32,
                                      wbemCimtypeUint32,
                                      wbemCimtypeSint64,
                                      wbemCimtypeUint64    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%d'',[Integer(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
                                      wbemCimtypeReal32    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%n'',[Double(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
                                      wbemCimtypeReal64    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%n'',[Double(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
                                      wbemCimtypeBoolean,
                                      wbemCimtypeDatetime,
                                      wbemCimtypeString,
                                      wbemCimtypeChar16    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[String(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s', [Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));

                                            {
                                      wbemCimtypeReference : ;
                                      wbemCimtypeObject    : ;
                                             }
                                  end;
                                end;
                          end;

      WmiCode_LateBinding:
                          begin
                            if Props.Count > 0 then
                              for i := 0 to Props.Count - 1 do
                                if FUseHelperFunctions then
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[VarStrNull(FWbemObject.%s)]));// %s',
                                    [Props.Names[i], Props.Names[i], Props.ValueFromIndex[i]]))
                                else
                                begin
                                  {
                                  DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
                                    Len) + 's %%s'',[FWbemObject.%s]));// %s', [Props.Names[i], Props.Names[i],
                                    Props.ValueFromIndex[i]]));
                                   }

                                  CimType:=Integer(Props.Objects[i]);
                                  case CimType of

                                      wbemCimtypeSint8,
                                      wbemCimtypeUint8,
                                      wbemCimtypeSint16,
                                      wbemCimtypeUint16,
                                      wbemCimtypeSint32,
                                      wbemCimtypeUint32,
                                      wbemCimtypeSint64,
                                      wbemCimtypeUint64    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%d'',[Integer(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i],
                                    Props.ValueFromIndex[i]]));
                                      wbemCimtypeReal32    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%n'',[Double(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i],
                                    Props.ValueFromIndex[i]]));
                                      wbemCimtypeReal64    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%n'',[Double(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i],
                                    Props.ValueFromIndex[i]]));
                                      wbemCimtypeBoolean,
                                      wbemCimtypeDatetime,
                                      wbemCimtypeString,
                                      wbemCimtypeChar16    : DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[String(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i],
                                    Props.ValueFromIndex[i]]));

                                            {
                                      wbemCimtypeReference : DynCode.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[Props.Names[i]]));
                                      wbemCimtypeObject    : DynCode.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[Props.Names[i]]));
                                             }
                                  end;



                                end;
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
                                if FUseHelperFunctions then
                                  DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[VarStrNull(pVal)]));', [Props.Names[i]]))
                                else
                                begin
                                  //DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[pVal]));', [Props.Names[i]]));
                                  CimType:=Integer(Props.Objects[i]);
                                  case CimType of
                                      wbemCimtypeSint8,
                                      wbemCimtypeUint8,
                                      wbemCimtypeSint16,
                                      wbemCimtypeUint16,
                                      wbemCimtypeSint32,
                                      wbemCimtypeUint32,
                                      wbemCimtypeSint64,
                                      wbemCimtypeUint64    : DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%d'',[Integer(pVal)]));', [Props.Names[i]]));
                                      wbemCimtypeReal32    : DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%n'',[Double(pVal)]));', [Props.Names[i]]));
                                      wbemCimtypeReal64    : DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%n'',[Double(pVal)]));', [Props.Names[i]]));
                                      wbemCimtypeBoolean,
                                      wbemCimtypeDatetime,
                                      wbemCimtypeString,
                                      wbemCimtypeChar16    : DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[String(pVal)]));', [Props.Names[i]]));
                                      {
                                      wbemCimtypeReference : ;
                                      wbemCimtypeObject    : ;
                                      }
                                  end;

                                end;



                                  DynCode.Add(Padding + 'VarClear(pVal);');
                                  DynCode.Add('');
                              end;
                          end;
    end;


    StrCode := StringReplace(StrCode, sTagDelphiCode, DynCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassDescr, Descr, [rfReplaceAll]);
    FOutPutCode.Text := StrCode;
  finally
    DynCode.Free;
  end;
end;



{ TDelphiWmiMethodCodeGenerator }

procedure TDelphiWmiMethodCodeGenerator.GenerateCode(ParamsIn, Values: TStrings);
var
  StrCode: string;
  Descr: string;
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
  Padding: string;
begin
  DynCodeInParams := TStringList.Create;
  DynCodeOutParams := TStringList.Create;
  OutParamsList  := TStringList.Create;
  OutParamsTypes := TStringList.Create;
  OutParamsDescr := TStringList.Create;
  InParamsList   := TStringList.Create;
  InParamsTypes  := TStringList.Create;
  InParamsDescr  := TStringList.Create;
  try
    IsStatic := WmiMethodIsStatic(WmiNameSpace, WmiClass, WmiMethod);
    GetListWmiMethodOutParameters(WmiNameSpace, WmiClass, WmiMethod,
      OutParamsList, OutParamsTypes, OutParamsDescr);
    GetListWmiMethodInParameters(WmiNameSpace, WmiClass, WmiMethod,
      InParamsList, InParamsTypes, InParamsDescr);


    if FUseHelperFunctions then
      FTemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
    else
      FTemplateCode:='';

   for Index:=0  to DelphiMaxTypesMethodCodeGen-1 do
    if DelphiWmiMethodCodeSupported[Index]=FModeCodeGeneration then
      break;


    if IsStatic then
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiMethodsStaticTemplates[Index]))
    else
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListDelphiWmiMethodsNonStaticTemplates[Index]));

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, FTemplateCode, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, FWmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);

     case FModeCodeGeneration of
      WmiCode_COM         :
                            begin
                              Padding:=StringOfChar(' ',23);
                              //pVal     := 0;
                              //pClassInstance.Put('Reason', 0, @pVal, 0);
                              //In Params
                              if ParamsIn.Count > 0 then
                                for Index := 0 to ParamsIn.Count - 1 do
                                  if Values[Index] <> WbemEmptyParam then
                                  begin
                                    if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                                    begin
                                        DynCodeInParams.Add(Format('%s  pVal :=%s;', [Padding,QuotedStr(Values[Index])]));
                                        DynCodeInParams.Add(Format('%s  pClassInstance.Put(%s, 0, @pVal, 0);', [Padding,QuotedStr(ParamsIn.Names[Index])]));
                                    end
                                    else
                                    begin
                                        DynCodeInParams.Add(Format('%s  pVal :=%s;', [Padding,Values[Index]]));
                                        DynCodeInParams.Add(Format('%s  pClassInstance.Put(%s, 0, @pVal, 0);', [Padding,QuotedStr(ParamsIn.Names[Index])]));
                                    end
                                  end;

                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

							                //ppOutParams.Get('ReturnValue', 0, pVal, pType, plFlavor);// String
                              //Writeln(Format('ReturnValue  %s',[pVal]));
                              //VarClear(pVal);

                              //Out Params
                              if OutParamsList.Count > 1 then
                              begin
                                for Index := 0 to OutParamsList.Count - 1 do
                                begin
                                  DynCodeOutParams.Add(Format('%s  ppOutParams.Get(%s, 0, pVal, pType, plFlavor);',[Padding,QuotedStr(OutParamsList[Index])]));
                                  if FUseHelperFunctions then
                                    DynCodeOutParams.Add(
                                      Format('%s  Writeln(Format(''%-20s  %%s'',[VarStrNull(pVal)]));',[Padding,OutParamsList[Index]]))
                                  else
                                    DynCodeOutParams.Add(Format('%s  Writeln(Format(''%-20s  %%s'',[pVal]));',[Padding,OutParamsList[Index]]));
                                  DynCodeOutParams.Add(Padding+'  VarClear(pVal);');
                                end;
                              end
                              else
                              if OutParamsList.Count = 1 then
                              begin
                                  DynCodeOutParams.Add(Format('%s  ppOutParams.Get(%s, 0, pVal, pType, plFlavor);',[Padding,QuotedStr('ReturnValue')]));
                                if FUseHelperFunctions then
                                  DynCodeOutParams.Add(Padding+'  Writeln(Format(''ReturnValue  %s'',[VarStrNull(pVal)]));')
                                else
                                  DynCodeOutParams.Add(Padding+'  Writeln(Format(''ReturnValue  %s'',[pVal]));');
                                  DynCodeOutParams.Add(Padding+'  VarClear(pVal);');
                              end;
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);

                            end;


      WmiCode_Scripting   :
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
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

                              //Writeln(Format('ProcessId             %s',[FOutParams.Properties_.Item('ProcessId', 0).Get_Value]));
                              //Out Params
                              if OutParamsList.Count > 1 then
                              begin
                                for Index := 0 to OutParamsList.Count - 1 do
                                  if FUseHelperFunctions then
                                    DynCodeOutParams.Add(
                                      Format('  Writeln(Format(''%-20s  %%s'',[VarStrNull(FOutParams.Properties_.Item(%s,0).Get_Value)]));',[OutParamsList[Index], QuotedStr(OutParamsList[Index])]))
                                  else
                                    DynCodeOutParams.Add(Format('  Writeln(Format(''%-20s  %%s'',[FOutParams.Properties_.Item(%s,0).Get_Value]));',[OutParamsList[Index], QuotedStr(OutParamsList[Index])]));
                              end
                              else
                              if OutParamsList.Count = 1 then
                              begin
                                if FUseHelperFunctions then
                                  DynCodeOutParams.Add('  Writeln(Format(''ReturnValue  %s'',[VarStrNull(FOutParams.Properties_.Item(''ReturnValue'',0).Get_Value)]));')
                                else
                                  DynCodeOutParams.Add('  Writeln(Format(''ReturnValue  %s'',[FOutParams.Properties_.Item(''ReturnValue'',0).Get_Value]));');
                              end;
                              StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);

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
                                  if FUseHelperFunctions then
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
                                if FUseHelperFunctions then
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


    Descr:=GetWmiClassDescription;
    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
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


function TDelphiWmiMethodCodeGenerator.GetWmiClassDescription: string;
var
  ClassDescr : TStringList;
  Index      : Integer;
begin
  try
    ClassDescr:=TStringList.Create;
    try
      Result := GetWmiMethodDescription(WmiNameSpace, WmiClass, WmiMethod);

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

  except
    on E: EOleSysError do
      if E.ErrorCode = HRESULT(wbemErrAccessDenied) then
        Result := ''
      else
        raise;
  end;
end;

initialization
  FileVersionStr := GetFileVersion(Application.ExeName);

end.
