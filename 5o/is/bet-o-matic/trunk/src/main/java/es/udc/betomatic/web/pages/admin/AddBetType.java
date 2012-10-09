package es.udc.betomatic.web.pages.admin;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.InjectPage;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.corelib.components.Submit;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.adminservice.AdminService;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.pages.admin.EventBetTypes;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;


@AuthenticationPolicy(AuthenticationPolicyType.ADMIN)
public class AddBetType {

	@Component
	private Form addBetTypeForm;
	
	@SuppressWarnings("unused")
	@Component
	private Submit addOption;
	@SuppressWarnings("unused")
	@Component
	private Submit create;

	@Property
	private String question;

	@Property
	private boolean multipleWinner;

	@Property
	private int index;
	
	@Inject
	private CommonService commonService;

	@Inject
	private AdminService adminService;

    @Inject
    private Messages messages;

	@InjectPage
	private EventBetTypes eventBetTypes;

	private Long eventId;
	@Property
	private List<String> optionNamesList;
	private List<String> quotaList;

	/* To differenciate from addOption and createBetType */
	private boolean isAddOptionSubmit;

	public Event getEvent() {
		try {
			return commonService.findEvent( eventId );
		} catch (InstanceNotFoundException e) {
			return null;
		} catch (IllegalArgumentException e) {
			return null;
		}
	}
	
	public void setQuota(String quota){
		quotaList.set(index, quota);
	}
	
	public String getQuota(){
		return quotaList.get(index);
	}
	
	public void setOptionName(String name){
		optionNamesList.set(index, name);
	}
	
	public String getOptionName(){
		return optionNamesList.get(index);
	}
	
	public Object[] getAddOptionContext(){
		List<Object> newContext = generateContext();
		newContext.add(null);
		newContext.add(null);
		return newContext.toArray();
	}

	private List<Object> generateContext(){
		List<Object> context = new ArrayList<Object>();
		context.add(eventId);
		context.add(question);
		context.add(multipleWinner);
		for(int i = 0; i<optionNamesList.size(); i++){
			context.add(optionNamesList.get(i));
			context.add(quotaList.get(i));
		}
		return context;
	}
	
	void onSelectedFromAddOption() {
		isAddOptionSubmit = true;
	}
	void onSelectedFromCreate() {
		isAddOptionSubmit = false;
	}
	
	
	private List<BetOption> readOptions(BetType betType) throws NumberFormatException{
		List<BetOption> betOptions = new ArrayList<BetOption>();
		for(int i=0; i<optionNamesList.size(); i++){
			betOptions.add(new BetOption(
					optionNamesList.get(i), new BigDecimal(quotaList.get(i)), false, betType));
		}
		return betOptions;
	}	
	
	void onValidateForm() {
		if (!addBetTypeForm.isValid()) {
			return;
		}
		if(isAddOptionSubmit){
			/* Add 2 new fields */
			optionNamesList.add(null);
			quotaList.add(null);
		}else{
			/* Create the bet type */
			BetType betType = new BetType(question, multipleWinner);
			try{
				List<BetOption> options = readOptions(betType);
				try {
					adminService.addBetTypeToEvent(eventId, betType);
					adminService.addBetOptionsToBetType(options, betType.getId());
				} catch (InstanceNotFoundException e) {
					addBetTypeForm.recordError(messages.get("error-noEvent"));
				}
			}catch (NumberFormatException e){
				addBetTypeForm.recordError(messages.get("error-quotaNumberFormat"));
			}
		}
	}

	Object onSuccess() {
		if(isAddOptionSubmit){
			return null;
		}else{
			eventBetTypes.setEvent(getEvent());
			return eventBetTypes;
		}
	}

	void onActivate(Object[] o) {
		List<Object> context = Arrays.asList(o);
		this.eventId = Long.parseLong((String) context.get(0));
		this.question = (String) context.get(1);
		this.multipleWinner = Boolean.parseBoolean((String) context.get(2));
		optionNamesList = new ArrayList<String>();
		quotaList = new ArrayList<String>();
		for(int i = 3; i<context.size(); i+=2){
			optionNamesList.add((i-3)/2, (String)context.get(i));
			quotaList.add((i-3)/2, (String)context.get(i+1));
		}
	}

	Object[] onPassivate() {
		return generateContext().toArray();
	}
}
