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
using System.Xml;

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

        /// <exception cref="Exception"/>
        public XmlDocument FindEvents(string[] keywords, int startIndex, int count, bool commentInfo)
        {
            return BetOMaticService.FindEvents(keywords, startIndex, count, commentInfo);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void RecommendEvent(long eventId, string eventName, List<long> groupIds, long userId, global::System.DateTime date, string text)
        {
            Recommendation recommendation = Recommendation.CreateRecommendation(0, eventId, eventName, date);
            recommendation.text = text;
            recommendation.User = UserDao.Find(userId);
            foreach (long groupId in groupIds)
            {
                recommendation.Group.Add(GroupDao.Find(groupId));
            }

            RecommendationDao.Create(recommendation);
        }

        public List<Recommendation> FindRecommendations(long userId, int startIndex, int count)
        {
            return RecommendationDao.FindByUserId(userId, startIndex, count);
        }

        public int GetNumberOfRecommendations(long userId)
        {
            return RecommendationDao.GetNumberByUserId(userId);
        }

        /// <exception cref="Exception"/>
        public XmlDocument FindBetTypes(long eventId)
        {
            return BetOMaticService.FindBetTypes(eventId);
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

        public List<Favourite> FindUserFavourites(long userId, int startIndex, int count)
        {
            return FavouriteDao.FindByUserId(userId, startIndex, count);
        }

        public int GetNumberOfUserFavourites(long userId)
        {
            return FavouriteDao.GetNumberByUserId(userId);
        }
        /// <exception cref="InstanceNotFoundException"/>
        /// <exception cref="IllegalOperationException"/>
        [Transactional]
        public void RemoveFavourite(long favId, long userId)
        {
            Favourite fav = FavouriteDao.Find(favId);
            fav.UserReference.Load();
            if (userId != fav.User.userId)
                throw new IllegalOperationException("User doesn't own favourite");
            FavouriteDao.Remove(favId);
        }

        #endregion
    }
}
