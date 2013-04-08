(** Definición de los tipos para el compilador de IMP *)

(**Almacena el nombre de una determinada variable*)
type variable = string

(**Expresión de tipo entero*)
type aexp = MkInt of int (**Constructor para almacenar el valor del entero*)

          | IntVar of variable (**Constructor para almacenar el nombre de la variable*)
          | Sum of aexp * aexp (**Constructor para sumas de enteros*)
          | Res of aexp * aexp (**Constructor para restas de enteros*)
          | Mul of aexp * aexp (**Constructor para multiplicacion de enteros*)

(**Expresión de tipo boolean*)    
type bexp = True (*Valor TRUE*)
          | False (*Valor FALSE*)
          | Equal of aexp * aexp (**Constructor para la operación '='*)
          | Lt of aexp * aexp (**Contructor para la operación '<'*)
          | LtEq of aexp * aexp (**Constructor para la operación '<='*)
          | Gt of aexp * aexp (**Constructor para la operación '>'*)
          | GtEq of aexp * aexp (**Constructor para la operación '>='*)
          | Not of bexp (**Constructor de la operación negación*)
          | And of bexp * bexp (**Constructor de la operación lógica 'and'*)
          | Or of bexp * bexp (**Constructor de la operación lógica 'or'*)

(**Expresión de tipo comando*)
type comm = Skip (**Contructor para la funcion nula*)
          | MkVar of variable * aexp (**Constructor para la creación de variables*)
          | Assign of variable * aexp (**Constructor para la asignación de valores a las variables*)
          | Seq of comm * comm (** Constructor para la ejecucion secuencial*)
          | If of bexp * comm * comm (** Constructor para la operacion condicional*)
          | While of bexp * comm (** Constructor para la operacion 'mientras'*)
          | Print of aexp (**Constructor para la operacion de mostrar por pantalla*)

(**Expresión de tipo programa formada por comandos*)
type program = comm

(**Excepciónes posibles*)
(**Excepción causada por un fallo lexico*)
exception ERROR_LEXICO 
(**Excepción causada por un fallo sintactico*)
exception ERROR_SINTACTICO 
(**Variable inexistente*)
exception NO_LIGADA of variable 
(**Excepción causada por un error de tipos, explicado en string*)
exception ERROR_DE_TIPOS of string 
(**Error en tiempo de ejecucion, explicado en un string*)
exception ERROR_DE_EJECUCION of string 



