using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Dao;

namespace Es.Udc.DotNet.Betbook.Model.FavouriteDao
{
    public interface IFavouriteDao : IGenericDao<Favourite, Int64>
    {
        List<Favourite> FindByUserId(long userId, int startIndex, int count);
        int GetNumberByUserId(long userId);
    }
}
