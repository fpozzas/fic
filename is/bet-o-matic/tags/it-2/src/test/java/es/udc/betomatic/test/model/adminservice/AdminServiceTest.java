package es.udc.betomatic.test.model.adminservice;

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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.account.AccountDao;
import es.udc.betomatic.model.adminservice.AdminService;
import es.udc.betomatic.model.adminservice.AlreadyHasWinnersException;
import es.udc.betomatic.model.adminservice.DifferentBetTypeOptionsException;
import es.udc.betomatic.model.adminservice.InvalidNumberOfWinnersException;
import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetDao;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bettype.BetTypeDao;
import es.udc.betomatic.model.category.Category;
import es.udc.betomatic.model.category.CategoryDao;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.event.EventDao;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class AdminServiceTest {

	@Autowired
	private EventDao eventDao;
	@Autowired
	private CategoryDao categoryDao;
	@Autowired
	private AccountDao accountDao;
	@Autowired
	private BetDao betDao;
	@Autowired
	private BetTypeDao betTypeDao;
	@Autowired
	private CommonService commonService;
	

	@Autowired
	private AdminService adminService;

	@BeforeClass
	public static void populateDb() throws Throwable {
		DbUtil.populateDb();
	}

	@AfterClass
	public static void cleanDb() throws Throwable {
		DbUtil.cleanDb();
	}

	@Test
	public void testCreateAndFindEvent() throws InstanceNotFoundException {
		Category category = categoryDao.find(new Long(1));
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 1);
		Event event = new Event("Partido de prueba", lastDec,category);
		event = adminService.createEvent(event, category.getId());
		
		Event event2 = commonService.findEvent(event.getId());
		assertEquals(event.getName(), event2.getName());
		assertEquals(event.getDate(), event2.getDate());
		assertEquals(event.getCategory(), event2.getCategory());
	}

	@Test
	public void testAddBetTypeToEvent() throws InstanceNotFoundException {
		BetType betType = new BetType("How many points will the winner score?", false);
		adminService.addBetTypeToEvent(DbUtil.getTestEventId(), betType);
		Event event = eventDao.find(DbUtil.getTestEventId());
		assertTrue(event.getBetTypes().contains(betType));
	}





	@Test
	public void testFindEventsAdmin() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Juan Jose");
		
		EventBlock eventBlock = adminService.findEventsAdmin(keywords, null, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Juan Jose - Pedro", events.get(0).getName());
	}

	@Test
	public void testFindEventsAdminCat() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Pedro");
		keywords.add("-");
		Long mus = new Long(3);
		
		EventBlock eventBlock = adminService.findEventsAdmin(keywords, mus, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Juan Jose - Pedro", events.get(0).getName());
	}



	@Test
	public void testGetNumberOfEventsAdmin() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Juan Jose");
		assertEquals(1,
				adminService.getNumberOfEventsAdmin(keywords, null));
	}
	
	@Test
	public void testGetNumberOfEventsAdminCat() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		Long mus = new Long(3);
		assertEquals(1,
				adminService.getNumberOfEventsAdmin(keywords, mus));
	}

	@Test
	public void testEstablishWinners() throws InstanceNotFoundException, DifferentBetTypeOptionsException, AlreadyHasWinnersException, InvalidNumberOfWinnersException {
		Set<Long> betOptions = new TreeSet<Long>();
		betOptions.add(DbUtil.getTestBetOptionId());
		
		adminService.establishWinners(DbUtil.getTestBetTypeId(), betOptions);
		
		Account account = accountDao.find(DbUtil.getTestAccountId());
		BigDecimal expected = new BigDecimal(10 + 2*2.5);
		int resultCompareTo = expected.compareTo(account.getBalance());
		
		assertEquals(0,resultCompareTo);
		
		Bet winnerBet = betDao.find(DbUtil.getTestBetId1());
		Bet loserBet = betDao.find(DbUtil.getTestBetId2());
		
		assertEquals(winnerBet.getBetState(),Bet.BetState.WINNER);
		assertEquals(loserBet.getBetState(),Bet.BetState.LOSER);
	}
	
	@Test
	public void testAddBetOptionsToBetType() throws InstanceNotFoundException{
		Event testEvent = eventDao.find(DbUtil.getTestEventId());
		BetType bt = new BetType("Who will get lost?", false);
		bt.setEvent(testEvent);
		betTypeDao.save(bt);
		BetOption bo1 = new BetOption("Margarito", new BigDecimal("2.5"), false, bt);
		BetOption bo2 = new BetOption("Graciela", new BigDecimal("1.5"), false, bt);
		List<BetOption> expectedBetOptions = new ArrayList<BetOption>();
		expectedBetOptions.add(bo1);
		expectedBetOptions.add(bo2);
		adminService.addBetOptionsToBetType(expectedBetOptions, bt.getId());
		
		List<BetOption> betOptions = bt.getOptions();
		assertEquals(expectedBetOptions.get(0).getName(),betOptions.get(0).getName());
		assertEquals(expectedBetOptions.get(1).getName(),betOptions.get(1).getName());

	}
}
