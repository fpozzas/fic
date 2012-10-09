using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Model.CommentService;
using Es.Udc.DotNet.Betbook.Model.EventService;
using Es.Udc.DotNet.Betbook.Model.GroupService;
using Es.Udc.DotNet.Betbook.Model.UserService;

namespace Es.Udc.DotNet.Betbook.Test
{
    /// <summary>
    ///This is a test class for ICommentServiceTest and is intended
    ///to contain all ICommentServiceTest Unit Tests
    ///</summary>
    [TestClass()]
    public class EventServiceTest
    {
        private static IUnityContainer container;
        private static IUserService UserService;
        private static IEventService EventService;
        private static IGroupService GroupService;
        private const int EVENTID1 = 0;
        private const int EVENTID2 = 0;
        private const string EVENTNAME1 = "Event1";
        private const string EVENTNAME2 = "Event2";
        // Variables used in several tests are initialized here
        TransactionScope transaction;


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes

        //Use ClassInitialize to run code before running the first test in the class
        [ClassInitialize()]
        public static void MyClassInitialize(TestContext testContext)
        {
            container = TestManager.ConfigureUnityContainer("unity");

            UserService = container.Resolve<IUserService>();
            EventService = container.Resolve<IEventService>();
            GroupService = container.Resolve<IGroupService>();
        }

        //Use ClassCleanup to run code after all tests in a class have run
        [ClassCleanup()]
        public static void MyClassCleanup()
        {
            TestManager.ClearUnityContainer(container);
        }

        //Use TestInitialize to run code before running each test
        [TestInitialize()]
        public void MyTestInitialize()
        {
            //TransactionOptions tso = new TransactionOptions();
            //tso.IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted;
            //transaction = new TransactionScope(TransactionScopeOption.Required, tso);
            transaction = new TransactionScope();
        }

        //Use TestCleanup to run code after each test has run
        [TestCleanup()]
        public void MyTestCleanup()
        {
            //transaction.Complete();
            transaction.Dispose();
        }
        #endregion
        [TestMethod()]
        public void FindAndRecommendEventTest()
        {
            /* Create user and groups */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran","Cannon Fodder", user1.userId);
            Group group2 = GroupService.CreateGroup("protoss","Kick Ass", user1.userId);
            GroupService.JoinGroup(user1.userId,group1.groupId);
            
            /* Recommend event */
            DateTime expectedDate = new DateTime(2000, 10, 30, 10, 20, 30);
            List<long> listGroups = new List<long>(){ group1.groupId };
            String description = "description";
            EventService.RecommendEvent(EVENTID1, EVENTNAME1, listGroups, user1.userId, expectedDate, description);

            /* New user joins group with recommendations */
            User user2 = UserService.RegisterUser("tassadar", "4aiur",
                new UserDetails("Tassadar", "Adun", "en@taro.pro", "en", "ES"));
            GroupService.JoinGroup(user2.userId, group1.groupId);

            /* Find recommendations for new user */
            List<Recommendation> foundRecommendations = EventService.FindRecommendations(user2.userId,0,10);
            Assert.AreEqual(1, foundRecommendations.Count);
            Assert.AreEqual(EVENTID1, foundRecommendations[0].eventId);
            Assert.AreEqual(EVENTNAME1, foundRecommendations[0].eventName);
            Assert.AreEqual(0, DateTime.Compare(expectedDate, foundRecommendations[0].date));
            Assert.AreEqual(description, foundRecommendations[0].text);
        }

        [TestMethod()]
        public void CheckPaginationAndOrderFindRecommendationsTest()
        {
            /* Create user1 and groups 1, 2 and 3 */
            /* user1 joins all of them */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", "Cannon Fodder", user1.userId);
            Group group2 = GroupService.CreateGroup("protoss", "Kick Ass", user1.userId);
            Group group3 = GroupService.CreateGroup("zerg", "BRZZZZZZ", user1.userId);
            GroupService.JoinGroup(user1.userId, group1.groupId);
            GroupService.JoinGroup(user1.userId, group2.groupId);
            GroupService.JoinGroup(user1.userId, group3.groupId);
            /* Create user2 joining groups 1 and 2 */
            User user2 = UserService.RegisterUser("tassadar", "4aiur",
                new UserDetails("Tassadar", "Adun", "en@taro.pro", "en", "ES"));
            GroupService.JoinGroup(user2.userId, group1.groupId);
            GroupService.JoinGroup(user2.userId, group2.groupId);
            /* 
             * Create 6 recommendations
             * Date of recommendations is different for each
             */
            DateTime expectedDate1 = new DateTime(1974, 10, 30, 10, 20, 30);
            String expectedRecommendation1 = "Very old recommendation";
            DateTime expectedDate2 = new DateTime(1998, 10, 30, 10, 20, 30);
            String expectedRecommendation2 = "Old recommendation";
            DateTime expectedDate3 = new DateTime(2005, 10, 30, 10, 20, 30);
            String expectedRecommendation3 = "Slightly old recommendation";
            DateTime expectedDate4 = new DateTime(2009, 10, 30, 10, 20, 30);
            String expectedRecommendation4 = "Recent recommendation";
            DateTime expectedDate5 = new DateTime(2009, 10, 30, 10, 20, 35);
            String expectedRecommendation5 = "Most recent recommendation";
            DateTime expectedDate6 = new DateTime(1900, 10, 30, 10, 20, 35);
            String expectedRecommendation6 = "Recommendation not to be found";

            /* 
             * Submit recommendations
             * Submit order (first to last) => 3, 1, 5, 2, 6, 4
             * Comment 1 -> into group 2 (event 1)
             * Comment 2 -> into groups 1 and 2 (event 1)
             * Comment 3 -> into group 1 (event 1)
             * Comment 4 and 5 -> into groups 2 and 3 (event 2)
             * Comment 6 -> intro group 3 (event 2)
             */
            EventService.RecommendEvent(EVENTID1, EVENTNAME1,
                new List<long>(new long[] { group1.groupId }),
                user1.userId, expectedDate3, expectedRecommendation3);
            EventService.RecommendEvent(EVENTID1, EVENTNAME1,
                new List<long>(new long[] { group2.groupId }),
                user1.userId, expectedDate1, expectedRecommendation1);
            EventService.RecommendEvent(EVENTID2, EVENTNAME2,
                new List<long>(new long[] { group2.groupId, group3.groupId }),
                user1.userId, expectedDate5, expectedRecommendation5);
            EventService.RecommendEvent(EVENTID1, EVENTNAME1,
                new List<long>(new long[] { group1.groupId, group2.groupId }),
                user1.userId, expectedDate2, expectedRecommendation2);
            EventService.RecommendEvent(EVENTID2, EVENTNAME2,
                new List<long>(new long[] { group3.groupId }),
                user1.userId, expectedDate6, expectedRecommendation6);
            EventService.RecommendEvent(EVENTID2, EVENTNAME2,
                new List<long>(new long[] { group2.groupId, group3.groupId }),
                user1.userId, expectedDate4, expectedRecommendation4);

            /* Fetch recommendations for user2 (in groups 1 and 2)
             * Number of events per fetch -> 2
             * Recommendation 6 shouldn't be found (only for group 3)
             * Hence if we want to get all events we need to do 3 FindRecommendatios (2+2+1=5)
             * The order should be => 5, 4, 3, 2, 1 (newest to oldest)
             */
            int nComments = 2;
            int startIndex = 0;
            List<Recommendation> foundRecommendations;

            /* First fetch */
            foundRecommendations = EventService.FindRecommendations(user2.userId, startIndex, nComments);
            /* Number of found recommendations (should be 2)*/
            Assert.AreEqual(2, foundRecommendations.Count);
            /* Recommendation 5 */
            Assert.AreEqual(expectedRecommendation5, foundRecommendations[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate5, foundRecommendations[0].date));
            Assert.AreEqual(EVENTID2, foundRecommendations[0].eventId);
            Assert.AreEqual(EVENTNAME2, foundRecommendations[0].eventName);
            Assert.AreEqual(user1.userId, foundRecommendations[0].User.userId);
            /* Recommendation 4 */
            Assert.AreEqual(expectedRecommendation4, foundRecommendations[1].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate4, foundRecommendations[1].date));
            Assert.AreEqual(EVENTID2, foundRecommendations[1].eventId);
            Assert.AreEqual(EVENTNAME2, foundRecommendations[1].eventName);
            Assert.AreEqual(user1.userId, foundRecommendations[1].User.userId);

            /* Second fetch */
            startIndex = startIndex + nComments;
            foundRecommendations = EventService.FindRecommendations(user2.userId, startIndex, nComments);
            /* Number of found recommendations (should be 2)*/
            Assert.AreEqual(2, foundRecommendations.Count);
            /* Recommendation 3 */
            Assert.AreEqual(expectedRecommendation3, foundRecommendations[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate3, foundRecommendations[0].date));
            Assert.AreEqual(EVENTID1, foundRecommendations[0].eventId);
            Assert.AreEqual(EVENTNAME1, foundRecommendations[0].eventName);
            Assert.AreEqual(user1.userId, foundRecommendations[0].User.userId);
            /* Recommendation 2 */
            Assert.AreEqual(expectedRecommendation2, foundRecommendations[1].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate2, foundRecommendations[1].date));
            Assert.AreEqual(EVENTID1, foundRecommendations[1].eventId);
            Assert.AreEqual(EVENTNAME1, foundRecommendations[1].eventName);
            Assert.AreEqual(user1.userId, foundRecommendations[1].User.userId);

            /* Third and last fetch */
            startIndex = startIndex + nComments;
            foundRecommendations = EventService.FindRecommendations(user2.userId, startIndex, nComments);
            /* Number of found recommendations (should be 1)*/
            Assert.AreEqual(1, foundRecommendations.Count);
            /* Recommendation 1 */
            Assert.AreEqual(expectedRecommendation1, foundRecommendations[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate1, foundRecommendations[0].date));
            Assert.AreEqual(EVENTID1, foundRecommendations[0].eventId);
            Assert.AreEqual(EVENTNAME1, foundRecommendations[0].eventName);
            Assert.AreEqual(user1.userId, foundRecommendations[0].User.userId);
        }


        [TestMethod()]
        public void CreateFindRemoveFavouriteTest()
        {   
            /* Creating user and favourite */
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
               new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            String expectedName = "Terran Vs Zerg";
            String expectedComment = "I don't know what to bet";
            DateTime expectedDate = new DateTime(2000, 10, 30, 10, 20, 30);
            EventService.FavouriteEvent(EVENTID1, user.userId, expectedName, expectedComment, expectedDate);

            /* Find user favourites */
            List<Favourite> listFav = EventService.FindUserFavourites(user.userId, 0, 10);
            Assert.AreEqual(1, listFav.Count);
            Favourite actualFavourite = listFav[0];
            Assert.AreEqual(EVENTID1, actualFavourite.eventId);
            Assert.AreEqual(expectedName, actualFavourite.name);
            Assert.AreEqual(expectedComment, actualFavourite.comment);
            Assert.AreEqual(expectedDate, actualFavourite.date);

            /* Remove favourite */
            EventService.RemoveFavourite(actualFavourite.favouriteId,user.userId);
            List<Favourite> listFavRm = EventService.FindUserFavourites(user.userId, 0, 10);
            Assert.AreEqual(0,listFavRm.Count);
        }

        [TestMethod()]
        public void PaginationOrderViewFavouritesTest()
        {
            /* Creating user and favourite */
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
               new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* 
             * Create 6 favourites
             */
            String expectedName1 = "AMyAlias1";
            DateTime expectedDate1 = new DateTime(1974, 10, 30, 10, 20, 30);
            String expectedComment1 = "Very old fav";
            String expectedName2 = "RepeatedAlias";
            DateTime expectedDate2 = new DateTime(1998, 10, 30, 10, 20, 30);
            String expectedComment2 = "Old fav";
            String expectedName3 = "RepeatedAlias";
            DateTime expectedDate3 = new DateTime(2005, 10, 30, 10, 20, 30);
            String expectedComment3 = "Slightly old fav";
            String expectedName4 = "ZMyAlias4";
            DateTime expectedDate4 = new DateTime(2009, 10, 30, 10, 20, 30);
            String expectedComment4 = "Recent fav";
            String expectedName5 = "MyAlias5";
            DateTime expectedDate5 = new DateTime(2009, 10, 30, 10, 20, 35);
            String expectedComment5 = "Most recent fav";
            /*
             * Add to favourites in order (not relevant): 5-2-1-4-3
             */
            EventService.FavouriteEvent(EVENTID2, user.userId, expectedName5, expectedComment5, expectedDate5);
            EventService.FavouriteEvent(EVENTID2, user.userId, expectedName2, expectedComment2, expectedDate2);
            EventService.FavouriteEvent(EVENTID2, user.userId, expectedName1, expectedComment1, expectedDate1);
            EventService.FavouriteEvent(EVENTID2, user.userId, expectedName4, expectedComment4, expectedDate4);
            EventService.FavouriteEvent(EVENTID2, user.userId, expectedName3, expectedComment3, expectedDate3);
            
            /* Fetch recommendations for user2
             * Number of events per fetch -> 2
             * Hence if we want to get all events we need to do 3 FindFavourites (2+2+1=5)
             * The order should be => 1, 5, 2, 3, 4 (alphabetically, then favouriteId)
             */
            int nComments = 2;
            int startIndex = 0;
            List<Favourite> foundFavourites;
            /* First fetch */
            foundFavourites = EventService.FindUserFavourites(user.userId, startIndex, nComments);
            /* Number of found recommendations (should be 2)*/
            Assert.AreEqual(2, foundFavourites.Count);
            /* Favourite 1 */
            Assert.AreEqual(expectedName1, foundFavourites[0].name);
            Assert.AreEqual(expectedComment1, foundFavourites[0].comment);
            Assert.AreEqual(0, DateTime.Compare(expectedDate1, foundFavourites[0].date));
            Assert.AreEqual(EVENTID2, foundFavourites[0].eventId);
            /* Favourite 5 */
            Assert.AreEqual(expectedName5, foundFavourites[1].name);
            Assert.AreEqual(expectedComment5, foundFavourites[1].comment);
            Assert.AreEqual(0, DateTime.Compare(expectedDate5, foundFavourites[1].date));
            Assert.AreEqual(EVENTID2, foundFavourites[1].eventId);
            /* Second fetch */
            startIndex = startIndex + nComments;
            foundFavourites = EventService.FindUserFavourites(user.userId, startIndex, nComments);
            /* Number of found recommendations (should be 2)*/
            Assert.AreEqual(2, foundFavourites.Count);
            /* Favourite 2 */
            Assert.AreEqual(expectedName2, foundFavourites[0].name);
            Assert.AreEqual(expectedComment2, foundFavourites[0].comment);
            Assert.AreEqual(0, DateTime.Compare(expectedDate2, foundFavourites[0].date));
            Assert.AreEqual(EVENTID2, foundFavourites[0].eventId);
            /* Favourite 3 */
            Assert.AreEqual(expectedName3, foundFavourites[1].name);
            Assert.AreEqual(expectedComment3, foundFavourites[1].comment);
            Assert.AreEqual(0, DateTime.Compare(expectedDate3, foundFavourites[1].date));
            Assert.AreEqual(EVENTID2, foundFavourites[1].eventId);
            /* Third fetch */
            startIndex = startIndex + nComments;
            foundFavourites = EventService.FindUserFavourites(user.userId, startIndex, nComments);
            /* Number of found recommendations (should be 1)*/
            Assert.AreEqual(1, foundFavourites.Count);
            /* Favourite 4 */
            Assert.AreEqual(expectedName4, foundFavourites[0].name);
            Assert.AreEqual(expectedComment4, foundFavourites[0].comment);
            Assert.AreEqual(0, DateTime.Compare(expectedDate4, foundFavourites[0].date));
            Assert.AreEqual(EVENTID2, foundFavourites[0].eventId);
        }


    }
}
