package es.udc.betomatic.web.pages.admin;

import java.text.DateFormat;
import java.text.ParsePosition;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.InjectPage;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.corelib.components.Select;
import org.apache.tapestry5.corelib.components.TextField;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.adminservice.AdminService;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;


@AuthenticationPolicy(AuthenticationPolicyType.ADMIN)
public class CreateEvent {

	@Property
	private String eventName;
	
	@Property
	private String eventDate;
	
	@Property
	private String categoryId;

	private Long categoryIdAsLong;
	private Calendar eventDateAsCalendar;
	
	@Component
	private Form createEventForm;
	
    @Component(id = "categoryId")
    private Select categoryIdField;
    
    @Component(id = "eventDate")
    private TextField eventDateField;
	
	@Inject
	private CommonService commonService;
	
	@Inject
	private AdminService adminService;
	
	@InjectPage
	private EventCreated eventCreated;
	
    @Inject
    private Messages messages;
    
	@Inject
	private Locale locale;
	
	public String getCategories() {
		return commonService.getAllCategoriesToString();
	}
	
	void onValidateForm() {
		if (!createEventForm.isValid()) {
			return;
		}
		
		eventDateAsCalendar = validateDate(eventDateField, eventDate);

		categoryIdAsLong = Long.parseLong(categoryId);
		if(eventDateAsCalendar!=null){
			try{
				Event event = new Event(eventName, eventDateAsCalendar);
				adminService.createEvent(event, categoryIdAsLong);
				eventCreated.setEventId(event.getId());
			}catch(InstanceNotFoundException e){
				createEventForm.recordError(categoryIdField, messages
						.get("error-categoryIdDoesntExist"));
			}
		}
	}
		
	Object onSuccess() {
		return eventCreated;
	}
	
	void onActivate() {
		eventDate = dateToString(Calendar.getInstance().getTime());
	}
	
	private Calendar validateDate(TextField textField, String dateAsString) {
		
		ParsePosition position = new ParsePosition(0);
		Date date = DateFormat.getDateInstance(DateFormat.SHORT, locale).
			parse(dateAsString, position);
		
		Calendar calendar = new GregorianCalendar();
		if (date==null || position.getIndex() != dateAsString.length()) {
			createEventForm.recordError(textField,
				messages.format("error-incorrectDateFormat", dateAsString));
			calendar = null;
		}else{
		calendar.setTime(date);
		}
		
		return calendar;
		
	}
	
	private String dateToString(Date date) {
		return DateFormat.getDateInstance(DateFormat.SHORT, locale).
			format(date);
	}
}
