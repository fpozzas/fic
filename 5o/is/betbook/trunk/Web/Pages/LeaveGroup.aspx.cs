using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.GroupService;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.ModelUtil.Exceptions;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class LeaveGroup : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            long groupId = Convert.ToInt32(Request.Params.Get("groupId"));

            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IGroupService groupService = container.Resolve<IGroupService>();

            try
            {
                groupService.LeaveGroup(SessionManager.GetUserSession(Context).UserProfileId, groupId);
                lblLeaveResult.Text = GetLocalResourceObject("LeaveGroupSuccesful").ToString() + " " + groupService.FindGroup(groupId).name + "!";
            }
            catch (InstanceNotFoundException)
            {
                lblLeaveResult.Text = GetLocalResourceObject("LeaveGroupUnsuccesful").ToString();
            }
        }
    }
}
