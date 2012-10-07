using System;
using System.Web;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Log;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.EventService;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class FavouriteEvent : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack == false)
            {
                txtFavouriteName.Text = Request.Params.Get("eventName");
            }
        }

        protected void btnAddFavourite_Click(object sender, EventArgs e)
        {
            string name = txtFavouriteName.Text;
            string comment = txtareaFavouriteComment.Value;
            int eventId = Int32.Parse(Request.Params.Get("eventId"));

            /* Get the Service */
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IEventService eventService = container.Resolve<IEventService>();

            UserSession userSession = SessionManager.GetUserSession(Context);
            eventService.FavouriteEvent(eventId, 
                userSession.UserProfileId, 
                name, 
                comment, 
                DateTime.Now);

            LogManager.RecordMessage("Favourite on event " + eventId + ".", LogManager.MessageType.INFO);

            Server.Transfer(Response.ApplyAppPathModifier("./ViewFavourites.aspx"));
        }
    }
}
