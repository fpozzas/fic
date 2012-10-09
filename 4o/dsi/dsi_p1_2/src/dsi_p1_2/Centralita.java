package dsi_p1_2;
import java.util.Collection;
import java.util.ArrayList;
public class Centralita {
    private String nombre;
    private String clave;
    private boolean autenticado = false;
    private ArrayList<ZGenerico> alarmas = new ArrayList<ZGenerico>();
    
    public String getNombre(){
        return nombre;
    }
    public void agregarAlarma(ZGenerico a){
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
        for(ZGenerico a : alarmas) a.probar();
    }
    public void reiniciar(){
        if (autenticado==false) return;
        for(ZGenerico a: alarmas) a.reiniciar();
    }
    public boolean autenticar(String clave){
        return autenticado=clave.equals(this.clave);
    }
    public Collection<ZGenerico> buscar(Especificacion e){
        if (autenticado==false) return null;
        ArrayList<ZGenerico> al = new ArrayList<ZGenerico>();
        for(ZGenerico a : alarmas)
            if (e.cumple(a)) al.add(a);
        return al;
    }
    Centralita(String nombre, String clave){
        this.nombre = nombre;
        this.clave = clave;
    }
}


