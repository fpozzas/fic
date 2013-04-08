

%{
   open Tipos
%}

%token <int> ENTERO
%token <string> CADENA
%token <string> VARIABLE
%token AND
%token BOOL
%token CIRCUM
%token COMA
%token CORDER
%token CORIZQ
%token DEFINE
%token DO
%token DONE
%token DOSIGUAL
%token ELSE
%token EOF
%token FALSE
%token FI
%token IF
%token IGUAL
%token INT
%token LLAVEDER
%token LLAVEIZQ
%token MAS
%token MAYOR
%token MAYORIGUAL
%token MENOR
%token MENORIGUAL
%token MENOS
%token MENOSU
%token NOT
%token OR
%token PARDER
%token PARIZQ
%token POR
%token PRINT
%token PUNTOCOMA
%token RETURN
%token SKIP
%token STRING
%token SUBSTRING
%token THEN
%token TRUE
%token WHILE

%nonassoc DOSIGUAL
%left OR           /* lowest precedence */
%left AND                /* medium precedence */
%nonassoc IGUAL MAYOR MENOR MENORIGUAL MAYORIGUAL 
%left CIRCUM
%left MAS MENOS           /* lowest precedence */
%left POR                 /* medium precedence */  
%nonassoc MENOSU          /* highest precedence */


%start aexp
%type <Tipos.aexp> aexp

%start bexp
%type <Tipos.bexp> bexp

%start sexp
%type <Tipos.sexp> sexp

%start comms
%type <Tipos.comm> comms

%start program
%type <Tipos.program> program

%%

program : EOF         { raise ERROR_SINTACTICO }
    | definitions EOF { $1 }
;

definitions : definition           { [$1] } 
         | definition definitions  { $1 :: $2 }
;

definition : 
    DEFINE imp_type VARIABLE PARIZQ arguments PARDER LLAVEIZQ comms LLAVEDER
    { DefineFun($3, MkFun($2, $5, $8)) }
;

imp_type : BOOL { Bool }
     | INT      { Int }
     | STRING   { String }
;

comms : comm                  { $1 } 
      | comm PUNTOCOMA        { $1 } 
      | comm PUNTOCOMA comms  { Seq($1,$3) }
;

comm: SKIP                                                 { Skip }
        | INT VARIABLE DOSIGUAL aexp                       { MkVar($2, VInt($4)) }
        | BOOL VARIABLE DOSIGUAL bexp                      { MkVar($2, VBool($4)) }
        | STRING VARIABLE DOSIGUAL sexp                    { MkVar($2, VString($4)) }
        | VARIABLE DOSIGUAL aexp                           { Assign($1, VInt($3)) }
        | VARIABLE DOSIGUAL bexp                           { Assign($1, VBool($3)) }
        | VARIABLE DOSIGUAL sexp                           { Assign($1, VString($3)) }
        | VARIABLE CORIZQ aexp CORDER DOSIGUAL aexp        { AssignArray($1, $3, VInt($6)) }
        | VARIABLE CORIZQ aexp CORDER DOSIGUAL bexp        { AssignArray($1, $3, VBool($6)) }
        | VARIABLE CORIZQ aexp CORDER DOSIGUAL sexp        { AssignArray($1, $3, VString($6)) }
        | INT VARIABLE CORIZQ aexp CORDER DOSIGUAL aexp    { MkArray($2,$4, VInt($7)) }
        | BOOL VARIABLE CORIZQ aexp CORDER DOSIGUAL bexp   { MkArray($2, $4, VBool($7)) }
        | STRING VARIABLE CORIZQ aexp CORDER DOSIGUAL sexp { MkArray($2, $4, VString($7)) }
        | IF bexp THEN comms ELSE comms FI                 { If($2, $4, $6) }
        | WHILE bexp DO comms DONE                         { While($2, $4) }
        | PRINT imp_exp                                    { Print($2) }
        | RETURN imp_exp                                   { Return($2) }
;

imp_exp : aexp                { VInt($1) }
        | bexp                { VBool($1) }
        | sexp                { VString($1) }
;

sexp:     CADENA                                             { MkString ($1) }
        | VARIABLE                                           { StringVar($1) }
        | VARIABLE CORIZQ aexp CORDER                        { StringArray($1, $3) }
       	| VARIABLE PARIZQ args PARDER                        { SFun($1, $3) }
        | sexp CIRCUM sexp                                   { Concat($1, $3) }
        | SUBSTRING PARIZQ sexp COMA aexp COMA aexp PARDER   { Substring($3, $5, $7) }
        | PARIZQ sexp PARDER                                 { $2 }
;

bexp : TRUE                         { MkBool(true) }
     | FALSE                        { MkBool(false) }
     | VARIABLE                     { BoolVar($1) }
     | VARIABLE CORIZQ aexp CORDER  { BoolArray ($1, $3) }
     | VARIABLE PARIZQ args PARDER  { BFun($1, $3) }
     | aexp IGUAL aexp              { Equal($1, $3) }
     | aexp MENOR aexp              { Lt($1, $3) }
     | aexp MENORIGUAL aexp         { LtEq($1, $3) }
     | aexp MAYOR aexp              { Gt($1, $3) }
     | aexp MAYORIGUAL aexp         { GtEq($1, $3) }
     | NOT bexp                     { Not($2) }
     | bexp AND bexp                { And($1, $3) }
     | bexp OR bexp                 { Or($1, $3) }
     | PARIZQ bexp PARDER           { $2 }
;

aexp : ENTERO                        { MkInt($1) }
     | VARIABLE                      { IntVar($1) }
     | VARIABLE CORIZQ aexp CORDER   { IntArray($1, $3) }
     | VARIABLE PARIZQ args PARDER   { AFun($1, $3) }
     | aexp MAS aexp                 { Sum($1,$3) }
     | aexp MENOS aexp               { Res($1,$3) }
     | aexp POR aexp                 { Mul($1,$3) }
     | MENOS aexp %prec MENOSU       { Res(MkInt(0),$2) }
     | PARIZQ aexp PARDER            { $2 }
;

arguments:                     { [] }
     | argument                { [$1] }
     | argument COMA arguments { $1 :: $3 }
;

argument : INT VARIABLE {AInt $2 }
     | BOOL VARIABLE    {ABool $2 }
     | STRING VARIABLE  {AString $2 }
;

args :                    { [] }
     | imp_exp            { [$1] } 
     | imp_exp COMA args  { $1::$3 }
;

%%
