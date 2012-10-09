using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Dao;

namespace Es.Udc.DotNet.Betbook.Model.GroupDao
{
    public interface IGroupDao : IGenericDao<Group, Int64>
    {
        List<Group> FindByUserId(long userId);
        
        List<Group> FindAll();
    }
}
