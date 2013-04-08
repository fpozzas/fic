let rec factor f x =
	if f = x then print_endline (string_of_int x)
	else if (f mod x = 0) then (print_endline (string_of_int x); factor (f/x) x)
	else factor f (x+1);;
	
factor (int_of_string Sys.argv.(1)) 2;;

