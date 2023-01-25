// **************************************************************************************************
//
// Unit WDCC.WMI.Methods.Container
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
// The Original Code is WDCC.WMI.Methods.Container.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.WMI.Methods.Container;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.StdCtrls, WDCC.Misc, WDCC.Settings,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ActnCtrls, System.Actions, System.ImageList;

type
  TPageControl = class(Vcl.ComCtrls.TPageControl);

  TFrmWmiMethodsContainer = class(TForm)
    ActionToolBar1: TActionToolBar;
    PageControl1: TPageControl;
    ActionManager1: TActionManager;
    ActionNew: TAction;
    ActionDelete: TAction;
    ImageList1: TImageList;
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionDeleteUpdate(Sender: TObject);
    procedure ActionNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FSetLog: TProcLog;
    DataLoaded: Boolean;
    FSetMsg: TProcLog;
    FConsole: TMemo;
    FSettings: TSettings;
    procedure CreateNewInstance;
  public
    property SetMsg: TProcLog read FSetMsg Write FSetMsg;
    property SetLog: TProcLog read FSetLog Write FSetLog;
    property Console: TMemo read FConsole write FConsole;
    property Settings: TSettings read FSettings Write FSettings;
  end;

var
  FrmWmiMethodsContainer: TFrmWmiMethodsContainer;

implementation

uses
  WDCC.WMI.Methods,
  Vcl.Styles.TabsClose,
  Vcl.Styles,
  Vcl.Themes;

{$R *.dfm}
{ TForm1 }

procedure TFrmWmiMethodsContainer.ActionDeleteExecute(Sender: TObject);
Var
  LTabSheet: TTabSheet;
begin
  if MsgQuestion(Format('Do you want delete the %s page?', [Trim(PageControl1.ActivePage.Caption)])) then
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

procedure TFrmWmiMethodsContainer.ActionDeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := PageControl1.PageCount > 0;
end;

procedure TFrmWmiMethodsContainer.ActionNewExecute(Sender: TObject);
begin
  CreateNewInstance;
end;

procedure TFrmWmiMethodsContainer.CreateNewInstance;
Var
  LTabSheet: TTabSheet;
  LForm: TFrmWmiMethods;
begin
  LTabSheet := TTabSheet.Create(PageControl1);
  LTabSheet.Caption := Format('WMI Methods CodeGen %d', [PageControl1.PageCount + 1]);
  LTabSheet.PageControl := PageControl1;

  LForm := TFrmWmiMethods.Create(LTabSheet);
  LForm.Parent := LTabSheet;
  LForm.BorderStyle := bsNone;
  LForm.Align := alClient;
  LForm.SetLog := FSetLog;
  LForm.SetMsg := FSetMsg;
  LForm.Settings := FSettings;
  LForm.Console := FConsole;
  LForm.Show;
  PageControl1.ActivePage := LTabSheet;
  DataLoaded := True;
end;

procedure TFrmWmiMethodsContainer.FormCreate(Sender: TObject);
begin
  DataLoaded := False;
end;

procedure TFrmWmiMethodsContainer.FormShow(Sender: TObject);
begin
  if not DataLoaded then
    CreateNewInstance;
end;

initialization

TStyleManager.Engine.RegisterStyleHook(WDCC.WMI.Methods.Container.TPageControl, TTabControlStyleHookBtnClose);

end.
