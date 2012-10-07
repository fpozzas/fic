package es.udc.betomatic.model.bet;

import java.util.List;
import es.udc.pojo.modelutil.dao.GenericDao;

public interface BetDao
	extends GenericDao<Bet, Long> {

	public int getNumberOfBets(long accId);

    public List<Bet> findByAccount(long accId,
    		int startIndex, int count);
    
    public List<Bet> findByBetOption(Long bopId);
	public List<Bet> findByBetType(Long btypeId);
    public void removeByAccountId(long accId);
}
