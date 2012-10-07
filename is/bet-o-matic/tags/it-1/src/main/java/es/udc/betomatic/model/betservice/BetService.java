package es.udc.betomatic.model.betservice;

import java.util.Calendar;
import java.util.Set;

import es.udc.betomatic.model.bet.Bet;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

public interface BetService {

	public Bet createBet(Bet bet)
		throws InsufficientBalanceException;
	
    public BetBlock findBetsByDate(Long accId,Calendar startDate, Calendar endDate,
    	int startIndex, int count);

	public int getNumberOfBets(Long accId, Calendar startDate,
			Calendar endDate);
	public void establishWinners(Long btypeId, Set<Long> betopIds)
		throws DifferentBetTypeOptionsException, InstanceNotFoundException,
		AlreadyHasWinnersException, InvalidNumberOfWinnersException;
		
}
