open OUnit

let setup _ = Env.add_local (Env.add_local (Env.add_local Env.empty "x" (Env.Int(4))) "y" (Env.Int(10))) "z" (Env.Int(3))

let teardown _ = ()

(* Pruebas de unidad expresiones aritméticas *)

let test_aexp_int = fun _ -> assert_equal 2 (Eval.aexp Env.empty (Lector.aexp "2"))
let test_aexp_var env = assert_equal 4 (Eval.aexp env (Lector.aexp "x"));
                        assert_raises (Tipos.NO_LIGADA "a") (fun _ -> Eval.aexp env (Lector.aexp "a"))
let test_aexp_sum env = assert_equal 9 (Eval.aexp env (Lector.aexp "x+5"))
let test_aexp_res env = assert_equal (-1) (Eval.aexp env (Lector.aexp "x-5"))
let test_aexp_mul env = assert_equal 20 (Eval.aexp env (Lector.aexp "x*5"))
let test_aexp_array env = assert_equal 9 (Eval.aexp (Env.add_local env "a" (Env.ArrayInt[(0,6);(1,3);(2,9);(3,1)])) (Lector.aexp "a[2]"))

(* Pruebas de unidad expresiones booleanas *)

let test_bexp_true = fun _ -> assert_bool "bexp_true" (Eval.bexp Env.empty (Lector.bexp "true"))
let test_bexp_false = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "false"))
let test_bexp_equal_1 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "3=3"))
let test_bexp_equal_2 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "2=3"))
let test_bexp_Lt_1 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "2<3"))
let test_bexp_Lt_2 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "3<3"))
let test_bexp_LtEq_1 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "2<=3"))
let test_bexp_LtEq_2 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "3<=3"))
let test_bexp_LtEq_3 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "4<=3"))
let test_bexp_Gt_1 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "4>3"))
let test_bexp_Gt_2 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "3>3"))
let test_bexp_GtEq_1 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "4>=3"))
let test_bexp_GtEq_2 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "3>=3"))
let test_bexp_GtEq_3 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "2>=3"))
let test_bexp_not_1 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "not false"))
let test_bexp_not_2 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "not true"))
let test_bexp_and_1 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "false and false"))
let test_bexp_and_2 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "false and true"))
let test_bexp_and_3 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "true and false"))
let test_bexp_and_4 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "true and true"))
let test_bexp_or_1 = fun _ -> assert_equal false (Eval.bexp Env.empty (Lector.bexp "false or false"))
let test_bexp_or_2 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "false or true"))
let test_bexp_or_3 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "true or false"))
let test_bexp_or_4 = fun _ -> assert_equal true (Eval.bexp Env.empty (Lector.bexp "true or true"))
let test_bexp_array env = assert_equal false (Eval.bexp (Env.add_local env "b" (Env.ArrayBool[(0,true);(1,true);(2,false);(3,true)])) (Lector.bexp "b[2]"))

(* Pruebas de unidad expresiones cadenas de caracteres *)

let test_sexp_string = fun _ -> assert_equal "hola" (Eval.sexp Env.empty (Lector.sexp "\"hola\""))
let test_sexp_concat_1 = fun _ -> assert_equal "holaholita" (Eval.sexp Env.empty (Lector.sexp "\"hola\" ^ \"holita\""))
let test_sexp_concat_2 = fun _ -> assert_equal "holitaholita" (Eval.sexp (Env.add_local Env.empty "a" (Env.String("holita"))) (Lector.sexp "a ^ a"))
let test_sexp_substring_1 = fun _ -> assert_equal "holi" (Eval.sexp (Env.add_local Env.empty "a" (Env.String("holita"))) (Lector.sexp "substring(a, 0, 4)"))
let test_sexp_substring_2 = fun _ -> assert_equal "ho" (Eval.sexp (Env.add_local Env.empty "a" (Env.String("holita"))) (Lector.sexp "substring(a, 0, 2)"))
let test_sexp_array env = assert_equal "b" (Eval.sexp (Env.add_local env "c" (Env.ArrayString[(0,"a");(1,"b");(2,"c");(3,"d")])) (Lector.sexp "c[1]"))

(* Pruebas de unidad comandos *)

let test_comm_skip = fun _ -> assert_equal Env.empty (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/skip.imp"))
let test_comm_mkvar = fun _ -> assert_equal (Env.add_local Env.empty "x" (Env.Int(4))) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/mkvar.imp"))
let test_comm_mkarray_1 = fun _ -> assert_equal (Env.add_local Env.empty "a" (Env.ArrayInt[(0,4);(1,4);(2,5);(3,4)])) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/mkarray_1.imp"))
let test_comm_mkarray_2 = fun _ -> assert_equal (Env.add_local Env.empty "a" (Env.ArrayBool[(0,true);(1,false);(2,true);(3,true)])) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/mkarray_2.imp"))
let test_comm_assignarray_1 = fun _ -> assert_equal (Env.add_local Env.empty "a" (Env.ArrayInt[(0,9);(1,8);(2,7);(3,6)])) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/assignarray_1.imp"))
let test_comm_assignarray_2 = fun _ -> assert_equal (Env.add_local Env.empty "a" (Env.ArrayBool[(0,true);(1,false);(2,true);(3,true)])) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/assignarray_2.imp"))
let test_comm_assignarray_3 = fun _ -> assert_raises (Tipos.ERROR_DE_TIPOS "No es un ArrayInt") (fun _ -> Eval.comm Env.empty (Lector.fichero "casos_de_prueba/assignarray_3.imp"))
let test_comm_assign_1 env = assert_equal (Env.add_local env "x" (Env.Int(13))) (Eval.comm env (Lector.fichero "casos_de_prueba/assign_2.imp"))
let test_comm_assign_2 env = assert_equal (Env.add_local env "x" (Env.Int(13))) (Eval.comm env (Lector.fichero "casos_de_prueba/assign_2.imp"))
let test_comm_assign_3 = fun _ -> assert_raises (Tipos.ERROR_DE_TIPOS "No es un Int") (fun _ -> Eval.comm Env.empty (Lector.fichero "casos_de_prueba/assign_3.imp"))
let test_comm_seq env = assert_equal env (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/seq.imp"))
let test_comm_if_1 = fun _ -> assert_equal (Env.add_local Env.empty "x" (Env.Int(5))) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/if_1.imp"))
let test_comm_if_2 = fun _ -> assert_equal (Env.add_local Env.empty "x" (Env.Int(9))) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/if_2.imp"))
let test_comm_if_3 = fun _ -> assert_raises (Tipos.NO_LIGADA "x") (fun _ -> Eval.comm Env.empty (Lector.fichero "casos_de_prueba/if_3.imp"))
let test_comm_if_4 = fun _ -> assert_equal (Env.add_local (Env.add_local Env.empty "i" (Env.Int(0))) "x" (Env.Int(12))) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/if_4.imp"))
let test_comm_while_1 = fun _ -> assert_equal (Env.add_local (Env.add_local Env.empty "x" (Env.Int(0))) "p" (Env.Int(10))) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/while_1.imp"))
let test_comm_while_2 = fun _ -> assert_raises (Tipos.NO_LIGADA "x") (fun _ -> Eval.comm Env.empty (Lector.fichero "casos_de_prueba/while_2.imp"))
let test_comm_while_3 = fun _ -> assert_equal (Env.add_local (Env.add_local Env.empty "i" (Env.Int(0))) "a" (Env.ArrayInt[(0,1);(1,2);(2,3)])) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/while_3.imp"))
let test_comm_print_1 = fun _ -> assert_equal (Env.add_local Env.empty "x" (Env.Int(12))) (print_string "*** Comando print correcto si escribe el número 12 por pantalla : "; Eval.comm Env.empty (Lector.fichero "casos_de_prueba/print_1.imp"))
let test_comm_print_2 = fun _ -> assert_equal (Env.add_local Env.empty "a" (Env.ArrayInt[(0,10);(1,25)])) (print_string "*** Comando print correcto si escribe el número 25 por pantalla (resultado de imprimir a[1]) : "; Eval.comm Env.empty (Lector.fichero "casos_de_prueba/print_2.imp"))

let suite_imp =
    "Pruebas_unidad_imp" >::: [ "test_aexp_int" >:: test_aexp_int;
				"test_aexp_var" >:: (bracket setup test_aexp_var teardown);
				"test_aexp_sum" >:: (bracket setup test_aexp_sum teardown);
				"test_aexp_res" >:: (bracket setup test_aexp_res teardown);
				"test_aexp_mul" >:: (bracket setup test_aexp_mul teardown);
				"test_aexp_array" >:: (bracket setup test_aexp_array teardown);

				"test_bexp_true" >:: test_bexp_true;
				"test_bexp_false" >:: test_bexp_false;
				"test_bexp_equal_1" >:: test_bexp_equal_1;
				"test_bexp_equal_2" >:: test_bexp_equal_2;
				"test_bexp_Lt_1" >:: test_bexp_Lt_1;
				"test_bexp_Lt_2" >:: test_bexp_Lt_2;
				"test_bexp_LtEq_1" >:: test_bexp_LtEq_1;
				"test_bexp_LtEq_2" >:: test_bexp_LtEq_2;
				"test_bexp_LtEq_3" >:: test_bexp_LtEq_3;
				"test_bexp_Gt_1" >:: test_bexp_Gt_1;
				"test_bexp_Gt_2" >:: test_bexp_Gt_2;
				"test_bexp_GtEq_1" >:: test_bexp_GtEq_1;
				"test_bexp_GtEq_2" >:: test_bexp_GtEq_2;
				"test_bexp_GtEq_3" >:: test_bexp_GtEq_3;
				"test_bexp_and_1" >:: test_bexp_and_1;
				"test_bexp_and_2" >:: test_bexp_and_2;
				"test_bexp_and_3" >:: test_bexp_and_3;
				"test_bexp_and_4" >:: test_bexp_and_4;
				"test_bexp_or_1" >:: test_bexp_or_1;
				"test_bexp_or_2" >:: test_bexp_or_2;
				"test_bexp_or_3" >:: test_bexp_or_3;
				"test_bexp_or_4" >:: test_bexp_or_4;
				"test_bexp_array" >:: (bracket setup test_bexp_array teardown);

				"test_sexp_string" >:: test_sexp_string;
				"test_sexp_concat_1" >:: test_sexp_concat_1;
				"test_sexp_concat_2" >:: test_sexp_concat_2;
				"test_sexp_substring_1" >:: test_sexp_substring_1;
				"test_sexp_substring_2" >:: test_sexp_substring_2;
				"test_sexp_array" >:: (bracket setup test_sexp_array teardown);

				"test_comm_skip" >:: test_comm_skip;
				"test_comm_mkvar" >:: (bracket setup test_comm_mkvar teardown);
				"test_comm_mkarray_1" >:: test_comm_mkarray_1;
				"test_comm_mkarray_2" >:: test_comm_mkarray_2;
				"test_comm_assignarray_1" >:: test_comm_assignarray_1;
				"test_comm_assignarray_2" >:: test_comm_assignarray_2;
				"test_comm_assignarray_3" >:: test_comm_assignarray_3;
				"test_comm_assign_1" >:: (bracket setup test_comm_assign_1 teardown);
				"test_comm_assign_2" >:: (bracket setup test_comm_assign_2 teardown);
				"test_comm_assign_3" >:: test_comm_assign_3;
				"test_comm_seq" >:: (bracket setup test_comm_seq teardown);
				"test_comm_if_1" >:: test_comm_if_1;
				"test_comm_if_2" >:: test_comm_if_2;
				"test_comm_if_3" >:: test_comm_if_3;
				"test_comm_if_4" >:: test_comm_if_4;
				"test_comm_while_1" >:: test_comm_while_1;
				"test_comm_while_2" >:: test_comm_while_2;
				"test_comm_while_3" >:: test_comm_while_3;
				"test_comm_print_1" >:: test_comm_print_1;
				"test_comm_print_2" >:: test_comm_print_2]

let _ = 
    run_test_tt_main suite_imp
