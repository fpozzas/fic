package es.udc.betomatic.model.adminservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetDao;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.betoption.BetOptionDao;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bettype.BetTypeDao;
import es.udc.betomatic.model.category.CategoryDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.event.EventDao;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@Service("adminService")
@Transactional
public class AdminServiceImpl implements AdminService {

    @Autowired
	private BetDao betDao;
    
    @Autowired
    private BetTypeDao betTypeDao;
    
    @Autowired
    private BetOptionDao betOptionDao;
    
    @Autowired
    private CategoryDao categoryDao;
    
    @Autowired
    private EventDao eventDao;
    
	public Event createEvent(Event event, Long categoryId) throws InstanceNotFoundException {
		event.setCategory(categoryDao.find(categoryId));
		eventDao.save(event);
		return event;
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
		List<Bet> betsByType = betDao.findByBetType(btypeId);
		for (Long bopId : betopIds){
			/*
			 *  Update betOption
			 */
			BetOption bop = betOptionDao.find(bopId);
			if (bop.getBetType()!=bt) throw new DifferentBetTypeOptionsException(bt.getId(),bop.getBetType().getId());
			bop.setWinner(true);
			for (Bet b : betsByType){
				if (b.getOption().getId()==bopId){
					/*
					 *  Update winner's balance
					 */
					Account acc = b.getAccount();
					// balance = balance + amount * quota
					acc.setBalance(acc.getBalance().add(b.getAmount().multiply(bop.getQuota())));
					b.setBetState(Bet.BetState.WINNER);
				}
				else { 
					if (b.getBetState()!=Bet.BetState.WINNER)
						b.setBetState(Bet.BetState.LOSER);
				}
			}
		}
		bt.setWinner(true);
	}



	@Override
	public void addBetOptionsToBetType(List<BetOption> betOptions,
			Long betTypeId) throws InstanceNotFoundException {
		BetType betType = betTypeDao.find(betTypeId);
		betType.addOptions(betOptions);
		for (BetOption opt : betOptions){
			betOptionDao.save(opt);
		}
	}
	
	public void addBetTypeToEvent(Long eventId, BetType betType)
	throws InstanceNotFoundException {
		Event event = eventDao.find(eventId);
		event.addBetType(betType);
		betTypeDao.save(betType);
	}

	@Transactional(readOnly = true)
	public EventBlock findEventsAdmin(List<String> substrings, Long catId,
									   int startIndex, int count) {
		List<Event> events;
		if(catId==null){
			events = eventDao.findEventsAdmin(substrings, startIndex, count+1);
		}else{
			events = eventDao.findEventsAdmin(substrings,catId,startIndex, count+1);
		}
		boolean existMoreEvents = events.size() == (count+1);
		if (existMoreEvents){
			events.remove(count);
		}
		return new EventBlock(events,existMoreEvents);
	}
	
	@Transactional(readOnly = true)
	public int getNumberOfEventsAdmin(List<String> substrings, Long catId) {
		if(catId==null){
			return eventDao.getNumberOfEventsAdmin(substrings);
		}else{
			return eventDao.getNumberOfEventsAdmin(substrings, catId);
		}
	}
	

}
