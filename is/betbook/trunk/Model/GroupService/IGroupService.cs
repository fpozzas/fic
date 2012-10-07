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

        /// <exception cref="InstanceNotFoundException">For creatorId</exception>
        /// <exception cref="AlreadyExistingGroupException"/>
        Group CreateGroup(String groupName, String groupDesc, long creatorId);

        /// <exception cref="InstanceNotFoundException"/>
        Group FindGroup(long groupId);

        List<Group> FindAllGroups();

        List<Group> FindUserGroups(long userId);

        /// <exception cref="InstanceNotFoundException">For userId and groupId</exception>
        /// <exception cref="AlreadyOnGroupException"/>
        void JoinGroup(long userId, long groupId);

        /// <exception cref="InstanceNotFoundException">For userId and groupId</exception>
        void LeaveGroup(long userId, long groupId);
    }
}
