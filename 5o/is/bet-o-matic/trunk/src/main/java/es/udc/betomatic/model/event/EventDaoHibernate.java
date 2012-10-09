package es.udc.betomatic.model.event;

import java.util.GregorianCalendar;
import java.util.List;

import org.hibernate.HibernateException;
import org.springframework.stereotype.Repository;

import es.udc.pojo.modelutil.dao.GenericDaoHibernate;

@Repository("eventDao")
public class EventDaoHibernate
	extends GenericDaoHibernate<Event, Long>
	implements EventDao {

	private String getSubstringsQuery(List<String> substrings){
		String str = "";
		if ((substrings!=null) && (substrings.size()>0)) {
			for (int i=0; i<substrings.size(); i++){
				str = str + "LOCATE(UPPER('"+substrings.get(i).replaceAll("'","''")+"'),UPPER(o.name))<>0 AND ";
			}
		}
		return str;
	}
	@SuppressWarnings("unchecked")
	public List<Event> findEvents(List<String> substrings, int startIndex,
			int count ){
		try{
			String str = getSubstringsQuery(substrings);
            return getSession().createQuery(
                    "SELECT o FROM Event o WHERE " +
                    str +
                    "o.date >= :startDate ORDER BY o.date").
                    setCalendar("startDate", new GregorianCalendar()).
                    setFirstResult(startIndex).
                    setMaxResults(count).
                    list();
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

	@SuppressWarnings("unchecked")
	public List<Event> findEvents(List<String> substrings, long catId, int startIndex,
			int count ){
		try{
			String str = getSubstringsQuery(substrings);
            return getSession().createQuery(
                    "SELECT o FROM Event o WHERE " +
                    "o.category.id = :catId AND " +
                    str +
                    " o.date >= :startDate ORDER BY o.date").
                    setParameter("catId", catId).
                    setCalendar("startDate", new GregorianCalendar()).
                    setFirstResult(startIndex).
                    setMaxResults(count).
                    list();
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

	@SuppressWarnings("unchecked")
	public List<Event> findEventsAdmin(List<String> substrings,
			int startIndex, int count) {
		try{
			String str = getSubstringsQuery(substrings);
            return getSession().createQuery(
                    "SELECT DISTINCT o " +
                    "FROM Event o LEFT JOIN o.betTypes b "+
                    "WHERE " + str +
                    "(b.winner=0 OR o.betTypes IS EMPTY) "+
                    "ORDER BY o.date, o.name").
                    setFirstResult(startIndex).
                    setMaxResults(count).
                    list();
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}
	@SuppressWarnings("unchecked")
	public List<Event> findEventsAdmin(List<String> substrings, long catId,
			int startIndex, int count) {
		try{
			String str = getSubstringsQuery(substrings);
            return getSession().createQuery(
                    "SELECT DISTINCT o " +
                    "FROM Event o LEFT JOIN o.betTypes b "+
                    "WHERE o.category.id=:catId AND "+
                    str +
                    "(b.winner=0 OR o.betTypes IS EMPTY) "+
                    "ORDER BY o.date").
                    setParameter("catId", catId).
                    setFirstResult(startIndex).
                    setMaxResults(count).
                    list();
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

	public int getNumberOfEvents(List<String> substrings) {
		try{
			String str = getSubstringsQuery(substrings);
			long numberOfEvents = (Long)  getSession().createQuery(
                    "SELECT COUNT(o) FROM Event o WHERE " +
                    str +
                    " o.date >= :startDate ORDER BY o.date").
                    setCalendar("startDate", new GregorianCalendar()).
                    uniqueResult();
    		return (int) numberOfEvents;
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

	public int getNumberOfEvents(List<String> substrings, long catId) {
		try{
			String str = getSubstringsQuery(substrings);
			long numberOfEvents = (Long)  getSession().createQuery(
                    "SELECT COUNT(o) FROM Event o WHERE " +
                    "o.category.id = :catId AND " +
                    str +
                    " o.date >= :startDate ORDER BY o.date").
                    setParameter("catId", catId).
                    setCalendar("startDate", new GregorianCalendar()).
                    uniqueResult();
    		return (int) numberOfEvents;
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

	public int getNumberOfEventsAdmin(List<String> substrings) {
		try{
			String str = getSubstringsQuery(substrings);
			long numberOfEvents = (Long)  getSession().createQuery(
	                   "SELECT COUNT (DISTINCT o) " +
	                    "FROM Event o LEFT JOIN o.betTypes b "+
	                    "WHERE "+ str + "(b.winner=0 OR o.betTypes IS EMPTY) "+
	                    "ORDER BY o.date").
                    uniqueResult();
    		return (int) numberOfEvents;
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

	public int getNumberOfEventsAdmin(List<String> substrings, long catId){
		try{
			String str = getSubstringsQuery(substrings);
			long numberOfEvents = (Long)  getSession().createQuery(
                    "SELECT COUNT (DISTINCT o) " +
                    "FROM Event o LEFT JOIN o.betTypes b "+
                    "WHERE o.category.id=:catId AND "+
                    str +
                    "(b.winner=0 OR o.betTypes IS EMPTY) "+
                    "ORDER BY o.date").
                    setParameter("catId", catId).
                    uniqueResult();
    		return (int) numberOfEvents;
		} catch (HibernateException e) {
	        throw convertHibernateAccessException(e);
	    }
	}

}
