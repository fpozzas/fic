package es.udc.betomatic.test.model.util;

import static es.udc.betomatic.model.util.GlobalNames.SPRING_CONFIG_FILE;
import static es.udc.betomatic.test.util.GlobalNames.SPRING_CONFIG_TEST_FILE;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;

import java.math.BigDecimal;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.List;

import es.udc.betomatic.model.user.User;
import es.udc.betomatic.model.user.UserDao;
import es.udc.betomatic.model.util.PasswordEncrypter;
import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.account.AccountDao;
import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetDao;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.betoption.BetOptionDao;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bettype.BetTypeDao;
import es.udc.betomatic.model.category.Category;
import es.udc.betomatic.model.category.CategoryDao;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventDao;

public class DbUtil {

    static {
        ApplicationContext context = new ClassPathXmlApplicationContext(
            new String[] {SPRING_CONFIG_FILE, SPRING_CONFIG_TEST_FILE});

        transactionManager = (PlatformTransactionManager) context
            .getBean("transactionManager");
        accountDao = (AccountDao) context.getBean("accountDao");
        userDao = (UserDao) context.getBean("userDao");
        categoryDao = (CategoryDao) context.getBean("categoryDao");
        eventDao = (EventDao) context.getBean("eventDao");
        betTypeDao = (BetTypeDao) context.getBean("betTypeDao");
        betOptionDao = (BetOptionDao) context.getBean("betOptionDao");
        betDao = (BetDao) context.getBean("betDao");
    }

    private static Long testAccountId;
    private static Long testUserId;
    private static Long testEventId;
    private static Long testEventId2;
    private static Long testEventId3; 
    private static Long testBetTypeId;
    private static Long testBetOptionId; 
    private static Long testBetOptionId2; 
    private static Long testBetId1; 
    private static Long testBetId2; 
    private static Calendar testBetDate;

	private static AccountDao accountDao;
    private static UserDao userDao;
    private static CategoryDao categoryDao;
    private static EventDao eventDao;
    private static BetTypeDao betTypeDao;
    private static BetOptionDao betOptionDao;
    private static BetDao betDao;
    private static PlatformTransactionManager transactionManager;

    public static Long getTestAccountId() {
        return testAccountId;
    }
    public static Long getTestUserId() {
		return testUserId;
	}
    public static Long getTestEventId() {
		return testEventId;
	}
	public static Long getTestBetTypeId() {
		return testBetTypeId;
	}
	public static Long getTestBetOptionId() {
		return testBetOptionId;
	}
	public static Calendar getTestBetDate() {
		return testBetDate;
	}
	public static Long getTestBetId1() {
		return testBetId1;
	}
	public static Long getTestBetId2() {
		return testBetId2;
	}
	
	public static void populateDb() throws Throwable {

		TransactionStatus transactionStatus = transactionManager
			.getTransaction(null);
		/* Test user and account */
		User testUser = new User("infbqu00", "Sarah", "Kerrigan",
				"s.kerrigan@alliance.com",PasswordEncrypter.crypt("kekeke"));
		Account testAccount = new Account(new BigDecimal(10), testUser);
		
		/* Test event: Mus, Jose Manuel - Antonio, 01/01/2010 */
		Calendar pastDate = new GregorianCalendar();
		pastDate.set(2010, 0, 1);
		Category mus = categoryDao.find(new Long(3));
		Event testEvent = new Event("Jose Manuel - Antonio", pastDate, mus);
		/* Test event2: Cricket, Antonio's team - Otros, 01/01/2020 */
		Calendar futureDate = new GregorianCalendar();
		futureDate.set(2020, 0, 1);
		Category cricket = categoryDao.find(new Long(1));
		Event testEvent2 = new Event("Antonio's team - Otros", futureDate, cricket);
		/* Test event3: Mus, Juan Jose - Pedro, 01/02/2020 */
		Calendar futureDate2 = new GregorianCalendar();
		futureDate2.set(2020, 1, 1);
		Event testEvent3 = new Event("Juan Jose - Pedro", futureDate2, mus);
		
		/* Test betType */
		BetType winner = new BetType("Who will win?", false);
		winner.setEvent(testEvent);
		
		/* Test betOptions */
		BetOption joseManuel = new BetOption("Jose Manuel", new BigDecimal("2.5"), false, winner);
		BetOption antonio = new BetOption("Antonio", new BigDecimal("1.5"), false, winner);
		List<BetOption> options = new LinkedList<BetOption>();
		options.add(joseManuel);
		options.add(antonio);
		winner.setOptions(options);
		
		/* Test bets */
		Calendar firstDec = new GregorianCalendar();
		firstDec.set(2009, 11, 1);
		testBetDate = firstDec;
		Bet testBet1 = new Bet(new BigDecimal(2), firstDec, testAccount, joseManuel);
		testBet1.setBetState(Bet.BetState.PENDING);
		Bet testBet2 = new Bet(new BigDecimal(3), firstDec, testAccount, antonio);
		testBet2.setBetState(Bet.BetState.PENDING);

		try {
			accountDao.save(testAccount);
			testAccountId = testAccount.getId();
			userDao.save(testUser);
			testUserId = testUser.getId();
			eventDao.save(testEvent);
			testEventId = testEvent.getId();
			eventDao.save(testEvent2);
			testEventId2 = testEvent2.getId();
			eventDao.save(testEvent3);
			testEventId3 = testEvent3.getId();
			betTypeDao.save(winner);
			testBetTypeId = winner.getId();
			betOptionDao.save(joseManuel);
			testBetOptionId = joseManuel.getId();
			betOptionDao.save(antonio);
			testBetOptionId2 = antonio.getId();
			betDao.save(testBet1);
			testBetId1 = testBet1.getId();
			betDao.save(testBet2);
			testBetId2 = testBet2.getId();
			transactionManager.commit(transactionStatus);
		} catch (Throwable e) {
			transactionManager.rollback(transactionStatus);
			throw e;
		}

	}

	public static void cleanDb() throws Throwable {

		TransactionStatus transactionStatus = transactionManager
			.getTransaction(null);

		try {
			betDao.remove(testBetId1);
			testBetId1 = null;
			betDao.remove(testBetId2);
			testBetId2 = null;
			betOptionDao.remove(testBetOptionId);
			testBetOptionId = null;
			betOptionDao.remove(testBetOptionId2);
			testBetOptionId2 = null;
			betTypeDao.remove(testBetTypeId);
			testBetTypeId = null;
			eventDao.remove(testEventId);
			testEventId = null;
			eventDao.remove(testEventId2);
			testEventId2 = null;
			eventDao.remove(testEventId3);
			testEventId3 = null;
			accountDao.remove(testAccountId);
			testAccountId = null;
			userDao.remove(testUserId);
			testUserId = null;
			transactionManager.commit(transactionStatus);
		} catch (Throwable e) {
			transactionManager.rollback(transactionStatus);
			throw e;
		}

	}

}
