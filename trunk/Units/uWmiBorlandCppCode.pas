{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiBorlandCppCode                                                                          }
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
{ The Original Code is uWmiBorlandCppCode.pas.                                                     }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiBorlandCppCode;

interface

uses
 uWmiGenCode,
 Classes;


const
  sTagCppCode          = '[CPPCODE]';
  sTagCppCodeParamsIn  = '[CPPCODEINPARAMS]';
  sTagCppCodeParamsOut = '[CPPCODEOUTPARAMS]';
  sTagCppEventsWql     = '[CPPEVENTSWQL]';
  sTagCppEventsOut     = '[CPPEVENTSOUT]';
  sTagCppEventsOut2    = '[CPPEVENTSOUT2]';

type
  TBorlandCppWmiClassCodeGenerator=class(TWmiClassCodeGenerator)
  public
    procedure GenerateCode(Props: TStrings);reintroduce; overload;
  end;

  TBorlandCppWmiEventCodeGenerator=class(TBorlandCppWmiClassCodeGenerator)
  private
    FWmiTargetInstance: string;
    FPollSeconds: Integer;
  public
    property WmiTargetInstance : string Read FWmiTargetInstance write FWmiTargetInstance;
    property PollSeconds : Integer read FPollSeconds write FPollSeconds;
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);overload;
  end;

  TBorlandCppWmiMethodCodeGenerator=class(TBorlandCppWmiClassCodeGenerator)
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


{ TFPCWmiClassCodeGenerator }
procedure TBorlandCppWmiClassCodeGenerator.GenerateCode(Props: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCode: TStrings;
  i:   integer;
  Padding: string;
  TemplateCode : string;
  eWmiNameSpace: string;
  CimType : Integer;
begin
  Descr     := GetWmiClassDescription;

  FOutPutCode.BeginUpdate;
  DynCode    := TStringList.Create;
  try
    FOutPutCode.Clear;

    Padding := StringOfChar(' ',16);
    TemplateCode:='';
    StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplates[Lng_BorlandCpp]));

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    eWmiNameSpace:=StringReplace(WmiNameSpace,'\','\\', [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, eWmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);

    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
       begin
          DynCode.Add(Padding + Format('hr = pclsObj->Get(L"%s", 0, &vtProp, 0, 0);// %s',[Props.Names[i],Props.ValueFromIndex[i]]));
          DynCode.Add(Padding + 'if (!FAILED(hr))');
          //DynCode.Add(Padding + '{');

          CimType:=Integer(Props.Objects[i]);
          case CimType of
              wbemCimtypeSint8     : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.iVal   << endl;',[Props.Names[i]]));
              wbemCimtypeUint8     : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.uiVal   << endl;',[Props.Names[i]]));
              wbemCimtypeSint16    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.intVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint16    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.uintVal << endl;',[Props.Names[i]]));
              wbemCimtypeSint32    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.intVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint32    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.uintVal << endl;',[Props.Names[i]]));
              wbemCimtypeSint64    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.llVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint64    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.ullVal << endl;',[Props.Names[i]]));
              wbemCimtypeReal32    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.fltVal << endl;',[Props.Names[i]]));
              wbemCimtypeReal64    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.dblVal << endl;',[Props.Names[i]]));
              wbemCimtypeBoolean   : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.boolVal << endl;',[Props.Names[i]]));
              wbemCimtypeString    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));
              wbemCimtypeDatetime  : DynCode.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[Props.Names[i]]));
              wbemCimtypeReference : DynCode.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[Props.Names[i]]));
              wbemCimtypeChar16    : DynCode.Add(Padding + Format('wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));
              wbemCimtypeObject    : DynCode.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[Props.Names[i]]));
          end;


          //DynCode.Add(Padding + '}');
          DynCode.Add(Padding+ 'VariantClear(&vtProp);');
          DynCode.Add('');
       end;

    StrCode := StringReplace(StrCode, sTagCppCode, DynCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassDescr, Descr, [rfReplaceAll]);
    FOutPutCode.Text := StrCode;
  finally
    FOutPutCode.EndUpdate;
    DynCode.Free;
  end;
end;

{ TFPCWmiEventCodeGenerator }

procedure TBorlandCppWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds,  PropsOut: TStrings);
var
  StrCode: string;
  sValue:  string;
  Wql:     string;
  i :  integer;
  Props:   TStrings;
begin
  StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesEvents[Lng_FPC]));

  WQL := Format('Select * From %s Within %d ', [FWmiClass, PollSeconds,
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
    StrCode := StringReplace(StrCode, sTagCppEventsOut, Props.Text, [rfReplaceAll]);
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
    StrCode := StringReplace(StrCode, sTagCppEventsOut2, Props.Text, [rfReplaceAll]);
  finally
    props.Free;
  end;


  StrCode := StringReplace(StrCode, sTagCppEventsWql, WQL, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNamespace, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);

  FOutPutCode.Text := StrCode;
end;

{ TFPCWmiMethodCodeGenerator }

procedure TBorlandCppWmiMethodCodeGenerator.GenerateCode(ParamsIn, Values: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCodeInParams: TStrings;
  DynCodeOutParams: TStrings;
  i: integer;

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
  Descr := GetWmiClassDescription;

  OutPutCode.BeginUpdate;
  DynCodeInParams := TStringList.Create;
  DynCodeOutParams := TStringList.Create;
  OutParamsList  := TStringList.Create;
  OutParamsTypes := TStringList.Create;
  OutParamsDescr := TStringList.Create;
  InParamsList   := TStringList.Create;
  InParamsTypes  := TStringList.Create;
  InParamsDescr  := TStringList.Create;
  try
    IsStatic := WmiMethodIsStatic(WmiNamespace, WmiClass, WmiMethod);
    GetListWmiMethodOutParameters(WmiNamespace, WmiClass, WmiMethod,
      OutParamsList, OutParamsTypes, OutParamsDescr);
    GetListWmiMethodInParameters(WmiNamespace, WmiClass, WmiMethod,
      InParamsList, InParamsTypes, InParamsDescr);

    OutPutCode.Clear;
    if IsStatic then
    begin
      if FUseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesStaticInvoker[Lng_FPC]));
    end
    else
    begin
      if FUseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesNonStaticInvoker[Lng_FPC]));
    end;

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNamespace, [rfReplaceAll]);
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
                Format('  FInParams.%s:=%s;', [ParamsIn.Names[i], QuotedStr(Values[i])]))
            else
              DynCodeInParams.Add(
                Format('  FInParams.%s:=%s;', [ParamsIn.Names[i], Values[i]]));
    end
    else
    begin
      //traer todos los parametros
      if InParamsList.Count = 0 then
      begin
        //DynCodeInParams.Add(Format('  FWbemObjectSet:= FWMIService.Get(%s);',[QuotedStr(WmiPath)]));
        DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s();', [WmiMethod]));
      end
      else
      begin
        ParamsStr := '';
        for i := 0 to InParamsList.Count - 1 do
          ParamsStr := ParamsStr + Values[i] + ',';
        Delete(ParamsStr, length(ParamsStr), 1);
        DynCodeInParams.Add(
          Format('  FOutParams:=FWbemObjectSet.%s(%s);', [WmiMethod, ParamsStr]));
      end;
    end;
    StrCode := StringReplace(StrCode, sTagCppCodeParamsIn, DynCodeInParams.Text,
      [rfReplaceAll]);


    //Out Params
    if OutParamsList.Count > 1 then
    begin
      for i := 0 to OutParamsList.Count - 1 do
        if FUseHelperFunctions then
        begin
          //DynCodeOutParams.Add(Format('  sValue:=VarStrNull(FOutParams.%s);',[OutParamsList[i]])); disabled for now
          DynCodeOutParams.Add(Format('  sValue:=FOutParams.%s;', [OutParamsList[i]]));
          DynCodeOutParams.Add(
            Format('  Writeln(Format(''%-20s  %%s'',[sValue]));', [OutParamsList[i]]));
        end
        else
        begin
          DynCodeOutParams.Add(Format('  sValue:=FOutParams.%s;', [OutParamsList[i]]));
          DynCodeOutParams.Add(
            Format('  Writeln(Format(''%-20s  %%s'',[sValue]));', [OutParamsList[i]]));
        end;
    end
    else
    if OutParamsList.Count = 1 then
    begin
      if FUseHelperFunctions then
      begin
        //DynCodeOutParams.Add('  sValue:=VarStrNull(FOutParams);'); disabled for now
        DynCodeOutParams.Add('  sValue:=FOutParams;');
        DynCodeOutParams.Add('  Writeln(Format(''ReturnValue %s'',[sValue]));');
      end
      else
      begin
        DynCodeOutParams.Add('  sValue:=FOutParams;');
        DynCodeOutParams.Add('  Writeln(Format(''ReturnValue %s'',[sValue]));');
      end;
    end;
    StrCode := StringReplace(StrCode, sTagCppCodeParamsOut,
      DynCodeOutParams.Text, [rfReplaceAll]);

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

function TBorlandCppWmiMethodCodeGenerator.GetWmiClassDescription: string;
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


end.
