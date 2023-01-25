// **************************************************************************************************
//
// Unit WDCC.About
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
// The Original Code is WDCC.About.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2023 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCC.About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage;

type
  TFrmAbout = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    LabelVersion: TLabel;
    LabelWMIVersion: TLabel;
    Button2: TButton;
    MemoCopyRights: TMemo;
    Button3: TButton;
    Image2: TImage;
    btnCheckUpdates: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnCheckUpdatesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  WDCC.Settings,
  WDCC.WMI.GenCode,
  uWmi_Metadata,
  WDCC.Misc,
  ShellApi;

{$R *.dfm}

procedure TFrmAbout.btnCheckUpdatesClick(Sender: TObject);
begin
  CheckForUpdates(False);
end;

procedure TFrmAbout.Button1Click(Sender: TObject);
begin
  Close();
end;

procedure TFrmAbout.Button2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('https://github.com/RRUZ/wmi-delphi-code-creator'), nil, nil, SW_SHOW);
end;

procedure TFrmAbout.Button3Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://theroadtodelphi.wordpress.com/contributions/'), nil, nil, SW_SHOW);
end;

procedure TFrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmAbout.FormCreate(Sender: TObject);
begin
  LabelVersion.Caption := Format('Version %s', [FileVersionStr]);
  LabelWMIVersion.Caption := Format('WMI installed version %s', [GetWmiVersion]);
  MemoCopyRights.Lines.Add('Author Rodrigo Ruz rodrigo.ruz.v@gmail.com - © 2010-2019 all rights reserved.');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('Third Party libraries and tools used');
  MemoCopyRights.Lines.Add('SynEdit https://github.com/SynEdit/SynEdit all rights reserved.');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('AsyncCalls https://github.com/ahausladen/AsyncCalls');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('Artistic Style 2.02 - http://sourceforge.net/projects/astyle/');
  MemoCopyRights.Lines.Add('A Free, Fast and Small Automatic Formatter C, C++, C#, and Java Source Code');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('Go Delphi Go');
end;

procedure TFrmAbout.Image3Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://tp.embarcadero.com/ctprefer?partner_id=1445&product_id=0', nil, nil,
    SW_SHOWNORMAL);
end;

end.
