(** Contiene la implementación de los entornos *)

open Tipos

(** Nombre de la variable *)
type name = string

(** Contenido asociado a una variable *)
type content = Int of int
             | Bool of bool
             | String of string
             | ArrayInt of (int * int) list
             | ArrayBool of (int * bool) list
             | ArrayString of (int * string) list

(** Lista de entornos compuestos por variables y sus contenidos. La lista va de
entorno más local a menos local (siendo el último siempre el entorno global) *)
type env = (name * content) list list

let empty = []

(** Se modifica una variable en el entorno. Para añadir nuevas variables se usa add_local.
Esta función recorre recursivamente los entornos hasta encontrar la variable y la modifica.
@param env Lista de entornos
@param name Nombre de la variable
@param content Nuevo contenido que irá asociado a la variable que se le pasa 
@return Devuelve un entorno con la variable y el contenido que le pasamos a la función *)
let rec add env name content =
	let rec buscar_var l n = match l with
		[] -> false
		| (n, c)::t when name = n -> true
		| h::t -> buscar_var t n
	in 
	if (env = []) then raise (Tipos.NO_LIGADA name)
	else if (buscar_var (List.hd env) name = false)
		then List.hd env :: add (List.tl env) name content
	else let rec mod_var l name content = match l with
			| (n, c)::t when name = n -> (name, content)::t
			| h::t -> h::mod_var t name content
			| _ -> raise (Tipos.NO_LIGADA name)
		in mod_var (List.hd env) name content :: List.tl env

(** Se añade una nueva variable al entorno local o se modifica si ya existe
@param env Lista de entornos
@param name Nombre de la variable
@param content Nuevo contenido que irá asociado a la variable que se le pasa
@return Devuelve la lista de entornos actualizado con la variable y su contenido *)
let add_local env name content = match env with
	| [] -> [[(name, content)]]
	| h::t -> 
		let rec aux env name content = match env with
			[]                      -> [(name, content)]
			| (n, c)::t when name = n -> (name, content)::t
			| h::t                    -> h::(aux t name content)
		in (aux h name content)::t

(** Se añade un nuevo entorno local a la lista de entornos
@param env Lista de entornos
@return Devuelve la lista de entornos con un nuevo entorno local vacio al principio de esa lista *)
let push_env env = [] :: env

(** Se elimina un entorno local de la lista de entornos
@param env Lista de entornos
@return Devuelve la lista de entornos si el entorno local *)
let pop_env env  = List.tl env

(** Dada la variable, devuelve el contenido asociado a esa variable en un entorno. Si esa variable
no existe en el entorno local actual, analiza los siguientes y si encuentra la variable, devuelve
el valor de la que esté en el entorno más "cercano" al local actual.
@param env Lista de entornos
@param name Nombre de la variable de la que queremos saber su contenido
@return Devuelve el contenido asociado a la variable [name] dada en el entorno [env] *)
let rec get env name =
	if (env = []) then None
	else match List.hd env with
			[] -> get (List.tl env) name
			| (n, c)::t when name = n -> Some(c)
			| h::t -> get (t :: List.tl env) name

(** Devuelve el valor del entero almacenado en una determinada posición de un array
@param prev Permite concatenar al comienzo de la linea el string recibido
@param name Nombre del array
@param index Posición del array en la que se encuentra el entero
@param value Valor del entero que se desea mostrar
@return Una cadena con una estructura del tipo name[index]=value*) 
let string_of_int_pos (prev,name) (index,value) =
    (prev ^ name ^ "[" ^  (string_of_int index) ^ "] := " ^ (string_of_int value) ^ ";\n", name)


(** Devuelve el valor del boolean almacenado en una determinada posición de un array
@param prev Permite concatenar al comienzo de la linea el string recibido
@param name Nombre del array
@param index Posición del array en la que se encuentra el boolean
@param value Valor del boolean que se desea mostrar
@return Una cadena con una estructura del tipo name[index]=value*)
let string_of_bool_pos (prev,name) (index,value) =
    (prev ^ name ^ "[" ^  (string_of_int index) ^ "] := " ^ (string_of_bool value) ^ ";\n", name)


(** Devuelve el valor del string almacenado en una determinada posición de un array
@param prev Permite concatenar al comienzo de la linea el string recibido
@param name Nombre del array
@param index Posición del array en la que se encuentra el strin
@param value Valor del string que se desea mostrar
@return Una cadena con estructura del tipo name[index]=value*)
let string_of_string_pos (prev,name) (index,value) =
    (prev ^ name ^ "[" ^  (string_of_int index) ^ "] := \"" ^ value ^ "\";\n", name)


(**Devuelve el valor de una variable
@param name Nombre de la variable
@param content Contenido de la variable
@return Una cadena con estructura del tipo name:=content*)
let string_of_content name content =
    match content with
          Int n -> name ^ " := " ^ (string_of_int n) ^ ";\n"
        | Bool b -> name ^ " := " ^ (string_of_bool b) ^ ";\n"
        | String s -> name ^ " := \"" ^  s ^ "\"\n"
        | ArrayInt l -> fst(List.fold_left string_of_int_pos ("",name) l)
        | ArrayBool l -> fst(List.fold_left string_of_bool_pos ("",name) l)
        | ArrayString l -> fst(List.fold_left string_of_string_pos ("",name) l)
        

(** Imprime las variables y los valores asociados a estas del entorno superior
@param env Lista de entornos *)
let print env =
    let rec string_of_env = function
              [] -> ""
            | (name, content)::t -> (string_of_content name content) ^ (string_of_env t)
    in if (env = []) then () else print_string (string_of_env (List.hd env))

