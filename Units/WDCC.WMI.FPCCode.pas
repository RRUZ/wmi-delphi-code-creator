// **************************************************************************************************
//
// Unit WDCC.WMI.FPCCode
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
// The Original Code is WDCC.WMI.FPCCode.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.FPCCode;

interface

uses
  WDCC.WMI.GenCode,
  Classes;

const
  sTagFPCCode = '[DELPHICODE]';
  sTagFPCCodeParamsIn = '[DELPHICODEINPARAMS]';
  sTagFPCCodeParamsOut = '[DELPHICODEOUTPARAMS]';
  sTagFPCEventsWql = '[FPCEVENTSWQL]';
  sTagFPCEventsOut = '[FPCEVENTSOUT]';
  sTagFPCEventsOut2 = '[FPCEVENTSOUT2]';

type
  TFPCWmiClassCodeGenerator = class(TWmiClassCodeGenerator)
  private type
    TFPCHelperCodeGen = class(TWmiCodeGenerator.THelperCodeGen)
      procedure AddCode(const WmiProperty: string); override;
    end;
  public
    procedure GenerateCode(Props: TStrings); override;
    constructor Create;
    destructor Destroy; override;
  end;

  TFPCWmiEventCodeGenerator = class(TWmiEventCodeGenerator)
  public
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings); override;
  end;

  TFPCWmiMethodCodeGenerator = class(TWmiMethodCodeGenerator)
  private
    function GetWmiClassDescription: string;
  public
    procedure GenerateCode(ParamsIn, Values: TStrings); override;
  end;

implementation

uses
  WDCC.SelectCompilerVersion,
  StrUtils,
  IOUtils,
  ComObj,
  uWmi_Metadata,
  SysUtils;

{ TFPCWmiClassCodeGenerator.TFPCHelperCodeGen }

procedure TFPCWmiClassCodeGenerator.TFPCHelperCodeGen.AddCode(const WmiProperty: string);
var
  PropertyMetaData: TWMiPropertyMetaData;
  k, j: integer;

  function ParseMapValue(const MapValue: string): string;
  begin
    Result := MapValue;
    if StartsText('0x', MapValue) then
      Result := StringReplace(Result, '0x', '$', [rfIgnoreCase]);
  end;

begin
  inherited;
  PropertyMetaData := WMiClassMetaData.PropertyByName[WmiProperty];

  // sanity check for valid values
  if (PropertyMetaData.ValidValues.Count > 0) and (PropertyMetaData.ValidMapValues.Count > 0) then
    for j := 0 to PropertyMetaData.ValidValues.Count - 1 do
      if not TryStrToInt(Trim(ParseMapValue(PropertyMetaData.ValidMapValues[j])), k) then
        exit;

  if (PropertyMetaData.ValidValues.Count > 0) and (PropertyMetaData.ValidMapValues.Count = 0) then
  begin
    WmiCodeGenerator.TemplateCode.Add(Format('function Get%sAsString(const %s:%s) : string;',
      [WmiProperty, 'ReturnValue', 'Integer']));
    WmiCodeGenerator.TemplateCode.Add('begin');
    WmiCodeGenerator.TemplateCode.Add(Format('Result:=%s;', [QuotedStr('')]));
    WmiCodeGenerator.TemplateCode.Add(Format('  case %s of', ['ReturnValue']));
    for j := 0 to PropertyMetaData.ValidValues.Count - 1 do
      WmiCodeGenerator.TemplateCode.Add(Format('    %d : Result:=%s;',
        [j, QuotedStr(PropertyMetaData.ValidValues[j])]));
    WmiCodeGenerator.TemplateCode.Add('  end;');
    WmiCodeGenerator.TemplateCode.Add('end;');
    WmiCodeGenerator.TemplateCode.Add('');

    HelperFuncts.Add(WmiProperty, Format('Get%sAsString', [WmiProperty]));
  end
  else if (PropertyMetaData.ValidValues.Count > 0) and (PropertyMetaData.ValidMapValues.Count > 0) then
  begin
    WmiCodeGenerator.TemplateCode.Add(Format('function Get%sAsString(const %s:%s) : string;',
      [WmiProperty, 'ReturnValue', 'Integer']));
    WmiCodeGenerator.TemplateCode.Add('begin');
    WmiCodeGenerator.TemplateCode.Add(Format('Result:=%s;', [QuotedStr('')]));
    WmiCodeGenerator.TemplateCode.Add(Format('  case %s of', ['ReturnValue']));

    for j := 0 to PropertyMetaData.ValidValues.Count - 1 do
    begin
      if PropertyMetaData.ValidMapValues[j] = '..' then
      begin
        k := WmiCodeGenerator.TemplateCode.Count - 1;
        WmiCodeGenerator.TemplateCode[k] := Copy(WmiCodeGenerator.TemplateCode[k], 1,
          Length(WmiCodeGenerator.TemplateCode[k]) - 1); // remove ;
        WmiCodeGenerator.TemplateCode.Add(Format('    else Result:=%s;', [QuotedStr(PropertyMetaData.ValidValues[j])]));
      end
      else
        WmiCodeGenerator.TemplateCode.Add(Format('    %s : Result:=%s;',
          [ParseMapValue(PropertyMetaData.ValidMapValues[j]), QuotedStr(PropertyMetaData.ValidValues[j])]));
    end;
    WmiCodeGenerator.TemplateCode.Add('  end;');
    WmiCodeGenerator.TemplateCode.Add('end;');
    WmiCodeGenerator.TemplateCode.Add('');

    HelperFuncts.Add(WmiProperty, Format('Get%sAsString', [WmiProperty]));
  end;
end;

{ TFPCWmiClassCodeGenerator }
constructor TFPCWmiClassCodeGenerator.Create;
begin
  inherited;
  if Assigned(HelperCodeGen) then
    HelperCodeGen.Free;

  HelperCodeGen := TFPCHelperCodeGen.Create;
end;

destructor TFPCWmiClassCodeGenerator.Destroy;
begin

  inherited;
end;

procedure TFPCWmiClassCodeGenerator.GenerateCode(Props: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCode: TStrings;
  i: integer;
  Len: integer;
  Singleton: boolean;
  Padding: string;
begin
  Singleton := WMiClassMetaData.IsSingleton;
  Descr := GetWmiClassDescription;

  OutPutCode.BeginUpdate;
  DynCode := TStringList.Create;
  try
    OutPutCode.Clear;

    if Singleton then
    begin
      Padding := '';
      StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_FPC, ModeCodeGeneration, TWmiGenCode.WmiClassesSingleton));
    end
    else
    begin
      Padding := '  ';
      StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_FPC, ModeCodeGeneration, TWmiGenCode.WmiClasses));
    end;

    HelperCodeGen.WmiCodeGenerator := Self;
    TemplateCode.Clear;
    if UseHelperFunctions then
      for i := 0 to Props.Count - 1 do
        HelperCodeGen.AddCode(Props.Names[i]);

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode.Text, [rfReplaceAll]);

    Len := GetMaxLengthItemName(Props) + 3;

    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
        if UseHelperFunctions and HelperCodeGen.HelperFuncts.ContainsKey(Props.Names[i]) and
          not WMiClassMetaData.PropertyByName[Props.Names[i]].IsArray then
        begin
          // DynCode.Add(Padding + Format('  sValue:= VarStrNull(FWbemObject.Properties_.Item(''%s'').Value);', [Props.Names[i]]));
          DynCode.Add(Padding + Format('  sValue:= Get%sAsString(FWbemObject.Properties_.Item(''%s'').Value);',
            [Props.Names[i], Props.Names[i]]));

          DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[sValue]));// %s',
            [Props.Names[i], Props.ValueFromIndex[i]]));
        end
        else
        begin
          DynCode.Add(Padding + Format('  sValue:= FWbemObject.Properties_.Item(''%s'').Value;', [Props.Names[i]]));
          DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[sValue]));// %s',
            [Props.Names[i], Props.ValueFromIndex[i]]));
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

procedure TFPCWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);
var
  StrCode: string;
  sValue: string;
  Wql: string;
  i: integer;
  Props: TStrings;
begin
  StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_FPC, ModeCodeGeneration, TWmiGenCode.WmiEvents));

  Wql := Format('Select * From %s Within %d ', [WmiClass, PollSeconds, WmiTargetInstance]);
  Wql := Format('  WQL =%s+%s', [QuotedStr(Wql), sLineBreak]);

  if WmiTargetInstance <> '' then
  begin
    sValue := Format('Where TargetInstance ISA "%s" ', [WmiTargetInstance]);
    Wql := Wql + StringOfChar(' ', 8) + QuotedStr(sValue) + '+' + sLineBreak;
  end;

  for i := 0 to Conds.Count - 1 do
  begin
    sValue := '';
    if (i > 0) or ((i = 0) and (WmiTargetInstance <> '')) then
      sValue := 'AND ';
    sValue := sValue + ' ' + ParamsIn.Names[i] + Conds[i] + Values[i] + ' ';
    Wql := Wql + StringOfChar(' ', 8) + QuotedStr(sValue) + '+' + sLineBreak;
  end;

  i := LastDelimiter('+', Wql);
  if i > 0 then
    Wql[i] := ';';

  // not wbemTargetInstance
  Props := TStringList.Create;
  try
    for i := 0 to PropsOut.Count - 1 do
      if not StartsText(wbemTargetInstance, PropsOut[i]) then
      begin
        {
          if Succeeded(apObjArray.Get('TIME_CREATED', lFlags, pVal, pType, plFlavor)) then
          begin
          sValue:=pVal;
          VarClear(pVal);
          Writeln(Format('TIME_CREATED %s',[sValue]));
          end;
        }
        Props.Add(
          '    //You must convert to string the next types manually -> CIM_OBJECT, CIM_EMPTY, CIM_DATETIME, CIM_REFERENCE');
        Props.Add(Format
          ('    if Succeeded(apObjArray.Get(%s, lFlags, pVal, pType, plFlavor)) and ((pType<>CIM_OBJECT) and (pType<>CIM_EMPTY) and (pType<>CIM_DATETIME) and (pType<>CIM_REFERENCE) )  then',
          [QuotedStr(PropsOut[i])]));
        Props.Add('    begin');
        Props.Add('      sValue:=pVal;');
        Props.Add('      VarClear(pVal);');
        Props.Add(Format('      Writeln(Format(''%s %%s'',[sValue]));', [PropsOut[i]]));
        Props.Add('    end;');
        Props.Add('');
      end;
    StrCode := StringReplace(StrCode, sTagFPCEventsOut, Props.Text, [rfReplaceAll]);
  finally
    Props.Free;
  end;

  Props := TStringList.Create;
  try
    for i := 0 to PropsOut.Count - 1 do
      if StartsText(wbemTargetInstance, PropsOut[i]) then
      begin
        {
          Instance.Get('Caption', 0, pVal, pType, plFlavor);
          sValue:=pVal;
          VarClear(pVal);
          Writeln(Format('Caption %s',[sValue]));
        }
        sValue := StringReplace(PropsOut[i], wbemTargetInstance + '.', '', [rfReplaceAll]);

        Props.Add(
          '        //You must convert to string the next types manually -> CIM_OBJECT, CIM_EMPTY, CIM_DATETIME, CIM_REFERENCE');
        Props.Add(Format
          ('        if Succeeded(Instance.Get(%s, 0, pVal, pType, plFlavor)) and ((pType<>CIM_OBJECT) and (pType<>CIM_EMPTY) and (pType<>CIM_DATETIME) and (pType<>CIM_REFERENCE) ) then ',
          [QuotedStr(sValue)]));
        Props.Add('        begin');
        Props.Add('          sValue:=pVal;');
        Props.Add('          VarClear(pVal);');
        Props.Add(Format('          Writeln(Format(''%s %%s'',[sValue]));', [sValue]));
        Props.Add('        end;');
        Props.Add('');
      end;
    StrCode := StringReplace(StrCode, sTagFPCEventsOut2, Props.Text, [rfReplaceAll]);
  finally
    Props.Free;
  end;

  StrCode := StringReplace(StrCode, sTagFPCEventsWql, Wql, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
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
  IsStatic: boolean;
  ParamsStr: string;
  TemplateCode: string;
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
      {
        if UseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
        else
        TemplateCode:='';
      }
      StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_FPC, ModeCodeGeneration, TWmiGenCode.WmiMethodStatic));
    end
    else
    begin
      {
        if UseHelperFunctions then
        TemplateCode := TFile.ReadAllText(GetTemplateLocation(sTemplateTemplateFuncts))
        else
        TemplateCode:='';
      }
      StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_FPC, ModeCodeGeneration, TWmiGenCode.WmiMethodNonStatic));
    end;

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);

    if IsStatic then
    begin
      // In Params
      if ParamsIn.Count > 0 then
        for i := 0 to ParamsIn.Count - 1 do
          if Values[i] <> WbemEmptyParam then
            if ParamsIn.ValueFromIndex[i] = wbemtypeString then
              DynCodeInParams.Add(Format('  FInParams.%s:=%s;', [ParamsIn.Names[i], QuotedStr(Values[i])]))
            else
              DynCodeInParams.Add(Format('  FInParams.%s:=%s;', [ParamsIn.Names[i], Values[i]]));
    end
    else
    begin
      // traer todos los parametros
      if WMiClassMetaData.MethodByName[WmiMethod].InParameters.Count = 0 then
      begin
        // DynCodeInParams.Add(Format('  FWbemObjectSet:= FWMIService.Get(%s);',[QuotedStr(WmiPath)]));
        DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s();', [WmiMethod]));
      end
      else
      begin
        ParamsStr := '';
        for i := 0 to WMiClassMetaData.MethodByName[WmiMethod].InParameters.Count - 1 do
          ParamsStr := ParamsStr + Values[i] + ',';
        Delete(ParamsStr, Length(ParamsStr), 1);
        DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s(%s);', [WmiMethod, ParamsStr]));
      end;
    end;
    StrCode := StringReplace(StrCode, sTagFPCCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

    // Out Params
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
    begin
      for i := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
        if UseHelperFunctions then
        begin
          // DynCodeOutParams.Add(Format('  sValue:=VarStrNull(FOutParams.%s);',[OutParamsList[i]])); disabled for now
          DynCodeOutParams.Add(Format('  sValue:=FOutParams.%s;',
            [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
          DynCodeOutParams.Add(Format('  Writeln(Format(''%-20s  %%s'',[sValue]));',
            [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
        end
        else
        begin
          DynCodeOutParams.Add(Format('  sValue:=FOutParams.%s;',
            [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
          DynCodeOutParams.Add(Format('  Writeln(Format(''%-20s  %%s'',[sValue]));',
            [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));
        end;
    end
    else if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
    begin
      if UseHelperFunctions then
      begin
        // DynCodeOutParams.Add('  sValue:=VarStrNull(FOutParams);'); disabled for now
        DynCodeOutParams.Add('  sValue:=FOutParams;');
        DynCodeOutParams.Add('  Writeln(Format(''ReturnValue %s'',[sValue]));');
      end
      else
      begin
        DynCodeOutParams.Add('  sValue:=FOutParams;');
        DynCodeOutParams.Add('  Writeln(Format(''ReturnValue %s'',[sValue]));');
      end;
    end;
    StrCode := StringReplace(StrCode, sTagFPCCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);

    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    DynCodeInParams.Free;
    DynCodeOutParams.Free;
  end;
end;

function TFPCWmiMethodCodeGenerator.GetWmiClassDescription: string;
var
  ClassDescr: TStringList;
  Index: integer;
begin
  ClassDescr := TStringList.Create;
  try
    Result := WMiClassMetaData.MethodByName[WmiMethod].Description;

    if Pos(#10, Result) = 0 then // check if the description has format
      ClassDescr.Text := WrapText(Result, 80)
    else
      ClassDescr.Text := Result; // WrapText(Summary,sLineBreak,[#10],80);

    for Index := 0 to ClassDescr.Count - 1 do
      ClassDescr[Index] := Format('// %s', [ClassDescr[Index]]);

    Result := ClassDescr.Text;
  finally
    ClassDescr.Free;
  end;
end;

end.
