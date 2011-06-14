unit WbemScripting_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 28-11-2010 22:09:59 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\system32\wbem\wbemdisp.TLB (1)
// LIBID: {565783C6-CB41-11D1-8B02-00600806D9B6}
// LCID: 0
// Helpfile: 
// HelpString: Microsoft WMI Scripting V1.2 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
// Errors:
//   Hint: Member 'Class' of 'ISWbemObjectPath' changed to 'Class_'
//   Hint: Member 'Object' of 'ISWbemRefreshableItem' changed to 'Object_'
//   Error creating palette bitmap of (TSWbemLocator) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
//   Error creating palette bitmap of (TSWbemNamedValueSet) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
//   Error creating palette bitmap of (TSWbemObjectPath) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
//   Error creating palette bitmap of (TSWbemLastError) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
//   Error creating palette bitmap of (TSWbemSink) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
//   Error creating palette bitmap of (TSWbemDateTime) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
//   Error creating palette bitmap of (TSWbemRefresher) : Server C:\WINDOWS\system32\wbem\wbemdisp.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Variants, OleServer;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  WbemScriptingMajorVersion = 1;
  WbemScriptingMinorVersion = 2;

  LIBID_WbemScripting: TGUID = '{565783C6-CB41-11D1-8B02-00600806D9B6}';

  IID_ISWbemServices: TGUID = '{76A6415C-CB41-11D1-8B02-00600806D9B6}';
  IID_ISWbemObject: TGUID = '{76A6415A-CB41-11D1-8B02-00600806D9B6}';
  IID_ISWbemObjectPath: TGUID = '{5791BC27-CE9C-11D1-97BF-0000F81E849C}';
  IID_ISWbemNamedValueSet: TGUID = '{CF2376EA-CE8C-11D1-8B05-00600806D9B6}';
  IID_ISWbemNamedValue: TGUID = '{76A64164-CB41-11D1-8B02-00600806D9B6}';
  IID_ISWbemSecurity: TGUID = '{B54D66E6-2287-11D2-8B33-00600806D9B6}';
  IID_ISWbemPrivilegeSet: TGUID = '{26EE67BF-5804-11D2-8B4A-00600806D9B6}';
  IID_ISWbemPrivilege: TGUID = '{26EE67BD-5804-11D2-8B4A-00600806D9B6}';
  IID_ISWbemObjectSet: TGUID = '{76A6415F-CB41-11D1-8B02-00600806D9B6}';
  IID_ISWbemQualifierSet: TGUID = '{9B16ED16-D3DF-11D1-8B08-00600806D9B6}';
  IID_ISWbemQualifier: TGUID = '{79B05932-D3B7-11D1-8B06-00600806D9B6}';
  IID_ISWbemPropertySet: TGUID = '{DEA0A7B2-D4BA-11D1-8B09-00600806D9B6}';
  IID_ISWbemProperty: TGUID = '{1A388F98-D4BA-11D1-8B09-00600806D9B6}';
  IID_ISWbemMethodSet: TGUID = '{C93BA292-D955-11D1-8B09-00600806D9B6}';
  IID_ISWbemMethod: TGUID = '{422E8E90-D955-11D1-8B09-00600806D9B6}';
  IID_ISWbemEventSource: TGUID = '{27D54D92-0EBE-11D2-8B22-00600806D9B6}';
  IID_ISWbemLocator: TGUID = '{76A6415B-CB41-11D1-8B02-00600806D9B6}';
  IID_ISWbemLastError: TGUID = '{D962DB84-D4BB-11D1-8B09-00600806D9B6}';
  DIID_ISWbemSinkEvents: TGUID = '{75718CA0-F029-11D1-A1AC-00C04FB6C223}';
  IID_ISWbemSink: TGUID = '{75718C9F-F029-11D1-A1AC-00C04FB6C223}';
  IID_ISWbemServicesEx: TGUID = '{D2F68443-85DC-427E-91D8-366554CC754C}';
  IID_ISWbemObjectEx: TGUID = '{269AD56A-8A67-4129-BC8C-0506DCFE9880}';
  IID_ISWbemDateTime: TGUID = '{5E97458A-CF77-11D3-B38F-00105A1F473A}';
  IID_ISWbemRefresher: TGUID = '{14D8250E-D9C2-11D3-B38F-00105A1F473A}';
  IID_ISWbemRefreshableItem: TGUID = '{5AD4BF92-DAAB-11D3-B38F-00105A1F473A}';
  CLASS_SWbemLocator: TGUID = '{76A64158-CB41-11D1-8B02-00600806D9B6}';
  CLASS_SWbemNamedValueSet: TGUID = '{9AED384E-CE8B-11D1-8B05-00600806D9B6}';
  CLASS_SWbemObjectPath: TGUID = '{5791BC26-CE9C-11D1-97BF-0000F81E849C}';
  CLASS_SWbemLastError: TGUID = '{C2FEEEAC-CFCD-11D1-8B05-00600806D9B6}';
  CLASS_SWbemSink: TGUID = '{75718C9A-F029-11D1-A1AC-00C04FB6C223}';
  CLASS_SWbemDateTime: TGUID = '{47DFBE54-CF76-11D3-B38F-00105A1F473A}';
  CLASS_SWbemRefresher: TGUID = '{D269BF5C-D9C1-11D3-B38F-00105A1F473A}';
  CLASS_SWbemServices: TGUID = '{04B83D63-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemServicesEx: TGUID = '{62E522DC-8CF3-40A8-8B2E-37D595651E40}';
  CLASS_SWbemObject: TGUID = '{04B83D62-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemObjectEx: TGUID = '{D6BDAFB2-9435-491F-BB87-6AA0F0BC31A2}';
  CLASS_SWbemObjectSet: TGUID = '{04B83D61-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemNamedValue: TGUID = '{04B83D60-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemQualifier: TGUID = '{04B83D5F-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemQualifierSet: TGUID = '{04B83D5E-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemProperty: TGUID = '{04B83D5D-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemPropertySet: TGUID = '{04B83D5C-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemMethod: TGUID = '{04B83D5B-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemMethodSet: TGUID = '{04B83D5A-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemEventSource: TGUID = '{04B83D58-21AE-11D2-8B33-00600806D9B6}';
  CLASS_SWbemSecurity: TGUID = '{B54D66E9-2287-11D2-8B33-00600806D9B6}';
  CLASS_SWbemPrivilege: TGUID = '{26EE67BC-5804-11D2-8B4A-00600806D9B6}';
  CLASS_SWbemPrivilegeSet: TGUID = '{26EE67BE-5804-11D2-8B4A-00600806D9B6}';
  CLASS_SWbemRefreshableItem: TGUID = '{8C6854BC-DE4B-11D3-B390-00105A1F473A}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum WbemImpersonationLevelEnum
type
  WbemImpersonationLevelEnum = TOleEnum;
const
  wbemImpersonationLevelAnonymous = $00000001;
  wbemImpersonationLevelIdentify = $00000002;
  wbemImpersonationLevelImpersonate = $00000003;
  wbemImpersonationLevelDelegate = $00000004;

// Constants for enum WbemAuthenticationLevelEnum
type
  WbemAuthenticationLevelEnum = TOleEnum;
const
  wbemAuthenticationLevelDefault = $00000000;
  wbemAuthenticationLevelNone = $00000001;
  wbemAuthenticationLevelConnect = $00000002;
  wbemAuthenticationLevelCall = $00000003;
  wbemAuthenticationLevelPkt = $00000004;
  wbemAuthenticationLevelPktIntegrity = $00000005;
  wbemAuthenticationLevelPktPrivacy = $00000006;

// Constants for enum WbemPrivilegeEnum
type
  WbemPrivilegeEnum = TOleEnum;
const
  wbemPrivilegeCreateToken = $00000001;
  wbemPrivilegePrimaryToken = $00000002;
  wbemPrivilegeLockMemory = $00000003;
  wbemPrivilegeIncreaseQuota = $00000004;
  wbemPrivilegeMachineAccount = $00000005;
  wbemPrivilegeTcb = $00000006;
  wbemPrivilegeSecurity = $00000007;
  wbemPrivilegeTakeOwnership = $00000008;
  wbemPrivilegeLoadDriver = $00000009;
  wbemPrivilegeSystemProfile = $0000000A;
  wbemPrivilegeSystemtime = $0000000B;
  wbemPrivilegeProfileSingleProcess = $0000000C;
  wbemPrivilegeIncreaseBasePriority = $0000000D;
  wbemPrivilegeCreatePagefile = $0000000E;
  wbemPrivilegeCreatePermanent = $0000000F;
  wbemPrivilegeBackup = $00000010;
  wbemPrivilegeRestore = $00000011;
  wbemPrivilegeShutdown = $00000012;
  wbemPrivilegeDebug = $00000013;
  wbemPrivilegeAudit = $00000014;
  wbemPrivilegeSystemEnvironment = $00000015;
  wbemPrivilegeChangeNotify = $00000016;
  wbemPrivilegeRemoteShutdown = $00000017;
  wbemPrivilegeUndock = $00000018;
  wbemPrivilegeSyncAgent = $00000019;
  wbemPrivilegeEnableDelegation = $0000001A;
  wbemPrivilegeManageVolume = $0000001B;

// Constants for enum WbemCimtypeEnum
type
  WbemCimtypeEnum = TOleEnum;
const
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

// Constants for enum WbemErrorEnum
type
  WbemErrorEnum = TOleEnum;
const
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

// Constants for enum WbemObjectTextFormatEnum
type
  WbemObjectTextFormatEnum = TOleEnum;
const
  wbemObjectTextFormatCIMDTD20 = $00000001;
  wbemObjectTextFormatWMIDTD20 = $00000002;

// Constants for enum WbemChangeFlagEnum
type
  WbemChangeFlagEnum = TOleEnum;
const
  wbemChangeFlagCreateOrUpdate = $00000000;
  wbemChangeFlagUpdateOnly = $00000001;
  wbemChangeFlagCreateOnly = $00000002;
  wbemChangeFlagUpdateCompatible = $00000000;
  wbemChangeFlagUpdateSafeMode = $00000020;
  wbemChangeFlagUpdateForceMode = $00000040;
  wbemChangeFlagStrongValidation = $00000080;
  wbemChangeFlagAdvisory = $00010000;

// Constants for enum WbemFlagEnum
type
  WbemFlagEnum = TOleEnum;
const
  wbemFlagReturnImmediately = $00000010;
  wbemFlagReturnWhenComplete = $00000000;
  wbemFlagBidirectional = $00000000;
  wbemFlagForwardOnly = $00000020;
  wbemFlagNoErrorObject = $00000040;
  wbemFlagReturnErrorObject = $00000000;
  wbemFlagSendStatus = $00000080;
  wbemFlagDontSendStatus = $00000000;
  wbemFlagEnsureLocatable = $00000100;
  wbemFlagDirectRead = $00000200;
  wbemFlagSendOnlySelected = $00000000;
  wbemFlagUseAmendedQualifiers = $00020000;
  wbemFlagGetDefault = $00000000;
  wbemFlagSpawnInstance = $00000001;
  wbemFlagUseCurrentTime = $00000001;

// Constants for enum WbemQueryFlagEnum
type
  WbemQueryFlagEnum = TOleEnum;
const
  wbemQueryFlagDeep = $00000000;
  wbemQueryFlagShallow = $00000001;
  wbemQueryFlagPrototype = $00000002;

// Constants for enum WbemTextFlagEnum
type
  WbemTextFlagEnum = TOleEnum;
const
  wbemTextFlagNoFlavors = $00000001;

// Constants for enum WbemTimeout
type
  WbemTimeout = TOleEnum;
const
  wbemTimeoutInfinite = $FFFFFFFF;

// Constants for enum WbemComparisonFlagEnum
type
  WbemComparisonFlagEnum = TOleEnum;
const
  wbemComparisonFlagIncludeAll = $00000000;
  wbemComparisonFlagIgnoreQualifiers = $00000001;
  wbemComparisonFlagIgnoreObjectSource = $00000002;
  wbemComparisonFlagIgnoreDefaultValues = $00000004;
  wbemComparisonFlagIgnoreClass = $00000008;
  wbemComparisonFlagIgnoreCase = $00000010;
  wbemComparisonFlagIgnoreFlavor = $00000020;

// Constants for enum WbemConnectOptionsEnum
type
  WbemConnectOptionsEnum = TOleEnum;
const
  wbemConnectFlagUseMaxWait = $00000080;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISWbemServices = interface;
  ISWbemServicesDisp = dispinterface;
  ISWbemObject = interface;
  ISWbemObjectDisp = dispinterface;
  ISWbemObjectPath = interface;
  ISWbemObjectPathDisp = dispinterface;
  ISWbemNamedValueSet = interface;
  ISWbemNamedValueSetDisp = dispinterface;
  ISWbemNamedValue = interface;
  ISWbemNamedValueDisp = dispinterface;
  ISWbemSecurity = interface;
  ISWbemSecurityDisp = dispinterface;
  ISWbemPrivilegeSet = interface;
  ISWbemPrivilegeSetDisp = dispinterface;
  ISWbemPrivilege = interface;
  ISWbemPrivilegeDisp = dispinterface;
  ISWbemObjectSet = interface;
  ISWbemObjectSetDisp = dispinterface;
  ISWbemQualifierSet = interface;
  ISWbemQualifierSetDisp = dispinterface;
  ISWbemQualifier = interface;
  ISWbemQualifierDisp = dispinterface;
  ISWbemPropertySet = interface;
  ISWbemPropertySetDisp = dispinterface;
  ISWbemProperty = interface;
  ISWbemPropertyDisp = dispinterface;
  ISWbemMethodSet = interface;
  ISWbemMethodSetDisp = dispinterface;
  ISWbemMethod = interface;
  ISWbemMethodDisp = dispinterface;
  ISWbemEventSource = interface;
  ISWbemEventSourceDisp = dispinterface;
  ISWbemLocator = interface;
  ISWbemLocatorDisp = dispinterface;
  ISWbemLastError = interface;
  ISWbemLastErrorDisp = dispinterface;
  ISWbemSinkEvents = dispinterface;
  ISWbemSink = interface;
  ISWbemSinkDisp = dispinterface;
  ISWbemServicesEx = interface;
  ISWbemServicesExDisp = dispinterface;
  ISWbemObjectEx = interface;
  ISWbemObjectExDisp = dispinterface;
  ISWbemDateTime = interface;
  ISWbemDateTimeDisp = dispinterface;
  ISWbemRefresher = interface;
  ISWbemRefresherDisp = dispinterface;
  ISWbemRefreshableItem = interface;
  ISWbemRefreshableItemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SWbemLocator = ISWbemLocator;
  SWbemNamedValueSet = ISWbemNamedValueSet;
  SWbemObjectPath = ISWbemObjectPath;
  SWbemLastError = ISWbemLastError;
  SWbemSink = ISWbemSink;
  SWbemDateTime = ISWbemDateTime;
  SWbemRefresher = ISWbemRefresher;
  SWbemServices = ISWbemServices;
  SWbemServicesEx = ISWbemServicesEx;
  SWbemObject = ISWbemObject;
  SWbemObjectEx = ISWbemObjectEx;
  SWbemObjectSet = ISWbemObjectSet;
  SWbemNamedValue = ISWbemNamedValue;
  SWbemQualifier = ISWbemQualifier;
  SWbemQualifierSet = ISWbemQualifierSet;
  SWbemProperty = ISWbemProperty;
  SWbemPropertySet = ISWbemPropertySet;
  SWbemMethod = ISWbemMethod;
  SWbemMethodSet = ISWbemMethodSet;
  SWbemEventSource = ISWbemEventSource;
  SWbemSecurity = ISWbemSecurity;
  SWbemPrivilege = ISWbemPrivilege;
  SWbemPrivilegeSet = ISWbemPrivilegeSet;
  SWbemRefreshableItem = ISWbemRefreshableItem;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface: ISWbemServices
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A6415C-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemServices = interface(IDispatch)
    ['{76A6415C-CB41-11D1-8B02-00600806D9B6}']
    function Get(const strObjectPath: WideString; iFlags: Integer; 
                 const objWbemNamedValueSet: IDispatch): ISWbemObject; safecall;
    procedure GetAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                       const objWbemAsyncContext: IDispatch); safecall;
    procedure Delete(const strObjectPath: WideString; iFlags: Integer; 
                     const objWbemNamedValueSet: IDispatch); safecall;
    procedure DeleteAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                          iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                          const objWbemAsyncContext: IDispatch); safecall;
    function InstancesOf(const strClass: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure InstancesOfAsync(const objWbemSink: IDispatch; const strClass: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); safecall;
    function SubclassesOf(const strSuperclass: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure SubclassesOfAsync(const objWbemSink: IDispatch; const strSuperclass: WideString; 
                                iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); safecall;
    function ExecQuery(const strQuery: WideString; const strQueryLanguage: WideString; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure ExecQueryAsync(const objWbemSink: IDispatch; const strQuery: WideString; 
                             const strQueryLanguage: WideString; lFlags: Integer; 
                             const objWbemNamedValueSet: IDispatch; 
                             const objWbemAsyncContext: IDispatch); safecall;
    function AssociatorsOf(const strObjectPath: WideString; const strAssocClass: WideString; 
                           const strResultClass: WideString; const strResultRole: WideString; 
                           const strRole: WideString; bClassesOnly: WordBool; 
                           bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                           const strRequiredQualifier: WideString; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure AssociatorsOfAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                                 const strAssocClass: WideString; const strResultClass: WideString; 
                                 const strResultRole: WideString; const strRole: WideString; 
                                 bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                 const strRequiredAssocQualifier: WideString; 
                                 const strRequiredQualifier: WideString; iFlags: Integer; 
                                 const objWbemNamedValueSet: IDispatch; 
                                 const objWbemAsyncContext: IDispatch); safecall;
    function ReferencesTo(const strObjectPath: WideString; const strResultClass: WideString; 
                          const strRole: WideString; bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure ReferencesToAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                                const strResultClass: WideString; const strRole: WideString; 
                                bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); safecall;
    function ExecNotificationQuery(const strQuery: WideString; const strQueryLanguage: WideString; 
                                   iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemEventSource; safecall;
    procedure ExecNotificationQueryAsync(const objWbemSink: IDispatch; const strQuery: WideString; 
                                         const strQueryLanguage: WideString; iFlags: Integer; 
                                         const objWbemNamedValueSet: IDispatch; 
                                         const objWbemAsyncContext: IDispatch); safecall;
    function ExecMethod(const strObjectPath: WideString; const strMethodName: WideString; 
                        const objWbemInParameters: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch): ISWbemObject; safecall;
    procedure ExecMethodAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                              const strMethodName: WideString; 
                              const objWbemInParameters: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); safecall;
    function Get_Security_: ISWbemSecurity; safecall;
    property Security_: ISWbemSecurity read Get_Security_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemServicesDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A6415C-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemServicesDisp = dispinterface
    ['{76A6415C-CB41-11D1-8B02-00600806D9B6}']
    function Get(const strObjectPath: WideString; iFlags: Integer; 
                 const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 1;
    procedure GetAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                       const objWbemAsyncContext: IDispatch); dispid 2;
    procedure Delete(const strObjectPath: WideString; iFlags: Integer; 
                     const objWbemNamedValueSet: IDispatch); dispid 3;
    procedure DeleteAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                          iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                          const objWbemAsyncContext: IDispatch); dispid 4;
    function InstancesOf(const strClass: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 5;
    procedure InstancesOfAsync(const objWbemSink: IDispatch; const strClass: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 6;
    function SubclassesOf(const strSuperclass: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 7;
    procedure SubclassesOfAsync(const objWbemSink: IDispatch; const strSuperclass: WideString; 
                                iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 8;
    function ExecQuery(const strQuery: WideString; const strQueryLanguage: WideString; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 9;
    procedure ExecQueryAsync(const objWbemSink: IDispatch; const strQuery: WideString; 
                             const strQueryLanguage: WideString; lFlags: Integer; 
                             const objWbemNamedValueSet: IDispatch; 
                             const objWbemAsyncContext: IDispatch); dispid 10;
    function AssociatorsOf(const strObjectPath: WideString; const strAssocClass: WideString; 
                           const strResultClass: WideString; const strResultRole: WideString; 
                           const strRole: WideString; bClassesOnly: WordBool; 
                           bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                           const strRequiredQualifier: WideString; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 11;
    procedure AssociatorsOfAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                                 const strAssocClass: WideString; const strResultClass: WideString; 
                                 const strResultRole: WideString; const strRole: WideString; 
                                 bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                 const strRequiredAssocQualifier: WideString; 
                                 const strRequiredQualifier: WideString; iFlags: Integer; 
                                 const objWbemNamedValueSet: IDispatch; 
                                 const objWbemAsyncContext: IDispatch); dispid 12;
    function ReferencesTo(const strObjectPath: WideString; const strResultClass: WideString; 
                          const strRole: WideString; bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 13;
    procedure ReferencesToAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                                const strResultClass: WideString; const strRole: WideString; 
                                bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 14;
    function ExecNotificationQuery(const strQuery: WideString; const strQueryLanguage: WideString; 
                                   iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemEventSource; dispid 15;
    procedure ExecNotificationQueryAsync(const objWbemSink: IDispatch; const strQuery: WideString; 
                                         const strQueryLanguage: WideString; iFlags: Integer; 
                                         const objWbemNamedValueSet: IDispatch; 
                                         const objWbemAsyncContext: IDispatch); dispid 16;
    function ExecMethod(const strObjectPath: WideString; const strMethodName: WideString; 
                        const objWbemInParameters: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 17;
    procedure ExecMethodAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                              const strMethodName: WideString; 
                              const objWbemInParameters: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); dispid 18;
    property Security_: ISWbemSecurity readonly dispid 19;
  end;

// *********************************************************************//
// Interface: ISWbemObject
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A6415A-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemObject = interface(IDispatch)
    ['{76A6415A-CB41-11D1-8B02-00600806D9B6}']
    function Put_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectPath; safecall;
    procedure PutAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch; const objWbemAsyncContext: IDispatch); safecall;
    procedure Delete_(iFlags: Integer; const objWbemNamedValueSet: IDispatch); safecall;
    procedure DeleteAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch; 
                           const objWbemAsyncContext: IDispatch); safecall;
    function Instances_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure InstancesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); safecall;
    function Subclasses_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure SubclassesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); safecall;
    function Associators_(const strAssocClass: WideString; const strResultClass: WideString; 
                          const strResultRole: WideString; const strRole: WideString; 
                          bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredAssocQualifier: WideString; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure AssociatorsAsync_(const objWbemSink: IDispatch; const strAssocClass: WideString; 
                                const strResultClass: WideString; const strResultRole: WideString; 
                                const strRole: WideString; bClassesOnly: WordBool; 
                                bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); safecall;
    function References_(const strResultClass: WideString; const strRole: WideString; 
                         bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                         const strRequiredQualifier: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; safecall;
    procedure ReferencesAsync_(const objWbemSink: IDispatch; const strResultClass: WideString; 
                               const strRole: WideString; bClassesOnly: WordBool; 
                               bSchemaOnly: WordBool; const strRequiredQualifier: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); safecall;
    function ExecMethod_(const strMethodName: WideString; const objWbemInParameters: IDispatch; 
                         iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObject; safecall;
    procedure ExecMethodAsync_(const objWbemSink: IDispatch; const strMethodName: WideString; 
                               const objWbemInParameters: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); safecall;
    function Clone_: ISWbemObject; safecall;
    function GetObjectText_(iFlags: Integer): WideString; safecall;
    function SpawnDerivedClass_(iFlags: Integer): ISWbemObject; safecall;
    function SpawnInstance_(iFlags: Integer): ISWbemObject; safecall;
    function CompareTo_(const objWbemObject: IDispatch; iFlags: Integer): WordBool; safecall;
    function Get_Qualifiers_: ISWbemQualifierSet; safecall;
    function Get_Properties_: ISWbemPropertySet; safecall;
    function Get_Methods_: ISWbemMethodSet; safecall;
    function Get_Derivation_: OleVariant; safecall;
    function Get_Path_: ISWbemObjectPath; safecall;
    function Get_Security_: ISWbemSecurity; safecall;
    property Qualifiers_: ISWbemQualifierSet read Get_Qualifiers_;
    property Properties_: ISWbemPropertySet read Get_Properties_;
    property Methods_: ISWbemMethodSet read Get_Methods_;
    property Derivation_: OleVariant read Get_Derivation_;
    property Path_: ISWbemObjectPath read Get_Path_;
    property Security_: ISWbemSecurity read Get_Security_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemObjectDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A6415A-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemObjectDisp = dispinterface
    ['{76A6415A-CB41-11D1-8B02-00600806D9B6}']
    function Put_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectPath; dispid 1;
    procedure PutAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch; const objWbemAsyncContext: IDispatch); dispid 2;
    procedure Delete_(iFlags: Integer; const objWbemNamedValueSet: IDispatch); dispid 3;
    procedure DeleteAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch; 
                           const objWbemAsyncContext: IDispatch); dispid 4;
    function Instances_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 5;
    procedure InstancesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); dispid 6;
    function Subclasses_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 7;
    procedure SubclassesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 8;
    function Associators_(const strAssocClass: WideString; const strResultClass: WideString; 
                          const strResultRole: WideString; const strRole: WideString; 
                          bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredAssocQualifier: WideString; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 9;
    procedure AssociatorsAsync_(const objWbemSink: IDispatch; const strAssocClass: WideString; 
                                const strResultClass: WideString; const strResultRole: WideString; 
                                const strRole: WideString; bClassesOnly: WordBool; 
                                bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 10;
    function References_(const strResultClass: WideString; const strRole: WideString; 
                         bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                         const strRequiredQualifier: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 11;
    procedure ReferencesAsync_(const objWbemSink: IDispatch; const strResultClass: WideString; 
                               const strRole: WideString; bClassesOnly: WordBool; 
                               bSchemaOnly: WordBool; const strRequiredQualifier: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 12;
    function ExecMethod_(const strMethodName: WideString; const objWbemInParameters: IDispatch; 
                         iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 13;
    procedure ExecMethodAsync_(const objWbemSink: IDispatch; const strMethodName: WideString; 
                               const objWbemInParameters: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 14;
    function Clone_: ISWbemObject; dispid 15;
    function GetObjectText_(iFlags: Integer): WideString; dispid 16;
    function SpawnDerivedClass_(iFlags: Integer): ISWbemObject; dispid 17;
    function SpawnInstance_(iFlags: Integer): ISWbemObject; dispid 18;
    function CompareTo_(const objWbemObject: IDispatch; iFlags: Integer): WordBool; dispid 19;
    property Qualifiers_: ISWbemQualifierSet readonly dispid 20;
    property Properties_: ISWbemPropertySet readonly dispid 21;
    property Methods_: ISWbemMethodSet readonly dispid 22;
    property Derivation_: OleVariant readonly dispid 23;
    property Path_: ISWbemObjectPath readonly dispid 24;
    property Security_: ISWbemSecurity readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ISWbemObjectPath
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {5791BC27-CE9C-11D1-97BF-0000F81E849C}
// *********************************************************************//
  ISWbemObjectPath = interface(IDispatch)
    ['{5791BC27-CE9C-11D1-97BF-0000F81E849C}']
    function Get_Path: WideString; safecall;
    procedure Set_Path(const strPath: WideString); safecall;
    function Get_RelPath: WideString; safecall;
    procedure Set_RelPath(const strRelPath: WideString); safecall;
    function Get_Server: WideString; safecall;
    procedure Set_Server(const strServer: WideString); safecall;
    function Get_Namespace: WideString; safecall;
    procedure Set_Namespace(const strNamespace: WideString); safecall;
    function Get_ParentNamespace: WideString; safecall;
    function Get_DisplayName: WideString; safecall;
    procedure Set_DisplayName(const strDisplayName: WideString); safecall;
    function Get_Class_: WideString; safecall;
    procedure Set_Class_(const strClass: WideString); safecall;
    function Get_IsClass: WordBool; safecall;
    procedure SetAsClass; safecall;
    function Get_IsSingleton: WordBool; safecall;
    procedure SetAsSingleton; safecall;
    function Get_Keys: ISWbemNamedValueSet; safecall;
    function Get_Security_: ISWbemSecurity; safecall;
    function Get_Locale: WideString; safecall;
    procedure Set_Locale(const strLocale: WideString); safecall;
    function Get_Authority: WideString; safecall;
    procedure Set_Authority(const strAuthority: WideString); safecall;
    property Path: WideString read Get_Path write Set_Path;
    property RelPath: WideString read Get_RelPath write Set_RelPath;
    property Server: WideString read Get_Server write Set_Server;
    property Namespace: WideString read Get_Namespace write Set_Namespace;
    property ParentNamespace: WideString read Get_ParentNamespace;
    property DisplayName: WideString read Get_DisplayName write Set_DisplayName;
    property Class_: WideString read Get_Class_ write Set_Class_;
    property IsClass: WordBool read Get_IsClass;
    property IsSingleton: WordBool read Get_IsSingleton;
    property Keys: ISWbemNamedValueSet read Get_Keys;
    property Security_: ISWbemSecurity read Get_Security_;
    property Locale: WideString read Get_Locale write Set_Locale;
    property Authority: WideString read Get_Authority write Set_Authority;
  end;

// *********************************************************************//
// DispIntf:  ISWbemObjectPathDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {5791BC27-CE9C-11D1-97BF-0000F81E849C}
// *********************************************************************//
  ISWbemObjectPathDisp = dispinterface
    ['{5791BC27-CE9C-11D1-97BF-0000F81E849C}']
    property Path: WideString dispid 0;
    property RelPath: WideString dispid 1;
    property Server: WideString dispid 2;
    property Namespace: WideString dispid 3;
    property ParentNamespace: WideString readonly dispid 4;
    property DisplayName: WideString dispid 5;
    property Class_: WideString dispid 6;
    property IsClass: WordBool readonly dispid 7;
    procedure SetAsClass; dispid 8;
    property IsSingleton: WordBool readonly dispid 9;
    procedure SetAsSingleton; dispid 10;
    property Keys: ISWbemNamedValueSet readonly dispid 11;
    property Security_: ISWbemSecurity readonly dispid 12;
    property Locale: WideString dispid 13;
    property Authority: WideString dispid 14;
  end;

// *********************************************************************//
// Interface: ISWbemNamedValueSet
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CF2376EA-CE8C-11D1-8B05-00600806D9B6}
// *********************************************************************//
  ISWbemNamedValueSet = interface(IDispatch)
    ['{CF2376EA-CE8C-11D1-8B05-00600806D9B6}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(const strName: WideString; iFlags: Integer): ISWbemNamedValue; safecall;
    function Get_Count: Integer; safecall;
    function Add(const strName: WideString; var varValue: OleVariant; iFlags: Integer): ISWbemNamedValue; safecall;
    procedure Remove(const strName: WideString; iFlags: Integer); safecall;
    function Clone: ISWbemNamedValueSet; safecall;
    procedure DeleteAll; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ISWbemNamedValueSetDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CF2376EA-CE8C-11D1-8B05-00600806D9B6}
// *********************************************************************//
  ISWbemNamedValueSetDisp = dispinterface
    ['{CF2376EA-CE8C-11D1-8B05-00600806D9B6}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(const strName: WideString; iFlags: Integer): ISWbemNamedValue; dispid 0;
    property Count: Integer readonly dispid 1;
    function Add(const strName: WideString; var varValue: OleVariant; iFlags: Integer): ISWbemNamedValue; dispid 2;
    procedure Remove(const strName: WideString; iFlags: Integer); dispid 3;
    function Clone: ISWbemNamedValueSet; dispid 4;
    procedure DeleteAll; dispid 5;
  end;

// *********************************************************************//
// Interface: ISWbemNamedValue
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A64164-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemNamedValue = interface(IDispatch)
    ['{76A64164-CB41-11D1-8B02-00600806D9B6}']
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(var varValue: OleVariant); safecall;
    function Get_Name: WideString; safecall;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  ISWbemNamedValueDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A64164-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemNamedValueDisp = dispinterface
    ['{76A64164-CB41-11D1-8B02-00600806D9B6}']
    function Value: OleVariant; dispid 0;
    property Name: WideString readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ISWbemSecurity
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {B54D66E6-2287-11D2-8B33-00600806D9B6}
// *********************************************************************//
  ISWbemSecurity = interface(IDispatch)
    ['{B54D66E6-2287-11D2-8B33-00600806D9B6}']
    function Get_ImpersonationLevel: WbemImpersonationLevelEnum; safecall;
    procedure Set_ImpersonationLevel(iImpersonationLevel: WbemImpersonationLevelEnum); safecall;
    function Get_AuthenticationLevel: WbemAuthenticationLevelEnum; safecall;
    procedure Set_AuthenticationLevel(iAuthenticationLevel: WbemAuthenticationLevelEnum); safecall;
    function Get_Privileges: ISWbemPrivilegeSet; safecall;
    property ImpersonationLevel: WbemImpersonationLevelEnum read Get_ImpersonationLevel write Set_ImpersonationLevel;
    property AuthenticationLevel: WbemAuthenticationLevelEnum read Get_AuthenticationLevel write Set_AuthenticationLevel;
    property Privileges: ISWbemPrivilegeSet read Get_Privileges;
  end;

// *********************************************************************//
// DispIntf:  ISWbemSecurityDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {B54D66E6-2287-11D2-8B33-00600806D9B6}
// *********************************************************************//
  ISWbemSecurityDisp = dispinterface
    ['{B54D66E6-2287-11D2-8B33-00600806D9B6}']
    property ImpersonationLevel: WbemImpersonationLevelEnum dispid 1;
    property AuthenticationLevel: WbemAuthenticationLevelEnum dispid 2;
    property Privileges: ISWbemPrivilegeSet readonly dispid 3;
  end;

// *********************************************************************//
// Interface: ISWbemPrivilegeSet
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {26EE67BF-5804-11D2-8B4A-00600806D9B6}
// *********************************************************************//
  ISWbemPrivilegeSet = interface(IDispatch)
    ['{26EE67BF-5804-11D2-8B4A-00600806D9B6}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(iPrivilege: WbemPrivilegeEnum): ISWbemPrivilege; safecall;
    function Get_Count: Integer; safecall;
    function Add(iPrivilege: WbemPrivilegeEnum; bIsEnabled: WordBool): ISWbemPrivilege; safecall;
    procedure Remove(iPrivilege: WbemPrivilegeEnum); safecall;
    procedure DeleteAll; safecall;
    function AddAsString(const strPrivilege: WideString; bIsEnabled: WordBool): ISWbemPrivilege; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ISWbemPrivilegeSetDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {26EE67BF-5804-11D2-8B4A-00600806D9B6}
// *********************************************************************//
  ISWbemPrivilegeSetDisp = dispinterface
    ['{26EE67BF-5804-11D2-8B4A-00600806D9B6}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(iPrivilege: WbemPrivilegeEnum): ISWbemPrivilege; dispid 0;
    property Count: Integer readonly dispid 1;
    function Add(iPrivilege: WbemPrivilegeEnum; bIsEnabled: WordBool): ISWbemPrivilege; dispid 2;
    procedure Remove(iPrivilege: WbemPrivilegeEnum); dispid 3;
    procedure DeleteAll; dispid 4;
    function AddAsString(const strPrivilege: WideString; bIsEnabled: WordBool): ISWbemPrivilege; dispid 5;
  end;

// *********************************************************************//
// Interface: ISWbemPrivilege
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {26EE67BD-5804-11D2-8B4A-00600806D9B6}
// *********************************************************************//
  ISWbemPrivilege = interface(IDispatch)
    ['{26EE67BD-5804-11D2-8B4A-00600806D9B6}']
    function Get_IsEnabled: WordBool; safecall;
    procedure Set_IsEnabled(bIsEnabled: WordBool); safecall;
    function Get_Name: WideString; safecall;
    function Get_DisplayName: WideString; safecall;
    function Get_Identifier: WbemPrivilegeEnum; safecall;
    property IsEnabled: WordBool read Get_IsEnabled write Set_IsEnabled;
    property Name: WideString read Get_Name;
    property DisplayName: WideString read Get_DisplayName;
    property Identifier: WbemPrivilegeEnum read Get_Identifier;
  end;

// *********************************************************************//
// DispIntf:  ISWbemPrivilegeDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {26EE67BD-5804-11D2-8B4A-00600806D9B6}
// *********************************************************************//
  ISWbemPrivilegeDisp = dispinterface
    ['{26EE67BD-5804-11D2-8B4A-00600806D9B6}']
    property IsEnabled: WordBool dispid 0;
    property Name: WideString readonly dispid 1;
    property DisplayName: WideString readonly dispid 2;
    property Identifier: WbemPrivilegeEnum readonly dispid 3;
  end;

// *********************************************************************//
// Interface: ISWbemObjectSet
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {76A6415F-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemObjectSet = interface(IDispatch)
    ['{76A6415F-CB41-11D1-8B02-00600806D9B6}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(const strObjectPath: WideString; iFlags: Integer): ISWbemObject; safecall;
    function Get_Count: Integer; safecall;
    function Get_Security_: ISWbemSecurity; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
    property Security_: ISWbemSecurity read Get_Security_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemObjectSetDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {76A6415F-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemObjectSetDisp = dispinterface
    ['{76A6415F-CB41-11D1-8B02-00600806D9B6}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(const strObjectPath: WideString; iFlags: Integer): ISWbemObject; dispid 0;
    property Count: Integer readonly dispid 1;
    property Security_: ISWbemSecurity readonly dispid 4;
  end;

// *********************************************************************//
// Interface: ISWbemQualifierSet
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9B16ED16-D3DF-11D1-8B08-00600806D9B6}
// *********************************************************************//
  ISWbemQualifierSet = interface(IDispatch)
    ['{9B16ED16-D3DF-11D1-8B08-00600806D9B6}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(const Name: WideString; iFlags: Integer): ISWbemQualifier; safecall;
    function Get_Count: Integer; safecall;
    function Add(const strName: WideString; var varVal: OleVariant; 
                 bPropagatesToSubclass: WordBool; bPropagatesToInstance: WordBool; 
                 bIsOverridable: WordBool; iFlags: Integer): ISWbemQualifier; safecall;
    procedure Remove(const strName: WideString; iFlags: Integer); safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ISWbemQualifierSetDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {9B16ED16-D3DF-11D1-8B08-00600806D9B6}
// *********************************************************************//
  ISWbemQualifierSetDisp = dispinterface
    ['{9B16ED16-D3DF-11D1-8B08-00600806D9B6}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(const Name: WideString; iFlags: Integer): ISWbemQualifier; dispid 0;
    property Count: Integer readonly dispid 1;
    function Add(const strName: WideString; var varVal: OleVariant; 
                 bPropagatesToSubclass: WordBool; bPropagatesToInstance: WordBool; 
                 bIsOverridable: WordBool; iFlags: Integer): ISWbemQualifier; dispid 2;
    procedure Remove(const strName: WideString; iFlags: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: ISWbemQualifier
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {79B05932-D3B7-11D1-8B06-00600806D9B6}
// *********************************************************************//
  ISWbemQualifier = interface(IDispatch)
    ['{79B05932-D3B7-11D1-8B06-00600806D9B6}']
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(var varValue: OleVariant); safecall;
    function Get_Name: WideString; safecall;
    function Get_IsLocal: WordBool; safecall;
    function Get_PropagatesToSubclass: WordBool; safecall;
    procedure Set_PropagatesToSubclass(bPropagatesToSubclass: WordBool); safecall;
    function Get_PropagatesToInstance: WordBool; safecall;
    procedure Set_PropagatesToInstance(bPropagatesToInstance: WordBool); safecall;
    function Get_IsOverridable: WordBool; safecall;
    procedure Set_IsOverridable(bIsOverridable: WordBool); safecall;
    function Get_IsAmended: WordBool; safecall;
    property Name: WideString read Get_Name;
    property IsLocal: WordBool read Get_IsLocal;
    property PropagatesToSubclass: WordBool read Get_PropagatesToSubclass write Set_PropagatesToSubclass;
    property PropagatesToInstance: WordBool read Get_PropagatesToInstance write Set_PropagatesToInstance;
    property IsOverridable: WordBool read Get_IsOverridable write Set_IsOverridable;
    property IsAmended: WordBool read Get_IsAmended;
  end;

// *********************************************************************//
// DispIntf:  ISWbemQualifierDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {79B05932-D3B7-11D1-8B06-00600806D9B6}
// *********************************************************************//
  ISWbemQualifierDisp = dispinterface
    ['{79B05932-D3B7-11D1-8B06-00600806D9B6}']
    function Value: OleVariant; dispid 0;
    property Name: WideString readonly dispid 1;
    property IsLocal: WordBool readonly dispid 2;
    property PropagatesToSubclass: WordBool dispid 3;
    property PropagatesToInstance: WordBool dispid 4;
    property IsOverridable: WordBool dispid 5;
    property IsAmended: WordBool readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ISWbemPropertySet
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {DEA0A7B2-D4BA-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemPropertySet = interface(IDispatch)
    ['{DEA0A7B2-D4BA-11D1-8B09-00600806D9B6}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(const strName: WideString; iFlags: Integer): ISWbemProperty; safecall;
    function Get_Count: Integer; safecall;
    function Add(const strName: WideString; iCimType: WbemCimtypeEnum; bIsArray: WordBool; 
                 iFlags: Integer): ISWbemProperty; safecall;
    procedure Remove(const strName: WideString; iFlags: Integer); safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ISWbemPropertySetDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {DEA0A7B2-D4BA-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemPropertySetDisp = dispinterface
    ['{DEA0A7B2-D4BA-11D1-8B09-00600806D9B6}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(const strName: WideString; iFlags: Integer): ISWbemProperty; dispid 0;
    property Count: Integer readonly dispid 1;
    function Add(const strName: WideString; iCimType: WbemCimtypeEnum; bIsArray: WordBool; 
                 iFlags: Integer): ISWbemProperty; dispid 2;
    procedure Remove(const strName: WideString; iFlags: Integer); dispid 3;
  end;

// *********************************************************************//
// Interface: ISWbemProperty
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {1A388F98-D4BA-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemProperty = interface(IDispatch)
    ['{1A388F98-D4BA-11D1-8B09-00600806D9B6}']
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(var varValue: OleVariant); safecall;
    function Get_Name: WideString; safecall;
    function Get_IsLocal: WordBool; safecall;
    function Get_Origin: WideString; safecall;
    function Get_CIMType: WbemCimtypeEnum; safecall;
    function Get_Qualifiers_: ISWbemQualifierSet; safecall;
    function Get_IsArray: WordBool; safecall;
    property Name: WideString read Get_Name;
    property IsLocal: WordBool read Get_IsLocal;
    property Origin: WideString read Get_Origin;
    property CIMType: WbemCimtypeEnum read Get_CIMType;
    property Qualifiers_: ISWbemQualifierSet read Get_Qualifiers_;
    property IsArray: WordBool read Get_IsArray;
  end;

// *********************************************************************//
// DispIntf:  ISWbemPropertyDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {1A388F98-D4BA-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemPropertyDisp = dispinterface
    ['{1A388F98-D4BA-11D1-8B09-00600806D9B6}']
    function Value: OleVariant; dispid 0;
    property Name: WideString readonly dispid 1;
    property IsLocal: WordBool readonly dispid 2;
    property Origin: WideString readonly dispid 3;
    property CIMType: WbemCimtypeEnum readonly dispid 4;
    property Qualifiers_: ISWbemQualifierSet readonly dispid 5;
    property IsArray: WordBool readonly dispid 6;
  end;

// *********************************************************************//
// Interface: ISWbemMethodSet
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C93BA292-D955-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemMethodSet = interface(IDispatch)
    ['{C93BA292-D955-11D1-8B09-00600806D9B6}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(const strName: WideString; iFlags: Integer): ISWbemMethod; safecall;
    function Get_Count: Integer; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  ISWbemMethodSetDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {C93BA292-D955-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemMethodSetDisp = dispinterface
    ['{C93BA292-D955-11D1-8B09-00600806D9B6}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(const strName: WideString; iFlags: Integer): ISWbemMethod; dispid 0;
    property Count: Integer readonly dispid 1;
  end;

// *********************************************************************//
// Interface: ISWbemMethod
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {422E8E90-D955-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemMethod = interface(IDispatch)
    ['{422E8E90-D955-11D1-8B09-00600806D9B6}']
    function Get_Name: WideString; safecall;
    function Get_Origin: WideString; safecall;
    function Get_InParameters: ISWbemObject; safecall;
    function Get_OutParameters: ISWbemObject; safecall;
    function Get_Qualifiers_: ISWbemQualifierSet; safecall;
    property Name: WideString read Get_Name;
    property Origin: WideString read Get_Origin;
    property InParameters: ISWbemObject read Get_InParameters;
    property OutParameters: ISWbemObject read Get_OutParameters;
    property Qualifiers_: ISWbemQualifierSet read Get_Qualifiers_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemMethodDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {422E8E90-D955-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemMethodDisp = dispinterface
    ['{422E8E90-D955-11D1-8B09-00600806D9B6}']
    property Name: WideString readonly dispid 1;
    property Origin: WideString readonly dispid 2;
    property InParameters: ISWbemObject readonly dispid 3;
    property OutParameters: ISWbemObject readonly dispid 4;
    property Qualifiers_: ISWbemQualifierSet readonly dispid 5;
  end;

// *********************************************************************//
// Interface: ISWbemEventSource
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27D54D92-0EBE-11D2-8B22-00600806D9B6}
// *********************************************************************//
  ISWbemEventSource = interface(IDispatch)
    ['{27D54D92-0EBE-11D2-8B22-00600806D9B6}']
    function NextEvent(iTimeoutMs: Integer): ISWbemObject; safecall;
    function Get_Security_: ISWbemSecurity; safecall;
    property Security_: ISWbemSecurity read Get_Security_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemEventSourceDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {27D54D92-0EBE-11D2-8B22-00600806D9B6}
// *********************************************************************//
  ISWbemEventSourceDisp = dispinterface
    ['{27D54D92-0EBE-11D2-8B22-00600806D9B6}']
    function NextEvent(iTimeoutMs: Integer): ISWbemObject; dispid 1;
    property Security_: ISWbemSecurity readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ISWbemLocator
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A6415B-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemLocator = interface(IDispatch)
    ['{76A6415B-CB41-11D1-8B02-00600806D9B6}']
    function ConnectServer(const strServer: WideString; const strNamespace: WideString; 
                           const strUser: WideString; const strPassword: WideString; 
                           const strLocale: WideString; const strAuthority: WideString; 
                           iSecurityFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemServices; safecall;
    function Get_Security_: ISWbemSecurity; safecall;
    property Security_: ISWbemSecurity read Get_Security_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemLocatorDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {76A6415B-CB41-11D1-8B02-00600806D9B6}
// *********************************************************************//
  ISWbemLocatorDisp = dispinterface
    ['{76A6415B-CB41-11D1-8B02-00600806D9B6}']
    function ConnectServer(const strServer: WideString; const strNamespace: WideString; 
                           const strUser: WideString; const strPassword: WideString; 
                           const strLocale: WideString; const strAuthority: WideString; 
                           iSecurityFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemServices; dispid 1;
    property Security_: ISWbemSecurity readonly dispid 2;
  end;

// *********************************************************************//
// Interface: ISWbemLastError
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {D962DB84-D4BB-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemLastError = interface(ISWbemObject)
    ['{D962DB84-D4BB-11D1-8B09-00600806D9B6}']
  end;

// *********************************************************************//
// DispIntf:  ISWbemLastErrorDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {D962DB84-D4BB-11D1-8B09-00600806D9B6}
// *********************************************************************//
  ISWbemLastErrorDisp = dispinterface
    ['{D962DB84-D4BB-11D1-8B09-00600806D9B6}']
    function Put_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectPath; dispid 1;
    procedure PutAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch; const objWbemAsyncContext: IDispatch); dispid 2;
    procedure Delete_(iFlags: Integer; const objWbemNamedValueSet: IDispatch); dispid 3;
    procedure DeleteAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch; 
                           const objWbemAsyncContext: IDispatch); dispid 4;
    function Instances_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 5;
    procedure InstancesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); dispid 6;
    function Subclasses_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 7;
    procedure SubclassesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 8;
    function Associators_(const strAssocClass: WideString; const strResultClass: WideString; 
                          const strResultRole: WideString; const strRole: WideString; 
                          bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredAssocQualifier: WideString; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 9;
    procedure AssociatorsAsync_(const objWbemSink: IDispatch; const strAssocClass: WideString; 
                                const strResultClass: WideString; const strResultRole: WideString; 
                                const strRole: WideString; bClassesOnly: WordBool; 
                                bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 10;
    function References_(const strResultClass: WideString; const strRole: WideString; 
                         bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                         const strRequiredQualifier: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 11;
    procedure ReferencesAsync_(const objWbemSink: IDispatch; const strResultClass: WideString; 
                               const strRole: WideString; bClassesOnly: WordBool; 
                               bSchemaOnly: WordBool; const strRequiredQualifier: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 12;
    function ExecMethod_(const strMethodName: WideString; const objWbemInParameters: IDispatch; 
                         iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 13;
    procedure ExecMethodAsync_(const objWbemSink: IDispatch; const strMethodName: WideString; 
                               const objWbemInParameters: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 14;
    function Clone_: ISWbemObject; dispid 15;
    function GetObjectText_(iFlags: Integer): WideString; dispid 16;
    function SpawnDerivedClass_(iFlags: Integer): ISWbemObject; dispid 17;
    function SpawnInstance_(iFlags: Integer): ISWbemObject; dispid 18;
    function CompareTo_(const objWbemObject: IDispatch; iFlags: Integer): WordBool; dispid 19;
    property Qualifiers_: ISWbemQualifierSet readonly dispid 20;
    property Properties_: ISWbemPropertySet readonly dispid 21;
    property Methods_: ISWbemMethodSet readonly dispid 22;
    property Derivation_: OleVariant readonly dispid 23;
    property Path_: ISWbemObjectPath readonly dispid 24;
    property Security_: ISWbemSecurity readonly dispid 25;
  end;

// *********************************************************************//
// DispIntf:  ISWbemSinkEvents
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {75718CA0-F029-11D1-A1AC-00C04FB6C223}
// *********************************************************************//
  ISWbemSinkEvents = dispinterface
    ['{75718CA0-F029-11D1-A1AC-00C04FB6C223}']
    procedure OnObjectReady(const objWbemObject: ISWbemObject; 
                            const objWbemAsyncContext: ISWbemNamedValueSet); dispid 1;
    procedure OnCompleted(iHResult: WbemErrorEnum; const objWbemErrorObject: ISWbemObject; 
                          const objWbemAsyncContext: ISWbemNamedValueSet); dispid 2;
    procedure OnProgress(iUpperBound: Integer; iCurrent: Integer; const strMessage: WideString; 
                         const objWbemAsyncContext: ISWbemNamedValueSet); dispid 3;
    procedure OnObjectPut(const objWbemObjectPath: ISWbemObjectPath; 
                          const objWbemAsyncContext: ISWbemNamedValueSet); dispid 4;
  end;

// *********************************************************************//
// Interface: ISWbemSink
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {75718C9F-F029-11D1-A1AC-00C04FB6C223}
// *********************************************************************//
  ISWbemSink = interface(IDispatch)
    ['{75718C9F-F029-11D1-A1AC-00C04FB6C223}']
    procedure Cancel; safecall;
  end;

// *********************************************************************//
// DispIntf:  ISWbemSinkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {75718C9F-F029-11D1-A1AC-00C04FB6C223}
// *********************************************************************//
  ISWbemSinkDisp = dispinterface
    ['{75718C9F-F029-11D1-A1AC-00C04FB6C223}']
    procedure Cancel; dispid 1;
  end;

// *********************************************************************//
// Interface: ISWbemServicesEx
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D2F68443-85DC-427E-91D8-366554CC754C}
// *********************************************************************//
  ISWbemServicesEx = interface(ISWbemServices)
    ['{D2F68443-85DC-427E-91D8-366554CC754C}']
    function Put(const objWbemObject: ISWbemObjectEx; iFlags: Integer; 
                 const objWbemNamedValueSet: IDispatch): ISWbemObjectPath; safecall;
    procedure PutAsync(const objWbemSink: ISWbemSink; const objWbemObject: ISWbemObjectEx; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                       const objWbemAsyncContext: IDispatch); safecall;
  end;

// *********************************************************************//
// DispIntf:  ISWbemServicesExDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {D2F68443-85DC-427E-91D8-366554CC754C}
// *********************************************************************//
  ISWbemServicesExDisp = dispinterface
    ['{D2F68443-85DC-427E-91D8-366554CC754C}']
    function Put(const objWbemObject: ISWbemObjectEx; iFlags: Integer; 
                 const objWbemNamedValueSet: IDispatch): ISWbemObjectPath; dispid 20;
    procedure PutAsync(const objWbemSink: ISWbemSink; const objWbemObject: ISWbemObjectEx; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                       const objWbemAsyncContext: IDispatch); dispid 21;
    function Get(const strObjectPath: WideString; iFlags: Integer; 
                 const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 1;
    procedure GetAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                       const objWbemAsyncContext: IDispatch); dispid 2;
    procedure Delete(const strObjectPath: WideString; iFlags: Integer; 
                     const objWbemNamedValueSet: IDispatch); dispid 3;
    procedure DeleteAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                          iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                          const objWbemAsyncContext: IDispatch); dispid 4;
    function InstancesOf(const strClass: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 5;
    procedure InstancesOfAsync(const objWbemSink: IDispatch; const strClass: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 6;
    function SubclassesOf(const strSuperclass: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 7;
    procedure SubclassesOfAsync(const objWbemSink: IDispatch; const strSuperclass: WideString; 
                                iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 8;
    function ExecQuery(const strQuery: WideString; const strQueryLanguage: WideString; 
                       iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 9;
    procedure ExecQueryAsync(const objWbemSink: IDispatch; const strQuery: WideString; 
                             const strQueryLanguage: WideString; lFlags: Integer; 
                             const objWbemNamedValueSet: IDispatch; 
                             const objWbemAsyncContext: IDispatch); dispid 10;
    function AssociatorsOf(const strObjectPath: WideString; const strAssocClass: WideString; 
                           const strResultClass: WideString; const strResultRole: WideString; 
                           const strRole: WideString; bClassesOnly: WordBool; 
                           bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                           const strRequiredQualifier: WideString; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 11;
    procedure AssociatorsOfAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                                 const strAssocClass: WideString; const strResultClass: WideString; 
                                 const strResultRole: WideString; const strRole: WideString; 
                                 bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                 const strRequiredAssocQualifier: WideString; 
                                 const strRequiredQualifier: WideString; iFlags: Integer; 
                                 const objWbemNamedValueSet: IDispatch; 
                                 const objWbemAsyncContext: IDispatch); dispid 12;
    function ReferencesTo(const strObjectPath: WideString; const strResultClass: WideString; 
                          const strRole: WideString; bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 13;
    procedure ReferencesToAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                                const strResultClass: WideString; const strRole: WideString; 
                                bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 14;
    function ExecNotificationQuery(const strQuery: WideString; const strQueryLanguage: WideString; 
                                   iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemEventSource; dispid 15;
    procedure ExecNotificationQueryAsync(const objWbemSink: IDispatch; const strQuery: WideString; 
                                         const strQueryLanguage: WideString; iFlags: Integer; 
                                         const objWbemNamedValueSet: IDispatch; 
                                         const objWbemAsyncContext: IDispatch); dispid 16;
    function ExecMethod(const strObjectPath: WideString; const strMethodName: WideString; 
                        const objWbemInParameters: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 17;
    procedure ExecMethodAsync(const objWbemSink: IDispatch; const strObjectPath: WideString; 
                              const strMethodName: WideString; 
                              const objWbemInParameters: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); dispid 18;
    property Security_: ISWbemSecurity readonly dispid 19;
  end;

// *********************************************************************//
// Interface: ISWbemObjectEx
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {269AD56A-8A67-4129-BC8C-0506DCFE9880}
// *********************************************************************//
  ISWbemObjectEx = interface(ISWbemObject)
    ['{269AD56A-8A67-4129-BC8C-0506DCFE9880}']
    procedure Refresh_(iFlags: Integer; const objWbemNamedValueSet: IDispatch); safecall;
    function Get_SystemProperties_: ISWbemPropertySet; safecall;
    function GetText_(iObjectTextFormat: WbemObjectTextFormatEnum; iFlags: Integer; 
                      const objWbemNamedValueSet: IDispatch): WideString; safecall;
    procedure SetFromText_(const bsText: WideString; iObjectTextFormat: WbemObjectTextFormatEnum; 
                           iFlags: Integer; const objWbemNamedValueSet: IDispatch); safecall;
    property SystemProperties_: ISWbemPropertySet read Get_SystemProperties_;
  end;

// *********************************************************************//
// DispIntf:  ISWbemObjectExDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {269AD56A-8A67-4129-BC8C-0506DCFE9880}
// *********************************************************************//
  ISWbemObjectExDisp = dispinterface
    ['{269AD56A-8A67-4129-BC8C-0506DCFE9880}']
    procedure Refresh_(iFlags: Integer; const objWbemNamedValueSet: IDispatch); dispid 26;
    property SystemProperties_: ISWbemPropertySet readonly dispid 27;
    function GetText_(iObjectTextFormat: WbemObjectTextFormatEnum; iFlags: Integer; 
                      const objWbemNamedValueSet: IDispatch): WideString; dispid 28;
    procedure SetFromText_(const bsText: WideString; iObjectTextFormat: WbemObjectTextFormatEnum; 
                           iFlags: Integer; const objWbemNamedValueSet: IDispatch); dispid 29;
    function Put_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectPath; dispid 1;
    procedure PutAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch; const objWbemAsyncContext: IDispatch); dispid 2;
    procedure Delete_(iFlags: Integer; const objWbemNamedValueSet: IDispatch); dispid 3;
    procedure DeleteAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch; 
                           const objWbemAsyncContext: IDispatch); dispid 4;
    function Instances_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 5;
    procedure InstancesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch); dispid 6;
    function Subclasses_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 7;
    procedure SubclassesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 8;
    function Associators_(const strAssocClass: WideString; const strResultClass: WideString; 
                          const strResultRole: WideString; const strRole: WideString; 
                          bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredAssocQualifier: WideString; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 9;
    procedure AssociatorsAsync_(const objWbemSink: IDispatch; const strAssocClass: WideString; 
                                const strResultClass: WideString; const strResultRole: WideString; 
                                const strRole: WideString; bClassesOnly: WordBool; 
                                bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch); dispid 10;
    function References_(const strResultClass: WideString; const strRole: WideString; 
                         bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                         const strRequiredQualifier: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet; dispid 11;
    procedure ReferencesAsync_(const objWbemSink: IDispatch; const strResultClass: WideString; 
                               const strRole: WideString; bClassesOnly: WordBool; 
                               bSchemaOnly: WordBool; const strRequiredQualifier: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 12;
    function ExecMethod_(const strMethodName: WideString; const objWbemInParameters: IDispatch; 
                         iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObject; dispid 13;
    procedure ExecMethodAsync_(const objWbemSink: IDispatch; const strMethodName: WideString; 
                               const objWbemInParameters: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch); dispid 14;
    function Clone_: ISWbemObject; dispid 15;
    function GetObjectText_(iFlags: Integer): WideString; dispid 16;
    function SpawnDerivedClass_(iFlags: Integer): ISWbemObject; dispid 17;
    function SpawnInstance_(iFlags: Integer): ISWbemObject; dispid 18;
    function CompareTo_(const objWbemObject: IDispatch; iFlags: Integer): WordBool; dispid 19;
    property Qualifiers_: ISWbemQualifierSet readonly dispid 20;
    property Properties_: ISWbemPropertySet readonly dispid 21;
    property Methods_: ISWbemMethodSet readonly dispid 22;
    property Derivation_: OleVariant readonly dispid 23;
    property Path_: ISWbemObjectPath readonly dispid 24;
    property Security_: ISWbemSecurity readonly dispid 25;
  end;

// *********************************************************************//
// Interface: ISWbemDateTime
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5E97458A-CF77-11D3-B38F-00105A1F473A}
// *********************************************************************//
  ISWbemDateTime = interface(IDispatch)
    ['{5E97458A-CF77-11D3-B38F-00105A1F473A}']
    function Get_Value: WideString; safecall;
    procedure Set_Value(const strValue: WideString); safecall;
    function Get_Year: Integer; safecall;
    procedure Set_Year(iYear: Integer); safecall;
    function Get_YearSpecified: WordBool; safecall;
    procedure Set_YearSpecified(bYearSpecified: WordBool); safecall;
    function Get_Month: Integer; safecall;
    procedure Set_Month(iMonth: Integer); safecall;
    function Get_MonthSpecified: WordBool; safecall;
    procedure Set_MonthSpecified(bMonthSpecified: WordBool); safecall;
    function Get_Day: Integer; safecall;
    procedure Set_Day(iDay: Integer); safecall;
    function Get_DaySpecified: WordBool; safecall;
    procedure Set_DaySpecified(bDaySpecified: WordBool); safecall;
    function Get_Hours: Integer; safecall;
    procedure Set_Hours(iHours: Integer); safecall;
    function Get_HoursSpecified: WordBool; safecall;
    procedure Set_HoursSpecified(bHoursSpecified: WordBool); safecall;
    function Get_Minutes: Integer; safecall;
    procedure Set_Minutes(iMinutes: Integer); safecall;
    function Get_MinutesSpecified: WordBool; safecall;
    procedure Set_MinutesSpecified(bMinutesSpecified: WordBool); safecall;
    function Get_Seconds: Integer; safecall;
    procedure Set_Seconds(iSeconds: Integer); safecall;
    function Get_SecondsSpecified: WordBool; safecall;
    procedure Set_SecondsSpecified(bSecondsSpecified: WordBool); safecall;
    function Get_Microseconds: Integer; safecall;
    procedure Set_Microseconds(iMicroseconds: Integer); safecall;
    function Get_MicrosecondsSpecified: WordBool; safecall;
    procedure Set_MicrosecondsSpecified(bMicrosecondsSpecified: WordBool); safecall;
    function Get_UTC: Integer; safecall;
    procedure Set_UTC(iUTC: Integer); safecall;
    function Get_UTCSpecified: WordBool; safecall;
    procedure Set_UTCSpecified(bUTCSpecified: WordBool); safecall;
    function Get_IsInterval: WordBool; safecall;
    procedure Set_IsInterval(bIsInterval: WordBool); safecall;
    function GetVarDate(bIsLocal: WordBool): TDateTime; safecall;
    procedure SetVarDate(dVarDate: TDateTime; bIsLocal: WordBool); safecall;
    function GetFileTime(bIsLocal: WordBool): WideString; safecall;
    procedure SetFileTime(const strFileTime: WideString; bIsLocal: WordBool); safecall;
    property Value: WideString read Get_Value write Set_Value;
    property Year: Integer read Get_Year write Set_Year;
    property YearSpecified: WordBool read Get_YearSpecified write Set_YearSpecified;
    property Month: Integer read Get_Month write Set_Month;
    property MonthSpecified: WordBool read Get_MonthSpecified write Set_MonthSpecified;
    property Day: Integer read Get_Day write Set_Day;
    property DaySpecified: WordBool read Get_DaySpecified write Set_DaySpecified;
    property Hours: Integer read Get_Hours write Set_Hours;
    property HoursSpecified: WordBool read Get_HoursSpecified write Set_HoursSpecified;
    property Minutes: Integer read Get_Minutes write Set_Minutes;
    property MinutesSpecified: WordBool read Get_MinutesSpecified write Set_MinutesSpecified;
    property Seconds: Integer read Get_Seconds write Set_Seconds;
    property SecondsSpecified: WordBool read Get_SecondsSpecified write Set_SecondsSpecified;
    property Microseconds: Integer read Get_Microseconds write Set_Microseconds;
    property MicrosecondsSpecified: WordBool read Get_MicrosecondsSpecified write Set_MicrosecondsSpecified;
    property UTC: Integer read Get_UTC write Set_UTC;
    property UTCSpecified: WordBool read Get_UTCSpecified write Set_UTCSpecified;
    property IsInterval: WordBool read Get_IsInterval write Set_IsInterval;
  end;

// *********************************************************************//
// DispIntf:  ISWbemDateTimeDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5E97458A-CF77-11D3-B38F-00105A1F473A}
// *********************************************************************//
  ISWbemDateTimeDisp = dispinterface
    ['{5E97458A-CF77-11D3-B38F-00105A1F473A}']
    property Value: WideString dispid 0;
    property Year: Integer dispid 1;
    property YearSpecified: WordBool dispid 2;
    property Month: Integer dispid 3;
    property MonthSpecified: WordBool dispid 4;
    property Day: Integer dispid 5;
    property DaySpecified: WordBool dispid 6;
    property Hours: Integer dispid 7;
    property HoursSpecified: WordBool dispid 8;
    property Minutes: Integer dispid 9;
    property MinutesSpecified: WordBool dispid 10;
    property Seconds: Integer dispid 11;
    property SecondsSpecified: WordBool dispid 12;
    property Microseconds: Integer dispid 13;
    property MicrosecondsSpecified: WordBool dispid 14;
    property UTC: Integer dispid 15;
    property UTCSpecified: WordBool dispid 16;
    property IsInterval: WordBool dispid 17;
    function GetVarDate(bIsLocal: WordBool): TDateTime; dispid 18;
    procedure SetVarDate(dVarDate: TDateTime; bIsLocal: WordBool); dispid 19;
    function GetFileTime(bIsLocal: WordBool): WideString; dispid 20;
    procedure SetFileTime(const strFileTime: WideString; bIsLocal: WordBool); dispid 21;
  end;

// *********************************************************************//
// Interface: ISWbemRefresher
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {14D8250E-D9C2-11D3-B38F-00105A1F473A}
// *********************************************************************//
  ISWbemRefresher = interface(IDispatch)
    ['{14D8250E-D9C2-11D3-B38F-00105A1F473A}']
    function Get__NewEnum: IUnknown; safecall;
    function Item(iIndex: Integer): ISWbemRefreshableItem; safecall;
    function Get_Count: Integer; safecall;
    function Add(const objWbemServices: ISWbemServicesEx; const bsInstancePath: WideString; 
                 iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem; safecall;
    function AddEnum(const objWbemServices: ISWbemServicesEx; const bsClassName: WideString; 
                     iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem; safecall;
    procedure Remove(iIndex: Integer; iFlags: Integer); safecall;
    procedure Refresh(iFlags: Integer); safecall;
    function Get_AutoReconnect: WordBool; safecall;
    procedure Set_AutoReconnect(bCount: WordBool); safecall;
    procedure DeleteAll; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Count: Integer read Get_Count;
    property AutoReconnect: WordBool read Get_AutoReconnect write Set_AutoReconnect;
  end;

// *********************************************************************//
// DispIntf:  ISWbemRefresherDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {14D8250E-D9C2-11D3-B38F-00105A1F473A}
// *********************************************************************//
  ISWbemRefresherDisp = dispinterface
    ['{14D8250E-D9C2-11D3-B38F-00105A1F473A}']
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(iIndex: Integer): ISWbemRefreshableItem; dispid 0;
    property Count: Integer readonly dispid 1;
    function Add(const objWbemServices: ISWbemServicesEx; const bsInstancePath: WideString; 
                 iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem; dispid 2;
    function AddEnum(const objWbemServices: ISWbemServicesEx; const bsClassName: WideString; 
                     iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem; dispid 3;
    procedure Remove(iIndex: Integer; iFlags: Integer); dispid 4;
    procedure Refresh(iFlags: Integer); dispid 5;
    property AutoReconnect: WordBool dispid 6;
    procedure DeleteAll; dispid 7;
  end;

// *********************************************************************//
// Interface: ISWbemRefreshableItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5AD4BF92-DAAB-11D3-B38F-00105A1F473A}
// *********************************************************************//
  ISWbemRefreshableItem = interface(IDispatch)
    ['{5AD4BF92-DAAB-11D3-B38F-00105A1F473A}']
    function Get_Index: Integer; safecall;
    function Get_Refresher: ISWbemRefresher; safecall;
    function Get_IsSet: WordBool; safecall;
    function Get_Object_: ISWbemObjectEx; safecall;
    function Get_ObjectSet: ISWbemObjectSet; safecall;
    procedure Remove(iFlags: Integer); safecall;
    property Index: Integer read Get_Index;
    property Refresher: ISWbemRefresher read Get_Refresher;
    property IsSet: WordBool read Get_IsSet;
    property Object_: ISWbemObjectEx read Get_Object_;
    property ObjectSet: ISWbemObjectSet read Get_ObjectSet;
  end;

// *********************************************************************//
// DispIntf:  ISWbemRefreshableItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {5AD4BF92-DAAB-11D3-B38F-00105A1F473A}
// *********************************************************************//
  ISWbemRefreshableItemDisp = dispinterface
    ['{5AD4BF92-DAAB-11D3-B38F-00105A1F473A}']
    property Index: Integer readonly dispid 1;
    property Refresher: ISWbemRefresher readonly dispid 2;
    property IsSet: WordBool readonly dispid 3;
    property Object_: ISWbemObjectEx readonly dispid 4;
    property ObjectSet: ISWbemObjectSet readonly dispid 5;
    procedure Remove(iFlags: Integer); dispid 6;
  end;

// *********************************************************************//
// The Class CoSWbemLocator provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemLocator exposed by              
// the CoClass SWbemLocator. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemLocator = class
    class function Create: ISWbemLocator;
    class function CreateRemote(const MachineName: string): ISWbemLocator;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemLocator
// Help String      : Used to obtain Namespace connections
// Default Interface: ISWbemLocator
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemLocatorProperties= class;
{$ENDIF}
  TSWbemLocator = class(TOleServer)
  private
    FIntf: ISWbemLocator;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemLocatorProperties;
    function GetServerProperties: TSWbemLocatorProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemLocator;
  protected
    procedure InitServerData; override;
    function Get_Security_: ISWbemSecurity;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemLocator);
    procedure Disconnect; override;
    function ConnectServer(const strServer: WideString; const strNamespace: WideString; 
                           const strUser: WideString; const strPassword: WideString; 
                           const strLocale: WideString; const strAuthority: WideString; 
                           iSecurityFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemServices;
    property DefaultInterface: ISWbemLocator read GetDefaultInterface;
    property Security_: ISWbemSecurity read Get_Security_;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemLocatorProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemLocator
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemLocatorProperties = class(TPersistent)
  private
    FServer:    TSWbemLocator;
    function    GetDefaultInterface: ISWbemLocator;
    constructor Create(AServer: TSWbemLocator);
  protected
    function Get_Security_: ISWbemSecurity;
  public
    property DefaultInterface: ISWbemLocator read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemNamedValueSet provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemNamedValueSet exposed by              
// the CoClass SWbemNamedValueSet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemNamedValueSet = class
    class function Create: ISWbemNamedValueSet;
    class function CreateRemote(const MachineName: string): ISWbemNamedValueSet;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemNamedValueSet
// Help String      : A collection of Named Values
// Default Interface: ISWbemNamedValueSet
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemNamedValueSetProperties= class;
{$ENDIF}
  TSWbemNamedValueSet = class(TOleServer)
  private
    FIntf: ISWbemNamedValueSet;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemNamedValueSetProperties;
    function GetServerProperties: TSWbemNamedValueSetProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemNamedValueSet;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemNamedValueSet);
    procedure Disconnect; override;
    function Item(const strName: WideString; iFlags: Integer): ISWbemNamedValue;
    function Add(const strName: WideString; var varValue: OleVariant; iFlags: Integer): ISWbemNamedValue;
    procedure Remove(const strName: WideString; iFlags: Integer);
    function Clone: ISWbemNamedValueSet;
    procedure DeleteAll;
    property DefaultInterface: ISWbemNamedValueSet read GetDefaultInterface;
    property Count: Integer read Get_Count;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemNamedValueSetProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemNamedValueSet
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemNamedValueSetProperties = class(TPersistent)
  private
    FServer:    TSWbemNamedValueSet;
    function    GetDefaultInterface: ISWbemNamedValueSet;
    constructor Create(AServer: TSWbemNamedValueSet);
  protected
    function Get_Count: Integer;
  public
    property DefaultInterface: ISWbemNamedValueSet read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemObjectPath provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemObjectPath exposed by              
// the CoClass SWbemObjectPath. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemObjectPath = class
    class function Create: ISWbemObjectPath;
    class function CreateRemote(const MachineName: string): ISWbemObjectPath;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemObjectPath
// Help String      : Object Path
// Default Interface: ISWbemObjectPath
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemObjectPathProperties= class;
{$ENDIF}
  TSWbemObjectPath = class(TOleServer)
  private
    FIntf: ISWbemObjectPath;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemObjectPathProperties;
    function GetServerProperties: TSWbemObjectPathProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemObjectPath;
  protected
    procedure InitServerData; override;
    function Get_Path: WideString;
    procedure Set_Path(const strPath: WideString);
    function Get_RelPath: WideString;
    procedure Set_RelPath(const strRelPath: WideString);
    function Get_Server: WideString;
    procedure Set_Server(const strServer: WideString);
    function Get_Namespace: WideString;
    procedure Set_Namespace(const strNamespace: WideString);
    function Get_ParentNamespace: WideString;
    function Get_DisplayName: WideString;
    procedure Set_DisplayName(const strDisplayName: WideString);
    function Get_Class_: WideString;
    procedure Set_Class_(const strClass: WideString);
    function Get_IsClass: WordBool;
    function Get_IsSingleton: WordBool;
    function Get_Keys: ISWbemNamedValueSet;
    function Get_Security_: ISWbemSecurity;
    function Get_Locale: WideString;
    procedure Set_Locale(const strLocale: WideString);
    function Get_Authority: WideString;
    procedure Set_Authority(const strAuthority: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemObjectPath);
    procedure Disconnect; override;
    procedure SetAsClass;
    procedure SetAsSingleton;
    property DefaultInterface: ISWbemObjectPath read GetDefaultInterface;
    property ParentNamespace: WideString read Get_ParentNamespace;
    property IsClass: WordBool read Get_IsClass;
    property IsSingleton: WordBool read Get_IsSingleton;
    property Keys: ISWbemNamedValueSet read Get_Keys;
    property Security_: ISWbemSecurity read Get_Security_;
    property Path: WideString read Get_Path write Set_Path;
    property RelPath: WideString read Get_RelPath write Set_RelPath;
    property Server: WideString read Get_Server write Set_Server;
    property Namespace: WideString read Get_Namespace write Set_Namespace;
    property DisplayName: WideString read Get_DisplayName write Set_DisplayName;
    property Class_: WideString read Get_Class_ write Set_Class_;
    property Locale: WideString read Get_Locale write Set_Locale;
    property Authority: WideString read Get_Authority write Set_Authority;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemObjectPathProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemObjectPath
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemObjectPathProperties = class(TPersistent)
  private
    FServer:    TSWbemObjectPath;
    function    GetDefaultInterface: ISWbemObjectPath;
    constructor Create(AServer: TSWbemObjectPath);
  protected
    function Get_Path: WideString;
    procedure Set_Path(const strPath: WideString);
    function Get_RelPath: WideString;
    procedure Set_RelPath(const strRelPath: WideString);
    function Get_Server: WideString;
    procedure Set_Server(const strServer: WideString);
    function Get_Namespace: WideString;
    procedure Set_Namespace(const strNamespace: WideString);
    function Get_ParentNamespace: WideString;
    function Get_DisplayName: WideString;
    procedure Set_DisplayName(const strDisplayName: WideString);
    function Get_Class_: WideString;
    procedure Set_Class_(const strClass: WideString);
    function Get_IsClass: WordBool;
    function Get_IsSingleton: WordBool;
    function Get_Keys: ISWbemNamedValueSet;
    function Get_Security_: ISWbemSecurity;
    function Get_Locale: WideString;
    procedure Set_Locale(const strLocale: WideString);
    function Get_Authority: WideString;
    procedure Set_Authority(const strAuthority: WideString);
  public
    property DefaultInterface: ISWbemObjectPath read GetDefaultInterface;
  published
    property Path: WideString read Get_Path write Set_Path;
    property RelPath: WideString read Get_RelPath write Set_RelPath;
    property Server: WideString read Get_Server write Set_Server;
    property Namespace: WideString read Get_Namespace write Set_Namespace;
    property DisplayName: WideString read Get_DisplayName write Set_DisplayName;
    property Class_: WideString read Get_Class_ write Set_Class_;
    property Locale: WideString read Get_Locale write Set_Locale;
    property Authority: WideString read Get_Authority write Set_Authority;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemLastError provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemLastError exposed by              
// the CoClass SWbemLastError. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemLastError = class
    class function Create: ISWbemLastError;
    class function CreateRemote(const MachineName: string): ISWbemLastError;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemLastError
// Help String      : The last error on the current thread
// Default Interface: ISWbemLastError
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemLastErrorProperties= class;
{$ENDIF}
  TSWbemLastError = class(TOleServer)
  private
    FIntf: ISWbemLastError;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemLastErrorProperties;
    function GetServerProperties: TSWbemLastErrorProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemLastError;
  protected
    procedure InitServerData; override;
    function Get_Qualifiers_: ISWbemQualifierSet;
    function Get_Properties_: ISWbemPropertySet;
    function Get_Methods_: ISWbemMethodSet;
    function Get_Derivation_: OleVariant;
    function Get_Path_: ISWbemObjectPath;
    function Get_Security_: ISWbemSecurity;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemLastError);
    procedure Disconnect; override;
    function Put_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectPath;
    procedure PutAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                        const objWbemNamedValueSet: IDispatch; const objWbemAsyncContext: IDispatch);
    procedure Delete_(iFlags: Integer; const objWbemNamedValueSet: IDispatch);
    procedure DeleteAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                           const objWbemNamedValueSet: IDispatch; 
                           const objWbemAsyncContext: IDispatch);
    function Instances_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
    procedure InstancesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                              const objWbemNamedValueSet: IDispatch; 
                              const objWbemAsyncContext: IDispatch);
    function Subclasses_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
    procedure SubclassesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch);
    function Associators_(const strAssocClass: WideString; const strResultClass: WideString; 
                          const strResultRole: WideString; const strRole: WideString; 
                          bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                          const strRequiredAssocQualifier: WideString; 
                          const strRequiredQualifier: WideString; iFlags: Integer; 
                          const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
    procedure AssociatorsAsync_(const objWbemSink: IDispatch; const strAssocClass: WideString; 
                                const strResultClass: WideString; const strResultRole: WideString; 
                                const strRole: WideString; bClassesOnly: WordBool; 
                                bSchemaOnly: WordBool; const strRequiredAssocQualifier: WideString; 
                                const strRequiredQualifier: WideString; iFlags: Integer; 
                                const objWbemNamedValueSet: IDispatch; 
                                const objWbemAsyncContext: IDispatch);
    function References_(const strResultClass: WideString; const strRole: WideString; 
                         bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                         const strRequiredQualifier: WideString; iFlags: Integer; 
                         const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
    procedure ReferencesAsync_(const objWbemSink: IDispatch; const strResultClass: WideString; 
                               const strRole: WideString; bClassesOnly: WordBool; 
                               bSchemaOnly: WordBool; const strRequiredQualifier: WideString; 
                               iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch);
    function ExecMethod_(const strMethodName: WideString; const objWbemInParameters: IDispatch; 
                         iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObject;
    procedure ExecMethodAsync_(const objWbemSink: IDispatch; const strMethodName: WideString; 
                               const objWbemInParameters: IDispatch; iFlags: Integer; 
                               const objWbemNamedValueSet: IDispatch; 
                               const objWbemAsyncContext: IDispatch);
    function Clone_: ISWbemObject;
    function GetObjectText_(iFlags: Integer): WideString;
    function SpawnDerivedClass_(iFlags: Integer): ISWbemObject;
    function SpawnInstance_(iFlags: Integer): ISWbemObject;
    function CompareTo_(const objWbemObject: IDispatch; iFlags: Integer): WordBool;
    property DefaultInterface: ISWbemLastError read GetDefaultInterface;
    property Qualifiers_: ISWbemQualifierSet read Get_Qualifiers_;
    property Properties_: ISWbemPropertySet read Get_Properties_;
    property Methods_: ISWbemMethodSet read Get_Methods_;
    property Derivation_: OleVariant read Get_Derivation_;
    property Path_: ISWbemObjectPath read Get_Path_;
    property Security_: ISWbemSecurity read Get_Security_;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemLastErrorProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemLastError
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemLastErrorProperties = class(TPersistent)
  private
    FServer:    TSWbemLastError;
    function    GetDefaultInterface: ISWbemLastError;
    constructor Create(AServer: TSWbemLastError);
  protected
    function Get_Qualifiers_: ISWbemQualifierSet;
    function Get_Properties_: ISWbemPropertySet;
    function Get_Methods_: ISWbemMethodSet;
    function Get_Derivation_: OleVariant;
    function Get_Path_: ISWbemObjectPath;
    function Get_Security_: ISWbemSecurity;
  public
    property DefaultInterface: ISWbemLastError read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemSink provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemSink exposed by              
// the CoClass SWbemSink. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemSink = class
    class function Create: ISWbemSink;
    class function CreateRemote(const MachineName: string): ISWbemSink;
  end;

  TSWbemSinkOnObjectReady = procedure(ASender: TObject; const objWbemObject: ISWbemObject; 
                                                        const objWbemAsyncContext: ISWbemNamedValueSet) of object;
  TSWbemSinkOnCompleted = procedure(ASender: TObject; iHResult: WbemErrorEnum; 
                                                      const objWbemErrorObject: ISWbemObject; 
                                                      const objWbemAsyncContext: ISWbemNamedValueSet) of object;
  TSWbemSinkOnProgress = procedure(ASender: TObject; iUpperBound: Integer; iCurrent: Integer; 
                                                     const strMessage: WideString; 
                                                     const objWbemAsyncContext: ISWbemNamedValueSet) of object;
  TSWbemSinkOnObjectPut = procedure(ASender: TObject; const objWbemObjectPath: ISWbemObjectPath; 
                                                      const objWbemAsyncContext: ISWbemNamedValueSet) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemSink
// Help String      : A sink for events arising from asynchronous operations
// Default Interface: ISWbemSink
// Def. Intf. DISP? : No
// Event   Interface: ISWbemSinkEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemSinkProperties= class;
{$ENDIF}
  TSWbemSink = class(TOleServer)
  private
    FOnObjectReady: TSWbemSinkOnObjectReady;
    FOnCompleted: TSWbemSinkOnCompleted;
    FOnProgress: TSWbemSinkOnProgress;
    FOnObjectPut: TSWbemSinkOnObjectPut;
    FIntf: ISWbemSink;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemSinkProperties;
    function GetServerProperties: TSWbemSinkProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemSink;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemSink);
    procedure Disconnect; override;
    procedure Cancel;
    property DefaultInterface: ISWbemSink read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemSinkProperties read GetServerProperties;
{$ENDIF}
    property OnObjectReady: TSWbemSinkOnObjectReady read FOnObjectReady write FOnObjectReady;
    property OnCompleted: TSWbemSinkOnCompleted read FOnCompleted write FOnCompleted;
    property OnProgress: TSWbemSinkOnProgress read FOnProgress write FOnProgress;
    property OnObjectPut: TSWbemSinkOnObjectPut read FOnObjectPut write FOnObjectPut;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemSink
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemSinkProperties = class(TPersistent)
  private
    FServer:    TSWbemSink;
    function    GetDefaultInterface: ISWbemSink;
    constructor Create(AServer: TSWbemSink);
  protected
  public
    property DefaultInterface: ISWbemSink read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemDateTime provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemDateTime exposed by              
// the CoClass SWbemDateTime. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemDateTime = class
    class function Create: ISWbemDateTime;
    class function CreateRemote(const MachineName: string): ISWbemDateTime;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemDateTime
// Help String      : Date & Time
// Default Interface: ISWbemDateTime
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemDateTimeProperties= class;
{$ENDIF}
  TSWbemDateTime = class(TOleServer)
  private
    FIntf: ISWbemDateTime;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemDateTimeProperties;
    function GetServerProperties: TSWbemDateTimeProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemDateTime;
  protected
    procedure InitServerData; override;
    function Get_Value: WideString;
    procedure Set_Value(const strValue: WideString);
    function Get_Year: Integer;
    procedure Set_Year(iYear: Integer);
    function Get_YearSpecified: WordBool;
    procedure Set_YearSpecified(bYearSpecified: WordBool);
    function Get_Month: Integer;
    procedure Set_Month(iMonth: Integer);
    function Get_MonthSpecified: WordBool;
    procedure Set_MonthSpecified(bMonthSpecified: WordBool);
    function Get_Day: Integer;
    procedure Set_Day(iDay: Integer);
    function Get_DaySpecified: WordBool;
    procedure Set_DaySpecified(bDaySpecified: WordBool);
    function Get_Hours: Integer;
    procedure Set_Hours(iHours: Integer);
    function Get_HoursSpecified: WordBool;
    procedure Set_HoursSpecified(bHoursSpecified: WordBool);
    function Get_Minutes: Integer;
    procedure Set_Minutes(iMinutes: Integer);
    function Get_MinutesSpecified: WordBool;
    procedure Set_MinutesSpecified(bMinutesSpecified: WordBool);
    function Get_Seconds: Integer;
    procedure Set_Seconds(iSeconds: Integer);
    function Get_SecondsSpecified: WordBool;
    procedure Set_SecondsSpecified(bSecondsSpecified: WordBool);
    function Get_Microseconds: Integer;
    procedure Set_Microseconds(iMicroseconds: Integer);
    function Get_MicrosecondsSpecified: WordBool;
    procedure Set_MicrosecondsSpecified(bMicrosecondsSpecified: WordBool);
    function Get_UTC: Integer;
    procedure Set_UTC(iUTC: Integer);
    function Get_UTCSpecified: WordBool;
    procedure Set_UTCSpecified(bUTCSpecified: WordBool);
    function Get_IsInterval: WordBool;
    procedure Set_IsInterval(bIsInterval: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemDateTime);
    procedure Disconnect; override;
    function GetVarDate(bIsLocal: WordBool): TDateTime;
    procedure SetVarDate(dVarDate: TDateTime; bIsLocal: WordBool);
    function GetFileTime(bIsLocal: WordBool): WideString;
    procedure SetFileTime(const strFileTime: WideString; bIsLocal: WordBool);
    property DefaultInterface: ISWbemDateTime read GetDefaultInterface;
    property Value: WideString read Get_Value write Set_Value;
    property Year: Integer read Get_Year write Set_Year;
    property YearSpecified: WordBool read Get_YearSpecified write Set_YearSpecified;
    property Month: Integer read Get_Month write Set_Month;
    property MonthSpecified: WordBool read Get_MonthSpecified write Set_MonthSpecified;
    property Day: Integer read Get_Day write Set_Day;
    property DaySpecified: WordBool read Get_DaySpecified write Set_DaySpecified;
    property Hours: Integer read Get_Hours write Set_Hours;
    property HoursSpecified: WordBool read Get_HoursSpecified write Set_HoursSpecified;
    property Minutes: Integer read Get_Minutes write Set_Minutes;
    property MinutesSpecified: WordBool read Get_MinutesSpecified write Set_MinutesSpecified;
    property Seconds: Integer read Get_Seconds write Set_Seconds;
    property SecondsSpecified: WordBool read Get_SecondsSpecified write Set_SecondsSpecified;
    property Microseconds: Integer read Get_Microseconds write Set_Microseconds;
    property MicrosecondsSpecified: WordBool read Get_MicrosecondsSpecified write Set_MicrosecondsSpecified;
    property UTC: Integer read Get_UTC write Set_UTC;
    property UTCSpecified: WordBool read Get_UTCSpecified write Set_UTCSpecified;
    property IsInterval: WordBool read Get_IsInterval write Set_IsInterval;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemDateTimeProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemDateTime
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemDateTimeProperties = class(TPersistent)
  private
    FServer:    TSWbemDateTime;
    function    GetDefaultInterface: ISWbemDateTime;
    constructor Create(AServer: TSWbemDateTime);
  protected
    function Get_Value: WideString;
    procedure Set_Value(const strValue: WideString);
    function Get_Year: Integer;
    procedure Set_Year(iYear: Integer);
    function Get_YearSpecified: WordBool;
    procedure Set_YearSpecified(bYearSpecified: WordBool);
    function Get_Month: Integer;
    procedure Set_Month(iMonth: Integer);
    function Get_MonthSpecified: WordBool;
    procedure Set_MonthSpecified(bMonthSpecified: WordBool);
    function Get_Day: Integer;
    procedure Set_Day(iDay: Integer);
    function Get_DaySpecified: WordBool;
    procedure Set_DaySpecified(bDaySpecified: WordBool);
    function Get_Hours: Integer;
    procedure Set_Hours(iHours: Integer);
    function Get_HoursSpecified: WordBool;
    procedure Set_HoursSpecified(bHoursSpecified: WordBool);
    function Get_Minutes: Integer;
    procedure Set_Minutes(iMinutes: Integer);
    function Get_MinutesSpecified: WordBool;
    procedure Set_MinutesSpecified(bMinutesSpecified: WordBool);
    function Get_Seconds: Integer;
    procedure Set_Seconds(iSeconds: Integer);
    function Get_SecondsSpecified: WordBool;
    procedure Set_SecondsSpecified(bSecondsSpecified: WordBool);
    function Get_Microseconds: Integer;
    procedure Set_Microseconds(iMicroseconds: Integer);
    function Get_MicrosecondsSpecified: WordBool;
    procedure Set_MicrosecondsSpecified(bMicrosecondsSpecified: WordBool);
    function Get_UTC: Integer;
    procedure Set_UTC(iUTC: Integer);
    function Get_UTCSpecified: WordBool;
    procedure Set_UTCSpecified(bUTCSpecified: WordBool);
    function Get_IsInterval: WordBool;
    procedure Set_IsInterval(bIsInterval: WordBool);
  public
    property DefaultInterface: ISWbemDateTime read GetDefaultInterface;
  published
    property Value: WideString read Get_Value write Set_Value;
    property Year: Integer read Get_Year write Set_Year;
    property YearSpecified: WordBool read Get_YearSpecified write Set_YearSpecified;
    property Month: Integer read Get_Month write Set_Month;
    property MonthSpecified: WordBool read Get_MonthSpecified write Set_MonthSpecified;
    property Day: Integer read Get_Day write Set_Day;
    property DaySpecified: WordBool read Get_DaySpecified write Set_DaySpecified;
    property Hours: Integer read Get_Hours write Set_Hours;
    property HoursSpecified: WordBool read Get_HoursSpecified write Set_HoursSpecified;
    property Minutes: Integer read Get_Minutes write Set_Minutes;
    property MinutesSpecified: WordBool read Get_MinutesSpecified write Set_MinutesSpecified;
    property Seconds: Integer read Get_Seconds write Set_Seconds;
    property SecondsSpecified: WordBool read Get_SecondsSpecified write Set_SecondsSpecified;
    property Microseconds: Integer read Get_Microseconds write Set_Microseconds;
    property MicrosecondsSpecified: WordBool read Get_MicrosecondsSpecified write Set_MicrosecondsSpecified;
    property UTC: Integer read Get_UTC write Set_UTC;
    property UTCSpecified: WordBool read Get_UTCSpecified write Set_UTCSpecified;
    property IsInterval: WordBool read Get_IsInterval write Set_IsInterval;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemRefresher provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemRefresher exposed by              
// the CoClass SWbemRefresher. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemRefresher = class
    class function Create: ISWbemRefresher;
    class function CreateRemote(const MachineName: string): ISWbemRefresher;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSWbemRefresher
// Help String      : Refresher
// Default Interface: ISWbemRefresher
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSWbemRefresherProperties= class;
{$ENDIF}
  TSWbemRefresher = class(TOleServer)
  private
    FIntf: ISWbemRefresher;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TSWbemRefresherProperties;
    function GetServerProperties: TSWbemRefresherProperties;
{$ENDIF}
    function GetDefaultInterface: ISWbemRefresher;
  protected
    procedure InitServerData; override;
    function Get_Count: Integer;
    function Get_AutoReconnect: WordBool;
    procedure Set_AutoReconnect(bCount: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISWbemRefresher);
    procedure Disconnect; override;
    function Item(iIndex: Integer): ISWbemRefreshableItem;
    function Add(const objWbemServices: ISWbemServicesEx; const bsInstancePath: WideString; 
                 iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem;
    function AddEnum(const objWbemServices: ISWbemServicesEx; const bsClassName: WideString; 
                     iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem;
    procedure Remove(iIndex: Integer; iFlags: Integer);
    procedure Refresh(iFlags: Integer);
    procedure DeleteAll;
    property DefaultInterface: ISWbemRefresher read GetDefaultInterface;
    property Count: Integer read Get_Count;
    property AutoReconnect: WordBool read Get_AutoReconnect write Set_AutoReconnect;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSWbemRefresherProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSWbemRefresher
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSWbemRefresherProperties = class(TPersistent)
  private
    FServer:    TSWbemRefresher;
    function    GetDefaultInterface: ISWbemRefresher;
    constructor Create(AServer: TSWbemRefresher);
  protected
    function Get_Count: Integer;
    function Get_AutoReconnect: WordBool;
    procedure Set_AutoReconnect(bCount: WordBool);
  public
    property DefaultInterface: ISWbemRefresher read GetDefaultInterface;
  published
    property AutoReconnect: WordBool read Get_AutoReconnect write Set_AutoReconnect;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSWbemServices provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemServices exposed by              
// the CoClass SWbemServices. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemServices = class
    class function Create: ISWbemServices;
    class function CreateRemote(const MachineName: string): ISWbemServices;
  end;

// *********************************************************************//
// The Class CoSWbemServicesEx provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemServicesEx exposed by              
// the CoClass SWbemServicesEx. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemServicesEx = class
    class function Create: ISWbemServicesEx;
    class function CreateRemote(const MachineName: string): ISWbemServicesEx;
  end;

// *********************************************************************//
// The Class CoSWbemObject provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemObject exposed by              
// the CoClass SWbemObject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemObject = class
    class function Create: ISWbemObject;
    class function CreateRemote(const MachineName: string): ISWbemObject;
  end;

// *********************************************************************//
// The Class CoSWbemObjectEx provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemObjectEx exposed by              
// the CoClass SWbemObjectEx. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemObjectEx = class
    class function Create: ISWbemObjectEx;
    class function CreateRemote(const MachineName: string): ISWbemObjectEx;
  end;

// *********************************************************************//
// The Class CoSWbemObjectSet provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemObjectSet exposed by              
// the CoClass SWbemObjectSet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemObjectSet = class
    class function Create: ISWbemObjectSet;
    class function CreateRemote(const MachineName: string): ISWbemObjectSet;
  end;

// *********************************************************************//
// The Class CoSWbemNamedValue provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemNamedValue exposed by              
// the CoClass SWbemNamedValue. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemNamedValue = class
    class function Create: ISWbemNamedValue;
    class function CreateRemote(const MachineName: string): ISWbemNamedValue;
  end;

// *********************************************************************//
// The Class CoSWbemQualifier provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemQualifier exposed by              
// the CoClass SWbemQualifier. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemQualifier = class
    class function Create: ISWbemQualifier;
    class function CreateRemote(const MachineName: string): ISWbemQualifier;
  end;

// *********************************************************************//
// The Class CoSWbemQualifierSet provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemQualifierSet exposed by              
// the CoClass SWbemQualifierSet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemQualifierSet = class
    class function Create: ISWbemQualifierSet;
    class function CreateRemote(const MachineName: string): ISWbemQualifierSet;
  end;

// *********************************************************************//
// The Class CoSWbemProperty provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemProperty exposed by              
// the CoClass SWbemProperty. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemProperty = class
    class function Create: ISWbemProperty;
    class function CreateRemote(const MachineName: string): ISWbemProperty;
  end;

// *********************************************************************//
// The Class CoSWbemPropertySet provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemPropertySet exposed by              
// the CoClass SWbemPropertySet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemPropertySet = class
    class function Create: ISWbemPropertySet;
    class function CreateRemote(const MachineName: string): ISWbemPropertySet;
  end;

// *********************************************************************//
// The Class CoSWbemMethod provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemMethod exposed by              
// the CoClass SWbemMethod. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemMethod = class
    class function Create: ISWbemMethod;
    class function CreateRemote(const MachineName: string): ISWbemMethod;
  end;

// *********************************************************************//
// The Class CoSWbemMethodSet provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemMethodSet exposed by              
// the CoClass SWbemMethodSet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemMethodSet = class
    class function Create: ISWbemMethodSet;
    class function CreateRemote(const MachineName: string): ISWbemMethodSet;
  end;

// *********************************************************************//
// The Class CoSWbemEventSource provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemEventSource exposed by              
// the CoClass SWbemEventSource. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemEventSource = class
    class function Create: ISWbemEventSource;
    class function CreateRemote(const MachineName: string): ISWbemEventSource;
  end;

// *********************************************************************//
// The Class CoSWbemSecurity provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemSecurity exposed by              
// the CoClass SWbemSecurity. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemSecurity = class
    class function Create: ISWbemSecurity;
    class function CreateRemote(const MachineName: string): ISWbemSecurity;
  end;

// *********************************************************************//
// The Class CoSWbemPrivilege provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemPrivilege exposed by              
// the CoClass SWbemPrivilege. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemPrivilege = class
    class function Create: ISWbemPrivilege;
    class function CreateRemote(const MachineName: string): ISWbemPrivilege;
  end;

// *********************************************************************//
// The Class CoSWbemPrivilegeSet provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemPrivilegeSet exposed by              
// the CoClass SWbemPrivilegeSet. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemPrivilegeSet = class
    class function Create: ISWbemPrivilegeSet;
    class function CreateRemote(const MachineName: string): ISWbemPrivilegeSet;
  end;

// *********************************************************************//
// The Class CoSWbemRefreshableItem provides a Create and CreateRemote method to          
// create instances of the default interface ISWbemRefreshableItem exposed by              
// the CoClass SWbemRefreshableItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSWbemRefreshableItem = class
    class function Create: ISWbemRefreshableItem;
    class function CreateRemote(const MachineName: string): ISWbemRefreshableItem;
  end;

procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

class function CoSWbemLocator.Create: ISWbemLocator;
begin
  Result := CreateComObject(CLASS_SWbemLocator) as ISWbemLocator;
end;

class function CoSWbemLocator.CreateRemote(const MachineName: string): ISWbemLocator;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemLocator) as ISWbemLocator;
end;

procedure TSWbemLocator.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{76A64158-CB41-11D1-8B02-00600806D9B6}';
    IntfIID:   '{76A6415B-CB41-11D1-8B02-00600806D9B6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemLocator.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISWbemLocator;
  end;
end;

procedure TSWbemLocator.ConnectTo(svrIntf: ISWbemLocator);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSWbemLocator.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSWbemLocator.GetDefaultInterface: ISWbemLocator;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemLocator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemLocatorProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemLocator.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemLocator.GetServerProperties: TSWbemLocatorProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSWbemLocator.Get_Security_: ISWbemSecurity;
begin
    Result := DefaultInterface.Security_;
end;

function TSWbemLocator.ConnectServer(const strServer: WideString; const strNamespace: WideString; 
                                     const strUser: WideString; const strPassword: WideString; 
                                     const strLocale: WideString; const strAuthority: WideString; 
                                     iSecurityFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemServices;
begin
  Result := DefaultInterface.ConnectServer(strServer, strNamespace, strUser, strPassword, 
                                           strLocale, strAuthority, iSecurityFlags, 
                                           objWbemNamedValueSet);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemLocatorProperties.Create(AServer: TSWbemLocator);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemLocatorProperties.GetDefaultInterface: ISWbemLocator;
begin
  Result := FServer.DefaultInterface;
end;

function TSWbemLocatorProperties.Get_Security_: ISWbemSecurity;
begin
    Result := DefaultInterface.Security_;
end;

{$ENDIF}

class function CoSWbemNamedValueSet.Create: ISWbemNamedValueSet;
begin
  Result := CreateComObject(CLASS_SWbemNamedValueSet) as ISWbemNamedValueSet;
end;

class function CoSWbemNamedValueSet.CreateRemote(const MachineName: string): ISWbemNamedValueSet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemNamedValueSet) as ISWbemNamedValueSet;
end;

procedure TSWbemNamedValueSet.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9AED384E-CE8B-11D1-8B05-00600806D9B6}';
    IntfIID:   '{CF2376EA-CE8C-11D1-8B05-00600806D9B6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemNamedValueSet.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISWbemNamedValueSet;
  end;
end;

procedure TSWbemNamedValueSet.ConnectTo(svrIntf: ISWbemNamedValueSet);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSWbemNamedValueSet.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSWbemNamedValueSet.GetDefaultInterface: ISWbemNamedValueSet;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemNamedValueSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemNamedValueSetProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemNamedValueSet.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemNamedValueSet.GetServerProperties: TSWbemNamedValueSetProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSWbemNamedValueSet.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TSWbemNamedValueSet.Item(const strName: WideString; iFlags: Integer): ISWbemNamedValue;
begin
  Result := DefaultInterface.Item(strName, iFlags);
end;

function TSWbemNamedValueSet.Add(const strName: WideString; var varValue: OleVariant; 
                                 iFlags: Integer): ISWbemNamedValue;
begin
  Result := DefaultInterface.Add(strName, varValue, iFlags);
end;

procedure TSWbemNamedValueSet.Remove(const strName: WideString; iFlags: Integer);
begin
  DefaultInterface.Remove(strName, iFlags);
end;

function TSWbemNamedValueSet.Clone: ISWbemNamedValueSet;
begin
  Result := DefaultInterface.Clone;
end;

procedure TSWbemNamedValueSet.DeleteAll;
begin
  DefaultInterface.DeleteAll;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemNamedValueSetProperties.Create(AServer: TSWbemNamedValueSet);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemNamedValueSetProperties.GetDefaultInterface: ISWbemNamedValueSet;
begin
  Result := FServer.DefaultInterface;
end;

function TSWbemNamedValueSetProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

{$ENDIF}

class function CoSWbemObjectPath.Create: ISWbemObjectPath;
begin
  Result := CreateComObject(CLASS_SWbemObjectPath) as ISWbemObjectPath;
end;

class function CoSWbemObjectPath.CreateRemote(const MachineName: string): ISWbemObjectPath;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemObjectPath) as ISWbemObjectPath;
end;

procedure TSWbemObjectPath.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5791BC26-CE9C-11D1-97BF-0000F81E849C}';
    IntfIID:   '{5791BC27-CE9C-11D1-97BF-0000F81E849C}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemObjectPath.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISWbemObjectPath;
  end;
end;

procedure TSWbemObjectPath.ConnectTo(svrIntf: ISWbemObjectPath);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSWbemObjectPath.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSWbemObjectPath.GetDefaultInterface: ISWbemObjectPath;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemObjectPath.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemObjectPathProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemObjectPath.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemObjectPath.GetServerProperties: TSWbemObjectPathProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSWbemObjectPath.Get_Path: WideString;
begin
    Result := DefaultInterface.Path;
end;

procedure TSWbemObjectPath.Set_Path(const strPath: WideString);
  { Warning: The property Path has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Path := strPath;
end;

function TSWbemObjectPath.Get_RelPath: WideString;
begin
    Result := DefaultInterface.RelPath;
end;

procedure TSWbemObjectPath.Set_RelPath(const strRelPath: WideString);
  { Warning: The property RelPath has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RelPath := strRelPath;
end;

function TSWbemObjectPath.Get_Server: WideString;
begin
    Result := DefaultInterface.Server;
end;

procedure TSWbemObjectPath.Set_Server(const strServer: WideString);
  { Warning: The property Server has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Server := strServer;
end;

function TSWbemObjectPath.Get_Namespace: WideString;
begin
    Result := DefaultInterface.Namespace;
end;

procedure TSWbemObjectPath.Set_Namespace(const strNamespace: WideString);
  { Warning: The property Namespace has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Namespace := strNamespace;
end;

function TSWbemObjectPath.Get_ParentNamespace: WideString;
begin
    Result := DefaultInterface.ParentNamespace;
end;

function TSWbemObjectPath.Get_DisplayName: WideString;
begin
    Result := DefaultInterface.DisplayName;
end;

procedure TSWbemObjectPath.Set_DisplayName(const strDisplayName: WideString);
  { Warning: The property DisplayName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DisplayName := strDisplayName;
end;

function TSWbemObjectPath.Get_Class_: WideString;
begin
    Result := DefaultInterface.Class_;
end;

procedure TSWbemObjectPath.Set_Class_(const strClass: WideString);
  { Warning: The property Class_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Class_ := strClass;
end;

function TSWbemObjectPath.Get_IsClass: WordBool;
begin
    Result := DefaultInterface.IsClass;
end;

function TSWbemObjectPath.Get_IsSingleton: WordBool;
begin
    Result := DefaultInterface.IsSingleton;
end;

function TSWbemObjectPath.Get_Keys: ISWbemNamedValueSet;
begin
    Result := DefaultInterface.Keys;
end;

function TSWbemObjectPath.Get_Security_: ISWbemSecurity;
begin
    Result := DefaultInterface.Security_;
end;

function TSWbemObjectPath.Get_Locale: WideString;
begin
    Result := DefaultInterface.Locale;
end;

procedure TSWbemObjectPath.Set_Locale(const strLocale: WideString);
  { Warning: The property Locale has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Locale := strLocale;
end;

function TSWbemObjectPath.Get_Authority: WideString;
begin
    Result := DefaultInterface.Authority;
end;

procedure TSWbemObjectPath.Set_Authority(const strAuthority: WideString);
  { Warning: The property Authority has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Authority := strAuthority;
end;

procedure TSWbemObjectPath.SetAsClass;
begin
  DefaultInterface.SetAsClass;
end;

procedure TSWbemObjectPath.SetAsSingleton;
begin
  DefaultInterface.SetAsSingleton;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemObjectPathProperties.Create(AServer: TSWbemObjectPath);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemObjectPathProperties.GetDefaultInterface: ISWbemObjectPath;
begin
  Result := FServer.DefaultInterface;
end;

function TSWbemObjectPathProperties.Get_Path: WideString;
begin
    Result := DefaultInterface.Path;
end;

procedure TSWbemObjectPathProperties.Set_Path(const strPath: WideString);
  { Warning: The property Path has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Path := strPath;
end;

function TSWbemObjectPathProperties.Get_RelPath: WideString;
begin
    Result := DefaultInterface.RelPath;
end;

procedure TSWbemObjectPathProperties.Set_RelPath(const strRelPath: WideString);
  { Warning: The property RelPath has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.RelPath := strRelPath;
end;

function TSWbemObjectPathProperties.Get_Server: WideString;
begin
    Result := DefaultInterface.Server;
end;

procedure TSWbemObjectPathProperties.Set_Server(const strServer: WideString);
  { Warning: The property Server has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Server := strServer;
end;

function TSWbemObjectPathProperties.Get_Namespace: WideString;
begin
    Result := DefaultInterface.Namespace;
end;

procedure TSWbemObjectPathProperties.Set_Namespace(const strNamespace: WideString);
  { Warning: The property Namespace has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Namespace := strNamespace;
end;

function TSWbemObjectPathProperties.Get_ParentNamespace: WideString;
begin
    Result := DefaultInterface.ParentNamespace;
end;

function TSWbemObjectPathProperties.Get_DisplayName: WideString;
begin
    Result := DefaultInterface.DisplayName;
end;

procedure TSWbemObjectPathProperties.Set_DisplayName(const strDisplayName: WideString);
  { Warning: The property DisplayName has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DisplayName := strDisplayName;
end;

function TSWbemObjectPathProperties.Get_Class_: WideString;
begin
    Result := DefaultInterface.Class_;
end;

procedure TSWbemObjectPathProperties.Set_Class_(const strClass: WideString);
  { Warning: The property Class_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Class_ := strClass;
end;

function TSWbemObjectPathProperties.Get_IsClass: WordBool;
begin
    Result := DefaultInterface.IsClass;
end;

function TSWbemObjectPathProperties.Get_IsSingleton: WordBool;
begin
    Result := DefaultInterface.IsSingleton;
end;

function TSWbemObjectPathProperties.Get_Keys: ISWbemNamedValueSet;
begin
    Result := DefaultInterface.Keys;
end;

function TSWbemObjectPathProperties.Get_Security_: ISWbemSecurity;
begin
    Result := DefaultInterface.Security_;
end;

function TSWbemObjectPathProperties.Get_Locale: WideString;
begin
    Result := DefaultInterface.Locale;
end;

procedure TSWbemObjectPathProperties.Set_Locale(const strLocale: WideString);
  { Warning: The property Locale has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Locale := strLocale;
end;

function TSWbemObjectPathProperties.Get_Authority: WideString;
begin
    Result := DefaultInterface.Authority;
end;

procedure TSWbemObjectPathProperties.Set_Authority(const strAuthority: WideString);
  { Warning: The property Authority has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Authority := strAuthority;
end;

{$ENDIF}

class function CoSWbemLastError.Create: ISWbemLastError;
begin
  Result := CreateComObject(CLASS_SWbemLastError) as ISWbemLastError;
end;

class function CoSWbemLastError.CreateRemote(const MachineName: string): ISWbemLastError;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemLastError) as ISWbemLastError;
end;

procedure TSWbemLastError.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{C2FEEEAC-CFCD-11D1-8B05-00600806D9B6}';
    IntfIID:   '{D962DB84-D4BB-11D1-8B09-00600806D9B6}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemLastError.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISWbemLastError;
  end;
end;

procedure TSWbemLastError.ConnectTo(svrIntf: ISWbemLastError);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSWbemLastError.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSWbemLastError.GetDefaultInterface: ISWbemLastError;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemLastError.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemLastErrorProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemLastError.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemLastError.GetServerProperties: TSWbemLastErrorProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSWbemLastError.Get_Qualifiers_: ISWbemQualifierSet;
begin
    Result := DefaultInterface.Qualifiers_;
end;

function TSWbemLastError.Get_Properties_: ISWbemPropertySet;
begin
    Result := DefaultInterface.Properties_;
end;

function TSWbemLastError.Get_Methods_: ISWbemMethodSet;
begin
    Result := DefaultInterface.Methods_;
end;

function TSWbemLastError.Get_Derivation_: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Derivation_;
end;

function TSWbemLastError.Get_Path_: ISWbemObjectPath;
begin
    Result := DefaultInterface.Path_;
end;

function TSWbemLastError.Get_Security_: ISWbemSecurity;
begin
    Result := DefaultInterface.Security_;
end;

function TSWbemLastError.Put_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectPath;
begin
  Result := DefaultInterface.Put_(iFlags, objWbemNamedValueSet);
end;

procedure TSWbemLastError.PutAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                                    const objWbemNamedValueSet: IDispatch; 
                                    const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.PutAsync_(objWbemSink, iFlags, objWbemNamedValueSet, objWbemAsyncContext);
end;

procedure TSWbemLastError.Delete_(iFlags: Integer; const objWbemNamedValueSet: IDispatch);
begin
  DefaultInterface.Delete_(iFlags, objWbemNamedValueSet);
end;

procedure TSWbemLastError.DeleteAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                                       const objWbemNamedValueSet: IDispatch; 
                                       const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.DeleteAsync_(objWbemSink, iFlags, objWbemNamedValueSet, objWbemAsyncContext);
end;

function TSWbemLastError.Instances_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
begin
  Result := DefaultInterface.Instances_(iFlags, objWbemNamedValueSet);
end;

procedure TSWbemLastError.InstancesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                                          const objWbemNamedValueSet: IDispatch; 
                                          const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.InstancesAsync_(objWbemSink, iFlags, objWbemNamedValueSet, objWbemAsyncContext);
end;

function TSWbemLastError.Subclasses_(iFlags: Integer; const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
begin
  Result := DefaultInterface.Subclasses_(iFlags, objWbemNamedValueSet);
end;

procedure TSWbemLastError.SubclassesAsync_(const objWbemSink: IDispatch; iFlags: Integer; 
                                           const objWbemNamedValueSet: IDispatch; 
                                           const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.SubclassesAsync_(objWbemSink, iFlags, objWbemNamedValueSet, objWbemAsyncContext);
end;

function TSWbemLastError.Associators_(const strAssocClass: WideString; 
                                      const strResultClass: WideString; 
                                      const strResultRole: WideString; const strRole: WideString; 
                                      bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                      const strRequiredAssocQualifier: WideString; 
                                      const strRequiredQualifier: WideString; iFlags: Integer; 
                                      const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
begin
  Result := DefaultInterface.Associators_(strAssocClass, strResultClass, strResultRole, strRole, 
                                          bClassesOnly, bSchemaOnly, strRequiredAssocQualifier, 
                                          strRequiredQualifier, iFlags, objWbemNamedValueSet);
end;

procedure TSWbemLastError.AssociatorsAsync_(const objWbemSink: IDispatch; 
                                            const strAssocClass: WideString; 
                                            const strResultClass: WideString; 
                                            const strResultRole: WideString; 
                                            const strRole: WideString; bClassesOnly: WordBool; 
                                            bSchemaOnly: WordBool; 
                                            const strRequiredAssocQualifier: WideString; 
                                            const strRequiredQualifier: WideString; 
                                            iFlags: Integer; const objWbemNamedValueSet: IDispatch; 
                                            const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.AssociatorsAsync_(objWbemSink, strAssocClass, strResultClass, strResultRole, 
                                     strRole, bClassesOnly, bSchemaOnly, strRequiredAssocQualifier, 
                                     strRequiredQualifier, iFlags, objWbemNamedValueSet, 
                                     objWbemAsyncContext);
end;

function TSWbemLastError.References_(const strResultClass: WideString; const strRole: WideString; 
                                     bClassesOnly: WordBool; bSchemaOnly: WordBool; 
                                     const strRequiredQualifier: WideString; iFlags: Integer; 
                                     const objWbemNamedValueSet: IDispatch): ISWbemObjectSet;
begin
  Result := DefaultInterface.References_(strResultClass, strRole, bClassesOnly, bSchemaOnly, 
                                         strRequiredQualifier, iFlags, objWbemNamedValueSet);
end;

procedure TSWbemLastError.ReferencesAsync_(const objWbemSink: IDispatch; 
                                           const strResultClass: WideString; 
                                           const strRole: WideString; bClassesOnly: WordBool; 
                                           bSchemaOnly: WordBool; 
                                           const strRequiredQualifier: WideString; iFlags: Integer; 
                                           const objWbemNamedValueSet: IDispatch; 
                                           const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.ReferencesAsync_(objWbemSink, strResultClass, strRole, bClassesOnly, 
                                    bSchemaOnly, strRequiredQualifier, iFlags, 
                                    objWbemNamedValueSet, objWbemAsyncContext);
end;

function TSWbemLastError.ExecMethod_(const strMethodName: WideString; 
                                     const objWbemInParameters: IDispatch; iFlags: Integer; 
                                     const objWbemNamedValueSet: IDispatch): ISWbemObject;
begin
  Result := DefaultInterface.ExecMethod_(strMethodName, objWbemInParameters, iFlags, 
                                         objWbemNamedValueSet);
end;

procedure TSWbemLastError.ExecMethodAsync_(const objWbemSink: IDispatch; 
                                           const strMethodName: WideString; 
                                           const objWbemInParameters: IDispatch; iFlags: Integer; 
                                           const objWbemNamedValueSet: IDispatch; 
                                           const objWbemAsyncContext: IDispatch);
begin
  DefaultInterface.ExecMethodAsync_(objWbemSink, strMethodName, objWbemInParameters, iFlags, 
                                    objWbemNamedValueSet, objWbemAsyncContext);
end;

function TSWbemLastError.Clone_: ISWbemObject;
begin
  Result := DefaultInterface.Clone_;
end;

function TSWbemLastError.GetObjectText_(iFlags: Integer): WideString;
begin
  Result := DefaultInterface.GetObjectText_(iFlags);
end;

function TSWbemLastError.SpawnDerivedClass_(iFlags: Integer): ISWbemObject;
begin
  Result := DefaultInterface.SpawnDerivedClass_(iFlags);
end;

function TSWbemLastError.SpawnInstance_(iFlags: Integer): ISWbemObject;
begin
  Result := DefaultInterface.SpawnInstance_(iFlags);
end;

function TSWbemLastError.CompareTo_(const objWbemObject: IDispatch; iFlags: Integer): WordBool;
begin
  Result := DefaultInterface.CompareTo_(objWbemObject, iFlags);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemLastErrorProperties.Create(AServer: TSWbemLastError);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemLastErrorProperties.GetDefaultInterface: ISWbemLastError;
begin
  Result := FServer.DefaultInterface;
end;

function TSWbemLastErrorProperties.Get_Qualifiers_: ISWbemQualifierSet;
begin
    Result := DefaultInterface.Qualifiers_;
end;

function TSWbemLastErrorProperties.Get_Properties_: ISWbemPropertySet;
begin
    Result := DefaultInterface.Properties_;
end;

function TSWbemLastErrorProperties.Get_Methods_: ISWbemMethodSet;
begin
    Result := DefaultInterface.Methods_;
end;

function TSWbemLastErrorProperties.Get_Derivation_: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.Derivation_;
end;

function TSWbemLastErrorProperties.Get_Path_: ISWbemObjectPath;
begin
    Result := DefaultInterface.Path_;
end;

function TSWbemLastErrorProperties.Get_Security_: ISWbemSecurity;
begin
    Result := DefaultInterface.Security_;
end;

{$ENDIF}

class function CoSWbemSink.Create: ISWbemSink;
begin
  Result := CreateComObject(CLASS_SWbemSink) as ISWbemSink;
end;

class function CoSWbemSink.CreateRemote(const MachineName: string): ISWbemSink;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemSink) as ISWbemSink;
end;

procedure TSWbemSink.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{75718C9A-F029-11D1-A1AC-00C04FB6C223}';
    IntfIID:   '{75718C9F-F029-11D1-A1AC-00C04FB6C223}';
    EventIID:  '{75718CA0-F029-11D1-A1AC-00C04FB6C223}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemSink.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as ISWbemSink;
  end;
end;

procedure TSWbemSink.ConnectTo(svrIntf: ISWbemSink);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TSWbemSink.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TSWbemSink.GetDefaultInterface: ISWbemSink;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemSink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemSinkProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemSink.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemSink.GetServerProperties: TSWbemSinkProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSWbemSink.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
    1: if Assigned(FOnObjectReady) then
         FOnObjectReady(Self,
                        IUnknown(TVarData(Params[0]).VPointer) as ISWbemObject {const ISWbemObject},
                        IUnknown(TVarData(Params[1]).VPointer) as ISWbemNamedValueSet {const ISWbemNamedValueSet});
    2: if Assigned(FOnCompleted) then
         FOnCompleted(Self,
                      Params[0] {WbemErrorEnum},
                      IUnknown(TVarData(Params[1]).VPointer) as ISWbemObject {const ISWbemObject},
                      IUnknown(TVarData(Params[2]).VPointer) as ISWbemNamedValueSet {const ISWbemNamedValueSet});
    3: if Assigned(FOnProgress) then
         FOnProgress(Self,
                     Params[0] {Integer},
                     Params[1] {Integer},
                     Params[2] {const WideString},
                     IUnknown(TVarData(Params[3]).VPointer) as ISWbemNamedValueSet {const ISWbemNamedValueSet});
    4: if Assigned(FOnObjectPut) then
         FOnObjectPut(Self,
                      IUnknown(TVarData(Params[0]).VPointer) as ISWbemObjectPath {const ISWbemObjectPath},
                      IUnknown(TVarData(Params[1]).VPointer) as ISWbemNamedValueSet {const ISWbemNamedValueSet});
  end; {case DispID}
end;

procedure TSWbemSink.Cancel;
begin
  DefaultInterface.Cancel;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemSinkProperties.Create(AServer: TSWbemSink);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemSinkProperties.GetDefaultInterface: ISWbemSink;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSWbemDateTime.Create: ISWbemDateTime;
begin
  Result := CreateComObject(CLASS_SWbemDateTime) as ISWbemDateTime;
end;

class function CoSWbemDateTime.CreateRemote(const MachineName: string): ISWbemDateTime;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemDateTime) as ISWbemDateTime;
end;

procedure TSWbemDateTime.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{47DFBE54-CF76-11D3-B38F-00105A1F473A}';
    IntfIID:   '{5E97458A-CF77-11D3-B38F-00105A1F473A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemDateTime.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISWbemDateTime;
  end;
end;

procedure TSWbemDateTime.ConnectTo(svrIntf: ISWbemDateTime);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSWbemDateTime.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSWbemDateTime.GetDefaultInterface: ISWbemDateTime;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemDateTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemDateTimeProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemDateTime.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemDateTime.GetServerProperties: TSWbemDateTimeProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSWbemDateTime.Get_Value: WideString;
begin
    Result := DefaultInterface.Value;
end;

procedure TSWbemDateTime.Set_Value(const strValue: WideString);
  { Warning: The property Value has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Value := strValue;
end;

function TSWbemDateTime.Get_Year: Integer;
begin
    Result := DefaultInterface.Year;
end;

procedure TSWbemDateTime.Set_Year(iYear: Integer);
begin
  DefaultInterface.Set_Year(iYear);
end;

function TSWbemDateTime.Get_YearSpecified: WordBool;
begin
    Result := DefaultInterface.YearSpecified;
end;

procedure TSWbemDateTime.Set_YearSpecified(bYearSpecified: WordBool);
begin
  DefaultInterface.Set_YearSpecified(bYearSpecified);
end;

function TSWbemDateTime.Get_Month: Integer;
begin
    Result := DefaultInterface.Month;
end;

procedure TSWbemDateTime.Set_Month(iMonth: Integer);
begin
  DefaultInterface.Set_Month(iMonth);
end;

function TSWbemDateTime.Get_MonthSpecified: WordBool;
begin
    Result := DefaultInterface.MonthSpecified;
end;

procedure TSWbemDateTime.Set_MonthSpecified(bMonthSpecified: WordBool);
begin
  DefaultInterface.Set_MonthSpecified(bMonthSpecified);
end;

function TSWbemDateTime.Get_Day: Integer;
begin
    Result := DefaultInterface.Day;
end;

procedure TSWbemDateTime.Set_Day(iDay: Integer);
begin
  DefaultInterface.Set_Day(iDay);
end;

function TSWbemDateTime.Get_DaySpecified: WordBool;
begin
    Result := DefaultInterface.DaySpecified;
end;

procedure TSWbemDateTime.Set_DaySpecified(bDaySpecified: WordBool);
begin
  DefaultInterface.Set_DaySpecified(bDaySpecified);
end;

function TSWbemDateTime.Get_Hours: Integer;
begin
    Result := DefaultInterface.Hours;
end;

procedure TSWbemDateTime.Set_Hours(iHours: Integer);
begin
  DefaultInterface.Set_Hours(iHours);
end;

function TSWbemDateTime.Get_HoursSpecified: WordBool;
begin
    Result := DefaultInterface.HoursSpecified;
end;

procedure TSWbemDateTime.Set_HoursSpecified(bHoursSpecified: WordBool);
begin
  DefaultInterface.Set_HoursSpecified(bHoursSpecified);
end;

function TSWbemDateTime.Get_Minutes: Integer;
begin
    Result := DefaultInterface.Minutes;
end;

procedure TSWbemDateTime.Set_Minutes(iMinutes: Integer);
begin
  DefaultInterface.Set_Minutes(iMinutes);
end;

function TSWbemDateTime.Get_MinutesSpecified: WordBool;
begin
    Result := DefaultInterface.MinutesSpecified;
end;

procedure TSWbemDateTime.Set_MinutesSpecified(bMinutesSpecified: WordBool);
begin
  DefaultInterface.Set_MinutesSpecified(bMinutesSpecified);
end;

function TSWbemDateTime.Get_Seconds: Integer;
begin
    Result := DefaultInterface.Seconds;
end;

procedure TSWbemDateTime.Set_Seconds(iSeconds: Integer);
begin
  DefaultInterface.Set_Seconds(iSeconds);
end;

function TSWbemDateTime.Get_SecondsSpecified: WordBool;
begin
    Result := DefaultInterface.SecondsSpecified;
end;

procedure TSWbemDateTime.Set_SecondsSpecified(bSecondsSpecified: WordBool);
begin
  DefaultInterface.Set_SecondsSpecified(bSecondsSpecified);
end;

function TSWbemDateTime.Get_Microseconds: Integer;
begin
    Result := DefaultInterface.Microseconds;
end;

procedure TSWbemDateTime.Set_Microseconds(iMicroseconds: Integer);
begin
  DefaultInterface.Set_Microseconds(iMicroseconds);
end;

function TSWbemDateTime.Get_MicrosecondsSpecified: WordBool;
begin
    Result := DefaultInterface.MicrosecondsSpecified;
end;

procedure TSWbemDateTime.Set_MicrosecondsSpecified(bMicrosecondsSpecified: WordBool);
begin
  DefaultInterface.Set_MicrosecondsSpecified(bMicrosecondsSpecified);
end;

function TSWbemDateTime.Get_UTC: Integer;
begin
    Result := DefaultInterface.UTC;
end;

procedure TSWbemDateTime.Set_UTC(iUTC: Integer);
begin
  DefaultInterface.Set_UTC(iUTC);
end;

function TSWbemDateTime.Get_UTCSpecified: WordBool;
begin
    Result := DefaultInterface.UTCSpecified;
end;

procedure TSWbemDateTime.Set_UTCSpecified(bUTCSpecified: WordBool);
begin
  DefaultInterface.Set_UTCSpecified(bUTCSpecified);
end;

function TSWbemDateTime.Get_IsInterval: WordBool;
begin
    Result := DefaultInterface.IsInterval;
end;

procedure TSWbemDateTime.Set_IsInterval(bIsInterval: WordBool);
begin
  DefaultInterface.Set_IsInterval(bIsInterval);
end;

function TSWbemDateTime.GetVarDate(bIsLocal: WordBool): TDateTime;
begin
  Result := DefaultInterface.GetVarDate(bIsLocal);
end;

procedure TSWbemDateTime.SetVarDate(dVarDate: TDateTime; bIsLocal: WordBool);
begin
  DefaultInterface.SetVarDate(dVarDate, bIsLocal);
end;

function TSWbemDateTime.GetFileTime(bIsLocal: WordBool): WideString;
begin
  Result := DefaultInterface.GetFileTime(bIsLocal);
end;

procedure TSWbemDateTime.SetFileTime(const strFileTime: WideString; bIsLocal: WordBool);
begin
  DefaultInterface.SetFileTime(strFileTime, bIsLocal);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemDateTimeProperties.Create(AServer: TSWbemDateTime);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemDateTimeProperties.GetDefaultInterface: ISWbemDateTime;
begin
  Result := FServer.DefaultInterface;
end;

function TSWbemDateTimeProperties.Get_Value: WideString;
begin
    Result := DefaultInterface.Value;
end;

procedure TSWbemDateTimeProperties.Set_Value(const strValue: WideString);
  { Warning: The property Value has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Value := strValue;
end;

function TSWbemDateTimeProperties.Get_Year: Integer;
begin
    Result := DefaultInterface.Year;
end;

procedure TSWbemDateTimeProperties.Set_Year(iYear: Integer);
begin
  DefaultInterface.Set_Year(iYear);
end;

function TSWbemDateTimeProperties.Get_YearSpecified: WordBool;
begin
    Result := DefaultInterface.YearSpecified;
end;

procedure TSWbemDateTimeProperties.Set_YearSpecified(bYearSpecified: WordBool);
begin
  DefaultInterface.Set_YearSpecified(bYearSpecified);
end;

function TSWbemDateTimeProperties.Get_Month: Integer;
begin
    Result := DefaultInterface.Month;
end;

procedure TSWbemDateTimeProperties.Set_Month(iMonth: Integer);
begin
  DefaultInterface.Set_Month(iMonth);
end;

function TSWbemDateTimeProperties.Get_MonthSpecified: WordBool;
begin
    Result := DefaultInterface.MonthSpecified;
end;

procedure TSWbemDateTimeProperties.Set_MonthSpecified(bMonthSpecified: WordBool);
begin
  DefaultInterface.Set_MonthSpecified(bMonthSpecified);
end;

function TSWbemDateTimeProperties.Get_Day: Integer;
begin
    Result := DefaultInterface.Day;
end;

procedure TSWbemDateTimeProperties.Set_Day(iDay: Integer);
begin
  DefaultInterface.Set_Day(iDay);
end;

function TSWbemDateTimeProperties.Get_DaySpecified: WordBool;
begin
    Result := DefaultInterface.DaySpecified;
end;

procedure TSWbemDateTimeProperties.Set_DaySpecified(bDaySpecified: WordBool);
begin
  DefaultInterface.Set_DaySpecified(bDaySpecified);
end;

function TSWbemDateTimeProperties.Get_Hours: Integer;
begin
    Result := DefaultInterface.Hours;
end;

procedure TSWbemDateTimeProperties.Set_Hours(iHours: Integer);
begin
  DefaultInterface.Set_Hours(iHours);
end;

function TSWbemDateTimeProperties.Get_HoursSpecified: WordBool;
begin
    Result := DefaultInterface.HoursSpecified;
end;

procedure TSWbemDateTimeProperties.Set_HoursSpecified(bHoursSpecified: WordBool);
begin
  DefaultInterface.Set_HoursSpecified(bHoursSpecified);
end;

function TSWbemDateTimeProperties.Get_Minutes: Integer;
begin
    Result := DefaultInterface.Minutes;
end;

procedure TSWbemDateTimeProperties.Set_Minutes(iMinutes: Integer);
begin
  DefaultInterface.Set_Minutes(iMinutes);
end;

function TSWbemDateTimeProperties.Get_MinutesSpecified: WordBool;
begin
    Result := DefaultInterface.MinutesSpecified;
end;

procedure TSWbemDateTimeProperties.Set_MinutesSpecified(bMinutesSpecified: WordBool);
begin
  DefaultInterface.Set_MinutesSpecified(bMinutesSpecified);
end;

function TSWbemDateTimeProperties.Get_Seconds: Integer;
begin
    Result := DefaultInterface.Seconds;
end;

procedure TSWbemDateTimeProperties.Set_Seconds(iSeconds: Integer);
begin
  DefaultInterface.Set_Seconds(iSeconds);
end;

function TSWbemDateTimeProperties.Get_SecondsSpecified: WordBool;
begin
    Result := DefaultInterface.SecondsSpecified;
end;

procedure TSWbemDateTimeProperties.Set_SecondsSpecified(bSecondsSpecified: WordBool);
begin
  DefaultInterface.Set_SecondsSpecified(bSecondsSpecified);
end;

function TSWbemDateTimeProperties.Get_Microseconds: Integer;
begin
    Result := DefaultInterface.Microseconds;
end;

procedure TSWbemDateTimeProperties.Set_Microseconds(iMicroseconds: Integer);
begin
  DefaultInterface.Set_Microseconds(iMicroseconds);
end;

function TSWbemDateTimeProperties.Get_MicrosecondsSpecified: WordBool;
begin
    Result := DefaultInterface.MicrosecondsSpecified;
end;

procedure TSWbemDateTimeProperties.Set_MicrosecondsSpecified(bMicrosecondsSpecified: WordBool);
begin
  DefaultInterface.Set_MicrosecondsSpecified(bMicrosecondsSpecified);
end;

function TSWbemDateTimeProperties.Get_UTC: Integer;
begin
    Result := DefaultInterface.UTC;
end;

procedure TSWbemDateTimeProperties.Set_UTC(iUTC: Integer);
begin
  DefaultInterface.Set_UTC(iUTC);
end;

function TSWbemDateTimeProperties.Get_UTCSpecified: WordBool;
begin
    Result := DefaultInterface.UTCSpecified;
end;

procedure TSWbemDateTimeProperties.Set_UTCSpecified(bUTCSpecified: WordBool);
begin
  DefaultInterface.Set_UTCSpecified(bUTCSpecified);
end;

function TSWbemDateTimeProperties.Get_IsInterval: WordBool;
begin
    Result := DefaultInterface.IsInterval;
end;

procedure TSWbemDateTimeProperties.Set_IsInterval(bIsInterval: WordBool);
begin
  DefaultInterface.Set_IsInterval(bIsInterval);
end;

{$ENDIF}

class function CoSWbemRefresher.Create: ISWbemRefresher;
begin
  Result := CreateComObject(CLASS_SWbemRefresher) as ISWbemRefresher;
end;

class function CoSWbemRefresher.CreateRemote(const MachineName: string): ISWbemRefresher;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemRefresher) as ISWbemRefresher;
end;

procedure TSWbemRefresher.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D269BF5C-D9C1-11D3-B38F-00105A1F473A}';
    IntfIID:   '{14D8250E-D9C2-11D3-B38F-00105A1F473A}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSWbemRefresher.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISWbemRefresher;
  end;
end;

procedure TSWbemRefresher.ConnectTo(svrIntf: ISWbemRefresher);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSWbemRefresher.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSWbemRefresher.GetDefaultInterface: ISWbemRefresher;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TSWbemRefresher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSWbemRefresherProperties.Create(Self);
{$ENDIF}
end;

destructor TSWbemRefresher.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSWbemRefresher.GetServerProperties: TSWbemRefresherProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSWbemRefresher.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TSWbemRefresher.Get_AutoReconnect: WordBool;
begin
    Result := DefaultInterface.AutoReconnect;
end;

procedure TSWbemRefresher.Set_AutoReconnect(bCount: WordBool);
begin
  DefaultInterface.Set_AutoReconnect(bCount);
end;

function TSWbemRefresher.Item(iIndex: Integer): ISWbemRefreshableItem;
begin
  Result := DefaultInterface.Item(iIndex);
end;

function TSWbemRefresher.Add(const objWbemServices: ISWbemServicesEx; 
                             const bsInstancePath: WideString; iFlags: Integer; 
                             const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem;
begin
  Result := DefaultInterface.Add(objWbemServices, bsInstancePath, iFlags, objWbemNamedValueSet);
end;

function TSWbemRefresher.AddEnum(const objWbemServices: ISWbemServicesEx; 
                                 const bsClassName: WideString; iFlags: Integer; 
                                 const objWbemNamedValueSet: IDispatch): ISWbemRefreshableItem;
begin
  Result := DefaultInterface.AddEnum(objWbemServices, bsClassName, iFlags, objWbemNamedValueSet);
end;

procedure TSWbemRefresher.Remove(iIndex: Integer; iFlags: Integer);
begin
  DefaultInterface.Remove(iIndex, iFlags);
end;

procedure TSWbemRefresher.Refresh(iFlags: Integer);
begin
  DefaultInterface.Refresh(iFlags);
end;

procedure TSWbemRefresher.DeleteAll;
begin
  DefaultInterface.DeleteAll;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSWbemRefresherProperties.Create(AServer: TSWbemRefresher);
begin
  inherited Create;
  FServer := AServer;
end;

function TSWbemRefresherProperties.GetDefaultInterface: ISWbemRefresher;
begin
  Result := FServer.DefaultInterface;
end;

function TSWbemRefresherProperties.Get_Count: Integer;
begin
    Result := DefaultInterface.Count;
end;

function TSWbemRefresherProperties.Get_AutoReconnect: WordBool;
begin
    Result := DefaultInterface.AutoReconnect;
end;

procedure TSWbemRefresherProperties.Set_AutoReconnect(bCount: WordBool);
begin
  DefaultInterface.Set_AutoReconnect(bCount);
end;

{$ENDIF}

class function CoSWbemServices.Create: ISWbemServices;
begin
  Result := CreateComObject(CLASS_SWbemServices) as ISWbemServices;
end;

class function CoSWbemServices.CreateRemote(const MachineName: string): ISWbemServices;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemServices) as ISWbemServices;
end;

class function CoSWbemServicesEx.Create: ISWbemServicesEx;
begin
  Result := CreateComObject(CLASS_SWbemServicesEx) as ISWbemServicesEx;
end;

class function CoSWbemServicesEx.CreateRemote(const MachineName: string): ISWbemServicesEx;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemServicesEx) as ISWbemServicesEx;
end;

class function CoSWbemObject.Create: ISWbemObject;
begin
  Result := CreateComObject(CLASS_SWbemObject) as ISWbemObject;
end;

class function CoSWbemObject.CreateRemote(const MachineName: string): ISWbemObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemObject) as ISWbemObject;
end;

class function CoSWbemObjectEx.Create: ISWbemObjectEx;
begin
  Result := CreateComObject(CLASS_SWbemObjectEx) as ISWbemObjectEx;
end;

class function CoSWbemObjectEx.CreateRemote(const MachineName: string): ISWbemObjectEx;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemObjectEx) as ISWbemObjectEx;
end;

class function CoSWbemObjectSet.Create: ISWbemObjectSet;
begin
  Result := CreateComObject(CLASS_SWbemObjectSet) as ISWbemObjectSet;
end;

class function CoSWbemObjectSet.CreateRemote(const MachineName: string): ISWbemObjectSet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemObjectSet) as ISWbemObjectSet;
end;

class function CoSWbemNamedValue.Create: ISWbemNamedValue;
begin
  Result := CreateComObject(CLASS_SWbemNamedValue) as ISWbemNamedValue;
end;

class function CoSWbemNamedValue.CreateRemote(const MachineName: string): ISWbemNamedValue;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemNamedValue) as ISWbemNamedValue;
end;

class function CoSWbemQualifier.Create: ISWbemQualifier;
begin
  Result := CreateComObject(CLASS_SWbemQualifier) as ISWbemQualifier;
end;

class function CoSWbemQualifier.CreateRemote(const MachineName: string): ISWbemQualifier;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemQualifier) as ISWbemQualifier;
end;

class function CoSWbemQualifierSet.Create: ISWbemQualifierSet;
begin
  Result := CreateComObject(CLASS_SWbemQualifierSet) as ISWbemQualifierSet;
end;

class function CoSWbemQualifierSet.CreateRemote(const MachineName: string): ISWbemQualifierSet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemQualifierSet) as ISWbemQualifierSet;
end;

class function CoSWbemProperty.Create: ISWbemProperty;
begin
  Result := CreateComObject(CLASS_SWbemProperty) as ISWbemProperty;
end;

class function CoSWbemProperty.CreateRemote(const MachineName: string): ISWbemProperty;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemProperty) as ISWbemProperty;
end;

class function CoSWbemPropertySet.Create: ISWbemPropertySet;
begin
  Result := CreateComObject(CLASS_SWbemPropertySet) as ISWbemPropertySet;
end;

class function CoSWbemPropertySet.CreateRemote(const MachineName: string): ISWbemPropertySet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemPropertySet) as ISWbemPropertySet;
end;

class function CoSWbemMethod.Create: ISWbemMethod;
begin
  Result := CreateComObject(CLASS_SWbemMethod) as ISWbemMethod;
end;

class function CoSWbemMethod.CreateRemote(const MachineName: string): ISWbemMethod;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemMethod) as ISWbemMethod;
end;

class function CoSWbemMethodSet.Create: ISWbemMethodSet;
begin
  Result := CreateComObject(CLASS_SWbemMethodSet) as ISWbemMethodSet;
end;

class function CoSWbemMethodSet.CreateRemote(const MachineName: string): ISWbemMethodSet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemMethodSet) as ISWbemMethodSet;
end;

class function CoSWbemEventSource.Create: ISWbemEventSource;
begin
  Result := CreateComObject(CLASS_SWbemEventSource) as ISWbemEventSource;
end;

class function CoSWbemEventSource.CreateRemote(const MachineName: string): ISWbemEventSource;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemEventSource) as ISWbemEventSource;
end;

class function CoSWbemSecurity.Create: ISWbemSecurity;
begin
  Result := CreateComObject(CLASS_SWbemSecurity) as ISWbemSecurity;
end;

class function CoSWbemSecurity.CreateRemote(const MachineName: string): ISWbemSecurity;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemSecurity) as ISWbemSecurity;
end;

class function CoSWbemPrivilege.Create: ISWbemPrivilege;
begin
  Result := CreateComObject(CLASS_SWbemPrivilege) as ISWbemPrivilege;
end;

class function CoSWbemPrivilege.CreateRemote(const MachineName: string): ISWbemPrivilege;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemPrivilege) as ISWbemPrivilege;
end;

class function CoSWbemPrivilegeSet.Create: ISWbemPrivilegeSet;
begin
  Result := CreateComObject(CLASS_SWbemPrivilegeSet) as ISWbemPrivilegeSet;
end;

class function CoSWbemPrivilegeSet.CreateRemote(const MachineName: string): ISWbemPrivilegeSet;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemPrivilegeSet) as ISWbemPrivilegeSet;
end;

class function CoSWbemRefreshableItem.Create: ISWbemRefreshableItem;
begin
  Result := CreateComObject(CLASS_SWbemRefreshableItem) as ISWbemRefreshableItem;
end;

class function CoSWbemRefreshableItem.CreateRemote(const MachineName: string): ISWbemRefreshableItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SWbemRefreshableItem) as ISWbemRefreshableItem;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TSWbemLocator, TSWbemNamedValueSet, TSWbemObjectPath, TSWbemLastError, 
    TSWbemSink, TSWbemDateTime, TSWbemRefresher]);
end;

end.
