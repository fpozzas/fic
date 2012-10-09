using System;
using System.Web.Security;

using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.Betbook.Model.UserService.Exceptions;


namespace Es.Udc.DotNet.Betbook.Web.Pages.User
{

    public partial class Authentication : SpecificCulturePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            lblPasswordError.Visible = false;
            lblLoginError.Visible = false;
        }

        /// <summary>
        /// Handles the Click event of the btnLogin control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance 
        /// containing the event data.</param>
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                SessionManager.Login(Context, txtLogin.Text,
                    txtPassword.Text, checkRememberPassword.Checked);

                FormsAuthentication.
                    RedirectFromLoginPage(txtLogin.Text,
                        checkRememberPassword.Checked);
            }
            catch (InstanceNotFoundException)
            {
                lblLoginError.Visible = true;
            }
            catch (IncorrectPasswordException)
            {
                lblPasswordError.Visible = true;
            }

        }

    }
}
