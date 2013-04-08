(* PRACTICA 9 *)

(********)
(* Ej 1 *)				
(********)	

(* INSERT_SORT *)

let rec insert f x = function
	[] -> [x]
	| h::t -> if f x h then x::h::t
					else h::insert f x t;;
					
let rec insert_sort f = function
	[] -> []
	| h::t -> insert f h (insert_sort f t);;
	

					
(* MERGE_SORT *)

let rec split = function
	[] -> ([],[])
	| h::[] -> ([h],[]);
	| h1::h2::t -> let x,y = split t in
						(h1 :: x, h2 :: y);;
						
let rec merge f = function
	([],l) -> l
	| (l,[]) -> l
	| (h::t, r::s) -> if f h r then h :: merge f (t,r::s)
							else r :: merge f (h::t, s);;
							
let rec merge_sort f = function
	[] -> []
	| [h] -> [h]
	| l -> let x,y = split l in
				merge f (merge_sort f x, merge_sort f y);; 

(* QUICK_SORT *)

let rec split2 f x = function
	[] -> ([], [])
	| h::t -> let a,b = split2 f x t in
					if f h x then (h::a, b)
					else (a, h::b);;

let rec quick_sort f = function
	[] -> []
	| h::t -> let a,b = split2 f h t in
					quick_sort f a @ h :: quick_sort f b;;
					

					
(********)
(* Ej 2 *)				
(********)					
					
let rec newListaDesc n = 
	if n < 0 then []
	else n :: newListaDesc (n-1);;

let newListaAsc n = List.rev (newListaDesc n);;

let rec newListaAleat n = 	
	if n < 0 then []
	else Random.int max_int :: newListaAleat (n-1);;
	
(* TIEMPOS EN SEGUNDOS *)	

(* Listas Ascendentes *)

let lAsc = newListaAsc 10000;;
let t = Sys.time() in (insert_sort (<) lAsc ; Sys.time()-.t);; (* Tiempo : 0.0160010000000000152 *)
let t = Sys.time() in (merge_sort (<) lAsc ; Sys.time()-.t);; (* Tiempo : 0.220013 *)
let t = Sys.time() in (quick_sort (<) lAsc ; Sys.time()-.t);; (* Tiempo : 31.721983 *)

(* Listas Descendentes *)

let lDesc = newListaDesc 10000;;
let t = Sys.time() in (insert_sort (<) lDesc ; Sys.time()-.t);; (* Tiempo : 24.5895360000000096  *)
let t = Sys.time() in (merge_sort (<) lDesc ; Sys.time()-.t);; (* Tiempo : 0.20401299999998912 *)
let t = Sys.time() in (quick_sort (<) lDesc ; Sys.time()-.t);; (* Tiempo : 47.842991 *)

(* Listas Aleatorias *)

let lAleat = newListaAleat 10000;;
let t = Sys.time() in (insert_sort (<) lAleat ; Sys.time()-.t);; (* Tiempo : 11.2687039999999854 *)
let t = Sys.time() in (merge_sort (<) lAleat ; Sys.time()-.t);; (* Tiempo : 0.216014000000001261 *)
let t = Sys.time() in (quick_sort (<) lAleat ; Sys.time()-.t);; (* Tiempo : 0.172010000000000218 *)

