//**************************************************************************************************
//
// Unit uCheckUpdate
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
// The Original Code is uCheckUpdate.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2015 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************


unit uCheckUpdate;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, pngimage, ExtCtrls, Diagnostics, uWinInet;

type
  TFrmCheckUpdate = class(TForm)
    LabelMsg: TLabel;
    ProgressBar1: TProgressBar;
    BtnCheckUpdates: TButton;
    LabelVersion: TLabel;
    BtnInstall: TButton;
    Image1: TImage;
    BtnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCheckUpdatesClick(Sender: TObject);
    procedure BtnInstallClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCancelClick(Sender: TObject);
  private
    FileStream : TFileStream;
    FXmlVersionInfo: string;
    FLocalVersion: string;
    FRemoteVersion: string;
    FUrlInstaller: string;
    FInstallerFileName: string;
    FTempInstallerFileName: string;
    FStopwatch : TStopwatch;
    FCheckExternal: boolean;
    FErrorUpdate : boolean;
    FRemoteVersionFile: string;
    FApplicationName: string;
    FXPathVersionNumber: string;
    FXPathUrlInstaller: string;
    FXPathInstallerFileName: string;
    FWinINetGetThread : TWinINetGetThread;
    FCancelled : Boolean;
    procedure ReadRemoteInfo;
    procedure ReadLocalInfo;
    function GetUpdateAvailable: Boolean;
    property XmlVersionInfo : string read FXmlVersionInfo write FXmlVersionInfo;
    property RemoteVersion : string read FRemoteVersion write FRemoteVersion;
    property LocalVersion  : string read FLocalVersion write FLocalVersion;
    property UrlInstaller : string read FUrlInstaller write FUrlInstaller;
    property InstallerFileName : string read FInstallerFileName write FInstallerFileName;
    property TempInstallerFileName : string read FTempInstallerFileName write FTempInstallerFileName;
    procedure SetMsg(const Msg:string);
    procedure Download;
    procedure ExecuteInstaller;
    procedure DownloadCallBack(BytesRead:Integer);
    procedure DownloadFinished;
    procedure OnDownloadFinished(var Msg: TMessage); message WM_UWININET_THREAD_FINISHED;
    procedure OnDownloadCancelled(var Msg: TMessage); message WM_UWININET_THREAD_CANCELLED;
    procedure ThreadOnTerminate(Sender: TObject);
  public
    property  RemoteVersionFile : string read FRemoteVersionFile write FRemoteVersionFile;
    property  ApplicationName  : string read FApplicationName write FApplicationName;
    property  XPathVersionNumber   : string read FXPathVersionNumber  write FXPathVersionNumber;
    property  XPathUrlInstaller   : string read FXPathUrlInstaller  write FXPathUrlInstaller;
    property  XPathInstallerFileName   : string read FXPathInstallerFileName  write FXPathInstallerFileName;
    property  CheckExternal   : boolean read FCheckExternal write FCheckExternal;
    property  UpdateAvailable : Boolean read GetUpdateAvailable;
    procedure ExecuteUpdater;
  end;

implementation


uses
  System.UITypes,
  ShellAPI,
  uUpdatesChanges,
  uMisc,
  ComObj;


{$R *.dfm}

{ TFrmCheckUpdate }
procedure TFrmCheckUpdate.BtnCancelClick(Sender: TObject);
begin
 if FWinINetGetThread<>nil then
   FWinINetGetThread.Terminate;
 BtnCancel.Enabled:=False;
 FCancelled:=True;
end;


procedure TFrmCheckUpdate.BtnCheckUpdatesClick(Sender: TObject);
begin
  ExecuteUpdater;
end;

procedure TFrmCheckUpdate.BtnInstallClick(Sender: TObject);
begin
  ExecuteInstaller;
end;

procedure TFrmCheckUpdate.Download;
{
var
  FileStream : TFileStream;
}
begin
  try
   ProgressBar1.Style:=pbstNormal;
   SetMsg('Getting Application information');
   ProgressBar1.Max:= GetRemoteFileSize(UrlInstaller);
   SetMsg(Format('%s bytes to download ',[FormatFloat('#,', ProgressBar1.Max)]));
   FTempInstallerFileName:=IncludeTrailingPathDelimiter(GetTempDirectory)+InstallerFileName;
   DeleteFile(TempInstallerFileName);

     {
     FileStream:=TFileStream.Create(TempInstallerFileName,fmCreate);
     try
       FStopwatch.Reset;
       FStopwatch.Start;
       WinInet_HttpGet(UrlInstaller,FileStream,DownloadCallBack);
       SetMsg('Application downloaded');
     finally
       FileStream.Free;
     end;

     BtnInstall.Visible:=FileExists(TempInstallerFileName);
     BtnCheckUpdates.Visible:=not BtnInstall.Visible;
     if BtnInstall.Visible and not CheckExternal then ExecuteInstaller;
     }
     FCancelled:=False;
     BtnCancel.Visible:=True;
     BtnCancel.Enabled:=False;
     FStopwatch.Reset;
     FStopwatch.Start;
     FileStream:=TFileStream.Create(TempInstallerFileName,fmCreate);
     FWinINetGetThread:=TWinINetGetThread.Create(UrlInstaller, FileStream, DownloadCallBack, Handle);
     FWinINetGetThread.OnTerminate:=ThreadOnTerminate;
     BtnCancel.Enabled:=True;
     //Application.ProcessMessages;
  except on E : Exception do
    SetMsg(Format('Error checking updates %s',[E.Message]));
  end;
end;

procedure TFrmCheckUpdate.DownloadFinished;
begin
   if FileStream<>nil then
   begin
     FileStream.Free;
     FileStream:=nil;
   end;

   BtnCancel.Visible:=False;
   BtnInstall.Visible:=FileExists(TempInstallerFileName);
   BtnCheckUpdates.Visible:=not BtnInstall.Visible;
   if BtnInstall.Visible and not CheckExternal then ExecuteInstaller;

   if CheckExternal then
     ExecuteInstaller;

   ProgressBar1.Style:=pbstNormal;
   BtnCheckUpdates.Enabled:=True;

   Close;
end;

procedure TFrmCheckUpdate.DownloadCallBack(BytesRead: Integer);
var
  Pos  :  Integer;
  Max  :  Integer;
  Rate :  Integer;
  sRate:  string;
begin
   if ProgressBar1.Style=pbstNormal then
   begin
     Pos:=ProgressBar1.Position+BytesRead;
     Max:=ProgressBar1.Max;
     Rate:=0;
     ProgressBar1.Position:=Pos;
     if FStopwatch.Elapsed.TotalSeconds>0 then
     Rate:= Round(Max/1024/FStopwatch.Elapsed.TotalSeconds);
     sRate:= Format('%d Kbytes x second',[Rate]);
     SetMsg(Format('Downloaded %s of %s bytes %n%% %sTransfer Rate %s',[FormatFloat('#,',Pos),FormatFloat('#,',Max),Pos*100/Max,#13#10,sRate]));
   end;
end;



procedure TFrmCheckUpdate.ExecuteInstaller;
begin
  if MessageDlg(Format('Do you want install the new version (the %s will be closed) ?',[FApplicationName]),
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ShellExecute(Handle, 'Open', PChar(TempInstallerFileName), nil, nil, SW_SHOWNORMAL);
    if Application.MainForm<>nil then
     Application.Terminate
    else
     Halt(0);
  end;
end;

procedure TFrmCheckUpdate.ExecuteUpdater;
begin
  try
    ProgressBar1.Style:=pbstMarquee;
    BtnCheckUpdates.Enabled:=False;
    try
      if not UpdateAvailable then
      begin
       if not FErrorUpdate then
        MsgInformation(Format('%s is up to date',[FApplicationName]));
       Close;
      end
      else
      if CheckChangesUpdates(Format('Exist a new version available (%s) of the %s %sDo you want download the new version?',[RemoteVersion, FApplicationName,#13#10])) then
      begin
       if not Visible then
         Show;

        Download;
        {
        if CheckExternal then
         ExecuteInstaller;
         }
      end;


    finally
      {
      ProgressBar1.Style:=pbstNormal;
      BtnCheckUpdates.Enabled:=True;
      }
    end;
  except on E : Exception do
    SetMsg(Format('Error checking updates %s',[E.Message]));
  end;
end;

procedure TFrmCheckUpdate.FormActivate(Sender: TObject);
begin
  if not CheckExternal then
   ExecuteUpdater;
end;

procedure TFrmCheckUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  if (FWinINetGetThread<>nil)  then
     Action:=caNone;
end;

procedure TFrmCheckUpdate.FormCreate(Sender: TObject);
begin
   BtnCancel.Visible:=False;
   FCancelled:=False;
   FileStream:=nil;
   FWinINetGetThread:=nil;
   FRemoteVersion:='';
   FErrorUpdate  :=False;
   FCheckExternal:=False;
   FStopwatch:=TStopwatch.Create;
   ReadLocalInfo;
   LabelVersion.Caption:=Format('Current Version %s',[LocalVersion]);
   SetMsg('');
end;


procedure TFrmCheckUpdate.ReadLocalInfo;
begin
   FLocalVersion:=GetFileVersion(ParamStr(0));
end;

procedure TFrmCheckUpdate.ReadRemoteInfo;
var
  XmlDoc : OleVariant;
  Node   : OleVariant;
begin
  XmlDoc       := CreateOleObject('Msxml2.DOMDocument.6.0');
  XmlDoc.Async := False;
  try
    SetMsg('Getting version info');
    FXmlVersionInfo:=WinInet_HttpGet(FRemoteVersionFile,DownloadCallBack);
    XmlDoc.LoadXml(XmlVersionInfo);
    XmlDoc.SetProperty('SelectionLanguage','XPath');
    if (XmlDoc.parseError.errorCode <> 0) then
     raise Exception.CreateFmt('Error in Xml Data Code %s Reason %s',[XmlDoc.parseError.errorCode, XmlDoc.parseError.reason]);

     Node:=XmlDoc.selectSingleNode(FXPathVersionNumber);
     if not VarIsClear(Node) then FRemoteVersion:=Node.Text;

     Node:=XmlDoc.selectSingleNode(FXPathUrlInstaller);
     if not VarIsClear(Node) then FUrlInstaller:=Node.Text;

     Node:=XmlDoc.selectSingleNode(FXPathInstallerFileName);
     if not VarIsClear(Node) then FInstallerFileName:=Node.Text;
  finally
   XmlDoc    :=Unassigned;
  end;

end;

procedure TFrmCheckUpdate.SetMsg(const Msg: string);
begin
  LabelMsg.Caption:=Msg;
  LabelMsg.Update;
end;


procedure TFrmCheckUpdate.ThreadOnTerminate(Sender: TObject);
var
  LException: TObject;
begin
  Assert(Sender is TThread);
  LException := TThread(Sender).FatalException;
  if Assigned(LException) then
  begin
    BtnCancel.Visible:=False;
    FWinINetGetThread:=nil;

    if LException is Exception then
      SetMsg(Format('Error downloading update %s %s',[#13#10,Exception(LException).Message]))
    else
      SetMsg(LException.ClassName);
  end;
end;


function TFrmCheckUpdate.GetUpdateAvailable: Boolean;
begin
 Result:=False;
 try
   if FRemoteVersion='' then
     ReadRemoteInfo;

   if DebugHook<>0 then
     Result:=True
   else

     Result:=(FRemoteVersion>FLocalVersion);
 except on E : Exception do
   begin
    FErrorUpdate:=True;
    MessageDlg(Format('Error checking updates %s',[E.Message]), mtWarning, [mbOK], 0);
   end;
 end;
end;


procedure TFrmCheckUpdate.OnDownloadCancelled(var Msg: TMessage);
begin
  FWinINetGetThread:=nil;

  if FileStream<>nil then
  begin
    FileStream.Free;
    FileStream:=nil;
  end;

  Close;
end;

procedure TFrmCheckUpdate.OnDownloadFinished(var Msg: TMessage);
begin
  DownloadFinished;
  FWinINetGetThread:=nil;
end;

end.
