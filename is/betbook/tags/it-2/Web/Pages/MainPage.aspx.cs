using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class MainPage : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (SessionManager.IsUserAuthenticated(Context))
            {
                if (lclContent != null)
                    lclContent.Text =
                        GetLocalResourceObject("lclContent.Text").ToString()
                        + ", " + ((UserSession)Session["userSession"]).FirstName;
            }
        }
    }
}
