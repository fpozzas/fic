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

        [TestMethod()]
        public void FindAndRecommendEventTest()
        {
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", user1.userId);
            Group group2 = GroupService.CreateGroup("protoss", user1.userId);
            GroupService.JoinGroup(user1.userId,group1.groupId);
            
            DateTime expectedDate = new DateTime(2000, 10, 30, 10, 20, 30);
            List<long> listGroups = new List<long>(){ group1.groupId };
            EventService.RecommendEvent(EVENTID1, listGroups, user1.userId, expectedDate);

            User user2 = UserService.RegisterUser("tassadar", "4aiur",
                new UserDetails("Tassadar", "Adun", "en@taro.pro", "en", "ES"));
            GroupService.JoinGroup(user2.userId, group1.groupId);

            List<Recommendation> foundRecommendations = EventService.FindRecommendations(user2.userId);
            Assert.AreEqual(1, foundRecommendations.Count);
            Assert.AreEqual(EVENTID1, foundRecommendations[0].eventId);
            Assert.AreEqual(0, DateTime.Compare(expectedDate, foundRecommendations[0].date));
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

            /* Testing find user favourites */
            List<Favourite> listFav = EventService.FindUserFavourites(user.userId);
            Assert.AreEqual(1, listFav.Count);
            Favourite actualFavourite = listFav[0];
            Assert.AreEqual(EVENTID1, actualFavourite.eventId);
            Assert.AreEqual(expectedName, actualFavourite.name);
            Assert.AreEqual(expectedComment, actualFavourite.comment);
            Assert.AreEqual(expectedDate, actualFavourite.date);

            /* Testing remove favourite */
            EventService.RemoveFavourite(actualFavourite.favouriteId);
            List<Favourite> listFavRm = EventService.FindUserFavourites(user.userId);
            Assert.AreEqual(0,listFavRm.Count);
        }

        #endregion
    }
}
