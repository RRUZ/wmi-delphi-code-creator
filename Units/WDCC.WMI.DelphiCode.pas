// **************************************************************************************************
//
// Unit WDCC.WMI.DelphiCode
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
// The Original Code is WDCC.WMI.DelphiCode.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.DelphiCode;

interface

uses
  WDCC.WMI.GenCode,
  Classes;

const
  DelphiMaxTypesClassCodeGen = 3;
  DelphiMaxTypesEventsCodeGen = 3;
  DelphiMaxTypesMethodCodeGen = 3;
  DelphiWmiClassCodeSupported: Array [0 .. DelphiMaxTypesClassCodeGen - 1] of TWmiCode = (WmiCode_Scripting,
    WmiCode_LateBinding, WmiCode_COM);
  DelphiWmiEventCodeSupported: Array [0 .. DelphiMaxTypesEventsCodeGen - 1] of TWmiCode = (WmiCode_Scripting,
    WmiCode_LateBinding, WmiCode_COM);
  DelphiWmiMethodCodeSupported: Array [0 .. DelphiMaxTypesMethodCodeGen - 1] of TWmiCode = (WmiCode_Scripting,
    WmiCode_LateBinding, WmiCode_COM);

type
  TDelphiWmiClassCodeGenerator = class(TWmiClassCodeGenerator)
  private type
    TDelphiHelperCodeGen = class(TWmiCodeGenerator.THelperCodeGen)
      procedure AddCode(const WmiProperty: string); override;
    end;
  public
    procedure GenerateCode(Props: TStrings); override;
    constructor Create;
    destructor Destroy; override;
  end;

  TDelphiWmiEventCodeGenerator = class(TWmiEventCodeGenerator)
  public
    procedure GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings); override;
  end;

  TDelphiWmiMethodCodeGenerator = class(TWmiMethodCodeGenerator)
  private
    function GetWmiClassDescription: string;
  public
    procedure GenerateCode(ParamsIn, Values: TStrings); override;
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
  WDCC.Misc,
  WDCC.SelectCompilerVersion,
  uWmi_Metadata;

const
  sTagDelphiCodeParamsIn = '[DELPHICODEINPARAMS]';
  sTagDelphiCodeParamsOut = '[DELPHICODEOUTPARAMS]';
  sTagDelphiCode = '[DELPHICODE]';
  sTagDelphiEventsWql = '[DELPHIEVENTSWQL]';
  sTagDelphiEventsOut = '[DELPHIEVENTSOUT]';
  sTagDelphiEventsOut2 = '[DELPHIEVENTSOUT2]';

  { TDelphiWmiClassCodeGenerator.TDelphiHelperCodeGen }

procedure TDelphiWmiClassCodeGenerator.TDelphiHelperCodeGen.AddCode(const WmiProperty: string);
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

{ TDelphiWmiEventCodeGenerator }

procedure TDelphiWmiEventCodeGenerator.GenerateCode(ParamsIn, Values, Conds, PropsOut: TStrings);
var
  StrCode: string;
  sValue: string;
  Wql: string;
  i, Len: integer;
  Props: TStrings;
  CimType: integer;
begin

  StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_Delphi, ModeCodeGeneration, TWmiGenCode.WmiEvents));;

  case ModeCodeGeneration of
    WmiCode_LateBinding, WmiCode_Default, WmiCode_Scripting:
      begin
        Wql := Format('Select * From %s Within %d ', [WmiClass, PollSeconds, WmiTargetInstance]);
        Wql := Format('  FWQL:=%s+%s', [QuotedStr(Wql), sLineBreak]);

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

        Len := GetMaxLengthItem(PropsOut) + 3;
        Props := TStringList.Create;
        try
          for i := 0 to PropsOut.Count - 1 do
          begin
            // Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) +'s : %%s '',[PropVal.%s]));', [PropsOut[i], PropsOut[i]]));

            CimType := integer(PropsOut.Objects[i]);
            case CimType of

              wbemCimtypeSint8, wbemCimtypeUint8, wbemCimtypeSint16, wbemCimtypeUint16, wbemCimtypeSint32,
                wbemCimtypeUint32, wbemCimtypeSint64, wbemCimtypeUint64:
                Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) + 's : %%d '',[Integer(PropVal.%s)]));',
                  [PropsOut[i], PropsOut[i]]));
              wbemCimtypeReal32:
                Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) + 's : %%n '',[Double(PropVal.%s)]));',
                  [PropsOut[i], PropsOut[i]]));
              wbemCimtypeReal64:
                Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) + 's : %%n '',[Double(PropVal.%s)]));',
                  [PropsOut[i], PropsOut[i]]));
              wbemCimtypeBoolean, wbemCimtypeDatetime, wbemCimtypeString, wbemCimtypeChar16:
                Props.Add(Format('  Writeln(Format(''%-' + IntToStr(Len) + 's : %%s '',[String(PropVal.%s)]));',
                  [PropsOut[i], PropsOut[i]]));
            end;
          end;

          StrCode := StringReplace(StrCode, sTagDelphiEventsOut, Props.Text, [rfReplaceAll]);
        finally
          Props.Free;
        end;

        StrCode := StringReplace(StrCode, sTagDelphiEventsWql, Wql, [rfReplaceAll]);
        StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
        StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
      end;

    // WmiCode_LateBinding:StrCode := '//Not implemented, please select another method for code generation in the Settings option';

    WmiCode_COM:
      begin
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
          StrCode := StringReplace(StrCode, sTagDelphiEventsOut, Props.Text, [rfReplaceAll]);
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
              Props.Add(Format('          Writeln(Format(''%s %%s'',[String(sValue)]));', [sValue]));
              Props.Add('        end;');
              Props.Add('');
            end;
          StrCode := StringReplace(StrCode, sTagDelphiEventsOut2, Props.Text, [rfReplaceAll]);
        finally
          Props.Free;
        end;

        StrCode := StringReplace(StrCode, sTagDelphiEventsWql, Wql, [rfReplaceAll]);
        StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
        StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
      end;

  end;

  StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode.Text, [rfReplaceAll]);
  OutPutCode.Text := StrCode;
end;

{ TDelphiWmiClassCodeGenerator }

constructor TDelphiWmiClassCodeGenerator.Create;
begin
  inherited;
  if Assigned(HelperCodeGen) then
    HelperCodeGen.Free;

  HelperCodeGen := TDelphiHelperCodeGen.Create;
end;

destructor TDelphiWmiClassCodeGenerator.Destroy;
begin
  inherited;
end;

procedure TDelphiWmiClassCodeGenerator.GenerateCode(Props: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCode: TStrings;
  i: integer;
  Len: integer;
  // Singleton: boolean;
  Padding: string;
  CimType: integer;
  TypeStr: string;
begin
  // Singleton := WMiClassMetaData.IsSingleton;
  Descr := GetWmiClassDescription;

  DynCode := TStringList.Create;
  try
    OutPutCode.Clear;

    StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_Delphi, ModeCodeGeneration, TWmiGenCode.WmiClasses));

    HelperCodeGen.WmiCodeGenerator := Self;
    TemplateCode.Clear;
    if UseHelperFunctions then
      for i := 0 to Props.Count - 1 do
        HelperCodeGen.AddCode(Props.Names[i]);

    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);

    Len := GetMaxLengthItemName(Props) + 3;

    case ModeCodeGeneration of
      WmiCode_Scripting:
        begin
          Padding := StringOfChar(' ', 2);
          if Props.Count > 0 then
            for i := 0 to Props.Count - 1 do
              if UseHelperFunctions and HelperCodeGen.HelperFuncts.ContainsKey(Props.Names[i]) and
                not WMiClassMetaData.Properties[i].IsArray then
                DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                  's %%s'',[Get%sAsString(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s',
                  [Props.Names[i], Props.Names[i], QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]))
              else
              {
                if WMiClassMetaData.Properties[i].IsArray then
                begin




                end
                else
              }
              begin

                if WMiClassMetaData.Properties[i].IsArray then
                  TypeStr := 'Array of ' + Props.ValueFromIndex[i]
                else
                  TypeStr := Props.ValueFromIndex[i];

                CimType := integer(Props.Objects[i]);
                case CimType of

                  wbemCimtypeSint8, wbemCimtypeUint8, wbemCimtypeSint16, wbemCimtypeUint16, wbemCimtypeSint32,
                    wbemCimtypeUint32, wbemCimtypeSint64, wbemCimtypeUint64:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%d'',[Integer(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s',
                      [Props.Names[i], QuotedStr(Props.Names[i]), TypeStr]));
                  wbemCimtypeReal32:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%n'',[Double(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s',
                      [Props.Names[i], QuotedStr(Props.Names[i]), TypeStr]));
                  wbemCimtypeReal64:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%n'',[Double(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s',
                      [Props.Names[i], QuotedStr(Props.Names[i]), TypeStr]));
                  wbemCimtypeBoolean, wbemCimtypeDatetime, wbemCimtypeString, wbemCimtypeChar16:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%s'',[String(FWbemPropertySet.Item(%s, 0).Get_Value)]));// %s',
                      [Props.Names[i], QuotedStr(Props.Names[i]), TypeStr]));

                  {
                    wbemCimtypeReference : ;
                    wbemCimtypeObject    : ;
                  }
                end;
              end;
        end;

      WmiCode_Default, WmiCode_LateBinding:
        begin
          Padding := StringOfChar(' ', 2);
          if Props.Count > 0 then
            for i := 0 to Props.Count - 1 do
              if UseHelperFunctions and HelperCodeGen.HelperFuncts.ContainsKey(Props.Names[i]) and
                not WMiClassMetaData.PropertyByName[Props.Names[i]].IsArray then
                DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                  's %%s'',[Get%sAsString(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i], Props.Names[i],
                  Props.ValueFromIndex[i]]))
              else
              begin

                if WMiClassMetaData.Properties[i].IsArray then
                  TypeStr := 'Array of ' + Props.ValueFromIndex[i]
                else
                  TypeStr := Props.ValueFromIndex[i];

                CimType := integer(Props.Objects[i]);
                case CimType of

                  wbemCimtypeSint8, wbemCimtypeUint8, wbemCimtypeSint16, wbemCimtypeUint16, wbemCimtypeSint32,
                    wbemCimtypeUint32, wbemCimtypeSint64, wbemCimtypeUint64:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%d'',[Integer(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i], TypeStr]));
                  wbemCimtypeReal32:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%n'',[Double(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i], TypeStr]));
                  wbemCimtypeReal64:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%n'',[Double(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i], TypeStr]));
                  wbemCimtypeBoolean, wbemCimtypeDatetime, wbemCimtypeString, wbemCimtypeChar16:
                    DynCode.Add(Padding + Format('  Writeln(Format(''%-' + IntToStr(Len) +
                      's %%s'',[String(FWbemObject.%s)]));// %s', [Props.Names[i], Props.Names[i], TypeStr]));

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
          Padding := Padding + StringOfChar(' ', 15);
          if Props.Count > 0 then
            for i := 0 to Props.Count - 1 do
            begin
              DynCode.Add(Padding + Format('apObjects.Get(%s, 0, pVal, pType, plFlavor);// %s',
                [QuotedStr(Props.Names[i]), Props.ValueFromIndex[i]]));
              if UseHelperFunctions and HelperCodeGen.HelperFuncts.ContainsKey(Props.Names[i]) and
                not WMiClassMetaData.PropertyByName[Props.Names[i]].IsArray then
                // DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[VarStrNull(pVal)]));', [Props.Names[i]]))
                DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) +
                  's %%s'',[Get%sAsString(pVal)])); //%s', [Props.Names[i], Props.Names[i], Props.ValueFromIndex[i]]))

              else
              begin
                // DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) + 's %%s'',[pVal]));', [Props.Names[i]]));

                if WMiClassMetaData.Properties[i].IsArray then
                  TypeStr := 'Array of ' + Props.ValueFromIndex[i]
                else
                  TypeStr := Props.ValueFromIndex[i];

                CimType := integer(Props.Objects[i]);
                case CimType of
                  wbemCimtypeSint8, wbemCimtypeUint8, wbemCimtypeSint16, wbemCimtypeUint16, wbemCimtypeSint32,
                    wbemCimtypeUint32, wbemCimtypeSint64, wbemCimtypeUint64:
                    DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) +
                      's %%d'',[Integer(pVal)]));//%s', [Props.Names[i], TypeStr]));
                  wbemCimtypeReal32:
                    DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) +
                      's %%n'',[Double(pVal)]));//%s', [Props.Names[i], TypeStr]));
                  wbemCimtypeReal64:
                    DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) +
                      's %%n'',[Double(pVal)]));//%s', [Props.Names[i], TypeStr]));
                  wbemCimtypeBoolean, wbemCimtypeDatetime, wbemCimtypeString, wbemCimtypeChar16:
                    DynCode.Add(Padding + Format('Writeln(Format(''%-' + IntToStr(Len) +
                      's %%s'',[String(pVal)]));//%s', [Props.Names[i], TypeStr]));
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
    OutPutCode.Text := StrCode;
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
  IsStatic: boolean;
  ParamsStr: string;
  Padding: string;
begin
  DynCodeInParams := TStringList.Create;
  DynCodeOutParams := TStringList.Create;
  try
    IsStatic := WMiClassMetaData.MethodByName[WmiMethod].IsStatic;

    if IsStatic then
      StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_Delphi, ModeCodeGeneration, TWmiGenCode.WmiMethodStatic))
    else
      StrCode := TFile.ReadAllText(GetTemplateLocation(Lng_Delphi, ModeCodeGeneration, TWmiGenCode.WmiMethodNonStatic));

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, WmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, WmiPath, [rfReplaceAll]);

    case ModeCodeGeneration of
      WmiCode_COM:
        begin
          Padding := StringOfChar(' ', 23);
          // pVal     := 0;
          // pClassInstance.Put('Reason', 0, @pVal, 0);
          // In Params
          if ParamsIn.Count > 0 then
            for Index := 0 to ParamsIn.Count - 1 do
              if Values[Index] <> WbemEmptyParam then
              begin
                if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                begin
                  DynCodeInParams.Add(Format('%s  pVal :=%s;', [Padding, QuotedStr(Values[Index])]));
                  DynCodeInParams.Add(Format('%s  pClassInstance.Put(%s, 0, @pVal, 0);',
                    [Padding, QuotedStr(ParamsIn.Names[Index])]));
                end
                else
                begin
                  DynCodeInParams.Add(Format('%s  pVal :=%s;', [Padding, Values[Index]]));
                  DynCodeInParams.Add(Format('%s  pClassInstance.Put(%s, 0, @pVal, 0);',
                    [Padding, QuotedStr(ParamsIn.Names[Index])]));
                end
              end;

          StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

          // Out Params
          if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
          begin
            for Index := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
            begin
              DynCodeOutParams.Add(Format('%s  ppOutParams.Get(%s, 0, pVal, pType, plFlavor);',
                [Padding, QuotedStr(WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name)]));
              {
                if UseHelperFunctions then
                DynCodeOutParams.Add(
                Format('%s  Writeln(Format(''%-20s  %%s'',[VarStrNull(pVal)]));',[Padding,WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name]))
                else
              }
              DynCodeOutParams.Add(Format('%s  Writeln(Format(''%-20s  %%s'',[pVal]));',
                [Padding, WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name]));
              DynCodeOutParams.Add(Padding + '  VarClear(pVal);');
            end;
          end
          else if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
          begin
            DynCodeOutParams.Add(Format('%s  ppOutParams.Get(%s, 0, pVal, pType, plFlavor);',
              [Padding, QuotedStr('ReturnValue')]));
            {
              if UseHelperFunctions then
              DynCodeOutParams.Add(Padding+'  Writeln(Format(''ReturnValue  %s'',[VarStrNull(pVal)]));')
              else
            }
            DynCodeOutParams.Add(Padding + '  Writeln(Format(''ReturnValue  %s'',[pVal]));');
            DynCodeOutParams.Add(Padding + '  VarClear(pVal);');
          end;
          StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);

        end;

      WmiCode_Scripting:
        begin
          // varValue      := 'notepad.exe';
          // FInParams.Properties_.Item('CommandLine', 0).Set_Value(varValue);
          // In Params
          if ParamsIn.Count > 0 then
            for Index := 0 to ParamsIn.Count - 1 do
              if Values[Index] <> WbemEmptyParam then
              begin
                if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                begin
                  DynCodeInParams.Add(Format('  varValue :=%s;', [QuotedStr(Values[Index])]));
                  DynCodeInParams.Add(Format('  FInParams.Properties_.Item(%s, 0).Set_Value(varValue);',
                    [QuotedStr(ParamsIn.Names[Index])]));
                end
                else
                begin
                  DynCodeInParams.Add(Format('  varValue :=%s;', [Values[Index]]));
                  DynCodeInParams.Add(Format('  FInParams.Properties_.Item(%s, 0).Set_Value(varValue);',
                    [QuotedStr(ParamsIn.Names[Index])]));
                end
              end;
          StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

          // Writeln(Format('ProcessId             %s',[FOutParams.Properties_.Item('ProcessId', 0).Get_Value]));
          // Out Params
          if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
          begin
            for Index := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
              {
                if UseHelperFunctions then
                DynCodeOutParams.Add(
                Format('  Writeln(Format(''%-20s  %%s'',[VarStrNull(FOutParams.Properties_.Item(%s,0).Get_Value)]));',[WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name, QuotedStr(WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name)]))
                else
              }
              DynCodeOutParams.Add
                (Format('  Writeln(Format(''%-20s  %%s'',[FOutParams.Properties_.Item(%s,0).Get_Value]));',
                [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name,
                QuotedStr(WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name)]));
          end
          else if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
          begin
            {
              if UseHelperFunctions then
              DynCodeOutParams.Add('  Writeln(Format(''ReturnValue  %s'',[VarStrNull(FOutParams.Properties_.Item(''ReturnValue'',0).Get_Value)]));')
              else
            }
            DynCodeOutParams.Add
              ('  Writeln(Format(''ReturnValue  %s'',[FOutParams.Properties_.Item(''ReturnValue'',0).Get_Value]));');
          end;
          StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);

        end;

      WmiCode_Default, WmiCode_LateBinding:
        begin
          if IsStatic then
          begin
            // In Params
            if ParamsIn.Count > 0 then
              for Index := 0 to ParamsIn.Count - 1 do
                if Values[Index] <> WbemEmptyParam then
                  if ParamsIn.ValueFromIndex[Index] = wbemtypeString then
                    DynCodeInParams.Add(Format('  FInParams.%s:=%s;', [ParamsIn.Names[Index],
                      QuotedStr(Values[Index])]))
                  else
                    DynCodeInParams.Add(Format('  FInParams.%s:=%s;', [ParamsIn.Names[Index], Values[Index]]));
          end
          else
          begin
            if WMiClassMetaData.MethodByName[WmiMethod].InParameters.Count = 0 then
            begin
              // DynCodeInParams.Add(Format('  FWbemObjectSet:= FWMIService.Get(%s);',[QuotedStr(WmiPath)]));
              DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s();', [WmiMethod]));
            end
            else
            begin
              ParamsStr := '';
              for Index := 0 to WMiClassMetaData.MethodByName[WmiMethod].InParameters.Count - 1 do
                ParamsStr := ParamsStr + Values[Index] + ',';
              Delete(ParamsStr, Length(ParamsStr), 1);
              DynCodeInParams.Add(Format('  FOutParams:=FWbemObjectSet.%s(%s);', [WmiMethod, ParamsStr]));
            end;
          end;
          StrCode := StringReplace(StrCode, sTagDelphiCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

          // Out Params
          if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
          begin
            for Index := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
              {
                if UseHelperFunctions then
                DynCodeOutParams.Add(
                Format('  Writeln(Format(''%-20s  %%s'',[VarStrNull(FOutParams.%s)]));',
                [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name, WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name]))
                else
              }
              DynCodeOutParams.Add(Format('  Writeln(Format(''%-20s  %%s'',[FOutParams.%s]));',
                [WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name,
                WMiClassMetaData.MethodByName[WmiMethod].OutParameters[Index].Name]));
          end
          else if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
          begin
            {
              if UseHelperFunctions then
              DynCodeOutParams.Add(
              '  Writeln(Format(''ReturnValue           %s'',[VarStrNull(FOutParams)]));')
              else
            }
            DynCodeOutParams.Add('  Writeln(Format(''ReturnValue           %s'',[FOutParams]));');
          end;
          StrCode := StringReplace(StrCode, sTagDelphiCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);
        end;

    end;
    Descr := GetWmiClassDescription;
    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    DynCodeInParams.Free;
    DynCodeOutParams.Free;
  end;
end;

function TDelphiWmiMethodCodeGenerator.GetWmiClassDescription: string;
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

initialization

FileVersionStr := GetFileVersion(Application.ExeName);

end.
