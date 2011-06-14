unit uComboBox;

interface

uses
  Classes,
  StdCtrls;

type
  TComboBox = class(StdCtrls.TComboBox)
  private
    FItemWidth: integer;
    FDropDownFixedWidth: integer;
    procedure SetDropDownFixedWidth(const Value: integer);
    function GetTextWidth(const AValue: string): integer;
  protected
    procedure DropDown; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ItemWidth: integer Read FItemWidth Write FItemWidth;
  published
    property DropDownFixedWidth: integer Read FDropDownFixedWidth
      Write SetDropDownFixedWidth;
  end;


implementation

uses
  Forms,
  Messages,
  Windows;

{ TComboBox }

constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TComboBox.DropDown;
var
  I: integer;
begin
  inherited DropDown;
  ItemWidth := 0;
  if (FDropDownFixedWidth > 0) then
    Self.Perform(CB_SETDROPPEDWIDTH, FDropDownFixedWidth, 0)
  else
  begin
    for I := 0 to Items.Count - 1 do
      if (GetTextWidth(Items[I]) > ItemWidth) then
        ItemWidth := GetTextWidth(Items[I]) + 8;
    Self.Perform(CB_SETDROPPEDWIDTH, ItemWidth, 0);
  end;
end;

function TComboBox.GetTextWidth(const AValue: string): integer;
begin
  Result := TForm(Owner).Canvas.TextWidth(AValue);
end;

procedure TComboBox.SetDropDownFixedWidth(const Value: integer);
begin
  FDropDownFixedWidth := Value;
end;

end.
