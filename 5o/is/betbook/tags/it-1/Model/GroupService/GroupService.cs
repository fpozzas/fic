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
        [Transactional]
        public Group CreateGroup(String groupName, long creatorId)
        {
            Group group = Group.CreateGroup(0, groupName);
            group.User = UserDao.Find(creatorId);
            GroupDao.Create(group);
            return group;
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

        /// <exception cref="InstanceNotFoundException"/>
        public List<Group> FindUserGroups(long userId)
        {
            return GroupDao.FindByUserId(userId);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void JoinGroup(long userId, long groupId)
        {
            User user = UserDao.Find(userId);
            Group group = GroupDao.Find(groupId);

            group.User1.Add(user);

            GroupDao.Update(group);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void LeaveGroup(long userId, long groupId)
        {
            Group group = GroupDao.Find(groupId);
            group.User1.Remove(UserDao.Find(userId));
            GroupDao.Update(group);
        }


        #endregion
    }
}
