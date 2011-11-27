{**************************************************************************************************}
{                                                                                                  }
{ Unit uXE2Patches                                                                                 }
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
{ The Original Code is uXE2Patches.pas.                                                            }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}

unit uXE2Patches;

interface

uses
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.ImgList,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.ComCtrls,
  Vcl.Themes;

type
  TMyTabControlStyleHook = class(TMouseTrackControlStyleHook)
  strict private
    FHotTabIndex: Integer;
    FMousePosition: TMouseTrackControlStyleHook.TMousePosition;
    FUpDownHandle: HWnd;
    FUpDownInstance: Pointer;
    FUpDownDefWndProc: Pointer;
    FUpDownLeftPressed, FUpDownRightPressed: Boolean;
    FUpDownMouseOnLeft, FUpDownMouseOnRight: Boolean;
    procedure AngleTextOut(Canvas: TCanvas; Angle: Integer; X, Y: Integer; const Text: string);
    function GetDisplayRect: TRect;
    function GetImages: TCustomImageList;
    function GetTabCount: Integer;
    function GetTabIndex: Integer;
    function GetTabPosition: TTabPosition;
    function GetTabRect(Index: Integer): TRect;
    function GetTabs(Index: Integer): string;
    procedure HookUpDownControl;
    procedure UpdateTabs(OldHotTab, HotTab: Integer);
    procedure UpdateUpDownArea;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure WMMouseMove(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMParentNotify(var Message: TMessage); message WM_PARENTNOTIFY;
  strict protected
    procedure DrawTab(Canvas: TCanvas; Index: Integer); virtual;
    function IndexOfTabAt(X, Y: Integer): Integer;
    procedure Paint(Canvas: TCanvas); override;
    procedure PaintBackground(Canvas: TCanvas); override;
    procedure PaintUpDown(Canvas: TCanvas); virtual;
    procedure UpDownWndProc(var Msg: TMessage); virtual;
    procedure WndProc(var Message: TMessage); override;
    property DisplayRect: TRect read GetDisplayRect;
    property HotTabIndex: Integer read FHotTabIndex;
    property Images: TCustomImageList read GetImages;
    property TabCount: Integer read GetTabCount;
    property TabIndex: Integer read GetTabIndex;
    property TabPosition: TTabPosition read GetTabPosition;
    property TabRect[Index: Integer]: TRect read GetTabRect;
    property Tabs[Index: Integer]: string read GetTabs;
  public
    constructor Create(AControl: TWinControl); override;
    destructor Destroy; override;
  end;

implementation

Uses
  Winapi.CommCtrl,
  System.Classes;

type
   THackCustomTabControl  =class (TCustomTabControl);
   TControlClass = class(TWinControl);


{ TMyTabControlStyleHook }

procedure TMyTabControlStyleHook.AngleTextOut(Canvas: TCanvas; Angle, X,
  Y: Integer; const Text: string);
var
  NewFontHandle, OldFontHandle: hFont;
  LogRec: TLogFont;
begin
  GetObject(Canvas.Font.Handle, SizeOf(LogRec), Addr(LogRec));
  LogRec.lfEscapement := Angle * 10;
  LogRec.lfOrientation := LogRec.lfEscapement;
  NewFontHandle := CreateFontIndirect(LogRec);
  OldFontHandle := SelectObject(Canvas.Handle, NewFontHandle);
  SetBkMode(Canvas.Handle, TRANSPARENT);
  Canvas.TextOut(X, Y, Text);
  NewFontHandle := SelectObject(Canvas.Handle, OldFontHandle);
  DeleteObject(NewFontHandle);
end;

procedure TMyTabControlStyleHook.CMMouseLeave(var Message: TMessage);
begin
  WMMouseMove(Message);
end;

procedure TMyTabControlStyleHook.CNNotify(var Message: TWMNotify);
begin
  if (Message.NMHdr.Code = TCN_SELCHANGE) and (LongWord(Message.IDCtrl) = Handle) and (FUpDownHandle <> 0) then
    UpdateUpDownArea;
end;

constructor TMyTabControlStyleHook.Create(AControl: TWinControl);
begin
  inherited;
  DoubleBuffered := True;
  OverridePaint := True;
  OverrideEraseBkgnd := True;
  FUpDownInstance := nil;
  FUpDownHandle := 0;
  FUpDownDefWndProc := nil;
  FUpDownLeftPressed := False;
  FUpDownRightPressed := False;
  FUpDownMouseOnLeft := False;
  FUpDownMouseOnRight := False;
end;

destructor TMyTabControlStyleHook.Destroy;
begin
  if FUpDownHandle <> 0 then
    SetWindowLong(FUpDownHandle, GWL_WNDPROC, IntPtr(FUpDownDefWndProc));
  FreeObjectInstance(FUpDownInstance);
  inherited;
end;

procedure TMyTabControlStyleHook.DrawTab(Canvas: TCanvas; Index: Integer);
var
  R, LayoutR, GlyphR: TRect;
  ImageWidth, ImageHeight, ImageStep, TX, TY: Integer;
  DrawState: TThemedTab;
  Details: TThemedElementDetails;
  ThemeTextColor: TColor;
  ImageIndex:Integer;
begin

  ImageIndex:=0;
  if (Control <> nil) and (Control is TCustomTabControl) then
   ImageIndex:=THackCustomTabControl(Control).GetImageIndex(Index);



  if (Images <> nil) and (ImageIndex < Images.Count) then
  begin
    ImageWidth := Images.Width;
    ImageHeight := Images.Height;
    ImageStep := 3;
  end
  else
  begin
    ImageWidth := 0;
    ImageHeight := 0;
    ImageStep := 0;
  end;

  R := TabRect[Index];
  if R.Left < 0 then Exit;

  if TabPosition in [tpTop, tpBottom] then
  begin
    if Index = TabIndex then
      InflateRect(R, 0, 2);
  end
  else if Index = TabIndex then
    Dec(R.Left, 2) else Dec(R.Right, 2);

  Canvas.Font.Assign(THackCustomTabControl(Control).Font);
  LayoutR := R;
  DrawState := ttTabDontCare;
  case TabPosition of
    tpTop:
      begin
        if Index = TabIndex then
          DrawState := ttTabItemSelected
        else if (Index = FHotTabIndex) and MouseInControl then
          DrawState := ttTabItemHot
        else
          DrawState := ttTabItemNormal;
      end;
    tpLeft:
      begin
        if Index = TabIndex then
          DrawState := ttTabItemLeftEdgeSelected
        else if (Index = FHotTabIndex) and MouseInControl then
          DrawState := ttTabItemLeftEdgeHot
        else
          DrawState := ttTabItemLeftEdgeNormal;
      end;
    tpBottom:
      begin
        if Index = TabIndex then
          DrawState := ttTabItemBothEdgeSelected
        else if (Index = FHotTabIndex) and MouseInControl then
          DrawState := ttTabItemBothEdgeHot
        else
          DrawState := ttTabItemBothEdgeNormal;
      end;
    tpRight:
      begin
        if Index = TabIndex then
          DrawState := ttTabItemRightEdgeSelected
        else if (Index = FHotTabIndex) and MouseInControl then
          DrawState := ttTabItemRightEdgeHot
        else
          DrawState := ttTabItemRightEdgeNormal;
      end;
  end;

  if StyleServices.Available then
  begin
    Details := StyleServices.GetElementDetails(DrawState);
    StyleServices.DrawElement(Canvas.Handle, Details, R);
  end;

  { Image }
  if (Images <> nil) and (ImageIndex < Images.Count) then
  begin
    GlyphR := LayoutR;
    case TabPosition of
      tpTop, tpBottom:
        begin
          GlyphR.Left := GlyphR.Left + ImageStep;
          GlyphR.Right := GlyphR.Left + ImageWidth;
          LayoutR.Left := GlyphR.Right;
          GlyphR.Top := GlyphR.Top + (GlyphR.Bottom - GlyphR.Top) div 2 - ImageHeight div 2;
          if (TabPosition = tpTop) and (Index = TabIndex) then
            OffsetRect(GlyphR, 0, -1)
          else if (TabPosition = tpBottom) and (Index = TabIndex) then
            OffsetRect(GlyphR, 0, 1);
        end;
      tpLeft:
        begin
          GlyphR.Bottom := GlyphR.Bottom - ImageStep;
          GlyphR.Top := GlyphR.Bottom - ImageHeight;
          LayoutR.Bottom := GlyphR.Top;
          GlyphR.Left := GlyphR.Left + (GlyphR.Right - GlyphR.Left) div 2 - ImageWidth div 2;
        end;
      tpRight:
        begin
          GlyphR.Top := GlyphR.Top + ImageStep;
          GlyphR.Bottom := GlyphR.Top + ImageHeight;
          LayoutR.Top := GlyphR.Bottom;
          GlyphR.Left := GlyphR.Left + (GlyphR.Right - GlyphR.Left) div 2 - ImageWidth div 2;
        end;
    end;
    if StyleServices.Available then
      StyleServices.DrawIcon(Canvas.Handle, Details, GlyphR, Images.Handle, ImageIndex);
  end;

  { Text }
  if StyleServices.Available then
  begin
    if (TabPosition = tpTop) and (Index = TabIndex) then
      OffsetRect(LayoutR, 0, -1)
    else if (TabPosition = tpBottom) and (Index = TabIndex) then
      OffsetRect(LayoutR, 0, 1);

    if TabPosition = tpLeft then
    begin
      TX := LayoutR.Left + (LayoutR.Right - LayoutR.Left) div 2 -
        Canvas.TextHeight(Tabs[Index]) div 2;
      TY := LayoutR.Top + (LayoutR.Bottom - LayoutR.Top) div 2 +
        Canvas.TextWidth(Tabs[Index]) div 2;
     if StyleServices.GetElementColor(Details, ecTextColor, ThemeTextColor) then
       Canvas.Font.Color := ThemeTextColor;
      AngleTextOut(Canvas, 90, TX, TY, Tabs[Index]);
    end
    else if TabPosition = tpRight then
    begin
      TX := LayoutR.Left + (LayoutR.Right - LayoutR.Left) div 2 +
        Canvas.TextHeight(Tabs[Index]) div 2;
      TY := LayoutR.Top + (LayoutR.Bottom - LayoutR.Top) div 2 -
        Canvas.TextWidth(Tabs[Index]) div 2;
      if StyleServices.GetElementColor(Details, ecTextColor, ThemeTextColor)
      then
        Canvas.Font.Color := ThemeTextColor;
      AngleTextOut(Canvas, -90, TX, TY, Tabs[Index]);
    end
    else
      DrawControlText(Canvas, Details, Tabs[Index], LayoutR, DT_VCENTER or DT_CENTER or DT_SINGLELINE  or DT_NOCLIP);
  end;
end;

function TMyTabControlStyleHook.GetDisplayRect: TRect;
begin
  Result := Rect(0, 0, 0, 0);
  if (Control <> nil) and (Control is TCustomTabControl) then
    Result := THackCustomTabControl(Control).DisplayRect
  else
  begin
    Result := Control.ClientRect;
    SendMessage(Handle, TCM_ADJUSTRECT, 0, IntPtr(@Result));
    Inc(Result.Top, 2);
  end;
end;

function TMyTabControlStyleHook.GetImages: TCustomImageList;
begin
  Result := nil;
  if Control is TCustomTabControl then
    Result := THackCustomTabControl(Control).Images;
end;

function TMyTabControlStyleHook.GetTabCount: Integer;
begin
  Result := SendMessage(Handle, TCM_GETITEMCOUNT, 0, 0);
end;

function TMyTabControlStyleHook.GetTabIndex: Integer;
begin
  if Control is TCustomTabControl then
    Result := THackCustomTabControl(Control).TabIndex
  else
    Result := SendMessage(Handle, TCM_GETCURSEL, 0, 0);
end;

function TMyTabControlStyleHook.GetTabPosition: TTabPosition;
begin
  Result := tpTop;
  if Control is TCustomTabControl then
    Result := THackCustomTabControl(Control).TabPosition;
end;


function TMyTabControlStyleHook.GetTabRect(Index: Integer): TRect;
begin
  Result := TRect.Empty;
  if (Control is TCustomTabControl) then
    Result := TCustomTabControl(Control).TabRect(Index)
  else if Handle <> 0 then
    TabCtrl_GetItemRect(Handle, Index, Result);
end;

function TMyTabControlStyleHook.GetTabs(Index: Integer): string;
var
  TCItem: TTCItem;
  Buffer: array[0..254] of Char;
begin
  FillChar(TCItem, Sizeof(TCItem), 0);

  TCItem.mask := TCIF_TEXT;
  TCItem.pszText := @Buffer;
  TCItem.cchTextMax := SizeOf(Buffer);
  if SendMessageW(Handle, TCM_GETITEMW, Index, IntPtr(@TCItem)) <> 0 then
    Result := TCItem.pszText
  else
    Result := '';
end;


procedure TMyTabControlStyleHook.HookUpDownControl;
begin
  if FUpDownHandle <> 0 then Exit;
  FUpDownHandle := FindWindowEx(Handle, 0, 'msctls_updown32', nil); // do not localize
  if FUpDownHandle <> 0 then
  begin
    FUpDownInstance := MakeObjectInstance(UpDownWndProc);
    FUpDownDefWndProc := Pointer(GetWindowLong(FUpDownHandle, GWL_WNDPROC));
    SetWindowLong(FUpDownHandle, GWL_WNDPROC, IntPtr(FUpDownInstance));
  end;
end;

function TMyTabControlStyleHook.IndexOfTabAt(X, Y: Integer): Integer;
var
  HitTest: TTCHitTestInfo;
begin
  if (Control <> nil) and (Control is TCustomTabControl) then
    Result := TCustomTabControl(Control).IndexOfTabAt(X, Y)
  else
  begin
    Result := -1;
    if PtInRect(Control.ClientRect, Point(X, Y)) then
      with HitTest do
      begin
        pt.X := X;
        pt.Y := Y;
        Result := TabCtrl_HitTest(Handle, @HitTest);
      end;
  end;
end;

procedure TMyTabControlStyleHook.Paint(Canvas: TCanvas);
var
  R: TRect;
  I, SaveIndex: Integer;
  Details: TThemedElementDetails;
begin
  SaveIndex := SaveDC(Canvas.Handle);
  try
    R := DisplayRect;
    ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
    PaintBackground(Canvas);
  finally
    RestoreDC(Canvas.Handle, SaveIndex);
  end;

  { Draw tabs }
  for I := 0 to TabCount - 1 do
  begin
    if I = TabIndex then
      Continue;
    DrawTab(Canvas, I);
  end;

  { Draw body }
  case TabPosition of
    tpTop: InflateRect(R, Control.Width - R.Right, Control.Height - R.Bottom);
    tpLeft: InflateRect(R, Control.Width - R.Right, Control.Height - R.Bottom);
    tpBottom: InflateRect(R, R.Left, R.Top);
    tpRight: InflateRect(R, R.Left, R.Top);
  end;

  if StyleServices.Available then
  begin
    Details := StyleServices.GetElementDetails(ttPane);
    StyleServices.DrawElement(Canvas.Handle, Details, R);
  end;

  { Draw active tab }
  if TabIndex >= 0 then
    DrawTab(Canvas, TabIndex);

  // paint other controls
  TControlClass(Control).PaintControls(Canvas.Handle, nil);
end;


procedure TMyTabControlStyleHook.PaintBackground(Canvas: TCanvas);
var
  Details: TThemedElementDetails;
begin
  if StyleServices.Available then
  begin
    Details := StyleServices.GetElementDetails(ttPane);
    StyleServices.DrawParentBackground(Handle, Canvas.Handle, Details, False);
  end;
end;

procedure TMyTabControlStyleHook.PaintUpDown(Canvas: TCanvas);
var
  Buffer: Vcl.Graphics.TBitmap;
  R, BoundsRect: TRect;
  DrawState: TThemedScrollBar;
  Details: TThemedElementDetails;
begin
  GetWindowRect(FUpDownHandle, BoundsRect);
  if (BoundsRect.Width = 0) or (BoundsRect.Height = 0) or not StyleServices.Available then
    Exit;
  {create buffer}
  Buffer := Vcl.Graphics.TBitmap.Create;
  try
    Buffer.Width := BoundsRect.Width;
    Buffer.Height := BoundsRect.Height;
    R := TRect.Create(0, 0, Buffer.Width, Buffer.Height);

    Buffer.Canvas.Brush.Color := StyleServices.ColorToRGB(clBtnFace);
    Buffer.Canvas.FillRect(R);
    {left button}
    R.Right := R.Left + R.Width div 2;
    if FUpDownLeftPressed then
       DrawState := tsArrowBtnLeftPressed
    else if FUpDownMouseOnLeft {and MouseInControl} then
      DrawState := tsArrowBtnLeftHot
    else
      DrawState := tsArrowBtnLeftNormal;
    Details := StyleServices.GetElementDetails(DrawState);
    StyleServices.DrawElement(Buffer.Canvas.Handle, Details, R);
    {right button}
    R := TRect.Create(0, 0, Buffer.Width, Buffer.Height);
    R.Left := R.Right - R.Width div 2;
    if FUpDownRightPressed then
      DrawState := tsArrowBtnRightPressed
    else if FUpDownMouseOnRight {and MouseInControl} then
      DrawState :=  tsArrowBtnRightHot
    else
      DrawState :=  tsArrowBtnRightNormal;
    Details := StyleServices.GetElementDetails(DrawState);
    StyleServices.DrawElement(Buffer.Canvas.Handle, Details, R);
    {draw buffer}
    Canvas.Draw(0, 0, Buffer);
  finally
    Buffer.Free;
  end;
end;

procedure TMyTabControlStyleHook.UpdateTabs(OldHotTab, HotTab: Integer);
var
  R: TRect;
begin
  if (OldHotTab >= 0) and (OldHotTab < TabCount) then
  begin
    R := TabRect[OldHotTab];
    InvalidateRect(Handle, @R, True);
  end;
  if (HotTab >= 0) and (HotTab < TabCount) then
  begin
    R := TabRect[HotTab];
    InvalidateRect(Handle, @R, True);
  end;
end;


procedure TMyTabControlStyleHook.UpdateUpDownArea;
var
  R, R1: TRect;
  P: TPoint;
begin
  if FUpDownHandle = 0 then
    Exit;
  GetWindowRect(FUpDownHandle, R);
  P := Control.ScreenToClient(Point(R.Left, R.Top));
  if TabPosition = tpTop then
  begin
    R1 := Rect(P.X, 0, P.X + R.Width, P.Y + R.Height + 5);
    RedrawWindow(Handle, R1, 0, RDW_INVALIDATE);
  end
  else
  begin
    R1 := Rect(P.X, P.Y - 5, P.X + R.Width, Control.Height);
    RedrawWindow(Handle, R1, 0, RDW_INVALIDATE);
  end;
end;

procedure TMyTabControlStyleHook.UpDownWndProc(var Msg: TMessage);
var
  FCallOldProc: Boolean;

  procedure WMLButtonDblClk(var Msg: TWMMouse);
  var
    R, R1: TRect;
  begin
    SendMessage(FUpDownHandle, WM_SETREDRAW, 0, 0);
    Msg.Result := CallWindowProc(FUpDownDefWndProc, FUpDownHandle,
      Msg.Msg, TMessage(Msg).WParam, TMessage(Msg).LParam);
    SendMessage(FUpDownHandle, WM_SETREDRAW, 1, 0);
    GetWindowRect(FUpDownHandle, R);
    R1 := Rect(0, 0, R.Width, R.Height);
    R1.Right := R1.Left +  R1.Width div 2;
    if PtInRect(R1, Point(Msg.XPos, Msg.YPos)) then
      FUpDownLeftPressed := True
    else
      FUpDownLeftPressed := False;
    R1 := Rect(0, 0, R.Width, R.Height);
    R1.Left := R1.Right - R1.Width div 2;
    if PtInRect(R1, Point(Msg.XPos, Msg.YPos)) then
      FUpDownRightPressed := True
    else
      FUpDownRightPressed := False;
    RedrawWindow(FUpDownHandle, nil, 0, RDW_INVALIDATE);
    FCallOldProc := False;
  end;

  procedure WMLButtonDown(var Msg: TWMMouse);
  begin
    WMLButtonDblClk(Msg);
  end;

  procedure WMLButtonUp(var Msg: TWMMouse);
  begin
    SendMessage(FUpDownHandle, WM_SETREDRAW, 0, 0);
    Msg.Result := CallWindowProc(FUpDownDefWndProc, FUpDownHandle,
      Msg.Msg, TMessage(Msg).WParam, TMessage(Msg).LParam);
    SendMessage(FUpDownHandle, WM_SETREDRAW, 1, 0);
    FUpDownLeftPressed := False;
    FUpDownRightPressed := False;
    RedrawWindow(FUpDownHandle, nil, 0, RDW_INVALIDATE);
    UpdateUpDownArea;
    FCallOldProc := False;
  end;

  procedure WMMouseMove(var Msg: TWMMouse);
  var
    R, R1: TRect;
    FOldUpDownMouseOnLeft, FOldUpDownMouseOnRight: Boolean;
  begin
    Msg.Result := CallWindowProc(FUpDownDefWndProc, FUpDownHandle,
      Msg.Msg, TMessage(Msg).WParam, TMessage(Msg).LParam);

    FOldUpDownMouseOnLeft := FUpDownMouseOnLeft;
    FOldUpDownMouseOnRight := FUpDownMouseOnRight;

    GetWindowRect(FUpDownHandle, R);

    R1 := Rect(0, 0, R.Width, R.Height);
    R1.Right := R1.Left +  R1.Width div 2;
    if PtInRect(R1, Point(Msg.XPos, Msg.YPos)) then
      FUpDownMouseOnLeft := True
    else
      FUpDownMouseOnLeft := False;
    R1 := Rect(0, 0, R.Width, R.Height);
    R1.Left := R1.Right - R1.Width div 2;
    if PtInRect(R1, Point(Msg.XPos, Msg.YPos)) then
      FUpDownMouseOnRight := True
    else
      FUpDownMouseOnRight := False;

    if (FOldUpDownMouseOnLeft <> FUpDownMouseOnLeft) or
       (FOldUpDownMouseOnRight <> FUpDownMouseOnRight) then
      RedrawWindow(FUpDownHandle, nil, 0, RDW_INVALIDATE);

    FCallOldProc := False;
  end;

  procedure WMMouseLeave(Msg: TMessage);
  begin
    FUpDownMouseOnLeft := False;
    FUpDownMouseOnRight := False;
    FUpDownLeftPressed := False;
    FUpDownRightPressed := False;
    RedrawWindow(FUpDownHandle, nil, 0, RDW_INVALIDATE);
  end;

  procedure WMPaint(Msg: TMessage);
  var
    DC: HDC;
    Canvas: TCanvas;
    PS: TPaintStruct;
  begin
    DC := Msg.WParam;
    Canvas := TCanvas.Create;
    if DC <> 0 then
      Canvas.Handle := DC
    else
      Canvas.Handle := BeginPaint(FUpDownHandle, PS);
    try
      PaintUpDown(Canvas);
    finally
      if DC = 0 then
        EndPaint(FUpDownHandle, PS);
      Canvas.Handle := 0;
      Canvas.Free;
    end;
    FCallOldProc := False;
  end;

begin
  FCallOldProc := True;
  case Msg.Msg of
    WM_MOUSELEAVE: WMMouseLeave(Msg);
    WM_LBUTTONDBLCLK: WMLButtonDblClk(TWMMouse(Msg));
    WM_LBUTTONDOWN: WMLButtonDown(TWMMouse(Msg));
    WM_LBUTTONUP: WMLButtonUp(TWMMouse(Msg));
    WM_MOUSEMOVE:  WMMouseMove(TWMMouse(Msg));
    WM_PAINT: WMPaint(Msg);
  end;
  if FCallOldProc then
    Msg.Result := CallWindowProc(FUpDownDefWndProc, FUpDownHandle,
      Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TMyTabControlStyleHook.WMEraseBkgnd(var Message: TMessage);
var
  Details: TThemedElementDetails;
begin
  if (Message.LParam = 1) and StyleServices.Available then
  begin
    Details := StyleServices.GetElementDetails(ttPane);
    StyleServices.DrawElement(HDC(Message.WParam), Details, Control.ClientRect);
  end;
  Message.Result := 1;
  Handled := True;
end;

procedure TMyTabControlStyleHook.WMMouseMove(var Message: TMessage);
var
  Index, OldIndex: Integer;
begin
  inherited;
  CallDefaultProc(Message);
  FMousePosition := mpNone;
  Index := IndexOfTabAt(TWMMouseMove(Message).XPos, TWMMouseMove(Message).YPos);
  if Index <> FHotTabIndex then
  begin
    OldIndex := FHotTabIndex;
    FHotTabIndex := Index;
    UpdateTabs(OldIndex, Index);
  end;
end;


procedure TMyTabControlStyleHook.WMParentNotify(var Message: TMessage);
begin
  if FUpDownHandle = 0 then
    HookUpDownControl;
end;

procedure TMyTabControlStyleHook.WndProc(var Message: TMessage);
begin
  inherited;
end;


end.
