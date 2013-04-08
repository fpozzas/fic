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

(** Entorno compuesto por una lista de variables con sus valores asociados *)
type env = (name * content) list

let empty = []

(** Se añade o modifica una variable en el entorno
@param env Entorno que modificamos
@param name Nombre de la variable
@param content Nuevo contenido que irá asociado a la variable que se le pasa 
@return Devuelve un entorno con la variable y el contenido que le pasamos a la función *)
let rec add env name content =
    match env with 
          []                      -> [(name, content)]
        | (n, c)::t when name = n -> (name, content)::t
        | h::t                    -> h::(add t name content)
        
(** Dada la variable, devuelve el contenido asociado a esa variable en un entorno
@param env Entorno que contiene ternas nombre y contenido
@param name Nombre de la variable de la que queremos saber su contenido
@return Devuelve el contenido asociado a la variable [name] dada en el entorno [env] *)
let rec get env name =
    match env with
          []        -> None
        | (n, c)::t -> if n = name then Some c
                       else get t name
                       

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
        

(** Imprime las variables y los valores asociados a estas de un entorno
@param env Entorno que queremos imprimir *)
let print env =
    let rec string_of_env = function
              [] -> ""
            | (name, content)::t -> (string_of_content name content) ^ (string_of_env t)
    in print_string (string_of_env env)


    

