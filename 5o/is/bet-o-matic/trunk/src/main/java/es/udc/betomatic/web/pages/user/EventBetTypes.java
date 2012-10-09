package es.udc.betomatic.web.pages.user;


import java.math.BigDecimal;
import java.text.Format;
import java.text.NumberFormat;
import java.text.ParsePosition;
import java.util.List;
import java.util.Set;
import java.util.Locale;
import java.util.Date;
import java.util.GregorianCalendar;
import java.text.DateFormat;

import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.InjectComponent;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.corelib.components.Zone;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.corelib.components.TextField;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.Block;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetBlock;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.userservice.InsufficientBalanceException;
import es.udc.betomatic.model.userservice.UserService;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;
import es.udc.betomatic.web.util.UserSession;

@AuthenticationPolicy(AuthenticationPolicyType.AUTHENTICATED_USERS)
public class EventBetTypes {

	private final static int BETS_PER_PAGE = 5;

	private int startIndex = 0;
	private Event event;
	private BetType betType;
	private BetOption betOption;
	private BetBlock betBlock;
	private Set<BetType> betTypes;
	@Property
	private Bet bet;
	@Property
	private BetOption currentBetOption;

	@Inject
	private CommonService commonService;
	@Inject
	private UserService userService;

	@Inject
	private Locale locale;

	@Property
	@SessionState(create=false)
    private UserSession userSession;

	@Inject
	private Messages messages;

	@Property
	private String errorMessage;

	@InjectComponent
	private Zone betSidebarZone;
	@SuppressWarnings("unused")
	@InjectComponent
	private Zone betFormZone;

	@Inject
	private Block betFormBlock;

	@Property
	private String amount;
    @Component(id = "amount")
    private TextField amountField;

    @Component
    private Form betForm;

	Object onActionFromUserBetsZone(Long betOptionId) {
		try {
			currentBetOption = commonService.findBetOption( betOptionId );
		} catch (InstanceNotFoundException e) {
			currentBetOption = null;
		}
		return betFormBlock;
	}
	Object onActionFromUserBetsZonePrevious() {
		startIndex -= BETS_PER_PAGE;
		betBlock = userService.findBetsByAccount(userSession.getAccountId(),
												startIndex, BETS_PER_PAGE);
		return betSidebarZone.getBody();
	}
	Object onActionFromUserBetsZoneNext() {
		startIndex += BETS_PER_PAGE;
		betBlock = userService.findBetsByAccount(userSession.getAccountId(),
												startIndex, BETS_PER_PAGE);
		return betSidebarZone.getBody();
	}

	void onValidateForm() throws InstanceNotFoundException {
        if (!betForm.isValid()) {
            return;
        }

		try {
			NumberFormat numberFormatter = NumberFormat.getInstance(locale);
			ParsePosition position = new ParsePosition(0);
			Number number = numberFormatter.parse(amount, position);
			if ( position.getIndex() == amount.length() &&
				 number.doubleValue() > 0 ) {
				Bet bet = new Bet(new BigDecimal( number.doubleValue() ),
								  new GregorianCalendar(),
								  commonService.findUser(userSession.getUserProfileId()).getAccount(),
								  currentBetOption);
				userService.createBet( bet );
			} else {
				betForm.recordError(amountField, messages
									.get("error-incorrectAmount"));
			}
		} catch (InsufficientBalanceException e) {
			betForm.recordError(amountField, messages
								.get("error-insufficientBalance"));
		}
    }

	Object onSuccess() {
		return betSidebarZone;
	}

	public Object[] getUserBetsZonePreviousLinkContext() {
		Long id = currentBetOption==null ? 0 : currentBetOption.getId();
		if (startIndex-BETS_PER_PAGE >= 0) {
			return new Object[] {startIndex-BETS_PER_PAGE, id};
		} else {
			return null;
		}
	}
	public Object[] getUserBetsZoneNextLinkContext() {
		Long id = currentBetOption==null ? 0 : currentBetOption.getId();
		if (betBlock.getExistMoreBets()) {
			return new Object[] {startIndex+BETS_PER_PAGE, id};
		} else {
			return null;
		}
	}


	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}

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


	public List<Bet> getBets() {
		return betBlock.getBets();
	}


	public Format getNumberFormat() {
		return NumberFormat.getCurrencyInstance(locale);
	}
	public DateFormat getDateFormat() {
		return DateFormat.getDateInstance(DateFormat.SHORT, locale);
	}

	public Date getDate()
	{
		return event.getDate().getTime();
	}
	public Date getBetDate(){
		return bet.getDate().getTime();
	}

	public boolean getEventHasStarted() {
		return event.getDate().before(new GregorianCalendar());
	}

	public int getNumberOfOptions() {
		return betType.getOptions().size();
	}

	public boolean getShouldShowOptions() {
		errorMessage = null;

		if (betType.getOptions().size() == 0) {
			errorMessage = messages.get("error-noOptions");
		} else {
			if (getEventHasStarted() != userSession.getIsAdmin()) {
				if (getEventHasStarted()) {
					errorMessage = messages.get("error-eventAlreadyStarted");
				} else {
					errorMessage = messages.get("error-eventNotStarted");
				}
			}
		}

		return errorMessage == null;
	}

	public String getBetState(){
		if (bet.getBetState()==Bet.BetState.PENDING){
			return messages.get("betstate-pending");
		}
		else if (bet.getBetState()==Bet.BetState.LOSER){
			return messages.get("betstate-loser");
		}
		else return messages.get("betstate-winner");
	}

	Object[] onPassivate() {
		Long id = currentBetOption==null ? 0 : currentBetOption.getId();
		Object[] o =
			{event.getId(), startIndex, id};
		return o;
	}

	void onActivate(Long eventId)
		throws InstanceNotFoundException {
		try {
			this.event = commonService.findEvent(eventId);
		} catch (InstanceNotFoundException e) {
			this.event = null;
		}
		betTypes = event.getBetTypes();
		betBlock = userService.findBetsByAccount(userSession.getAccountId(),
												startIndex, BETS_PER_PAGE);
		balance = userService.getBalance(userSession.getUserProfileId());
	}

	void onActivate(Long eventId, int startIndex, Long currentBetOptionId)
		throws InstanceNotFoundException {
		this.onActivate(eventId);
		this.startIndex = startIndex;
		try {
			currentBetOption = commonService.findBetOption( currentBetOptionId );
		} catch (InstanceNotFoundException e) {
			currentBetOption = null;
		}
	}

	public Format getFormat() {
		return NumberFormat.getCurrencyInstance(locale);
	}


	@SuppressWarnings("unused")
	@Property
    private BigDecimal balance;
	
}
