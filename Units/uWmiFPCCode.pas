{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmiFPCCode                                                                                 }
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
{ The Original Code is uWmiFPCCode.pas.                                                            }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmiFPCCode;

interface

uses
 uWmiGenCode,
 Classes;


const
  sTagFPCCode          = '[DELPHICODE]';
  sTagFPCCodeParamsIn  = '[DELPHICODEINPARAMS]';
  sTagFPCCodeParamsOut = '[DELPHICODEOUTPARAMS]';
  sTagFPCEventsWql     = '[FPCEVENTSWQL]';
  sTagFPCEventsOut     = '[FPCEVENTSOUT]';
  sTagFPCEventsOut2    = '[FPCEVENTSOUT2]';

type
  TFPCWmiClassCodeGenerator=class(TWmiClassCodeGenerator)
  public
    procedure GenerateCode(Props: TStrings);override;//reintroduce; overload;
  end;

  TFPCWmiEventCodeGenerator=class(TFPCWmiClassCodeGenerator)
  private
    FWmiTargetInstance: string;
    FPollSeconds: Integer;
  public
    property WmiTargetInstance : string Read FWmiTargetInstance write FWmiTargetInstance;
    property PollSeconds : Integer read FPollSeconds write FPollSeconds;
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);overload;
  end;

  TFPCWmiMethodCodeGenerator=class(TFPCWmiClassCodeGenerator)
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
procedure TFPCWmiClassCodeGenerator.GenerateCode(Props: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCode: TStrings;
  i:   integer;
  Len: integer;
  Singleton: boolean;
  Padding: string;
  TemplateCode : string;
begin
  Singleton := WMiClassMetaData.IsSingleton;
  Descr     := GetWmiClassDescription;

  OutPutCode.BeginUpdate;
  DynCode    := TStringList.Create;
  try
    OutPutCode.Clear;

    if Singleton then
    begin
      Padding := '';
      if UseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

        StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesSingleton[Lng_FPC]));
    end
    else
    begin
      Padding := '  ';
      if UseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
      else
        TemplateCode:='';

      StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplates[Lng_FPC]));
    end;


    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);


    Len := GetMaxLengthItemName(Props) + 3;

    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
        if UseHelperFunctions then
        begin
          DynCode.Add(Padding + Format(
            '  sValue:= VarStrNull(FWbemObject.Properties_.Item(''%s'').Value);', [Props.Names[i]]));
          DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
            Len) + 's %%s'',[sValue]));// %s', [Props.Names[i], Props.ValueFromIndex[i]]));
        end
        else
        begin
          DynCode.Add(Padding + Format(
            '  sValue:= FWbemObject.Properties_.Item(''%s'').Value;', [Props.Names[i]]));
          DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(
            Len) + 's %%s'',[sValue]));// %s', [Props.Names[i], Props.ValueFromIndex[i]]));
        end;

    StrCode := StringReplace(StrCode, sTagFPCCode, DynCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    OutPutCode.EndUpdate;
    DynCode.Free;
  end;
end;

{ TFPCWmiEventCodeGenerator }

procedure TFPCWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds,  PropsOut: TStrings);
var
  StrCode: string;
  sValue:  string;
  Wql:     string;
  i :  integer;
  Props:   TStrings;
begin
  StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesEvents[Lng_FPC]));

  WQL := Format('Select * From %s Within %d ', [WmiClass, PollSeconds, WmiTargetInstance]);
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
    StrCode := StringReplace(StrCode, sTagFPCEventsOut, Props.Text, [rfReplaceAll]);
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
    StrCode := StringReplace(StrCode, sTagFPCEventsOut2, Props.Text, [rfReplaceAll]);
  finally
    props.Free;
  end;


  StrCode := StringReplace(StrCode, sTagFPCEventsWql, WQL, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNamespace, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);

  OutPutCode.Text := StrCode;
end;

{ TFPCWmiMethodCodeGenerator }

procedure TFPCWmiMethodCodeGenerator.GenerateCode(ParamsIn, Values: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCodeInParams: TStrings;
  DynCodeOutParams: TStrings;
  i: integer;
  IsStatic:  boolean;
  ParamsStr: string;
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
          ListSourceTemplatesStaticInvoker[Lng_FPC]));
    end
    else
    begin
      if UseHelperFunctions then
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
      if WMiClassMetaData.MethodByName[WmiMethod].InParameters.Count = 0 then
      begin
        //DynCodeInParams.Add(Format('  FWbemObjectSet:= FWMIService.Get(%s);',[QuotedStr(WmiPath)]));
        DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s();', [WmiMethod]));
      end
      else
      begin
        ParamsStr := '';
        for i := 0 to WMiClassMetaData.MethodByName[WmiMethod].InParameters.Count - 1 do
          ParamsStr := ParamsStr + Values[i] + ',';
        Delete(ParamsStr, length(ParamsStr), 1);
        DynCodeInParams.Add(
          Format('  FOutParams:=FWbemObjectSet.%s(%s);', [WmiMethod, ParamsStr]));
      end;
    end;
    StrCode := StringReplace(StrCode, sTagFPCCodeParamsIn, DynCodeInParams.Text,
      [rfReplaceAll]);


    //Out Params
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
    begin
      for i := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
        if UseHelperFunctions then
        begin
          //DynCodeOutParams.Add(Format('  sValue:=VarStrNull(FOutParams.%s);',[OutParamsList[i]])); disabled for now
          DynCodeOutParams.Add(Format('  sValue:=FOutParams.%s;', [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
          DynCodeOutParams.Add(
            Format('  Writeln(Format(''%-20s  %%s'',[sValue]));', [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
        end
        else
        begin
          DynCodeOutParams.Add(Format('  sValue:=FOutParams.%s;', [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
          DynCodeOutParams.Add(
            Format('  Writeln(Format(''%-20s  %%s'',[sValue]));', [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
        end;
    end
    else
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
    begin
      if UseHelperFunctions then
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
    StrCode := StringReplace(StrCode, sTagFPCCodeParamsOut,
      DynCodeOutParams.Text, [rfReplaceAll]);

    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    DynCodeInParams.Free;
    DynCodeOutParams.Free;
  end;
end;

function TFPCWmiMethodCodeGenerator.GetWmiClassDescription: string;
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
