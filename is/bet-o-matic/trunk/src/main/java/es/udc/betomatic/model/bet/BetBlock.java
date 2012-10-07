package es.udc.betomatic.model.bet;

import java.util.List;

public class BetBlock {

	private List<Bet> bets;
	private boolean existMoreBets;
	
	public BetBlock(List<Bet> bets, boolean existMoreBets){
		
		this.bets = bets;
		this.existMoreBets = existMoreBets;
		
	}

	public List<Bet> getBets() {
		return bets;
	}

	public boolean getExistMoreBets() {
		return existMoreBets;
	}
	
	
}
