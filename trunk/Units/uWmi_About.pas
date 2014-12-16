{**************************************************************************************************}
{                                                                                                  }
{ Unit uWmi_About                                                                                  }
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
{ The Original Code is uWmi_About.pas.                                                             }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2013 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uWmi_About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage;

type
  TFrmAbout = class(TForm)
    Panel1:    TPanel;
    Button1:   TButton;
    Image1:    TImage;
    Label1:    TLabel;
    LabelVersion: TLabel;
    LabelWMIVersion: TLabel;
    Button2:   TButton;
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
  uCheckUpdate,
  uSettings,
  uWmiGenCode,
  uWmi_Metadata,
  ShellApi;

{$R *.dfm}



procedure TFrmAbout.btnCheckUpdatesClick(Sender: TObject);
var
  Frm: TFrmCheckUpdate;
begin
  Frm := GetUpdaterInstance;
  try
    Frm.ShowModal();
  finally
    Frm.Free;
  end;
end;

procedure TFrmAbout.Button1Click(Sender: TObject);
begin
  Close();
end;

procedure TFrmAbout.Button2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://theroadtodelphi.wordpress.com/wmi-delphi-code-creator/'), nil,
    nil, SW_SHOW);
end;

procedure TFrmAbout.Button3Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', PChar('http://theroadtodelphi.wordpress.com/contributions/'), nil, nil, SW_SHOW);
end;

procedure TFrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TFrmAbout.FormCreate(Sender: TObject);
begin
  LabelVersion.Caption    := Format('Version %s', [FileVersionStr]);
  LabelWmiVersion.Caption := Format('WMI installed version %s', [GetWmiVersion]);
  MemoCopyRights.Lines.Add(
    'Author Rodrigo Ruz rodrigo.ruz.v@gmail.com - © 2010-2014 all rights reserved.');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('Third Party libraries and tools used');
  MemoCopyRights.Lines.Add(
    'SynEdit http://synedit.svn.sourceforge.net/viewvc/synedit/ all rights reserved.');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add(
    'AsyncCalls 2.98 Copyright © 2008-2011 Andreas Hausladen all rights reserved.');
  MemoCopyRights.Lines.Add('http://andy.jgknet.de/blog/?page_id=100');
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
  ShellExecute(Handle, 'open', 'http://tp.embarcadero.com/ctprefer?partner_id=1445&product_id=0',nil,nil, SW_SHOWNORMAL) ;
end;

end.
