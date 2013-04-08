let rec factor f x =
	if f = x then [x]
	else if sqrt (float_of_int f) < (float_of_int x) then [f]
	else if (f mod x = 0) then x :: factor (f/x) x
	else factor f (x+1);;

let rec next_prime n =
	if (List.length(factor (n+1) 2))=1 then print_endline (string_of_int (n+1))
	else next_prime (n+1);;
	
if (int_of_string Sys.argv.(1)) < 2 then print_endline (string_of_int 2)
else next_prime (int_of_string Sys.argv.(1));;
	
