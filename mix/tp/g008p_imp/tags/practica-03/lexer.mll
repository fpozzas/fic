
{
     open Parser

     let cadena c = String.sub c 1 (String.length c - 2)
}

rule token = parse
     [' ' '\t' '\n']    { token lexbuf }
   | '('                { PARIZQ }
   | ')'                { PARDER }
   | '['                { CORIZQ }
   | ']'                { CORDER }
   | '{'		{ LLAVEIZQ }
   | '}'		{ LLAVEDER }
   | '='                { IGUAL }
   | "<="               { MENORIGUAL }
   | "<"                { MENOR }
   | ">="               { MAYORIGUAL }
   | ">"                { MAYOR }
   | '+'                { MAS }
   | '-'                { MENOS }
   | '*'                { POR }
   | ','                { COMA }
   | ';'                { PUNTOCOMA }
   | '^'		{ CIRCUM }
   | ":="               { DOSIGUAL }
   | "and"              { AND }
   | "not"		{ NOT }
   | "or"               { OR }
   | "if"               { IF }
   | "then"             { THEN }
   | "else"             { ELSE }
   | "fi"               { FI }
   | "while"            { WHILE }
   | "do"               { DO }
   | "define"           { DEFINE }
   | "done"             { DONE }
   | "skip"             { SKIP }
   | "false"            { FALSE }
   | "true"             { TRUE }
   | "print"            { PRINT }
   | "substring"        { SUBSTRING }
   | "return"           { RETURN }
   | "Int"              { INT }
   | "Bool"             { BOOL }
   | "String"           { STRING }
   | ['0'-'9']+         { ENTERO (int_of_string (Lexing.lexeme lexbuf)) }
   | ['a'-'z''A'-'Z']['A'-'Z''a'-'z''0'-'9''_']*
                        { VARIABLE (Lexing.lexeme lexbuf)}
   | '"'[^'"']*'"'
                        { CADENA (cadena(Lexing.lexeme lexbuf)) }
   | '#'[^'\n']*'\n'    { token lexbuf }
   | eof                { EOF }
   | _                  { raise Tipos.ERROR_LEXICO }

			



