open OUnit

let setup _ = Env.add (Env.add (Env.add Env.empty "x" 4) "y" 10) "z" 3

let teardown _ = ()

(* Pruebas de unidad expresiones aritméticas *)

let test_aexp_int = fun _ -> assert_equal 2 (Eval.aexp Env.empty (Lector.aexp "2"))
let test_aexp_var env = assert_equal 4 (Eval.aexp env (Lector.aexp "x"));
                        assert_raises (Tipos.NO_LIGADA "a") (fun _ -> Eval.aexp env (Lector.aexp "a"))
let test_aexp_sum env = assert_equal 9 (Eval.aexp env (Lector.aexp "x+5"))
let test_aexp_res env = assert_equal (-1) (Eval.aexp env (Lector.aexp "x-5"))
let test_aexp_mul env = assert_equal 20 (Eval.aexp env (Lector.aexp "x*5"))

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


(* Pruebas de unidad comandos *)

let test_comm_skip = fun _ -> assert_equal Env.empty (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/skip.imp"))
let test_comm_mkvar = fun _ -> assert_equal (Env.add Env.empty "x" 4) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/mkvar.imp"))
let test_comm_assign_1 env = assert_equal (Env.add env "x" 7) (Eval.comm env (Lector.fichero "casos_de_prueba/assign_1.imp"))
let test_comm_assign_2 env = assert_equal (Env.add env "x" 13) (Eval.comm env (Lector.fichero "casos_de_prueba/assign_2.imp"))
let test_comm_seq env = assert_equal env (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/seq.imp"))
let test_comm_if_1 = fun _ -> assert_equal (Env.add Env.empty "x" 5) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/if_1.imp"))
let test_comm_if_2 = fun _ -> assert_equal (Env.add Env.empty "x" 9) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/if_2.imp"))
let test_comm_while = fun _ -> assert_equal (Env.add (Env.add Env.empty "x" 0) "p" 10) (Eval.comm Env.empty (Lector.fichero "casos_de_prueba/while.imp"))
let test_comm_print = fun _ -> assert_equal (Env.add Env.empty "x" 12) (print_string "*** Comando print correcto si escribe el número 12 por pantalla : "; Eval.comm Env.empty (Lector.fichero "casos_de_prueba/print.imp"))


let suite_imp =
    "Pruebas_unidad_imp" >::: [ "test_aexp_int" >:: test_aexp_int;
                                "test_aexp_var" >:: (bracket setup test_aexp_var teardown);
				"test_aexp_sum" >:: (bracket setup test_aexp_sum teardown);
				"test_aexp_res" >:: (bracket setup test_aexp_res teardown);
				"test_aexp_mul" >:: (bracket setup test_aexp_mul teardown);
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
                                "test_comm_skip" >:: test_comm_skip;
				"test_comm_mkvar" >:: (bracket setup test_comm_mkvar teardown);
				"test_comm_assign_1" >:: (bracket setup test_comm_assign_1 teardown);
				"test_comm_assign_2" >:: (bracket setup test_comm_assign_2 teardown);
				"test_comm_seq" >:: (bracket setup test_comm_seq teardown);
				"test_comm_if_1" >:: test_comm_if_1;
				"test_comm_if_2" >:: test_comm_if_2;
				"test_comm_while" >:: test_comm_while;
				"test_comm_print" >:: test_comm_print]

let _ = 
    run_test_tt_main suite_imp
