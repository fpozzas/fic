package dsi_p1_2;
import java.util.ArrayList;

public abstract class Alarma extends ZGenerico{
    
    public ArrayList<Etiqueta> getEtiquetas(){
        return etiquetas;
    }
    public boolean alerta(){
        return this.alarma;
    }
    public String id(){
        return  " ("+this.id+") ";
    }
    public String tipo(){
        return this.tipo;
    }
    public void reiniciar(){
        if (this.alarma) {
            this.alarma = false;
            this.notificaPadres();
        }
    }
    
    public void probar(){
        if (!this.alarma) {
            this.alarma = true;
            this.notificaPadres();
        }
    }

    Alarma(String id, boolean estado){
        super(id,estado);
    }
}
