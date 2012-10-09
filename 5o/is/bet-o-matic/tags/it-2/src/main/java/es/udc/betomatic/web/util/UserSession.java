package es.udc.betomatic.web.util;


public class UserSession {

	private Long userId;
	private Long accountId;
	private String firstName;
	private boolean isAdmin;

	public Long getUserProfileId() {
		return userId;
	}
	
	public void setUserProfileId(Long userProfileId) {
		this.userId = userProfileId;
	}
	
	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}

	public Long getAccountId() {
		return accountId;
	}

	public void setIsAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}

	public boolean getIsAdmin() {
		return isAdmin;
	}

}
