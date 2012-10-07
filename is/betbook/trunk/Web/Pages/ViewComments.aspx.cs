using System;
using System.Collections.Generic;
using System.Web;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.Betbook.Web.Properties;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Model.CommentService;
using System.Data;
using System.Web.UI.WebControls;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class ViewComments : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
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
            ICommentService commentService = container.Resolve<ICommentService>();

            /* Get Comments, either by tagId or eventId */
            List<Comment> comments = new List<Comment>();
            int numberOfComments = 0;
            string pageLink = "";
            try
            {
                String tagText = Request.Params.Get("tag");
                Tag tag = commentService.FindTagByText(tagText);
                comments = commentService.FindCommentsByTag(tag.tagId, startIndex, count);
                numberOfComments = commentService.GetNumberOfCommentsByTag(tag.tagId);
                pageLink = "?tag=" + tagText;
            }
            catch (Exception)
            {
                try
                {
                    long eventId = Convert.ToInt32(Request.Params.Get("eventId"));
                    comments = commentService.FindCommentsByEvent(eventId, startIndex, count);
                    numberOfComments = commentService.GetNumberOfCommentsByEvent(eventId);
                    pageLink = "?eventId=" + eventId;
                }
                catch (Exception)
                {
                    lblCommentsHeader.Text = GetLocalResourceObject("lolNoComments").ToString();
                }
            }


            // Message
            if (comments.Count == 0)
            {
                lblCommentsHeader.Text = GetLocalResourceObject("lolNoComments").ToString();
                return;
            }
            else
            {
                try
                {
                    String tagText = Request.Params.Get("tag");
                    if (tagText == null)
                        throw new ArgumentNullException();
                    lblCommentsHeader.Text = String.Format(GetLocalResourceObject("showingCommentsByTag").ToString(), tagText);
                }
                catch (Exception)
                {
                    try
                    {
                        long eventId = Convert.ToInt32(Request.Params.Get("eventId"));
                        lblCommentsHeader.Text = String.Format(GetLocalResourceObject("showingCommentsByEvent").ToString(), eventId);
                    }
                    catch (ArgumentNullException)
                    {}
                }
            }

            this.gvEventComments.DataSource = comments;
            this.gvEventComments.DataBind();


            /* "Previous" link */
            lnkPrevious.Visible = false;
            if ((startIndex - count) >= 0)
            {
                String url =
                    Settings.Default.Betbook_applicationURL +
                    "/Pages/ViewComments.aspx" +
                    pageLink +
                    "&startIndex=" + (startIndex - count) +
                    "&count=" + count;

                this.lnkPrevious.NavigateUrl = 
                    Response.ApplyAppPathModifier(url);
                this.lnkPrevious.Visible = true;
            }

            /* "Next" link */
            lnkNext.Visible = false;
            if ((startIndex + count) < numberOfComments)
            {
                String url =
                    Settings.Default.Betbook_applicationURL +
                    "/Pages/ViewComments.aspx" +
                    pageLink +
                    "&startIndex=" + (startIndex + count) +
                    "&count=" + count;

                this.lnkNext.NavigateUrl = 
                    Response.ApplyAppPathModifier(url);
                this.lnkNext.Visible = true;
            }
        }
    }
}