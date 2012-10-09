package dsi_p1_1;
public class AlMov extends Alarma{
    private int pmtp;
    public int getPmtp(){
        return this.pmtp;
    }
    AlMov(String id, boolean estado,int pmtp){
        super(id,estado);
        this.pmtp = pmtp;
        this.tipo = "AlMov";
    }    
    
    public String id() {
        return  " ("+this.id+" pmtp="+ pmtp +") ";
    }
}