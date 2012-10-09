using System;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Web.Properties;


namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class EventRecommended : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string url = Settings.Default.Betbook_applicationURL + "/Pages/ViewRecommendations.aspx";
            this.lnkViewRecommendations.NavigateUrl = Response.ApplyAppPathModifier(url);
        }
    }
}
