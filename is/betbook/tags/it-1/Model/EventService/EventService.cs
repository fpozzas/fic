using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.ModelUtil.Transactions;
using Es.Udc.DotNet.Betbook.Model.BetOMaticService;
using Es.Udc.DotNet.Betbook.Model.FavouriteDao;
using Es.Udc.DotNet.Betbook.Model.RecommendationDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;
using Es.Udc.DotNet.Betbook.Model.GroupDao;

namespace Es.Udc.DotNet.Betbook.Model.EventService
{
    class EventService: IEventService
    {
        [Dependency]
        public IBetOMaticService BetOMaticService { private get; set; }
        [Dependency]
        public IFavouriteDao FavouriteDao { private get; set; }
        [Dependency]
        public IRecommendationDao RecommendationDao { private get; set; }
        [Dependency]
        public IUserDao UserDao { private get; set; }
        [Dependency]
        public IGroupDao GroupDao { private get; set; }


        #region IEventService Members

        public List<Event> FindEvents(List<string> keywords, int startIndex, int count)
        {
            return BetOMaticService.FindEvents(keywords, startIndex, count);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void RecommendEvent(long eventId, List<long> groupIds, long userId, global::System.DateTime date)
        {
            Recommendation recommendation = Recommendation.CreateRecommendation(0, eventId, date);
            recommendation.eventId = eventId;
            recommendation.User = UserDao.Find(userId);
            foreach (long groupId in groupIds)
            {
                recommendation.Group.Add(GroupDao.Find(groupId));
            }

            RecommendationDao.Create(recommendation);
        }

        /// <exception cref="InstanceNotFoundException"/>
        public List<Recommendation> FindRecommendations(long userId)
        {
            return RecommendationDao.FindByUserId(userId);
        }


        public List<BetType> FindBetTypes()
        {
            return BetOMaticService.FindBetTypes();
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void FavouriteEvent(long eventId, long userId, string name, string comment, global::System.DateTime date)
        {
            Favourite favourite = Favourite.CreateFavourite(0, date, eventId);
            favourite.eventId = eventId;
            favourite.comment = comment;
            favourite.name = name;
            favourite.User = UserDao.Find(userId);

            FavouriteDao.Create(favourite);
        }

        public List<Favourite> FindUserFavourites(long userId)
        {
            return FavouriteDao.FindByUserId(userId);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void RemoveFavourite(long favId)
        {
            FavouriteDao.Remove(favId);
        }

        #endregion
    }
}
