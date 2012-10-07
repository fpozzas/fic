package es.udc.betomatic.model.bet;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.hibernate.HibernateException;

import es.udc.pojo.modelutil.dao.GenericDaoHibernate;

@Repository("betDao")
public class BetDaoHibernate
	extends GenericDaoHibernate<Bet, Long>
	implements BetDao {
	@SuppressWarnings("unchecked")
    public List<Bet> findByAccount(long accId, int startIndex, int count){
	    try {
            return getSession().createQuery(
                    "SELECT o FROM Bet o WHERE " +
                    "o.account.id = :accId " +
                    "ORDER BY o.date DESC").
                    setParameter("accId", accId).
                    setFirstResult(startIndex).
                    setMaxResults(count).
                    list();

	    } catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }

	}

	public int getNumberOfBets(long accId) {

	    try {

    		long numberOfBets = (Long) getSession().createQuery(
                    "SELECT COUNT(o) FROM Bet o WHERE " +
                    "o.account.id = :accId").
                    setParameter("accId", accId).
                    uniqueResult();

    		return (int) numberOfBets;

    	} catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }

	}
    public void removeByAccountId(long accId) {

        try {

            getSession().createQuery("DELETE FROM Bet o WHERE " +
                "o.account.id = :accId").
                setParameter("accId", accId).executeUpdate();

        } catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }
    }
    
    @SuppressWarnings("unchecked")
	public List<Bet> findByBetOption(Long bopId){
	    try {
            return getSession().createQuery(
                    "SELECT o FROM Bet o WHERE " +
                    "o.option.id = :bopId").
                    setParameter("bopId", bopId).
                    list();
	    } catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }

	}
    
    @SuppressWarnings("unchecked")
	public List<Bet> findByBetType(Long btypeId){
	    try {
            return getSession().createQuery(
                    "SELECT o " +
                    "FROM Bet o " +
                    "WHERE :btypeId = " +
                    "(SELECT c.betType.id FROM BetOption c WHERE c.id=o.option.id)").
                    setParameter("btypeId", btypeId).
                    list();
	    } catch (HibernateException e) {
            throw convertHibernateAccessException(e);
        }

	}
}
