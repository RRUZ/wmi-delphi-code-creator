
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
  i: integer;
begin
  Result := Trim(AWord);

  for i := 0 to NumReservedWords - 1 do
    if CompareText(Result, DelphiReservedWords[i]) = 0 then
    begin
      //Result:=  EscapeChr+Result;
      //Result:=Format('{$IFDEF FPC}_%s{$ELSE}&%s{$ENDIF}',[Result,Result]);
      Result := Format('{$IFDEF OLD_DELPHI}_%s{$ELSE}&%s{$ENDIF}', [Result, Result]);
      break;
    end;
end;


end.
