using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.GroupService;
using Es.Udc.DotNet.Betbook.Model;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class ViewGroups : SpecificCulturePage
    {
        protected void Page_Load(Object sender, EventArgs e)
        {
            lblNoGroups.Visible = false;
            /* Get the Service */
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IGroupService groupService = container.Resolve<IGroupService>();
            List<Group> allGroups = groupService.FindAllGroups();
            if (allGroups.Count == 0)
            {
                lblNoGroups.Visible = true;
                return;
            }
            /* Binding gridview with groups */
            this.gvViewGroups.DataSource = allGroups;
            this.gvViewGroups.DataBind();

            if (SessionManager.IsUserAuthenticated(Context))
            {
                /* Get user groups ids */
                List<Group> userGroups = groupService.FindUserGroups(SessionManager.GetUserSession(Context).UserProfileId);
                List<long> groupsIds = new List<long>();
                foreach (Group g in userGroups)
                {
                    groupsIds.Add(g.groupId);
                }
                /* If user has already joined the group, Join button is hidden */
                for (int i = 0; i < allGroups.Count; i++)
                {
                    Group group = allGroups[i];
                    if (groupsIds.Contains(group.groupId))
                    {
                        this.gvViewGroups.Rows[i].Cells[3].Visible = false;
                    }
                }
            }
        }

        //protected void gvViewGroups_Command(Object sender, GridViewCommandEventArgs e)
        //{
        //    if (e.CommandName == "Join")
        //    {

        //        IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
        //        IGroupService groupService = container.Resolve<IGroupService>();

        //        int index = Convert.ToInt32(e.CommandArgument);

        //        GridViewRow row = this.gvViewGroups.Rows[index];
        //        long groupId = Convert.ToInt64(row.Cells[0].Text);
        //        groupService.JoinGroup(SessionManager.GetUserSession(Context).UserProfileId, groupId);

        //    }

        //}
    }
}
