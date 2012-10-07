package es.udc.betomatic.web.pages.user;

import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.services.Cookies;

import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.commonservice.IncorrectPasswordException;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.web.pages.Index;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.util.CookiesManager;
import es.udc.betomatic.web.util.UserSession;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@AuthenticationPolicy(AuthenticationPolicyType.NON_AUTHENTICATED_USERS)
public class Login {

    @Property
    private String loginName;

    @Property
    private String password;

    @Property
    private boolean rememberMyPassword;

    @SessionState(create=false)
    private UserSession userSession;

    @Inject
    private Cookies cookies;

    @Component
    private Form loginForm;

    @Inject
    private Messages messages;
    
    @Inject
    private CommonService commonService;
    
    private User user = null;


    void onValidateForm() {

        if (!loginForm.isValid()) {
            return;
        }

        try {
            user = commonService.authenticate(loginName, password, false);
        } catch (InstanceNotFoundException e) {
            loginForm.recordError(messages.get("error-authenticationFailed"));
        } catch (IncorrectPasswordException e) {
            loginForm.recordError(messages.get("error-authenticationFailed"));
        }

    }

    Object onSuccess() {

    	userSession = new UserSession();
        userSession.setUserProfileId(user.getId());
        userSession.setFirstName(user.getName());
		try {
        	userSession.setIsAdmin(user.getId()==commonService.getAdminUserId());
        } catch (InstanceNotFoundException e) {
        	userSession.setIsAdmin(false);
        }
		if (!userSession.getIsAdmin())
			userSession.setAccountId(user.getAccount().getId());

        if (rememberMyPassword) {
            CookiesManager.leaveCookies(cookies, loginName, user.getPasswd());
        }
        return Index.class;

    }

	void onActivate() {}
}
