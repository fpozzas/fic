package es.udc.betomatic.model.user;

import es.udc.betomatic.model.user.User;
import es.udc.pojo.modelutil.dao.GenericDao;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

public interface UserDao
	extends GenericDao<User, Long> {
		
	public User findByLogin(String login) throws InstanceNotFoundException;
}