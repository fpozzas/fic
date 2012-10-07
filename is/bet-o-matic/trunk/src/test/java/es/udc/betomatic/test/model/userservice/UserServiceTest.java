package es.udc.betomatic.test.model.userservice;

import static es.udc.betomatic.model.util.GlobalNames.SPRING_CONFIG_FILE;
import static es.udc.betomatic.test.util.GlobalNames.SPRING_CONFIG_TEST_FILE;

import static org.junit.Assert.*;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;

import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.account.*;
import es.udc.betomatic.model.bet.*;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.betoption.BetOptionDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.userservice.InsufficientBalanceException;
import es.udc.betomatic.model.userservice.UserService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class UserServiceTest {

	private final long NON_EXISTENT_USER_ID = -1;
	
	@Autowired
	private BetDao betDao;
	@Autowired
	private AccountDao accountDao;
	@Autowired
	private BetOptionDao betOptionDao;
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
	public void testCreateBet() throws InstanceNotFoundException, InsufficientBalanceException {
		Account account = accountDao.find(DbUtil.getTestAccountId());
		Calendar firstDec = new GregorianCalendar();
		firstDec.set(2009, 11, 1);
		BetOption betOption = betOptionDao.find(DbUtil.getTestBetOptionId());
		Bet bet = new Bet(new BigDecimal(5), firstDec, account, betOption);
		
		bet = userService.createBet(bet);
		Bet bet2 = betDao.find(bet.getId());
		assertEquals(bet, bet2);
	}

	@Test
	public void testFindBetsByUser() {
		BetBlock betBlock = userService.findBetsByAccount(DbUtil.getTestAccountId(), 0, 5);
		assertFalse(betBlock.getExistMoreBets());
		List<Bet> bets = betBlock.getBets();
		assertEquals(2, bets.size());
		assertEquals(2, bets.get(0).getAmount().doubleValue(), Double.MIN_NORMAL);
		assertEquals(3, bets.get(1).getAmount().doubleValue(), Double.MIN_NORMAL);
	}

	@Test
	public void testGetNumberOfBets() {
		assertEquals(2,
				userService.getNumberOfBets(DbUtil.getTestAccountId()));
	}
	
	@Test
	public void testFindEvents() throws InstanceNotFoundException {

		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		
		EventBlock eventBlock = userService.findEvents(keywords, null, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Antonio's team - Otros", events.get(0).getName());
	}
	
	@Test
	public void testFindEventsCat() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		Long cricket = new Long(1);
		
		EventBlock eventBlock = userService.findEvents(keywords, cricket, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Antonio's team - Otros", events.get(0).getName());
	}
	
	@Test
	public void testGetNumberOfEvents() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		assertEquals(1,
				userService.getNumberOfEvents(keywords, null));
	}

	@Test
	public void testGetNumberOfEventsCat() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		Long cricket = new Long(1);
		assertEquals(1,
				userService.getNumberOfEvents(keywords, cricket));
	}
	
	@Test(expected = InstanceNotFoundException.class)
	public void testUserGetBalance() throws InstanceNotFoundException {
		userService.getBalance(NON_EXISTENT_USER_ID);
	}
	
}
