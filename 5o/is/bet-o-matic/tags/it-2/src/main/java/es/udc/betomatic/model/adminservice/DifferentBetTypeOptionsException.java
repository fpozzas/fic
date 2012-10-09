package es.udc.betomatic.model.adminservice;

@SuppressWarnings("serial")
public class DifferentBetTypeOptionsException extends Exception {
	
	private long expectedBettypeId;
	private long gotBettypeId;

	public DifferentBetTypeOptionsException(long expectedBettypeId, long gotBettypeId) {
		super("DifferentBetTypeOptionsException: expected=" + expectedBettypeId + " got=" + gotBettypeId );
		this.expectedBettypeId = expectedBettypeId;
		this.gotBettypeId = gotBettypeId;
	}

	public long getExpectedBettypeId() {
		return expectedBettypeId;
	}

	public long getGotBettypeId() {
		return gotBettypeId;
	}


}
