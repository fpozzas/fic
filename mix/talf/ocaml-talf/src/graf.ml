
(*****************************************************************************
 *
 * graf.ml   Funciones para la visualizaci�n gr�fica e impresi�n de los
 *           aut�matas.
 *
 *****************************************************************************)

open Conj;;
open Auto;;
open List;;

(*****************************************************************************
 *
 * primer_estado : int -> simbolo Conjunto -> int
 *
 * Funci�n que dado un entero y un conjunto de estados devuelve un entero
 * igual o mayor que el entero dado, cuyo string correspondiente no genera
 * conflictos con el espacio de nombres del conjunto de estados, siendo
 * por tanto un nombre v�lido para el estado inicial, en el proceso que pasa
 * un aut�mata a sintaxis dot.
 *
 *****************************************************************************)

let primer_estado n (Conjunto estados) =
   let
      nombres = map (function Estado s -> s) estados
   in
      let rec aux m =
         if mem (string_of_int m) nombres then
            aux (m+1)
         else
            m
      in
         aux n
      ;;


(*****************************************************************************
 *
 * dot_of_af : af -> string
 *
 * Funci�n que dado un aut�mata finito devuelve su especificaci�n tipo
 * texto en sintaxis dot de graphviz.
 *
 *****************************************************************************)

let dot_of_af
   (Af (estados, _, Estado inicial, Conjunto arcos, Conjunto finales)) =
   let
      invisible = string_of_int (primer_estado 0 estados)
   in
      let rec aux1 = function
           [] -> ""
         | Estado s :: t -> "\"" ^ s ^ "\"; " ^ (aux1 t)
      and aux2 = function
           [] -> ""
         | Arco_af (Estado o, Estado d, Terminal "") :: t ->
              "   \"" ^ o ^ "\" -> \"" ^ d ^ "\" [label=\"epsilon\"];\n" ^ (aux2 t)
         | Arco_af (Estado o, Estado d, Terminal s) :: t ->
              "   \"" ^ o ^ "\" -> \"" ^ d ^ "\" [label=\"" ^ s ^ "\"];\n" ^ (aux2 t)
         | _ -> raise (Failure "dot_of_af: el arco contiene un no terminal")
      in
         "digraph grafo {\n" ^
         "   node [style=invis]; \"" ^ invisible ^ "\";\n" ^
         "   node [shape=doublecircle, style=solid]; " ^
         aux1 finales ^ "\n" ^
         "   node [shape=circle, style=solid];\n" ^
         "   rankdir = LR;\n" ^
         "   \"" ^ invisible ^ "\" -> \"" ^ inicial ^ "\";\n" ^
         aux2 arcos ^
         "}\n"
      ;;
   

(*****************************************************************************
 *
 * dibuja_af : af -> unit
 *
 * Funci�n que dado un aut�mata finito, llama al comando dot para generar un
 * dibujo PostScript de dicho aut�mata, y luego llama al comando gv para
 * poder visualizarlo y/o imprimirlo.
 *
 *****************************************************************************)

let dibuja_af a =
   let
      c = open_out ".grafo.dot"
   in
      output_string c (dot_of_af a); close_out c;
      ignore (Sys.command ("dot -Tps .grafo.dot -o .grafo.ps"));
      ignore (Sys.command ("evince .grafo.ps"));
      Sys.remove ".grafo.dot";
      Sys.remove ".grafo.ps"
      ;;


(*****************************************************************************
 *
 * dot_of_ap : ap -> string
 *
 * Funci�n que dado un aut�mata de pila devuelve su especificaci�n tipo
 * texto en sintaxis dot de graphviz.
 *
 *****************************************************************************)

let dot_of_ap
   (Ap (estados, _, _, Estado inicial, Conjunto arcos, _, Conjunto finales)) =
   let
      invisible = string_of_int (primer_estado 0 estados)
   in
      let rec aux1 = function
           [] -> ""
         | Estado s :: t -> "\"" ^ s ^ "\"; " ^ (aux1 t)
      and aux2 = 
         let rec aux3 = function
              [] -> "epsilon"
            | [Terminal ""] -> "epsilon"
            | [Terminal s] -> s
            | [No_terminal ""] -> "zeta"
            | [No_terminal s] -> s
            | Terminal s :: t -> s ^ " " ^ (aux3 t)
            | No_terminal "" :: t -> "zeta" ^ " " ^ (aux3 t)
            | No_terminal s :: t -> s ^ " " ^ (aux3 t)
         in
            function
              [] -> ""
            | Arco_ap (Estado o, Estado d, s1, s2, lista) :: t ->
                 "   \"" ^ o ^ "\" -> \"" ^ d ^ "\" [label=\"" ^ 
                 (aux3 [s1]) ^ ", " ^ (aux3 [s2]) ^ " / " ^ (aux3 lista) ^ "\"];\n" ^ (aux2 t)
      in
         "digraph grafo {\n" ^
         "   node [style=invis]; \"" ^ invisible ^ "\";\n" ^
         "   node [shape=doublecircle, style=solid]; " ^
         aux1 finales ^ "\n" ^
         "   node [shape=circle, style=solid];\n" ^
         "   rankdir = LR;\n" ^
         "   \"" ^ invisible ^ "\" -> \"" ^ inicial ^ "\";\n" ^
         aux2 arcos ^
         "}\n"
      ;;
   

(*****************************************************************************
 *
 * dibuja_ap : ap -> unit
 *
 * Funci�n que dado un aut�mata de pila, llama al comando dot para generar un
 * dibujo PostScript de dicho aut�mata, y luego llama al comando gv para
 * poder visualizarlo y/o imprimirlo.
 *
 *****************************************************************************)

let dibuja_ap a =
   let
      c = open_out ".grafo.dot"
   in
      output_string c (dot_of_ap a); close_out c;
      ignore (Sys.command ("dot -Tps .grafo.dot -o .grafo.ps"));
      ignore (Sys.command ("evince .grafo.ps"));
      Sys.remove ".grafo.dot";
      Sys.remove ".grafo.ps"
      ;;


(*****************************************************************************
 *
 * dot_of_mt : mt -> string
 *
 * Funci�n que dada una m�quina de Turing devuelve su especificaci�n tipo
 * texto en sintaxis dot de graphviz.
 *
 *****************************************************************************)

let dot_of_mt
   (Mt (estados, _, _, Estado inicial, Conjunto arcos, _, Conjunto finales)) =
   let
      invisible = string_of_int (primer_estado 0 estados)
   in
      let rec aux1 = function
           [] -> ""
         | Estado s :: t -> "\"" ^ s ^ "\"; " ^ (aux1 t)
      and aux2 = 
         let aux3 = function
              Terminal "" -> "epsilon"
            | Terminal s -> s
            | No_terminal "" -> "blanco"
            | No_terminal s -> s
         and aux4 = function
              Izquierda -> "izquierda"
            | Derecha -> "derecha"
         in
            function
              [] -> ""
            | Arco_mt (Estado o, Estado d, s1, s2, mov) :: t ->
                 "   \"" ^ o ^ "\" -> \"" ^ d ^ "\" [label=\"" ^ 
                 (aux3 s1) ^ " / " ^ (aux3 s2) ^ ", " ^ (aux4 mov) ^ "\"];\n" ^ (aux2 t)
      in
         "digraph grafo {\n" ^
         "   node [style=invis]; \"" ^ invisible ^ "\";\n" ^
         "   node [shape=doublecircle, style=solid]; " ^
         aux1 finales ^ "\n" ^
         "   node [shape=circle, style=solid];\n" ^
         "   rankdir = LR;\n" ^
         "   \"" ^ invisible ^ "\" -> \"" ^ inicial ^ "\";\n" ^
         aux2 arcos ^
         "}\n"
      ;;
   

(*****************************************************************************
 *
 * dibuja_mt : mt -> unit
 *
 * Funci�n que dada una m�quina de Turing, llama al comando dot para generar un
 * dibujo PostScript de dicha m�quina, y luego llama al comando gv para
 * poder visualizarla y/o imprimirla.
 *
 *****************************************************************************)

let dibuja_mt m =
   let
      c = open_out ".grafo.dot"
   in
      output_string c (dot_of_mt m); close_out c;
      ignore (Sys.command ("dot -Tps .grafo.dot -o .grafo.ps"));
      ignore (Sys.command ("evince .grafo.ps"));
      Sys.remove ".grafo.dot";
      Sys.remove ".grafo.ps"
      ;;

(*****************************************************************************)

