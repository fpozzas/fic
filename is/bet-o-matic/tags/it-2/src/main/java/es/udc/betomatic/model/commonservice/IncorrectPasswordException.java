package es.udc.betomatic.model.commonservice;

@SuppressWarnings("serial")
public class IncorrectPasswordException extends Exception {

	private String login;

	public IncorrectPasswordException(String login) {
		super("Incorrect password exception => login = " + login);
		this.login = login;
	}

	public String getLogin() {
		return login;
	}
}
