package es.udc.betomatic.model.betservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.List;
import java.util.Set;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetDao;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.betoption.BetOptionDao;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bettype.BetTypeDao;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@Service("betService")
@Transactional
public class BetServiceImpl implements BetService {

    @Autowired
	private BetDao betDao;
    
    @Autowired
    private BetTypeDao betTypeDao;
    
    @Autowired
    private BetOptionDao betOptionDao;

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
		/* Save bet, betOption and account */
		betDao.save(bet);
		return bet;
	}

	public void establishWinners(Long btypeId, Set<Long> betopIds)
			throws DifferentBetTypeOptionsException, InstanceNotFoundException, 
			AlreadyHasWinnersException, InvalidNumberOfWinnersException {
		/*
		 *  Find betType
		 */
		BetType bt = betTypeDao.find(btypeId);
		/*
		 *  Integrity checks
		 */
		if (bt.getWinner()==true) throw new AlreadyHasWinnersException(bt.getId());
		if ((betopIds.size()==0) || ((betopIds.size()>1) && !(bt.getMultipleWinner())))
			throw new InvalidNumberOfWinnersException(bt.getId());
		/*
		 * Updates
		 */
		for (Long bopId : betopIds){
			/*
			 *  Update betOption
			 */
			BetOption bop = betOptionDao.find(bopId);
			if (bop.getBetType()!=bt) throw new DifferentBetTypeOptionsException(bt.getId(),bop.getBetType().getId());
			bop.setWinner(true);
			/*
			 *  Update winner's balance
			 */
			List<Bet> bets = betDao.findByBetOption(bopId);
			for (Bet b : bets){
				Account acc = b.getAccount();
				// balance = balance + amount * quota
				acc.setBalance(acc.getBalance().add(b.getAmount().multiply(bop.getQuota())));
			}
		}
		bt.setWinner(true);
	}

	@Transactional(readOnly = true)
	public BetBlock findBetsByDate(Long accId, Calendar startDate,
			Calendar endDate, int startIndex, int count) {
		/*
		 * Find count+1 accounts to determine if there exist more accounts above
		 * the specified range.
		 */
		List<Bet> bets = betDao.findByDate(accId, startDate, endDate, startIndex, count + 1);
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
	public int getNumberOfBets(Long accId, Calendar startDate, Calendar endDate) {
		return betDao.getNumberOfBets(accId, startDate, endDate);
	}

}
