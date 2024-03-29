package es.udc.betomatic.model.user;

public class UserDetails {

	private String name;
	private String lastName;
	private String email;

	public UserDetails(String name, String lastName, String email) {
		this.name = name;
		this.lastName = lastName;
		this.email = email;
	}

	public String getName() {
		return name;
	}
	
	public String getLastName() {
		return lastName;
	}
	
	public String getEmail() {
		return email;
	}
	
}
