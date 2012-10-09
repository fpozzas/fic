using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.Betbook.Model.GroupService;
using Es.Udc.DotNet.Betbook.Model.CommentService;

namespace Es.Udc.DotNet.Betbook.Test
{
    /// <summary>
    ///This is a test class for ICommentServiceTest and is intended
    ///to contain all ICommentServiceTest Unit Tests
    ///</summary>
    [TestClass()]
    public class GroupServiceTest
    {
        private static IUnityContainer container;
        private static IUserService UserService;
        private static IGroupService GroupService;
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
        public void CreateGroupTest()
        {
            /* Create user */
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Create group with user as creator */
            Group actual = GroupService.CreateGroup("protoss", "KickAss", user.userId);
            /* Find group */
            Group expected = GroupService.FindGroup(actual.groupId);

            Assert.AreEqual(expected.groupId, actual.groupId);
            Assert.AreEqual(expected.name, actual.name);
            Assert.AreEqual(expected.description, actual.description);
            Assert.AreEqual(user.userId, actual.User.userId);
        }

        [TestMethod()]
        [ExpectedException(typeof(AlreadyExistingGroupException))]
        public void AlreadyExistingGroupExceptionTest()
        {
            /* Create user */
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Create group with user as creator */
            Group group1 = GroupService.CreateGroup("protoss", "KickAss", user.userId);
            /* Create group with name exactly like the previous */
            Group group2 = GroupService.CreateGroup("protoss", "Doppelganger!", user.userId); // Exception
        }

        [TestMethod()]
        public void FindAllGroupsTest()
        {
            /* Create user */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            
            /* Create first group */
            Group group1 = GroupService.CreateGroup("terran","CannonFodder", user1.userId);
            List<Group> foundGroups;

            /* Find all groups (should be one group) */
            foundGroups = GroupService.FindAllGroups();
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);
            Assert.AreEqual(group1.name,foundGroups[0].name);
            Assert.AreEqual(group1.description, foundGroups[0].description);
            Assert.AreEqual(user1.userId, foundGroups[0].User.userId);

            /* Create second group */
            User user2 = UserService.RegisterUser("tassadar", "4aiur",
                new UserDetails("Tassadar", "Adun", "en@taro.pro", "en", "ES"));
            Group group2 = GroupService.CreateGroup("protoss","Kick Ass", user2.userId);

            /* Find all groups (should be two groups) */
            foundGroups = GroupService.FindAllGroups();
            Assert.AreEqual(2, foundGroups.Count);
            Assert.AreEqual(group2.groupId, foundGroups[1].groupId);
            Assert.AreEqual(group2.name, foundGroups[1].name);
            Assert.AreEqual(group2.description, foundGroups[1].description);
            Assert.AreEqual(user2.userId, foundGroups[1].User.userId);
        }

        [TestMethod()]
        public void FindUserGroupsTest()
        {
            /* Create user and group */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran","Cannon Fodder", user1.userId);
            List<Group> foundGroups;

            /* Find user groups (should be zero right now) */
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(0, foundGroups.Count);

            /* User joins group */
            GroupService.JoinGroup(user1.userId, group1.groupId);

            /* Find user groups (should be one) */
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);
            Assert.AreEqual(group1.name, foundGroups[0].name);
            Assert.AreEqual(group1.description, foundGroups[0].description);
            Assert.AreEqual(user1.userId, foundGroups[0].User.userId);

            /* Create second group with the same user */
            Group group2 = GroupService.CreateGroup("protoss","Kick Ass", user1.userId);

            /* Find users groups (should be one) */
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);
            Assert.AreEqual(group1.name, foundGroups[0].name);
            Assert.AreEqual(group1.description, foundGroups[0].description);
            Assert.AreEqual(user1.userId, foundGroups[0].User.userId);

            /* User joins second group */
            GroupService.JoinGroup(user1.userId, group2.groupId);

            /* Find users groups (should be two) */
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(2, foundGroups.Count);
            Assert.AreEqual(group2.groupId, foundGroups[1].groupId);
            Assert.AreEqual(group2.name, foundGroups[1].name);
            Assert.AreEqual(group2.description, foundGroups[1].description);
            Assert.AreEqual(user1.userId, foundGroups[1].User.userId);
        }


        [TestMethod()]
        public void JoinLeaveGroupTest()
        {
            /* Create user and group */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", "Cannon Fodder", user1.userId);
            List<Group> foundGroups;

            /* User is group creator but didn't joined it for now */
            Assert.AreEqual(1, user1.Group.Count);
            Assert.AreEqual(0, user1.Group1.Count);
            /* User joins group */
            GroupService.JoinGroup(user1.userId, group1.groupId);
            Assert.AreEqual(1, user1.Group.Count);
            Assert.AreEqual(1, user1.Group1.Count);
            /* Find user groups (should be one) */
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);

            /* User leaves group */
            GroupService.LeaveGroup(user1.userId, group1.groupId);

            Assert.AreEqual(1, user1.Group.Count);
            Assert.AreEqual(0, user1.Group1.Count);
            /* Find user groups (should be zero) */
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(0, foundGroups.Count);
        }

        [TestMethod()]
        [ExpectedException(typeof(AlreadyOnGroupException))]
        public void AlreadyOnGroupExceptionTest()
        {
            /* Create user and group */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", "Cannon Fodder", user1.userId);
            List<Group> foundGroups;

            /* User joins group */
            GroupService.JoinGroup(user1.userId, group1.groupId);
            Assert.AreEqual(1, user1.Group.Count);
            Assert.AreEqual(1, user1.Group1.Count);
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);

            /* User attemps to join group again */
            GroupService.JoinGroup(user1.userId, group1.groupId); // Exception
        }
    }
}
