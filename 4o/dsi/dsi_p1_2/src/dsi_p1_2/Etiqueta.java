package dsi_p1_2;
import java.util.ArrayList;
public class Etiqueta {
    private String nombre;
    private String valor;
    private static ArrayList<Etiqueta> lista = new ArrayList<Etiqueta>();
    public String getNombre(){
        return this.nombre;
    }
    public String getValor(){
        return this.valor;
    }
    public boolean equals(Etiqueta e){
        return this.nombre.equals(e.nombre) && this.valor.equals(e.valor);
    }

    Etiqueta(String nombre, String valor){
        this.nombre = nombre;
        this.valor = valor;
        if (!lista.contains(this))
            lista.add(this);
    }
}
            
