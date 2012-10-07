package es.udc.betomatic.test.model.userservice;

import static es.udc.betomatic.model.util.GlobalNames.SPRING_CONFIG_FILE;
import static es.udc.betomatic.test.util.GlobalNames.SPRING_CONFIG_TEST_FILE;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;


import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.DuplicateInstanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDao;
import es.udc.betomatic.model.userservice.IncorrectPasswordException;
import es.udc.betomatic.model.userservice.UserService;
import es.udc.betomatic.model.util.PasswordEncrypter;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class UserServiceTest {

	private final long NON_EXISTENT_USER_ID = -1;
	
	@Autowired
	private UserDao userDao;

	@Autowired
	private UserService userService;

	@BeforeClass
	public static void populateDb() throws Throwable {
		DbUtil.populateDb();
	}

	@AfterClass
	public static void cleanDb() throws Throwable {
		DbUtil.cleanDb();
	}

	@Test
	public void testUserAuthentication() throws InstanceNotFoundException, IncorrectPasswordException {
		User user2 = userDao.find(DbUtil.getTestUserId());
		boolean passwdIsEncrypted = true;
		User user = userService.authenticate(user2.getLogin(),user2.getPasswd(),passwdIsEncrypted);

		assertEquals(user, user2);
	}
	
	@Test
	public void testCreateAuthenticate() 
			throws DuplicateInstanceException,InstanceNotFoundException, IncorrectPasswordException {
		String login = "infdfn01";
		String clearPasswd = "rqe3wf2zs";
		User user = userService.registerUser(login, "Perico", "Pardo", "ppardo@lol.com", clearPasswd);
		
		boolean passwdIsEncrypted = false;
		User user2 = userService.authenticate(login, clearPasswd, passwdIsEncrypted);
		assertEquals(user,user2);
	}

	@Test(expected = InstanceNotFoundException.class)
	public void testUserGetBalance() throws InstanceNotFoundException {
		userService.getBalance(NON_EXISTENT_USER_ID);
	}
	
	@Test
	public void testChangeUserDetails() throws InstanceNotFoundException{
		User user = userDao.find(DbUtil.getTestUserId());
		String newName = "Petete";
		userService.updateUserDetails(user.getId(), newName, user.getLastName(), user.getEmail());
		
		User userMod = userDao.find(DbUtil.getTestUserId());
		assertEquals(newName,userMod.getName());
	}
	
	@Test
	public void testChanguePassword()
			throws InstanceNotFoundException, IncorrectPasswordException, DuplicateInstanceException{
		String login = "pepa";
		String clearPasswd = "rqe3wf2zs";
		User user = userService.registerUser("pepa", "Perico", "Pardo", "ppardo@lol.com", clearPasswd);
		
		String newPasswd = "ccccc";
		userService.changePassword(user.getId(), clearPasswd, newPasswd);
		
		boolean passwdIsEncrypted = false;
		User userMod = userService.authenticate(login, newPasswd, passwdIsEncrypted);
		assertEquals(user,userMod);
		assertTrue(PasswordEncrypter.isClearPasswordCorrect(newPasswd,userMod.getPasswd()));
	}
}
