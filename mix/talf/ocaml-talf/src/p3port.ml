let escaner_mt2 cadena (Mt (_, _, _, inicial, Conjunto delta, _, finales)) =
	if (pertenece inicial finales)
	then [([],inicial,cadena)]
   else

   let
      cinta = if cadena = [] then [No_terminal ""] else cadena
   in
      let rec aux lista = function
           ([], [], _) -> lista

         | (sigcfs, [], _) -> aux lista ([], sigcfs, delta)

         | (sigcfs, _::cfs, []) -> aux lista (sigcfs, cfs, delta)

         | (sigcfs, (((i::c1, e, s::c2)::_) as cfs),
                    (Arco_mt (e1, e2, s1, s2, Izquierda))::arcos)
                    when e = e1 & s = s1 ->
              let
                 nc1 = if c1 = [] then [No_terminal ""] else c1 in
              if (pertenece e2 finales) 
              then aux ((nc1,e2,i::s2::c2)::lista) ((nc1, e2, i::s2::c2)::sigcfs, cfs, arcos)
              else aux lista ((nc1, e2, i::s2::c2)::sigcfs, cfs, arcos)

         | (sigcfs, (((c1, e, s::c2)::_) as cfs),
                    (Arco_mt (e1, e2, s1, s2, Derecha))::arcos)
                    when e = e1 & s = s1 ->
              let
                 nc2 = if c2 = [] then [No_terminal ""] else c2 in
              if (pertenece e2 finales)
              then aux ((s2::c1,e2,nc2)::lista) ((s2::c1, e2, nc2)::sigcfs, cfs, arcos)
              else aux lista ((s2::c1, e2, nc2)::sigcfs, cfs, arcos)

         | (sigcfs, cfs, _::arcos) -> aux lista (sigcfs, cfs, arcos)

      in
         aux [] ([], [([No_terminal ""], inicial, cinta)], delta) 
      ;; 
