package es.udc.betomatic.model.event;

import java.util.Calendar;
import java.util.List;

import es.udc.pojo.modelutil.dao.GenericDao;

public interface EventDao
	extends GenericDao<Event, Long> {
	
	public List<Event> findEvents(List<String> substrings,
								  Calendar startDate, int startIndex, int count );
	public List<Event> findEvents(List<String> substrings, long catId,
								  Calendar startDate, int startIndex, int count );
	public List<Event> findEventsAdmin(List<String> substrings,
									   int startIndex, int count );
	public List<Event> findEventsAdmin(List<String> substrings, long catId,
									   int startIndex, int count );
	public int getNumberOfEvents(List<String> substrings, Calendar startDate);
	public int getNumberOfEvents(List<String> substrings, long catId, Calendar startDate);
	public int getNumberOfEventsAdmin(List<String> substrings);
	public int getNumberOfEventsAdmin(List<String> substrings, long catId);

}
