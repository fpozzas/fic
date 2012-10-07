package es.udc.betomatic.web.pages.user;

import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.corelib.components.Form;
import org.apache.tapestry5.corelib.components.PasswordField;
import org.apache.tapestry5.corelib.components.TextField;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.web.pages.Index;
import es.udc.betomatic.web.pages.error.AuthenticationError;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.util.UserSession;
import es.udc.pojo.modelutil.exceptions.DuplicateInstanceException;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@AuthenticationPolicy(AuthenticationPolicyType.NON_AUTHENTICATED_USERS)
public class Register {

    @Property
    private String loginName;

    @Property
    private String password;

    @Property
    private String retypePassword;

    @Property
    private String name;

    @Property
    private String lastName;

    @Property
    private String email;

    @SessionState(create=false)
    private UserSession userSession;
    
    @Inject
    private CommonService commonService;

    @Component
    private Form registrationForm;

    @Component(id = "loginName")
    private TextField loginNameField;

    @Component(id = "password")
    private PasswordField passwordField;

    @Inject
    private Messages messages;

    private Long userProfileId;

    void onValidateForm() {

        if (!registrationForm.isValid()) {
            return;
        }

        if (!password.equals(retypePassword)) {
            registrationForm.recordError(passwordField, messages
                    .get("error-passwordsDontMatch"));
        } else {

            try {
                userProfileId = commonService.registerUser(loginName, name, lastName,
                		email, password).getId();
            } catch (DuplicateInstanceException e) {
                registrationForm.recordError(loginNameField, messages
                        .get("error-loginNameAlreadyExists"));
            }

        }

    }

    Object onSuccess() {

    	userSession = new UserSession();
        userSession.setUserProfileId(userProfileId);
        userSession.setFirstName(name);
        try{
        	userSession.setIsAdmin(userProfileId==commonService.getAdminUserId());
        }catch (InstanceNotFoundException e){
        	userSession.setIsAdmin(false);
        }
        User user;
		if (!userSession.getIsAdmin()){
	        try {
	            user = commonService.findUser(userProfileId);
	        } catch (InstanceNotFoundException e) { 
	        	return AuthenticationError.class;
	        }
	        userSession.setAccountId(user.getAccount().getId());
		}
        return Index.class;

    }

}
