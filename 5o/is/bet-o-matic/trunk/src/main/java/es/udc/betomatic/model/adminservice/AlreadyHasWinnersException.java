package es.udc.betomatic.model.adminservice;

@SuppressWarnings("serial")
public class AlreadyHasWinnersException extends Exception {
	private long bettypeId;
	
	public AlreadyHasWinnersException(long bettypeId) {
		super("Already Has Winners Exception => " + bettypeId);
		this.bettypeId = bettypeId;
	}
	
	public long getBettypeId(){
		return bettypeId;
	}
	
	
}
