package es.udc.betomatic.model.bet;

import java.util.Calendar;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import es.udc.betomatic.model.account.Account;
import es.udc.betomatic.model.betoption.BetOption;


@Entity
@org.hibernate.annotations.Entity(mutable=false)
public class Bet {
	
	private Long id;
	private BigDecimal amount;
	private Calendar date;
	private Account account;
	private BetOption option;

	public Bet(){}
	
	public Bet(BigDecimal amount, Calendar date, Account account, BetOption option) {
		this.amount = amount;
		this.date = date;
		this.account = account;
		this.option = option;
	}
	
    @Column(name="betId")
    @SequenceGenerator(         // It only takes effect for
         name="BetIdGenerator", // databases providing identifier
         sequenceName="BetSeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="BetIdGenerator")
	public Long getId() {
		return id;
	}               
    public void setId(Long id) {
		this.id = id;
	}
	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}
	public BigDecimal getAmount() {
		return amount;
	}
    @Temporal(TemporalType.TIMESTAMP)
	public Calendar getDate() {
		return date;
	}
	public void setDate(Calendar date) {
		this.date = date;
	}
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="accId")
	public Account getAccount() {
		return account;
	}
	public void setAccount(Account account) {
		this.account = account;
	}
	@OneToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="betOptionId")
	public BetOption getOption() {
		return option;
	}
	public void setOption(BetOption option) {
		this.option = option;
	}

	
}
