package es.udc.betomatic.web.services;

import java.io.IOException;

import org.apache.tapestry5.services.ApplicationStateManager;
import org.apache.tapestry5.services.Cookies;
import org.apache.tapestry5.services.Dispatcher;
import org.apache.tapestry5.services.Request;
import org.apache.tapestry5.services.Response;

import es.udc.betomatic.model.commonservice.CommonService;
import es.udc.betomatic.model.commonservice.IncorrectPasswordException;
import es.udc.betomatic.model.user.User;
import es.udc.betomatic.web.util.CookiesManager;
import es.udc.betomatic.web.util.UserSession;
import es.udc.pojo.modelutil.exceptions.InstanceNotFoundException;

public class SessionDispatcher implements Dispatcher {

	private ApplicationStateManager applicationStateManager;
	private Cookies cookies;
	private CommonService commonService;

	public SessionDispatcher(ApplicationStateManager applicationStateManager,
			Cookies cookies, CommonService commonService) {

		this.applicationStateManager = applicationStateManager;
		this.cookies = cookies;
		this.commonService = commonService;
	}

	public boolean dispatch(Request request, Response response)
			throws IOException {

		if (!applicationStateManager.exists(UserSession.class)) {

			String loginName = CookiesManager.getLoginName(cookies);
			if (loginName == null) {
				return false;
			}

			String encryptedPassword = CookiesManager
					.getEncryptedPassword(cookies);
			if (encryptedPassword == null) {
				return false;
			}

			try {

				User user = commonService.authenticate(loginName,
						encryptedPassword, true);
				UserSession userSession = new UserSession();
				userSession.setUserProfileId(user.getId());
				userSession.setFirstName(user.getName());
				userSession.setIsAdmin(user.getId()==commonService.getAdminUserId());
				applicationStateManager.set(UserSession.class, userSession);

			} catch (InstanceNotFoundException e) {
				CookiesManager.removeCookies(cookies);
			} catch (IncorrectPasswordException e) {
				CookiesManager.removeCookies(cookies);
			}

		}

		return false;

	}

}
