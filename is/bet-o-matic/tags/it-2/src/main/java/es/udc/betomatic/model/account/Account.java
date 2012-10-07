package es.udc.betomatic.model.account;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

import es.udc.betomatic.model.user.User;

import java.math.BigDecimal;

@Entity
public class Account {
	private long id;
	private BigDecimal balance;
	private User user;
	private long version;

	public Account() {}

	public Account(BigDecimal balance, User user) {
		this.balance = balance;
		this.setUser(user);
	}

    @Column(name="accId")
    @SequenceGenerator(         // It only takes effect for
         name="AccIdGenerator", // databases providing identifier
         sequenceName="AccSeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="AccIdGenerator")
	public long getId(){
		return id;
	}
	public void setId(long id){
		this.id = id;
	}
	public BigDecimal getBalance() {
		return balance;
	}
	public void setBalance(BigDecimal balance) {
		this.balance = balance;
	}
    @Version
    public long getVersion() {
        return version;
    }
    public void setVersion(long version) {
        this.version = version;
    }
    @OneToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="userId")
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}

}
