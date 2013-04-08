open Auto;;
open Ergo;;

let talfgrep er f =
	try
		let ic = open_in f in
		let af = af_of_er er in
			let rec aux af ic linea = 
				let simb = input_line ic in
					if (escaner_af (cadena_of_string simb) af) 
						then (print_endline((string_of_int linea) ^ ") " ^ simb );aux af ic (linea+1))
						else aux af ic (linea+1)
			in aux af ic 1
	with
		End_of_file -> ();;
		
talfgrep (er_of_string Sys.argv.(1)) Sys.argv.(2);;
		