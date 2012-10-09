using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.GroupService;
using Es.Udc.DotNet.Betbook.Model;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class MyGroups : SpecificCulturePage
    {
        protected void Page_Load(Object sender, EventArgs e)
        {
            lblNoUserGroups.Visible = false;
            /* Get the Service */
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IGroupService groupService = container.Resolve<IGroupService>();
            List<Group> userGroups = groupService.FindUserGroups(SessionManager.GetUserSession(Context).UserProfileId);

            if (userGroups.Count == 0)
            {
                lblNoUserGroups.Visible = true;
                return;
            }

            /* Binding gridview with groups */
            this.gvViewGroups.DataSource = userGroups;
            this.gvViewGroups.DataBind();
        }
    }
}
