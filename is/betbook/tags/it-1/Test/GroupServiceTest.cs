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
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group actual = GroupService.CreateGroup("protoss", user.userId);
            Group expected = GroupService.FindGroup(actual.groupId);

            Assert.AreEqual(expected.groupId, actual.groupId);
            Assert.AreEqual(expected.name, actual.name);
        }

        [TestMethod()]
        public void FindAllGroupsTest()
        {
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", user1.userId);
            List<Group> foundGroups;

            foundGroups = GroupService.FindAllGroups();
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);

            User user2 = UserService.RegisterUser("tassadar", "4aiur",
                new UserDetails("Tassadar", "Adun", "en@taro.pro", "en", "ES"));
            Group group2 = GroupService.CreateGroup("protoss", user2.userId);

            foundGroups = GroupService.FindAllGroups();
            Assert.AreEqual(2, foundGroups.Count);
        }

        [TestMethod()]
        public void FindUserGroupsTest()
        {
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", user1.userId);
            List<Group> foundGroups;

            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(0, foundGroups.Count);

            GroupService.JoinGroup(user1.userId, group1.groupId);

            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);

            Group group2 = GroupService.CreateGroup("protoss", user1.userId);

            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);

            GroupService.JoinGroup(user1.userId, group2.groupId);

            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(2, foundGroups.Count);
        }


        [TestMethod()]
        public void JoinLeaveGroupTest()
        {
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            Group group1 = GroupService.CreateGroup("terran", user1.userId);
            List<Group> foundGroups;

            //Assert.AreEqual(0,user1.Group1.Count);
            /* foundGroups = CommentService.FindUserGroups(user1.userId);
            Assert.AreEqual(0, foundGroups.Count);
            */
            GroupService.JoinGroup(user1.userId, group1.groupId);
            //user1 = UserService.FindUser(user1.userId);
            //user1.Group1.ToList();
            Assert.AreEqual(1, user1.Group.Count);
            Assert.AreEqual(1, user1.Group1.Count);
            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(1, foundGroups.Count);
            Assert.AreEqual(group1.groupId, foundGroups[0].groupId);

            GroupService.LeaveGroup(user1.userId, group1.groupId);

            foundGroups = GroupService.FindUserGroups(user1.userId);
            Assert.AreEqual(0, foundGroups.Count);
        }
    }
}
