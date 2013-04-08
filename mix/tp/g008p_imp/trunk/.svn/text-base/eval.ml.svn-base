(**Módulo encargado de evaluar las funciones aritméticas y lógicas así como las operaciones del lenguaje IMP*)
open Tipos
open Env

(**Devuelve el valor de una variable
@param Un entorno para trabajar
@return Devuelve el valor de la variable
@raise Tipos.NO_LIGADA Si la variable no existe*)
let get env name =
    match (Env.get env name) with
          None    -> raise (Tipos.NO_LIGADA name)
        | Some(n) -> n

(**Comprueba que existe una variable
@param name Nombre de la variable
@return Devuelve true si existe y false si no*) 
let exists env name =
    match (Env.get env name) with
          None   -> false
        | Some _ -> true

(**Devuelve el valor de la lista en la posición que le pasamos *)
let rec dev_pos lista pos = match lista with
	(n,v)::t -> if n=pos then v else dev_pos t pos
	| _ -> raise (Tipos.FUERA_DE_RANGO "Posición inválida")



(**Define las expresiones de tipo entero
@param env Un entorno para trabajar
@return Resultado de la operación*)
let rec aexp env prog = function
      MkInt n       -> n
    | IntVar v      -> (match (get env v) with Int(x) -> x | _ -> raise (Tipos.ERROR_DE_TIPOS("No es un Int")))
    | IntArray(v,a) -> dev_pos (match (get env v) with ArrayInt(l) -> l | _ -> raise (Tipos.ERROR_DE_TIPOS("No es un ArrayInt"))) (aexp env prog a)
    | AFun(name, arg_values) -> failwith "Not implemented"
    | Sum(a1, a2)   -> aexp env prog a1 + aexp env prog a2
    | Res(a1, a2)   -> aexp env prog a1 - aexp env prog a2
    | Mul(a1, a2)   -> aexp env prog a1 * aexp env prog a2

(**Define las expresiones de tipo lógico
@param env Un entorno para trabajar 
@return Resultado de la operación*)
let rec bexp env prog = function
      MkBool b       -> b
    | BoolVar v      -> (match (get env v) with Bool(x) -> x | _ -> raise (Tipos.ERROR_DE_TIPOS("No es un Bool")))
    | BoolArray(v,a) -> dev_pos (match (get env v) with ArrayBool(l) -> l | _ -> raise (Tipos.ERROR_DE_TIPOS("No es un ArrayBool"))) (aexp env prog a)
    | BFun(name, arg_values) -> failwith "Not implemented"
    | Not(b)        -> not (bexp env prog b)
    | And(b1, b2)   -> (bexp env prog b1) & (bexp env prog b2)
    | Or(b1, b2)    -> (bexp env prog b1) or (bexp env prog b2)
    | Equal(a1, a2) -> (aexp env prog a1) = (aexp env prog a2)
    | Gt(a1, a2)    -> (aexp env prog a1) > (aexp env prog a2)
    | GtEq(a1, a2)  -> (aexp env prog a1) >= (aexp env prog a2)
    | Lt(a1, a2)    -> (aexp env prog a1) < (aexp env prog a2)
    | LtEq(a1, a2)  -> (aexp env prog a1) <= (aexp env prog a2)

(**Define las expresiones de tipo string
@param env Un entorno para trabajar 
@return Resultado de la operación*)
let rec sexp env prog = function
      MkString s       -> s
    | StringVar v      -> (match (get env v) with String(x) -> x | _ -> raise (Tipos.ERROR_DE_TIPOS("No es un String")))
    | StringArray(v,a) -> dev_pos (match (get env v) with ArrayString(l) -> l | _ -> raise (Tipos.ERROR_DE_TIPOS("No es un ArrayString"))) (aexp env prog a)
    | SFun(name, arg_values) -> failwith "Not implemented"
    | Concat(s1, s2)   -> (sexp env prog s1) ^ (sexp env prog s2)
    | Substring(s1,start,len) -> 
        String.sub (sexp env prog s1) (aexp env prog start) (aexp env prog len)

(**Define las operaciones del lenguaje
@param env Un entorno para trabajar
@return El entorno tras la operación*)
let rec comm env prog = function
      Skip                -> env
    | MkVar(name, value)  -> 
    	(match value with
    		VBool(b) -> Env.add_local env name (Bool (bexp env prog b))
    		| VInt(i) -> Env.add_local env name (Int (aexp env prog i))
    		| VString(s) -> Env.add_local env name (String (sexp env prog s)))

    | MkArray(name, size, value)  -> (if (aexp env prog size)<1 then raise (Tipos.FUERA_DE_RANGO "Número de posiciones incorrecto") 
		else let crear_lista valor tamano = 
			let rec cl_aux l v t =
				if t>0 then cl_aux ((t-1,v)::l) v (t-1) else l
			in cl_aux [] valor tamano
		in match value with
    		VBool(b) -> Env.add_local env name (ArrayBool (crear_lista (bexp env prog b) (aexp env prog size)))
    		| VInt(i) -> Env.add_local env name (ArrayInt (crear_lista (aexp env prog i) (aexp env prog size)))
    		| VString(s) -> Env.add_local env name (ArrayString (crear_lista (sexp env prog s) (aexp env prog size))))

	| Assign(name, value) -> 
		(if not (exists env name) then raise (Tipos.NO_LIGADA name)
			else match value with
				VBool(b) -> (match (get env name) with 
								| Bool(_) -> Env.add env name (Bool (bexp env prog b))
								| _ -> raise (Tipos.ERROR_DE_TIPOS "No es un Bool"))
				| VInt(i) -> (match (get env name) with
								| Int(_) -> Env.add env name (Int (aexp env prog i))
								| _ -> raise (Tipos.ERROR_DE_TIPOS "No es un Int"))
				| VString(s) -> match s with 
					StringVar(x) -> (match (get env x) with
										Bool(x) -> comm env prog (Assign(name,VBool(MkBool x)))
										| Int(x) -> comm env prog (Assign(name,VInt(MkInt x)))
										| String(x) -> comm env prog (Assign(name,VString(MkString x)))
										| _ -> raise (Tipos.ERROR_DE_TIPOS("")))
										
					| StringArray(n,x) -> (match (get env n) with
										ArrayBool(l) -> comm env prog (Assign(name,VBool(MkBool(bexp env prog (BoolArray(n,x))))))
										| ArrayInt(l) -> comm env prog (Assign(name,VInt(MkInt(aexp env prog (IntArray(n,x))))))
										| ArrayString(l) -> comm env prog (Assign(name,VString(MkString(sexp env prog (StringArray(n,x))))))
										| _ -> raise (Tipos.ERROR_DE_TIPOS("")))
					| _ -> (match (get env name) with 
								| String(_) -> Env.add env name (String (sexp env prog s))
								| _ -> raise (Tipos.ERROR_DE_TIPOS "No es un String")))

    | AssignArray(name, index, value) -> 
		(if not(exists env name) then raise (Tipos.NO_LIGADA name)
		else let mod_lista lista valor posicion = 
				let rec aux l v p pini =
					if p>0 then List.hd l :: aux (List.tl l) v (p-1) pini
					else (pini,v) :: List.tl l
				in aux lista valor posicion posicion
			in let index = (aexp env prog index) in let lista = get env name
			in match value with
				VBool(b) -> (match lista with 
					ArrayBool(l) -> Env.add env name (ArrayBool(mod_lista l (bexp env prog b) index))
					| _ -> raise (Tipos.ERROR_DE_TIPOS("No es un ArrayBool")))
				| VInt(i) -> (match lista with 
					ArrayInt(l) -> Env.add env name (ArrayInt(mod_lista l (aexp env prog i) index))
					| _ -> raise (Tipos.ERROR_DE_TIPOS("No es un ArrayInt")))
				| VString(s) -> match s with
					StringVar(x) -> (match (get env x) with
										Bool(x) -> comm env prog (AssignArray(name,(MkInt index),VBool(MkBool x)))
										| Int(x) -> comm env prog (AssignArray(name,(MkInt index),VInt(MkInt x)))
										| String(x) -> comm env prog (AssignArray(name,(MkInt index),VString(MkString x)))
										| _ -> raise (Tipos.ERROR_DE_TIPOS("")))
					| StringArray(n,x) -> (match (get env n) with
										ArrayBool(l) -> comm env prog (AssignArray(name,(MkInt index),VBool(MkBool(bexp env prog (BoolArray(n,x))))))
										| ArrayInt(l) -> comm env prog (AssignArray(name,(MkInt index),VInt(MkInt(aexp env prog (IntArray(n,x))))))
										| ArrayString(l) -> comm env prog (AssignArray(name,(MkInt index),VString(MkString(sexp env prog (StringArray(n,x))))))
										| _ -> raise (Tipos.ERROR_DE_TIPOS("")))
					| _ -> (match lista with 
						ArrayString(l) -> Env.add env name (ArrayString(mod_lista l (sexp env prog s) index))
					| _ -> raise (Tipos.ERROR_DE_TIPOS("No es un ArrayString"))))

    | Seq(c1, c2) -> let env1 = comm env prog c1 in comm env1 prog c2
    | While(b,c)  -> let env = Env.push_env env in 
    					if (bexp env prog b) then 
    						let env = comm env prog (Seq(c, While(b,c))) in Env.pop_env env 
    					else Env.pop_env env
    | If(b,c1,c2) -> if (bexp env prog b) then 
						let env = Env.push_env env in let env = comm env prog c1 in Env.pop_env env 
					else comm env prog c2
    | Print value -> 
		(match value with
			VBool(b) -> print_string(string_of_bool(bexp env prog b)); print_newline(); env
			| VInt(i) -> print_string(string_of_int(aexp env prog i)); print_newline(); env
			| VString(s) -> (match s with
								StringVar(x) -> (match (get env x) with
													Bool(x) -> comm env prog (Print (VBool(MkBool x)))
													| Int(x) -> comm env prog (Print (VInt(MkInt x)))
													| String(x) -> comm env prog (Print (VString(MkString x)))
													| _ -> raise (Tipos.ERROR_DE_TIPOS("")))
								| StringArray(n,x) -> (match (get env n) with
										ArrayBool(l) -> comm env prog (Print (VBool(BoolArray(n,x))))
										| ArrayInt(l) -> comm env prog (Print (VInt(IntArray(n,x))))
										| ArrayString(l) -> print_string(sexp env prog s); print_newline(); env
										| _ -> raise (Tipos.ERROR_DE_TIPOS("")))
								| _ -> print_string(sexp env prog s); print_newline(); env))
    | Return value -> failwith "Not implemented"

let program env prog = failwith "not implemented"
