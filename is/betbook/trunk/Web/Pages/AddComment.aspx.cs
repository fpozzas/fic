using System;
using System.Web;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Log;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.CommentService;
using Es.Udc.DotNet.Betbook.Model;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class AddComment : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            updateTagCloud();
        }

        protected void btnAddComment_Click(object sender, EventArgs e)
        {   
            string comment = txtareaComment.Value;
            int eventId = Int32.Parse(Request.Params.Get("eventId"));

            /* Get the Service */
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            ICommentService commentService = container.Resolve<ICommentService>();

            UserSession userSession = SessionManager.GetUserSession(Context);
            long commentId = commentService.SubmitComment(userSession.UserProfileId, eventId, comment, DateTime.Now);

            // Add tags
            foreach (var tag in txtTags.Text.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                commentService.AddTagToComment(commentId, tag);
            }

            Server.Transfer(Response.ApplyAppPathModifier(String.Format("./ViewComments.aspx?eventId={0}", eventId)));
        }

        void updateTagCloud()
        {
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            ICommentService commentService = container.Resolve<ICommentService>();

            List<Tag> tags = commentService.FindAllTags();
            lvTagList.DataSource = tags;
            lvTagList.DataBind();
        }

        public string GetTagLink(string tag)
        {
            return String.Format("javascript:addTag(document.getElementById('{0}'), '{1}')", txtTags.ClientID, tag);
        }

        //protected void LvTagList_ItemCommand(object sender, ListViewCommandEventArgs e)
        //{
        //    if (e.CommandName == "addTag")
        //    {
        //        txtTags.Text = e.CommandArgument.ToString() + txtTags.Text;
        //    }
        //}
    }
}
