package dsi_p1_1;

public class EspecEstado extends Especificacion{
    private boolean estado;
    public boolean cumple(Alarma a){
        return a.alerta()==this.estado;
    }
    public boolean getEstado(){
        return estado;
    }
    EspecEstado(boolean estado){
        this.estado = estado;
    }
}
