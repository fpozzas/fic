TALF Practica 0
---------------

Ejercicio 1)

* Implementación de mapdoble:

let rec mapdoble f1 f2 = function
	| [] -> []
	| h1::[] -> [f1 h1]
	| h1::h2::t -> f1 h1 :: f2 h2 :: mapdoble f1 f2 t;;

* Tipo de mapdoble:

val mapdoble : ('a -> 'b) -> ('a -> 'b) -> 'a list -> 'b list = <fun>

* Valor de:

mapdoble (function x -> x*2) (function x -> "x") [1;2;3;4;5];;

This expression has type string but is here used with type int
(No podemos tener en una misma lista elementos enteros y strings)

* Tipo de:

let y = function x -> 5 in mapdoble y;;

- : ('_a -> int) -> '_a list -> int list = <fun>


Ejercicio 2)

* Implementación de primero_que_cumple

let rec pqc f1 = function
	| [] -> raise(Failure "No existe un elemento en la lista que cumpla el predicado")
	| h::t -> if f1 h = true then h else pqc f1 t;;
	
* Tipo de pqc:

val pqc : ('a -> bool) -> 'a list -> 'a = <fun>

* Implementación de existe:

let existe f1 l = try (let _ = pqc f1 l in true) with _ -> false;; 

* Tipo de existe:

val existe : ('a -> bool) -> 'a list -> bool = <fun>

* Implementación de asociado:

let asociado x l = let (c,v) = pqc (function (a,b) -> a = x) l in v;; 



Ejercicio 3)

   type 'a arbol_binario = 
      Vacio
    | Nodo of 'a * 'a arbol_binario * 'a arbol_binario;;

let rec pre_orden = function
	| Vacio -> []
	| Nodo(e,i,d) -> e :: pre_orden i @ pre_orden d;;

let rec in_orden = function
	| Vacio -> []
	| Nodo(e,i,d) -> in_orden i @ e :: in_orden d;;

let rec post_orden = function
	| Vacio -> []
	| Nodo(e,i,d) -> post_orden i @ post_orden d @ [e];;

let anchura

Ejercicio 4)

   type 'a conjunto = Conjunto of 'a list;;
   let conjunto_vacio = Conjunto [];;

let es_vacio = function Conjunto l -> l = [];;  

let rec pertenece e = function
	| Conjunto [] -> false
	| Conjunto (h::t) -> if h = e then true else pertenece e (Conjunto t);;

let agregar e (Conjunto l) = if pertenece e (Conjunto l) then Conjunto l else Conjunto (e::l);; 

let conjunto_of_list l = Conjunto l;;

let suprimir e (Conjunto l) =
	let rec aux e = function
		| [] -> []
		| h::t  -> if h = e then t else h :: aux e t
	in Conjunto (aux e l);; 
	
let rec cardinal (Conjunto l) =
	let rec aux card = function
		| [] -> card
		| h::t -> aux (card+1) t
	in aux 0 l;;

let union c1 (Conjunto l2) = 
	let rec aux c1 = function
		| [] -> let (Conjunto l1) = c1 in l1 
		| h::t -> if pertenece h c1 then aux c1 t else h :: aux c1 t
	in Conjunto (aux c1 l2);;

let interseccion c1 (Conjunto l2) = 
	let rec aux c1 = function
		| [] -> []
		| h::t -> if pertenece h c1 then h :: aux c1 t else aux c1 t
	in Conjunto (aux c1 l2);;

let diferencia (Conjunto l2) c1 = 
	let rec aux c1 = function
		| [] -> []
		| h::t -> if pertenece h c1 then aux c1 t else h :: aux c1 t
	in Conjunto (aux c1 l2);;

let rec incluido (Conjunto l1) c2 = match l1 with
	| [] -> true
	| h::t -> if pertenece h c2 then incluido (Conjunto t) c2 else false;;

let rec igual c1 c2 = if diferencia c1 c2 = diferencia c2 c1 then true else false;;

let list_of_conjunto (Conjunto l) = l;;

let producto_cartesiano (Conjunto l1) (Conjunto l2) =
	let rec aux l1 l2 l2ini = match l1 with
		| [] -> []
		| h::t -> if l2=[] then aux t l2ini l2ini else (h,List.hd l2) :: aux l1 (List.tl l2) l2ini
	in Conjunto (aux l1 l2 l2);;






let arbol = Nodo(3,Nodo(2,Vacio,Vacio),Nodo(5,Nodo(4,Vacio,Vacio),Nodo(1,Vacio,Vacio)));;

let l2 = [1;2;7;4;5];;
let l3 = [(10,1);(11,2);(12,3);(13,4)];;
let c1 = Conjunto [1;2;7;4;5];;
let c2 = Conjunto [2;9;3;6;7];;