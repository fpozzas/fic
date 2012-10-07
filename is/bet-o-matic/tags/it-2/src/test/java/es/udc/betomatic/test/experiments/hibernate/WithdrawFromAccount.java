package es.udc.betomatic.test.experiments.hibernate;

import java.math.BigDecimal;

import org.hibernate.Transaction;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.account.AccountDao;
import es.udc.betomatic.model.account.AccountDaoHibernate;
import es.udc.betomatic.model.userservice.InsufficientBalanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@Deprecated
public class WithdrawFromAccount {

	private final static String USAGE_MESSAGE = "Usage: WithdrawFromAccount <accountId:long> <amount:double>";

	public static void main(String[] args) {
		long accountId = -1;
		double amount = -1;
		if (args.length == 2) {
			try {
				accountId = Long.parseLong(args[0]);
				amount = Double.parseDouble(args[1]);
			} catch (NumberFormatException e) {
				System.err.println("Error: " + USAGE_MESSAGE);
				System.exit(-1);
			}
		} else {
			System.err.println("Error: " + USAGE_MESSAGE);
			System.exit(-1);
		}

		AccountDaoHibernate accountDaoHibernate = new AccountDaoHibernate();
		accountDaoHibernate
				.setSessionFactory(HibernateUtil.getSessionFactory());
		AccountDao accountDao = accountDaoHibernate;

		Transaction tx = HibernateUtil.getSessionFactory().getCurrentSession()
				.beginTransaction();

		try {
			/* Find account. */
			Account account = accountDao.find(accountId);

			/* Modify balance. */
			double currentBalance = account.getBalance().doubleValue();

			if (currentBalance < amount) {
				throw new InsufficientBalanceException(accountId,
						currentBalance, amount);
			}

			account.setBalance(new BigDecimal(currentBalance - amount));

			tx.commit();

		} catch (RuntimeException e) {
			e.printStackTrace();
			tx.rollback();
			throw e;
		} catch (InstanceNotFoundException e) {
			e.printStackTrace();
			tx.commit();
		} catch (InsufficientBalanceException e) {
			e.printStackTrace();
			tx.commit();
		} finally {
			HibernateUtil.getSessionFactory().getCurrentSession().close();
		}
		HibernateUtil.shutdown();

	}

}
