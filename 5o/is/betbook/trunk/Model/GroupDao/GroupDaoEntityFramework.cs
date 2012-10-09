using System;
using System.Collections.Generic;
using System.Linq;
using Es.Udc.DotNet.ModelUtil.Dao;
using Es.Udc.DotNet.ModelUtil.Log;
using System.Data.Objects;
using System.Data.EntityClient;
using System.Data;
using System.Configuration;
using Es.Udc.DotNet.ModelUtil.Exceptions;


namespace Es.Udc.DotNet.Betbook.Model.GroupDao
{
    class GroupDaoEntityFramework :
        GenericDaoEntityFramework<Group, Int64>, IGroupDao
    {
        #region IGroupDao Members

        public List<Group> FindByUserId(long userId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from user in container.User
                      from the_group in user.Group1
                      where user.userId == userId
                      select the_group).ToList();

                foreach (var c in result)
                {
                    c.UserReference.Load();
                    c.User1.Load();
                }
                return result;
            }
        }

        public List<Group> FindAll()
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from the_group in container.Group
                      select the_group).ToList();

                foreach (var c in result)
                {   
                    c.UserReference.Load();
                    c.User1.Load();
                }
                return result;
            }
        }

        /// <exception cref="InstanceNotFoundException"/>
        public Group FindByGroupName(string groupName)
        {
            Group group = null;

            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from u in container.Group
                      where u.name == groupName
                      select u);

                if (result.Count<Group>() > 0)
                    group = result.First<Group>();

            }

            if (group == null)
                throw new InstanceNotFoundException(groupName, typeof(Group).FullName);

            return group;
        }

        #endregion
    }
}
