package es.udc.betomatic.model.userservice;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.account.AccountDao;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDao;
import es.udc.betomatic.model.util.PasswordEncrypter;
import es.udc.pojo.modelutil.exceptions.DuplicateInstanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@Service("userService")
@Transactional
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDao userDao;
	@Autowired
	private AccountDao accountDao;
	
	@Transactional(readOnly = true)
	public User authenticate(String login, String passwd, boolean passwordIsEncrypted)
			throws InstanceNotFoundException, IncorrectPasswordException {
		User user = userDao.findByLogin(login);
		String storedPassword = user.getPasswd();
		if (passwordIsEncrypted) {
			if (!passwd.equals(storedPassword)) {
				throw new IncorrectPasswordException(login);
			}
		} else {
			if (!PasswordEncrypter.isClearPasswordCorrect(passwd,
					storedPassword)) {
				throw new IncorrectPasswordException(login);
			}
		}
		return user;
	}

	@Transactional(readOnly = true)
	public BigDecimal getBalance(Long userId)
			throws InstanceNotFoundException {
		User user = userDao.find(userId);
		return user.getAccount().getBalance();
	}
	
	public User registerUser(String login, String name, String lastName,
				String email, String clearPassword)
				throws DuplicateInstanceException {
		try{
			userDao.findByLogin(login);
			throw new DuplicateInstanceException(login, User.class.getName());
		}catch(InstanceNotFoundException e){
			// Encrypt password
			String encryptedPassword = PasswordEncrypter.crypt(clearPassword);
			User user = new User(login,name,lastName,email,encryptedPassword);
			//Create user
			userDao.save(user);
			//Create its account
			Account account = new Account(new BigDecimal(0), user);
			accountDao.save(account);
			//Add account to user
			user.setAccount(account);
			userDao.save(user);
			return user;		
		}
	}
	public void updateUserDetails(Long userId,
			String name, String lastName, String email)
			throws InstanceNotFoundException {
		User user = userDao.find(userId);
		user.setName(name);
		user.setLastName(lastName);
		user.setEmail(email);
	}

	public void changePassword(Long userId, String oldClearPassword,
			String newClearPassword) throws IncorrectPasswordException,
			InstanceNotFoundException {
		User user = userDao.find(userId);
		String storedPassword = user.getPasswd();
		if (!PasswordEncrypter.isClearPasswordCorrect(oldClearPassword,
				storedPassword)) {
			throw new IncorrectPasswordException(user.getLogin());
		}
		user.setPasswd(PasswordEncrypter.crypt(newClearPassword));
	}
	

}
