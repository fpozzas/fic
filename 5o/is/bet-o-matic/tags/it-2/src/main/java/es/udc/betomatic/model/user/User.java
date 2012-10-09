package es.udc.betomatic.model.user;

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

import es.udc.betomatic.model.account.Account;

@Entity
public class User {
	private long id;
	private String login;
	private String name;
	private String lastName;
	private String email;
	private String passwd;
	private Account account;
	private long version;

	public User() {}

	public User(String login, String name, String lastName,
				String email, String passwd) {
		this.login = login;
		this.name = name;
		this.lastName = lastName;
		this.email = email;
		this.passwd = passwd;
	}

    @Column(name="userId")
    @SequenceGenerator(         // It only takes effect for
         name="UserIdGenerator", // databases providing identifier
         sequenceName="UserSeq") // generators.
    @Id
    @GeneratedValue(strategy=GenerationType.AUTO,
                    generator="UserIdGenerator")
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getLogin() {
		return login;
	}
	public void setLogin(String login) {
		this.login = login;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	@OneToOne(fetch=FetchType.LAZY)
	@JoinColumn(name="accId")
	public Account getAccount() {
		return account;
	}
	public void setAccount(Account account) {
		this.account = account;
	}
	@Version
	public long getVersion() {
		return version;
	}
	public void setVersion(long version) {
		this.version = version;
	}






	
	
}
