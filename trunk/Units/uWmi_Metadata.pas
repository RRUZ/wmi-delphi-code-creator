{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmi_Metadata                                                                               }
{ Get Meta info about objects of the WMI  (Windows Management Instrumentation)                     }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uWmi_Metadata.pas.                                                          }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2010 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmi_Metadata;

interface

uses
  Classes,
  SysUtils,
  ActiveX,
  ComObj,
  Variants;


Const
  UrlWmiHelp       = 'http://msdn2.microsoft.com/library/default.asp?url=/library/en-us/wmisdk/wmi/%s.asp';
  wbemtypeString   = 'String';
  wbemtypeSint8    = 'Sint8';
  wbemtypeUint8    = 'Uint8';
  wbemtypeSint16   = 'Sint16';
  wbemtypeUint16   = 'Uint16';
  wbemtypeSint32   = 'Sint32';
  wbemtypeUint32   = 'Uint32';
  wbemtypeSint64   = 'Sint64';
  wbemtypeUint64   = 'Uint64';
  wbemtypeReal32   = 'Real32';
  wbemtypeReal64   = 'Real64';
  wbemtypeBoolean  = 'Boolean';
  wbemtypeDatetime = 'Datetime';
  wbemtypeReference= 'Reference';
  wbemtypeChar16   = 'Char16';
  wbemtypeObject   = 'Object';

  wbemCimtypeSint8 = $00000010;
  wbemCimtypeUint8 = $00000011;
  wbemCimtypeSint16 = $00000002;
  wbemCimtypeUint16 = $00000012;
  wbemCimtypeSint32 = $00000003;
  wbemCimtypeUint32 = $00000013;
  wbemCimtypeSint64 = $00000014;
  wbemCimtypeUint64 = $00000015;
  wbemCimtypeReal32 = $00000004;
  wbemCimtypeReal64 = $00000005;
  wbemCimtypeBoolean = $0000000B;
  wbemCimtypeString = $00000008;
  wbemCimtypeDatetime = $00000065;
  wbemCimtypeReference = $00000066;
  wbemCimtypeChar16 = $00000067;
  wbemCimtypeObject = $0000000D;

  wbemNoErr = $00000000;
  wbemErrFailed = $80041001;
  wbemErrNotFound = $80041002;
  wbemErrAccessDenied = $80041003;
  wbemErrProviderFailure = $80041004;
  wbemErrTypeMismatch = $80041005;
  wbemErrOutOfMemory = $80041006;
  wbemErrInvalidContext = $80041007;
  wbemErrInvalidParameter = $80041008;
  wbemErrNotAvailable = $80041009;
  wbemErrCriticalError = $8004100A;
  wbemErrInvalidStream = $8004100B;
  wbemErrNotSupported = $8004100C;
  wbemErrInvalidSuperclass = $8004100D;
  wbemErrInvalidNamespace = $8004100E;
  wbemErrInvalidObject = $8004100F;
  wbemErrInvalidClass = $80041010;
  wbemErrProviderNotFound = $80041011;
  wbemErrInvalidProviderRegistration = $80041012;
  wbemErrProviderLoadFailure = $80041013;
  wbemErrInitializationFailure = $80041014;
  wbemErrTransportFailure = $80041015;
  wbemErrInvalidOperation = $80041016;
  wbemErrInvalidQuery = $80041017;
  wbemErrInvalidQueryType = $80041018;
  wbemErrAlreadyExists = $80041019;
  wbemErrOverrideNotAllowed = $8004101A;
  wbemErrPropagatedQualifier = $8004101B;
  wbemErrPropagatedProperty = $8004101C;
  wbemErrUnexpected = $8004101D;
  wbemErrIllegalOperation = $8004101E;
  wbemErrCannotBeKey = $8004101F;
  wbemErrIncompleteClass = $80041020;
  wbemErrInvalidSyntax = $80041021;
  wbemErrNondecoratedObject = $80041022;
  wbemErrReadOnly = $80041023;
  wbemErrProviderNotCapable = $80041024;
  wbemErrClassHasChildren = $80041025;
  wbemErrClassHasInstances = $80041026;
  wbemErrQueryNotImplemented = $80041027;
  wbemErrIllegalNull = $80041028;
  wbemErrInvalidQualifierType = $80041029;
  wbemErrInvalidPropertyType = $8004102A;
  wbemErrValueOutOfRange = $8004102B;
  wbemErrCannotBeSingleton = $8004102C;
  wbemErrInvalidCimType = $8004102D;
  wbemErrInvalidMethod = $8004102E;
  wbemErrInvalidMethodParameters = $8004102F;
  wbemErrSystemProperty = $80041030;
  wbemErrInvalidProperty = $80041031;
  wbemErrCallCancelled = $80041032;
  wbemErrShuttingDown = $80041033;
  wbemErrPropagatedMethod = $80041034;
  wbemErrUnsupportedParameter = $80041035;
  wbemErrMissingParameter = $80041036;
  wbemErrInvalidParameterId = $80041037;
  wbemErrNonConsecutiveParameterIds = $80041038;
  wbemErrParameterIdOnRetval = $80041039;
  wbemErrInvalidObjectPath = $8004103A;
  wbemErrOutOfDiskSpace = $8004103B;
  wbemErrBufferTooSmall = $8004103C;
  wbemErrUnsupportedPutExtension = $8004103D;
  wbemErrUnknownObjectType = $8004103E;
  wbemErrUnknownPacketType = $8004103F;
  wbemErrMarshalVersionMismatch = $80041040;
  wbemErrMarshalInvalidSignature = $80041041;
  wbemErrInvalidQualifier = $80041042;
  wbemErrInvalidDuplicateParameter = $80041043;
  wbemErrTooMuchData = $80041044;
  wbemErrServerTooBusy = $80041045;
  wbemErrInvalidFlavor = $80041046;
  wbemErrCircularReference = $80041047;
  wbemErrUnsupportedClassUpdate = $80041048;
  wbemErrCannotChangeKeyInheritance = $80041049;
  wbemErrCannotChangeIndexInheritance = $80041050;
  wbemErrTooManyProperties = $80041051;
  wbemErrUpdateTypeMismatch = $80041052;
  wbemErrUpdateOverrideNotAllowed = $80041053;
  wbemErrUpdatePropagatedMethod = $80041054;
  wbemErrMethodNotImplemented = $80041055;
  wbemErrMethodDisabled = $80041056;
  wbemErrRefresherBusy = $80041057;
  wbemErrUnparsableQuery = $80041058;
  wbemErrNotEventClass = $80041059;
  wbemErrMissingGroupWithin = $8004105A;
  wbemErrMissingAggregationList = $8004105B;
  wbemErrPropertyNotAnObject = $8004105C;
  wbemErrAggregatingByObject = $8004105D;
  wbemErrUninterpretableProviderQuery = $8004105F;
  wbemErrBackupRestoreWinmgmtRunning = $80041060;
  wbemErrQueueOverflow = $80041061;
  wbemErrPrivilegeNotHeld = $80041062;
  wbemErrInvalidOperator = $80041063;
  wbemErrLocalCredentials = $80041064;
  wbemErrCannotBeAbstract = $80041065;
  wbemErrAmendedObject = $80041066;
  wbemErrClientTooSlow = $80041067;
  wbemErrNullSecurityDescriptor = $80041068;
  wbemErrTimeout = $80041069;
  wbemErrInvalidAssociation = $8004106A;
  wbemErrAmbiguousOperation = $8004106B;
  wbemErrQuotaViolation = $8004106C;
  wbemErrTransactionConflict = $8004106D;
  wbemErrForcedRollback = $8004106E;
  wbemErrUnsupportedLocale = $8004106F;
  wbemErrHandleOutOfDate = $80041070;
  wbemErrConnectionFailed = $80041071;
  wbemErrInvalidHandleRequest = $80041072;
  wbemErrPropertyNameTooWide = $80041073;
  wbemErrClassNameTooWide = $80041074;
  wbemErrMethodNameTooWide = $80041075;
  wbemErrQualifierNameTooWide = $80041076;
  wbemErrRerunCommand = $80041077;
  wbemErrDatabaseVerMismatch = $80041078;
  wbemErrVetoPut = $80041079;
  wbemErrVetoDelete = $8004107A;
  wbemErrInvalidLocale = $80041080;
  wbemErrProviderSuspended = $80041081;
  wbemErrSynchronizationRequired = $80041082;
  wbemErrNoSchema = $80041083;
  wbemErrProviderAlreadyRegistered = $80041084;
  wbemErrProviderNotRegistered = $80041085;
  wbemErrFatalTransportError = $80041086;
  wbemErrEncryptedConnectionRequired = $80041087;
  wbemErrRegistrationTooBroad = $80042001;
  wbemErrRegistrationTooPrecise = $80042002;
  wbemErrTimedout = $80043001;
  wbemErrResetToDefault = $80043002;


  wbemFlagForwardOnly          = $00000020;
  wbemFlagUseAmendedQualifiers = $00020000;
  wbemObjectTextFormatWMIDTD20 = 2;
  wbemTargetInstance           = 'TargetInstance';
  wbemLocalhost                = 'localhost';


{.$DEFINE USEXML}

{$IFDEF USEXML}
 Unfinished not activate
{$ENDIF}

type
  TArrayBoolean = Array of Boolean;
  TWMiMethodMetaData=class
  private
    FInParams: TStrings;
    FInParamsTypes: TStrings;
    FInParamsDescr: TStrings;
    FOutParamsTypes: TStrings;
    FOutParamsDescr: TStrings;
    FValidValues: TStrings;
    FValidMapValues: TStrings;
    FOutParams: TStrings;
    FIsStatic   : Boolean;
    FIsFunction : Boolean;
    FMethodInParamsDecl: string;
    FMethodOutParamsDecl: string;
    FMethodInParamsPascalDecl: string;
    FMethodOutParamsPascalDecl: string;
    FName: string;
    FDescription: string;
    FType: string;
    FInParamsIsArray : TArrayBoolean;
    FOutParamsIsArray: TArrayBoolean;
  public
    constructor Create; overload;
    Destructor  Destroy; override;
    property Name : string read FName;
    property Description : string read FDescription;
    property &Type : string read FType;
    property InParamsIsArray: TArrayBoolean read FInParamsIsArray;
    property InParams       : TStrings read FInParams;
    property InParamsTypes  : TStrings read FInParamsTypes;
    property InParamsDescr  : TStrings read FInParamsDescr;
    property OutParamsIsArray: TArrayBoolean read FOutParamsIsArray;
    property OutParams      : TStrings read FOutParams;
    property OutParamsTypes : TStrings read FOutParamsTypes;
    property OutParamsDescr : TStrings read FOutParamsDescr;
    property MethodInParamsPascalDecl : string read FMethodInParamsPascalDecl;
    property MethodOutParamsPascalDecl : string read FMethodOutParamsPascalDecl;
    property MethodInParamsDecl : string read FMethodInParamsDecl;
    property MethodOutParamsDecl : string read FMethodOutParamsDecl;
    property IsStatic : Boolean read FIsStatic;
    property IsFunction : Boolean read FIsFunction;
  end;

  TWMiPropertyMetaData=class
  private
    FName: string;
    FDescription: string;
    FType: string;
    FPascalType: string;
    FValidValues: TStrings;
    FValidMapValues: TStrings;
    FIsOrdinal: Boolean;
    FIsArray : Boolean;
  public
    constructor Create; overload;
    Destructor  Destroy; override;
    property IsArray : Boolean read FIsArray;
    property IsOrdinal : Boolean read FIsOrdinal;
    property Name : string read FName;
    property Description : string read FDescription;
    property &Type : string read FType;
    property PascalType : string read FPascalType;
    property ValidValues :  TStrings  read FValidValues;
    property ValidMapValues : TStrings  read FValidMapValues;
  end;


  TWMiClassMetaData=class
  private
    {$IFDEF USEXML}
    FXmlDoc    : OleVariant;
    FXml       : string;
    {$ENDIF}
    FNameSpace : string;
    FClass     : string;
    FCollectionMethodMetaData  : TList;
    FCollectionPropertyMetaData: TList;
    FDescription: string;
    FURI: string;
    {$IFDEF USEXML}
    procedure LoadWmiClassDataXML;
    {$ENDIF}
    procedure LoadWmiClassData;
    function GetWMiMethodMetaData(index: integer): TWMiMethodMetaData;
    function GetMethodName(index: integer): string;
    function GetMethodDescr(index: integer): string;
    function GetMethodType(index: integer): string;
    function GetMethodsCount: Integer;
    function GetPropertiesCount: Integer;
    function GetPropertyDescription(index: integer): string;
    function GetPropertyName(index: integer): string;
    function GetPropertyPascalType(index: integer): string;
    function GetPropertyType(index: integer): string;
    function GetPropertyMetaData(index: integer): TWMiPropertyMetaData;
    function GetPropertyValidMapValues(index: integer): TStrings;
    function GetPropertyValidValues(index: integer): TStrings;
    function GetMethodValidMapValues(index: integer): TStrings;
    function GetMethodValidValues(index: integer): TStrings;
  public
    {$IFDEF USEXML}
    property Xml : string Read FXml;
    property XmlDoc : OleVariant read FXmlDoc;
    {$ENDIF}
    constructor Create(const ANameSpace,AClass:string); overload;
    Destructor  Destroy; override;
    property URI     : string read FURI;
    property Description     : string read FDescription;
    property PropertiesCount : Integer read GetPropertiesCount;
    property Properties      [index:integer]  : string read GetPropertyName;
    property PropertiesTypes [index:integer]  : string read GetPropertyType;
    property PropertiesPascalTypes [index:integer]  : string read GetPropertyPascalType;
    property PropertiesDescr [index:integer]  : string read GetPropertyDescription;
    property PropertyMetaData[index:integer]  : TWMiPropertyMetaData read GetPropertyMetaData;
    property PropertyValidValues[index:integer]  : TStrings read GetPropertyValidValues;
    property PropertyValidMapValues[index:integer]  : TStrings read GetPropertyValidMapValues;
    property MethodsCount    : Integer read GetMethodsCount;
    property Methods       [index:integer]  : string read GetMethodName;
    property MethodsTypes  [index:integer]  : string read GetMethodType;
    property MethodsDescr  [index:integer]  : string read GetMethodDescr;
    property MethodMetaData[index:integer]  : TWMiMethodMetaData read GetWMiMethodMetaData;
    property MethodValidValues[index:integer]  : TStrings read GetMethodValidValues;
    property MethodValidMapValues[index:integer]  : TStrings read GetMethodValidMapValues;
  end;


  function  VarStrNull(const V:OleVariant):string;
  function  CIMTypeStr(const CIMType:Integer):string;
  function  GetDefaultValueWmiType(const WmiType:string):string;
  function  WmiTypeToDelphiType(const WmiType:string):string;

  function  GetWMIObject(const objectName: string): IDispatch;
  function  GetWmiVersion:string;
  procedure GetListWMINameSpaces(const List :TStrings);  cdecl; overload;
  procedure GetListWMINameSpaces(const RootNameSpace:String;const List :TStrings;ReportException:Boolean=True); cdecl; overload;
  procedure GetListWmiClasses(const NameSpace:String;Const List :TStrings); cdecl; overload;
  procedure GetListWmiClasses(const NameSpace:String;const List :TStrings;const IncludeQualifiers,ExcludeQualifiers: Array of string;ExcludeEvents:Boolean); cdecl; overload;
  procedure GetListWmiDynamicAndStaticClasses(const NameSpace:String;const List :TStrings); cdecl;
  procedure GetListWmiDynamicClasses(const NameSpace:String;const List :TStrings);
  procedure GetListWmiStaticClasses(const NameSpace:String;const List :TStrings);
  procedure GetListWmiClassesWithMethods(const NameSpace:String;const List :TStrings);
  procedure GetListWmiClassProperties(const NameSpace,WmiClass:String;const List :TStrings);
  procedure GetListWmiClassPropertiesTypes(const NameSpace,WmiClass:String;const List :TStringList);
  procedure GetListWmiClassPropertiesValues(const NameSpace,WQL:String;properties:TStrings;List :TList);
  procedure GetListWmiClassMethods(const NameSpace,WmiClass:String;const List :TStrings);
  procedure GetListWmiClassImplementedMethods(const NameSpace,WmiClass:String;Const List :TStrings);

  procedure GetListWmiEvents(const NameSpace:String;const List :TStrings);
  procedure GetListIntrinsicWmiEvents(const NameSpace:String;const List :TStrings);
  procedure GetListExtrinsicWmiEvents(const NameSpace:String;const List :TStrings);

  procedure GetListWmiMethodInParameters(const NameSpace,WmiClass,WmiMethod:String;ParamsList,ParamsTypes,ParamsDescr :TStringList);
  procedure GetListWmiMethodOutParameters(const NameSpace,WmiClass,WmiMethod:String;ParamsList,ParamsTypes,ParamsDescr :TStringList);
  procedure GetWmiClassPath(const WmiNameSpace,WmiClass:string;Const List :TStrings);

  function  GetWmiClassMOF(const NameSpace,  WmiClass:String):string;
  function  GetWmiClassXML(const NameSpace,WmiClass:String;FormatXml:boolean=True):string;
  function  GetWmiClassDescription(const NameSpace,WmiClass:String):string;
  procedure GetWmiClassQualifiers(const NameSpace,WmiClass:String;Const List :TStringList);
  procedure GetWmiClassPropertiesQualifiers(const NameSpace,WmiClass,WmiProperty:String;Const List :TStringList);
  procedure GetWmiClassMethodsQualifiers(const NameSpace,WmiClass,WmiMethod:String;Const List :TStringList);
  function  WmiMethodIsStatic(const NameSpace,WmiClass,WmiMethod:String):Boolean;

  function  GetWmiPropertyDescription(const NameSpace,WmiClass,WmiProperty:String):string;
  //return a list of Valid Values returned by a property.
  procedure GetWmiPropertyValidValues(const NameSpace,WmiClass,WmiProperty:String;Values:TStrings);
  function  GetWmiMethodDescription(const NameSpace,WmiClass,WmiMethod:String):string;

  function  GetWmiMethodInParamsDeclaration(const NameSpace,WmiClass,WmiMethod:String):string;
  function  GetWmiMethodOutParamsDeclaration(const NameSpace,WmiClass,WmiMethod:String):string;
  procedure GetWmiMethodValidValues(const NameSpace,WmiClass,WmiMethod:String;ValidValues :TStringList);
  procedure GetOutParamsValidValues(const NameSpace,WmiClass,WmiMethod, ParamName:String;ValidValues :TStringList);

  function  WmiClassIsSingleton(const NameSpace,  WmiClass:String):Boolean;

implementation

uses
 XMLDoc, uDelphiSyntax, StrUtils;

function VarArrayToStr(const vArray: variant): string;

    function _VarToStr(const V: variant): string;
    var
      Vt: integer;
    begin
      Vt := VarType(V);
        case Vt of
          varSmallint,
          varInteger  : Result := IntToStr(integer(V));
          varSingle,
          varDouble,
          varCurrency : Result := FloatToStr(Double(V));
          varDate     : Result := VarToStr(V);
          varOleStr   : Result := WideString(V);
          varBoolean  : Result := VarToStr(V);
          varVariant  : Result := VarToStr(Variant(V));
          varByte     : Result := char(byte(V));
          varString   : Result := String(V);
          varArray    : Result := VarArrayToStr(Variant(V));
        end;
    end;

var
i : integer;
begin
    Result := '[';
     if (VarType(vArray) and VarArray)=0 then
       Result := _VarToStr(vArray)
    else
    for i := VarArrayLowBound(vArray, 1) to VarArrayHighBound(vArray, 1) do
     if i=VarArrayLowBound(vArray, 1)  then
      Result := Result+_VarToStr(vArray[i])
     else
      Result := Result+'|'+_VarToStr(vArray[i]);

    Result:=Result+']';
end;

function VarStrNull(const V:OleVariant):string; //avoid problems with null strings
begin
  Result:='';
  if not VarIsNull(V) then
  begin
    if VarIsArray(V) then
       Result:=VarArrayToStr(V)
    else
    Result:=VarToStr(V);
  end;
end;

function CIMTypeStr(const CIMType:Integer):string;
begin
   case CIMType of
        wbemCimtypeSint8    : Result:=wbemtypeSint8;
        wbemCimtypeUint8    : Result:=wbemtypeUint8;
        wbemCimtypeSint16   : Result:=wbemtypeSint16;
        wbemCimtypeUint16   : Result:=wbemtypeUint16;
        wbemCimtypeSint32   : Result:=wbemtypeSint32;
        wbemCimtypeUint32   : Result:=wbemtypeUint32;
        wbemCimtypeSint64   : Result:=wbemtypeSint64;
        wbemCimtypeUint64   : Result:=wbemtypeUint64;
        wbemCimtypeReal32   : Result:=wbemtypeReal32;
        wbemCimtypeReal64   : Result:=wbemtypeReal64;
        wbemCimtypeBoolean  : Result:=wbemtypeBoolean;
        wbemCimtypeString   : Result:=wbemtypeString;
        wbemCimtypeDatetime : Result:=wbemtypeDatetime;
        wbemCimtypeReference: Result:=wbemtypeReference;
        wbemCimtypeChar16   : Result:=wbemtypeChar16;
        wbemCimtypeObject   : Result:=wbemtypeObject;
      else
        Result := 'Unknow'
   end;
end;

function CIMTypeOrdinal(const CIMType:Integer):boolean;
begin
Result:=False;
   case CIMType of
        wbemCimtypeSint8,
        wbemCimtypeUint8,
        wbemCimtypeSint16,
        wbemCimtypeUint16,
        wbemCimtypeSint32,
        wbemCimtypeUint32,
        wbemCimtypeSint64,
        wbemCimtypeUint64   : Result:=True;
        //wbemCimtypeBoolean  : Result:=wbemtypeBoolean;
   end;
end;


function GetDefaultValueWmiType(const WmiType:string):string;
begin
   if WmiType=wbemtypeSint8 then Result:='0'
   else
   if WmiType=wbemtypeUint8 then Result:='0'
   else
   if WmiType=wbemtypeSint16 then  Result:='0'
   else
   if WmiType=wbemtypeUint16 then Result:='0'
   else
   if WmiType= wbemtypeSint32   then Result:='0'
   else
   if WmiType=wbemtypeUint32   then Result:='0'
   else
   if WmiType=wbemtypeSint64   then Result:='0'
   else
   if WmiType=wbemtypeUint64   then Result:='0'
   else
   if WmiType=wbemtypeReal32   then Result:='0.0'
   else
   if WmiType=wbemtypeReal64   then Result:='0.0'
   else
   if WmiType=wbemtypeBoolean  then Result:='True'
   else
   if WmiType=wbemtypeString   then Result:=QuotedStr('')
   else
   if WmiType=wbemtypeDatetime then Result:='Now'
   else
   if WmiType=wbemtypeReference then Result:='varNull'
   else
   if WmiType=wbemtypeChar16   then Result:=QuotedStr('')
   else
   if WmiType=wbemtypeObject   then Result:='varNull'
   else
   Result := ''
end;

function WmiTypeToDelphiType(const WmiType:string):string;
begin
   if WmiType=wbemtypeSint8 then Result:='ShortInt'
   else
   if WmiType=wbemtypeUint8 then Result:='Byte'
   else
   if WmiType=wbemtypeSint16 then  Result:='SmallInt'
   else
   if WmiType=wbemtypeUint16 then Result:='Word'
   else
   if WmiType= wbemtypeSint32   then Result:='Integer'
   else
   if WmiType=wbemtypeUint32   then Result:='Cardinal'//LongInt
   else
   if WmiType=wbemtypeSint64   then Result:='Int64'//???
   else
   if WmiType=wbemtypeUint64   then Result:='Int64'
   else
   if WmiType=wbemtypeReal32   then Result:='Double'
   else
   if WmiType=wbemtypeReal64   then Result:='Double' //  Extended
   else
   if WmiType=wbemtypeBoolean  then Result:='Boolean'
   else
   if WmiType=wbemtypeString   then Result:='String'
   else
   if WmiType=wbemtypeDatetime then Result:='TDateTime'
   else
   if WmiType=wbemtypeReference then Result:='OleVariant'//???   IDispatch
   else
   if WmiType=wbemtypeChar16   then Result:='WideString' ///?????
   else
   if WmiType=wbemtypeObject   then Result:='OleVariant' //????  variant
   else
   Result := 'Unknow'
end;

function  WmiClassIsSingleton(const NameSpace, WmiClass:String):Boolean;
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  sValue        : string;
begin
  Result:=False;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Qualifiers_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;

  while oEnum.Next(1, colItem, iValue) = 0 do
   begin
    sValue:=colItem.Name;
    colItem:=Unassigned;
      if CompareText(sValue,'Singleton')=0 then
      begin
        Result:=True;
        Break;
      end;
   end;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

function GetWMIObject(const objectName: string): IDispatch;
var
  chEaten: Integer;
  BindCtx: IBindCtx;
  Moniker: IMoniker;
begin
  OleCheck(CreateBindCtx(0, bindCtx));
  OleCheck(MkParseDisplayName(BindCtx, StringToOleStr(objectName), chEaten, Moniker));
  OleCheck(Moniker.BindToObject(BindCtx, nil, IDispatch, Result));
end;

function  GetWmiVersion:string;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OleVariant;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, 'root\cimv2', '', '');
  colItems        := objWMIService.Get('Win32_WMISetting=@');
  Result:=VarStrNull(colItems.BuildVersion);
  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
end;

procedure  GetListWMINameSpaces(const List :TStrings); cdecl;
begin
  GetListWMINameSpaces('root', List, False);
end;


procedure  GetListWMINameSpaces(const RootNameSpace:String;const List :TStrings;ReportException:Boolean=True); cdecl;//recursive function
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
  sValue          : string;
begin
 try
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, RootNameSpace, '', '');
  colItems        := objWMIService.InstancesOf('__NAMESPACE');
  oEnum           := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    sValue:=VarStrNull(colItem.Name);
    colItem:=Unassigned;
    List.Add(RootNameSpace+'\'+sValue);
    GetListWMINameSpaces(RootNameSpace+'\'+sValue,List);
  end;
 except
     if ReportException then
     raise;
 end;
end;

procedure  GetWmiClassPath(const WmiNameSpace,WmiClass:string;Const List :TStrings);
var
  FSWbemLocator   : OLEVariant;
  FWMIService     : OLEVariant;
  FWbemObjectSet  : OLEVariant;
  FWbemObject     : OLEVariant;
  iValue          : Cardinal;
  oEnum           : IEnumvariant;
  //WmiPath         : string;
  //Index           : integer;
begin
  List.BeginUpdate;
  try
    List.Clear;
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService   := FSWbemLocator.ConnectServer(wbemLocalhost, WmiNameSpace, '', '');
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM %s',[WmiClass]),'WQL',wbemFlagForwardOnly);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
      while oEnum.Next(1, FWbemObject, iValue) = 0 do
      begin
        {
        WmiPath:=FWbemObject.Path_;
        Index:=pos(':',WmiPath);
        if Index>0 then
         WmiPath:=Copy(WmiPath,Index+1,length(WmiPath));
        List.Add(WmiPath);
        }
        List.Add(FWbemObject.Path_.RelPath);

          {
          \\HARANZ\root\CIMV2:Win32_LogicalDisk.DeviceID="C:"
          \\HARANZ\root\CIMV2:Win32_LogicalDisk.DeviceID="D:"
          \\HARANZ\root\CIMV2:Win32_LogicalDisk.DeviceID="Z:"
          }
        
        FWbemObject:=Unassigned;
      end;
  finally
    List.EndUpdate;
  end;
end;

procedure  GetListWmiClasses(const NameSpace:String;Const List :TStrings);
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OleVariant;
  colItem         : OleVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.SubclassesOf();
  oEnum           := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    List.Add(colItem.Path_.Class);
    colItem        :=Unassigned;
  end;

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItem        :=Unassigned;
  colItems       :=Unassigned;
end;

{
procedure  GetListWmiClasses(const NameSpace:String;const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s',[wbemLocalhost,NameSpace]));
  colItems      := objWMIService.ExecQuery('select * from meta_class');
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
    List.Add(colItem.Path_.Class);
end;
}

procedure  GetListWmiDynamicAndStaticClasses(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses    := objWMIService.SubclassesOf();
  oEnum         := IUnknown(colClasses._NewEnum) as IEnumVariant;
  while oEnum.Next(1, objClass, iValue) = 0 do
  begin
      oEnumQualif :=  IUnknown(objClass.Qualifiers_._NewEnum) as IEnumVariant;
       while oEnumQualif.Next(1, objClassQualifier, iValue) = 0 do
        begin
          if (CompareText(objClassQualifier.Name,'dynamic')=0) or (CompareText(objClassQualifier.Name,'static')=0) Then
          begin
            List.Add(objClass.Path_.Class);
            break;
          end;
          objClassQualifier:=Unassigned;
        end;
      objClass:=Unassigned;
  end;

  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;



procedure  GetListWmiClasses(const NameSpace:String;const List :TStrings;const IncludeQualifiers,ExcludeQualifiers: Array of string;ExcludeEvents:Boolean);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
  ClassName         : string;
  i                 : Integer;
  Ok                : Boolean;
  QualifCount       : Integer;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  oEnum           := IUnknown(colClasses._NewEnum) as IEnumVariant;
  while (oEnum.Next(1, objClass, iValue) = 0)  do
  begin
     ClassName:= objClass.Path_.Class;
     if ExcludeEvents and StartsText('_',ClassName) then     //ugly hack to detect events classes
     begin
      objClass:=Unassigned;
      Continue;
     end;

      QualifCount := 0;
      Ok          := True;
      oEnumQualif := IUnknown(objClass.Qualifiers_._NewEnum) as IEnumVariant;
      while (oEnumQualif.Next(1, objClassQualifier, iValue) = 0) and Ok do
      begin
        inc(QualifCount);

        for i := Low(ExcludeQualifiers) to High(ExcludeQualifiers) do
        if CompareText(objClassQualifier.Name,ExcludeQualifiers[i])=0 then
        begin
         objClassQualifier:=Unassigned;
         Ok:=False;
        end;


        for i := Low(IncludeQualifiers) to High(IncludeQualifiers) do
        if CompareText(objClassQualifier.Name,IncludeQualifiers[i])=0 then
        begin
          List.Add(ClassName);
          Ok:=False;
          Break;
        end;

        objClassQualifier:=Unassigned;
      end;

      if (Length(IncludeQualifiers)=0) then
        List.Add(ClassName);

      objClass:=Unassigned;
  end;

  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;

procedure  GetListWmiDynamicClasses(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  oEnum           := IUnknown(colClasses._NewEnum) as IEnumVariant;
  while oEnum.Next(1, objClass, iValue) = 0 do
  begin
    oEnumQualif :=  IUnknown(objClass.Qualifiers_._NewEnum) as IEnumVariant;
     while oEnumQualif.Next(1, objClassQualifier, iValue) = 0 do
      begin
        if  CompareText(objClassQualifier.Name,'dynamic')=0 Then
          List.Add(objClass.Path_.Class);
        objClassQualifier:=Unassigned;
      end;
    objClass:=Unassigned;
  end;


  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;


procedure  GetListWmiStaticClasses(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  oEnum           := IUnknown(colClasses._NewEnum) as IEnumVariant;
  while oEnum.Next(1, objClass, iValue) = 0 do
  begin
      oEnumQualif :=  IUnknown(objClass.Qualifiers_._NewEnum) as IEnumVariant;
       while oEnumQualif.Next(1, objClassQualifier, iValue) = 0 do
        begin
          if  CompareText(objClassQualifier.Name,'static')=0 Then
               List.Add(objClass.Path_.Class);
          objClassQualifier:=Unassigned;
        end;
      objClass:=Unassigned;
  end;

  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;


{
procedure  GetListWmiClassesWithMethods(const NameSpace:String;Const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s',[wbemLocalhost,NameSpace]));
  colItems      := objWMIService.SubclassesOf();
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
   if colItem.Methods_.Count>0 then
    List.Add(colItem.Path_.Class);
end;
}
//only dynamic classes with methods
procedure  GetListWmiClassesWithMethods(const NameSpace:String;Const List :TStrings);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  oEnum           := IUnknown(colClasses._NewEnum) as IEnumVariant;
  while oEnum.Next(1, objClass, iValue) = 0 do
  begin
      oEnumQualif :=  IUnknown(objClass.Qualifiers_._NewEnum) as IEnumVariant;
       while oEnumQualif.Next(1, objClassQualifier, iValue) = 0 do
        begin
          if  ((CompareText(objClassQualifier.Name,'dynamic')=0) and (objClass.Methods_.Count>0)) then
            List.Add(objClass.Path_.Class);
          objClassQualifier:=Unassigned;
        end;
     objClass:=Unassigned;
  end;

  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;

procedure  GetListWmiEvents(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
  oEnum          : IEnumvariant;
  iValue         : LongWord;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.ExecQuery('select * from meta_class where __this isa ''__EVENT''');
  oEnum           := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    List.Add(colItem.Path_.Class);
    colItem:=Unassigned;
  end;


  if List.Count>0 then
  List.Delete(0); //Remove '__Event'

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
  colItem        :=Unassigned;
end;

procedure  GetListExtrinsicWmiEvents(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
  oEnum          : IEnumvariant;
  iValue         : LongWord;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.ExecQuery('select * from meta_class where __this isa ''__ExtrinsicEvent''');
  oEnum           := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    List.Add(colItem.Path_.Class);
    colItem:=Unassigned;
  end;

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
  colItem        :=Unassigned;
end;

procedure  GetListIntrinsicWmiEvents(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
  oEnum          : IEnumvariant;
  iValue         : LongWord;
  Extrinsic      : TStrings;
begin
  Extrinsic:=TStringList.Create;
  try
    GetListExtrinsicWmiEvents(NameSpace,Extrinsic);
    List.Clear;
    objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
    colItems        := objWMIService.ExecQuery('select * from meta_class where __this isa ''__Event''');
    oEnum           := IUnknown(colItems._NewEnum) as IEnumVariant;
    while oEnum.Next(1, colItem, iValue) = 0 do
    begin
      if Extrinsic.IndexOf(colItem.Path_.Class)=-1 then
       List.Add(colItem.Path_.Class);
      colItem:=Unassigned;
    end;

    objSWbemLocator:=Unassigned;
    objWMIService  :=Unassigned;
    colItems       :=Unassigned;
    colItem        :=Unassigned;
  finally
    Extrinsic.Free;
  end;
end;


procedure GetListWmiClassPropertiesValues(const NameSpace,WQL:String;properties:TStrings;List :TList);
var
  objSWbemLocator : OleVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;

  Props           : OLEVariant;
  PropItem        : OLEVariant;
  oEnumProp       : IEnumvariant;
  //Str             : string;
  //Value           : string;
begin
  properties.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.ExecQuery(WQL);
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
   while oEnum.Next(1, colItem, iValue) = 0 do
    begin
       List.Add(TStringList.Create);
       //Str        := '';
       Props      := colItem.Properties_;
       oEnumProp  := IUnknown(Props._NewEnum) as IEnumVariant;
          {
        while oEnumProp.Next(1, PropItem, iValue) = 0 do
        begin

            Value:=StringReplace(VarStrNull(PropItem.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
            Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
            str:=Str+Format('%s=%s, ',[VarStrNull(PropItem.Name),Value]);

            PropItem:=Unassigned;
        end;
        TStringList(List[List.Count-1]).CommaText := Str;
         }

        while oEnumProp.Next(1, PropItem, iValue) = 0 do
        begin
          if properties.IndexOf(PropItem.Name)<0 then
          properties.Add(PropItem.Name);

          TStringList(List[List.Count-1]).Add(VarStrNull(PropItem.Value));
          PropItem:=Unassigned;
        end;
       colItem:=Unassigned;
       Props  :=Unassigned;
    end;


  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Props           :=Unassigned;
  PropItem        :=Unassigned;
end;

procedure  GetListWmiClassProperties(const NameSpace,WmiClass:String;Const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Properties_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
   begin
    List.Add(colItem.Name);
    colItem:=Unassigned;
   end;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;


procedure  GetListWmiClassPropertiesTypes(const NameSpace,WmiClass:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  Str           : string;
begin
  Str:='';
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Properties_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    Str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),CIMTypeStr(colItem.cimtype)]);
    colItem:=Unassigned;
  end;
  List.CommaText:=Str;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

procedure  GetListWmiClassMethods(const NameSpace,WmiClass:String;Const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
begin
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Methods_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    List.Add(colItem.Name);
    colItem:=Unassigned;
  end;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

procedure  GetListWmiClassImplementedMethods(const NameSpace,WmiClass:String;Const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  Qualifiers    : TStringList;
  i             : Integer;
begin
  Qualifiers:=TStringList.Create;
  try
    List.Clear;
    objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
    colItems      := objWMIService.Methods_;
    oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
    while oEnum.Next(1, colItem, iValue) = 0 do
    begin      
      GetWmiClassMethodsQualifiers(NameSpace,WmiClass,colItem.Name,Qualifiers);
      for i := 0 to Qualifiers.Count - 1 do
         if CompareText(Qualifiers.Names[i],'Implemented')=0 then
         begin
          List.Add(colItem.Name);
          Break;
         end;
      colItem:=Unassigned;
    end;


    objWMIService :=Unassigned;
    colItems      :=Unassigned;
    colItem       :=Unassigned;
  finally
    Qualifiers.Free;
  end;
end;


function  GetWmiClassMOF(const NameSpace,WmiClass:String):string;
var
  objSWbemLocator: OLEVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Result          := VarStrNull(colItems.GetObjectText_);

  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
  objSWbemLocator:=Unassigned;
end;

function  GetWmiClassXML(const NameSpace,WmiClass:String;FormatXml:boolean=True):string;
var
  objSWbemLocator : OLEVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colNamedValueSet: OLEVariant;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);

  colNamedValueSet:= CreateOleObject('Wbemscripting.SWbemNamedValueSet');
  colNamedValueSet.Add('LocalOnly', False);
  colNamedValueSet.Add('IncludeQualifiers', True);
  colNamedValueSet.Add('ExcludeSystemProperties', False);
  colNamedValueSet.Add('IncludeClassOrigin', True);

  Result:=VarStrNull(colItems.GetText_(wbemObjectTextFormatWMIDTD20, 0, colNamedValueSet));
  if FormatXml then
    Result:=xmlDoc.FormatXMLData(Result);

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colNamedValueSet:=Unassigned;
end;

function  GetWmiClassDescription(const NameSpace,WmiClass:String):string;
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
  Qualifiers     : OLEVariant;
  oEnum          : IEnumvariant;
  iValue         : LongWord;
begin
  Result:='';
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers    := colItems.Qualifiers_;
  oEnum         := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
   begin
    if CompareText(VarStrNull(colItem.Name),'description')=0 then
    begin
     Result:=VarStrNull(colItem.Value);
     break;
    end;
    colItem:=Unassigned;
   end;

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
  colItem        :=Unassigned;
  Qualifiers     :=Unassigned;
end;



function  GetWmiMethodDescription(const NameSpace,WmiClass,WmiMethod:String):string;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  Qualifiers      : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers    := colItems.Methods_.Item(WmiMethod).Qualifiers_;
  oEnum         := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    if CompareText(VarStrNull(colItem.Name),'description')=0 then
    begin
     Result:= VarStrNull(colItem.Value);
     break;
    end;
    colItem:=Unassigned;
  end;

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Qualifiers      :=Unassigned;
end;




function  GetWmiPropertyDescription(const NameSpace,WmiClass,WmiProperty:String):string;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  Qualifiers      : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers      := colItems.Properties_.Item(WmiProperty).Qualifiers_;
  oEnum           := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    if CompareText(VarStrNull(colItem.Name),'description')=0 then
    begin
     Result:= VarStrNull(colItem.Value);
     colItem:=Unassigned;
     break;
    end;
    colItem:=Unassigned;
  end;

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Qualifiers      :=Unassigned;
end;


procedure   GetWmiPropertyValidValues(const NameSpace,WmiClass,WmiProperty:String;Values:TStrings);
var
  objSWbemLocator : OleVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  Qualifiers      : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
  i               : integer;
begin
  Values.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers      := colItems.Properties_.Item(WmiProperty).Qualifiers_;
  oEnum           := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    if CompareText(VarStrNull(colItem.Name),'values')=0 then
    begin
       if not VarIsNull(colItem.Value) and  VarIsArray(colItem.Value) then
        for i := VarArrayLowBound(colItem.Value, 1) to VarArrayHighBound(colItem.Value, 1) do
          Values.Add(VarStrNull(colItem.Value[i]));
     colItem:=Unassigned;
     break;
    end;
    colItem:=Unassigned;
  end;

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Qualifiers      :=Unassigned;
end;

procedure  GetWmiClassQualifiers(const NameSpace,WmiClass:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  Str           : string;
  Value         : string;
begin
  List.Clear;
  Str:='';
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Qualifiers_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;

  while oEnum.Next(1, colItem, iValue) = 0 do
   begin
    Value:=StringReplace(VarStrNull(colItem.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
    Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
    str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),Value]);
    colItem:=Unassigned;
   end;

  List.CommaText := Str;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

procedure  GetWmiClassPropertiesQualifiers(const NameSpace,WmiClass,WmiProperty:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  oEnumQualif   : IEnumvariant;
  iValue        : LongWord;
  Qualifiers    : OLEVariant;
  Qualif        : OLEVariant;
  Str           : string;
  Value         : string;
begin
  List.Clear;
  Str:='';
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Properties_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  if VarStrNull(colItem.Name)=WmiProperty then
  begin
   Qualifiers    := colItem.Qualifiers_;
     oEnumQualif := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
       while oEnumQualif.Next(1, Qualif, iValue) = 0 do
       begin
        Value:=StringReplace(VarStrNull(Qualif.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
        Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
        str:=Str+Format('%s=%s, ',[VarStrNull(Qualif.Name),Value]);
        Qualif:=Unassigned;
       end;
    colItem:=Unassigned;
  end
  else
   colItem:=Unassigned;

  List.CommaText := Str;
  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

procedure GetWmiClassMethodsQualifiers(const NameSpace,WmiClass,WmiMethod:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  oEnum         : IEnumvariant;
  oEnumQualif   : IEnumvariant;
  iValue        : LongWord;
  Qualifiers    : OLEVariant;
  Qualif        : OLEVariant;
  Str           : string;
  Value         : string;
begin
  List.Clear;
  Str:='';
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Methods_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
    while oEnum.Next(1, colItem, iValue) = 0 do
    if VarStrNull(colItem.Name)=WmiMethod then
    begin
       Qualifiers    := colItem.Qualifiers_;
       oEnumQualif   := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
         while oEnumQualif.Next(1, Qualif, iValue) = 0 do
         begin
          Value:=StringReplace(VarStrNull(Qualif.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
          Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
          str:=Str+Format('%s=%s, ',[VarStrNull(Qualif.Name),Value]);
          Qualif:=Unassigned;
         end;
      colItem:=Unassigned;
    end
    else
    colItem:=Unassigned;

    List.CommaText := Str;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
  Qualifiers    :=Unassigned;
  Qualif        :=Unassigned;
end;

procedure GetWmiMethodValidValues(const NameSpace,WmiClass,WmiMethod:String;ValidValues :TStringList);
var
  objSWbemLocator : OleVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  Qualifiers      : OLEVariant;
  oEnum           : IEnumvariant;
  iValue          : LongWord;
  i               : Integer;
begin
  ValidValues.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers    := colItems.Methods_.Item(WmiMethod).Qualifiers_;
  oEnum         := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    if CompareText(VarStrNull(colItem.Name),'Values')=0 then
    begin
     if not VarIsNull(colItem.Value) and  VarIsArray(colItem.Value) then
      for i := VarArrayLowBound(colItem.Value, 1) to VarArrayHighBound(colItem.Value, 1) do
        ValidValues.Add(VarStrNull(colItem.Value[i]));
     break;
    end;
    colItem:=Unassigned;
  end;

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Qualifiers      :=Unassigned;
end;


function  WmiMethodIsStatic(const NameSpace,WmiClass,WmiMethod:String):Boolean;
var
  List : TStringList;
  i    : integer;
begin
 Result:=False;
  List:=TStringList.Create;
  try
    GetWmiClassMethodsQualifiers(NameSpace,WmiClass,WmiMethod,List);
     for i:=0 to List.Count-1 do
      if List.IndexOfName('Static')>=0 then
       Result:=CompareText(List.ValueFromIndex[List.IndexOfName('Static')],'True')=0;
  finally
    List.Free;
  end;
end;


procedure  GetListWmiMethodInParameters(const NameSpace,WmiClass,WmiMethod:String;ParamsList,ParamsTypes,ParamsDescr :TStringList);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colItems          : OLEVariant;
  colItem           : OLEVariant;
  Parameters        : OLEVariant;
  objParamQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
  //Str               : string;
begin
  ParamsList.Clear;
  ParamsTypes.Clear;
  ParamsDescr.Clear;
  //Str:='';
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass,wbemFlagUseAmendedQualifiers);
  Parameters      := colItems.Methods_.Item(WmiMethod).inParameters;
  //if Parameters.Count>0 then
  //if (not VarIsNull(Parameters)) and (not VarIsEmpty(Parameters)) then
  try
    Parameters:= Parameters.Properties_;
    oEnum     := IUnknown(Parameters._NewEnum) as IEnumVariant;
      while oEnum.Next(1, colItem, iValue) = 0 do
      begin
        //Str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),CIMTypeStr(colItem.CIMType)]);
        ParamsList.Add(VarStrNull(colItem.Name));
        ParamsTypes.Add(CIMTypeStr(colItem.CIMType));
        ParamsDescr.Add('');

          oEnumQualif :=  IUnknown(colItem.Qualifiers_._NewEnum) as IEnumVariant;
           while oEnumQualif.Next(1, objParamQualifier, iValue) = 0 do
            begin
              //Writeln(VarStrNull(objParamQualifier.Name));
              if  CompareText(objParamQualifier.Name,'Description')=0 Then
              begin
                ParamsDescr[ParamsDescr.Count-1]:= VarStrNull(objParamQualifier.Value);
                break;
              end;
              objParamQualifier:=Unassigned;
            end;
        colItem:=Unassigned;
      end;
  except
    //Str:='';
  end;
  //ParamsList.CommaText := Str;

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Parameters      :=Unassigned;
end;



procedure  GetOutParamsValidValues(const NameSpace,WmiClass,WmiMethod, ParamName:String;ValidValues :TStringList);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colItems          : OLEVariant;
  colItem           : OLEVariant;
  Parameters        : OLEVariant;
  objParamQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
  i                 : integer;
begin
  ValidValues.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass,wbemFlagUseAmendedQualifiers);
  Parameters      := colItems.Methods_.Item(WmiMethod).OutParameters;
  try
    Parameters:= Parameters.Properties_;
    oEnum     := IUnknown(Parameters._NewEnum) as IEnumVariant;
      while oEnum.Next(1, colItem, iValue) = 0 do
      begin
        if  CompareText(colItem.Name,ParamName)=0 Then
        begin
          oEnumQualif :=  IUnknown(colItem.Qualifiers_._NewEnum) as IEnumVariant;
           while oEnumQualif.Next(1, objParamQualifier, iValue) = 0 do
            begin
              //Writeln(objParamQualifier.Name);

              if  CompareText(objParamQualifier.Name,'Values')=0 Then
              begin
               if not VarIsNull(objParamQualifier.Value) and  VarIsArray(objParamQualifier.Value) then
                for i := VarArrayLowBound(objParamQualifier.Value, 1) to VarArrayHighBound(objParamQualifier.Value, 1) do
                  ValidValues.Add(VarStrNull(objParamQualifier.Value[i]));

               break;
              end;
              objParamQualifier:=Unassigned;
            end;

        end;
        colItem:=Unassigned;
      end;
  except
  end;
  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Parameters      :=Unassigned;
end;


procedure GetListWmiMethodOutParameters(const NameSpace,WmiClass,WmiMethod:String;ParamsList,ParamsTypes,ParamsDescr :TStringList);
var
  objSWbemLocator   : OleVariant;
  objWMIService     : OLEVariant;
  colItems          : OLEVariant;
  colItem           : OLEVariant;
  Parameters        : OLEVariant;
  objParamQualifier : OLEVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  iValue            : LongWord;
begin
  ParamsList.Clear;
  ParamsTypes.Clear;
  ParamsDescr.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass,wbemFlagUseAmendedQualifiers);
  Parameters    := colItems.Methods_.Item(WmiMethod).OutParameters;
  try
    Parameters:= Parameters.Properties_;
    oEnum     := IUnknown(Parameters._NewEnum) as IEnumVariant;
      while oEnum.Next(1, colItem, iValue) = 0 do
       begin
        //Str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),CIMTypeStr(colItem.CIMType)]);
        ParamsList.Add(VarStrNull(colItem.Name));
        ParamsTypes.Add(CIMTypeStr(colItem.CIMType));
        ParamsDescr.Add('');

          oEnumQualif :=  IUnknown(colItem.Qualifiers_._NewEnum) as IEnumVariant;
           while oEnumQualif.Next(1, objParamQualifier, iValue) = 0 do
            begin
              if  CompareText(objParamQualifier.Name,'Description')=0 Then
              begin
                ParamsDescr[ParamsDescr.Count-1]:= VarStrNull(objParamQualifier.Value);
                break;
              end;
              objParamQualifier:=Unassigned;
            end;
        colItem:=Unassigned;
       end;
  except
  end;

  objSWbemLocator :=Unassigned;
  objWMIService   :=Unassigned;
  colItems        :=Unassigned;
  colItem         :=Unassigned;
  Parameters      :=Unassigned;
end;


function  GetWmiMethodInParamsDeclaration(const NameSpace,WmiClass,WmiMethod:String):string;
var
 Params : TStringList;
 Types  : TStringList;
 Descr  : TStringList;
 i      : integer;
begin
   Result:='';
   Params:=TStringList.Create;
   Types :=TStringList.Create;
   Descr :=TStringList.Create;
   try
     GetListWmiMethodInParameters(NameSpace,WmiClass,WmiMethod,Params,Types,Descr);
      for i := 0 to Params.Count-1 do
      begin
        Result:= Result + Format('%s : %s',[Params[i],Types[i]]);

        if i<Params.Count-1 then
        Result:=Result+' - ';
      end;
   finally
     Params.Free;
     Types.Free;
     Descr.Free;
   end;
end;

function  GetWmiMethodOutParamsDeclaration(const NameSpace,WmiClass,WmiMethod:String):string;
var
 Params : TStringList;
 Types  : TStringList;
 Descr  : TStringList;
 i      : integer;
begin
   Result:='';
   Params:=TStringList.Create;
   Types :=TStringList.Create;
   Descr :=TStringList.Create;
   try
     GetListWmiMethodOutParameters(NameSpace,WmiClass,WmiMethod,Params,Types,Descr);
      for i := 0 to Params.Count-1 do
      begin
        Result:= Result + Format('%s : %s',[Params[i],Types[i]]);

        if i<Params.Count-1 then
        Result:=Result+' - ';
      end;
   finally
     Params.Free;
     Types.Free;
     Descr.Free;
   end;
end;



{ TWMiClassMetaData }

constructor TWMiClassMetaData.Create(const ANameSpace, AClass: string);
begin
  inherited Create;
  FNameSpace    := ANameSpace;
  FClass        := AClass;
  {$IFDEF USEXML}
  FXmlDoc       := CreateOleObject('Msxml2.DOMDocument.6.0');
  FXmlDoc.Async := false;
  {$ENDIF}
  FCollectionMethodMetaData    := TList.Create;
  FCollectionPropertyMetaData  := TList.Create;
  FURI               := Format(UrlWmiHelp,[AClass]);
  LoadWmiClassData;
end;

destructor TWMiClassMetaData.Destroy;
var
  i : integer;
begin
  for i:=0 to FCollectionMethodMetaData.Count-1 do
   TWMiMethodMetaData(FCollectionMethodMetaData[i]).Free;
  FCollectionMethodMetaData.Free;

  for i:=0 to FCollectionPropertyMetaData.Count-1 do
   TWMiPropertyMetaData(FCollectionPropertyMetaData[i]).Free;

  FCollectionPropertyMetaData.Free;
  inherited;
end;

function TWMiClassMetaData.GetMethodDescr(index: integer): string;
begin
   Result:=TWMiMethodMetaData(FCollectionMethodMetaData[index]).FDescription;
end;

function TWMiClassMetaData.GetMethodName(index: integer): string;
begin
   Result:=TWMiMethodMetaData(FCollectionMethodMetaData[index]).FName;
end;

function TWMiClassMetaData.GetMethodsCount: Integer;
begin
   Result:=FCollectionMethodMetaData.Count;
end;

function TWMiClassMetaData.GetMethodType(index: integer): string;
begin
   Result:=TWMiMethodMetaData(FCollectionMethodMetaData[index]).FType;
end;

function TWMiClassMetaData.GetMethodValidMapValues(index: integer): TStrings;
begin
   Result:=TWMiMethodMetaData(FCollectionMethodMetaData[index]).FValidMapValues;
end;

function TWMiClassMetaData.GetMethodValidValues(index: integer): TStrings;
begin
   Result:=TWMiMethodMetaData(FCollectionMethodMetaData[index]).FValidValues;
end;

function TWMiClassMetaData.GetPropertiesCount: Integer;
begin
   Result:=FCollectionPropertyMetaData.Count;
end;

function TWMiClassMetaData.GetPropertyDescription(index: integer): string;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]).FDescription;
end;

function TWMiClassMetaData.GetPropertyMetaData(index: integer): TWMiPropertyMetaData;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]);
end;

function TWMiClassMetaData.GetPropertyName(index: integer): string;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]).FName;
end;

function TWMiClassMetaData.GetPropertyPascalType(index: integer): string;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]).FPascalType;
end;

function TWMiClassMetaData.GetPropertyType(index: integer): string;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]).FType;
end;

function TWMiClassMetaData.GetPropertyValidMapValues(index: integer): TStrings;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]).FValidMapValues;
end;

function TWMiClassMetaData.GetPropertyValidValues(index: integer): TStrings;
begin
   Result:=TWMiPropertyMetaData(FCollectionPropertyMetaData[index]).FValidValues;
end;

function TWMiClassMetaData.GetWMiMethodMetaData(index: integer): TWMiMethodMetaData;
begin
   Result:=TWMiMethodMetaData(FCollectionMethodMetaData[index]);
end;

procedure TWMiClassMetaData.LoadWmiClassData;
var
  objSWbemLocator   : OleVariant;
  objSWbemObjectSet : OleVariant;
  objWMIService     : OleVariant;
  colItems          : OleVariant;
  colItem           : OleVariant;
  Param             : OleVariant;
  Qualif            : OleVariant;
  Qualifiers        : OleVariant;
  Parameters        : OleVariant;
  oEnum             : IEnumvariant;
  oEnumQualif       : IEnumvariant;
  oEnumParam        : IEnumvariant;
  iValue            : LongWord;
  PropertyMetaData  : TWMiPropertyMetaData;
  MethodMetaData    : TWMiMethodMetaData;
  i                 : integer;
begin
  objSWbemLocator  := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService    := objSWbemLocator.ConnectServer(wbemLocalhost, FNameSpace, '', '');
  objSWbemObjectSet:= objWMIService.Get(FClass, wbemFlagUseAmendedQualifiers);


  Qualifiers    := objSWbemObjectSet.Qualifiers_;
  oEnum         := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
   begin
    if CompareText(VarStrNull(colItem.Name),'Description')=0 then
    begin
     FDescription:=VarStrNull(colItem.Value);
     colItem:=Unassigned;
     break;
    end;
    colItem:=Unassigned;
   end;

  colItems         := objSWbemObjectSet.Properties_;
  oEnum            := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    PropertyMetaData:=TWMiPropertyMetaData.Create;
    FCollectionPropertyMetaData.Add(PropertyMetaData);
    PropertyMetaData.FName:=VarStrNull(colItem.Name);
    PropertyMetaData.FType:=CIMTypeStr(colItem.cimtype);
    PropertyMetaData.FPascalType :=WmiTypeToDelphiType(CIMTypeStr(colItem.cimtype));
    PropertyMetaData.FIsOrdinal  :=CIMTypeOrdinal(colItem.cimtype);
    PropertyMetaData.FIsArray    :=colItem.IsArray;


      Qualifiers      := colItem.Qualifiers_;
      oEnumQualif     := IUnknown(Qualifiers._NewEnum) as IEnumVariant;
      while oEnumQualif.Next(1, Qualif, iValue) = 0 do
      begin
        if CompareText(VarStrNull(Qualif.Name),'Description')=0 then
         PropertyMetaData.FDescription := VarStrNull(Qualif.Value)
        else
        if CompareText(VarStrNull(Qualif.Name),'values')=0 then
        begin
           if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
            for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
              PropertyMetaData.FValidValues.Add(VarStrNull(Qualif.Value[i]));
        end
        else
        if CompareText(VarStrNull(Qualif.Name),'ValueMap')=0 then
        begin
           if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
            for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
              PropertyMetaData.FValidMapValues.Add(VarStrNull(Qualif.Value[i]));
        end;
        Qualif:=Unassigned;
      end;

    //avoid problems when the length of Valid Map Values list is distinct from the length of the Valid Values list
    if PropertyMetaData.FValidMapValues.Count>0 then
       if PropertyMetaData.FValidMapValues.Count<>PropertyMetaData.FValidValues.Count then
       PropertyMetaData.FValidMapValues.Clear;

    colItem:=Unassigned;
  end;

  colItems      := objSWbemObjectSet.Methods_;
  oEnum         := IUnknown(colItems._NewEnum) as IEnumVariant;
  while oEnum.Next(1, colItem, iValue) = 0 do
  begin
    MethodMetaData:=TWMiMethodMetaData.Create;
    MethodMetaData.FIsStatic:=False;
    FCollectionMethodMetaData.Add(MethodMetaData);
    MethodMetaData.FName:=colItem.Name;
    MethodMetaData.FType:=wbemtypeSint32;

      Qualifiers      := colItem.Qualifiers_;
      oEnumQualif     := IUnknown(Qualifiers._NewEnum) as IEnumVariant;

      while oEnumQualif.Next(1, Qualif, iValue) = 0 do
      begin
        if CompareText(VarStrNull(Qualif.Name),'description')=0 then
          MethodMetaData.FDescription := VarStrNull(Qualif.Value)
        else
        if CompareText(VarStrNull(Qualif.Name),'Static')=0 then
          MethodMetaData.FIsStatic:=True
        else
        if CompareText(VarStrNull(Qualif.Name),'values')=0 then
        begin
          if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
          for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
            MethodMetaData.FValidValues.Add(VarStrNull(Qualif.Value[i]));
        end
        else
        if CompareText(VarStrNull(Qualif.Name),'ValueMap')=0 then
        begin
          if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
          for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
            MethodMetaData.FValidMapValues.Add(VarStrNull(Qualif.Value[i]));
        end;

        Qualif:=Unassigned;
      end;

        Parameters:= colItem.InParameters;
        if not VarIsNull(Parameters) then
        begin
          try
            Parameters:= Parameters.Properties_;
            oEnumParam:= IUnknown(Parameters._NewEnum) as IEnumVariant;
            while oEnumParam.Next(1, Param, iValue) = 0 do
            begin
              MethodMetaData.InParams.Add(VarStrNull(Param.Name));
              MethodMetaData.InParamsTypes.Add(CIMTypeStr(Param.CIMType));
              MethodMetaData.InParamsDescr.Add('');
              MethodMetaData.InParamsIsArray[MethodMetaData.InParams.Count-1]:=Param.IsArray;

              oEnumQualif :=  IUnknown(Param.Qualifiers_._NewEnum) as IEnumVariant;
               while oEnumQualif.Next(1, Qualif, iValue) = 0 do
                begin
                   if  CompareText(Qualif.Name,'Description')=0 Then
                    MethodMetaData.InParamsDescr[MethodMetaData.InParamsDescr.Count-1]:= VarStrNull(Qualif.Value);
                  Qualif:=Unassigned;
                end;
              Param:=Unassigned;
            end;
          except
          end;
        end;


        Parameters:= colItem.OutParameters;
        if not VarIsNull(Parameters) then
        begin
          try
            Parameters:= Parameters.Properties_;
            oEnumParam:= IUnknown(Parameters._NewEnum) as IEnumVariant;
            while oEnumParam.Next(1, Param, iValue) = 0 do
            begin
              MethodMetaData.OutParams.Add(VarStrNull(Param.Name));
              MethodMetaData.OutParamsTypes.Add(CIMTypeStr(Param.CIMType));
              MethodMetaData.OutParamsDescr.Add('');
              MethodMetaData.OutParamsIsArray[MethodMetaData.OutParams.Count-1]:=Param.IsArray;

              oEnumQualif :=  IUnknown(Param.Qualifiers_._NewEnum) as IEnumVariant;
               while oEnumQualif.Next(1, Qualif, iValue) = 0 do
                begin
                   if  CompareText(Qualif.Name,'Description')=0 Then
                    MethodMetaData.OutParamsDescr[MethodMetaData.OutParamsDescr.Count-1]:= VarStrNull(Qualif.Value);
                  Qualif:=Unassigned;
                end;
              Param:=Unassigned;
            end;
          except

          end;
        end;


        MethodMetaData.FMethodInParamsDecl:='';
        for i := 0 to MethodMetaData.InParams.Count-1 do
         if MethodMetaData.InParamsIsArray[i] then
            MethodMetaData.FMethodInParamsDecl:=MethodMetaData.FMethodInParamsDecl+Format('%s : Array of %s -',
            [MethodMetaData.InParams[i],MethodMetaData.InParamsTypes[i]])
         else
            MethodMetaData.FMethodInParamsDecl:=MethodMetaData.FMethodInParamsDecl+Format('%s : %s -',
            [MethodMetaData.InParams[i],MethodMetaData.InParamsTypes[i]]);

        if MethodMetaData.FMethodInParamsDecl<>'' then
        Delete(MethodMetaData.FMethodInParamsDecl,Length(MethodMetaData.FMethodInParamsDecl),1);

        MethodMetaData.FMethodOutParamsDecl:='';
        for i := 0 to MethodMetaData.OutParams.Count-1 do
         if MethodMetaData.OutParamsIsArray[i] then
            MethodMetaData.FMethodOutParamsDecl:=MethodMetaData.FMethodOutParamsDecl+Format('%s : Array of %s -',
            [MethodMetaData.OutParams[i],MethodMetaData.OutParamsTypes[i]])
         else
            MethodMetaData.FMethodOutParamsDecl:=MethodMetaData.FMethodOutParamsDecl+Format('%s : %s -',
            [MethodMetaData.OutParams[i],MethodMetaData.OutParamsTypes[i]]);

        if MethodMetaData.FMethodOutParamsDecl<>'' then
        Delete(MethodMetaData.FMethodOutParamsDecl,Length(MethodMetaData.FMethodOutParamsDecl),1);



        MethodMetaData.FMethodInParamsPascalDecl:='';
        for i := 0 to MethodMetaData.InParams.Count-1 do
         if MethodMetaData.InParamsIsArray[i] then
            MethodMetaData.FMethodInParamsPascalDecl:=MethodMetaData.FMethodInParamsPascalDecl+Format('const %s : Array of %s;',
            [EscapeDelphiReservedWord(MethodMetaData.InParams[i]),WmiTypeToDelphiType(MethodMetaData.InParamsTypes[i])])
         else
            MethodMetaData.FMethodInParamsPascalDecl:=MethodMetaData.FMethodInParamsPascalDecl+Format('const %s : %s;',
            [EscapeDelphiReservedWord(MethodMetaData.InParams[i]),WmiTypeToDelphiType(MethodMetaData.InParamsTypes[i])]);

        if MethodMetaData.FMethodInParamsPascalDecl<>'' then
        Delete(MethodMetaData.FMethodInParamsPascalDecl,Length(MethodMetaData.FMethodInParamsPascalDecl),1);

        MethodMetaData.FMethodOutParamsPascalDecl:='';
        for i := 0 to MethodMetaData.OutParams.Count-1 do
        if CompareText(MethodMetaData.OutParams[i],'ReturnValue')<>0 then
          MethodMetaData.FMethodOutParamsPascalDecl:= MethodMetaData.FMethodOutParamsPascalDecl + Format('var %s : %s;',[EscapeDelphiReservedWord(MethodMetaData.OutParams[i]),WmiTypeToDelphiType(MethodMetaData.OutParamsTypes[i])]);

        if MethodMetaData.FMethodOutParamsPascalDecl<>'' then
        Delete(MethodMetaData.FMethodOutParamsPascalDecl,Length(MethodMetaData.FMethodOutParamsPascalDecl),1);



        MethodMetaData.FIsFunction:=MethodMetaData.OutParams.Count>0;
        if not MethodMetaData.FIsFunction then  //delete default type value for method because is a method and not a function.
         MethodMetaData.FType:='';

    //avoid problems when the length of Valid Map Values list is distinct from the length of the Valid Values list
    if MethodMetaData.FValidMapValues.Count>0 then
       if MethodMetaData.FValidMapValues.Count<>MethodMetaData.FValidValues.Count then
       MethodMetaData.FValidMapValues.Clear;

    colItem:=Unassigned;
  end;


end;

{$IFDEF USEXML}
procedure TWMiClassMetaData.LoadWmiClassDataXML;
Var
  i,j,k  : integer;
  Node   : OleVariant;
  Nodes  : OleVariant;
  NodesC : OleVariant;
  NodesQ : OleVariant;
  lNodes : Integer;

  IdxIn  : Integer;
  IdxOut : Integer;
  MethodMetaData : TWMiMethodMetaData;
begin
  FXml:=GetWmiClassXML(FNameSpace,FClass,False);
  FXMLDoc.LoadXML(FXml);
  FXMLDoc.setProperty('SelectionLanguage','XPath');
  if (FXMLDoc.parseError.errorCode <> 0) then
   raise Exception.CreateFmt('Error in WMI Xml Data %s',[FXmlDoc.parseError]);

  //Load Class Qualifiers;
  Nodes := FXMLDoc.selectNodes('/CLASS/QUALIFIER');
  lNodes:= Nodes.Length;
  for i := 1 to lNodes do
  begin
    if CompareText(FXMLDoc.selectSingleNode(Format('/CLASS/QUALIFIER[%d]/@NAME',[i])).text,'Description')=0 then
     FDescription:=FXMLDoc.selectSingleNode(Format('/CLASS/QUALIFIER[%d]/VALUE',[i])).text;
  end;


  //Load Properties;
  Nodes := FXMLDoc.selectNodes('/CLASS/PROPERTY');
  lNodes:= Nodes.Length;
  for i := 1 to lNodes do
  begin
    if CompareText(FXMLDoc.selectSingleNode(Format('/CLASS/PROPERTY[%d]/@CLASSORIGIN',[i])).text,'___SYSTEM')<>0 then
    begin
      Node:=FXMLDoc.selectSingleNode(Format('/CLASS/PROPERTY[%d]/@NAME',[i]));
      FProperties.Add(Node.text);
      Node:=FXMLDoc.selectSingleNode(Format('/CLASS/PROPERTY[%d]/@TYPE',[i]));
      FPropertiesTypes.Add(Node.text);//capitalize

      FPropertiesDescr.Add('');
         for j := 1 to FXMLDoc.selectNodes(Format('/CLASS/PROPERTY[%d]/QUALIFIER',[i])).Length do
         begin
           Node:=FXMLDoc.selectSingleNode(Format('/CLASS/PROPERTY[%d]/QUALIFIER[%d]/@NAME',[i,j]));
           if CompareText(Node.text,'Description')=0 then
           begin
              FPropertiesDescr[FPropertiesDescr.Count-1]:=FXMLDoc.selectSingleNode(Format('/CLASS/PROPERTY[%d]/QUALIFIER[%d]/VALUE',[i,j])).text;
              break;
           end;
         end;
    end;
  end;


  //load Methods
  Nodes := FXMLDoc.selectNodes('/CLASS/METHOD');
  lNodes:= Nodes.Length;
  for i := 1 to lNodes do
  begin
      Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/@NAME',[i]));
      FMethods.Add(Node.text);
      Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/@TYPE',[i]));
      if not VarIsNull(Node) then
       FMethodsTypes.Add(Node.text)//capitalize
      else
       FMethodsTypes.Add('');

      FMethodsDescr.Add('');
         for j := 1 to FXMLDoc.selectNodes(Format('/CLASS/METHOD[%d]/QUALIFIER',[i])).Length do
         begin
           Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/QUALIFIER[%d]/@NAME',[i,j]));
           if CompareText(Node.text,'Description')=0 then
           begin
              FMethodsDescr[FMethodsDescr.Count-1]:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/QUALIFIER[%d]/VALUE',[i,j])).text;
              break;
           end;
         end;


    MethodMetaData:=TWMiMethodMetaData.Create;
    FMethodMetaData.Add(MethodMetaData);

    //load methods parameters
    NodesC := FXMLDoc.selectNodes(Format('/CLASS/METHOD[%d]/PARAMETER',[i]));
    if not VarIsNull(NodesC) then
    for j := 1 to  NodesC.Length do
    begin
      NodesQ:=FXMLDoc.selectNodes(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER',[i,j]));

        IdxIn :=-1;
        IdxOut:=-1;
        //iterates over the qualifiers to find if a in or a out parameter
        for k := 1 to NodesQ.Length do
        begin
          Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER[%d]/@NAME',[i,j,k]));
          if CompareText(Node.text,'In')=0 then
          begin
           IdxIn:=k;
           break;
          end
          else
          if CompareText(Node.text,'Out')=0 then
          begin
           IdxOut:=k;
           break;
          end
        end;

      //if is a in parameter
      if IdxIn>0 then
      begin
        MethodMetaData.MethodsInParams.Add('');
        MethodMetaData.MethodsInParamsTypes.Add('');
        MethodMetaData.MethodsInParamsDescr.Add('');

        Node:=FXMLDoc.selectSingleNode(Format('CLASS/METHOD[%d]/PARAMETER[%d]/@NAME',[i,j]));
        MethodMetaData.MethodsInParams[MethodMetaData.MethodsInParams.Count-1]:=Node.text;

        Node:=FXMLDoc.selectSingleNode(Format('CLASS/METHOD[%d]/PARAMETER[%d]/@TYPE',[i,j]));
        MethodMetaData.MethodsInParamsTypes[MethodMetaData.MethodsInParamsTypes.Count-1]:=Node.text;

        NodesQ:=FXMLDoc.selectNodes(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER',[i,j]));
        for k := 1 to NodesQ.Length do
        begin
          Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER[%d]/@NAME',[i,j,k]));
          if CompareText(Node.text,'Description')=0 then
          begin
           Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER[%d]/VALUE',[i,j,k]));
           MethodMetaData.MethodsInParamsDescr[MethodMetaData.MethodsInParamsDescr.Count-1]:=Node.text;
           break;
          end
        end;
      end
      else
      //if is a out parameter
      if IdxOut>0 then
      begin
        MethodMetaData.MethodsOutParams.Add('');
        MethodMetaData.MethodsOutParamsTypes.Add('');
        MethodMetaData.MethodsOutParamsDescr.Add('');

        Node:=FXMLDoc.selectSingleNode(Format('CLASS/METHOD[%d]/PARAMETER[%d]/@NAME',[i,j]));
        MethodMetaData.MethodsOutParams[MethodMetaData.MethodsOutParams.Count-1]:=Node.text;

        Node:=FXMLDoc.selectSingleNode(Format('CLASS/METHOD[%d]/PARAMETER[%d]/@TYPE',[i,j]));
        MethodMetaData.MethodsOutParamsTypes[MethodMetaData.MethodsOutParamsTypes.Count-1]:=Node.text;

        NodesQ:=FXMLDoc.selectNodes(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER',[i,j]));
        for k := 1 to NodesQ.Length do
        begin
          Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER[%d]/@NAME',[i,j,k]));
          if CompareText(Node.text,'Description')=0 then
          begin
           Node:=FXMLDoc.selectSingleNode(Format('/CLASS/METHOD[%d]/PARAMETER[%d]/QUALIFIER[%d]/VALUE',[i,j,k]));
           MethodMetaData.MethodsOutParamsDescr[MethodMetaData.MethodsOutParamsDescr.Count-1]:=Node.text;
           break;
          end
        end;
      end;
    end;

    //load objects types

    //load arrays types and params

    //load Result param
  end;



end;
{$ENDIF}

{ TWMiMethodMetaData }

constructor TWMiMethodMetaData.Create;
begin
  inherited Create;
  FInParams       := TStringList.Create;
  FInParamsTypes  := TStringList.Create;
  FInParamsDescr  := TStringList.Create;
  FOutParams      := TStringList.Create;
  FOutParamsTypes := TStringList.Create;
  FOutParamsDescr := TStringList.Create;
  FValidValues    := TStringList.Create;
  FValidMapValues := TStringList.Create;
  SetLength(FInParamsIsArray,256);
  SetLength(FOutParamsIsArray,256);
end;

destructor TWMiMethodMetaData.Destroy;
begin
  FInParams.Free;
  FInParamsTypes.Free;
  FInParamsDescr.Free;
  FOutParamsTypes.Free;
  FOutParamsDescr.Free;
  FOutParams.Free;
  FValidValues.Free;
  FValidMapValues.Free;
  SetLength(FInParamsIsArray,0);
  SetLength(FOutParamsIsArray,0);
  inherited;
end;

{ TWMiPropertyMetaData }

constructor TWMiPropertyMetaData.Create;
begin
  FValidValues:=TStringList.Create;
  FValidMapValues:=TStringList.Create;
end;

destructor TWMiPropertyMetaData.Destroy;
begin
  FValidValues.Free;
  FValidMapValues.Free;
  inherited;
end;

initialization
CoInitialize(nil);

finalization
CoUninitialize;

end.
