using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.ModelUtil.Transactions;
using Es.Udc.DotNet.Betbook.Model.UserDao;
using Es.Udc.DotNet.Betbook.Model.GroupDao;

namespace Es.Udc.DotNet.Betbook.Model.GroupService
{
    class GroupService: IGroupService
    {
        [Dependency]
        public IUserDao UserDao { private get; set; }
        [Dependency]
        public IGroupDao GroupDao { private get; set; }


        #region IGroupService Members

        /// <exception cref="InstanceNotFoundException"/>
        /// <exception cref="AlreadyExistingGroupException"/>
        [Transactional]
        public Group CreateGroup(String groupName, String groupDesc, long creatorId)
        {
            try
            {
                GroupDao.FindByGroupName(groupName);
                // Group already exists
                throw new AlreadyExistingGroupException(groupName);
            }
            catch (InstanceNotFoundException)
            {
                Group group = Group.CreateGroup(0, groupName);
                group.description = groupDesc;
                group.User = UserDao.Find(creatorId);
                GroupDao.Create(group);
                return group;
            }
        }

        /// <exception cref="InstanceNotFoundException"/>
        public Group FindGroup(long groupId)
        {
            return GroupDao.Find(groupId);
        }

        public List<Group> FindAllGroups()
        {
            return GroupDao.FindAll();
        }

        public List<Group> FindUserGroups(long userId)
        {
            return GroupDao.FindByUserId(userId);
        }

        /// <exception cref="InstanceNotFoundException"/>
        /// <exception cref="AlreadyOnGroupException"/>
        [Transactional]
        public void JoinGroup(long userId, long groupId)
        {
            User user = UserDao.Find(userId);
            Group group = GroupDao.Find(groupId);

            foreach (Group g in user.Group1)
            {
                if (g.groupId == group.groupId)
                    throw new AlreadyOnGroupException(user.userId,group.groupId);
            }
            group.User1.Add(user);

            GroupDao.Update(group);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void LeaveGroup(long userId, long groupId)
        {
            Group group = GroupDao.Find(groupId);
            group.User1.Load();
            group.User1.Remove(UserDao.Find(userId));
            GroupDao.Update(group);
        }


        #endregion
    }
}
