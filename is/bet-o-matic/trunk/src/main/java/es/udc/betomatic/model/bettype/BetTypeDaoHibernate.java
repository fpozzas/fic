package es.udc.betomatic.model.bettype;

import org.hibernate.HibernateException;
import org.springframework.stereotype.Repository;
import es.udc.pojo.modelutil.dao.GenericDaoHibernate;

@Repository("betTypeDao")
public class BetTypeDaoHibernate
	extends GenericDaoHibernate<BetType, Long>
	implements BetTypeDao {

	public void removeByEventId(Long eventId) {

		try {

            getSession().createQuery("DELETE FROM BetType o WHERE " +
									 "o.event.eventId = :eventId").
                setParameter("eventId", eventId).executeUpdate();

        } catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }

	}

}
