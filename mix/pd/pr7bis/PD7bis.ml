(******************)
(* PRACTICA 7 bis *)
(******************)
			
(******)
(*Ej 1*)
(******) 
		
let uncurry f (x,y) = f x y;;

(******)
(*Ej 2*)
(******)
 
let nth = function
		[] -> raise (Failure "nth : lista vacia")
		| h::t -> function n -> 
					if n < 0 then raise (Failure "nth : entero invalido")
					else 
						let rec aux (h::t) n =
						if n = 0 then h
							else if t=[] then raise (Failure "nth : entero invalido")
							else aux t (n-1)
						in aux (h::t) n;;

let rec append l1 l2 = match l1 with
	[] -> l2
	| h :: [] -> if (l2=[]) then [h] else h :: l2
	| h :: t -> h :: append t l2;;
		
let rec concat l =
	if l=[] then []
	else let h::t=l in 
			if t=[] then h
			else let h1::t1=h in 
				h1 :: concat [t1] :: concat t;;
			
let rec concat = function
	[] -> []
	| h :: [] -> h
	| h1 :: h2 :: t -> concat ((append h1 h2) :: t);;

let rec map f = function
		[] -> []
		| h::t -> f h :: map f t;;
		
(******)
(*Ej 3*)
(******)

let rec for_all p = function
		[] -> true
		| h::t -> (p h) && for_all p t;;
		
let rec exists p = function
		[] -> false
		| h::t -> (p h) || for_all p t;;
		
let rec mem e = function
		[] -> false
		| h::t -> if h=e then true else mem e t;;
		
let rec find p = function
		[] -> raise (Failure "Not_Found")
		| h::t -> if p h then h else find p t;;
		
let rec filter p = function
		[] -> []
		| h::t -> if p h then h :: filter p t else filter p t;;
		
let find_all p l = filter p l;;

let rec partition p = function
		[] -> ([],[])
		| h::t -> let x,y = partition p t in
					if p h then (h::x,y)
					else (x,h::y);;
