using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.EventService;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Web.Properties;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class ViewRecommendations : SpecificCulturePage
    {
        protected void Page_Load(Object sender, EventArgs e)
        {
            lblNoRecommendations.Visible = false;
            if (SessionManager.IsUserAuthenticated(Context))
            {
                int startIndex, count;

                try
                {
                    startIndex = Int32.Parse(Request.Params.Get("startIndex"));
                }
                catch (ArgumentNullException)
                {
                    startIndex = 0;
                }

                try
                {
                    count = Int32.Parse(Request.Params.Get("count"));
                }
                catch (ArgumentNullException)
                {
                    count = Settings.Default.Betbook_defaultCount;
                }

                /* Get the Service */
                IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
                IEventService eventService = container.Resolve<IEventService>();

                long userId = SessionManager.GetUserSession(Context).UserProfileId;
                List<Recommendation> recommendations = eventService.FindRecommendations(userId, startIndex, count);
                int numberOfRecommendations = eventService.GetNumberOfRecommendations(userId);
                
                if (numberOfRecommendations == 0)
                {
                    lblNoRecommendations.Visible = true;
                    return;
                }
                /* Binding gridview with recommendations */
                this.gvViewRecommendations.DataSource = recommendations;
                this.gvViewRecommendations.DataBind();

                /* "Previous" link */
                lnkPrevious.Visible = false;
                if ((startIndex - count) >= 0)
                {
                    String url =
                        Settings.Default.Betbook_applicationURL +
                        "/Pages/ViewRecommendations.aspx" +
                        "?startIndex=" + (startIndex - count) +
                        "&count=" + count;

                    this.lnkPrevious.NavigateUrl =
                        Response.ApplyAppPathModifier(url);
                    this.lnkPrevious.Visible = true;
                }

                /* "Next" link */
                lnkNext.Visible = false;
                if ((startIndex + count) < numberOfRecommendations)
                {
                    String url =
                        Settings.Default.Betbook_applicationURL +
                        "/Pages/ViewRecommendations.aspx" +
                        "?startIndex=" + (startIndex + count) +
                        "&count=" + count;

                    this.lnkNext.NavigateUrl =
                        Response.ApplyAppPathModifier(url);
                    this.lnkNext.Visible = true;
                }
            }
        }
    }
}
