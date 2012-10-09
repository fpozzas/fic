package es.udc.betomatic.model.userservice;

import java.math.BigDecimal;
import java.util.List;

import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetBlock;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

public interface UserService {

	public Bet createBet(Bet bet)
		throws InsufficientBalanceException;
	
    public BetBlock findBetsByAccount(Long accId, int startIndex, int count);

	public int getNumberOfBets(Long accId);
	
	public BigDecimal getBalance (Long userId)
		throws InstanceNotFoundException;
		
	public EventBlock findEvents(List<String> substrings, Long catId,
			int startIndex, int count );

	public int getNumberOfEvents(List<String> substrings, Long catId);
}
