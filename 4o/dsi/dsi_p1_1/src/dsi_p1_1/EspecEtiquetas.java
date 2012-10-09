package dsi_p1_1;
import java.util.ArrayList;

public class EspecEtiquetas extends Especificacion {
    private ArrayList<Etiqueta> etiquetas;
    public boolean cumple(Alarma a){
        boolean flag;
        for(Etiqueta espec : this.etiquetas){
            flag = false;
            for(Etiqueta ealarma : a.getEtiquetas())
                if (espec.equals(ealarma)) flag = true;
            if (flag==false) return false;
        }
        return true;
    }
    public ArrayList<Etiqueta> getEtiquetas(){
        return etiquetas;
    }
    EspecEtiquetas(ArrayList<Etiqueta> etiquetas){
        this.etiquetas = new ArrayList<Etiqueta>(etiquetas);
    }
}
