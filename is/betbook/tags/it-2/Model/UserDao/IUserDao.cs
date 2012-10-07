using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Dao;

namespace Es.Udc.DotNet.Betbook.Model.UserDao
{
    public interface IUserDao : IGenericDao<User, Int64>
    {
        /// <exception cref="InstanceNotFoundException"/>
        User FindByLoginName(string login);
    }
}
