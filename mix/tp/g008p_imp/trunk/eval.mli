
val aexp : Env.env -> Tipos.program -> Tipos.aexp -> int
val bexp : Env.env -> Tipos.program -> Tipos.bexp -> bool
val sexp : Env.env -> Tipos.program -> Tipos.sexp -> string
val comm : Env.env -> Tipos.program -> Tipos.comm -> Env.env
val program : Env.env -> Tipos.program -> Env.env
