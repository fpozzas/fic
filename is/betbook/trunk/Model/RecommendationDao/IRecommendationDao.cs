using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Dao;

namespace Es.Udc.DotNet.Betbook.Model.RecommendationDao
{
    public interface IRecommendationDao : IGenericDao<Recommendation, Int64>
    {
        List<Recommendation> FindByUserId(long userId, int startIndex, int count);

        int GetNumberByUserId(long userId);
    }
}
