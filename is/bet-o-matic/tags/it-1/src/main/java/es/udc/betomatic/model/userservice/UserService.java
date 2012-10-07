package es.udc.betomatic.model.userservice;

import java.math.BigDecimal;

import es.udc.betomatic.model.user.User;
import es.udc.pojo.modelutil.exceptions.DuplicateInstanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

public interface UserService {
		
	public User registerUser(String login, String name, String lastName,
			String email, String clearPassword)
			throws DuplicateInstanceException;
	
	public User authenticate(String login, String passwd, boolean passwordIsEncrypted)
		throws InstanceNotFoundException, IncorrectPasswordException;
	
	public BigDecimal getBalance (Long userId)
		throws InstanceNotFoundException;
	
	public void updateUserDetails(Long userId,
			String name, String lastName, String email)
			throws InstanceNotFoundException;
	public void changePassword(Long userId, String oldClearPassword,
			String newClearPassword) throws IncorrectPasswordException,
			InstanceNotFoundException;
}
