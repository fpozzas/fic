using System.Collections.Generic;
using Es.Udc.DotNet.Betbook.Model.BetOMaticService;
using Es.Udc.DotNet.Betbook.Model.GroupDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;
using Es.Udc.DotNet.Betbook.Model.RecommendationDao;
using Es.Udc.DotNet.Betbook.Model.FavouriteDao;

namespace Es.Udc.DotNet.Betbook.Model.EventService
{
    public interface IEventService
    {
        IBetOMaticService BetOMaticService { set; }
        IFavouriteDao FavouriteDao { set; }
        IRecommendationDao RecommendationDao { set; }
        IUserDao UserDao { set; }
        IGroupDao GroupDao { set; }

        List<Event> FindEvents(List<string> keywords, int startIndex, int count);
        List<BetType> FindBetTypes();

        void RecommendEvent(long eventId, List<long> groupIds, long userId, global::System.DateTime date);
        List<Recommendation> FindRecommendations(long userId);

        void FavouriteEvent(long eventId, long userId, string name, string comment, global::System.DateTime date);
        List<Favourite> FindUserFavourites(long userId);
        void RemoveFavourite(long favId);
    }
}
