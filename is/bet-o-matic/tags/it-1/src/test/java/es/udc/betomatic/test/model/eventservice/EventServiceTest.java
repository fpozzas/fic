package es.udc.betomatic.test.model.eventservice;

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

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;

import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.category.Category;
import es.udc.betomatic.model.category.CategoryDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventDao;
import es.udc.betomatic.model.eventservice.EventBlock;
import es.udc.betomatic.model.eventservice.EventService;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class EventServiceTest {

	@Autowired
	private EventDao eventDao;
	@Autowired
	private CategoryDao categoryDao;

	@Autowired
	private EventService eventService;

	@BeforeClass
	public static void populateDb() throws Throwable {
		DbUtil.populateDb();
	}

	@AfterClass
	public static void cleanDb() throws Throwable {
		DbUtil.cleanDb();
	}

	@Test
	public void testCreateEvent() throws InstanceNotFoundException {
		Category category = categoryDao.find(new Long(1));
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 1);
		Event event = new Event("Partido de prueba", lastDec,category);
		event = eventService.createEvent(event);
		
		Event event2 = eventDao.find(event.getId());
		assertEquals(event.getName(), event2.getName());
		assertEquals(event.getDate(), event2.getDate());
		assertEquals(event.getCategory(), event2.getCategory());
	}

	@Test
	public void testAddBetTypeToEvent() throws InstanceNotFoundException {
		BetType betType = new BetType("How many points will the winner score?", false);
		eventService.addBetTypeToEvent(DbUtil.getTestEventId(), betType);
		Event event = eventDao.find(DbUtil.getTestEventId());
		assertTrue(event.getBetTypes().contains(betType));
	}

	@Test
	public void testFindEvents() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 31);
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		
		EventBlock eventBlock = eventService.findEvents(keywords, lastDec, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(2, events.size());
		assertEquals("Jose Manuel - Antonio", events.get(0).getName());
		assertEquals("Antonio's team - Otros", events.get(1).getName());
	}

	@Test
	public void testFindEventsCat() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 31);
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		Long mus = new Long(3);
		
		EventBlock eventBlock = eventService.findEvents(keywords, mus, lastDec, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Jose Manuel - Antonio", events.get(0).getName());
	}

	@Test
	public void testFindEventsAdmin() throws InstanceNotFoundException {
		Calendar lastJan = new GregorianCalendar();
		lastJan.set(2010, 0, 31);
		List<String> keywords = new LinkedList<String>();
		keywords.add("Juan Jose");
		
		EventBlock eventBlock = eventService.findEventsAdmin(keywords, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Juan Jose - Pedro", events.get(0).getName());
	}

	@Test
	public void testFindEventsAdminCat() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 31);
		List<String> keywords = new LinkedList<String>();
		keywords.add("Pedro");
		keywords.add("-");
		Long mus = new Long(3);
		
		EventBlock eventBlock = eventService.findEvents(keywords, mus, lastDec, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(1, events.size());
		assertEquals("Juan Jose - Pedro", events.get(0).getName());
	}

	@Test
	public void testGetNumberOfEvents() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 31);
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		assertEquals(2,
				eventService.getNumberOfEvents(keywords, lastDec));
	}

	@Test
	public void testGetNumberOfEventsCat() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 31);
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		Long cricket = new Long(1);
		assertEquals(1,
				eventService.getNumberOfEvents(keywords, cricket, lastDec));
	}

	@Test
	public void testGetNumberOfEventsAdmin() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Juan Jose");
		assertEquals(1,
				eventService.getNumberOfEventsAdmin(keywords));
	}
	
	@Test
	public void testGetNumberOfEventsAdminCat() throws InstanceNotFoundException {
		List<String> keywords = new LinkedList<String>();
		keywords.add("Antonio");
		keywords.add("-");
		Long mus = new Long(3);
		assertEquals(1,
				eventService.getNumberOfEventsAdmin(keywords, mus));
	}
}
