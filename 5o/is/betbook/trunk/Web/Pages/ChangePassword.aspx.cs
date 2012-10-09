using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.UserService.Exceptions;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class ChangePassword : SpecificCulturePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            lblOldPasswordError.Visible = false;
        }

        /// <summary>
        /// Handles the Click event of the btnChangePassword control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance 
        /// containing the event data.</param>
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {

            try
            {

                SessionManager.ChangePassword(Context, txtOldPassword.Text,
                    txtNewPassword.Text);

                Response.Redirect(Response.
                    ApplyAppPathModifier("~/Pages/MainPage.aspx"));

            }
            catch (IncorrectPasswordException)
            {
                lblOldPasswordError.Visible = true;
            }

        }
    }
}

