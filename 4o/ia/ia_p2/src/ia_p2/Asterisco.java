package ia_p2;
import java.util.Vector;
import java.util.ArrayList;
import java.util.HashMap;
public class Asterisco {
    private Nodo I;
    private Nodo O;
    public Nodo F;
    private Heuristica fh;
    public int ntests=0;
    private int nop = 6;
    public ArrayList<Nodo> abiertos = new ArrayList<Nodo>();
    public ArrayList<Nodo> cerrados = new ArrayList<Nodo>();
    public ArrayList<Nodo> descendientes = new ArrayList<Nodo>();
    public ArrayList<Nodo> camino = new ArrayList<Nodo>();
    public Nodo mn;

    public int mejorf(ArrayList<Nodo> al){
        int i;
        int index=-1;
        int value=Integer.MAX_VALUE;
        for (i=0; i<al.size();i++){
            if (al.get(i).f<value) {
                value = al.get(i).f;
                index=i;
            }
        }
        return index;
    }
    public boolean estaen(Nodo s, ArrayList<Nodo> al){
        for (Nodo n : al){
            if (n.equals(s)) return true;
        }
        return false;
    }
    public int coste(Nodo s1, Nodo s2){
        int h=0;
        h += Math.abs(s1.get(0)-s2.get(0));
        h += Math.abs(s1.get(1)-s2.get(1));
        h += Math.abs(s1.get(2)-s2.get(2));
        return h;
    }
    public void generacamino(Nodo nodo){
        Nodo n = nodo;
        ArrayList<Nodo> al = new ArrayList<Nodo>();
        camino.clear();
        while(n!=null){
            al.add(n);
            n = n.getPadre();
        }
        while (!al.isEmpty())
           camino.add(al.remove(al.size()-1));
    }
    public int paso(){
        if (!abiertos.isEmpty()){
            int indexmn = mejorf(abiertos);
            mn = abiertos.get(indexmn);
            ntests++;
            if (mn.equals(O)){
                F = mn;
                generacamino(mn);
                // Calculo de la ramificacion efectiva para una profundidad
                // obtenida a partir de A*
                //System.out.println("Ramificacion = "+BranchingFactor.compute(ntests,Main.depth));
                return 1;
            }
            cerrados.add(abiertos.remove(indexmn));
            int i;
            generacamino(mn);
            descendientes.clear();
            for (i=1;i<=nop;i++){
                if (mn.evalOp(i)){
                    Nodo s = mn.op(i);
                    int newg;
                    boolean mejor;
                    if (estaen(s,cerrados)) continue;
                    newg = mn.g + coste(mn,s);
                    mejor = false;
                    if (!estaen(s,abiertos)){
                        abiertos.add(s);
                        s.h=(fh.calc(s,O));
                        mejor = true;
                    }
                    else if (newg<s.g){
                        mejor = true;
                    }
                    if (mejor){
                        s.g = newg;
                        s.f = s.g + s.h;
                    }
                    descendientes.add(s);
                }
            }
            return 0;
        }
        return -1;
    }
    public Asterisco(Nodo I, Nodo O, Heuristica h){
        this.I = I;
        this.O = O;
        this.fh = h;
        abiertos.add(I);
        I.g=0;
        I.h=(fh.calc(I,O));
        I.f=0;
    }
}
