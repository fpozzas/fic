package dsi_p1_2;

import java.util.ArrayList;

public class Zona extends ZGenerico{
    public String id() {
        String temp=" [ "+this.id+" : ";
        for(ZGenerico z:cacheActivos) 
            temp=temp+", "+z.id();
        temp=temp+"]";
        return temp;
    }
    
    @Override
    public ZGenerico getHijo(int i) {
        return this.hijos.get(i);
    }
    
    @Override
    public void add(ZGenerico hijo) {
        this.hijos.add(hijo);
        hijo.padres.add(this);
        if (hijo.alerta())
            cacheActivos.add(hijo);
    }
    
    @Override
    public boolean alerta() {
        this.alarma=!cacheActivos.isEmpty();
        return this.alarma;
    }
    
    @Override
    public void remove(ZGenerico hijo) {
        this.hijos.remove(hijo);
        hijo.padres.remove(this);
        cacheActivos.remove(this);
    }
    
    public void reiniciar() {
        for(ZGenerico z:this.hijos)
            z.reiniciar();            
    }
    
    public void probar() {
        for(ZGenerico z:this.hijos)
            z.probar();            
    }    
        
    Zona(String id, boolean estado) {
        super(id,estado);
        this.tipo="Zona";
        this.hijos=new ArrayList<ZGenerico>();
        this.cacheActivos=new ArrayList<ZGenerico>();       
    }
    
    
}
