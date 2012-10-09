package ia_p2;

public class Heuristica {
    private int codh;
    private int incorrectos(Nodo a, Nodo f){
        int h=0;
        if (a.get(0)!=f.get(0)) h++;
        if (a.get(1)!=f.get(1)) h++;
        if (a.get(2)!=f.get(2)) h++;
        return h;
    }
    @Override
    public String toString(){
        switch(codh){
            case 0: return "Dígitos incorrectos";
            case 1: return "Distancias";
            default: return "";
        }
    }

    private int distancias(Nodo a, Nodo f){
        int h=0;
        h += Math.abs(a.get(0)-f.get(0));
        h += Math.abs(a.get(1)-f.get(1));
        h += Math.abs(a.get(2)-f.get(2));
        return h;
    }
    private int sobreestima(Nodo a, Nodo f){
        return distancias(a,f)+incorrectos(a,f);
    }
    public int calc(Nodo a, Nodo f){
        switch(codh){
            case 0: return incorrectos(a,f);
            case 1: return distancias(a,f);
            case 2: return sobreestima(a,f);
            default: return -1;
        }
    }
    public Heuristica(String s){
        if (s.equals("i")) this.codh = 0;
        else if (s.equals("d")) this.codh = 1;
        else if (s.equals("s")) this.codh = 2;
    }
}
