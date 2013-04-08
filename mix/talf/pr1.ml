(* traza_af : Auto.simbolo list -> Auto.af -> bool *)

let traza_af cadena (Af (_, _, inicial, _, finales) as a) =
	let rec impr_conj = function
		| Conjunto [] -> (print_string(",");())
		| Conjunto ((Estado h)::t) -> (print_string (h ^ " "); impr_conj (Conjunto t))
	in 
		
   let rec aux = function

        (Conjunto [], _) ->
           false

      | (actuales, []) -> (impr_conj actuales; print_endline(" ");
           not (es_vacio (interseccion actuales finales)))

      | (actuales, simbolo :: t) -> (impr_conj actuales; print_endline (" " ^ (string_of_cadena (simbolo::t)));
           aux ((epsilon_cierre (avanza simbolo actuales a) a), t))

   in
      aux ((epsilon_cierre (Conjunto [inicial]) a), cadena)
   ;;

