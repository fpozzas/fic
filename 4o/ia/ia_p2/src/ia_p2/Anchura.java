package ia_p2;
import java.util.ArrayList;

public class Anchura {
    public int nop = 6;
    public int ntests = 0;
    public int iteraciones = -1;
    public Nodo I;
    public Nodo O;
    public Nodo F = null;
    public ArrayList<Nodo> abiertos = new ArrayList<Nodo>();
    public ArrayList<Nodo> cerrados = new ArrayList<Nodo>();

    public int init(){
        iteraciones = 0;
        abiertos.add(I);
        ntests++;
        if (I.equals(O))
            return 1;
        else return -1;
    }

    public int paso(){
        iteraciones++;
        ntests++;
        if (abiertos.isEmpty()) return -1;
        Nodo n = abiertos.remove(0);
        cerrados.add(n);
        // Expandir n
        boolean usado;
        for (int i=1; i<=nop;i++){
            usado = false;
            if (n.evalOp(i)){
                Nodo s = n.op(i);
                for (Nodo nc : cerrados){
                    if (nc.equals(s)){
                        usado = true;
                        break;
                    }
                }
                if (!usado)
                    for (Nodo na : abiertos){
                        if (na.equals(s)){
                            usado = true;
                            break;
                        }
                    }
                if (!usado){
                    abiertos.add(s);
                    ntests++;
                    if (s.equals(O)){
                        this.F = s;
                        // Calculo de la ramificacion efectiva para una profundidad
                        // obtenida a partir de A*
                        //System.out.println("Ramificacion = "+BranchingFactor.compute(ntests,Main.depth));
                        return 1;
                    }
                }
            }
        }
        return 0;
    }

    public
    Anchura(Nodo I, Nodo O){
        this.I = I;
        this.O = O;
    }
}
