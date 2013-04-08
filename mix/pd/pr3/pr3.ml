(* PRACTICA 3 *)

(*********)
(* Ej. 1 *)
(*********)

(* abs x *)
if x < 0 then -x else x;;

(* not x *)
 if x = false then true else false;;
 
(* string_of_bool b *)
if b = false then "false" else "true";;

(* Char.lowercase c *)
if Char.code c > 96 then c else Char.chr ( Char.code c + 32 );;

(* x mod y *)
x - (x / y) * y;;

(* x && (y || z) *)
if x = false then false 
	else if y = true then true 
		else if z = true then true 
			else false;;
			
(*********)
(* Ej. 2 *)
(*********)

(* abs *)
let ab x = if x < 0 then -x else x;;

(* lowercase *)
let lowercase c = if Char.code c > 96 then c else Char.chr ( Char.code c + 32 );;

(* string_of_bool *)
let string_of_bool b = if b = false then "false" else "true";;

(*********)
(* Ej. 3 *)
(*********)

(* hd *)
let hd = function h::t -> h;;

(* tl *)
let tl = function h::t -> t;;

(* length *)
let length l = 
	let rec aux = function [] -> 0 
	| h::t -> 1 + aux t 
in aux l;;

(* reverse *)

let rec reverse = 
	function [] -> [] 
	| h :: t -> (reverse t) @ [h];;


(*********)
(* Ej. 4 *)
(*********)

(* lmax *)


let rec lmax = 
	function [x] -> x
   | h::t -> max h (lmax t);;
                      
                      
let rec lmax = 
	function [x] -> x
   | h::t -> let m = lmax t in if h > m then h else m;;      
   
(* lmin *)

let rec lmin = 
	function [x] -> x
   | h::t -> min h (lmin t);;   
   
(*********)
(* Ej. 5 *)
(*********)

let rango = function l -> (lmin(l),lmax(l));;	
        
(*********)
(* Ej. 6 *)
(*********)

let rec primeros n = 
	if n <= 0 then [] 
	else primeros (n-1) @ [n];;
	
let primeros n =
	if n > 0 then 
		let rec aux = 
			function 1 -> [1]
			| n -> aux(n-1) @ [n]
		in aux(n)
	else [];;
	
(*********)
(* Ej. 7 *)
(*********)

let rec from_to min max =
	if max < min then []
	else from_to min (max-1) @ [max];;
	
(*********)
(* Ej. 8 *)
(*********)

let rec ordenada =
	function [] |  _ :: [] -> true
	| h1::h2::t -> (h1 <= h2) && ordenada (h2::t);;

