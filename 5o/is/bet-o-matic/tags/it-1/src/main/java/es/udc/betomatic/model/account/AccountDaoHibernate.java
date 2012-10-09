package es.udc.betomatic.model.account;

import org.springframework.stereotype.Repository;
import es.udc.pojo.modelutil.dao.GenericDaoHibernate;

@Repository("accountDao")
public class AccountDaoHibernate
	extends GenericDaoHibernate<Account, Long>
	implements AccountDao {


}
