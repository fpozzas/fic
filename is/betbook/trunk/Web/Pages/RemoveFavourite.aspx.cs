using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.EventService;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.ModelUtil.Exceptions;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class RemoveFavourite : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            long favouriteId = Convert.ToInt32(Request.Params.Get("favouriteId"));

            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IEventService eventService = container.Resolve<IEventService>();
            try
            {
                eventService.RemoveFavourite(favouriteId, SessionManager.GetUserSession(Context).UserProfileId);
                Server.Transfer(Response.ApplyAppPathModifier("./ViewFavourites.aspx"));
            }
            catch (IllegalOperationException)
            {
                lblRemoveFavouriteResult.Text = GetLocalResourceObject("RemoveFavouriteIllegal").ToString();
            }
            catch (InstanceNotFoundException)
            {
                lblRemoveFavouriteResult.Text = GetLocalResourceObject("RemoveFavouriteIllegal").ToString();
            }
            
        }
    }
}
