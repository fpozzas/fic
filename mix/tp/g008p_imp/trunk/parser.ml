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

open Parsing;;
# 4 "parser.mly"
   open Tipos
# 50 "parser.ml"
let yytransl_const = [|
  260 (* AND *);
  261 (* BOOL *);
  262 (* CIRCUM *);
  263 (* COMA *);
  264 (* CORDER *);
  265 (* CORIZQ *);
  266 (* DEFINE *);
  267 (* DO *);
  268 (* DONE *);
  269 (* DOSIGUAL *);
  270 (* ELSE *);
    0 (* EOF *);
  271 (* FALSE *);
  272 (* FI *);
  273 (* IF *);
  274 (* IGUAL *);
  275 (* INT *);
  276 (* LLAVEDER *);
  277 (* LLAVEIZQ *);
  278 (* MAS *);
  279 (* MAYOR *);
  280 (* MAYORIGUAL *);
  281 (* MENOR *);
  282 (* MENORIGUAL *);
  283 (* MENOS *);
  284 (* MENOSU *);
  285 (* NOT *);
  286 (* OR *);
  287 (* PARDER *);
  288 (* PARIZQ *);
  289 (* POR *);
  290 (* PRINT *);
  291 (* PUNTOCOMA *);
  292 (* RETURN *);
  293 (* SKIP *);
  294 (* STRING *);
  295 (* SUBSTRING *);
  296 (* THEN *);
  297 (* TRUE *);
  298 (* WHILE *);
    0|]

let yytransl_block = [|
  257 (* ENTERO *);
  258 (* CADENA *);
  259 (* VARIABLE *);
    0|]

let yylhs = "\255\255\
\005\000\005\000\004\000\004\000\004\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\006\000\006\000\006\000\
\006\000\006\000\006\000\006\000\006\000\007\000\007\000\007\000\
\003\000\003\000\003\000\003\000\003\000\003\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\001\000\001\000\001\000\001\000\001\000\
\001\000\001\000\001\000\000\000\000\000\000\000\000\000\000\000"

let yylen = "\002\000\
\001\000\001\000\001\000\002\000\003\000\001\000\004\000\004\000\
\004\000\003\000\003\000\003\000\006\000\006\000\006\000\007\000\
\007\000\007\000\007\000\005\000\002\000\001\000\001\000\001\000\
\001\000\001\000\004\000\003\000\008\000\003\000\001\000\001\000\
\001\000\004\000\003\000\003\000\003\000\003\000\003\000\002\000\
\003\000\003\000\003\000\001\000\001\000\004\000\003\000\003\000\
\003\000\002\000\003\000\002\000\002\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\044\000\000\000\
\000\000\000\000\000\000\000\000\032\000\000\000\000\000\031\000\
\000\000\000\000\025\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\006\000\000\000\000\000\055\000\
\000\000\001\000\002\000\056\000\000\000\050\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\021\000\000\000\000\000\000\000\000\000\
\051\000\000\000\000\000\049\000\000\000\043\000\000\000\000\000\
\000\000\000\000\000\000\041\000\000\000\000\000\030\000\000\000\
\028\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\005\000\046\000\
\000\000\027\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\019\000\
\000\000\000\000\029\000"

let yydgoto = "\006\000\
\017\000\046\000\055\000\032\000\036\000\033\000\068\000"

let yysindex = "\244\000\
\009\255\255\254\003\255\077\255\001\000\000\000\000\000\006\255\
\009\255\009\255\250\254\013\255\000\000\255\254\255\254\000\000\
\211\255\041\255\000\000\015\255\003\255\254\254\031\255\000\255\
\040\255\255\254\046\255\132\255\000\000\051\255\255\254\000\000\
\027\255\000\000\000\000\000\000\009\255\000\000\118\255\009\255\
\009\255\009\255\009\255\041\255\199\255\025\255\009\255\009\255\
\009\255\009\255\009\255\255\254\255\254\009\255\001\255\003\255\
\003\255\009\255\132\255\080\255\004\255\141\255\058\255\132\255\
\211\255\041\255\031\255\000\000\171\255\035\255\077\255\104\255\
\000\000\042\255\042\255\000\000\119\255\000\000\250\254\250\254\
\250\254\250\254\250\254\000\000\074\255\135\255\000\000\084\255\
\000\000\152\255\211\255\041\255\031\255\009\255\255\254\077\255\
\009\255\009\255\009\255\009\255\003\255\077\255\000\000\000\000\
\000\000\000\000\009\255\068\255\159\255\041\255\069\255\167\255\
\250\254\169\255\185\255\031\255\072\255\065\255\132\255\073\255\
\077\255\087\255\000\000\090\255\000\000\009\255\211\255\041\255\
\031\255\255\254\089\255\009\255\003\255\177\255\041\255\000\000\
\250\254\031\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\033\000\
\000\000\000\000\106\000\113\000\000\000\000\000\000\000\000\000\
\000\000\116\000\000\000\017\000\000\000\000\000\122\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\003\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\242\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\016\001\000\000\
\018\000\066\000\169\000\000\000\000\000\000\000\118\000\000\000\
\000\000\063\000\088\000\000\000\000\000\000\000\163\000\176\000\
\198\000\209\000\220\000\000\000\231\000\000\000\000\000\000\000\
\000\000\000\000\170\000\183\000\000\001\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\138\000\000\000\000\000\000\000\000\000\013\001\000\000\000\000\
\072\001\000\000\000\000\083\001\000\000\000\000\000\000\000\000\
\000\000\000\000\046\001\000\000\000\000\000\000\084\001\097\001\
\108\001\000\000\000\000\000\000\000\000\000\000\109\001\000\000\
\121\001\122\001\000\000"

let yygindex = "\000\000\
\010\000\071\000\020\000\255\255\000\000\000\000\000\000"

let yytablesize = 669
let yytable = "\007\000\
\034\000\012\000\003\000\035\000\019\000\020\000\057\000\052\000\
\058\000\007\000\011\000\008\000\059\000\013\000\037\000\040\000\
\026\000\022\000\038\000\039\000\041\000\043\000\023\000\054\000\
\045\000\009\000\042\000\014\000\052\000\056\000\015\000\087\000\
\045\000\053\000\021\000\009\000\057\000\065\000\052\000\016\000\
\010\000\022\000\060\000\096\000\052\000\102\000\072\000\067\000\
\062\000\074\000\075\000\076\000\077\000\069\000\053\000\078\000\
\079\000\080\000\081\000\082\000\083\000\071\000\047\000\086\000\
\053\000\023\000\099\000\090\000\091\000\103\000\053\000\126\000\
\018\000\045\000\042\000\088\000\089\000\052\000\093\000\024\000\
\119\000\025\000\121\000\125\000\044\000\130\000\040\000\048\000\
\094\000\057\000\107\000\041\000\095\000\026\000\111\000\027\000\
\061\000\042\000\066\000\132\000\117\000\070\000\133\000\109\000\
\136\000\052\000\112\000\113\000\114\000\115\000\028\000\104\000\
\033\000\029\000\030\000\053\000\118\000\004\000\031\000\131\000\
\116\000\054\000\084\000\085\000\000\000\040\000\105\000\000\000\
\127\000\092\000\041\000\000\000\007\000\019\000\063\000\134\000\
\042\000\034\000\129\000\040\000\040\000\137\000\106\000\000\000\
\041\000\041\000\013\000\000\000\073\000\097\000\042\000\042\000\
\138\000\098\000\000\000\000\000\040\000\000\000\009\000\108\000\
\014\000\041\000\035\000\064\000\000\000\110\000\120\000\042\000\
\024\000\010\000\022\000\000\000\016\000\040\000\122\000\038\000\
\123\000\000\000\041\000\100\000\040\000\000\000\011\000\101\000\
\042\000\041\000\000\000\000\000\040\000\128\000\040\000\042\000\
\124\000\041\000\000\000\041\000\000\000\039\000\040\000\042\000\
\135\000\042\000\000\000\041\000\000\000\000\000\040\000\139\000\
\036\000\042\000\000\000\041\000\000\000\000\000\000\000\000\000\
\047\000\042\000\000\000\037\000\040\000\048\000\049\000\050\000\
\051\000\041\000\000\000\000\000\047\000\073\000\042\000\042\000\
\040\000\048\000\049\000\050\000\051\000\041\000\000\000\000\000\
\000\000\040\000\000\000\042\000\001\000\002\000\003\000\004\000\
\005\000\000\000\000\000\000\000\000\000\000\000\000\000\012\000\
\000\000\000\000\000\000\024\000\000\000\025\000\000\000\000\000\
\000\000\000\000\000\000\000\000\008\000\000\000\003\000\026\000\
\003\000\026\000\003\000\027\000\000\000\000\000\026\000\026\000\
\000\000\000\000\000\000\000\000\026\000\022\000\026\000\022\000\
\026\000\022\000\028\000\000\000\045\000\029\000\030\000\045\000\
\045\000\000\000\031\000\045\000\045\000\027\000\045\000\026\000\
\045\000\000\000\045\000\026\000\022\000\000\000\045\000\045\000\
\045\000\045\000\045\000\045\000\000\000\000\000\045\000\045\000\
\000\000\045\000\047\000\045\000\000\000\047\000\047\000\007\000\
\045\000\047\000\047\000\000\000\047\000\023\000\047\000\023\000\
\047\000\023\000\009\000\013\000\047\000\047\000\047\000\047\000\
\047\000\047\000\000\000\048\000\047\000\047\000\048\000\048\000\
\014\000\047\000\048\000\048\000\023\000\048\000\047\000\048\000\
\000\000\048\000\000\000\015\000\017\000\048\000\048\000\048\000\
\048\000\048\000\048\000\000\000\033\000\048\000\048\000\000\000\
\016\000\018\000\048\000\033\000\033\000\000\000\033\000\048\000\
\033\000\004\000\045\000\004\000\000\000\004\000\045\000\045\000\
\045\000\045\000\045\000\045\000\000\000\034\000\033\000\033\000\
\000\000\045\000\000\000\033\000\034\000\034\000\000\000\034\000\
\033\000\034\000\000\000\046\000\000\000\000\000\000\000\046\000\
\046\000\046\000\046\000\046\000\046\000\000\000\035\000\034\000\
\034\000\000\000\046\000\000\000\034\000\035\000\035\000\000\000\
\035\000\034\000\035\000\038\000\024\000\010\000\024\000\010\000\
\024\000\010\000\038\000\038\000\000\000\038\000\000\000\038\000\
\035\000\035\000\011\000\000\000\011\000\035\000\011\000\000\000\
\000\000\039\000\035\000\024\000\010\000\038\000\038\000\000\000\
\039\000\039\000\038\000\039\000\036\000\039\000\000\000\038\000\
\000\000\011\000\000\000\036\000\036\000\000\000\036\000\037\000\
\036\000\000\000\000\000\039\000\039\000\000\000\037\000\037\000\
\039\000\037\000\000\000\037\000\000\000\039\000\036\000\036\000\
\000\000\042\000\042\000\036\000\042\000\000\000\042\000\000\000\
\036\000\037\000\037\000\000\000\040\000\040\000\037\000\040\000\
\000\000\040\000\000\000\037\000\042\000\042\000\000\000\000\000\
\000\000\042\000\000\000\012\000\000\000\012\000\042\000\012\000\
\040\000\000\000\000\000\033\000\040\000\026\000\000\000\000\000\
\008\000\040\000\008\000\026\000\008\000\026\000\000\000\026\000\
\000\000\045\000\012\000\000\000\000\000\045\000\045\000\045\000\
\045\000\045\000\045\000\000\000\000\000\033\000\026\000\008\000\
\045\000\034\000\026\000\027\000\000\000\000\000\000\000\000\000\
\000\000\027\000\000\000\027\000\000\000\027\000\000\000\046\000\
\000\000\000\000\000\000\046\000\046\000\046\000\046\000\046\000\
\046\000\000\000\000\000\034\000\027\000\000\000\046\000\000\000\
\027\000\000\000\000\000\007\000\000\000\007\000\000\000\007\000\
\000\000\000\000\000\000\000\000\000\000\000\000\009\000\013\000\
\009\000\013\000\009\000\013\000\000\000\000\000\000\000\000\000\
\000\000\000\000\007\000\000\000\014\000\000\000\014\000\000\000\
\014\000\000\000\000\000\000\000\000\000\009\000\013\000\015\000\
\017\000\015\000\017\000\015\000\017\000\000\000\000\000\000\000\
\000\000\000\000\000\000\014\000\016\000\018\000\016\000\018\000\
\016\000\018\000\000\000\000\000\000\000\000\000\015\000\017\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\016\000\018\000"

let yycheck = "\001\001\
\000\000\003\001\000\000\005\000\002\001\003\001\006\001\004\001\
\009\001\001\001\001\000\003\001\013\001\015\001\009\001\022\001\
\000\000\000\000\009\000\010\000\027\001\009\001\003\000\009\001\
\015\000\027\001\033\001\029\001\004\001\032\001\032\001\031\001\
\000\000\030\001\032\001\027\001\006\001\028\000\004\001\041\001\
\032\001\039\001\003\001\040\001\004\001\011\001\037\000\028\000\
\003\001\040\000\041\000\042\000\043\000\003\001\030\001\031\001\
\047\000\048\000\049\000\050\000\051\000\035\001\000\000\054\000\
\030\001\000\000\009\001\058\000\059\000\071\000\030\001\007\001\
\002\000\064\000\033\001\056\000\057\000\004\001\059\000\003\001\
\013\001\005\001\014\001\012\001\014\000\013\001\022\001\000\000\
\009\001\006\001\007\001\027\001\013\001\017\001\096\000\019\001\
\026\000\033\001\028\000\013\001\102\000\031\000\013\001\094\000\
\016\001\000\000\097\000\098\000\099\000\100\000\034\001\008\001\
\000\000\037\001\038\001\000\000\107\000\000\000\042\001\121\000\
\101\000\000\000\052\000\053\000\255\255\022\001\008\001\255\255\
\119\000\059\000\027\001\255\255\001\001\002\001\003\001\126\000\
\033\001\000\000\119\000\022\001\022\001\132\000\008\001\255\255\
\027\001\027\001\015\001\255\255\031\001\009\001\033\001\033\001\
\133\000\013\001\255\255\255\255\022\001\255\255\027\001\008\001\
\029\001\027\001\000\000\032\001\255\255\095\000\008\001\033\001\
\000\000\000\000\039\001\255\255\041\001\022\001\008\001\000\000\
\008\001\255\255\027\001\009\001\022\001\255\255\000\000\013\001\
\033\001\027\001\255\255\255\255\022\001\119\000\022\001\033\001\
\008\001\027\001\255\255\027\001\255\255\000\000\022\001\033\001\
\130\000\033\001\255\255\027\001\255\255\255\255\022\001\031\001\
\000\000\033\001\255\255\027\001\255\255\255\255\255\255\255\255\
\018\001\033\001\255\255\000\000\022\001\023\001\024\001\025\001\
\026\001\027\001\255\255\255\255\018\001\031\001\000\000\033\001\
\022\001\023\001\024\001\025\001\026\001\027\001\255\255\255\255\
\255\255\000\000\255\255\033\001\001\000\002\000\003\000\004\000\
\005\000\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
\255\255\255\255\255\255\003\001\255\255\005\001\255\255\255\255\
\255\255\255\255\255\255\255\255\000\000\255\255\012\001\000\000\
\014\001\017\001\016\001\019\001\255\255\255\255\006\001\007\001\
\255\255\255\255\255\255\255\255\012\001\012\001\014\001\014\001\
\016\001\016\001\034\001\255\255\004\001\037\001\038\001\007\001\
\008\001\255\255\042\001\011\001\012\001\000\000\014\001\031\001\
\016\001\255\255\018\001\035\001\035\001\255\255\022\001\023\001\
\024\001\025\001\026\001\027\001\255\255\255\255\030\001\031\001\
\255\255\033\001\004\001\035\001\255\255\007\001\008\001\000\000\
\040\001\011\001\012\001\255\255\014\001\012\001\016\001\014\001\
\018\001\016\001\000\000\000\000\022\001\023\001\024\001\025\001\
\026\001\027\001\255\255\004\001\030\001\031\001\007\001\008\001\
\000\000\035\001\011\001\012\001\035\001\014\001\040\001\016\001\
\255\255\018\001\255\255\000\000\000\000\022\001\023\001\024\001\
\025\001\026\001\027\001\255\255\004\001\030\001\031\001\255\255\
\000\000\000\000\035\001\011\001\012\001\255\255\014\001\040\001\
\016\001\012\001\018\001\014\001\255\255\016\001\022\001\023\001\
\024\001\025\001\026\001\027\001\255\255\004\001\030\001\031\001\
\255\255\033\001\255\255\035\001\011\001\012\001\255\255\014\001\
\040\001\016\001\255\255\018\001\255\255\255\255\255\255\022\001\
\023\001\024\001\025\001\026\001\027\001\255\255\004\001\030\001\
\031\001\255\255\033\001\255\255\035\001\011\001\012\001\255\255\
\014\001\040\001\016\001\004\001\012\001\012\001\014\001\014\001\
\016\001\016\001\011\001\012\001\255\255\014\001\255\255\016\001\
\030\001\031\001\012\001\255\255\014\001\035\001\016\001\255\255\
\255\255\004\001\040\001\035\001\035\001\030\001\031\001\255\255\
\011\001\012\001\035\001\014\001\004\001\016\001\255\255\040\001\
\255\255\035\001\255\255\011\001\012\001\255\255\014\001\004\001\
\016\001\255\255\255\255\030\001\031\001\255\255\011\001\012\001\
\035\001\014\001\255\255\016\001\255\255\040\001\030\001\031\001\
\255\255\011\001\012\001\035\001\014\001\255\255\016\001\255\255\
\040\001\030\001\031\001\255\255\011\001\012\001\035\001\014\001\
\255\255\016\001\255\255\040\001\030\001\031\001\255\255\255\255\
\255\255\035\001\255\255\012\001\255\255\014\001\040\001\016\001\
\031\001\255\255\255\255\004\001\035\001\006\001\255\255\255\255\
\012\001\040\001\014\001\012\001\016\001\014\001\255\255\016\001\
\255\255\018\001\035\001\255\255\255\255\022\001\023\001\024\001\
\025\001\026\001\027\001\255\255\255\255\030\001\031\001\035\001\
\033\001\004\001\035\001\006\001\255\255\255\255\255\255\255\255\
\255\255\012\001\255\255\014\001\255\255\016\001\255\255\018\001\
\255\255\255\255\255\255\022\001\023\001\024\001\025\001\026\001\
\027\001\255\255\255\255\030\001\031\001\255\255\033\001\255\255\
\035\001\255\255\255\255\012\001\255\255\014\001\255\255\016\001\
\255\255\255\255\255\255\255\255\255\255\255\255\012\001\012\001\
\014\001\014\001\016\001\016\001\255\255\255\255\255\255\255\255\
\255\255\255\255\035\001\255\255\012\001\255\255\014\001\255\255\
\016\001\255\255\255\255\255\255\255\255\035\001\035\001\012\001\
\012\001\014\001\014\001\016\001\016\001\255\255\255\255\255\255\
\255\255\255\255\255\255\035\001\012\001\012\001\014\001\014\001\
\016\001\016\001\255\255\255\255\255\255\255\255\035\001\035\001\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\035\001\035\001"

let yynames_const = "\
  AND\000\
  BOOL\000\
  CIRCUM\000\
  COMA\000\
  CORDER\000\
  CORIZQ\000\
  DEFINE\000\
  DO\000\
  DONE\000\
  DOSIGUAL\000\
  ELSE\000\
  EOF\000\
  FALSE\000\
  FI\000\
  IF\000\
  IGUAL\000\
  INT\000\
  LLAVEDER\000\
  LLAVEIZQ\000\
  MAS\000\
  MAYOR\000\
  MAYORIGUAL\000\
  MENOR\000\
  MENORIGUAL\000\
  MENOS\000\
  MENOSU\000\
  NOT\000\
  OR\000\
  PARDER\000\
  PARIZQ\000\
  POR\000\
  PRINT\000\
  PUNTOCOMA\000\
  RETURN\000\
  SKIP\000\
  STRING\000\
  SUBSTRING\000\
  THEN\000\
  TRUE\000\
  WHILE\000\
  "

let yynames_block = "\
  ENTERO\000\
  CADENA\000\
  VARIABLE\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    Obj.repr(
# 78 "parser.mly"
                      ( raise ERROR_SINTACTICO )
# 412 "parser.ml"
               : Tipos.program))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tipos.comm) in
    Obj.repr(
# 79 "parser.mly"
                      (_1)
# 419 "parser.ml"
               : Tipos.program))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'comm) in
    Obj.repr(
# 82 "parser.mly"
                              ( _1 )
# 426 "parser.ml"
               : Tipos.comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'comm) in
    Obj.repr(
# 83 "parser.mly"
                              ( _1 )
# 433 "parser.ml"
               : Tipos.comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'comm) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.comm) in
    Obj.repr(
# 84 "parser.mly"
                              ( Seq(_1,_3) )
# 441 "parser.ml"
               : Tipos.comm))
; (fun __caml_parser_env ->
    Obj.repr(
# 87 "parser.mly"
                                                           ( Skip )
# 447 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 88 "parser.mly"
                                                           ( MkVar(_2, VInt(_4)) )
# 455 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 89 "parser.mly"
                                                           ( MkVar(_2, VBool(_4)) )
# 463 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : Tipos.sexp) in
    Obj.repr(
# 90 "parser.mly"
                                                           ( MkVar(_2, VString(_4)) )
# 471 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 91 "parser.mly"
                                                           ( Assign(_1, VInt(_3)) )
# 479 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 92 "parser.mly"
                                                           ( Assign(_1, VBool(_3)) )
# 487 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.sexp) in
    Obj.repr(
# 93 "parser.mly"
                                                           ( Assign(_1, VString(_3)) )
# 495 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 94 "parser.mly"
                                                           ( AssignArray(_1, _3, VInt(_6)) )
# 504 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 95 "parser.mly"
                                                           ( AssignArray(_1, _3, VBool(_6)) )
# 513 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : Tipos.sexp) in
    Obj.repr(
# 96 "parser.mly"
                                                           ( AssignArray(_1, _3, VString(_6)) )
# 522 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 97 "parser.mly"
                                                           ( MkArray(_2,_4, VInt(_7)) )
# 531 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 98 "parser.mly"
                                                           ( MkArray(_2, _4, VBool(_7)) )
# 540 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : Tipos.sexp) in
    Obj.repr(
# 99 "parser.mly"
                                                           ( MkArray(_2, _4, VString(_7)) )
# 549 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : Tipos.bexp) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : Tipos.comm) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : Tipos.comm) in
    Obj.repr(
# 100 "parser.mly"
                                                           ( If(_2, _4, _6) )
# 558 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : Tipos.bexp) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : Tipos.comm) in
    Obj.repr(
# 101 "parser.mly"
                                                           ( While(_2, _4) )
# 566 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'imp_exp) in
    Obj.repr(
# 102 "parser.mly"
                                                           ( Print(_2) )
# 573 "parser.ml"
               : 'comm))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 105 "parser.mly"
                              ( VInt(_1) )
# 580 "parser.ml"
               : 'imp_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 106 "parser.mly"
                              ( VBool(_1) )
# 587 "parser.ml"
               : 'imp_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Tipos.sexp) in
    Obj.repr(
# 107 "parser.mly"
                              ( VString(_1) )
# 594 "parser.ml"
               : 'imp_exp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 110 "parser.mly"
                                                             ( MkString (_1) )
# 601 "parser.ml"
               : Tipos.sexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 111 "parser.mly"
                                                             ( StringVar(_1) )
# 608 "parser.ml"
               : Tipos.sexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Tipos.aexp) in
    Obj.repr(
# 112 "parser.mly"
                                                             ( StringArray(_1, _3) )
# 616 "parser.ml"
               : Tipos.sexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.sexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.sexp) in
    Obj.repr(
# 113 "parser.mly"
                                                             ( Concat(_1, _3) )
# 624 "parser.ml"
               : Tipos.sexp))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 5 : Tipos.sexp) in
    let _5 = (Parsing.peek_val __caml_parser_env 3 : Tipos.aexp) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : Tipos.aexp) in
    Obj.repr(
# 114 "parser.mly"
                                                             ( Substring(_3, _5, _7) )
# 633 "parser.ml"
               : Tipos.sexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Tipos.sexp) in
    Obj.repr(
# 115 "parser.mly"
                                                             ( _2 )
# 640 "parser.ml"
               : Tipos.sexp))
; (fun __caml_parser_env ->
    Obj.repr(
# 118 "parser.mly"
                                    ( MkBool(true) )
# 646 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    Obj.repr(
# 119 "parser.mly"
                                    ( MkBool(false) )
# 652 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 120 "parser.mly"
                                    ( BoolVar(_1) )
# 659 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Tipos.aexp) in
    Obj.repr(
# 121 "parser.mly"
                                    ( BoolArray (_1, _3) )
# 667 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 122 "parser.mly"
                                    ( Equal(_1, _3) )
# 675 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 123 "parser.mly"
                                    ( Lt(_1, _3) )
# 683 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 124 "parser.mly"
                                    ( LtEq(_1, _3) )
# 691 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 125 "parser.mly"
                                    ( Gt(_1, _3) )
# 699 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 126 "parser.mly"
                                    ( GtEq(_1, _3) )
# 707 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 127 "parser.mly"
                                    ( Not(_2) )
# 714 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.bexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 128 "parser.mly"
                                    ( And(_1, _3) )
# 722 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.bexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.bexp) in
    Obj.repr(
# 129 "parser.mly"
                                    ( Or(_1, _3) )
# 730 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Tipos.bexp) in
    Obj.repr(
# 130 "parser.mly"
                                    ( _2 )
# 737 "parser.ml"
               : Tipos.bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 133 "parser.mly"
                                     ( MkInt(_1) )
# 744 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 134 "parser.mly"
                                     ( IntVar(_1) )
# 751 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : Tipos.aexp) in
    Obj.repr(
# 135 "parser.mly"
                                     ( IntArray(_1, _3) )
# 759 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 136 "parser.mly"
                                     ( Sum(_1,_3) )
# 767 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 137 "parser.mly"
                                     ( Res(_1,_3) )
# 775 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Tipos.aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 138 "parser.mly"
                                     ( Mul(_1,_3) )
# 783 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Tipos.aexp) in
    Obj.repr(
# 139 "parser.mly"
                                     ( Res(MkInt(0),_2) )
# 790 "parser.ml"
               : Tipos.aexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : Tipos.aexp) in
    Obj.repr(
# 140 "parser.mly"
                                     ( _2 )
# 797 "parser.ml"
               : Tipos.aexp))
(* Entry aexp *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry bexp *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry sexp *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry comms *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let aexp (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Tipos.aexp)
let bexp (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : Tipos.bexp)
let sexp (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 3 lexfun lexbuf : Tipos.sexp)
let comms (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 4 lexfun lexbuf : Tipos.comm)
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 5 lexfun lexbuf : Tipos.program)
;;
