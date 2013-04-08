type token =
  | ENTERO of (int)
  | CADENA of (string)
  | VARIABLE of (string)
  | AND
  | BOOL
  | CIRCUM
  | COMA
  | CORDER
  | CORIZQ
  | DEFINE
  | DO
  | DONE
  | DOSIGUAL
  | ELSE
  | EOF
  | FALSE
  | FI
  | IF
  | IGUAL
  | INT
  | LLAVEDER
  | LLAVEIZQ
  | MAS
  | MAYOR
  | MAYORIGUAL
  | MENOR
  | MENORIGUAL
  | MENOS
  | MENOSU
  | NOT
  | OR
  | PARDER
  | PARIZQ
  | POR
  | PRINT
  | PUNTOCOMA
  | RETURN
  | SKIP
  | STRING
  | SUBSTRING
  | THEN
  | TRUE
  | WHILE

val aexp :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Tipos.aexp
val bexp :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Tipos.bexp
val sexp :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Tipos.sexp
val comms :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Tipos.comm
val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Tipos.program
