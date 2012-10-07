package es.udc.betomatic.web.pages.admin;

import java.util.List;
import java.util.Set;
import java.util.LinkedList;
import java.util.HashSet;

import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.InjectPage;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.adminservice.AlreadyHasWinnersException;
import es.udc.betomatic.model.adminservice.AdminService;
import es.udc.betomatic.model.adminservice.DifferentBetTypeOptionsException;
import es.udc.betomatic.model.adminservice.InvalidNumberOfWinnersException;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.web.pages.Index;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@AuthenticationPolicy(AuthenticationPolicyType.ADMIN)
public class SetWinners {

	private final static int ROWS_PER_PAGE = 10;
	
	private Event event;
	private BetType betType;
	private Set<Long> winnerOptionIdsSet;
    
    @Property
    private BetOption betOption;
    
	private boolean isWinnerOption;

	@Inject
	private CommonService commonService;
	
	@Inject
	private AdminService adminService;

    @Inject
    private Messages messages;
	
	@InjectPage
	private EventBetTypes eventBetTypes;
	
	@Component
	private Form setWinnersForm;
	
    public int getRowsPerPage() {
        return ROWS_PER_PAGE;
    }

    public void setIsWinnerOption(boolean b) {
        if (b){
            winnerOptionIdsSet.add(betOption.getId());
        }
        this.isWinnerOption = false;
    }

    public boolean getIsWinnerOption(){
    	return isWinnerOption;
    }
    
	public BetType getBetType() {
		return betType;
	}

	public List<BetOption> getBetOptions() {
		if (betType != null) {
			return new LinkedList<BetOption>(betType.getOptions());
		} else {
			return null;
		}
	}


	public Event getEvent() {
		return event;
	}

	Object[] onPassivate() {
		Object[] o =
			{event.getId(), betType.getId()};
		return o;
	}

	void onActivate(Long eventId, Long betTypeId) {
		try {
			this.event = commonService.findEvent(eventId);

			Set<BetType> set = event.getBetTypes();
			for (BetType betType : set) {
				if (betType.getId().equals(betTypeId))
					this.betType = betType;
			}
		} catch (InstanceNotFoundException e) {
			this.event = null;
		}
		winnerOptionIdsSet = new HashSet<Long>();
	}

	void onValidateForm() {
		if (!setWinnersForm.isValid()) {
			return;
		}
		if (!betType.getMultipleWinner() && winnerOptionIdsSet.size()!=1){
			setWinnersForm.recordError(messages.get("error-multipleWinners"));
		}
	}
	
    Object onSuccess() {
        try {
			adminService.establishWinners(betType.getId(), winnerOptionIdsSet);
		} catch (InstanceNotFoundException e) {
			return Index.class; //Never happens
		} catch (DifferentBetTypeOptionsException e) {
			return Index.class; //Never happens
		} catch (AlreadyHasWinnersException e) {
			return Index.class; //Never happens
		} catch (InvalidNumberOfWinnersException e) {
			return Index.class; //Never happens
		}
        eventBetTypes.setEvent(event);
        return eventBetTypes;
    }

	
}
