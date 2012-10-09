using System;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using System.Web.UI.WebControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.CommentService;
using System.Web;
using System.Collections.Generic;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Web.HTTP.Util;

namespace Es.Udc.DotNet.Betbook.Web
{
    public partial class Betbook : System.Web.UI.MasterPage
    {
        int numberOfComments;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!SessionManager.IsUserAuthenticated(Context))
            {
                if (lnkLogout != null)
                    lnkLogout.Visible = false;
                if (lnkUpdateUserProfile != null)
                    lnkUpdateUserProfile.Visible = false;
                if (lnkLocale != null)
                    lblLoggedIn.Visible = false;
            }
            else
            {
                if (lnkAuthenticate != null)
                    lnkAuthenticate.Visible = false;
                if (lnkRegister != null)
                    lnkRegister.Visible = false;
                if (lnkLocale != null)
                    lnkLocale.Visible = false;
                if (lblLoggedIn != null)
                    lblLoggedIn.Text = String.Format(GetLocalResourceObject("lblLoggedIn.Text").ToString(),
                        SessionManager.GetUserSession(Context).FirstName);
            }

            updateTagCloud();
        }

        void updateTagCloud()
        {
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            ICommentService commentService = container.Resolve<ICommentService>();

            numberOfComments = commentService.GetNumberOfComments();

            List<Tag> tags = commentService.FindAllTags();
            lvTagCloud.DataSource = tags;
            lvTagCloud.DataBind();
        }

        public string GetCssClass(int commentCount)
        {
            if (commentCount==0 ||numberOfComments==0)
                return "t0";

            float idx = (float)commentCount / (float)numberOfComments;

            if (idx < 0.2) return "t1";
            if (idx < 0.4) return "t2";
            if (idx < 0.6) return "t3";
            if (idx < 0.8) return "t4";
            
            return "t5";
        }
    }
}
