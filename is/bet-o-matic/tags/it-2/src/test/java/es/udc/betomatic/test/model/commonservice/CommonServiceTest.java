package es.udc.betomatic.test.model.commonservice;

import static es.udc.betomatic.model.util.GlobalNames.SPRING_CONFIG_FILE;
import static es.udc.betomatic.test.util.GlobalNames.SPRING_CONFIG_TEST_FILE;

import java.util.List;

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

import es.udc.betomatic.model.category.Category;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.commonservice.IncorrectPasswordException;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDao;
import es.udc.betomatic.model.user.UserDetails;
import es.udc.betomatic.model.util.PasswordEncrypter;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class CommonServiceTest {
	
	@Autowired
	private UserDao userDao;
	
	@Autowired
	private CommonService commonService;

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
		User user = commonService.authenticate(user2.getLogin(),user2.getPasswd(),passwdIsEncrypted);

		assertEquals(user, user2);
	}
	
	@Test
	public void testCreateAuthenticate() 
			throws DuplicateInstanceException,InstanceNotFoundException, IncorrectPasswordException {
		String login = "infdfn01";
		String clearPasswd = "rqe3wf2zs";
		User user = commonService.registerUser(login, "Perico", "Pardo", "ppardo@lol.com", clearPasswd);
		
		boolean passwdIsEncrypted = false;
		User user2 = commonService.authenticate(login, clearPasswd, passwdIsEncrypted);
		assertEquals(user,user2);
	}
	
	@Test
	public void testChangeUserDetails() throws InstanceNotFoundException{
		User user = userDao.find(DbUtil.getTestUserId());
		String newName = "Petete";
		commonService.updateUserDetails(user.getId(), newName, user.getLastName(), user.getEmail());
		
		User userMod = userDao.find(DbUtil.getTestUserId());
		assertEquals(newName,userMod.getName());
	}
	
	@Test
	public void testChanguePassword()
			throws InstanceNotFoundException, IncorrectPasswordException, DuplicateInstanceException{
		String login = "pepa";
		String clearPasswd = "rqe3wf2zs";
		User user = commonService.registerUser("pepa", "Perico", "Pardo", "ppardo@lol.com", clearPasswd);
		
		String newPasswd = "ccccc";
		commonService.changePassword(user.getId(), clearPasswd, newPasswd);
		
		boolean passwdIsEncrypted = false;
		User userMod = commonService.authenticate(login, newPasswd, passwdIsEncrypted);
		assertEquals(user,userMod);
		assertTrue(PasswordEncrypter.isClearPasswordCorrect(newPasswd,userMod.getPasswd()));
	}
	
	@Test
	public void testGetUserDetails() throws InstanceNotFoundException{
		User user = userDao.find(DbUtil.getTestUserId());
		UserDetails userDetails = commonService.getUserDetails(DbUtil.getTestUserId());
		
		assertEquals(user.getName(), userDetails.getName());
		assertEquals(user.getLastName(), userDetails.getLastName());
		assertEquals(user.getEmail(), userDetails.getEmail());
	}
	
	@Test
	public void testGetAllCategories(){
		List<Category> result = commonService.getAllCategories();
		assertEquals(4, result.size());
		assertEquals("Cricket", result.get(0).getName());
		assertEquals("Petanca", result.get(1).getName());
		assertEquals("Mus", result.get(2).getName());
	}
	
	@Test
	public void testAdminUserId() throws DuplicateInstanceException, InstanceNotFoundException{
		String login = "admin";
		String clearPasswd = "rqe3wf2zs";
		User admin = commonService.registerUser(login, "Perico", "Pardo", "admin@lol.com", clearPasswd);
		assertEquals(admin.getId(),commonService.getAdminUserId());
	}
}
