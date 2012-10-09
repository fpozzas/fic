package dsi_p1_1;
import java.util.Collection;
import java.util.ArrayList;
public class Centralita {
    private String nombre;
    private String clave;
    private boolean autenticado = false;
    private ArrayList<Alarma> alarmas = new ArrayList<Alarma>();
    
    public String getNombre(){
        return nombre;
    }
    public void agregarAlarma(Alarma a){
        if (autenticado==false) return;
        if (!alarmas.contains(a))
            alarmas.add(a);
    }
    public void eliminarAlarma(Alarma a){
        if (autenticado==false) return;
        alarmas.remove(a);
    }
    public void probar(){
        if (autenticado==false) return;
        for(Alarma a : alarmas) a.probar();
    }
    public void reiniciar(){
        if (autenticado==false) return;
        for(Alarma a: alarmas) a.reiniciar();
    }
    public boolean autenticar(String clave){
        return autenticado=clave.equals(this.clave);
    }
    public Collection<Alarma> buscar(Especificacion e){
        if (autenticado==false) return null;
        ArrayList<Alarma> al = new ArrayList<Alarma>();
        for(Alarma a : alarmas)
            if (e.cumple(a))
                al.add(a);
        return al;
    }
    Centralita(String nombre, String clave){
        this.nombre = nombre;
        this.clave = clave;
    }
}


