using System;

using Es.Udc.DotNet.Betbook.Web.HTTP.Session;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{

    public partial class Logout : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

            SessionManager.Logout(Context);

            Response.Redirect("~/Pages/MainPage.aspx");


        }
    }
}
