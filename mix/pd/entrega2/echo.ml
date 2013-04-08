let rec echo () =
	let cadena = input_line stdin in
	print_endline cadena;
	echo () ;;
	
echo ();;
