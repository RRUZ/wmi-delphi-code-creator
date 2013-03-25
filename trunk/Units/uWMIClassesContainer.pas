{**************************************************************************************************}
{                                                                                                  }
{ Unit uWMIClassesContainer                                                                        }
{ unit for the WMI Delphi Code Creator                                                             }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is uWMIClassesContainer.pas.                                                   }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2012 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit uWMIClassesContainer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uMisc, Vcl.StdCtrls, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ImgList, Vcl.ActnList, uSettings,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ComCtrls, System.Actions;

type
  TPageControl = class(Vcl.ComCtrls.TPageControl);

  TFrmWMiClassesContainer = class(TForm)
    ActionManager1: TActionManager;
    ActionNew: TAction;
    ActionDelete: TAction;
    ImageList1: TImageList;
    ActionToolBar1: TActionToolBar;
    PageControl1: TPageControl;
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionDeleteUpdate(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FSetLog: TProcLog;
    DataLoaded : Boolean;
    FSetMsg: TProcLog;
    FConsole: TMemo;
    FSettings: TSettings;
    procedure CreateNewInstance;
  public
    property SetMsg : TProcLog read FSetMsg Write FSetMsg;
    property SetLog : TProcLog read FSetLog Write FSetLog;
    property Console : TMemo read FConsole write FConsole;
    property Settings : TSettings read FSettings Write  FSettings;
  end;


implementation

uses
  uWmiClasses,
  Vcl.Styles.TabsClose,
  Vcl.Styles,
  Vcl.Themes;

{$R *.dfm}

{ TFrmWMiClassesContainer }

procedure TFrmWMiClassesContainer.ActionDeleteExecute(Sender: TObject);
Var
 LTabSheet : TTabSheet;
begin
 if MsgQuestion(Format('Do you want delete the %s page?',[Trim(PageControl1.ActivePage.Caption)])) then
 begin
  LTabSheet := TTabSheet(PageControl1.ActivePage);
  PageControl1.SelectNextPage(False);
  if LTabSheet <> nil then
  begin
   LTabSheet.Parent := nil;
   LTabSheet.Free;
  end;
 end;
end;

procedure TFrmWMiClassesContainer.ActionDeleteUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled:=PageControl1.PageCount>0;
end;

procedure TFrmWMiClassesContainer.ActionNewExecute(Sender: TObject);
begin
 CreateNewInstance;
end;

procedure TFrmWMiClassesContainer.CreateNewInstance;
Var
 LTabSheet : TTabSheet;
 LForm     : TFrmWmiClasses;
begin
 LTabSheet:=TTabSheet.Create(PageControl1);
 LTabSheet.Caption:=Format('WMI Class CodeGen %d',[PageControl1.PageCount+1]);
 LTabSheet.PageControl:=PageControl1;

 LForm:=TFrmWmiClasses.Create(LTabSheet);
 LForm.Parent:=LTabSheet;
 LForm.BorderStyle:=bsNone;
 LForm.Align:=alClient;
 LForm.SetLog:=FSetLog;
 LForm.SetMsg:=FSetMsg;
 LForm.Settings:=FSettings;
 LForm.Console:=FConsole;
 LForm.Show;
 PageControl1.ActivePage:=LTabSheet;
 DataLoaded:=True;
end;

procedure TFrmWMiClassesContainer.FormCreate(Sender: TObject);
begin
  DataLoaded:=False;
end;

procedure TFrmWMiClassesContainer.FormShow(Sender: TObject);
begin
 if not DataLoaded then
  CreateNewInstance;
end;

initialization
  TStyleManager.Engine.RegisterStyleHook(uWMIClassesContainer.TPageControl, TTabControlStyleHookBtnClose);


end.
