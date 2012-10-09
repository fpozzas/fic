package es.udc.betomatic.model.bettype;

import es.udc.pojo.modelutil.dao.GenericDao;

public interface BetTypeDao
	extends GenericDao<BetType, Long> {

	public void removeByEventId(Long eventId);

}
