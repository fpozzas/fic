package es.udc.betomatic.model.commonservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Iterator;
import java.util.List;

import es.udc.pojo.modelutil.exceptions.DuplicateInstanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventDao;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDao;
import es.udc.betomatic.model.user.UserDetails;
import es.udc.betomatic.model.util.PasswordEncrypter;
import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.account.AccountDao;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.betoption.BetOptionDao;
import es.udc.betomatic.model.category.Category;
import es.udc.betomatic.model.category.CategoryDao;

@Service("commonService")
@Transactional
public class CommonServiceImpl implements CommonService {

	private static int START_BALANCE = 666;
	
    @Autowired
	private EventDao eventDao;

    @Autowired
    private CategoryDao categoryDao;
    
    @Autowired
    private UserDao userDao;
    
    @Autowired
    private AccountDao accountDao;
    
    @Autowired
    private BetOptionDao betOptionDao;

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
		Account account = new Account(new BigDecimal(START_BALANCE), user);
		accountDao.save(account);
		//Add account to user
		user.setAccount(account);
		userDao.save(user);
		return user;		
	}
	}

	
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

	@Override
	public UserDetails getUserDetails(Long userId) throws InstanceNotFoundException {
		User user = userDao.find(userId);
		return new UserDetails(user.getName(), user.getLastName(), user.getEmail());
	}
	
	public Event findEvent(Long eventId) 
			throws InstanceNotFoundException{
		return eventDao.find(eventId);
	}

	@Override
	public User findUser(Long userId)
		throws InstanceNotFoundException {
		return userDao.find( userId );
	}
	
	@Override
	public List<Category> getAllCategories() {
		return categoryDao.allCategories();
	}

	@Override
	public String getAllCategoriesToString() {
		StringBuffer buf = new StringBuffer();
		Iterator<Category> iterator = getAllCategories().iterator();
		while(iterator.hasNext()){
			Category category = iterator.next();
			buf.append(category.getId()+"="+category.getName()+",");
		}
		return buf.substring(0, buf.length()-2);
	}
	
	public BetOption findBetOption(Long betOptionId)
			throws InstanceNotFoundException{
		return betOptionDao.find(betOptionId);
	}

	@Override
	public long getAdminUserId() throws InstanceNotFoundException {
		return userDao.findByLogin("admin").getId();
	}
	
}
