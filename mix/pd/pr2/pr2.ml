(* PRACTICA 2 *)

(*********)
(* Ej. 1 *)
(*********)

12, "octubre", 1492;; (* - : int * string * int = (12, "octubre", 1492) *)

fst (12, "octubre", 1492);; (* Error, fst solo funciona con pares de elementos)
(* This expression has type int * string * int but is here used with type
  'a * 'b *)
  
(12, "octubre"), 1492;; (* - : (int * string) * int = ((12, "octubre"), 1492) *)

fst ((12, "octubre"), 1492);; (* - : int * string = (12, "octubre") *)

snd ((12, "octubre"), 1492);; (* - : int = 1492 *)

snd (12, "octubre"), 1492;;(* - : int = 1492 *)
(* En realidad da:
- : string * int = ("octubre", 1492)
Si no ponemos los parentesis rodeando toda la expresion, snd nos da el segundo valor del primer par, más el resto *)

snd ((12, octubre), 1492);; (* Error, octubre no significa nada *)
(* Unbound value octubre *)

(1, 1+1, 1+1+1);; (* - : int * int * int = (1,2,3) *)

[1; 1+1; 1+1+1];; (* - : int list = [1;2;3] *)

[1, 1+1, 1+1+1];; (* - : (int * int * int) list = [(1,2,3)] *)

1, "dos", 3;; (* - : int * string * int = (1, "dos, 3) *)

[1; "dos"; 3];; (* Error, tipos distintos en una misma lista *)
(* This expression has type string but is here used with type int *)

0 :: [1; 2; 3];; (* - : int list = [0;1;2;3] *)

[];; (* - : 'a list = [] *)

3 :: [];; (* - : int list = [3] *)

2 :: (3 :: []);; (* - : int list = [2;3] *)

1 :: (2 :: (3 :: []));; (* - : int list = [1;2;3] *)

(1 :: 2 :: 3 ::[]) ;; (* - : int list = [1;2;3] *)

List.length ([1; 2] @ [3; 4]);; (* - : int = 4 *)

List.append ['a'; 'e'; 'i'] (List.tl ['o'; 'u']);; (* - : char list = ['a';'e';'i';'u'] *)

List.hd [];; (*  Error, la lista no tiene elementos *)
(* Exception: Failure "hd". *)

List.tl [];; (*  Error, la lista no tiene elementos *)
(* Exception: Failure "tl". *)

function x -> x;; (* - : 'a -> 'a = <fun> *)

(function x -> x) (1,2,3);; (* - : int * int * int = (1,2,3) *)

(function x -> x) int_of_char;; (* - : char -> int = <fun> *)

function x -> x, x;; (* - : 'a -> 'a * 'a = <fun> *)

(function x -> x, x) "hola";; (* - : string * string = ("hola, "hola) *)

(function x -> x, x) 0;; (* - : int * int = (0,0) *)

function x -> [x];; (* - : 'a -> 'a list = <fun> *)

(function x -> [x]) 0;; (* - : int list = [0] *)

function x -> List.hd x, List.tl x;; (* - : 'a list -> 'a * 'a list= <fun> *)

(function x -> List.hd x, List.tl x) [3;2;1];; (* - : int * int list = (3,[2;1]) *)

(function x -> List.hd x, List.tl x) [[]];; (* Error, se le pasa una lista vacia y List.hd y List.tl fallarán *)
(* En realidad da: 
- : 'a list * 'a list list = ([], [])
Las listas pueden ser elementos de otra lista *)

(function p -> fst p +. snd p);; (* - : float * float -> float = <fun> *)

(function p -> fst p +. snd p) (1.5, 2.5);; (* - : float = 4 *)

function p -> snd p, fst p;; (* - : 'a * 'b -> 'b * 'a = <fun> *)

(function p -> snd p, fst p) (('a', true), "true");; (* - : string * (char * bool) = ("true",('a', true)) *)

(function p ->snd p, fst p) ('a', true), "true";; (* - : (bool * char) * string = ((true, 'a'), "true") *)

function x -> [x; [x]];; (* Error, la lista definida tiene tipos distintos *)
(* This expression has type 'a list but is here used with type 'a *)

function x -> x > 0;; (* - : 'a -> bool = <fun> *)

(function x -> x > 0) 2;; (* - : bool = true *)

(function x -> x > 0) (-3);; (* - : bool = false *)

(*********)
(* Ej. 2 *)
(*********)

let pi = 3.14;; (* val pi : float = 3.14 *)

sin (pi /. 2.);; (* - : float = 1 *)
(* En realidad da:
- : float = 0.99999968293183461
Obviamente, pi es solo una aproximacion por lo que no puede dar el valor exacto *)

let pi = 4. *. atan 1. in sin (pi /. 2.);; (* - : float = 1. *)

sin (pi /. 2.);; (* - : float = 0.99999968293183461 *)

let x = 1;; (* val x : int = 1 *)

let y = 2;; (* val y : int = 2 *)

let x, y = y, x in x - y;; (* - : int = 1 *)

x - y;; (* - : int = -1 *)

let x = y and y = x in x - y;; (* - : int = 1 *)
