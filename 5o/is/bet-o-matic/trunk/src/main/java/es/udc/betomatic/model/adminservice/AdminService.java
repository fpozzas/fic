package es.udc.betomatic.model.adminservice;

import java.util.List;
import java.util.Set;

import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

public interface AdminService {
	public Event createEvent(Event event, Long categoryId) throws InstanceNotFoundException;

	public void establishWinners(Long btypeId, Set<Long> betopIds)
		throws DifferentBetTypeOptionsException, InstanceNotFoundException,
		AlreadyHasWinnersException, InvalidNumberOfWinnersException;

	public void addBetOptionsToBetType(List<BetOption> betOptions, Long betTypeId) throws InstanceNotFoundException;
	
	public void addBetTypeToEvent(Long eventId, BetType betType)
		throws InstanceNotFoundException;
	
	public EventBlock findEventsAdmin(List<String> substrings, Long catId,
			int startIndex, int count );
	
	public int getNumberOfEventsAdmin(List<String> substrings, Long catId);

}
