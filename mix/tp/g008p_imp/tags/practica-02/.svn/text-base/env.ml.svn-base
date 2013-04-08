(** Contiene la implementación de los entornos *)

open Tipos

(** Nombre de la variable *)
type name = string

(** Contenido asociado a una variable *)
type content = int

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
(** Imprime las variables y los valores asociados a estas de un entorno
@param env Entorno que queremos imprimir *)
let print env =
    let rec string_of_env env =
        match env with
          []                 -> "";
        | (name, content)::t ->  (name ^ " := " ^ string_of_int content ^ ";\n") ^ (string_of_env t)
    in  print_string (string_of_env env)


    

