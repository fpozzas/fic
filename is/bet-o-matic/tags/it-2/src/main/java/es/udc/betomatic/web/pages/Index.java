package es.udc.betomatic.web.pages;

import es.udc.betomatic.web.services.AuthenticationPolicy;
import es.udc.betomatic.web.services.AuthenticationPolicyType;

@AuthenticationPolicy(AuthenticationPolicyType.ALL_USERS)
public class Index {

	void onActivate() {
	}
	
}
