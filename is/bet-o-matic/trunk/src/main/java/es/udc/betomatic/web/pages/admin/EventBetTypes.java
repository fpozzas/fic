package es.udc.betomatic.web.pages.admin;


import java.text.Format;
import java.text.NumberFormat;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Locale;
import java.util.GregorianCalendar;

import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.ioc.Messages;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@AuthenticationPolicy(AuthenticationPolicyType.ADMIN)
public class EventBetTypes {

	private Event event;
	private BetType betType;
	private BetOption betOption;
	private Set<BetType> betTypes;

	@Inject
	private CommonService commonService;

	@Inject
	private Locale locale;

	@Inject
	private Messages messages;

	@Property
	private String errorMessage;

	public Set<BetType> getBetTypes() {
		if (event != null) {
			return betTypes;
		} else {
			return null;
		}
	}

	public BetType getBetType() {
		return betType;
	}

 	public void setBetType(BetType betType){
		this.betType = betType;
	}

	public List<BetOption> getBetOptions() {
		if (betType != null) {
			return betType.getOptions();
		} else {
			return null;
		}
	}

	public BetOption getBetOption() {
		return betOption;
	}

 	public void setBetOption(BetOption betOption){
		this.betOption = betOption;
	}

	public Event getEvent() {
		return event;
	}

	public void setEvent(Event event){
		this.event = event;
	}
	public Format getNumberFormat() {
		return NumberFormat.getNumberInstance(locale);
	}
	
	public boolean getEventHasStarted() {
		return event.getDate().before(new GregorianCalendar());
	}

	public boolean getHasOptions() {
		errorMessage = null;

		if (betType.getOptions().size() == 0) {
			errorMessage = messages.get("error-noOptions");
		}
		return errorMessage == null;
	}

	public Object[] getAddLinksContext() {
		Object o[] = { event.getId(), null, false, null, null };
		return o;
	}
	
	public Object[] getSetLinksContext() {
		Object o[] = { event.getId(), betType.getId() };
		return o;
	}

	Long onPassivate() {
		return event.getId();
	}

	void onActivate(Long eventId) {
		try {
			this.event = commonService.findEvent(eventId);
		} catch (InstanceNotFoundException e) {
			this.event = null;
		}
		//BetTypes must contain only betTypes without winner
		Set<BetType> aux = event.getBetTypes();
		Iterator<BetType> it = aux.iterator();
		betTypes = new HashSet<BetType>();
		while(it.hasNext()){
			BetType b = it.next();
			if (!b.getWinner()){
				//This betType has no winner already
				betTypes.add(b);
			}
		}
	}

	public Format getFormat() {
		return NumberFormat.getCurrencyInstance(locale);
	}

}
