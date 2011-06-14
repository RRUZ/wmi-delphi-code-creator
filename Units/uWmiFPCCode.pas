unit uWmiFPCCode;

interface

uses
 Classes;


const
  sTagFPCCode          = '[DELPHICODE]';
  sTagFPCCodeParamsIn  = '[DELPHICODEINPARAMS]';
  sTagFPCCodeParamsOut = '[DELPHICODEOUTPARAMS]';
  sTagFPCEventsWql     = '[FPCEVENTSWQL]';
  sTagFPCEventsOut     = '[FPCEVENTSOUT]';
  sTagFPCEventsOut2    = '[FPCEVENTSOUT2]';

procedure GenerateFPCWmiConsoleCode(const DestList, Props: TStrings;
  const Namespace, WmiClass: string; UseHelperFunct: boolean);

procedure GenerateFPCWmiInvokerCode(const DestList, ParamsIn, Values: TStrings;
  const Namespace, WmiClass, WmiMethod, WmiPath: string; UseHelperFunct: boolean);

procedure GenerateFPCWmiEventCode(
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


procedure GenerateFPCWmiConsoleCode(const DestList, Props: TStrings;
  const Namespace, WmiClass: string; UseHelperFunct: boolean);
var
  StrCode: string;
  Descr: string;
  ClassDescr: TStrings;
  DynCode: TStrings;
  i:   integer;
  Len: integer;
  Singleton: boolean;
  Padding: string;
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
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesSingletonHelper[Lng_FPC]))
      else
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesSingleton[Lng_FPC]));
    end
    else
    begin
      Padding := '  ';
      if UseHelperFunct then
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesHelper[Lng_FPC]))
      else
        StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplates[Lng_FPC]));
    end;


    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);

    Len := GetMaxLengthItemName(Props) + 3;

    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
        if UseHelperFunct then
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

procedure GenerateFPCWmiInvokerCode(const DestList, ParamsIn, Values: TStrings;
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

  IsStatic:  boolean;
  ParamsStr: string;
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
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesStaticInvokerHelper[Lng_FPC]))
      else
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesStaticInvoker[Lng_FPC]));
    end
    else
    begin
      if UseHelperFunct then
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesNonStaticInvokerHelper[Lng_FPC]))
      else
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesNonStaticInvoker[Lng_FPC]));
    end;

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);


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
    StrCode := StringReplace(StrCode, sTagFPCCodeParamsIn, DynCodeInParams.Text,
      [rfReplaceAll]);


    //Out Params
    if OutParamsList.Count > 1 then
    begin
      for i := 0 to OutParamsList.Count - 1 do
        if UseHelperFunct then
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
      if UseHelperFunct then
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



procedure GenerateFPCWmiEventCode(
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
  StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplatesEvents[Lng_FPC]));

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
  Len   := GetMaxLengthItem(PropsOut) + 3;

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
  StrCode := StringReplace(StrCode, sTagWmiNameSpace, Namespace, [rfReplaceAll]);
  StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);

  DestList.Text := StrCode;
end;


end.
