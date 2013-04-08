(** Definición de los tipos para el compilador de IMP *)

(**Almacena el nombre de una determinada variable*)
type variable = string

type name = string

type imp_type = Bool
              | Int
              | String

type imp_exp = VBool of bexp
         | VInt of aexp
         | VString of sexp
         
(**Expresión de tipo entero*)
and aexp = MkInt of int (**Constructor para almacenar el valor del entero*)
          | IntVar of variable (**Constructor para almacenar el nombre de la variable*)
          | Sum of aexp * aexp (**Constructor para sumas de enteros*)
          | Res of aexp * aexp (**Constructor para restas de enteros*)
          | Mul of aexp * aexp (**Constructor para multiplicacion de enteros*)
          | IntArray of variable * aexp (**Constructor para crear un array de enteros*)
          | AFun of name * imp_exp list          
 
and index = aexp

and size = aexp
          
(**Expresión de tipo boolean*)    
and bexp = MkBool of bool (**Constructor para almacenar el valor del boolean*)
          | BoolVar of variable (**Constructor para almacenar el nombre de la variable*)
          | Equal of aexp * aexp (**Constructor para la operación '='*)
          | Lt of aexp * aexp (**Contructor para la operación '<'*)
          | LtEq of aexp * aexp (**Constructor para la operación '<='*)
          | Gt of aexp * aexp (**Constructor para la operación '>'*)
          | GtEq of aexp * aexp (**Constructor para la operación '>='*)
          | Not of bexp (**Constructor de la operación negación*)
          | And of bexp * bexp (**Constructor de la operación lógica 'and'*)
          | Or of bexp * bexp (**Constructor de la operación lógica 'or'*)
          | BoolArray of variable * aexp (**Constructor para crear un array de booleans*)
          | BFun of name * imp_exp list          

(**Expresión de tipo string*)
and sexp = MkString of string (**Constructor para almacenar el valor del string*)
          | StringVar of variable (**Constructor para almacenar el nombre de la variable*)
          | Concat of sexp * sexp (**Constructor para la operación de concatenacion*) 
          | Substring of sexp * aexp * aexp (**Constructor para la operación de cortar*)
          | StringArray of variable * aexp (**Constructor para crear un array de strings*)
          | SFun of name * imp_exp list          
          
type arg = AInt of name 
         | ABool of name
         | AString of name   

(**Expresión de tipo comando*)
type comm = Skip (**Contructor para la funcion nula*)
          | MkVar of variable * imp_exp (**Constructor para la creación de variables*)
          | Assign of variable * imp_exp (**Constructor para la asignación de valores a las variables*)
          | Seq of comm * comm (** Constructor para la ejecucion secuencial*)
          | If of bexp * comm * comm (** Constructor para la operacion condicional*)
          | While of bexp * comm (** Constructor para la operacion 'mientras'*)
          | Print of imp_exp (**Constructor para la operacion de mostrar por pantalla*)
          | MkArray of variable * aexp * imp_exp (**Constructor para la creación de un array*)
          | AssignArray of variable * aexp * imp_exp (**Constructor para añadir un valor en una posición a un array*)
          | Return of imp_exp

type result = imp_type

type imp_function = MkFun of result * arg list * comm

type definition = DefineFun of name * imp_function

type program = definition list

(**Excepciónes posibles*)
(**Excepción causada por un fallo lexico*)
exception ERROR_LEXICO 
(**Excepción causada por un fallo sintactico*)
exception ERROR_SINTACTICO 
(**Excepción causada si se intenta crear una variable ya existente*)
exception YA_LIGADA of variable
(**Excepción causada si la variable a la que se intenta acceder no existe*)
exception NO_LIGADA of variable 
(**Excepción causada por un error de tipos, explicado en string*)
exception ERROR_DE_TIPOS of string 
(**Error en tiempo de ejecución, explicado en un string*)
exception ERROR_DE_EJECUCION of string 
(**Excepción causada por intentar acceder a posiciones inválidas*)
exception FUERA_DE_RANGO of string



