package es.udc.betomatic.model.commonservice;

import java.util.List;

import es.udc.pojo.modelutil.exceptions.DuplicateInstanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.category.Category;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDetails;

public interface CommonService {
    
	public User registerUser(String login, String name, String lastName,
			String email, String clearPassword)
			throws DuplicateInstanceException;
	
	public User authenticate(String login, String passwd, boolean passwordIsEncrypted)
			throws InstanceNotFoundException, IncorrectPasswordException;

	public void updateUserDetails(Long userId,
			String name, String lastName, String email)
			throws InstanceNotFoundException;
	
	public UserDetails getUserDetails(Long userId) throws InstanceNotFoundException;
	
	public void changePassword(Long userId, String oldClearPassword,
			String newClearPassword) throws IncorrectPasswordException,
			InstanceNotFoundException;

	public User findUser(Long userId) throws InstanceNotFoundException;

	public Event findEvent(Long eventId)
			throws InstanceNotFoundException;

	public List<Category> getAllCategories();
	
	public String getAllCategoriesToString();
	
	public BetOption findBetOption(Long betOptionId) throws InstanceNotFoundException;
	
	public long getAdminUserId() throws InstanceNotFoundException;


}
