using System;
using System.Web;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.EventService;
using System.Xml.Xsl;
using Es.Udc.DotNet.Betbook.Web.Properties;
using Es.Udc.DotNet.Betbook.Model.CommentService;
using Es.Udc.DotNet.Betbook.Model.BetOMaticService;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class FindBetTypes : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                long eventId = Int32.Parse(Request.Params.Get("eventId"));
                ShowEventList(eventId);
            }
            catch (ArgumentNullException)
            {
                // TODO
            }
        }

        private void ShowEventList(long eventId)
        {
            try
            {
                /* Get the Service */
                IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
                IEventService eventService = container.Resolve<IEventService>();
                ICommentService commentService = container.Resolve<ICommentService>();

                aspXml.XPathNavigator = eventService.FindBetTypes(eventId).CreateNavigator();
                aspXml.TransformArgumentList = new XsltArgumentList();

                aspXml.TransformArgumentList.AddParam("numberOfResults", "", aspXml.XPathNavigator.Select("//betType").Count);

                foreach (var lcl in new string[]{ "lclBetTypes","lclQuestion","lclMultipleWinner","lclOptions",
                    "lclAddComment", "lclViewComments", "lclFavouriteEvent", "lclRecommendEvent", "lclNoBetTypes" })
                {
                    aspXml.TransformArgumentList.AddParam(lcl, "",
                        GetLocalResourceObject(lcl + ".Text").ToString());
                }

                foreach (var page in new string[] { "AddComment", "ViewComments", "FavouriteEvent", "RecommendEvent" })
                {
                    aspXml.TransformArgumentList.AddParam("url" + page, "",
                        Response.ApplyAppPathModifier("~/Pages/" + page + ".aspx"));
                }

                aspXml.TransformArgumentList.AddParam("eventId", "", eventId);
                aspXml.TransformArgumentList.AddParam("eventName", "", Request.Params.Get("eventName"));
                aspXml.TransformArgumentList.AddParam("numberOfComments", "", commentService.GetNumberOfCommentsByEvent(eventId));
            }
            catch (BetOMaticException e)
            {
                lblBetOMaticErrorMessage.Visible = true;
            }
        }
    }
}
