{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{
    ThemedDBGrid
    When this unit is added to a project, all TDBGrid components are painted
    themed when run under WinXP with a manifest and active XP theming.

    The source code is based on Jeremy North's ( http://www.jed-software.com )
    ThemedDBGrid unit code with some additions by Andreas Hausladen.

    License Terms
    - there are none

    Comments and improvements welcome.


    History:
      Version 2009-01-08:
        - Fixed Indicator direction in bdRightToLeft BiDiMode (by Issam Ali http://www.issamsoft.com)
        - Fixed: WMEraseBkgnd didn't work correctly in bidiRightToLeft BiDiMode
        - Added: Mouse wheel support
        - Added: Workaround for a RightToLeft painting bug (QC #70075)
      Version 2008-03-21:
        - Added support for Columns[].Title.Alignment
      Version 2008-03-10:
        - Fixed: TitleFont was not used
        - Fixed: indicator column was not aligned to the bottom line of the cells
      Version 2008-03-02:
        - Fixed AccessViolation if DataSource is NIL
        - DefaultDrawing isn't forced anymore
}

unit ThemedDBGrid;

interface

{$IFNDEF CONDITIONALEXPRESSIONS}
'Your Delphi version is not supported. You must have Delphi 7 or higher'
{$ENDIF ~CONDITIONALEXPRESSIONS}

{$IF CompilerVersion < 15.0}
 {$MESSAGE ERROR 'Your Delphi version is not supported. You must have Delphi 7 or higher'}
{$IFEND}

{$IF CompilerVersion >= 18.0}
 {$DEFINE SUPPORTS_INLINE}
{$IFEND}

{$IFNDEF DEBUG}
 {$D-}
{$ENDIF ~DEBUG}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Grids,
  DBGrids, DB, ImgList, Themes;

type
  TPaintInfo = record
    MouseInCol: Integer; // the column that the mouse is in
    ColPressed: Boolean; // a column has been pressed
    ColPressedIdx: Integer; // idx of the pressed column
    ColSizing: Boolean; // currently sizing a column
    ColMoving: Boolean; // currently moving a column
  end;

  TDBGrid = class(DBGrids.TDBGrid) // keep TDBGrid.ClassName = 'TDBGrid'
  private
    FPaintInfo: TPaintInfo;
    FCell: TGridCoord; // currently selected cell
    FAllowTitleClick: Boolean;
    function CentreV(ARect: TRect; ATextHeight: Integer): Integer; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
    function CentreH(ARect: TRect; ATextWidth: Integer): Integer; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
    // col offset used for calculations. Is 1 if indicator is being displayed
    function ColumnOffset(AOptions: TDBGridOptions): Integer; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
    function TitleOffset(AOptions: TDBGridOptions): Integer; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
    function ValidCell(ACell: TGridCoord): Boolean;
    function RowIsMultiSelected: Boolean; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
  protected
    {$IF CompilerVersion >= 18.0}
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    {$IFEND}
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    function BeginColumnDrag(var Origin: Integer; var Destination: Integer; const MousePt: TPoint): Boolean; override;
    procedure ColExit; override;
    procedure ColumnMoved(FromIndex: Integer; ToIndex: Integer); override;
    procedure DrawCell(ACol: Integer; ARow: Integer; ARect: TRect; AState: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure TitleClick(Column: TColumn); override;
    procedure ColWidthsChanged; override;
    function AcquireFocus: Boolean;

    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property AllowTitleClick: Boolean read FAllowTitleClick write FAllowTitleClick default True;
  end;

  TThemeDBGrid = class(TDBGrid)
  published
    property AllowTitleClick;
  end;

implementation

uses
  GraphUtil;

type
  TPrivateCustomDBGrid = class(TCustomGrid)
  private
    FIndicators: TImageList;
  end;

{ TDBGrid }

function TDBGrid.AcquireFocus: Boolean;
begin
  Result := True;
  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    Result := Focused or ((InplaceEditor <> nil) and InplaceEditor.Focused);
  end;
end;

function TDBGrid.BeginColumnDrag(var Origin, Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := inherited BeginColumnDrag(Origin, Destination, MousePt);
  FPaintInfo.ColMoving := Result;
end;

function TDBGrid.CentreV(ARect: TRect; ATextHeight: Integer): Integer;
begin
  Result := ((ARect.Bottom - ARect.Top) - ATextHeight) div 2;
end;

function TDBGrid.CentreH(ARect: TRect; ATextWidth: Integer): Integer;
begin
  Result := ((ARect.Right - ARect.Left) - ATextWidth) div 2;
end;

procedure TDBGrid.CMMouseEnter(var Message: TMessage);
var
  Cell: TGridCoord;
  lPt: TPoint;
begin
  lPt := Point(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  Cell := MouseCoord(lPt.X, lPt.Y);
  if (dgTitles in Options) and (Cell.Y = 0) then
    InvalidateCell(Cell.X, Cell.Y);
end;

procedure TDBGrid.CMMouseLeave(var Message: TMessage);
begin
  if ValidCell(FCell) then
    InvalidateCell(FCell.X, FCell.Y);
  FCell.X := -1;
  FCell.Y := -1;
  FPaintInfo.MouseInCol := -1;
  FPaintInfo.ColPressedIdx := -1;
end;

procedure TDBGrid.ColExit;
begin
  inherited ColExit;
  FPaintInfo.MouseInCol := -1;
  if ValidCell(FCell) then
    InvalidateCell(FCell.X, FCell.Y);
end;

procedure TDBGrid.ColumnMoved(FromIndex, ToIndex: Integer);
begin
  inherited ColumnMoved(FromIndex, ToIndex);
  FPaintInfo.ColMoving := False;
  Invalidate;
end;

function TDBGrid.ColumnOffset(AOptions: TDBGridOptions): Integer;
begin
  if dgIndicator in Options then
    Result := 1
  else
    Result := 0;
end;

type
  TOpenCustomGrid = class(TCustomGrid);
  TInstanceMethod = procedure(Instance: TObject);

procedure TDBGrid.ColWidthsChanged;
var
  I, ChangeCount: Integer;
begin
  TInstanceMethod(@TOpenCustomGrid.ColWidthsChanged)(Self); // inherited TCustomGrid.ColWidthsChanged;

  { Do not generate multiple deLayoutChanged events } 
  if (DataLink.Active or (Columns.State = csCustomized)) and
    AcquireLayoutLock then
  try
    ChangeCount := 0;
    for I := IndicatorOffset to ColCount - 1 do
      if Columns[I - IndicatorOffset].Width <> ColWidths[I] then
      begin
        Inc(ChangeCount);
        if ChangeCount > 1 then // we have what we need
          Break;
      end;
    if ChangeCount > 0 then
    begin
      if ChangeCount > 1 then
        DataLink.DataSet.DisableControls;
      try
        for I := IndicatorOffset to ColCount - 1 do
          if Columns[I - IndicatorOffset].Width <> ColWidths[I] then
            Columns[I - IndicatorOffset].Width := ColWidths[I];
      finally
        if ChangeCount > 1 then
          DataLink.DataSet.EnableControls;
      end;
    end;
  finally
    EndLayout;
  end;
end;

constructor TDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPaintInfo.ColPressed := False;
  FPaintInfo.MouseInCol := -1;
  FPaintInfo.ColPressedIdx := -1;
  FPaintInfo.ColMoving := False;
  FPaintInfo.ColSizing := False;
  FCell.X := -1;
  FCell.Y := -1;
  FAllowTitleClick := True;
end;

function TDBGrid.RowIsMultiSelected: Boolean;
var
  Index: Integer;
begin
  Result := (dgMultiSelect in Options) and DataLink.Active and
    SelectedRows.Find(DataLink.DataSource.DataSet.Bookmark, Index);
end;

function TDBGrid.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  // Do not validate a record by error
  if DataLink.Active and (DataLink.DataSet.State <> dsBrowse) then
    DataLink.DataSet.Cancel;
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
end;

function TDBGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  Distance: Integer;
begin
  Result := False;
  if Assigned(OnMouseWheelDown) then
    OnMouseWheelDown(Self, Shift, MousePos, Result);
  if not Result then
  begin
    if not AcquireFocus then
      Exit;
    if ssCtrl in Shift then
      Distance := VisibleRowCount - 1
    else
    if ssShift in Shift then
      Distance := 1
    else
      Distance := 2;
    if DataLink.Active then
      Result := DataLink.DataSet.MoveBy(Distance) <> 0;
  end;
end;

function TDBGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
var
  Distance: Integer;
begin
  Result := False;
  if Assigned(OnMouseWheelUp) then
    OnMouseWheelUp(Self, Shift, MousePos, Result);
  if not Result then
  begin
    if not AcquireFocus then
      Exit;
    if Shift * [ssShift, ssAlt, ssCtrl] = [ssCtrl] then
      Distance := VisibleRowCount - 1
    else
    if ssShift in Shift then
      Distance := 1
    else
      Distance := 2;
    if DataLink.Active then
      Result := DataLink.DataSet.MoveBy(-Distance) <> 0;
  end;
end;

procedure TDBGrid.DrawCell(ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  Details: TThemedElementDetails;
  lCaptionRect: TRect;
  lCellRect: TRect;
  lStr: string;
  PenRecall: TPenRecall;
  MultiSelected: Boolean;
  OldActive: Integer;
  Indicator: Integer;
  Indicators: TImageList;
  TextX, TextY: Integer;
begin
  lCellRect := ARect;
  if (ARow = 0) and (ACol - ColumnOffset(Options) >= 0) and (dgTitles in Options) and ThemeServices.ThemesEnabled then
  begin
    lCaptionRect := ARect;
    if not FPaintInfo.ColPressed or (FPaintInfo.ColPressedIdx <> ACol) then
    begin
      if (FPaintInfo.MouseInCol = -1) or (FPaintInfo.MouseInCol <> ACol) or (csDesigning in ComponentState) then
        Details := ThemeServices.GetElementDetails(thHeaderItemNormal)
      else
        Details := ThemeServices.GetElementDetails(thHeaderItemHot);
      lCellRect.Right := lCellRect.Right + 1;
      lCellRect.Bottom := lCellRect.Bottom + 2;
    end
    else if AllowTitleClick then
    begin
      Details := ThemeServices.GetElementDetails(thHeaderItemPressed);
      InflateRect(lCaptionRect, -1, 1);
    end
    else
    begin
      if FPaintInfo.MouseInCol = ACol then
        Details := ThemeServices.GetElementDetails(thHeaderItemHot)
      else
        Details := ThemeServices.GetElementDetails(thHeaderItemNormal);
    end;
    ThemeServices.DrawElement(Canvas.Handle, Details, lCellRect);
    Canvas.Brush.Style := bsClear;
    Canvas.Font.Assign(Columns.Items[ACol - ColumnOffset(Options)].Title.Font);
    lStr := Columns.Items[ACol - ColumnOffset(Options)].Title.Caption;
    TextY := lCaptionRect.Top + CentreV(lCaptionRect, Canvas.TextHeight(lStr));
    case Columns.Items[ACol - ColumnOffset(Options)].Title.Alignment of
      taRightJustify:
        TextX := lCaptionRect.Right - 2 - Canvas.TextWidth(lStr);
      taCenter:
        TextX := lCaptionRect.Left + CentreH(lCaptionRect, Canvas.TextWidth(lStr));
    else
      TextX := lCaptionRect.Left + 2;
    end;
    Canvas.TextRect(lCaptionRect, TextX, TextY, lStr);
  end
  else if (ACol = 0) and (dgIndicator in Options) and (gdFixed in AState) and ThemeServices.ThemesEnabled then
  begin
    MultiSelected := False;
    if (ARow >= TitleOffset(Options)) and DataLink.Active then
    begin
      OldActive := DataLink.ActiveRecord;
      try
        DataLink.ActiveRecord := ARow - TitleOffset(Options);
        MultiSelected := RowIsMultiSelected;
      finally
        DataLink.ActiveRecord := OldActive;
      end;
    end;

    // indicator column
    if ARow < TitleOffset(Options) then
      Details := ThemeServices.GetElementDetails(thHeaderItemNormal)
    else
      Details := ThemeServices.GetElementDetails(thHeaderRoot);
    lCellRect.Right := lCellRect.Right + 1;
    lCellRect.Bottom := lCellRect.Bottom + 2;
    ThemeServices.DrawElement(Canvas.Handle, Details, lCellRect);

    // draw the indicator
    if DataLink.Active then
    begin
      Indicator := -1;
      if ((ARow - TitleOffset(Options) = DataLink.ActiveRecord)) then
      begin
        Indicator := 0;
        if DataLink.DataSet <> nil then
        begin
          case DataLink.DataSet.State of
            dsEdit: Indicator := 1;
            dsInsert: Indicator := 2;
          end;
          if Indicator > 0 then
            Inc(ARect.Left); // center edit/insert indicator
        end;
      end
      else
      if MultiSelected and (Indicator = -1) then
        Indicator := 3;

      if Indicator >= 0 then
      begin
        if Indicator = 0 then
        begin
          PenRecall := TPenRecall.Create(Canvas.Pen);
          try
            Canvas.Pen.Color := clWhite;
            DrawArrow(Canvas, sdRight, Point(lCellRect.Left + 4, lCellRect.Top + 3), 5);
            Canvas.Pen.Color := clBlack;
            DrawArrow(Canvas, sdRight, Point(lCellRect.Left + 3, lCellRect.Top + 3), 5);
          finally
            PenRecall.Free;
          end;
        end
        else
        begin
          if Canvas.CanvasOrientation = coRightToLeft then
            Inc(ARect.Left);
          Indicators := TPrivateCustomDBGrid(Self).FIndicators; // get access to the private field
          Indicators.Draw(Canvas,
            ARect.Left + ((ARect.Right - ARect.Left) - Indicators.Width) div 2,
            ARect.Top + ((ARect.Bottom - ARect.Top) - Indicators.Height) div 2,
            Indicator, dsTransparent, itImage, True);
        end;
      end;
    end;
  end
  else
    inherited DrawCell(ACol, ARow, ARect, AState);
end;

procedure TDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lCell: TGridCoord;
begin
  if not (csDesigning in ComponentState) then
  begin
    FPaintInfo.ColSizing := Sizing(X, Y);
    if not FPaintInfo.ColSizing then
    begin
      FPaintInfo.ColPressedIdx := -1;
      FPaintInfo.ColPressed := False;
      if AllowTitleClick then
        FPaintInfo.MouseInCol := -1;
      lCell := MouseCoord(X,Y);
      if (Button = mbLeft) and (lCell.X >= IndicatorOffset) and (lCell.Y >= 0) and AllowTitleClick then
      begin
        FPaintInfo.ColPressed := lCell.Y < TitleOffset(Options);
        if FPaintInfo.ColPressed then
          FPaintInfo.ColPressedIdx := Columns[RawToDataColumn(lCell.X)].Index + ColumnOffset(Options);
        if ValidCell(FCell) then
          InvalidateCell(FCell.X, FCell.Y);
        FCell := lCell;
      end;
    end;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;

function GridCoordEqual(const aCell1, aCell2: TGridCoord): Boolean; {$IFDEF SUPPORTS_INLINE} inline; {$ENDIF}
begin
  Result := (aCell1.X = aCell2.X) and (aCell2.X = aCell2.X);
end;

procedure TDBGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  lCell: TGridCoord;
  lMouseInCol: Integer;
begin
  if not (csDesigning in ComponentState) then
  begin
    if not FPaintInfo.ColSizing and not FPaintInfo.ColMoving then
    begin
      FPaintInfo.MouseInCol := -1;
      lCell := MouseCoord(X,Y);
      if (lCell.X <> FCell.X) or (lCell.Y <> FCell.Y) then
      begin
        if (lCell.X >= IndicatorOffset) and (lCell.Y >= 0) then
        begin
          if lCell.Y < TitleOffset(Options) then
          begin
            lMouseInCol := Columns[RawToDataColumn(lCell.X)].Index + ColumnOffset(Options);
            if lMouseInCol <> FPaintInfo.MouseInCol then
            begin
              InvalidateCell(lCell.X, lCell.Y);
              FPaintInfo.MouseInCol := lMouseInCol;
            end;
          end
        end;
        if ValidCell(FCell) then
          InvalidateCell(FCell.X, FCell.Y);
        FCell := lCell;
      end;
    end;
  end;
  inherited MouseMove(Shift, X, Y);
end;

procedure TDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FPaintInfo.ColSizing := False;
  FPaintInfo.ColMoving := False;
  FPaintInfo.ColPressedIdx := -1;
  FCell.X := -1;
  FCell.Y := -1;
  Invalidate;
end;

procedure TDBGrid.Paint;
begin
  if ThemeServices.ThemesEnabled then
  begin
    // Reset the inherited options but remove the goFixedVertLine and goFixedHorzLine values
    // as that causes the titles and indicator panels to have a black border
    TStringGrid(Self).Options := TStringGrid(Self).Options - [goFixedVertLine];
    TStringGrid(Self).Options := TStringGrid(Self).Options - [goFixedHorzLine];
  end;
  inherited Paint;
end;

procedure TDBGrid.TitleClick(Column: TColumn);
begin
  inherited TitleClick(Column);
  if AllowTitleClick then
  begin
    FPaintInfo.ColPressed := False;
    FPaintInfo.ColPressedIdx := -1;
    if ValidCell(FCell) then
      InvalidateCell(FCell.X, FCell.Y);
  end;
end;

function TDBGrid.TitleOffset(AOptions: TDBGridOptions): Integer;
begin
  if dgTitles in Options then
    Result := 1
  else
    Result := 0;
end;

function TDBGrid.ValidCell(ACell: TGridCoord): Boolean;
begin
  Result := (ACell.X <> -1) and (ACell.Y <> -1);
end;

{$IF CompilerVersion >= 18.0}
procedure TDBGrid.WMPaint(var Message: TWMPaint);
var
  R: TRect;
begin
  if UseRightToLeftAlignment then
  begin
    { Workaround for a RightToLeft painting bug (QC #70075)
      Side effect: The grid needs more time to paint }
    R.TopLeft := ClientRect.TopLeft;
    R.BottomRight := ClientRect.BottomRight;
    InvalidateRect(Handle, @R, False);
  end;
  inherited;
end;
{$IFEND}

procedure TDBGrid.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  R: TRect;
  Size: TSize;
begin
  { Fill the area between the two scroll bars. }
  Size.cx := GetSystemMetrics(SM_CXVSCROLL);
  Size.cy := GetSystemMetrics(SM_CYHSCROLL);
  if UseRightToLeftAlignment then
    R := Bounds(0, Height - Size.cy, Size.cx, Size.cy)
  else
    R := Bounds(Width - Size.cx, Height - Size.cy, Size.cx, Size.cy);
  FillRect(Message.DC, R, Self.Brush.Handle);
  Message.Result := 1; // the grid paints its content in the Paint method
end;

{------------------------------------------------------------------------------}

function TDBGrid_NewInstance(AClass: TClass): TObject;
begin
  Result := TDBGrid.NewInstance;
end;

function GetVirtualMethod(AClass: TClass; const VmtOffset: Integer): Pointer;
begin
  Result := PPointer(Integer(AClass) + VmtOffset)^;
end;

procedure SetVirtualMethod(AClass: TClass; const VmtOffset: Integer; const Method: Pointer);
var
  WrittenBytes: DWORD;
  PatchAddress: PPointer;
begin
  PatchAddress := Pointer(Integer(AClass) + VmtOffset);
  WriteProcessMemory(GetCurrentProcess, PatchAddress, @Method, SizeOf(Method), WrittenBytes);
end;

{$IFOPT W+}{$DEFINE WARN}{$ENDIF}{$WARNINGS OFF} // no compiler warning
const
  vmtNewInstance = System.vmtNewInstance;
{$IFDEF WARN}{$WARNINGS ON}{$ENDIF}

var
  OrgTDBGrid_NewInstance: Pointer;

initialization
  OrgTDBGrid_NewInstance := GetVirtualMethod(TDBGrid, vmtNewInstance);
  SetVirtualMethod(DBGrids.TDBGrid, vmtNewInstance, @TDBGrid_NewInstance);

finalization
  SetVirtualMethod(DBGrids.TDBGrid, vmtNewInstance, OrgTDBGrid_NewInstance);

end.

