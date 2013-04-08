let conjest_to_string conjest =
    let rec aux string = function
        | Conjunto [] -> string
        | Conjunto ((Estado h)::t) -> aux (string ^ " " ^ h) (Conjunto t)
    in aux "" conjest;;

(* traza_af : Auto.simbolo list -> Auto.af -> bool *)

let traza_af cadena (Af (_, _, inicial, _, finales) as a) =
		
   let rec aux = function

        (Conjunto [], _) ->
           false

      | (actuales, []) -> (print_endline ((conjest_to_string actuales) ^ ",");
           not (es_vacio (interseccion actuales finales)))

      | (actuales, simbolo :: t) -> (print_string ((conjest_to_string actuales) ^ ","); 
            print_endline (" " ^ (string_of_cadena (simbolo::t)));
            aux ((epsilon_cierre (avanza simbolo actuales a) a), t))

   in
      aux ((epsilon_cierre (Conjunto [inicial]) a), cadena);;

(* af_of_er : Auto.er -> Auto.af *)

let af_of_er er =
    let rec aux (Af (estados,alfabeto,inicial,funtr,fin) er contest = match er with
        | 
        | Concatenacion (e1,e2) -> aux (Af (agregar (Estado (string_of_int (contest+2))) (agregar (Estado (string_of_int contest+1))), alfabeto, inicial, agregar (Arco_af ((Estado (string_of_int (contest)))
    

