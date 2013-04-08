
type name = string
type content = int
type env

val empty : env
val add : env -> name -> content -> env
val get : env -> name -> content option 
val print : env -> unit
