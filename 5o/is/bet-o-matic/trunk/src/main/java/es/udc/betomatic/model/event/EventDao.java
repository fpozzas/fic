package es.udc.betomatic.model.event;

import java.util.List;

import es.udc.pojo.modelutil.dao.GenericDao;

public interface EventDao
	extends GenericDao<Event, Long> {
	
	public List<Event> findEvents(List<String> substrings,
								  int startIndex, int count );
	public List<Event> findEvents(List<String> substrings, long catId,
								  int startIndex, int count );
	public List<Event> findEventsAdmin(List<String> substrings,
									   int startIndex, int count );
	public List<Event> findEventsAdmin(List<String> substrings, long catId,
									   int startIndex, int count );
	public int getNumberOfEvents(List<String> substrings);
	public int getNumberOfEvents(List<String> substrings, long catId);
	public int getNumberOfEventsAdmin(List<String> substrings);
	public int getNumberOfEventsAdmin(List<String> substrings, long catId);

}
