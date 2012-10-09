using System;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model;


namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class UserCreated : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblUserCreatedId.Text = SessionManager.GetUserSession(Context).UserProfileId.ToString();
        }
    }
}
