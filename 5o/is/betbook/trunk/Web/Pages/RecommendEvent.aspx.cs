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
using Es.Udc.DotNet.Betbook.Model.EventService;
using Es.Udc.DotNet.Betbook.Web.Properties;
using System.Data;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class RecommendEvent : SpecificCulturePage
    {
        protected void Page_Load(Object sender, EventArgs e)
        {
            /* Get the Service */
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IGroupService groupService = container.Resolve<IGroupService>();


            if (SessionManager.IsUserAuthenticated(Context))
            {
                List<Group> userGroups = groupService.FindUserGroups(SessionManager.GetUserSession(Context).UserProfileId);

                lblNoUserGroups.Visible = false;
                if (userGroups.Count == 0)
                {
                    lblNoUserGroups.Visible = true;
                    form.Visible = false;
                    return;
                }
                this.gvShowUserGroups.DataSource = userGroups;
                this.gvShowUserGroups.DataBind();
            }


        }

        protected void btnRecommend_Click(object sender, EventArgs e)
        {
            List<long> groupIds = new List<long>();

            // Select the checkboxes from the GridView control
            for (int i = 0; i < gvShowUserGroups.Rows.Count; i++)
            {
                GridViewRow row = gvShowUserGroups.Rows[i];
                CheckBox checkBox = (CheckBox)row.Cells[2].FindControl("chkSelect");

                if (checkBox.Checked)
                {
                    long groupId = Int64.Parse(gvShowUserGroups.DataKeys[i].Value.ToString());
                    groupIds.Add(groupId);
                }
            }
            if (groupIds.Count == 0)
            {
                lblNoGroupsSelected.Visible = true;
            }
            else
            {
                /* Get the Service */
                IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
                IEventService eventService = container.Resolve<IEventService>();

                long eventId = Convert.ToInt64(Request.Params.Get("eventId"));
                string eventName = Request.Params.Get("eventName");
                long userId = SessionManager.GetUserSession(Context).UserProfileId;

                eventService.RecommendEvent(eventId, eventName, groupIds, userId, DateTime.Now, txtareaRecommendationDesc.Value);


                String url = Settings.Default.Betbook_applicationURL + "/Pages/EventRecommended.aspx";
                Response.Redirect(Response.ApplyAppPathModifier(url));

            }
        }
    }

}
