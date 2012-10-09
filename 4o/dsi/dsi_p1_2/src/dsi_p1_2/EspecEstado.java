package dsi_p1_2;

public class EspecEstado extends Especificacion{
    private boolean estado;
    public boolean cumple(ZGenerico a){
        return a.alerta()==this.estado;
    }
    public boolean getEstado(){
        return estado;
    }
    EspecEstado(boolean estado){
        this.estado = estado;
    }
}
