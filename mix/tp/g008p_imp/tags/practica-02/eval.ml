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
        
(**Define las expresiones de tipo entero
@param env Un entorno para trabajar
@return Resultado de la operación*)
let rec aexp env = function 
      MkInt n     -> n
    | IntVar v    -> get env v
    | Sum(a1, a2) -> aexp env a1 + aexp env a2
    | Res(a1, a2) -> aexp env a1 - aexp env a2
    | Mul(a1, a2) -> aexp env a1 * aexp env a2

(**Define las expresiones de tipo lógico
@param env Un entorno para trabajar 
@return Resultado de la operación*)
let rec bexp env = function
      True          -> true
    | False         -> false
    | Not(b)        -> not (bexp env b)
    | And(b1, b2)   -> (bexp env b1) & (bexp env b2)
    | Or(b1, b2)    -> (bexp env b1) or (bexp env b2)
    | Equal(a1, a2) -> (aexp env a1) = (aexp env a2)
    | Gt(a1, a2)    -> (aexp env a1) > (aexp env a2)
    | GtEq(a1, a2)  -> (aexp env a1) >= (aexp env a2)
    | Lt(a1, a2)    -> (aexp env a1) < (aexp env a2)
    | LtEq(a1, a2)  -> (aexp env a1) <= (aexp env a2)

(**Define las operaciones del lenguaje
@param env Un entorno para trabajar
@return El entorno tras la operación*)
let rec comm env = function
      Skip                -> env
    | MkVar(name, value)  -> Env.add env name (aexp env value)
    | Assign(name, value) -> 
          if (exists env name) then Env.add env name (aexp env value)
          else raise (Tipos.NO_LIGADA name)     
    | Seq(c1, c2)         -> let env1 = comm env c1 in comm env1 c2
    | While(b,c)          -> if (bexp env b) then comm env (Seq(c, While(b,c))) else env
    | Print n             -> print_string(string_of_int(aexp env n)); print_newline(); env
    | If(b,c1,c2)         -> if (bexp env b) then comm env c1 else comm env c2

(**Llama a comm pasándole c y env*)
let program c env = comm c env
