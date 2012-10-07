package es.udc.betomatic.web.components;

import org.apache.tapestry5.annotations.Parameter;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.Cookies;

import es.udc.betomatic.web.pages.Index;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.util.CookiesManager;
import es.udc.betomatic.web.util.UserSession;

public class Layout {
    @SuppressWarnings("unused")
    @Property
    @Parameter(required = false, defaultPrefix = "message")
    private String menuExplanation;

    @SuppressWarnings("unused")
    @Property
    @Parameter(required = true, defaultPrefix = "message")
    private String pageTitle;

    @SuppressWarnings("unused")
    @Property
    @SessionState(create=false)
    private UserSession userSession;

    @Inject
    private Cookies cookies;

    @AuthenticationPolicy(AuthenticationPolicyType.AUTHENTICATED_USERS)
   	Object onActionFromLogout() {
        userSession = null;
        CookiesManager.removeCookies(cookies);
        return Index.class;
	}
}