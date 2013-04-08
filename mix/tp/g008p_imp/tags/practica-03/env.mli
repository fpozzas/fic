
type name = string
type content = Int of int
             | Bool of bool
             | String of string
             | ArrayInt of (int * int) list
             | ArrayBool of (int * bool) list
             | ArrayString of (int * string) list
             
type env 

val empty : env
val add : env -> name -> content -> env
val get : env -> name -> content option 
val print : env -> unit
