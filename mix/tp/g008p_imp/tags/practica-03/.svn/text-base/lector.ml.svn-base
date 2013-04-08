(** Utiliza los analizadores léxico y sintáctico para traducir una cadena de caracteres a la representación utilizada por el intérprete *)

(** Procesa una cadena que llama a una función algebraica *)
let aexp cadena =
    Parser.aexp Lexer.token (Lexing.from_string cadena)

(** Procesa una cadena que llama a una función booleana *)
let bexp cadena =  
  Parser.bexp Lexer.token (Lexing.from_string cadena)

(** Procesa una cadena que llama a una función de cadena *)  
let sexp cadena =  
    Parser.sexp Lexer.token (Lexing.from_string cadena)

(** Procesa una cadena que llama a un comando *)
let comm cadena =
    Parser.program Lexer.token (Lexing.from_string cadena)

(** Procesa una cadena que es la ruta de un fichero con instrucciones *)
let fichero nombre = 
    Parser.program Lexer.token (Lexing.from_channel (open_in nombre))
