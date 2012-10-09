package dsi_p1_1;
public class AlTemp extends Alarma{
    private int tme;
    public int getTme(){
        return this.tme;
    }
    AlTemp(String id, boolean estado,int tme){
        super(id,estado);
        this.tme = tme;
        this.tipo = "AlTemp";
    }    
    
    public String id() {
        return  " ("+this.id+" tme="+ tme +") ";
    }
}