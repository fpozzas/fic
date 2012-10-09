using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Log;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.Betbook.Model;
using System.Globalization;
using Es.Udc.DotNet.Betbook.Model.GroupService;
using System.Data.SqlClient;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class CreateGroup : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblCreateGroupError.Visible = false;
        }

        protected void btnCreateGroup_Click(object sender, EventArgs e)
        {   
            /* Create group */
            string groupName = txtGroupName.Text;
            string groupDesc = txtareaGroupDesc.Value;

            /* Get the Service */
            IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
            IGroupService groupService = container.Resolve<IGroupService>();

            UserSession userSession = SessionManager.GetUserSession(Context);
            try
            {
                Group group = groupService.CreateGroup(groupName, groupDesc, userSession.UserProfileId);
                LogManager.RecordMessage("Group " + group.groupId + " (" + group.name + ") created.", LogManager.MessageType.INFO);

                Server.Transfer(Response.ApplyAppPathModifier("./GroupCreated.aspx"));
            }
            catch (AlreadyExistingGroupException)
            {
                lblCreateGroupError.Visible = true;
            }
        }
    }
}
