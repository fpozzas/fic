package es.udc.betomatic.test.model.userservice;

import static es.udc.betomatic.model.util.GlobalNames.SPRING_CONFIG_FILE;
import static es.udc.betomatic.test.util.GlobalNames.SPRING_CONFIG_TEST_FILE;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bettype.BetTypeDao;
import es.udc.betomatic.model.category.CategoryDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.event.EventDao;
import es.udc.betomatic.model.userservice.UserService;
import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class ExhaustiveTest {

	@Autowired
	private EventDao eventDao;
	@Autowired
	private BetTypeDao betTypeDao;
	@Autowired
	private CategoryDao categoryDao;

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
	public void testNoResults() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 1);
		List<String> keywords = new LinkedList<String>();
		keywords.add("ManoleteKiller");
		
		EventBlock eventBlock = userService.findEvents(keywords, null, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(0, events.size());
	}
	
	@Test
	public void testMixedKeywords() throws InstanceNotFoundException {
		Calendar cal = new GregorianCalendar();
		cal.set(2020, 1, 1);
		Event event = new Event("Socorritos - Donha Virtudes", cal, categoryDao.find(new Long(2)));
		eventDao.save(event);
		
		List<String> keywords1 = new LinkedList<String>();
		keywords1.add("socorritos");
		keywords1.add("virtudes");
		List<String> keywords2 = new LinkedList<String>();
		keywords2.add("virtudes");
		keywords2.add("socorritos");
		
		EventBlock eventBlock1 = userService.findEvents(keywords1, null, 0, 10);
		EventBlock eventBlock2 = userService.findEvents(keywords2, null, 0, 10);
		List<Event> events1 = eventBlock1.getEvents();
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(1, events1.size());
		assertEquals(1, events2.size());
		assertEquals(events2.get(0), events1.get(0));
		assertEquals(events2.get(0), event);

	}

	@Test
	public void testIncompleteKeywords() throws InstanceNotFoundException {
		Calendar cal = new GregorianCalendar();
		cal.set(2020, 1, 1);
		Event event = new Event("Socorritos - Donha Virtudes", cal, categoryDao.find(new Long(2)));
		eventDao.save(event);
		
		List<String> keywords1 = new LinkedList<String>();
		keywords1.add("socorri");
		keywords1.add("virtu");

		EventBlock eventBlock1 = userService.findEvents(keywords1, null, 0, 10);
		List<Event> events1 = eventBlock1.getEvents();
		assertEquals(1, events1.size());
		assertEquals(events1.get(0), event);
	}
	
	@Test
	public void testNoKeywords() throws InstanceNotFoundException{
		// Empty list
		EventBlock eventBlock1 = userService.findEvents(new LinkedList<String>(),null,0,10);
		List<Event> events1 = eventBlock1.getEvents();
		assertEquals(2,events1.size());
		
		// Null list
		EventBlock eventBlock2 = userService.findEvents(null,null,0,10);
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(2,events2.size());
	}
	
	@Test
	public void testNoKeywordsButCategory() throws InstanceNotFoundException{
		Calendar cal = new GregorianCalendar();
		cal.set(2020, 1, 1);
		Long petancaId = new Long(2);
		Event event = new Event("Socorritos - Donha Virtudes", cal, categoryDao.find(petancaId));
		eventDao.save(event);
		
		// Empty list
		EventBlock eventBlock1 = userService.findEvents(new LinkedList<String>(),petancaId,0,10);
		List<Event> events1 = eventBlock1.getEvents();
		assertEquals(1,events1.size());
		
		// Null list
		EventBlock eventBlock2 = userService.findEvents(null,petancaId,0,10);
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(1,events2.size());
	}
	
	@Test
	public void testEventBlocks() throws InstanceNotFoundException{
		// First block
		EventBlock eventBlock = userService.findEvents(null, null, 0, 1);
		int nevents = userService.getNumberOfEvents(null,null);
		assertEquals(2,nevents);
		assertTrue(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		// Next block
		EventBlock eventBlock2 = userService.findEvents(null, null, 1, 1);
		assertFalse(eventBlock2.getExistMoreEvents());
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(nevents, events.size() + events2.size());
	}

	@Test
	public void testNoPastEvents() throws InstanceNotFoundException{
		int beforeEvents = userService.getNumberOfEvents(null, null);
		// Insertion of a past event
		Calendar pastCal = new GregorianCalendar();
		pastCal.set(1990,1,1);
		Event pastEvent = new Event("Garrulo - Mariscal", pastCal, categoryDao.find(new Long (2)));
		eventDao.save(pastEvent);
		BetType bt = new BetType("Quien ganara la Super Petanca 1990?", false);
		bt.setEvent(pastEvent);
		betTypeDao.save(bt);
		int afterEvents =  userService.getNumberOfEvents(null, null);
		assertEquals(beforeEvents, afterEvents);
	}
	
	@Test
	public void testCheckOrderEvents() throws InstanceNotFoundException{
		// Insertion of two future events
		Long petancaId = new Long(2);
		Calendar tomorrow = Calendar.getInstance();
		tomorrow.add(Calendar.DAY_OF_MONTH, 1);
		Calendar afterTomorrow = Calendar.getInstance();
		afterTomorrow.add(Calendar.DAY_OF_MONTH, 2);
		Event tomorrowEvent = new Event("Garrulo - Mariscal", tomorrow, categoryDao.find(petancaId));
		BetType bt1 = new BetType("Quien ganara la Super Petanca 2010?", false);
		bt1.setEvent(tomorrowEvent);
		Event afterTomorrowEvent = new Event("MegaGarrulo - Mariscal360", afterTomorrow, categoryDao.find(petancaId));
		BetType bt2 = new BetType("Quien ganara la Super Petanca 2010v2?", false);
		bt2.setEvent(afterTomorrowEvent);
		eventDao.save(tomorrowEvent);
		eventDao.save(afterTomorrowEvent);
		betTypeDao.save(bt1);
		betTypeDao.save(bt2);
		// Check order
		EventBlock eventBlock = userService.findEvents(null, petancaId, 0, 10);
		assertEquals(eventBlock.getEvents().get(0).getId(), tomorrowEvent.getId());
		assertEquals(eventBlock.getEvents().get(1).getId(), afterTomorrowEvent.getId());		
		
	}
	
}
