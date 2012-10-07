package es.udc.betomatic.web.pages.admin;

import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;

@AuthenticationPolicy(AuthenticationPolicyType.ADMIN)
public class EventCreated {

	private Long eventId;
	
	public Long getEventId() {
		return eventId;
	}

	public void setEventId(Long eventId) {
		this.eventId = eventId;
	}

	Long onPassivate() {
		return eventId;
	}
	
	void onActivate(Long eventId) {
		this.eventId = eventId;
	}
	
}
