using System;
using System.Collections.Generic;
using System.Linq;
using Es.Udc.DotNet.ModelUtil.Dao;
using Es.Udc.DotNet.ModelUtil.Log;
using System.Data.Objects;
using System.Data.EntityClient;
using System.Data;
using System.Configuration;


namespace Es.Udc.DotNet.Betbook.Model.FavouriteDao
{
    class FavouriteDaoEntityFramework :
        GenericDaoEntityFramework<Favourite, Int64>, IFavouriteDao
    {
        #region IFavouriteDao Members

        public List<Favourite> FindByUserId(long userId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from fav in container.Favourite
                      where fav.User.userId == userId
                      select fav).ToList();

                return result;
            }
        }

        #endregion
    }
}
