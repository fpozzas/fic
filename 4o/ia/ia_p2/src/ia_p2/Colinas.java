package ia_p2;
import java.util.ArrayList;
import java.util.Random;

public class Colinas {
    public int nop = 6;
    public int ntests = 0;
    public int iteraciones = -1;
    public Nodo I;
    public Nodo O;
    public Nodo F = null;
    public ArrayList<Nodo> camino = new ArrayList<Nodo>();
    public Nodo N;
    public int hN;
    public Heuristica fh;
    public ArrayList<Nodo> descendientes = new ArrayList<Nodo>();
    public void generardesc(){
        int i;
        Nodo n;
        for (i=1;i<=nop;i++){
            if (N.evalOp(i)){
                n= N.op(i);
                n.h = fh.calc(n,O);
                descendientes.add(N.op(i));
            }
        }
    }
    public int paso(){
        int i;
        camino.add(N);
        ntests++;
        if (N.equals(O)) {
            // Calculo de la ramificacion efectiva para una profundidad
            // obtenida a partir de A*
            //System.out.println("Ramificacion = "+BranchingFactor.compute(ntests,Main.depth));
            return 1;
        }
        Random rnd = new Random();
        descendientes.clear();
        generardesc();
        int aleat = (int)(rnd.nextDouble() * 1000.0);
        for (i=1;i<=nop;i++){
            int op = ((aleat+i)%nop)+1;
            if (N.evalOp(op)){
                Nodo s = N.op(op);
                int hs;
                if ((hs=(fh.calc(s, O)))<hN){
                    N = s;
                    hN = hs;
                    s.h = hs;
                    return 0;
                }
            }
        }
        // Para evitar que ascensión de colinas se quede
        // colgado por culpa de mesetas
        for (i=1;i<=nop;i++){
            int op = ((aleat+i)%nop)+1;
            if (N.evalOp(op)){
                Nodo s = N.op(op);
                int hs;
                if ((hs=(fh.calc(s, O)))<=hN){
                    N = s;
                    hN = hs;
                    s.h =hs;
                    return 0;
                }
            }
        }
        return -1;
    }

    public Colinas(Nodo I, Nodo O, Heuristica h){
        this.I = I;
        this.O = O;
        this.N = I;
        this.fh = h;
        this.hN = h.calc(I, O);
        this.N.h = hN;
    }
}
