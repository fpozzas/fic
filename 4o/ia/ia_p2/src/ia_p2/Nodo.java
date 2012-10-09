package ia_p2;

public class Nodo{

    private short[] nodo = new short[3];
    private short posUltima = -1;
    private Nodo padre= null;
    public int g;
    public int h=-1;
    public int f=-1;

    @Override
    public String toString(){
        if (h==-1)
            return "("+Integer.toString(nodo[2]) + Integer.toString(nodo[1]) + Integer.toString(nodo[0])+")";
        else if (f==-1)
            return "("+Integer.toString(nodo[2])+Integer.toString(nodo[1]) + Integer.toString(nodo[0])+"," +h+")";
        else return "("+Integer.toString(nodo[2])+Integer.toString(nodo[1]) + Integer.toString(nodo[0]) +","+g+","+h+")";
    }

    public boolean equals(Nodo n1){
        return (this.nodo[0]==n1.nodo[0]) &&
               (this.nodo[1]==n1.nodo[1]) &&
               (this.nodo[2]==n1.nodo[2]);
    }
    private boolean evalInc(int pos){
        if (pos==this.posUltima) return false;
        this.nodo[pos]++;
        if (this.nodo[pos]>9) {
            this.nodo[pos]--;
            return false;
        }
        for (Nodo t : Interfaz.tabu){
            if (this.equals(t)){
                this.nodo[pos]--;
                return false;
            }
        }
        this.nodo[pos]--;
        return true;
    }

     private boolean evalDec(int pos){
        if (pos==this.posUltima) return false;
        this.nodo[pos]--;
        if (this.nodo[pos]<0) {
            this.nodo[pos]++;
            return false;
        }
        for (Nodo t : Interfaz.tabu){
            if (this.equals(t)){
                this.nodo[pos]++;
                return false;
            }
        }
        this.nodo[pos]++;
        return true;
    }

    private Nodo inc(int pos){
        Nodo n = new Nodo(this);
        n.nodo[pos]++;
        n.posUltima = (short) pos;
        return n;
    }
    private Nodo dec(int pos){
        Nodo n = new Nodo(this);
        n.nodo[pos]--;
        n.posUltima = (short) pos;
        return n;
    }

    public int get(int pos){
        return this.nodo[pos];
    }

    public Nodo getPadre(){
        return this.padre;
    }

    public boolean evalOp(int op){
        switch(op){
            case 1: return this.evalInc(0);
            case 2: return this.evalDec(0);
            case 3: return this.evalInc(1);
            case 4: return this.evalDec(1);
            case 5: return this.evalInc(2);
            case 6: return this.evalDec(2);
            default: return false;
        }
    }
    public Nodo op(int op){
        switch(op){
            case 1: return this.inc(0);
            case 2: return this.dec(0);
            case 3: return this.inc(1);
            case 4: return this.dec(1);
            case 5: return this.inc(2);
            case 6: return this.dec(2);
            default: return this;
        }
    }
    Nodo(int n2, int n1, int n0){
        nodo[0] = (short) n0;
        nodo[1] = (short) n1;
        nodo[2] = (short) n2;
    }

    Nodo(int n){
        nodo[0] = (short) (n%10);
        nodo[1] = (short) (n%100/10);
        nodo[2] = (short) (n/100);
    }
    Nodo(Nodo n){
        nodo[0] = n.nodo[0];
        nodo[1] = n.nodo[1];
        nodo[2] = n.nodo[2];
        padre = n;
    }
}