package es.udc.betomatic.test.model.betservice;

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
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import es.udc.betomatic.test.model.util.DbUtil;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

import es.udc.betomatic.model.account.*;
import es.udc.betomatic.model.bet.*;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.betoption.BetOptionDao;
import es.udc.betomatic.model.betservice.AlreadyHasWinnersException;
import es.udc.betomatic.model.betservice.BetBlock;
import es.udc.betomatic.model.betservice.BetService;
import es.udc.betomatic.model.betservice.DifferentBetTypeOptionsException;
import es.udc.betomatic.model.betservice.InsufficientBalanceException;
import es.udc.betomatic.model.betservice.InvalidNumberOfWinnersException;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE })
@Transactional
public class BetServiceTest {

	@Autowired
	private BetDao betDao;
	@Autowired
	private AccountDao accountDao;
	@Autowired
	private BetOptionDao betOptionDao;
	@Autowired
	private BetService betService;

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
		
		bet = betService.createBet(bet);
		Bet bet2 = betDao.find(bet.getId());
		assertEquals(bet, bet2);
	}

	@Test
	public void testFindBetsByDate() {
		BetBlock betBlock = betService.findBetsByDate(DbUtil.getTestAccountId(), DbUtil.getTestBetDate(), DbUtil.getTestBetDate(), 0, 5);
		assertFalse(betBlock.getExistMoreBets());
		List<Bet> bets = betBlock.getBets();
		assertEquals(2, bets.size());
		assertEquals(2, bets.get(0).getAmount().doubleValue(), Double.MIN_NORMAL);
		assertEquals(3, bets.get(1).getAmount().doubleValue(), Double.MIN_NORMAL);
	}

	@Test
	public void testGetNumberOfBets() {
		assertEquals(2,
				betService.getNumberOfBets(DbUtil.getTestAccountId(), DbUtil.getTestBetDate(), DbUtil.getTestBetDate()));
	}
	
	@Test
	public void testEstablishWinners() throws InstanceNotFoundException, DifferentBetTypeOptionsException, AlreadyHasWinnersException, InvalidNumberOfWinnersException {
		Set<Long> betOptions = new TreeSet<Long>();
		betOptions.add(DbUtil.getTestBetOptionId());
		
		betService.establishWinners(DbUtil.getTestBetTypeId(), betOptions);
		
		Account account = accountDao.find(DbUtil.getTestAccountId());
		BigDecimal expected = new BigDecimal(10 + 2*2.5);
		int resultCompareTo = expected.compareTo(account.getBalance()); 
		assertEquals(0,resultCompareTo);
	}
}
