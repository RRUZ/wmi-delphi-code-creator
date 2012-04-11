{**************************************************************************************************}
{                                                                                                  }
{ Unit uDelphiSyntax                                                                               }
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
{ The Original Code is uDelphiSyntax.pas.                                                          }
{                                                                                                  }
{ The Initial Developer of the Original Code is Rodrigo Ruz V.                                     }
{ Portions created by Rodrigo Ruz V. are Copyright (C) 2011 Rodrigo Ruz V.                         }
{ All Rights Reserved.                                                                             }
{                                                                                                  }
{**************************************************************************************************}
unit uDelphiSyntax;

interface

function EscapeDelphiReservedWord(const AWord: string): string;

implementation

uses
  SysUtils;

const
  EscapeChr = '&';
  NumReservedWords = 74;
  DelphiReservedWords: array [0..NumReservedWords - 1] of string = (
    'add', 'else', 'initialization', 'program', 'then', 'and', 'end', 'inline',
    'property', 'Object',
    'threadvar', 'array', 'except', 'interface', 'raise', 'to', 'as', 'exports', 'is', 'record',
    'try', 'asm', 'file', 'label', 'remove', 'type', 'begin', 'final', 'library', 'repeat', 'unit',
    'case', 'finalization', 'mod', 'resourcestring', 'unsafe', 'class', 'finally', 'nil', 'seled',
    'until', 'const', 'for', 'not', 'set', 'uses', 'constructor', 'function',
    'not', 'shl', 'var', 'destructor',
    'goto', 'of', 'shr', 'while', 'dispinterface', 'if', 'or', 'static', 'with',
    'div', 'implementation',
    'out', 'strict private', 'xor', 'do', 'in', 'packed', 'strict protected',
    'downto', 'inherited', 'procedure',
    'string');

function EscapeDelphiReservedWord(const AWord: string): string;
var
  LIndex: integer;
begin
  Result := Trim(AWord);

  for LIndex := 0 to NumReservedWords - 1 do
    if CompareText(Result, DelphiReservedWords[LIndex]) = 0 then
    begin
      //Result:=  EscapeChr+Result;
      //Result:=Format('{$IFDEF FPC}_%s{$ELSE}&%s{$ENDIF}',[Result,Result]);
      Result := Format('{$IFDEF OLD_DELPHI}_%s{$ELSE}&%s{$ENDIF}', [Result, Result]);
      break;
    end;
end;


end.
