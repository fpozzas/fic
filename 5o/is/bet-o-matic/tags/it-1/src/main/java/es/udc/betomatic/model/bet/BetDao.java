package es.udc.betomatic.model.bet;

import java.util.Calendar;
import java.util.List;

import es.udc.pojo.modelutil.dao.GenericDao;

public interface BetDao
	extends GenericDao<Bet, Long> {

	public int getNumberOfBets(long accId, Calendar startDate,
			Calendar endDate);

    public List<Bet> findByDate(long accId,
    		Calendar startDate, Calendar endDate, int startIndex, int count);
    
    public List<Bet> findByBetOption(Long bopId);

    public void removeByAccountId(long accId);
}
