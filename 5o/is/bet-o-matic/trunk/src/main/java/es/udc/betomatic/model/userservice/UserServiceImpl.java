package es.udc.betomatic.model.userservice;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetBlock;
import es.udc.betomatic.model.bet.BetDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.event.EventDao;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDao;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@Service("userService")
@Transactional
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDao userDao;
	
	@Autowired
	private BetDao betDao;
	
	@Autowired
	private EventDao eventDao;
	
	
	public Bet createBet(Bet bet) throws InsufficientBalanceException {
		/* Find account */
		Account account = bet.getAccount();
		/* Check balance */
		BigDecimal currentBalance = account.getBalance();
		BigDecimal amount = bet.getAmount();
		if(currentBalance.compareTo(bet.getAmount()) < 0){
			throw new InsufficientBalanceException(
					account.getId(), currentBalance.doubleValue(), amount.doubleValue());
		}
		/* Update balance */
		account.setBalance(currentBalance.subtract(amount));
		/* Set state */
		bet.setBetState(Bet.BetState.PENDING);
		/* Save bet, betOption and account */
		betDao.save(bet);
		return bet;
	}
	
	@Transactional(readOnly = true)
	public int getNumberOfBets(Long accId) {
		return betDao.getNumberOfBets(accId);
	}
	
	@Transactional(readOnly = true)
	public BetBlock findBetsByAccount(Long accId, int startIndex, int count) {
		/*
		 * Find count+1 accounts to determine if there exist more accounts above
		 * the specified range.
		 */
		List<Bet> bets = betDao.findByAccount(accId, startIndex, count + 1);
		boolean existMoreBets = bets.size() == (count + 1);
		/*
		 * Remove the last account from the returned list if there exist more
		 * accounts above the specified range.
		 */
		if (existMoreBets){
			bets.remove(count);
		}
		
		return new BetBlock(bets, existMoreBets);
	}	


	@Transactional(readOnly = true)
	public BigDecimal getBalance(Long userId)
			throws InstanceNotFoundException {
		User user = userDao.find(userId);
		return user.getAccount().getBalance();
	}
	






	@Transactional(readOnly = true)
	public EventBlock findEvents(List<String> substrings, Long catId,
								  int startIndex, int count) {
		List<Event> events;
		if(catId==null){
			events = eventDao.findEvents(substrings, startIndex, count+1);
		}else{
			events = eventDao.findEvents(substrings,catId,startIndex, count+1);
		}
		boolean existMoreEvents = events.size() == (count+1);
		if (existMoreEvents){
			events.remove(count);
		}
		return new EventBlock(events,existMoreEvents);
	}



	@Transactional(readOnly = true)
	public int getNumberOfEvents(List<String> substrings, Long catId) {
		if(catId==null){
			return eventDao.getNumberOfEvents(substrings);
		}else{
			return eventDao.getNumberOfEvents(substrings, catId);
		}
	}
	
}
