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

        public List<Recommendation> FindByUserId(long userId, int startIndex, int count)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from rec in container.Recommendation
                      from grp in rec.Group
                      from usr in grp.User1
                      where usr.userId == userId
                      select rec).Distinct().OrderByDescending(rec => rec.date).
                        ThenBy(rec => rec.recId).Skip(startIndex).Take(count).ToList();

                foreach (var c in result)
                {
                    c.UserReference.Load();
                    c.Group.Load();
                }
                return result;
            }
        }

        public int GetNumberByUserId(long userId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from rec in container.Recommendation
                      from grp in rec.Group
                      from usr in grp.User1
                      where usr.userId == userId
                      select rec).Distinct().Count();
                return result;
            }
        }

        #endregion
    }
}
