package es.udc.betomatic.model.eventservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.Calendar;
import java.util.List;

import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventDao;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bettype.BetTypeDao;

@Service("eventService")
@Transactional
public class EventServiceImpl implements EventService {

    @Autowired
	private EventDao eventDao;

    @Autowired
	private BetTypeDao betTypeDao;

    
	public Event createEvent(Event event) {
		eventDao.save(event);
		return event;
	}

	@Transactional(readOnly = true)
	public EventBlock findEvents(List<String> substrings,
								  Calendar startDate, int startIndex, int count) {
		List<Event> events = eventDao.findEvents(substrings, startDate, startIndex, count+1);
		boolean existMoreEvents = events.size() == (count+1);
		if (existMoreEvents){
			events.remove(count);
		}
		return new EventBlock(events,existMoreEvents);
	}
	
	@Transactional(readOnly = true)
	public EventBlock findEvents(List<String> substrings, long catId,
								  Calendar startDate, int startIndex, int count) {
		List<Event> events = eventDao.findEvents(substrings,catId,startDate, startIndex, count+1);
		boolean existMoreEvents = events.size() == (count+1);
		if (existMoreEvents){
			events.remove(count);
		}
		return new EventBlock(events,existMoreEvents);
	}

	@Transactional(readOnly = true)
	public EventBlock findEventsAdmin(List<String> substrings,
									   int startIndex, int count) {
		List<Event> events = eventDao.findEventsAdmin(substrings, startIndex, count+1);
		boolean existMoreEvents = events.size() == (count+1);
		if (existMoreEvents){
			events.remove(count);
		}
		return new EventBlock(events,existMoreEvents);
	}

	@Transactional(readOnly = true)
	public EventBlock findEventsAdmin(List<String> substrings, long catId,
									   int startIndex, int count) {
		List<Event> events = eventDao.findEventsAdmin(substrings, catId, startIndex, count+1);
		boolean existMoreEvents = events.size() == (count+1);
		if (existMoreEvents){
			events.remove(count);
		}
		return new EventBlock(events,existMoreEvents);
	}

	@Transactional(readOnly = true)
	public int getNumberOfEvents(List<String> substrings, Calendar startDate) {
		return eventDao.getNumberOfEvents(substrings, startDate);
	}

	@Transactional(readOnly = true)
	public int getNumberOfEvents(List<String> substrings, long catId, Calendar startDate) {
		return eventDao.getNumberOfEvents(substrings, catId, startDate);
	}

	@Transactional(readOnly = true)
	public int getNumberOfEventsAdmin(List<String> substrings) {
		return eventDao.getNumberOfEventsAdmin(substrings);
	}

	@Transactional(readOnly = true)
	public int getNumberOfEventsAdmin(List<String> substrings, long catId) {
		return eventDao.getNumberOfEventsAdmin(substrings,catId);
	}
	
	public void addBetTypeToEvent(Long eventId, BetType betType)
			throws InstanceNotFoundException {
		Event event = eventDao.find(eventId);
		event.addBetType(betType);
		betTypeDao.save(betType);
	}
}
