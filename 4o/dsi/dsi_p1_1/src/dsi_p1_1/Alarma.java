package dsi_p1_1;
import java.util.ArrayList;

public abstract class Alarma {
    private boolean alarma;
    protected String id;
    protected String tipo;
    private ArrayList<Etiqueta> etiquetas = new ArrayList<Etiqueta>();
    
    public ArrayList<Etiqueta> getEtiquetas(){
        return etiquetas;
    }
    public boolean alerta(){
        return this.alarma;
    }
    public String id(){
        return this.id;
    }
    public String tipo(){
        return this.id;
    }
    public void reiniciar(){
        this.alarma = false;
    }
    public String toString() {
        return this.id();
    }
    public void probar(){
        this.alarma = true;
    }
    public void agregarEtiqueta(Etiqueta e){
        if (!etiquetas.contains(e))
            etiquetas.add(e);
    }
    Alarma(String id, boolean estado){
        this.id = id;
        this.alarma = estado;
    }
}
