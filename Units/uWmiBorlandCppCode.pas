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

function EscapeCppStr(const Value:string) : string;
const
 ArrChrEscape : Array [0..1] of Char = ('"','\');
Var
 i : integer;
begin
  Result:=Value;
  for i:= Low(ArrChrEscape) to High(ArrChrEscape) do
   Result:=StringReplace(Result,ArrChrEscape[i],ArrChrEscape[i]+ArrChrEscape[i], [rfReplaceAll]);
end;




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

  OutPutCode.BeginUpdate;
  DynCode    := TStringList.Create;
  try
    OutPutCode.Clear;

    Padding := StringOfChar(' ',16);
    TemplateCode:='';
    StrCode := TFile.ReadAllText(GetTemplateLocation(ListSourceTemplates[Lng_BorlandCpp]));

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    eWmiNameSpace:=StringReplace(WmiNameSpace,'\','\\', [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, eWmiNameSpace, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);


    (*
				hr = pclsObj->Get(L"TotalVirtualMemorySize", 0, &vtProp, 0, 0);// Uint64
				if (!FAILED(hr))
				{
					if ((vtProp.vt==VT_NULL) || (vtProp.vt==VT_EMPTY))
					  wcout << "TotalVirtualMemorySize : " << "NULL" << endl;
					else
					if ((vtProp.vt & VT_ARRAY))
					  wcout << "TotalVirtualMemorySize : " << "Array types not supported (yet)" << endl;
					else
					  wcout << "TotalVirtualMemorySize : " << vtProp.uintVal << endl;
				}
				VariantClear(&vtProp);
    *)

    if Props.Count > 0 then
      for i := 0 to Props.Count - 1 do
       begin
          DynCode.Add(Padding + Format('hr = pclsObj->Get(L"%s", 0, &vtProp, 0, 0);// %s',[Props.Names[i],Props.ValueFromIndex[i]]));
          DynCode.Add(Padding + 'if (!FAILED(hr))');
          DynCode.Add(Padding + '{');
          DynCode.Add(Padding + '  if ((vtProp.vt==VT_NULL) || (vtProp.vt==VT_EMPTY))');
          DynCode.Add(Padding + Format('    wcout << "%s : " << ((vtProp.vt==VT_NULL) ? "%s" : "%s") << endl;',[Props.Names[i],'NULL','EMPTY']));
          DynCode.Add(Padding + '  else');
          DynCode.Add(Padding + '  if ((vtProp.vt & VT_ARRAY))');
          DynCode.Add(Padding + Format('    wcout << "%s : " << "%s" << endl;',[Props.Names[i],'Array types not supported (yet)']));
          DynCode.Add(Padding + '  else');


          CimType:=Integer(Props.Objects[i]);
          case CimType of
              wbemCimtypeSint8     : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bVal   << endl;',[Props.Names[i]]));
              wbemCimtypeUint8     : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bVal   << endl;',[Props.Names[i]]));
              wbemCimtypeSint16    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.iVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint16    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.uiVal << endl;',[Props.Names[i]]));
              wbemCimtypeSint32    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.intVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint32    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.uintVal << endl;',[Props.Names[i]]));
              wbemCimtypeSint64    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.intVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint64    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.uintVal << endl;',[Props.Names[i]]));
              wbemCimtypeReal32    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.fltVal << endl;',[Props.Names[i]]));
              wbemCimtypeReal64    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.dblVal << endl;',[Props.Names[i]]));
              wbemCimtypeBoolean   : DynCode.Add(Padding + Format('    wcout << "%s : " << (vtProp.boolVal ? "True" : "False") << endl;',[Props.Names[i]]));//ok
              wbemCimtypeString    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));//ok
              wbemCimtypeDatetime  : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));//ok
              wbemCimtypeReference : DynCode.Add(Padding + Format('    wcout << "%s : " << "Reference Type is not supported" << endl;',[Props.Names[i]]));
              wbemCimtypeChar16    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));
              wbemCimtypeObject    : DynCode.Add(Padding + Format('    wcout << "%s : " << "Object Type is not supported" << endl;',[Props.Names[i]]));
          end;


          DynCode.Add(Padding + '}');
          DynCode.Add(Padding+ 'VariantClear(&vtProp);');
          DynCode.Add('');
       end;

    StrCode := StringReplace(StrCode, sTagCppCode, DynCode.Text, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    OutPutCode.EndUpdate;
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

  WQL := Format('Select * From %s Within %d ', [WmiClass, PollSeconds,
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

  OutPutCode.Text := StrCode;
end;

{ TFPCWmiMethodCodeGenerator }

procedure TBorlandCppWmiMethodCodeGenerator.GenerateCode(ParamsIn, Values: TStrings);
var
  StrCode: string;
  Descr: string;
  DynCodeInParams: TStrings;
  DynCodeOutParams: TStrings;
  i: integer;

  IsStatic:  boolean;
  //ParamsStr: string;
  TemplateCode : string;
  Padding : string;
  CimType : Integer;
  ParamName : string;
begin
  Descr := GetWmiClassDescription;

  //OutPutCode.BeginUpdate;
  DynCodeInParams := TStringList.Create;
  DynCodeOutParams := TStringList.Create;
  try
    IsStatic := WMiClassMetaData.MethodByName[WmiMethod].IsStatic;

    OutPutCode.Clear;
    if IsStatic then
    begin
        TemplateCode:='';
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesStaticInvoker[Lng_BorlandCpp]));
    end
    else
    begin
        TemplateCode:='';
        StrCode := TFile.ReadAllText(GetTemplateLocation(
          ListSourceTemplatesNonStaticInvoker[Lng_BorlandCpp]));
    end;

    StrCode := StringReplace(StrCode, sTagVersionApp, FileVersionStr, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiClassName, WmiClass, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiNameSpace, EscapeCppStr(WmiNameSpace), [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiMethodName, WmiMethod, [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagWmiPath, EscapeCppStr(WmiPath), [rfReplaceAll]);
    StrCode := StringReplace(StrCode, sTagHelperTemplate, TemplateCode, [rfReplaceAll]);

    Padding := StringOfChar(' ',4);
 {
/*
 * VARENUM usage key,
 *
 * * [V] - may appear in a VARIANT
 * * [T] - may appear in a TYPEDESC
 * * [P] - may appear in an OLE property set
 * * [S] - may appear in a Safe Array
 *
 *
 *  VT_EMPTY            [V]   [P]     nothing
 *  VT_NULL             [V]   [P]     SQL style Null
 *  VT_I2               [V][T][P][S]  2 byte signed int
 *  VT_I4               [V][T][P][S]  4 byte signed int
 *  VT_R4               [V][T][P][S]  4 byte real
 *  VT_R8               [V][T][P][S]  8 byte real
 *  VT_CY               [V][T][P][S]  currency
 *  VT_DATE             [V][T][P][S]  date
 *  VT_BSTR             [V][T][P][S]  OLE Automation string
 *  VT_DISPATCH         [V][T]   [S]  IDispatch *
 *  VT_ERROR            [V][T][P][S]  SCODE
 *  VT_BOOL             [V][T][P][S]  True=-1, False=0
 *  VT_VARIANT          [V][T][P][S]  VARIANT *
 *  VT_UNKNOWN          [V][T]   [S]  IUnknown *
 *  VT_DECIMAL          [V][T]   [S]  16 byte fixed point
 *  VT_RECORD           [V]   [P][S]  user defined type
 *  VT_I1               [V][T][P][s]  signed char
 *  VT_UI1              [V][T][P][S]  unsigned char
 *  VT_UI2              [V][T][P][S]  unsigned short
 *  VT_UI4              [V][T][P][S]  unsigned long
 *  VT_I8                  [T][P]     signed 64-bit int
 *  VT_UI8                 [T][P]     unsigned 64-bit int
 *  VT_INT              [V][T][P][S]  signed machine int
 *  VT_UINT             [V][T]   [S]  unsigned machine int
 *  VT_INT_PTR             [T]        signed machine register size width
 *  VT_UINT_PTR            [T]        unsigned machine register size width
 *  VT_VOID                [T]        C style void
 *  VT_HRESULT             [T]        Standard return type
 *  VT_PTR                 [T]        pointer type
 *  VT_SAFEARRAY           [T]        (use VT_ARRAY in VARIANT)
 *  VT_CARRAY              [T]        C style array
 *  VT_USERDEFINED         [T]        user defined type
 *  VT_LPSTR               [T][P]     null terminated string
 *  VT_LPWSTR              [T][P]     wide null terminated string
 *  VT_FILETIME               [P]     FILETIME
 *  VT_BLOB                   [P]     Length prefixed bytes
 *  VT_STREAM                 [P]     Name of the stream follows
 *  VT_STORAGE                [P]     Name of the storage follows
 *  VT_STREAMED_OBJECT        [P]     Stream contains an object
 *  VT_STORED_OBJECT          [P]     Storage contains an object
 *  VT_VERSIONED_STREAM       [P]     Stream with a GUID version
 *  VT_BLOB_OBJECT            [P]     Blob contains an object
 *  VT_CF                     [P]     Clipboard format
 *  VT_CLSID                  [P]     A Class ID
 *  VT_VECTOR                 [P]     simple counted array
 *  VT_ARRAY            [V]           SAFEARRAY*
 *  VT_BYREF            [V]           void* for local use
 *  VT_BSTR_BLOB                      Reserved for system use
 */


              wbemCimtypeSint8     : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bVal   << endl;',[Props.Names[i]]));
              wbemCimtypeUint8     : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bVal   << endl;',[Props.Names[i]]));
              wbemCimtypeSint16    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.iVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint16    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.uiVal << endl;',[Props.Names[i]]));
              wbemCimtypeSint32    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.intVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint32    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.uintVal << endl;',[Props.Names[i]]));
              wbemCimtypeSint64    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.intVal << endl;',[Props.Names[i]]));
              wbemCimtypeUint64    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.uintVal << endl;',[Props.Names[i]]));
              wbemCimtypeReal32    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.fltVal << endl;',[Props.Names[i]]));
              wbemCimtypeReal64    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.dblVal << endl;',[Props.Names[i]]));
              wbemCimtypeBoolean   : DynCode.Add(Padding + Format('    wcout << "%s : " << (vtProp.boolVal ? "True" : "False") << endl;',[Props.Names[i]]));//ok
              wbemCimtypeString    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));//ok
              wbemCimtypeDatetime  : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));//ok
              wbemCimtypeReference : DynCode.Add(Padding + Format('    wcout << "%s : " << "Reference Type is not supported" << endl;',[Props.Names[i]]));
              wbemCimtypeChar16    : DynCode.Add(Padding + Format('    wcout << "%s : " << vtProp.bstrVal << endl;',[Props.Names[i]]));
              wbemCimtypeObject    : DynCode.Add(Padding + Format('    wcout << "%s : " << "Object Type is not supported" << endl;',[Props.Names[i]]));
    }

        {
        VARIANT varCommand;
        varCommand.vt = VT_BSTR;
        varCommand.bstrVal = L"notepad.exe";
        // Store the value for the in parameters
        hres = pClassInstance->Put(L"CommandLine", 0, &varCommand, 0);
        }

      if ParamsIn.Count > 0 then
      begin
        DynCodeInParams.Add(Padding+'VARIANT varCommand;');
        for i := 0 to ParamsIn.Count - 1 do
        if Values[i] <> WbemEmptyParam then
        begin

          CimType:=Integer(Values.Objects[i]);
          case CimType of
              wbemCimtypeSint8     :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_I1;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.bVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeUint8     :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_UI1;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.bVal = %s;',[Values[i]]));
                                    end;

              wbemCimtypeSint16    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_I2;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.iVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeUint16    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_UI2;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.uiVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeSint32    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_I4;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.intVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeUint32    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_UI4;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.uintVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeSint64    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_I8;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.intVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeUint64    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_UI8;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.uintVal = %s;',[Values[i]]));
                                    end;

              wbemCimtypeReal32    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_R4;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.fltVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeReal64    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_R8;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.dblVal = %s;',[Values[i]]));
                                    end;

              wbemCimtypeBoolean   :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_I2;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.boolVal = %s;',[Values[i]]));
                                    end;
              wbemCimtypeString    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_BSTR;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.bstrVal = L"%s";',[Values[i]]));
                                    end;

              wbemCimtypeDatetime  :
                                    begin
                                      //DynCodeInParams.Add(Padding+'varCommand.vt = VT_I2;');
                                      //DynCodeInParams.Add(Padding+Format('varCommand.bstrVal = L"%s"',[Values[i]]));
                                    end;
              wbemCimtypeReference :
                                    begin
                                      //DynCodeInParams.Add(Padding+'varCommand.vt = VT_I2;');
                                      //DynCodeInParams.Add(Padding+Format('varCommand.bstrVal = L"%s"',[Values[i]]));
                                    end;
              wbemCimtypeChar16    :
                                    begin
                                      DynCodeInParams.Add(Padding+'varCommand.vt = VT_I2;');
                                      DynCodeInParams.Add(Padding+Format('varCommand.bstrVal = L"%s";',[Values[i]]));
                                    end;
              wbemCimtypeObject    :
                                    begin
                                      //DynCodeInParams.Add(Padding+'varCommand.vt = VT_I2;');
                                      //DynCodeInParams.Add(Padding+Format('varCommand.bstrVal = L"%s"',[Values[i]]));
                                    end;

          end;


         DynCodeInParams.Add(Padding+Format('hres = pClassInstance->Put(L"%s", 0, &varCommand, 0);',[ParamsIn.Names[i]]));;
         DynCodeInParams.Add(Padding+'VariantClear(&varCommand);');
        end;


      end;

    StrCode := StringReplace(StrCode, sTagCppCodeParamsIn, DynCodeInParams.Text, [rfReplaceAll]);

            {
                hr = pclsObj->Get(L"ConfigManagerUserConfig", 0, &vtProp, 0, 0);// Boolean
                if (!FAILED(hr))
                wcout << "ConfigManagerUserConfig : " << vtProp.boolVal << endl;
                VariantClear(&vtProp);
            }

            {
                VARIANT varReturnValue;
                hres = pOutParams->Get(L"ReturnValue", 0, &varReturnValue, NULL, 0);
                VariantClear(&varReturnValue);

            }

    //Out Params
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count > 1 then
    begin
      DynCodeOutParams.Add(Padding+'VARIANT varReturnValue;');
      for i := 0 to WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count - 1 do
        begin
          DynCodeOutParams.Add(Padding+Format('hres = pOutParams->Get(L"%s", 0, &varReturnValue, NULL, 0);',[WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name]));

          {
          DynCodeOutParams.Add(Padding+'if (!FAILED(hres))');
          CimType:=Integer(OutParamsTypes.Objects[i]);
          case CimType of
              wbemCimtypeSint8     : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.iVal   << endl;',[OutParamsList[i]]));
              wbemCimtypeUint8     : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.uiVal   << endl;',[OutParamsList[i]]));
              wbemCimtypeSint16    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.intVal << endl;',[OutParamsList[i]]));
              wbemCimtypeUint16    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.uintVal << endl;',[OutParamsList[i]]));
              wbemCimtypeSint32    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.intVal << endl;',[OutParamsList[i]]));
              wbemCimtypeUint32    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.uintVal << endl;',[OutParamsList[i]]));
              wbemCimtypeSint64    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.llVal << endl;',[OutParamsList[i]]));
              wbemCimtypeUint64    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.ullVal << endl;',[OutParamsList[i]]));
              wbemCimtypeReal32    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.fltVal << endl;',[OutParamsList[i]]));
              wbemCimtypeReal64    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.dblVal << endl;',[OutParamsList[i]]));
              wbemCimtypeBoolean   : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.boolVal << endl;',[OutParamsList[i]]));
              wbemCimtypeString    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.bstrVal << endl;',[OutParamsList[i]]));
              wbemCimtypeDatetime  : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[OutParamsList[i]]));
              wbemCimtypeReference : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[OutParamsList[i]]));
              wbemCimtypeChar16    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << varReturnValue.bstrVal << endl;',[OutParamsList[i]]));
              wbemCimtypeObject    : DynCodeOutParams.Add(Padding + Format('wcout << "%s : " << "Not supported" << endl;',[OutParamsList[i]]));
          end;
          }

          DynCodeOutParams.Add(Padding + 'if (!FAILED(hres))');
          DynCodeOutParams.Add(Padding + '{');
          DynCodeOutParams.Add(Padding + '  if ((varReturnValue.vt==VT_NULL) || (varReturnValue.vt==VT_EMPTY))');
          DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << ((varReturnValue.vt==VT_NULL) ? "%s" : "%s") << endl;',[WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name,'NULL','EMPTY']));
          DynCodeOutParams.Add(Padding + '  else');
          DynCodeOutParams.Add(Padding + '  if ((varReturnValue.vt & VT_ARRAY))');
          DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << "%s" << endl;',[WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name,'Array types not supported (yet)']));
          DynCodeOutParams.Add(Padding + '  else');

          ParamName:=WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].Name;
          CimType  :=WMiClassMetaData.MethodByName[WmiMethod].OutParameters[i].CimType;

          case CimType of
              wbemCimtypeSint8     : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.bVal   << endl;',[ParamName]));
              wbemCimtypeUint8     : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.bVal   << endl;',[ParamName]));
              wbemCimtypeSint16    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.iVal << endl;',[ParamName]));
              wbemCimtypeUint16    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.uiVal << endl;',[ParamName]));
              wbemCimtypeSint32    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.intVal << endl;',[ParamName]));
              wbemCimtypeUint32    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.uintVal << endl;',[ParamName]));
              wbemCimtypeSint64    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.intVal << endl;',[ParamName]));
              wbemCimtypeUint64    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.uintVal << endl;',[ParamName]));
              wbemCimtypeReal32    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.fltVal << endl;',[ParamName]));
              wbemCimtypeReal64    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.dblVal << endl;',[ParamName]));
              wbemCimtypeBoolean   : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << (varReturnValue.boolVal ? "True" : "False") << endl;',[ParamName]));//ok
              wbemCimtypeString    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.bstrVal << endl;',[ParamName]));//ok
              wbemCimtypeDatetime  : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.bstrVal << endl;',[ParamName]));//ok
              wbemCimtypeReference : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << "Reference Type is not supported" << endl;',[ParamName]));
              wbemCimtypeChar16    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << varReturnValue.bstrVal << endl;',[ParamName]));
              wbemCimtypeObject    : DynCodeOutParams.Add(Padding + Format('    wcout << "%s : " << "Object Type is not supported" << endl;',[ParamName]));
          end;


          DynCodeOutParams.Add(Padding + '}');
          DynCodeOutParams.Add(Padding+'VariantClear(&varReturnValue);');
          DynCodeOutParams.Add('');
        end;
    end
    else
    if WMiClassMetaData.MethodByName[WmiMethod].OutParameters.Count = 1 then
    begin
        DynCodeOutParams.Add(Padding+'VARIANT varReturnValue;');
        DynCodeOutParams.Add(Padding+'hres = pOutParams->Get(L"ReturnValue", 0, &varReturnValue, NULL, 0);');
        DynCodeOutParams.Add(Padding+'if (!FAILED(hres))');
        DynCodeOutParams.Add(Padding+'wcout << "ReturnValue " << varReturnValue.intVal << endl;');
        DynCodeOutParams.Add(Padding+'VariantClear(&varReturnValue);');
    end;


    StrCode := StringReplace(StrCode, sTagCppCodeParamsOut, DynCodeOutParams.Text, [rfReplaceAll]);

    StrCode := StringReplace(StrCode, sTagWmiMethodDescr, Descr, [rfReplaceAll]);
    OutPutCode.Text := StrCode;
  finally
    DynCodeInParams.Free;
    DynCodeOutParams.Free;
  end;
end;

function TBorlandCppWmiMethodCodeGenerator.GetWmiClassDescription: string;
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
