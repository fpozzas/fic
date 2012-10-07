package es.udc.betomatic.model.adminservice;

@SuppressWarnings("serial")
public class InvalidNumberOfWinnersException extends Exception {
	
	private long bettypeId;
	
	public InvalidNumberOfWinnersException(long bettypeId){
		super("Invalid Number Of Winners Exception => " + bettypeId);
		this.bettypeId = bettypeId;
	}
	
	public long getBettypeId(){
		return bettypeId;
	}
	
}
