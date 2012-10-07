package es.udc.betomatic.model.eventservice;

import java.util.Calendar;
import java.util.List;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.event.Event;

public interface EventService {

	public Event createEvent(Event event);
	public void addBetTypeToEvent(Long eventId, BetType betType)
			throws InstanceNotFoundException;
	public EventBlock findEvents(List<String> substrings,
			Calendar startDate, int startIndex, int count )
			throws InstanceNotFoundException;
	public EventBlock findEvents(List<String> substrings, long catId,
			Calendar startDate, int startIndex, int count )
			throws InstanceNotFoundException;
	public EventBlock findEventsAdmin(List<String> substrings,
			int startIndex, int count )
			throws InstanceNotFoundException;
	public EventBlock findEventsAdmin(List<String> substrings, long catId,
			int startIndex, int count )
			throws InstanceNotFoundException;
	public int getNumberOfEvents(List<String> substrings, Calendar startDate)
			throws InstanceNotFoundException;
	public int getNumberOfEvents(List<String> substrings, long catId, Calendar startDate)
			throws InstanceNotFoundException;
	public int getNumberOfEventsAdmin(List<String> substrings)
			throws InstanceNotFoundException;
	public int getNumberOfEventsAdmin(List<String> substrings, long catId)
			throws InstanceNotFoundException;

}
