package dsi_p1_2;

import java.util.ArrayList;

public abstract class ZGenerico {
    protected boolean alarma;
    protected String id;
    protected String tipo;
    protected ArrayList<Etiqueta> etiquetas = new ArrayList<Etiqueta>();
    protected ArrayList<ZGenerico> hijos;
    protected ArrayList<ZGenerico> cacheActivos;
    protected ArrayList<ZGenerico> padres = new ArrayList<ZGenerico>();
    
    public String toString() {
        return this.id();
    }
    
    public boolean alerta() {
        return alarma;        
    } 
    
    public abstract String id();
    
    public String tipo() {
        return tipo;
    }
    
    public abstract void reiniciar();
    
    public abstract void probar();
    
    public void agregarEtiqueta(Etiqueta e){
        if (!etiquetas.contains(e))
            etiquetas.add(e);
    }
    
    public void add(ZGenerico z) {}
    
    public void remove(ZGenerico z) {}
    
    public ZGenerico getHijo(int i) {return null;}
       
    protected void notificaPadres() {
        if (this.alarma) 
            for(ZGenerico z:padres) {
                z.cacheActivos.add(this);
                if (!z.alarma) {
                    z.alarma=true;
                    z.notificaPadres();
                }
            }
        else 
            for(ZGenerico z:padres) {
                z.cacheActivos.remove(this);    
                if (z.cacheActivos.isEmpty()) 
                    if (z.alarma) {
                        z.alarma=false;
                        z.notificaPadres();
                    }
            }
    }
    
    public ArrayList<Etiqueta> getEtiquetas(){
        return etiquetas;
    }
    
    ZGenerico(String id, boolean estado){
        this.id = id;
        this.alarma = estado;
    }
      
}


