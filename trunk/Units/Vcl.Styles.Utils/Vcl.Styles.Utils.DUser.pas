unit Vcl.Styles.Utils.DUser;

interface

implementation

uses
  DDetours,
  System.SysUtils,
  VCL.Dialogs,
  Winapi.GDIPOBJ,
  Winapi.GDIPAPI,
  System.Classes,
  Winapi.Windows;

type
  TResourceStreamWritable = class(TResourceStream)
  public
    function Write(const Buffer; Count: Longint): Longint; override;
  end;


var
  LResourceStream : TResourceStreamWritable = nil;

procedure LoadDuser;
var
  HResInfo, HGlobal, duser  : THandle;
//  resourceSize : Integer;
//  resourceData : HGLOBAL;
//  LResourceStream:  TResourceStream;

  LStringStream  : TStringStream;
  s : string;
begin
  duser:= LoadLibrary('duser.dll');
  if duser<>0 then
  begin
     HResInfo := FindResource(duser, '#1010', 'UIFILE');
     if HResInfo<>0 then
     begin
       HGlobal := LoadResource(duser, HResInfo);
//       resourceSize := SizeofResource(duser, HResInfo);
//       resourceData := LoadResource(duser, HResInfo);
       LResourceStream:= TResourceStreamWritable.Create(duser, '#1010', 'UIFILE');
       LResourceStream.Position:=0;

       LStringStream:=TStringStream.Create;
       try
         LResourceStream.SaveToStream(LStringStream);
         s:= LStringStream.DataString;

      //   s:=StringOfChar('*', Length(s));

         s:= StringReplace(s,
         'themeable(dtb(TaskDialog, 8, 0), threedface)',
         'themeable(ARGB(255, 0, 255,  0),     window)', [rfReplaceAll]);

         s:= StringReplace(s,
         'themeable(dtb(AeroWizard, 3, 0), threedface)',
         'themeable(ARGB(255, 255, 0,  0),     window)', [rfReplaceAll]);


         s:= StringReplace(s,
         'gtc(CONTROLPANELSTYLE,10,1,3803)',
         'themeable(ARGB(255,5,0,0),window)', [rfReplaceAll]);

         s:= StringReplace(s,
         'gtc(TEXTSTYLE, 1, 0, 3803)',
         'ARGB(255, 255,    0,    0)', [rfReplaceAll]);

    //   ShowMessage(Format('LStringStream.Size %d LResourceStream.Size %d', [LStringStream.Size, LResourceStream.Size]));

         LStringStream.Position:=0;
         LStringStream.WriteString(s);

         LResourceStream.Position:=0;
         LStringStream.Position:=0;
         LResourceStream.CopyFrom(LStringStream, LStringStream.Size);
       finally
         LStringStream.Free;
       end;
     end;
  end;
end;

procedure LoadExplorerFrame;
var
  HResInfo, HGlobal, duser  : THandle;
  LStringStream  : TStringStream;
  s : string;
begin
  duser:= LoadLibrary('explorerframe.dll');
  if duser<>0 then
  begin
     HResInfo := FindResource(duser, '#40960', 'UIFILE');
     if HResInfo<>0 then
     begin
       HGlobal := LoadResource(duser, HResInfo);
//       resourceSize := SizeofResource(duser, HResInfo);
//       resourceData := LoadResource(duser, HResInfo);
       LResourceStream:= TResourceStreamWritable.Create(duser, '#40960', 'UIFILE');
       LResourceStream.Position:=0;

       LStringStream:=TStringStream.Create;
       try
         LResourceStream.SaveToStream(LStringStream);
         s:= LStringStream.DataString;

         s:= StringReplace(s,
         'LogicalImageSize="16"',
         'LogicalImageSize="64"', [rfReplaceAll]);


    //   ShowMessage(Format('LStringStream.Size %d LResourceStream.Size %d', [LStringStream.Size, LResourceStream.Size]));

         LStringStream.Position:=0;
         LStringStream.WriteString(s);

         LResourceStream.Position:=0;
         LStringStream.Position:=0;
         LResourceStream.CopyFrom(LStringStream, LStringStream.Size);
       finally
         LStringStream.Free;
       end;
     end;
  end;
end;

{ TResourceStreamWritable }

function TResourceStreamWritable.Write(const Buffer; Count: Integer): Longint;
var
  Pos: Longint;
  lpflOldProtect : DWORD;
begin
  if (Position >= 0) and (Count >= 0) then
  begin
    Pos := Position + Count;
    if Pos > 0 then
    begin
      if Pos > Size then
      begin
//        if Pos > Capacity then
//          SetCapacity(Pos);
        Size := Pos;
      end;

      VirtualProtect((PByte(Memory) + Position), Count, PAGE_EXECUTE_READWRITE, @lpflOldProtect);
      System.Move(Buffer, (PByte(Memory) + Position)^, Count);
      VirtualProtect((PByte(Memory) + Position), Count, lpflOldProtect, @lpflOldProtect);
      Position := Pos;
      Result := Count;
      Exit;
    end;
  end;
  Result := 0;
end;

//UtilGetColor(HGDIOBJ, __int64, int, int, __int64, __int64)
var
  TrampolineUtilGetColor           : function ( h: HGDIOBJ; i1 : Int64; i2, i3 : Integer; i4, i5 : Int64): DWORD; stdcall =  nil;
//; class Gdiplus::Brush * GetStdColorBrushF(unsigned int)
  TrampolineGetStdColorBrushF      : function ( i : DWORD): GpBrush; stdcall =  nil;


function Detour_UtilGetColor( h: HGDIOBJ; i1 : Int64; i2, i3 : Integer; i4, i5 : Int64): DWORD; stdcall;
begin
  Result:=TrampolineUtilGetColor(h, i1, i2, i3, i4, i5);
end;

function Detour_GetStdColorBrushF( i : DWORD): GpBrush; stdcall;
begin
 Result:=TrampolineGetStdColorBrushF(i);
end;

procedure LoadDuserHooks;
var
 duser :THandle;
 pOrgPointer : Pointer;
begin
  duser:= LoadLibrary('duser.dll');
  if duser<>0 then
  begin

   pOrgPointer     := GetProcAddress(GetModuleHandle('duser.dll'), 'UtilGetColor');
   if Assigned(pOrgPointer) then
     @TrampolineUtilGetColor    :=  InterceptCreate(pOrgPointer, @Detour_UtilGetColor);

   pOrgPointer     := GetProcAddress(GetModuleHandle('duser.dll'), 'GetStdColorBrushF');
   if Assigned(pOrgPointer) then
     @TrampolineGetStdColorBrushF    :=  InterceptCreate(pOrgPointer, @Detour_GetStdColorBrushF);

  end;
end;

initialization
 //LoadDuser;
 //LoadExplorerFrame;

  //LoadDuserHooks;


finalization
 if Assigned(TrampolineUtilGetColor) then
  InterceptRemove(@TrampolineUtilGetColor);

 if Assigned(TrampolineGetStdColorBrushF) then
  InterceptRemove(@TrampolineGetStdColorBrushF);

 if Assigned(LResourceStream) then
   LResourceStream.Free;

end.
