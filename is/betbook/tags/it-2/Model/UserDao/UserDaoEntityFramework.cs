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


namespace Es.Udc.DotNet.Betbook.Model.UserDao
{
    class UserDaoEntityFramework :
        GenericDaoEntityFramework<User, Int64>, IUserDao
    {

        public UserDaoEntityFramework() { }

        #region IUserDao Members

        public User FindByLoginName(string login)
        {
            User user = null;

            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from u in container.User
                      where u.login == login
                      select u);

                if (result.Count<User>() > 0)
                    user = result.First<User>();

            }

            if (user == null)
                throw new InstanceNotFoundException(login, typeof(User).FullName);

            return user;
        }

        #endregion
    }
}
