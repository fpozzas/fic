package es.udc.betomatic.web.pages.common;

import java.text.Format;
import java.text.NumberFormat;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Date;
import java.text.DateFormat;


import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.annotations.SessionState;

import es.udc.betomatic.model.adminservice.AdminService;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.userservice.UserService;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.util.UserSession;


@AuthenticationPolicy(AuthenticationPolicyType.AUTHENTICATED_USERS)
public class SearchEvents {

	private final static int EVENTS_PER_PAGE = 10;

	private int startIndex = 0;
	private String keywords;
	private Long categoryId;

	@Property
	private EventBlock eventBlock;
	private Event event;

	@Property
	private String categoryIdInput;

	@Component
	private Form searchEventsForm;

	@Inject
	private CommonService commonService;
	
	@Inject
	private UserService userService;
	
	@Inject
	private AdminService adminService;

	@Inject
	private Locale locale;

	@Property
	@SessionState(create=false)
    private UserSession userSession;


	public String getCategories() {
		return commonService.getAllCategoriesToString();
	}

	void onValidateForm() {

		if (!searchEventsForm.isValid()) {
			return;
		}
		if (categoryIdInput != null)
		{
			categoryId = Long.parseLong(categoryIdInput);
		}
	}

	Object onSuccess() {
		this.setKeywords(keywords);
		this.setCategory(categoryId);
		this.setStartIndex(0);
		return this;
	}


	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

	public void setCategory(Long categoryId) {
		this.categoryId = categoryId;
	}

	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	public String getKeywords() {
		return keywords;
	}

	public List<Event> getEvents() {
		return eventBlock.getEvents();
	}

	public Event getEvent() {
		return event;
	}

	public Date getDate()
	{
		return event.getDate().getTime();
	}

	public void setEvent(Event event){
		this.event = event;
	}

	public Format getNumberFormat() {
		return NumberFormat.getInstance(locale);
	}

	public DateFormat getDateFormat() {
		return DateFormat.getDateInstance(DateFormat.SHORT, locale);
	}

	public Object[] getPreviousLinkContext() {

		if (startIndex-EVENTS_PER_PAGE >= 0) {
			return new Object[] {keywords, categoryId, startIndex-EVENTS_PER_PAGE};
		} else {
			return null;
		}

	}

	public Object[] getNextLinkContext() {

		if (eventBlock.getExistMoreEvents()) {
			return new Object[] {keywords, categoryId, startIndex+EVENTS_PER_PAGE};
		} else {
			return null;
		}

	}

	Object[] onPassivate() {
		if (searching) {
			Object[] o = { keywords, categoryId, startIndex };
			return o;
		} else {
			return null;
		}
	}

	void onPrepare() {
		this.searching = true;
	}

	void onActivate(String keywords, Long categoryId, int startIndex) {
		this.keywords = keywords;

		List<String> splittedKeywords;
		if (keywords==null) {
			splittedKeywords = null;
		} else {
			splittedKeywords = Arrays.asList(keywords.split("\\s+"));
		}

		this.categoryId = categoryId;
		this.startIndex = startIndex;

		if ( userSession.getIsAdmin() )
			eventBlock = adminService.findEventsAdmin(splittedKeywords, categoryId, startIndex, EVENTS_PER_PAGE);
		else
			eventBlock = userService.findEvents(splittedKeywords, categoryId, startIndex, EVENTS_PER_PAGE);
	}

	@Property
	private boolean searching = false;
}
