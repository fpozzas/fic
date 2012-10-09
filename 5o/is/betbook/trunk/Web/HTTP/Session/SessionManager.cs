using System;
using System.Web;
using System.Web.Security;
using Microsoft.Practices.Unity;

using Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects;
using Es.Udc.DotNet.Betbook.Web.HTTP.Util;
using Es.Udc.DotNet.Betbook.Model.UserService.Exceptions;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.ModelUtil.Exceptions;

namespace Es.Udc.DotNet.Betbook.Web.HTTP.Session
{


    ///<summary>
    ///
    /// A facade utility class to transparently manage session objects and 
    /// cookies. The following objects are mantained in the session:
    /// <list>
    ///  <item>* The user's data, stored in the UserSession object under the key 
    ///    <c>USER_SESSION_ATTRIBUTE</c>. This attribute is only present 
    ///    for authenticated users, and is only of interest to the view. The
    ///    UserSession object stores the firstName and the userProfileId</item>
    ///    
    ///  <item>* The user's language and the user's country, stored in the
    ///     Locale object under the key <c>LOCALE_SESSION_ATTRIBUTE</c>. This 
    ///     attribute is only present for authenticated users, and is only of 
    ///     interest to the view.</item>
    ///</list>
    /// 
    /// For users that select "remember my password" in the login wizard, the
    /// following cookies are used (managed in the CookiesManager object):
    /// <list>
    ///   <item>* <c>LOGIN_NAME_COOKIE</c>: to store the login name.</item>
    ///   <item>* <c>ENCRYPTED_PASSWORD_COOKIE</c>: to store the 
    ///              encrypted password.</item>
    ///   <item>* <c>.ASPXAUTH</c>: Authentication Cookie.</item>
    /// </list>
    /// In order to make transparent the management of session objects and cookies
    /// to the implementation of controller actions, this class provides a number
    /// of methods equivalent to some of the ones provided by 
    /// <c>UserService</c>, which manage session objects and cookies,
    /// and call upon the corresponding <c>UserService's</c> method.
    /// These methods are as follows:
    /// <list>
    ///   <item>* <c>Login</c>.</item>
    ///   <item>* <c>RegisterUser</c>.</item>
    ///   <item>* <c>FindUserDetails</c>.</item>
    ///   <item>* <c>UpdateUserDetails</c>.</item>
    ///   <item>* <c>ChangePassword</c>.</item>
    /// </list>
    /// 
    /// It is important to remember that when needing to do some of the above
    /// actions from the controller, the corresponding method of this class
    /// (one of the previous list) must be called, and <b>not</b> the one in
    /// <c>UserService</c>. The rest of methods of <c>UserService</c> must be 
    /// called directly. 
    /// 
    /// For example, in a personalizable portal,<c>UserService</c> could include:
    /// 
    ///   <c>findServicePreferences</c>, <c>updateServicePreferences</c>,
    ///   <c>findLayout</c>, <c>updateLayout</c>, etc. 
    /// 
    /// In a electronic commerce shop <c>UserFacadeDelegate</c> could include:
    /// 
    ///   <c>getShoppingCart</c>, <c>addToShoppingCart</c>,
    ///   <c>removeFromShoppingCart</c>, <c>makeOrder</c>,
    ///   <c>findPendingOrders</c>, etc. 
    ///   
    /// When needing to invoke directly a method of <c>UserSession</c>, the
    /// property <c>SessionManager.UserService</c> must be invoked in order
    /// to get the personal delegate (each user has his/her own delegate).
    ///  
    /// Same as <c>UserService</c>, there exist some logical 
    /// restrictions with regard to the order of method calling. In particular, 
    /// <c>updateUserDetails</c> and <c>changePassword</c>
    /// can not be called if <c>login</c> or <c>registerUser</c> 
    /// have not been previously called. After the user calls one of these two 
    ///  methods, the user is said to be authenticated.
    /// </summary>
    public class SessionManager
    {
        public static readonly String LOCALE_SESSION_ATTRIBUTE = "locale";

        public static readonly String USER_SESSION_ATTRIBUTE = "userSession";

        private static IUserService userService;

        [Dependency]
        public IUserService UserService
        {
            set { userService = value; }
        }

        static SessionManager()
        {
            IUnityContainer container =
                (IUnityContainer)HttpContext.Current.Application["unityContainer"];

            userService = container.Resolve<IUserService>();
        }


        /// <summary>
        /// Registers the user.
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <param name="loginName">Username</param>
        /// <param name="clearPassword">Password in clear text</param>
        /// <param name="UserDetails">The user profile details.</param>
        /// <exception cref="DuplicateInstanceException"/>
        public static void RegisterUser(HttpContext context,
            String loginName, String clearPassword,
            UserDetails userDetails)
        {
            /* Register user. */
            Es.Udc.DotNet.Betbook.Model.User user = userService.RegisterUser(loginName, clearPassword, userDetails);
            
            /* Insert necessary objects in the session. */
            UserSession userSession = new UserSession();
            userSession.UserProfileId = user.userId;
            userSession.FirstName = userDetails.Name;

            Locale locale = new Locale(userDetails.Language, userDetails.Country);

            UpdateSessionForAuthenticatedUser(context, userSession, locale);

            FormsAuthentication.SetAuthCookie(loginName, false);
        }

        /// <summary>
        /// Login method. Authenticates an user in the current context.
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <param name="loginName">Username</param>
        /// <param name="clearPassword">Password in clear text</param>
        /// <param name="rememberMyPassword">Remember password to the next logins</param>
        /// <exception cref="IncorrectPasswordException"/>
        /// <exception cref="InstanceNotFoundException"/>
        public static void Login(HttpContext context, String loginName,
           String clearPassword, Boolean rememberMyPassword)
        {
            /* Try to login, and if successful, update session with the necessary 
             * objects for an authenticated user. */
            LoginResult loginResult = DoLogin(context, loginName,
                clearPassword, false, rememberMyPassword);

            /* Add cookies if requested. */
            if (rememberMyPassword)
            {
                CookiesManager.LeaveCookies(context, loginName,
                    loginResult.EncryptedPassword);
            }
        }


        /// <summary>
        /// Tries to log in with the corresponding method of  
        /// <c>UserService</c>, and if successful, inserts in the
        /// session the necessary objects for an authenticated user.
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <param name="loginName">Username</param>
        /// <param name="password">User Password</param>
        /// <param name="passwordIsEncrypted">Password is either encrypted or 
        /// in clear text</param>
        /// <param name="rememberMyPassword">Remember password to the next 
        /// logins</param>
        /// <exception cref="IncorrectPasswordException"/>
        /// <exception cref="InstanceNotFoundException"/>
        ///<exception cref="InternalErrorException"/>
        private static LoginResult DoLogin(HttpContext context,
             String loginName, String password, Boolean passwordIsEncrypted,
             Boolean rememberMyPassword)
        {

            LoginResult loginResult =
                userService.Login(loginName, password,
                    passwordIsEncrypted);

            /* Insert necessary objects in the session. */

            UserSession userSession = new UserSession();
            userSession.UserProfileId = loginResult.UserId;
            userSession.FirstName = loginResult.Name;

            Locale locale =
                new Locale(loginResult.Language, loginResult.Country);

            UpdateSessionForAuthenticatedUser(context, userSession, locale);

            return loginResult;

        }


        /// <summary>
        /// Updates the session values for an previously authenticated user
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <param name="userSession">The user data stored in session.</param>
        /// <param name="locale">The locale info.</param>
        private static void UpdateSessionForAuthenticatedUser(
            HttpContext context, UserSession userSession, Locale locale)
        {
            /* Insert objects in session. */
            context.Session.Add(USER_SESSION_ATTRIBUTE, userSession);
            context.Session.Add(LOCALE_SESSION_ATTRIBUTE, locale);
        }

        /// <summary>
        /// Determine if a user is authenticated
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <returns>
        /// 	<c>true</c> if is user authenticated
        ///     <c>false</c> otherwise
        /// </returns>
        public static Boolean IsUserAuthenticated(HttpContext context)
        {
            if (context.Session == null)
                return false;

            return (context.Session[USER_SESSION_ATTRIBUTE] != null);
        }


        public static Locale GetLocale(HttpContext context)
        {
            Locale locale = (Locale)context.Session[LOCALE_SESSION_ATTRIBUTE];

            return locale;
        }

        public static void SetLocale(HttpContext context, Locale locale)
        {
            context.Session[LOCALE_SESSION_ATTRIBUTE] = locale;
        }

        public static UserSession GetUserSession(HttpContext context)
        {
            UserSession userSession = (UserSession)context.Session[USER_SESSION_ATTRIBUTE];

            return userSession;
        }
        public static Boolean IsLocaleDefined(HttpContext context)
        {
            if (context.Session == null)
                return false;
            else
                return (context.Session[LOCALE_SESSION_ATTRIBUTE] != null);
        }

        /// <summary>
        /// Updates the user profile details.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="UserDetails">The user profile details.</param>
        public static void UpdateUserDetails(HttpContext context,
            UserDetails UserDetails)
        {
            /* Update user's profile details. */

            UserSession userSession =
                (UserSession)context.Session[USER_SESSION_ATTRIBUTE];

            userService.UpdateUserDetails(userSession.UserProfileId,
                UserDetails);

            userSession.FirstName = UserDetails.Name;

            /* Update user's session objects. */

            Locale locale = new Locale(UserDetails.Language,
                UserDetails.Country);

            UpdateSessionForAuthenticatedUser(context, userSession, locale);

        }

        /// <summary>
        /// Finds the user profile with the id stored in the session.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <returns></returns>
        public static UserDetails FindUserDetails(HttpContext context)
        {
            UserSession userSession =
                (UserSession)context.Session[USER_SESSION_ATTRIBUTE];

            UserDetails UserDetails =
                userService.FindUserDetails(userSession.UserProfileId);

            return UserDetails;
        }

        /// <summary>
        /// Changes the user's password
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <param name="oldClearPassword">The old password in clear text</param>
        /// <param name="newClearPassword">The new password in clear text</param>
        /// <exception cref="IncorrectPasswordException"/>
        public static void ChangePassword(HttpContext context,
               String oldClearPassword, String newClearPassword)
        {
            UserSession userSession =
                (UserSession)context.Session[USER_SESSION_ATTRIBUTE];

            userService.ChangePassword(userSession.UserProfileId,
                oldClearPassword, newClearPassword);

            /* Remove cookies. */
            CookiesManager.RemoveCookies(context);

            /* Re-create the authentication ticket cookie. */
            FormsAuthentication.
                SetAuthCookie(userSession.FirstName, false);
        }

        /// <summary>
        /// Destroyes the session, and removes the cookies if the user had 
        /// selected "remember my password".
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        public static void Logout(HttpContext context)
        {
            /* Remove cookies. */
            CookiesManager.LeaveCookies(context, "", "");

            /* Invalidate session. */
            context.Session.Abandon();

            /* Invalidate Authentication Ticket */
            FormsAuthentication.SignOut();
        }


        /// <sumary>
        /// Guarantees that the session will have the necessary objects if the
        /// user has been authenticated or had selected "remember my password"
        /// in the past.
        /// </sumary> 
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <exception cref="InternalErrorException"/>
        public static void TouchSession(HttpContext context)
        {

            /* Check if "UserSession" object is in the session. */
            UserSession userSession = null;

            if (context.Session != null)
            {

                userSession =
                    (UserSession)context.Session[USER_SESSION_ATTRIBUTE];

                // If userSession object is in the session, nothing should be doing.
                if (userSession != null)
                {
                    return;
                }

            }

            /* 
             * The user had not been authenticated or his/her session has 
             * expired. We need to check if the user has selected "remember my 
             * password" in the last login (login name and password will come 
             * as cookies). If so, we reconstruct user's session objects.
             */
            UpdateSessionFromCookies(context);

            if (!IsUserAuthenticated(context))
            {
                FormsAuthentication.SignOut();
            }
        }

        /// <summary>
        /// Tries to login (inserting necessary objects in the session) by using
        /// cookies (if present).
        /// </summary>
        /// <param name="context">Http Context includes request, response, etc.</param>
        /// <exception cref="InternalErrorException"/>
        private static void UpdateSessionFromCookies(HttpContext context)
        {

            HttpRequest request = context.Request;

            /* Are there cookies in the request ? */
            if (request.Cookies == null)
            {
                return;
            }

            /* 
             * Check if the login name and the encrypted password come as 
             * cookies. 
             */
            String loginName = CookiesManager.GetLoginName(context);
            String encryptedPassword = CookiesManager.GetEncryptedPassword(context);


            if ((loginName == "") || (loginName == null) || (encryptedPassword == null))
            {
                return;
            }

            /* If loginName and encryptedPassword have valid values (the user selected "remember 
             * my password" option) try to login, and if successful, update session with the 
             * necessary objects for an authenticated user.
             */
            try
            {
                DoLogin(context, loginName, encryptedPassword, true, true);

                /* Authentication Ticket. */
                FormsAuthentication.SetAuthCookie(loginName, true);

            }
            catch (Exception)
            { // Incorrect loginName or encryptedPassword
                return;
            }

        }

    }

}
