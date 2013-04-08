(* PRACTICA 8 *)

(* del_fst : 'a-> 'a list -> 'a list *)
let rec del_fst x = function
	[] -> []
	| h :: l -> if h = x then l else [h] @ del_fst x l;; 

	
(* del_all : 'a -> 'a list -> 'a list *)
let rec del_all x = function
	[] -> []
	| h :: l -> if h = x then del_all x l else [h] @ del_all x l;;

(* dif_1 : 'a list -> 'a list -> 'a list *)
let rec dif_1 l1 = function
	[] -> l1
	| h :: l2 -> dif_1 (del_fst h l1) l2;;	
	
(* dif_2 : 'a list -> 'a list -> 'a list *)
let rec dif_2 l1 = function
	[] -> l1
	| h :: l2 -> dif_2 (del_all h l1) l2;;	
	
(* s_contents : 'a list -> 'a list -> bool *)
let rec s_contents l1 = function
	[] -> true
	| h :: [] -> del_all h l1 = []
	| h :: l2 -> s_contents (del_all h l1) l2;; 
	
(* m_contents : 'a list -> 'a list -> bool *)
let rec m_contents l1 = function
	[] -> true
	| h :: [] -> del_fst h l1 = []
	| h :: l2 -> m_contents (del_fst h l1) l2;;
	
(* perm : 'a list -> 'a list -> bool *)
let rec perm l1 l2 = (m_contents l1 l2) && (m_contents l2 l1);; 
	

