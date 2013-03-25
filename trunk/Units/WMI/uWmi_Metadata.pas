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
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
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
  Generics.Collections,
  Variants;


Const
  UrlWmiHelp       = 'http://msdn2.microsoft.com/library/default.asp?url=/library/en-us/wmisdk/wmi/%s.asp';
  wbemtypeString   = 'String';
  wbemtypeSint8    = 'Sint8';
  wbemtypeUint8    = 'Uint8';
  wbemtypeSint16   = 'Sint16';
  wbemtypeUint16   = 'Uint16';  //uintVal
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
  TWMiQualifierMetaData=class
  private
    FName: string;
    FValue: string;
  public
    property Name : string read FName;
    property Value : string read FValue;
  end;
  //WMI and CIM Concepts and Terminology http://msdn.microsoft.com/en-us/windows/hardware/gg463464
  TWMiPropertyMetaData=class
  private
    FName: string;
    FDescription: string;
    FType: string;
    FCimType: Integer;
    FPascalType: string;
    FValidValues: TStrings;
    FValidMapValues: TStrings;
    FIsOrdinal: Boolean;
    FIsArray : Boolean;
    FQualifiers: TList<TWMiQualifierMetaData>;
    FIsReadOnly: Boolean;
  public
    constructor Create; overload;
    Destructor  Destroy; override;
    property IsReadOnly : Boolean read FIsReadOnly;
    property IsArray : Boolean read FIsArray;
    property IsOrdinal : Boolean read FIsOrdinal;
    property Name : string read FName;
    property Description : string read FDescription;
    property &Type : string read FType;
    property CimType : integer read FCimType;
    property PascalType : string read FPascalType;
    property ValidValues :  TStrings  read FValidValues;
    property ValidMapValues : TStrings  read FValidMapValues;
    //Standard Qualifiers  http://msdn.microsoft.com/en-us/library/windows/desktop/aa393650%28v=vs.85%29.aspx
    property Qualifiers : TList<TWMiQualifierMetaData> read FQualifiers;
  end;

  TWMiMethodMetaData=class
  private
    FValidValues: TStrings;
    FValidMapValues: TStrings;
    FIsStatic   : Boolean;
    FIsFunction : Boolean;
    FMethodInParamsDecl: string;
    FMethodOutParamsDecl: string;
    FMethodInParamsPascalDecl: string;
    FMethodOutParamsPascalDecl: string;
    FName: string;
    FDescription: string;
    FType: string;
    FQualifiers: TList<TWMiQualifierMetaData>;
    FOutParameters: TList<TWMiPropertyMetaData>;
    FInParameters: TList<TWMiPropertyMetaData>;
    FImplemented: Boolean;
  public
    constructor Create; overload;
    Destructor  Destroy; override;
    property Name : string read FName;
    property Description : string read FDescription;
    property &Type : string read FType;
    property MethodInParamsPascalDecl : string read FMethodInParamsPascalDecl;
    property MethodOutParamsPascalDecl : string read FMethodOutParamsPascalDecl;
    property MethodInParamsDecl : string read FMethodInParamsDecl;
    property MethodOutParamsDecl : string read FMethodOutParamsDecl;
    property Implemented : Boolean read FImplemented;
    property IsStatic : Boolean read FIsStatic;
    property IsFunction : Boolean read FIsFunction;
    property Qualifiers : TList<TWMiQualifierMetaData> read FQualifiers;
    property InParameters : TList<TWMiPropertyMetaData> read FInParameters;
    property OutParameters : TList<TWMiPropertyMetaData> read FOutParameters;
    property ValidValues : TStrings read FValidValues;
    property ValidMapValues : TStrings read FValidMapValues;
  end;

  TWMiClassMetaData=class
  private
    {$IFDEF USEXML}
    FXmlDoc    : OleVariant;
    FXml       : string;
    {$ENDIF}
    FNameSpace : string;
    FClass     : string;
    FCollectionMethodMetaData  : TList<TWMiMethodMetaData>;
    FCollectionPropertyMetaData: TList<TWMiPropertyMetaData>;
    FCollectionQualifierMetaData: TList<TWMiQualifierMetaData>;
    FCollectionSystemPropertyMetaData: TList<TWMiPropertyMetaData>;
    FDescription: string;
    FURI: string;
    FWmiClassMOF: string;
    FWmiClassXML: string;
    FIsSingleton : Boolean;
    FIsAssociation: boolean;
    FHost, FUser, FPassword : string;
    {$IFDEF USEXML}
    procedure LoadWmiClassDataXML;
    {$ENDIF}
    procedure LoadWmiClassData;
    function GetMethodsCount: Integer;
    function GetPropertiesCount: Integer;
    function GetQualifiersCount: Integer;
    function GetProperty(index: integer): TWMiPropertyMetaData;overload;
    function GetProperty(const Name: string): TWMiPropertyMetaData;overload;
    function GetMethod(index: integer): TWMiMethodMetaData;overload;
    function GetMethod(const Name: string): TWMiMethodMetaData;overload;
    function GetDescriptionEx: string;
    function GetQualifiers(index: integer): TWMiQualifierMetaData;
    function GetSystemPropertiesCount: Integer;
    function GetSystemProperty(index: integer): TWMiPropertyMetaData;overload;
    function GetSystemProperty(const Name: string): TWMiPropertyMetaData;overload;
  public
    {$IFDEF USEXML}
    property Xml : string Read FXml;
    property XmlDoc : OleVariant read FXmlDoc;
    {$ENDIF}
    constructor Create(const ANameSpace,AClass:string); overload;
    constructor Create(const ANameSpace,AClass, Host, User, Password:string); overload;
    Destructor  Destroy; override;
    property URI     : string read FURI;
    property Description     : string read FDescription;
    property DescriptionEx   : string read GetDescriptionEx;

    property PropertiesCount : Integer read GetPropertiesCount;
    property Properties      [index:integer]  : TWMiPropertyMetaData read GetProperty;
    property PropertyByName  [const Name:String]  : TWMiPropertyMetaData read GetProperty;

    property SystemPropertiesCount : Integer read GetSystemPropertiesCount;
    property SystemProperties      [index:integer]  : TWMiPropertyMetaData read GetSystemProperty;
    property SystemPropertyByName  [const Name:String]  : TWMiPropertyMetaData read GetSystemProperty;

    property MethodsCount    : Integer read GetMethodsCount;
    property Methods         [index:integer]      : TWMiMethodMetaData read GetMethod;
    property MethodByName    [const Name:String]  : TWMiMethodMetaData read GetMethod;
    property QualifiersCount : Integer read GetQualifiersCount;
    property Qualifiers      [index:integer]  : TWMiQualifierMetaData read GetQualifiers;

    Property WmiClass     : string read FClass;
    Property WmiNameSpace : string read FNameSpace;
    property WmiClassMOF  : string read FWmiClassMOF;
    property WmiClassXML  : string read FWmiClassXML;

    property IsSingleton  : boolean read FIsSingleton;
    property IsAssociation  : boolean read FIsAssociation;
  end;


  function  VarStrNull(const V:OleVariant):string;
  function  WbemDateToDateTime(const V : OleVariant): OleVariant;
  function  VarDateTimeNull(const V : OleVariant): TDateTime;
  function  FormatWbemValue(const V:OleVariant;CIMType:Integer):string;
  function  CIMTypeStr(const CIMType:Integer):string;
  function  GetDefaultValueWmiType(const WmiType:string):string;
  function  WmiTypeToDelphiType(const WmiType:string):string;

  function  GetWMIObject(const objectName: string): IDispatch;
  function  GetWmiVersion:string;
  procedure GetListWMINameSpaces(const List :TStrings);  cdecl; overload;
  procedure GetListWMINameSpaces(const RootNameSpace:String;const List :TStrings;ReportException:Boolean=True); cdecl; overload;
  procedure GetListWMINameSpaces(const RootNameSpace, Host, User, Password:String;const List :TStrings;ReportException:Boolean=True); cdecl; overload;

  procedure GetListWmiClasses(const NameSpace:String;Const List :TStrings); cdecl; overload;
  procedure GetListWmiClasses(const NameSpace:String;const List :TStrings;const IncludeQualifiers,ExcludeQualifiers: Array of string;ExcludeEvents:Boolean); cdecl; overload;
  procedure GetListWmiClasses(const NameSpace, Host , User, Password:String;const List :TStrings;const IncludeQualifiers,ExcludeQualifiers: Array of string;ExcludeEvents:Boolean); cdecl;overload;

  procedure GetListWmiParentClasses(const NameSpace:string;Const List :TStrings);
  procedure GetListWmiSubClasses(const NameSpace,WmiClass:String;Const List :TStrings);

  procedure GetListWmiDynamicAndStaticClasses(const NameSpace:String;const List :TStrings); cdecl;
  procedure GetListWmiDynamicClasses(const NameSpace:String;const List :TStrings);
  procedure GetListWmiStaticClasses(const NameSpace:String;const List :TStrings);
  procedure GetListWmiClassesWithMethods(const NameSpace:String;const List :TStrings);
  procedure GetListWmiClassProperties(const NameSpace,WmiClass:String;const List :TStrings);
  procedure GetListWmiClassPropertiesTypes(const NameSpace,WmiClass:String;const List :TStringList);
  procedure GetListWmiClassPropertiesValues(const NameSpace,WQL:String;properties:TStrings;List :TList);
  procedure GetListWmiClassMethods(const NameSpace,WmiClass:String;const List :TStrings);
  procedure GetListWmiClassImplementedMethods(const NameSpace,WmiClass:String;Const List :TStrings);

  procedure GetListWmiEvents(const NameSpace, Host , User, Password:String;const List :TStrings);
  procedure GetListIntrinsicWmiEvents(const NameSpace, Host , User, Password:String;const List :TStrings);
  procedure GetListExtrinsicWmiEvents(const NameSpace, Host , User, Password:String;const List :TStrings);

  procedure GetListWmiMethodInParameters(const NameSpace,WmiClass,WmiMethod:String;ParamsList,ParamsTypes,ParamsDescr :TStringList);
  procedure GetListWmiMethodOutParameters(const NameSpace,WmiClass,WmiMethod:String;ParamsList,ParamsTypes,ParamsDescr :TStringList);

  procedure GetWmiClassPath(const WmiNameSpace,WmiClass:string;Const List :TStrings);
 {
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
    }
implementation

uses
 XMLDoc, uDelphiSyntax, StrUtils, uOleVariantEnum;

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

function WbemDateToDateTime(const V : OleVariant): OleVariant;
var
  Dt : OleVariant;
begin
  Result:=varNull;
  if VarIsNull(V) then exit;
  Dt:=CreateOleObject('WbemScripting.SWbemDateTime');
  Dt.Value := V;
  Result:=Dt.GetVarDate;
end;


function VarDateTimeNull(const V : OleVariant): TDateTime;
var
  Dt : OleVariant;
begin
  Result:=0;
  if VarIsNull(V) then exit;
  Dt:=CreateOleObject('WbemScripting.SWbemDateTime');
  Dt.Value := V;
  Result:=Dt.GetVarDate;
end;

function FormatWbemValue(const V:OleVariant;CIMType:Integer):string;
begin
  Result:='';
  if not VarIsNull(V) then
  case CIMType of
    wbemCimtypeSint8,
    wbemCimtypeUint8,
    wbemCimtypeSint16,
    wbemCimtypeUint16,
    wbemCimtypeSint32,
    wbemCimtypeUint32,
    wbemCimtypeSint64,
    wbemCimtypeUint64,
    wbemCimtypeReal32,
    wbemCimtypeReal64,
    wbemCimtypeBoolean,
    wbemCimtypeString,
    wbemCimtypeChar16    : Result:=VarStrNull(V);
    wbemCimtypeDatetime  : Result:=DateTimeToStr(VarDateTimeNull(V));
    wbemCimtypeReference : Result:='Reference';
    wbemCimtypeObject    : Result:='Object'
   else
     Result:=VarStrNull(V);
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


function  WmiClassIsSingleton(const NameSpace, WmiClass:String):Boolean;
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  sValue        : string;
begin
  Result:=False;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Qualifiers_;
  for colItem in GetOleVariantEnum(colItems) do
   begin
    sValue:=colItem.Name;
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

procedure GetListWMINameSpaces(const RootNameSpace, Host, User, Password:String;const List :TStrings;ReportException:Boolean=True); cdecl; overload;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  sValue          : string;
begin
 try
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(Host, RootNameSpace, User, Password);
  colItems        := objWMIService.InstancesOf('__NAMESPACE');
  for colItem in GetOleVariantEnum(colItems) do
  begin
    sValue:=VarStrNull(colItem.Name);
    List.Add(RootNameSpace+'\'+sValue);
    GetListWMINameSpaces(RootNameSpace+'\'+sValue, Host, User, Password ,List, ReportException);
  end;
 except
     if ReportException then
     raise;
 end;
end;

procedure  GetListWMINameSpaces(const RootNameSpace:String;const List :TStrings;ReportException:Boolean=True); cdecl;overload;//recursive function
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  sValue          : string;
begin
 try
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, RootNameSpace, '', '');
  colItems        := objWMIService.InstancesOf('__NAMESPACE');
  for colItem in GetOleVariantEnum(colItems) do
  begin
    sValue:=VarStrNull(colItem.Name);
    List.Add(RootNameSpace+'\'+sValue);
    GetListWMINameSpaces(RootNameSpace+'\'+sValue,List);
  end;
 except
     if ReportException then
     raise;
 end;
end;

procedure  GetListWMINameSpaces(const List :TStrings); cdecl;overload;
begin
  GetListWMINameSpaces('root', List, False);
end;


procedure  GetWmiClassPath(const WmiNameSpace,WmiClass:string;Const List :TStrings);
var
  FSWbemLocator   : OLEVariant;
  FWMIService     : OLEVariant;
  FWbemObjectSet  : OLEVariant;
  FWbemObject     : OLEVariant;
begin
  List.BeginUpdate;
  try
    List.Clear;
    FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    FWMIService   := FSWbemLocator.ConnectServer(wbemLocalhost, WmiNameSpace, '', '');
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM %s',[WmiClass]),'WQL',wbemFlagForwardOnly);
      for FWbemObject in GetOleVariantEnum(FWbemObjectSet) do
        List.Add(FWbemObject.Path_.RelPath);
  finally
    List.EndUpdate;
  end;
end;



procedure  GetListWmiParentClasses(const NameSpace:string;Const List :TStrings);
const
  wbemQueryFlagShallow =1;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OleVariant;
  colItem         : OleVariant;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.SubclassesOf('',wbemQueryFlagShallow);
  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Path_.Class);

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItem        :=Unassigned;
  colItems       :=Unassigned;
end;


procedure  GetListWmiSubClasses(const NameSpace,WmiClass:String;Const List :TStrings);
const
  wbemQueryFlagShallow =1;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OleVariant;
  colItem         : OleVariant;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.SubclassesOf(WmiClass,wbemQueryFlagShallow);

  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Path_.Class);

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItem        :=Unassigned;
  colItems       :=Unassigned;
end;


procedure  GetListWmiClasses(const NameSpace:String;Const List :TStrings);overload;
var
  objSWbemLocator : OleVariant;
  objWMIService   : OleVariant;
  colItems        : OleVariant;
  colItem         : OleVariant;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.SubclassesOf();
  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Path_.Class);

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItem        :=Unassigned;
  colItems       :=Unassigned;
end;



procedure  GetListWmiDynamicAndStaticClasses(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses    := objWMIService.SubclassesOf();
  for objClass in GetOleVariantEnum(colClasses) do
   for objClassQualifier in GetOleVariantEnum(objClass.Qualifiers_)  do
    begin
      if (CompareText(objClassQualifier.Name,'dynamic')=0) or (CompareText(objClassQualifier.Name,'static')=0) Then
      begin
        List.Add(objClass.Path_.Class);
        break;
      end;
    end;

  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;

procedure  GetListWmiClasses(const NameSpace, Host , User, Password:String;const List :TStrings;const IncludeQualifiers,ExcludeQualifiers: Array of string;ExcludeEvents:Boolean);overload;
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
  ClassName         : string;
  i                 : Integer;
  Ok                : Boolean;
  ExtrinsicWmiEvents: TStrings;
  IntrinsicWmiEvents: TStrings;
begin
   ExtrinsicWmiEvents:=TStringList.Create;
   IntrinsicWmiEvents:=TStringList.Create;
   try
     if ExcludeEvents then
     begin
       GetListExtrinsicWmiEvents(NameSpace, Host, User, Password ,ExtrinsicWmiEvents);
       GetListIntrinsicWmiEvents(NameSpace, Host, User, Password ,IntrinsicWmiEvents);
     end;

    objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    objWMIService   := objSWbemLocator.ConnectServer(Host, NameSpace, User, Password);
    colClasses      := objWMIService.SubclassesOf();
    for objClass in GetOleVariantEnum(colClasses) do
    begin
       ClassName:= objClass.Path_.Class;

       if ExcludeEvents and StartsText('_',ClassName) then //ugly hack to fast detection of events classes
        Continue;

       if ExcludeEvents and (ExtrinsicWmiEvents.IndexOf(ClassName)>-1) then  Continue;
       if ExcludeEvents and (IntrinsicWmiEvents.IndexOf(ClassName)>-1) then  Continue;

        Ok          := True;
        for objClassQualifier in GetOleVariantEnum(objClass.Qualifiers_) do
          if ok then
          begin
            //inc(QualifCount);

            for i := Low(ExcludeQualifiers) to High(ExcludeQualifiers) do
            if SameText(objClassQualifier.Name,ExcludeQualifiers[i]) then
             Ok:=False;


            for i := Low(IncludeQualifiers) to High(IncludeQualifiers) do
            if SameText(objClassQualifier.Name,IncludeQualifiers[i]) then
            begin
              List.Add(ClassName);
              Ok:=False;
              Break;
            end;
          end;

        if (Length(IncludeQualifiers)=0) then
          List.Add(ClassName);
    end;

    objSWbemLocator   :=Unassigned;
    objWMIService     :=Unassigned;
    colClasses        :=Unassigned;
    objClass          :=Unassigned;
    objClassQualifier :=Unassigned;
   finally
      ExtrinsicWmiEvents.Free;
      IntrinsicWmiEvents.Free;
   end;
end;

procedure  GetListWmiClasses(const NameSpace:String;const List :TStrings;const IncludeQualifiers,ExcludeQualifiers: Array of string;ExcludeEvents:Boolean);overload;
begin
    GetListWmiClasses(NameSpace, 'localhost', '', '', List, IncludeQualifiers, ExcludeQualifiers, ExcludeEvents)
end;

procedure  GetListWmiDynamicClasses(const NameSpace:String;const List :TStrings);
var
  objSWbemLocator   : OLEVariant;
  objWMIService     : OLEVariant;
  colClasses        : OLEVariant;
  objClass          : OLEVariant;
  objClassQualifier : OLEVariant;
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  for objClass in GetOleVariantEnum(colClasses) do
  begin
     for objClassQualifier in GetOleVariantEnum(objClass.Qualifiers_) do
        if  CompareText(objClassQualifier.Name,'dynamic')=0 Then
          List.Add(objClass.Path_.Class);
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
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  for objClass in GetOleVariantEnum(colClasses) do
   for objClassQualifier in GetOleVariantEnum(objClass.Qualifiers_) do
    if  CompareText(objClassQualifier.Name,'static')=0 Then
     List.Add(objClass.Path_.Class);

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
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colClasses      := objWMIService.SubclassesOf();
  for objClass in GetOleVariantEnum(colClasses) do
   for objClassQualifier in GetOleVariantEnum(objClass.Qualifiers_) do
    if  ((CompareText(objClassQualifier.Name,'dynamic')=0) and (objClass.Methods_.Count>0)) then
      List.Add(objClass.Path_.Class);

  objSWbemLocator   :=Unassigned;
  objWMIService     :=Unassigned;
  colClasses        :=Unassigned;
  objClass          :=Unassigned;
  objClassQualifier :=Unassigned;
end;

procedure  GetListWmiEvents(const NameSpace, Host , User, Password:String;const List :TStrings);
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(Host, NameSpace, User, Password);
  colItems        := objWMIService.ExecQuery('select * from meta_class where __this isa ''__EVENT''');
  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Path_.Class);

  if List.Count>0 then
  List.Delete(0); //Remove '__Event'

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
  colItem        :=Unassigned;
end;

procedure  GetListExtrinsicWmiEvents(const NameSpace, Host , User, Password:String;const List :TStrings);
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
begin
  List.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(Host, NameSpace, User, Password);
  colItems        := objWMIService.ExecQuery('select * from meta_class where __this isa ''__ExtrinsicEvent''');
  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Path_.Class);

  objSWbemLocator:=Unassigned;
  objWMIService  :=Unassigned;
  colItems       :=Unassigned;
  colItem        :=Unassigned;
end;

procedure  GetListIntrinsicWmiEvents(const NameSpace, Host , User, Password:String;const List :TStrings);
var
  objSWbemLocator: OleVariant;
  objWMIService  : OLEVariant;
  colItems       : OLEVariant;
  colItem        : OLEVariant;
  Extrinsic      : TStrings;
begin
  Extrinsic:=TStringList.Create;
  try
    GetListExtrinsicWmiEvents(NameSpace, Host, User, Password, Extrinsic);
    List.Clear;
    objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    objWMIService   := objSWbemLocator.ConnectServer(Host, NameSpace, User, Password);
    colItems        := objWMIService.ExecQuery('select * from meta_class where __this isa ''__Event''');
    for colItem in GetOleVariantEnum(colItems) do
      if Extrinsic.IndexOf(colItem.Path_.Class)=-1 then
       List.Add(colItem.Path_.Class);

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
  Props           : OLEVariant;
  PropItem        : OLEVariant;
begin
  properties.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.ExecQuery(WQL);
    for colItem in GetOleVariantEnum(colItems) do
    begin
     List.Add(TStringList.Create);
     //Str        := '';
     Props      := colItem.Properties_;
      for PropItem in GetOleVariantEnum(Props) do
      begin
        if properties.IndexOf(PropItem.Name)<0 then
        properties.Add(PropItem.Name);
        TStringList(List[List.Count-1]).Add(VarStrNull(PropItem.Value));
      end;
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
begin
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Properties_;
  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Name);

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;


procedure  GetListWmiClassPropertiesTypes(const NameSpace,WmiClass:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  Str           : string;
  i             : Integer;
begin
  Str:='';
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Properties_;

  for colItem in GetOleVariantEnum(colItems) do
    Str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),CIMTypeStr(colItem.cimtype)]);

  List.CommaText:=Str;

  i:=0;
  for colItem in GetOleVariantEnum(colItems) do
  begin
    List.Objects[i]:=TObject(Integer(colItem.cimtype));
    inc(i);
  end;

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

procedure  GetListWmiClassMethods(const NameSpace,WmiClass:String;Const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
begin
  List.Clear;
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Methods_;
  for colItem in GetOleVariantEnum(colItems) do
    List.Add(colItem.Name);

  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;


procedure GetWmiClassMethodsQualifiers(const NameSpace,WmiClass,WmiMethod:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  Qualifiers    : OLEVariant;
  Qualif        : OLEVariant;
  Str           : string;
  Value         : string;
begin
  List.Clear;
  Str:='';
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Methods_;
    for colItem in GetOleVariantEnum(colItems) do
    if VarStrNull(colItem.Name)=WmiMethod then
    begin
       Qualifiers    := colItem.Qualifiers_;
         for Qualif in GetOleVariantEnum(Qualifiers) do
         begin
          Value:=StringReplace(VarStrNull(Qualif.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
          Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
          str:=Str+Format('%s=%s, ',[VarStrNull(Qualif.Name),Value]);
         end;
    end;

  List.CommaText := Str;
  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
  Qualifiers    :=Unassigned;
  Qualif        :=Unassigned;
end;

procedure  GetListWmiClassImplementedMethods(const NameSpace,WmiClass:String;Const List :TStrings);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  Qualifiers    : TStringList;
  i             : Integer;
begin
  Qualifiers:=TStringList.Create;
  try
    List.Clear;
    objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
    colItems      := objWMIService.Methods_;
    for colItem in GetOleVariantEnum(colItems) do
    begin
      GetWmiClassMethodsQualifiers(NameSpace,WmiClass,colItem.Name,Qualifiers);
      for i := 0 to Qualifiers.Count - 1 do
         if CompareText(Qualifiers.Names[i],'Implemented')=0 then
         begin
          List.Add(colItem.Name);
          Break;
         end;
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
begin
  Result:='';
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers    := colItems.Qualifiers_;
  for colItem in GetOleVariantEnum(Qualifiers) do
    if CompareText(VarStrNull(colItem.Name),'description')=0 then
    begin
     Result:=VarStrNull(colItem.Value);
     break;
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
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers    := colItems.Methods_.Item(WmiMethod).Qualifiers_;
  for colItem in GetOleVariantEnum(Qualifiers) do
    if CompareText(VarStrNull(colItem.Name),'description')=0 then
    begin
     Result:= VarStrNull(colItem.Value);
     break;
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
begin
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers      := colItems.Properties_.Item(WmiProperty).Qualifiers_;
  for colItem in GetOleVariantEnum(Qualifiers) do
    if CompareText(VarStrNull(colItem.Name),'description')=0 then
    begin
     Result:= VarStrNull(colItem.Value);
     break;
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
  i               : integer;
begin
  Values.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  for colItem in GetOleVariantEnum(Qualifiers)do
    if CompareText(VarStrNull(colItem.Name),'values')=0 then
    begin
       if not VarIsNull(colItem.Value) and  VarIsArray(colItem.Value) then
        for i := VarArrayLowBound(colItem.Value, 1) to VarArrayHighBound(colItem.Value, 1) do
          Values.Add(VarStrNull(colItem.Value[i]));
     break;
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
  Str           : string;
  Value         : string;
begin
  List.Clear;
  Str:='';
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Qualifiers_;
  for colItem in GetOleVariantEnum(colItems) do
   begin
    Value:=StringReplace(VarStrNull(colItem.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
    Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
    str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),Value]);
   end;

  List.CommaText:= Str;
  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;

procedure  GetWmiClassPropertiesQualifiers(const NameSpace,WmiClass,WmiProperty:String;Const List :TStringList);
var
  objWMIService : OLEVariant;
  colItems      : OLEVariant;
  colItem       : OLEVariant;
  Qualifiers    : OLEVariant;
  Qualif        : OLEVariant;
  Str           : string;
  Value         : string;
begin
  List.Clear;
  Str:='';
  objWMIService := GetWMIObject(Format('winmgmts:\\%s\%s:%s',[wbemLocalhost,NameSpace,WmiClass]));
  colItems      := objWMIService.Properties_;
  for colItem in GetOleVariantEnum(colItems) do
  if VarStrNull(colItem.Name)=WmiProperty then
  begin
   Qualifiers    := colItem.Qualifiers_;
       for Qualif in GetOleVariantEnum(Qualifiers) do
       begin
        Value:=StringReplace(VarStrNull(Qualif.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
        Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
        str:=Str+Format('%s=%s, ',[VarStrNull(Qualif.Name),Value]);
       end;
  end;

  List.CommaText := Str;
  objWMIService :=Unassigned;
  colItems      :=Unassigned;
  colItem       :=Unassigned;
end;


procedure GetWmiMethodValidValues(const NameSpace,WmiClass,WmiMethod:String;ValidValues :TStringList);
var
  objSWbemLocator : OleVariant;
  objWMIService   : OLEVariant;
  colItems        : OLEVariant;
  colItem         : OLEVariant;
  Qualifiers      : OLEVariant;
  i               : Integer;
begin
  ValidValues.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems      := objWMIService.Get(WmiClass, wbemFlagUseAmendedQualifiers);
  Qualifiers    := colItems.Methods_.Item(WmiMethod).Qualifiers_;
  for colItem in GetOleVariantEnum(Qualifiers) do
    if CompareText(VarStrNull(colItem.Name),'Values')=0 then
    begin
     if not VarIsNull(colItem.Value) and  VarIsArray(colItem.Value) then
      for i := VarArrayLowBound(colItem.Value, 1) to VarArrayHighBound(colItem.Value, 1) do
        ValidValues.Add(VarStrNull(colItem.Value[i]));
     break;
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
      for colItem in GetOleVariantEnum(Parameters) do
      begin
        //Str:=Str+Format('%s=%s, ',[VarStrNull(colItem.Name),CIMTypeStr(colItem.CIMType)]);
        ParamsList.Add(VarStrNull(colItem.Name));
        ParamsTypes.AddObject(CIMTypeStr(colItem.CIMType), TObject(Integer(colItem.CIMType)));
        ParamsDescr.Add('');

           for objParamQualifier in GetOleVariantEnum(colItem.Qualifiers_) do
              if  CompareText(objParamQualifier.Name,'Description')=0 Then
              begin
                ParamsDescr[ParamsDescr.Count-1]:= VarStrNull(objParamQualifier.Value);
                break;
              end;
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
  i                 : integer;
begin
  ValidValues.Clear;
  objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService   := objSWbemLocator.ConnectServer(wbemLocalhost, NameSpace, '', '');
  colItems        := objWMIService.Get(WmiClass,wbemFlagUseAmendedQualifiers);
  Parameters      := colItems.Methods_.Item(WmiMethod).OutParameters;
  Parameters      := Parameters.Properties_;
    for colItem in GetOleVariantEnum(Parameters) do
      if  CompareText(colItem.Name,ParamName)=0 Then
       for objParamQualifier in GetOleVariantEnum(colItem.Qualifiers_) do
          if  CompareText(objParamQualifier.Name,'Values')=0 Then
          begin
           if not VarIsNull(objParamQualifier.Value) and  VarIsArray(objParamQualifier.Value) then
            for i := VarArrayLowBound(objParamQualifier.Value, 1) to VarArrayHighBound(objParamQualifier.Value, 1) do
              ValidValues.Add(VarStrNull(objParamQualifier.Value[i]));
           break;
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
      for colItem in GetOleVariantEnum(Parameters) do
       begin
        ParamsList.Add(VarStrNull(colItem.Name));
        ParamsTypes.AddObject(CIMTypeStr(colItem.CIMType),TObject(Integer(colItem.CIMType)));
        ParamsDescr.Add('');
         for objParamQualifier in GetOleVariantEnum(colItem.Qualifiers_) do
            if  CompareText(objParamQualifier.Name,'Description')=0 Then
            begin
              ParamsDescr[ParamsDescr.Count-1]:= VarStrNull(objParamQualifier.Value);
              break;
            end;
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
  FCollectionMethodMetaData    := TList<TWMiMethodMetaData>.Create;
  FCollectionPropertyMetaData  := TList<TWMiPropertyMetaData>.Create;
  FCollectionSystemPropertyMetaData := TList<TWMiPropertyMetaData>.Create;
  FCollectionQualifierMetaData := TList<TWMiQualifierMetaData>.Create;
  FURI               := Format(UrlWmiHelp,[AClass]);
  FHost:='localhost';
  FUser:='';
  FPassword:='';
  LoadWmiClassData;
end;

constructor TWMiClassMetaData.Create(const ANameSpace, AClass, Host, User,
  Password: string);
begin
  inherited Create;
  FNameSpace    := ANameSpace;
  FClass        := AClass;
  {$IFDEF USEXML}
  FXmlDoc       := CreateOleObject('Msxml2.DOMDocument.6.0');
  FXmlDoc.Async := false;
  {$ENDIF}
  FCollectionMethodMetaData    := TList<TWMiMethodMetaData>.Create;
  FCollectionPropertyMetaData  := TList<TWMiPropertyMetaData>.Create;
  FCollectionSystemPropertyMetaData := TList<TWMiPropertyMetaData>.Create;
  FCollectionQualifierMetaData := TList<TWMiQualifierMetaData>.Create;
  FURI               := Format(UrlWmiHelp,[AClass]);
  FHost:=Host;
  FUser:=User;
  FPassword:=Password;
  LoadWmiClassData;
end;

destructor TWMiClassMetaData.Destroy;
var
  i : integer;
begin
  for i:=0 to FCollectionMethodMetaData.Count-1 do
   FCollectionMethodMetaData[i].Free;

  FCollectionMethodMetaData.Free;

  for i:=0 to FCollectionPropertyMetaData.Count-1 do
   FCollectionPropertyMetaData[i].Free;

  FCollectionPropertyMetaData.Free;

  for i:=0 to FCollectionQualifierMetaData.Count-1 do
   FCollectionQualifierMetaData[i].Free;

  FCollectionQualifierMetaData.Free;


  for i:=0 to FCollectionSystemPropertyMetaData.Count-1 do
   FCollectionSystemPropertyMetaData[i].Free;

  FCollectionSystemPropertyMetaData.Free;

  inherited;
end;

function TWMiClassMetaData.GetDescriptionEx: string;
Var
  List : TStringList;
  i    : Integer;
begin
  List:=TStringList.Create;
  try
    List.Add(WmiClass);
    List.Add('');

    if PropertiesCount>0 then
    begin
      List.Add('Properties');
      List.Add('');
      for i := 0 to PropertiesCount-1 do
      begin
         List.Add('  '+Properties[i].Name);
         List.Add('    '+Properties[i].Description);
         List.Add('');
      end;
    end;

    if MethodsCount>0 then
    begin
      List.Add('Methods');
      List.Add('');
      for i := 0 to MethodsCount-1 do
      begin
         List.Add('  '+Methods[i].Name);
         List.Add('    '+Methods[i].Description);
         List.Add('');
      end;
    end;


    Result:=List.Text;
  finally
    List.Free;
  end;
end;

function TWMiClassMetaData.GetMethod(index: integer): TWMiMethodMetaData;
begin
   Result:=FCollectionMethodMetaData[index];
end;

function TWMiClassMetaData.GetMethod(const Name: string): TWMiMethodMetaData;
Var
 i,Index: Integer;
begin
  Index:=-1;
  for i := 0 to FCollectionMethodMetaData.Count-1 do
  if SameText(FCollectionMethodMetaData[i].Name, Name) then
  begin
   Index:=i;
   break;
  end;

  Result:=FCollectionMethodMetaData[index];
end;

function TWMiClassMetaData.GetMethodsCount: Integer;
begin
   Result:=FCollectionMethodMetaData.Count;
end;


function TWMiClassMetaData.GetPropertiesCount: Integer;
begin
   Result:=FCollectionPropertyMetaData.Count;
end;

function TWMiClassMetaData.GetProperty(
  const Name: string): TWMiPropertyMetaData;
Var
 i,Index: Integer;
begin
  Index:=-1;
  for i := 0 to FCollectionPropertyMetaData.Count-1 do
  if SameText(FCollectionPropertyMetaData[i].Name, Name) then
  begin
   Index:=i;
   break;
  end;

  Result:=FCollectionPropertyMetaData[index];
end;

function TWMiClassMetaData.GetProperty(index: integer): TWMiPropertyMetaData;
begin
  Result:=FCollectionPropertyMetaData[index];
end;


function TWMiClassMetaData.GetQualifiers(index: integer): TWMiQualifierMetaData;
begin
   Result:=FCollectionQualifierMetaData[index];
end;

function TWMiClassMetaData.GetQualifiersCount: Integer;
begin
   Result:=FCollectionQualifierMetaData.Count;
end;

function TWMiClassMetaData.GetSystemPropertiesCount: Integer;
begin
   Result:=FCollectionSystemPropertyMetaData.Count;
end;

function TWMiClassMetaData.GetSystemProperty(
  const Name: string): TWMiPropertyMetaData;
Var
 i,Index: Integer;
begin
  Index:=-1;
  for i := 0 to FCollectionSystemPropertyMetaData.Count-1 do
  if SameText(FCollectionSystemPropertyMetaData[i].Name, Name) then
  begin
   Index:=i;
   break;
  end;

  Result:=FCollectionSystemPropertyMetaData[index];
end;


function TWMiClassMetaData.GetSystemProperty(
  index: integer): TWMiPropertyMetaData;
begin
   Result:=FCollectionSystemPropertyMetaData[index];
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
  colNamedValueSet  : OleVariant;
  PropertyMetaData  : TWMiPropertyMetaData;
  ParameterMetaData : TWMiPropertyMetaData;
  MethodMetaData    : TWMiMethodMetaData;
  QualifierMetaData : TWMiQualifierMetaData;
  i                 : integer;
  Value             : string;
begin
  objSWbemLocator  := CreateOleObject('WbemScripting.SWbemLocator');
  objWMIService    := objSWbemLocator.ConnectServer(FHost, FNameSpace, FUser, FPassword);
  objSWbemObjectSet:= objWMIService.Get(FClass, wbemFlagUseAmendedQualifiers);

  //Get MOF definition
  try
   //prevent incomplete class exception
   FWmiClassMOF     :=VarStrNull(objSWbemObjectSet.GetObjectText_);
  except
   FWmiClassMOF:='';
  end;

  //Get XML Wmi class definition
  colNamedValueSet:= CreateOleObject('Wbemscripting.SWbemNamedValueSet');
  colNamedValueSet.Add('LocalOnly', False);
  colNamedValueSet.Add('IncludeQualifiers', True);
  colNamedValueSet.Add('ExcludeSystemProperties', False);
  colNamedValueSet.Add('IncludeClassOrigin', True);
  FWmiClassXML:=VarStrNull(objSWbemObjectSet.GetText_(wbemObjectTextFormatWMIDTD20, 0, colNamedValueSet));
  FWmiClassXML:=xmlDoc.FormatXMLData(FWmiClassXML);

  FIsSingleton:=False;
  FIsAssociation:=False;


  //Get Qualifiers of the class
  Qualifiers    := objSWbemObjectSet.Qualifiers_;
  for colItem in GetOleVariantEnum(Qualifiers) do
   begin
    QualifierMetaData:=TWMiQualifierMetaData.Create;
    FCollectionQualifierMetaData.Add(QualifierMetaData);
    {
    if CompareText(VarStrNull(colItem.Name),'Description')=0 then
    begin
     FDescription:=VarStrNull(colItem.Value);
     colItem:=Unassigned;
     break;
    end;
    colItem:=Unassigned;
    }
    //Value:=StringReplace(VarStrNull(colItem.Value),',',';',[rfReplaceAll,rfIgnoreCase]);
    //Value:=StringReplace(Value,' ','_',[rfReplaceAll,rfIgnoreCase]);
    Value:=VarStrNull(colItem.Value);
    QualifierMetaData.FName :=VarStrNull(colItem.Name);
    QualifierMetaData.FValue:=Value;

    //get description of the class
    if CompareText(VarStrNull(colItem.Name),'Description')=0 then
     FDescription:=VarStrNull(colItem.Value);
   end;

  //get system properties
  colItems := objSWbemObjectSet.SystemProperties_;
  for colItem in GetOleVariantEnum(colItems) do
  begin
    PropertyMetaData:=TWMiPropertyMetaData.Create;
    FCollectionSystemPropertyMetaData.Add(PropertyMetaData);
    PropertyMetaData.FName:=VarStrNull(colItem.Name);
    PropertyMetaData.FType:=CIMTypeStr(colItem.cimtype);
    PropertyMetaData.FCimType:=colItem.cimtype;
    PropertyMetaData.FPascalType :=WmiTypeToDelphiType(CIMTypeStr(colItem.cimtype));
    PropertyMetaData.FIsOrdinal  :=CIMTypeOrdinal(colItem.cimtype);
    PropertyMetaData.FIsArray    :=colItem.IsArray;

    //System properties doesn't have Qualifiers

                {
      Qualifiers      := colItem.Qualifiers_;
      for Qualif in GetOleVariantEnum(Qualifiers) do
      begin
        //Get qualifiers of properties.
        PropertyMetaData.Qualifiers.Add(TWMiQualifierMetaData.Create);
        PropertyMetaData.Qualifiers[PropertyMetaData.Qualifiers.Count-1].FValue:=VarStrNull(Qualif.Value);
        PropertyMetaData.Qualifiers[PropertyMetaData.Qualifiers.Count-1].FName :=VarStrNull(Qualif.Name);

        if SameText(VarStrNull(Qualif.Name),'Singleton') then
         FIsSingleton := True
        else
        if SameText(VarStrNull(Qualif.Name),'Association') then
         FIsAssociation := True
        else
        if SameText(VarStrNull(Qualif.Name),'Description') then
         PropertyMetaData.FDescription := VarStrNull(Qualif.Value)
        else
        if SameText(VarStrNull(Qualif.Name),'values') then
        begin
           if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
            for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
              PropertyMetaData.FValidValues.Add(VarStrNull(Qualif.Value[i]));
        end
        else
        if SameText(VarStrNull(Qualif.Name),'ValueMap') then
        begin
           if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
            for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
              PropertyMetaData.FValidMapValues.Add(VarStrNull(Qualif.Value[i]));
        end;
      end;

    //avoid problems when the length of Valid Map Values list is distinct from the length of the Valid Values list
    if PropertyMetaData.FValidMapValues.Count>0 then
       if PropertyMetaData.FValidMapValues.Count<>PropertyMetaData.FValidValues.Count then
       PropertyMetaData.FValidMapValues.Clear;
       }
  end;

  colItems := objSWbemObjectSet.Properties_;
  for colItem in GetOleVariantEnum(colItems) do
  begin
    PropertyMetaData:=TWMiPropertyMetaData.Create;
    FCollectionPropertyMetaData.Add(PropertyMetaData);
    PropertyMetaData.FName:=VarStrNull(colItem.Name);
    PropertyMetaData.FType:=CIMTypeStr(colItem.cimtype);
    PropertyMetaData.FCimType:=colItem.cimtype;
    PropertyMetaData.FPascalType :=WmiTypeToDelphiType(CIMTypeStr(colItem.cimtype));
    PropertyMetaData.FIsOrdinal  :=CIMTypeOrdinal(colItem.cimtype);
    PropertyMetaData.FIsArray    :=colItem.IsArray;

      Qualifiers      := colItem.Qualifiers_;
      for Qualif in GetOleVariantEnum(Qualifiers) do
      begin
        //Get qualifiers of properties.
        PropertyMetaData.Qualifiers.Add(TWMiQualifierMetaData.Create);
        PropertyMetaData.Qualifiers[PropertyMetaData.Qualifiers.Count-1].FValue:=VarStrNull(Qualif.Value);
        PropertyMetaData.Qualifiers[PropertyMetaData.Qualifiers.Count-1].FName :=VarStrNull(Qualif.Name);


        if CompareText(VarStrNull(Qualif.Name),'write')=0 then
         PropertyMetaData.FIsReadOnly :=False
        else
        if SameText(VarStrNull(Qualif.Name),'Singleton') then
         FIsSingleton := True
        else
        if SameText(VarStrNull(Qualif.Name),'Association') then
         FIsAssociation := True
        else
        if SameText(VarStrNull(Qualif.Name),'Description') then
         PropertyMetaData.FDescription := VarStrNull(Qualif.Value)
        else
        if SameText(VarStrNull(Qualif.Name),'values') then
        begin
           if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
            for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
              PropertyMetaData.FValidValues.Add(VarStrNull(Qualif.Value[i]));
        end
        else
        if SameText(VarStrNull(Qualif.Name),'ValueMap') then
        begin
           if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
            for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
              PropertyMetaData.FValidMapValues.Add(VarStrNull(Qualif.Value[i]));
        end;
      end;

    //avoid problems when the length of Valid Map Values list is distinct from the length of the Valid Values list
    if PropertyMetaData.FValidMapValues.Count>0 then
       if PropertyMetaData.FValidMapValues.Count<>PropertyMetaData.FValidValues.Count then
       PropertyMetaData.FValidMapValues.Clear;
  end;

  colItems      := objSWbemObjectSet.Methods_;
  for colItem in GetOleVariantEnum(colItems) do
  begin
    MethodMetaData:=TWMiMethodMetaData.Create;
    MethodMetaData.FIsStatic:=False;
    MethodMetaData.FImplemented:=False;
    FCollectionMethodMetaData.Add(MethodMetaData);
    MethodMetaData.FName:=colItem.Name;
    MethodMetaData.FType:=wbemtypeSint32;

      Qualifiers      := colItem.Qualifiers_;
      for Qualif in GetOleVariantEnum(Qualifiers) do
      begin

        //Get qualifiers of methods.
        MethodMetaData.Qualifiers.Add(TWMiQualifierMetaData.Create);
        MethodMetaData.Qualifiers[MethodMetaData.Qualifiers.Count-1].FValue:=VarStrNull(Qualif.Value);
        MethodMetaData.Qualifiers[MethodMetaData.Qualifiers.Count-1].FName :=VarStrNull(Qualif.Name);

        if SameText(VarStrNull(Qualif.Name),'Implemented') then
          MethodMetaData.FImplemented:=True
        else
        if SameText(VarStrNull(Qualif.Name),'description') then
          MethodMetaData.FDescription := VarStrNull(Qualif.Value)
        else
        if SameText(VarStrNull(Qualif.Name),'Static') then
          MethodMetaData.FIsStatic:=True
        else
        if SameText(VarStrNull(Qualif.Name),'values') then
        begin
          if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
          for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
            MethodMetaData.FValidValues.Add(VarStrNull(Qualif.Value[i]));
        end
        else
        if SameText(VarStrNull(Qualif.Name),'ValueMap') then
        begin
          if not VarIsNull(Qualif.Value) and  VarIsArray(Qualif.Value) then
          for i := VarArrayLowBound(Qualif.Value, 1) to VarArrayHighBound(Qualif.Value, 1) do
            MethodMetaData.FValidMapValues.Add(VarStrNull(Qualif.Value[i]));
        end;

      end;

       //get data of in params

        Parameters:= colItem.InParameters;
        if not VarIsNull(Parameters) and not VarIsClear(Parameters) then
        begin
          try
            Parameters:= Parameters.Properties_;
            for Param in GetOleVariantEnum(Parameters) do
            begin
              ParameterMetaData:=TWMiPropertyMetaData.Create;
              MethodMetaData.FInParameters.Add(ParameterMetaData);
              ParameterMetaData.FName:=Param.Name;
              ParameterMetaData.FType:=CIMTypeStr(Param.CIMType);
              ParameterMetaData.FCimType:=Param.CIMType;
              ParameterMetaData.FIsArray:=Param.IsArray;

               for Qualif in  GetOleVariantEnum(Param.Qualifiers_) do
                begin
                  ParameterMetaData.Qualifiers.Add(TWMiQualifierMetaData.Create);
                  ParameterMetaData.Qualifiers[ParameterMetaData.Qualifiers.Count-1].FValue:=VarStrNull(Qualif.Value);
                  ParameterMetaData.Qualifiers[ParameterMetaData.Qualifiers.Count-1].FName :=VarStrNull(Qualif.Name);

                  if  SameText(Qualif.Name,'Description') Then
                    ParameterMetaData.FDescription:=VarStrNull(Qualif.Value);
                end;
            end;
          except
          end;
        end;

       //get data of out params
        Parameters:= colItem.OutParameters;
        if not VarIsNull(Parameters) and not VarIsClear(Parameters) then
        begin
          try
            Parameters:= Parameters.Properties_;
            for Param in GetOleVariantEnum(Parameters) do
            begin
              ParameterMetaData:=TWMiPropertyMetaData.Create;
              MethodMetaData.FOutParameters.Add(ParameterMetaData);
              ParameterMetaData.FName:=Param.Name;
              ParameterMetaData.FType:=CIMTypeStr(Param.CIMType);
              ParameterMetaData.FCimType:=Param.CIMType;
              ParameterMetaData.FIsArray:=Param.IsArray;

               for Qualif in GetOleVariantEnum(Param.Qualifiers_) do
                begin
                  ParameterMetaData.Qualifiers.Add(TWMiQualifierMetaData.Create);
                  ParameterMetaData.Qualifiers[ParameterMetaData.Qualifiers.Count-1].FValue:=VarStrNull(Qualif.Value);
                  ParameterMetaData.Qualifiers[ParameterMetaData.Qualifiers.Count-1].FName :=VarStrNull(Qualif.Name);

                  if  CompareText(Qualif.Name,'Description')=0 Then
                   ParameterMetaData.FDescription:=VarStrNull(Qualif.Value);
                end;
            end;
          except

          end;
        end;


        MethodMetaData.FMethodInParamsDecl:='';
        for i := 0 to MethodMetaData.FInParameters.Count-1 do
         if MethodMetaData.InParameters[i].IsArray then
            MethodMetaData.FMethodInParamsDecl:=MethodMetaData.FMethodInParamsDecl+Format('%s : Array of %s -',
            [MethodMetaData.FInParameters[i].Name,MethodMetaData.InParameters[i].&Type])
         else
            MethodMetaData.FMethodInParamsDecl:=MethodMetaData.FMethodInParamsDecl+Format('%s : %s -',
            [MethodMetaData.FInParameters[i].Name,MethodMetaData.InParameters[i].&Type]);

        if MethodMetaData.FMethodInParamsDecl<>'' then
        Delete(MethodMetaData.FMethodInParamsDecl,Length(MethodMetaData.FMethodInParamsDecl),1);

        MethodMetaData.FMethodOutParamsDecl:='';
        for i := 0 to MethodMetaData.OutParameters.Count-1 do
         if MethodMetaData.OutParameters[i].IsArray then
            MethodMetaData.FMethodOutParamsDecl:=MethodMetaData.FMethodOutParamsDecl+Format('%s : Array of %s -',
            [MethodMetaData.OutParameters[i].Name,MethodMetaData.OutParameters[i].&Type])
         else
            MethodMetaData.FMethodOutParamsDecl:=MethodMetaData.FMethodOutParamsDecl+Format('%s : %s -',
            [MethodMetaData.OutParameters[i].Name,MethodMetaData.OutParameters[i].&Type]);

        if MethodMetaData.FMethodOutParamsDecl<>'' then
        Delete(MethodMetaData.FMethodOutParamsDecl,Length(MethodMetaData.FMethodOutParamsDecl),1);


        MethodMetaData.FMethodInParamsPascalDecl:='';
        for i := 0 to MethodMetaData.InParameters.Count-1 do
         if MethodMetaData.InParameters[i].IsArray then
            MethodMetaData.FMethodInParamsPascalDecl:=MethodMetaData.FMethodInParamsPascalDecl+Format('const %s : Array of %s;',
            [EscapeDelphiReservedWord(MethodMetaData.InParameters[i].Name),WmiTypeToDelphiType(MethodMetaData.InParameters[i].&Type)])
         else
            MethodMetaData.FMethodInParamsPascalDecl:=MethodMetaData.FMethodInParamsPascalDecl+Format('const %s : %s;',
            [EscapeDelphiReservedWord(MethodMetaData.InParameters[i].Name),WmiTypeToDelphiType(MethodMetaData.InParameters[i].&Type)]);

        if MethodMetaData.FMethodInParamsPascalDecl<>'' then
        Delete(MethodMetaData.FMethodInParamsPascalDecl,Length(MethodMetaData.FMethodInParamsPascalDecl),1);

        MethodMetaData.FMethodOutParamsPascalDecl:='';
        for i := 0 to MethodMetaData.OutParameters.Count-1 do
        if CompareText(MethodMetaData.OutParameters[i].Name,'ReturnValue')<>0 then
          MethodMetaData.FMethodOutParamsPascalDecl:= MethodMetaData.FMethodOutParamsPascalDecl + Format('var %s : %s;',
          [EscapeDelphiReservedWord(MethodMetaData.OutParameters[i].Name),WmiTypeToDelphiType(MethodMetaData.OutParameters[i].&Type)]);

        if MethodMetaData.FMethodOutParamsPascalDecl<>'' then
         Delete(MethodMetaData.FMethodOutParamsPascalDecl,Length(MethodMetaData.FMethodOutParamsPascalDecl),1);

        MethodMetaData.FIsFunction:=MethodMetaData.OutParameters.Count>0;
        if not MethodMetaData.FIsFunction then  //delete default type value for method because is a method and not a function.
         MethodMetaData.FType:='';

    //avoid problems when the length of Valid Map Values list is distinct from the length of the Valid Values list
    if MethodMetaData.FValidMapValues.Count>0 then
       if MethodMetaData.FValidMapValues.Count<>MethodMetaData.FValidValues.Count then
       MethodMetaData.FValidMapValues.Clear;
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
  FValidValues    := TStringList.Create;
  FValidMapValues := TStringList.Create;
  FQualifiers   :=TList<TWMiQualifierMetaData>.Create;
  FInParameters :=TList<TWMiPropertyMetaData>.Create;
  FOutParameters:=TList<TWMiPropertyMetaData>.Create;
end;

destructor TWMiMethodMetaData.Destroy;
var
 i : Integer;
begin
  FValidValues.Free;
  FValidMapValues.Free;

  for i:=0 to FQualifiers.Count-1 do
   FQualifiers[i].Free;
  FQualifiers.Free;

  for i:=0 to FInParameters.Count-1 do
   FInParameters[i].Free;
  FInParameters.Free;

  for i:=0 to FOutParameters.Count-1 do
   FOutParameters[i].Free;
  FOutParameters.Free;

  inherited;
end;

{ TWMiPropertyMetaData }

constructor TWMiPropertyMetaData.Create;
begin
  FValidValues:=TStringList.Create;
  FValidMapValues:=TStringList.Create;
  FQualifiers:=TList<TWMiQualifierMetaData>.Create;
  FIsReadOnly:=True;
end;

destructor TWMiPropertyMetaData.Destroy;
var
 i : Integer;
begin
  FValidValues.Free;
  FValidMapValues.Free;

  for i:=0 to FQualifiers.Count-1 do
   FQualifiers[i].Free;
  FQualifiers.Free;

  inherited;
end;

initialization
CoInitialize(nil);

finalization
CoUninitialize;

end.
