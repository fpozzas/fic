using System;
using System.Collections.Generic;
using System.Linq;
using Es.Udc.DotNet.ModelUtil.Dao;
using Es.Udc.DotNet.ModelUtil.Log;
using System.Data.Objects;
using System.Data.EntityClient;
using System.Data;
using System.Configuration;


namespace Es.Udc.DotNet.Betbook.Model.GroupDao
{
    class GroupDaoEntityFramework :
        GenericDaoEntityFramework<Group, Int64>, IGroupDao
    {
        #region IGroupDao Members

        List<Group> IGroupDao.FindByUserId(long userId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from user in container.User
                      from the_group in user.Group1
                      where user.userId == userId
                      select the_group).ToList();

                return result;
            }
        }

        List<Group> IGroupDao.FindAll()
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from the_group in container.Group
                      select the_group).ToList();

                return result;
            }
        }

        #endregion
    }
}
