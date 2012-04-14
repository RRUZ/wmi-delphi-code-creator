unit uSqlWMIContainer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ActnMan, uMisc,  Vcl.Styles.ColorTabs,
  Vcl.ActnCtrls, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ImgList;

type
  TFrmSqlWMIContainer = class(TForm)
    ActionToolBar1: TActionToolBar;
    PageControl1: TPageControl;
    ImageList1: TImageList;
    ActionManager1: TActionManager;
    ActionNew: TAction;
    ActionDelete: TAction;
    procedure ActionNewExecute(Sender: TObject);
    procedure ActionDeleteUpdate(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FSetLog: TProcLog;
    DataLoaded : Boolean;
    { Private declarations }
    procedure CreateNewInstance;
  public
    property SetLog : TProcLog read FSetLog Write FSetLog;
  end;

implementation

uses
 uSqlWMI;

{$R *.dfm}

{ TFrmSqlWMIContainer }

procedure TFrmSqlWMIContainer.ActionDeleteExecute(Sender: TObject);
Var
 LTabSheet : TTabSheet;
begin
 if MsgQuestion(Format('Do you want delete the %s page',[PageControl1.ActivePage.Caption])) then
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

procedure TFrmSqlWMIContainer.ActionDeleteUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled:=PageControl1.PageCount>0;
end;

procedure TFrmSqlWMIContainer.ActionNewExecute(Sender: TObject);
begin
 CreateNewInstance;
end;

procedure TFrmSqlWMIContainer.CreateNewInstance;
Var
 LTabSheet : TTabSheet;
 LForm     : TFrmWMISQL;
begin
 LTabSheet:=TTabSheet.Create(PageControl1);
 LTabSheet.Caption:=Format('SQL WMI %d',[PageControl1.PageCount+1]);
 LTabSheet.PageControl:=PageControl1;

 LForm:=TFrmWMISQL.Create(LTabSheet);
 LForm.Parent:=LTabSheet;
 LForm.BorderStyle:=bsNone;
 LForm.Align:=alClient;
 LForm.SetLog:=FSetLog;

 LForm.Show;
 PageControl1.ActivePage:=LTabSheet;

 DataLoaded:=True;
end;

procedure TFrmSqlWMIContainer.FormCreate(Sender: TObject);
begin
  DataLoaded:=False;
end;

procedure TFrmSqlWMIContainer.FormShow(Sender: TObject);
begin
 if not DataLoaded then
  CreateNewInstance;
end;

end.
