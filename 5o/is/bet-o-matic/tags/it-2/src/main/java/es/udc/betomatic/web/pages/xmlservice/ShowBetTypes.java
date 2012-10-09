package es.udc.betomatic.web.pages.xmlservice;

import java.util.Set;

import java.util.List;
import java.util.Locale;
import java.text.NumberFormat;
import java.text.Format;

import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.annotations.ContentType;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.bettype.BetType;
import es.udc.betomatic.model.betoption.BetOption;
import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@ContentType("text/xml")
public class ShowBetTypes {

    @Inject
    private org.apache.tapestry5.services.Request request;

    @Inject
    private CommonService commonService;

    @Inject
    private Locale locale;

    @Inject
    private Messages messages;

    private Event event=null;
    private BetType betType;
    private BetOption betOption;

    private String errorMessage = messages.get("error-Unknown");


    public Set<BetType> getBetTypes() {
        if (event != null)
            return event.getBetTypes();
        else
            return null;
    }

    public BetType getBetType() {
        return betType;
    }
    public void setBetType(BetType betType) {
        this.betType = betType;
    }


    public List<BetOption> getBetOptions() {
        return betType.getOptions();
    }

    public BetOption getBetOption() {
        return betOption;
    }
    public void setBetOption(BetOption betOption) {
        this.betOption = betOption;
    }

    public Format getNumberFormat() {
        return NumberFormat.getCurrencyInstance(locale);
    }


    public String getErrorMessage()
    {
        return errorMessage;
    }

    void onActivate() {
        String paramEventId = request.getParameter("eventId");

        if (paramEventId == null) {
            errorMessage = messages.get("error-noEventId");
        } else {
            try {
                event = commonService.findEvent( Long.parseLong(paramEventId) );
            } catch (InstanceNotFoundException e) {
                errorMessage = messages.get("error-noEvent");
            } catch (NumberFormatException e) {
                errorMessage = messages.get("error-invalidEventId");
            }
        }

    }
}
