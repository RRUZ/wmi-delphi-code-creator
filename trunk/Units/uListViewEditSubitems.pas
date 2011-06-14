unit  uListViewEditSubitems;

interface

uses
  Types,
  CommCtrl,
  ComCtrls,
  Windows;

type
  TListViewCoord = record
    Item:   integer;
    Column: integer;
  end;

  TLVGetColumnAt = function(Item: TListItem; const Pt: TPoint): integer;
  TLVGetColumnRect = function(Item: TListItem; ColumnIndex: integer;
    var Rect: TRect): boolean;
  TLVGetIndexesAt = function(ListView: TCustomListView; const Pt: TPoint;
    var Coord: TListViewCoord): boolean;

function ComCtl_GetColumnRect(Item: TListItem; ColumnIndex: integer;
  var Rect: TRect): boolean;
function ComCtl_GetIndexesAt(ListView: TCustomListView; const Pt: TPoint;
  var Coord: TListViewCoord): boolean;
function ComCtl_GetColumnAt(Item: TListItem; const Pt: TPoint): integer;


var
  // these will be assigned according to the version of COMCTL32.DLL being used
  GetColumnAt:   TLVGetColumnAt = nil;
  GetColumnRect: TLVGetColumnRect = nil;
  GetIndexesAt:  TLVGetIndexesAt = nil;



implementation

type
  // TCustomListViewAccess provides access to the protected members of TCustomListView
  TCustomListViewAccess = class(TCustomListView);


 //---------------------------------------------------------------------------
 //  GetComCtl32Version

 //  Purpose: Helper function to determine the version of CommCtrl32.dll that is loaded.
 //---------------------------------------------------------------------------
 {
var
  ComCtl32Version: DWORD = 0;

function GetComCtl32Version: DWORD;
type
  DLLVERSIONINFO = packed record
    cbSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformID: DWORD;
  end;

  DLLGETVERSIONPROC = function(var dvi: DLLVERSIONINFO): Integer; stdcall;
var
  hComCtrl32: HMODULE;
  lpDllGetVersion: DLLGETVERSIONPROC;
  dvi: DLLVERSIONINFO;
  FileName: array[0..MAX_PATH+1] of Char;
  dwHandle: DWORD;
  dwSize: DWORD;
  pData: Pointer;
  pVersion: Pointer;
  uiLen: UINT;
begin
  if ComCtl32Version = 0 then
  begin
    hComCtrl32 := GetModuleHandle('comctl32.dll');
    if hComCtrl32 <> 0 then
    begin
      @lpDllGetVersion := GetProcAddress(hComCtrl32, 'DllGetVersion');
      if @lpDllGetVersion <> nil then
      begin
        FillChar(dvi, SizeOf(dvi), 0);
        dvi.cbSize := SizeOf(dvi);
        if lpDllGetVersion(dvi) >= 0 then
          ComCtl32Version := MAKELONG(Word(dvi.dwMajorVersion), Word(dvi.dwMinorVersion));
      end;
      if ComCtl32Version = 0 then
      begin
        FillChar(FileName, SizeOf(FileName), 0);
        if GetModuleFileName(hComCtrl32, FileName, MAX_PATH) <> 0 then
        begin
          dwHandle := 0;
          dwSize := GetFileVersionInfoSize(FileName, dwHandle);
          if dwSize <> 0 then
          begin
            pData := LocalAlloc(LPTR, dwSize);
            if pData <> nil then
            begin
              if GetFileVersionInfo(FileName, dwHandle, dwSize, pData) then
              begin
                pVersion := nil;
                uiLen := 0;
                if VerQueryValue(pData, '\', pVersion, uiLen) then
                begin
                  with PVSFixedFileInfo(pVersion)^ do
                    ComCtl32Version := MAKELONG(Word(dwFileVersionMS), Word(dwFileVersionLS));
                end;
              end;
              LocalFree(pData);
            end;
          end;
        end;
      end;
    end;
  end;
  Result := ComCtl32Version;
end;
      }
 //---------------------------------------------------------------------------
 //  Manual_GetColumnAt

 //  Purpose: Returns the column index at the specified coordinates,
 //    relative to the specified item
 //---------------------------------------------------------------------------

function Manual_GetColumnAt(Item: TListItem; const Pt: TPoint): integer;
var
  LV: TCustomListViewAccess;
  R:  TRect;
  I:  integer;
begin
  LV := TCustomListViewAccess(Item.ListView);

  // determine the dimensions of the current column value, and
  // see if the coordinates are inside of the column value

  // get the dimensions of the entire item
  R := Item.DisplayRect(drBounds);

  // loop through all of the columns looking for the value that was clicked on
  for I := 0 to LV.Columns.Count - 1 do
  begin
    R.Right := (R.Left + LV.Column[I].Width);
    if PtInRect(R, Pt) then
    begin
      Result := I;
      Exit;
    end;
    R.Left := R.Right;
  end;

  Result := -1;
end;

 //---------------------------------------------------------------------------
 //  Manual_GetColumnRect

 //  Purpose: Calculate the dimensions of the specified column,
 //    relative to the specified item
 //---------------------------------------------------------------------------

function Manual_GetColumnRect(Item: TListItem; ColumnIndex: integer;
  var Rect: TRect): boolean;
var
  LV: TCustomListViewAccess;
  I:  integer;
begin
  Result := False;

  LV := TCustomListViewAccess(Item.ListView);

  // make sure the index is in the valid range
  if (ColumnIndex >= 0) and (ColumnIndex < LV.Columns.Count) then
  begin
    // get the dimensions of the entire item
    Rect := Item.DisplayRect(drBounds);

    // loop through the columns calculating the desired offsets
    for I := 0 to ColumnIndex - 1 do
      Rect.Left := (Rect.Left + LV.Column[i].Width);
    Rect.Right := (Rect.Left + LV.Column[ColumnIndex].Width);

    Result := True;
  end;
end;

 //---------------------------------------------------------------------------
 //  Manual_GetIndexesAt

 //  Purpose: Returns the Item and Column indexes at the specified coordinates
 //---------------------------------------------------------------------------

function Manual_GetIndexesAt(ListView: TCustomListView; const Pt: TPoint;
  var Coord: TListViewCoord): boolean;
var
  Item: TListItem;
begin
  Result := False;

  Item := ListView.GetItemAt(Pt.x, Pt.y);
  if Item <> nil then
  begin
    Coord.Item := Item.Index;
    Coord.Column := Manual_GetColumnAt(Item, Pt);
    Result := True;
  end;
end;

 //---------------------------------------------------------------------------
 //  ComCtl_GetColumnAt

//  Purpose: Returns the column index at the specified coordinates, relative to the specified item
//---------------------------------------------------------------------------

function ComCtl_GetColumnAt(Item: TListItem; const Pt: TPoint): integer;
var
  HitTest: LV_HITTESTINFO;
begin
  Result := -1;

  FillChar(HitTest, SizeOf(HitTest), 0);
  HitTest.pt := Pt;

  if ListView_SubItemHitTest(Item.ListView.Handle, @HitTest) > -1 then
  begin
    if HitTest.iItem = Item.Index then
      Result := HitTest.iSubItem;
  end;
end;

 //---------------------------------------------------------------------------
 //  ComCtl_GetColumnRect

//  Purpose: Calculate the dimensions of the specified column, relative to the specified item
//---------------------------------------------------------------------------

function ComCtl_GetColumnRect(Item: TListItem; ColumnIndex: integer;
  var Rect: TRect): boolean;
begin
  Result := ListView_GetSubItemRect(Item.ListView.Handle, Item.Index,
    ColumnIndex, LVIR_BOUNDS, @Rect);
end;

 //---------------------------------------------------------------------------
 //  ComCtl_GetIndexesAt

 //  Purpose: Returns the Item and Column indexes at the specified coordinates
 //---------------------------------------------------------------------------

function ComCtl_GetIndexesAt(ListView: TCustomListView; const Pt: TPoint;
  var Coord: TListViewCoord): boolean;
var
  HitTest: LV_HITTESTINFO;
begin
  Result := False;
  FillChar(HitTest, SizeOf(HitTest), 0);
  HitTest.pt := Pt;

  if ListView_SubItemHitTest(ListView.Handle, @HitTest) > -1 then
  begin
    Coord.Item := HitTest.iItem;
    Coord.Column := HitTest.iSubItem;
    Result := True;
  end;
end;


end.
