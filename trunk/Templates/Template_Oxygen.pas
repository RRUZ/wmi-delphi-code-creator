namespace GenericMethodTest;
 
interface
 
type
GenericMethodTest = static class
public
  class method Main;
private
  class method Swap<T>(var left, right : T);
  class method DoSwap<T>(left, right : T);
end;
 
implementation
 
class method GenericMethodTest.DoSwap<T>(left, right : T);
begin
  var a := left;
  var b := right;
  Console.WriteLine('Type: {0}', typeof(T));
  Console.WriteLine('-> a = {0}, b = {1}', a , b);
  Swap<T>(var a, var b);
  Console.WriteLine('-> a = {0}, b = {1}', a , b);
end;
 
class method GenericMethodTest.Main;
begin
  var a := 23;// type inference
  var b := 15;
  DoSwap<Integer>(a, b); // no downcasting to Object in this method.
 
  var aa := 'abc';// type inference
  var bb := 'def';
  DoSwap<String>(aa, bb); // no downcasting to Object in this method.
 
  DoSwap(1.1, 1.2); // type inference for generic parameters
  Console.ReadLine();
end;
 
class method GenericMethodTest.Swap<T>(var left, right : T);
begin
  var temp := left;
  left:= right;
  right := temp;
end;
 
end.