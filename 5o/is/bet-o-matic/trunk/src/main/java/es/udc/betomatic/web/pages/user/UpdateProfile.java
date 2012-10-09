package es.udc.betomatic.web.pages.user;

import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.ioc.annotations.Inject;

import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.user.UserDetails;
import es.udc.betomatic.web.pages.Index;
import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;
import es.udc.betomatic.web.util.UserSession;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

@AuthenticationPolicy(AuthenticationPolicyType.AUTHENTICATED_USERS)
public class UpdateProfile {

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

    void onPrepareForRender() throws InstanceNotFoundException {

        UserDetails userDetails;

        userDetails = commonService.getUserDetails(userSession
                .getUserProfileId());
        name = userDetails.getName();
        lastName = userDetails.getLastName();
        email = userDetails.getEmail();

    }

    Object onSuccess() throws InstanceNotFoundException {

        commonService.updateUserDetails(
                userSession.getUserProfileId(), 
                        name, lastName, email);
        userSession.setFirstName(name);
        return Index.class;

    }

}