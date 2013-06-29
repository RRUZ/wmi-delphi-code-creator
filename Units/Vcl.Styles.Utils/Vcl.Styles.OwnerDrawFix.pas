{**************************************************************************************************}
{                                                                                                  }
{ Unit Vcl.Styles.OwnerDrawFix                                                                     }
{ unit for the VCL Styles Utils                                                                    }
{ http://code.google.com/p/vcl-styles-utils/                                                       }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is Vcl.Styles.OwnerDrawFix.pas.                                                }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2012-2013 Rodrigo Ruz V.                    }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit Vcl.Styles.OwnerDrawFix;

interface

uses
 Winapi.Windows,
 Winapi.CommCtrl,
 Vcl.ComCtrls,
 Vcl.Graphics,
 Vcl.StdCtrls,
 Vcl.Controls,
 Vcl.Styles,
 Vcl.Themes,
 System.Classes;

type
  TVclStylesOwnerDrawFix=class
  public
    procedure ComboBoxDrawItem(Control: TWinControl; Index: Integer;  Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ListViewDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect; State: TOwnerDrawState);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   // procedure TreeViewAdvancedCustomDrawItem(Sender: TCustomTreeView;
  //Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages,
  //DefaultDraw: Boolean);
  end;

var
  VclStylesOwnerDrawFix : TVclStylesOwnerDrawFix;

implementation

uses
  Winapi.UxTheme,
  System.SysUtils;

type
  TCustomListViewClass=class(TCustomListView);

{ TVclStylesOwnerDrawFix }

procedure TVclStylesOwnerDrawFix.ComboBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
const
  ColorStates: array[Boolean] of TStyleColor = (scComboBoxDisabled, scComboBox);
  FontColorStates: array[Boolean] of TStyleFont = (sfComboBoxItemDisabled, sfComboBoxItemNormal);
var
  LStyles  : TCustomStyleServices;
begin
  LStyles  :=StyleServices;
  with Control as TComboBox do
  begin
    Canvas.Brush.Color := LStyles.GetStyleColor(ColorStates[Control.Enabled]);
    Canvas.Font.Color  := LStyles.GetStyleFontColor(FontColorStates[Control.Enabled]);

    if odSelected in State then
    begin
     Canvas.Brush.Color := LStyles.GetSystemColor(clHighlight);
     Canvas.Font.Color  := LStyles.GetSystemColor(clHighlightText);
    end;

    Canvas.FillRect(Rect) ;
    Canvas.TextOut(Rect.Left+2, Rect.Top, Items[Index]);
  end;
end;


procedure TVclStylesOwnerDrawFix.ListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
Var
 LListBox : TListBox;
 LStyles  : TCustomStyleServices;
 LDetails : TThemedElementDetails;
begin
  LListBox :=TListBox(Control);
  LStyles  :=StyleServices;

  if odSelected in State then
    LListBox.Brush.Color := LStyles.GetSystemColor(clHighlight);

  LDetails := StyleServices.GetElementDetails(tlListItemNormal);

  LListBox.Canvas.FillRect(Rect);
  Rect.Left:=Rect.Left+2;
  LStyles.DrawText(LListBox.Canvas.Handle, LDetails, LListBox.Items[Index], Rect, [tfLeft, tfSingleLine, tfVerticalCenter]);

  if odFocused In State then
  begin
    LListBox.Canvas.Brush.Color := LStyles.GetSystemColor(clHighlight);
    LListBox.Canvas.DrawFocusRect(Rect);
  end;
end;


procedure TVclStylesOwnerDrawFix.ListViewDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
const
  Spacing =4;
var
  Dx        : Integer;
  r         : TRect;
  rc        : TRect;
  ColIdx    : Integer;
  s         : string;
  LDetails  : TThemedElementDetails;
  LStyles   : TCustomStyleServices;
  BoxSize   : TSize;
  LColor    : TColor;
  ImageSize : Integer;
begin
  ImageSize:=0;
  LStyles:=StyleServices;

  if not LStyles.GetElementColor(LStyles.GetElementDetails(ttItemNormal), ecTextColor, LColor) or  (LColor = clNone) then
  LColor := LStyles.GetSystemColor(clWindowText);

  //LColor:=clBlack;

  Sender.Canvas.Brush.Color := LStyles.GetStyleColor(scListView);
  Sender.Canvas.Font.Color  := LColor;
  Sender.Canvas.FillRect(Rect);

  r := Rect;
  inc(r.Left, Spacing);
  for ColIdx := 0 to TListView(Sender).Columns.Count - 1 do
  begin
    Dx:=0;
    r.Right := r.Left + Sender.Column[ColIdx].Width;

    if (ColIdx > 0) and (Item.SubItems.Count>=ColIdx) then
      s := Item.SubItems[ColIdx - 1]
    else
    begin
      BoxSize.cx := GetSystemMetrics(SM_CXMENUCHECK);
      BoxSize.cy := GetSystemMetrics(SM_CYMENUCHECK);
      s := Item.Caption;
      if TListView(Sender).Checkboxes then
      begin
       Inc(Dx,BoxSize.cx+3);
       r.Left:=r.Left+BoxSize.cx+3;
      end;
    end;

    if ColIdx = 0 then
    begin
      if not IsWindowVisible(ListView_GetEditControl(Sender.Handle)) and ([odSelected, odHotLight] * State <> []) then
      begin
        if ([odSelected, odHotLight] * State <> []) then
        begin
          rc:=Rect;
          if TListView(Sender).Checkboxes then
           rc.Left:=rc.Left+BoxSize.cx+Spacing;

          if not TListView(Sender).RowSelect then
           rc.Right:=Sender.Column[0].Width;

          Sender.Canvas.Brush.Color := LStyles.GetSystemColor(clHighlight);
          Sender.Canvas.FillRect(rc);
        end;
      end;
    end;

    if TListView(Sender).RowSelect then
      Sender.Canvas.Brush.Color := LStyles.GetSystemColor(clHighlight);

    if (ColIdx=0) and (TCustomListViewClass(Sender).SmallImages<>nil) and (TCustomListViewClass(Sender).SmallImages.Handle<>0) and (Item.ImageIndex>=0) then
    begin
      ImageList_Draw(TCustomListViewClass(Sender).SmallImages.Handle, Item.ImageIndex, Sender.Canvas.Handle, R.Left - 2, R.Top, ILD_NORMAL);
      ImageSize:=TCustomListViewClass(Sender).SmallImages.Width;
      Inc(Dx,ImageSize);
      r.Left:=r.Left+ImageSize;
    end;

    if ([odSelected, odHotLight] * State <> []) then
      LDetails := StyleServices.GetElementDetails(tlListItemSelected)
    else
      LDetails := StyleServices.GetElementDetails(tlListItemNormal);

    Sender.Canvas.Brush.Style := bsClear;
    LStyles.DrawText(Sender.Canvas.Handle, LDetails, s, r, [tfLeft, tfSingleLine, tfVerticalCenter, tfEndEllipsis]);

    if (ColIdx=0) and TListView(Sender).Checkboxes then
    begin
      rc := Rect;
      rc.Top    := Rect.Top + (Rect.Bottom - Rect.Top - BoxSize.cy) div 2;
      rc.Bottom := rc.Top + BoxSize.cy;
      rc.Left   := rc.Left + Spacing;
      rc.Right  := rc.Left + BoxSize.cx;

      if Item.Checked then
       LDetails := StyleServices.GetElementDetails(tbCheckBoxCheckedNormal)
      else
       LDetails := StyleServices.GetElementDetails(tbCheckBoxUncheckedNormal);

      LStyles.DrawElement(Sender.Canvas.Handle, LDetails, Rc);
    end;

    if ColIdx=0 then
     r.Left:=r.Left - Dx;
   { else         }
     inc(r.Left, Sender.Column[ColIdx].Width);
  end;

end;


procedure TVclStylesOwnerDrawFix.ListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  Spacing =4;
var
  LDetails  : TThemedElementDetails;
  Size      : TSize;
begin
 if TListView(Sender).OwnerDraw and (TListView(Sender).Checkboxes) then
  begin
   LDetails := StyleServices.GetElementDetails(tbCheckBoxCheckedNormal);
   Size.cx:=0;
   Size.cy:=0;

   if StyleServices.GetElementSize(TListView(Sender).Canvas.Handle, LDetails, esMinimum, Size) and (X>Spacing) and (X<=Size.Width) then
    TListView(Sender).Selected.Checked:=not TListView(Sender).Selected.Checked;

   //OutputDebugString(PChar(Format('X %d Size.Width %d',[X, Size.Width])));
  end;
end;


procedure DrawExpander(TreeView :TTreeView;ACanvas: TCanvas; ATextRect: TRect; AExpanded: Boolean; AHot: Boolean);
const
  TreeExpanderSpacing = 6;
var
  ExpanderRect: TRect;
  ThemeData: HTHEME;
  ElementPart: Integer;
  ElementState: Integer;
  ExpanderSize: TSize;
begin
  if ThemeServices.ThemesEnabled then
  begin
    if AHot then
      ElementPart := TVP_HOTGLYPH
    else
      ElementPart := TVP_GLYPH;

    if AExpanded then
      ElementState := GLPS_OPENED
    else
      ElementState := GLPS_CLOSED;

    ThemeData := OpenThemeData(TreeView.Handle, VSCLASS_TREEVIEW);
    GetThemePartSize(ThemeData, ACanvas.Handle, ElementPart, ElementState, nil,
      TS_TRUE, ExpanderSize);
    ExpanderRect.Left := ATextRect.Left - TreeExpanderSpacing - ExpanderSize.cx;
    ExpanderRect.Right := ExpanderRect.Left + ExpanderSize.cx;
    ExpanderRect.Top := ATextRect.Top + (ATextRect.Bottom - ATextRect.Top - ExpanderSize.cy) div 2;
    ExpanderRect.Bottom := ExpanderRect.Top + ExpanderSize.cy;
    DrawThemeBackground(ThemeData, ACanvas.Handle, ElementPart, ElementState, ExpanderRect, nil);
    CloseThemeData(ThemeData);
  end
  else
  begin

    // Drawing expander without themes...

  end;
end;

//procedure TVclStylesOwnerDrawFix.TreeViewAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
//  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
//var
//  LStyles   : TCustomStyleServices;
//  LDetails  : TThemedElementDetails;
//  NodeRect: TRect;
//  NodeTextRect: TRect;
//  Text: string;
//  ThemeData: HTHEME;
//  TreeItemState: Integer;
//begin
//  if Stage = cdPrePaint then
//  begin
//    LStyles:=StyleServices;
//       LDetails := StyleServices.GetElementDetails(tbCheckBoxCheckedNormal)
//
//                 ggg
//    NodeRect := Node.DisplayRect(False);
//    NodeTextRect := Node.DisplayRect(True);
//
//    // Drawing background
//    if (cdsSelected in State) and Sender.Focused then
//      TreeItemState := TREIS_SELECTED
//    else
//      if (cdsSelected in State) and (cdsHot in State) then
//        TreeItemState := TREIS_HOTSELECTED
//      else
//        if cdsSelected in State then
//          TreeItemState := TREIS_SELECTEDNOTFOCUS
//        else
//          if cdsHot in State then
//            TreeItemState := TREIS_HOT
//          else
//            TreeItemState := TREEITEMStateFiller0;
//
//    if TreeItemState <> TREEITEMStateFiller0 then
//    begin
//      ThemeData := OpenThemeData(Sender.Handle, VSCLASS_TREEVIEW);
//      DrawThemeBackground(ThemeData, Sender.Canvas.Handle, TVP_TREEITEM, TreeItemState,
//        NodeRect, nil);
//      CloseThemeData(ThemeData);
//    end;
//
//    // Drawing expander
//     {
//    if Node.HasChildren then
//      DrawExpander(TTreeView(Sender), Sender.Canvas, NodeTextRect, Node.Expanded, cdsHot in State);
//                           }
//    // Drawing main text
//    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
//    SetTextColor(Sender.Canvas.Handle, clBlue);
//
//    Text := Node.Text;
//    Sender.Canvas.TextRect(NodeTextRect, Text,
//      [tfVerticalCenter, tfSingleLine, tfEndEllipsis, tfLeft]);
//
//    // Some extended drawing...
//
//  end;
//
//  PaintImages := False;
//  DefaultDraw := False;
//end;

initialization
 VclStylesOwnerDrawFix:=TVclStylesOwnerDrawFix.Create;
finalization
 VclStylesOwnerDrawFix.Free;
end.
