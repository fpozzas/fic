(* PRACTICA 1 *)

(*********)
(* Ej. 5 *)
(*********)

2 + 5 * 3;; (* - : int = 17 *)

2+5*3;; (* - : int = 17 *)
(* Los espacios en blanco no afectan a la expresion *)

2 - 2.0;; (* - : int = 0 *)
(* En realidad da 
This expression has type float but is here used with type int
Da error porque no podemos operar enteros con flotantes *)

3+2;; (* - : int = 5 *)

3.0-2.0;; (* - : float = 0.0 *)
(* En realidad da
This expression has type float but is here used with type int
No podemos utilizar el signo + para sumar flotantes *)

3.0+.2.0;; (* - : float = 5 *)
(* El operador para sumar flotantes es el +. *)

5 / 3;; (* - : int = 1 *)
(* Solo da como resultado la parte entera de la division *)

5 mod 3;; (* - : int = 2 *)

3.0 *. 2.0 ** 3.0;; (* - : float = 24 *)

3.0 = float_of_int 3;;
(* Da
- : bool = true
Comprueba si la igualdad es cierta, y en este caso lo es, ya que compara las partes decimales de ambos valores, 0 en este caso *)

int_of_float  2.1 + int_of_float (-2.9);; (* - : int = 0 *)

truncate 2.1 + truncate (-2.9);; (* - : int = 0 *)
(* int_of_float y truncate son equivalentes *)

floor 2.1 +. floor (-2.9);;
(* Da
- : float = -1
floor redondea al entero menor o igual más cercano al flotante *)

ceil 2.1 +. ceil (-2.9);;
(* Da
- : float = 1.
ceil redondea al entero mayor o igual más cercano al flotante *)

'B';; (* - : char = 'B' *)

int_of_char 'A';; 
(* Da
- : int = 65
int_of_char saca el entero asociado a ese caracter en el código ASCII *)

char_of_int 66;;
(* Da
- : char = 'B'
char_of_int devuelve el caracter asociado a ese entero en el código ASCII *)

# Char.code 'B';; (* - : int = 66 *)

# Char.chr 67;; (* - : char = 'C' *)

Char.chr (Char.code 'a' - Char.code 'A' + Char.code 'Ñ');;
(* Da
- : char = '\241'
No da el caracter porque no existe el caracter 241 en el código ASCII *)

Char.uppercase 'ñ';; (* - : char = 'Ñ' *)
(* En realidad da
- : char = '\209'
Con 'ñ' no funciona correctamente porque esta considerado un caracter especial en el codigo ASCII y no como un caracter normal del alfabeto *)

Char.lowercase 'O';; (* - : char = 'o' *)

"this is a string";; (* - : string = "this is a string" *)

String.length "longitud";; (* - : int = 8 *)

"1999" + 1;; (* Debe dar un error, son tipos distintos *)
(* This expression has type string but is here used with type int *)

"1999" + "1";; (* Debe dar error, son del mismo tipo pero no podemos usar el operador + *)
(* This expression has type string but is here used with type int *)

"1999" ^ "1";;
(* Da
- : string = "19991"
El operador que se utiliza para "sumar" cadenas es ^ . Las cadenas siempre deben ir entre comillas *)

int_of_string "1999" + 1;; (* - : int = 2000 *)

string_of_int 010;; (* - : string = "010" *)
(* En realidad da
- : string = "10"
El cero a la izquierda es ignorado *)

true;;
(* Da
- : bool = true *)

not true;; (* - : bool = false *)

true && false;; (* - : bool = false *)

true || false;; (* - : bool = true *)

true or false;; (* - : bool = true *)
(* || y 'or' son equivalentes *)

1 < 2;; (* - : bool = true *)

(1 < 2) = false;; (* - : bool = false *)

"1" < "2";; (* - : bool = true *)

2< 12;; (* - : bool = true *)

"2" < "12";; (* - : bool = false *)

"uno" < "dos";; (* - : bool = false *)
(* Las cadenas comparan respecto al valor numerico de sus caracteres en el código ASCII, no comparan su longitud*)

min 10 (-10);; (* - : int = -10 *)

max 'z' 'a';; (* - : char = 'z' *)

[1];;
(* Da
- : int list = [1]
Crea una lista de enteros con un elemento *)

[3;2;1];; (* - : int list = [3; 2; 1] *)

[1;"dos"];; (* Debe dar error, no se puede tene una lista de varios tipos a la vez *)
(* This expression has type string but is here used with type int *)

[1;2.0];; (* This expression has type float but is here used with type int *)

2 :: [3;4];;
(* Da
- : int list = [2; 3; 4]
Con :: podemos añadir un elemento a una lista *)

List.length [3;3;3;3];; (* - : int = 4 *)

List.nth [5;4;3;2;1] 2;; (* - : int = 4 *)
(* En realidad da
- : int = 3
Devuelve el numero que ocupa la posicion de la lista que le pasamos, siendo el primer elemento de la lista la posicion 0 *)

[1;1+1;1+1+1];; (* - : int list = [1; 2; 3] *)

[1; 2] @ [3; 4];;
(* Da
- : int list = [1; 2; 3; 4] *)

List.hd [1; 2; 3];;
(* Da
- : int = 1
Devuelve el primer elemento de una lista *)

List.tl [1; 2; 3];;
(* Da
- : int list = [2; 3]
Devuelve la lista sin el primer elemento *)

List.hd [0];; (* - : int = 0 *)

List.tl [0];; (* - : int list = [] *)

['a'; 'e'; 'i'; 'o'; 'u'];; (* - : char list = ['a'; 'e'; 'i'; 'o'; 'u'] *)

List.rev ['a'; 'b'; 'c'];; 
(* Da
- : char list = ['c'; 'b'; 'a'] 
Devuelve la lista con sus elementos invertidos de posición *)

[];;
(* Da
- : 'a list = []
Devuelve una lista vacia de tipo indefinido *)

"hola" :: [];; (* - : string list = ["hola"] *)

2,5;; (* - : int * int = (2, 5) *)

"hola", "adios";; (* - : string * string = ("hola", "adios") *)

0, 0.0;; (* - : int * float = (0, 0.) *)

fst ('a',0);;
(* Da
- : char = 'a'
Devuelve el primer elemento *)

snd (false, true);;
(* Da
- : bool = true
Devuelve el segundo elemento *)

(1,2,3);; (* - : int * int * int = (1, 2, 3) *)

(1,2),3;; (* - : (int * int) * int = ((1, 2), 3) *)

fst ((1,2),3);; (* - : int * int = (1, 2) *)

[1,2,3];;
(* Da
- : (int * int * int) list = [(1, 2, 3)]
Devuelve una lista del tipo int*int*int de un solo elemento *)

if 3 = 4 then 0 else 4;; (* - : int = 4 *)

if 3 = 4 then "0" else "4";; (* - : string = "4" *)

if 3 = 4 then 0 else "4";; (* - : string = "4" *)
(* En realidad da
This expression has type string but is here used with type int
Las expresiones de then y de else deben ser del mismo tipo *)

function x -> 2 * x;;
(* Da
- : int -> int = <fun> *)

(function x -> 2 * x) (2 + 1);;
(* Da
- : int = 6
Crea la funcion 'x -> 2 * x' y sustituye x por 2 + 1 *)

int_of_float;; (* Deberia dar error porque no le pasamos parametros *)
(* En realidad da
- : float -> int = <fun>
Si no especificamos valores, vemos como esta definida en Ocaml la funcion int_of_float *)

float_of_int;; (* - : int -> float = <fun> *)

int_of_char;; (* - : char -> int = <fun> *)

char_of_int;; (* - : int -> char = <fun> *)

min;;
(* Da
- : 'a -> 'a -> 'a = <fun>
El tipo es indefinido *)

max;; (* - : 'a -> 'a -> 'a = <fun> *)

fst;; (* - : 'a * 'b -> 'a = <fun> *)

snd;; (* - : 'a * 'b -> 'b = <fun> *)


(*********)
(* Ej. 7 *)
(*********)

max_int;;
(* - : int = 1073741823 *)

min_int;;
(* - : int = -1073741824 *)
