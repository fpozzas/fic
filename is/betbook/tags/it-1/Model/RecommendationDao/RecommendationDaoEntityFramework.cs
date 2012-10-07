using System;
using System.Collections.Generic;
using System.Linq;
using Es.Udc.DotNet.ModelUtil.Dao;
using Es.Udc.DotNet.ModelUtil.Log;
using System.Data.Objects;
using System.Data.EntityClient;
using System.Data;
using System.Configuration;


namespace Es.Udc.DotNet.Betbook.Model.RecommendationDao
{
    class RecommendationDaoEntityFramework :
        GenericDaoEntityFramework<Recommendation, Int64>, IRecommendationDao
    {
        #region IRecommendationDao Members

        public List<Recommendation> FindByUserId(long userId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from rec in container.Recommendation
                      from grp in rec.Group
                      from usr in grp.User1
                      where usr.userId == userId
                      select rec).ToList();

                return result;
            }
        }

        #endregion
    }
}
