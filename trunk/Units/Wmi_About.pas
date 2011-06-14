unit Wmi_About;

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
    ImageLogo: TImage;
    MemoCopyRights: TMemo;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

uses
  uWmiGenCode,
  uWmi_Metadata,
  ShellApi;

{$R *.dfm}



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

procedure TFrmAbout.FormCreate(Sender: TObject);
begin
  LabelVersion.Caption    := Format('Version %s', [FileVersionStr]);
  LabelWmiVersion.Caption := Format('WMI installed version %s', [GetWmiVersion]);
  MemoCopyRights.Lines.Add(
    'Author Rodrigo Ruz rodrigo.ruz.v@gmail.com - © 2010 all rights reserved.');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add(
    'SynEdit http://synedit.svn.sourceforge.net/viewvc/synedit/ all rights reserved.');
  MemoCopyRights.Lines.Add(
    'AsyncCalls 2.96 Copyright © 2008-2010 Andreas Hausladen all rights reserved. http://andy.jgknet.de/blog/?page_id=100');
  MemoCopyRights.Lines.Add('ThemedDBGrid Jeremy North ''s  -  Andreas Hausladen');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('');
  MemoCopyRights.Lines.Add('Go Delphi Go');
end;


end.
