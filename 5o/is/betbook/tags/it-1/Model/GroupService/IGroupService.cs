using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Es.Udc.DotNet.Betbook.Model.GroupDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;

namespace Es.Udc.DotNet.Betbook.Model.GroupService
{
    public interface IGroupService
    {
        IUserDao UserDao { set; }
        IGroupDao GroupDao { set; }

        Group CreateGroup(String groupName, long creatorId);
        Group FindGroup(long groupId);
        List<Group> FindAllGroups();
        List<Group> FindUserGroups(long userId);

        void JoinGroup(long userId, long groupId);
        void LeaveGroup(long userId, long groupId);
    }
}
