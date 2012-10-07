package es.udc.betomatic.web.pages.xmlservice;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Date;
import java.text.DateFormat;

import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.annotations.ContentType;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.event.Event;
import es.udc.betomatic.model.event.EventBlock;
import es.udc.betomatic.model.userservice.UserService;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@ContentType("text/xml")
public class FindEvents {

    @Inject
    private org.apache.tapestry5.services.Request request;

    @Inject
    private UserService userService;

    @Inject
    private Locale locale;

    @Inject
    private Messages messages;

    private Event event;

    private String errorMessage = messages.get("error-Unknown");


    public List<Event> getEvents() throws InstanceNotFoundException {
        String paramKeywords = request.getParameter("keywords");
        if ( paramKeywords == null )
        {
            paramKeywords = "";
        }

        List<String> keywordList = Arrays.asList( paramKeywords.split(" ") );
        EventBlock betBlock = userService.findEvents(keywordList, null, 0, Integer.MAX_VALUE-1);
        return betBlock.getEvents();
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public Date getDate()
    {
        return event.getDate().getTime();
    }

    public DateFormat getDateFormat() {
        return DateFormat.getDateInstance(DateFormat.SHORT, locale);
    }


    public String getErrorMessage()
    {
        return errorMessage;
    }

    void onActivate() {}
}
