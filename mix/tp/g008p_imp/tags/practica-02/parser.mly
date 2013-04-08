

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
%token THEN
%token TRUE
%token WHILE

%nonassoc DOSIGUAL
%left OR                  /* lowest precedence */
%left AND                 /* medium precedence */
%nonassoc IGUAL MENORIGUAL
%left CIRCUM
%left MAS MENOS           /* lowest precedence */
%left POR                 /* medium precedence */  
%nonassoc MENOSU          /* highest precedence */


%start aexp
%type <Tipos.aexp> aexp

%start bexp
%type <Tipos.bexp> bexp

%start comms
%type <Tipos.comm> comms

%start program
%type <Tipos.program> program

%%

program : EOF     { raise ERROR_SINTACTICO }
    | comms       {$1}
;

comms : comm                  { $1 } 
      | comm PUNTOCOMA        { $1 } 
      | comm PUNTOCOMA comms  { Seq($1,$3) }
;

comm    : SKIP                               { Skip }
    | INT VARIABLE DOSIGUAL aexp             { MkVar($2, $4) }
    | VARIABLE DOSIGUAL aexp                 { Assign($1, $3) }
    | IF bexp THEN comms ELSE comms FI       { If($2, $4, $6) }
    | WHILE bexp DO comms DONE               { While($2, $4) }
    | PRINT aexp                             { Print($2) }
;


bexp : TRUE                  { True }
     | FALSE                 { False }
     | aexp IGUAL aexp       { Equal($1, $3) }
     | aexp MAYOR aexp       { Gt($1, $3) }
     | aexp MAYORIGUAL aexp  { GtEq($1, $3) }
     | aexp MENOR aexp       { Lt($1, $3) }
     | aexp MENORIGUAL aexp  { LtEq($1, $3) }
     | NOT bexp              { Not($2) }
     | bexp AND bexp         { And($1, $3) }
     | bexp OR bexp          { Or($1, $3) }
     | PARIZQ bexp PARDER    { $2 }
;

aexp : ENTERO                   { MkInt($1) }
     | VARIABLE                 { IntVar($1) }
     | aexp MAS aexp            { Sum($1,$3) }
     | aexp MENOS aexp          { Res($1,$3) }
     | aexp POR aexp            { Mul($1,$3) }
     | MENOS aexp %prec MENOSU  { Res(MkInt(0),$2) }
     | PARIZQ aexp PARDER       { $2 }
;

%%