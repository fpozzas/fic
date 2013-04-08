(**Fichero principal del intérprete de IMP*)
open Tipos

(**Imprime por pantalla una cadena
@param s String a mostrar por pantalla*)
let print s = print_string s;
              print_newline ()

(**Muestra por pantalla la manera de llamar al intérprete*)
let usage () =
  print "Uso:";
  print "\timp <fichero>";
  ()

(**Inicia el programa pasándole el archivo que queremos interpretar
@param name La ruta del archivo*)
let program name = 
  let final_env = Eval.comm Env.empty (Lector.fichero name) in
    Env.print final_env

(**Comprueba que se le hayan pasado el número correcto de argumentos al intérprete.
Si es así llama a programa con el primer argumento. Si no, llama a usage*)
let _ = if (Array.length (Sys.argv) = 2) then
          program(Sys.argv.(1))
        else
          usage ()
