using System.Collections.Generic;
using Es.Udc.DotNet.Betbook.Model.BetOMaticService;
using Es.Udc.DotNet.Betbook.Model.GroupDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;
using Es.Udc.DotNet.Betbook.Model.RecommendationDao;
using Es.Udc.DotNet.Betbook.Model.FavouriteDao;
using System.Xml;

namespace Es.Udc.DotNet.Betbook.Model.EventService
{
    public interface IEventService
    {
        IBetOMaticService BetOMaticService { set; }
        IFavouriteDao FavouriteDao { set; }
        IRecommendationDao RecommendationDao { set; }
        IUserDao UserDao { set; }
        IGroupDao GroupDao { set; }

        /// <exception cref="Exception"/>
        XmlDocument FindEvents(string[] keywords, int startIndex, int count, bool commentInfo);
        /// <exception cref="Exception"/>
        XmlDocument FindBetTypes(long eventId);

        /// <exception cref="InstanceNotFoundException">For userId or any groupId</exception>
        void RecommendEvent(long eventId, string eventName, List<long> groupIds, long userId, global::System.DateTime date, string text);
        List<Recommendation> FindRecommendations(long userId, int startIndex, int count);
        int GetNumberOfRecommendations(long userId);

        /// <exception cref="InstanceNotFoundException">For userId</exception>
        void FavouriteEvent(long eventId, long userId, string name, string comment, global::System.DateTime date);
        List<Favourite> FindUserFavourites(long userId, int startIndex, int count);
        int GetNumberOfUserFavourites(long userId);
        /// <exception cref="InstanceNotFoundException">For favId</exception>
        /// <exception cref="IllegalOperationException">When user does not own the favourite</exception>
        void RemoveFavourite(long favId, long userId);
    }
}
