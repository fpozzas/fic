using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.EventService;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Web.Properties;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class ViewFavourites : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblNoFavourites.Visible = false;

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
                List<Favourite> userFav = eventService.FindUserFavourites(userId, startIndex, count);
                int numberOfRecommendations = eventService.GetNumberOfRecommendations(userId);

                if (userFav.Count == 0)
                {
                    lblNoFavourites.Visible = true;
                    return;
                }

                /* Binding gridview with groups */
                this.gvViewFavourites.DataSource = userFav;
                this.gvViewFavourites.DataBind();

                /* "Previous" link */
                lnkPrevious.Visible = false;
                if ((startIndex - count) >= 0)
                {
                    String url =
                        Settings.Default.Betbook_applicationURL +
                        "/Pages/ViewFavourites.aspx" +
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
                        "/Pages/ViewFavourites.aspx" +
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
