package es.udc.betomatic.test.model.eventservice;

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

import es.udc.betomatic.model.category.CategoryDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventDao;
import es.udc.betomatic.model.eventservice.EventBlock;
import es.udc.betomatic.model.eventservice.EventService;
import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class EventServiceExhaustiveTest {

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
	public void testNoResults() throws InstanceNotFoundException {
		Calendar lastDec = new GregorianCalendar();
		lastDec.set(2009, 11, 1);
		List<String> keywords = new LinkedList<String>();
		keywords.add("ManoleteKiller");
		
		EventBlock eventBlock = eventService.findEvents(keywords, lastDec, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(0, events.size());
	}
	
	@Test
	public void testMixedKeywords() throws InstanceNotFoundException {
		Calendar cal = new GregorianCalendar();
		cal.set(2010, 1, 1);
		Event event = new Event("Socorritos - Donha Virtudes", cal, categoryDao.find(new Long(2)));
		eventDao.save(event);
		
		cal.set(2009,11,1);
		List<String> keywords1 = new LinkedList<String>();
		keywords1.add("socorritos");
		keywords1.add("virtudes");
		List<String> keywords2 = new LinkedList<String>();
		keywords2.add("virtudes");
		keywords2.add("socorritos");
		
		EventBlock eventBlock1 = eventService.findEvents(keywords1, cal, 0, 10);
		EventBlock eventBlock2 = eventService.findEvents(keywords2, cal, 0, 10);
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
		cal.set(2010, 1, 1);
		Event event = new Event("Socorritos - Donha Virtudes", cal, categoryDao.find(new Long(2)));
		eventDao.save(event);
		
		cal.set(2009,11,1);
		List<String> keywords1 = new LinkedList<String>();
		keywords1.add("socorri");
		keywords1.add("virtu");

		EventBlock eventBlock1 = eventService.findEvents(keywords1, cal, 0, 10);
		List<Event> events1 = eventBlock1.getEvents();
		assertEquals(1, events1.size());
		assertEquals(events1.get(0), event);
	}
	
	@Test
	public void testNoKeywords() throws InstanceNotFoundException{
		Calendar cal = new GregorianCalendar();
		cal.set(2009,1,1);
		
		// Empty list
		EventBlock eventBlock1 = eventService.findEvents(new LinkedList<String>(),cal,0,10);
		List<Event> events1 = eventBlock1.getEvents();
		assertEquals(3,events1.size());
		
		// Null list
		EventBlock eventBlock2 = eventService.findEvents(null,cal,0,10);
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(3,events2.size());
	}
	
	@Test
	public void testNoKeywordsButCategory() throws InstanceNotFoundException{
		Calendar cal = new GregorianCalendar();
		cal.set(2010, 1, 1);
		Long petancaId = new Long(2);
		Event event = new Event("Socorritos - Donha Virtudes", cal, categoryDao.find(petancaId));
		eventDao.save(event);
		
		cal.set(2009,1,1);
		// Empty list
		EventBlock eventBlock1 = eventService.findEvents(new LinkedList<String>(),petancaId,cal,0,10);
		List<Event> events1 = eventBlock1.getEvents();
		assertEquals(1,events1.size());
		
		// Null list
		EventBlock eventBlock2 = eventService.findEvents(null,petancaId,cal,0,10);
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(1,events2.size());
	}
	
	@Test
	public void testLateStartDate() throws InstanceNotFoundException{
		Calendar lateDate = new GregorianCalendar();
		lateDate.set(2021,1,1);
		EventBlock eventBlock = eventService.findEvents(null, lateDate, 0, 10);
		assertFalse(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(0, events.size());
	}
	
	@Test
	public void testEventBlocks() throws InstanceNotFoundException{
		Calendar cal = new GregorianCalendar();
		cal.set(2009,1,1);
		// First block
		EventBlock eventBlock = eventService.findEvents(null, cal, 0, 2);
		int nevents = eventService.getNumberOfEvents(null, cal);
		assertEquals(3,nevents);
		assertTrue(eventBlock.getExistMoreEvents());
		List<Event> events = eventBlock.getEvents();
		assertEquals(2, events.size());
		// Next block
		EventBlock eventBlock2 = eventService.findEvents(null, cal, 2, 2);
		assertFalse(eventBlock2.getExistMoreEvents());
		List<Event> events2 = eventBlock2.getEvents();
		assertEquals(nevents, events.size() + events2.size());
	}
	
}
