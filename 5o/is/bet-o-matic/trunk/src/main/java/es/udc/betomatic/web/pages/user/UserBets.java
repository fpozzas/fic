package es.udc.betomatic.web.pages.user;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.Format;
import java.text.NumberFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.bet.Bet;
import es.udc.betomatic.model.bet.BetBlock;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.userservice.UserService;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.util.UserSession;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@AuthenticationPolicy(AuthenticationPolicyType.AUTHENTICATED_USERS)
public class UserBets {
	
	private final static int BETS_PER_PAGE = 10;

	private int startIndex = 0;
	private BetBlock betBlock;
	private Bet bet;
	
	@Inject
	private UserService userService;
	@Inject
	private Messages messages;
	@Inject
	private Locale locale;
	
    @Property
    @SessionState(create=false)
    private UserSession userSession;
	
    @SuppressWarnings("unused")
	@Property
    private BigDecimal balance;
    
	public List<Bet> getBets() {
		return betBlock.getBets();
	}
	
	public Bet getBet() {
		return bet;
	}
	public void setBet(Bet bet) {
		this.bet = bet;
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
	
	public String getBetTypeWinners(){
		String winners = "";
		BetType bt = bet.getOption().getBetType();
		if (bt.getWinner()==false) return winners;
		List<BetOption> bops = bt.getOptions();
		for (BetOption bop : bops){
			if (bop.getWinner()) winners=winners.concat(bop.getName()+", ");
		}
		return winners.substring(0,winners.length()-2);
	}

	public Format getFormat() {
		return NumberFormat.getCurrencyInstance(locale);
	}
	
	public Date getBetDate(){
		return bet.getDate().getTime();
	}
	public Date getEventDate(){
		return bet.getOption().getBetType().getEvent().getDate().getTime();
	}
	public DateFormat getDateFormat() {
		return DateFormat.getDateInstance(DateFormat.SHORT, locale);
	}
	public Object[] getPreviousLinkContext() {
		
		if (startIndex-BETS_PER_PAGE >= 0) {
			return new Object[] {startIndex-BETS_PER_PAGE};
		} else {
			return null;
		}
		
	}
	
	public Object[] getNextLinkContext() {
		
		if (betBlock.getExistMoreBets()) {
			return new Object[] {startIndex+BETS_PER_PAGE};
		} else {
			return null;
		}
		
	}
	
	int onPassivate() {
		return startIndex;
	}
	
	void onActivate(int startIndex) {
		this.startIndex = startIndex;
		betBlock = userService.findBetsByAccount(userSession.getAccountId(),
				startIndex, BETS_PER_PAGE);
		try {
			balance = userService.getBalance(userSession.getUserProfileId());
		} catch (InstanceNotFoundException e) {
			balance = new BigDecimal(0);
		}
	}

}
