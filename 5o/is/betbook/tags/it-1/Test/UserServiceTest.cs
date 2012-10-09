using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.Betbook.Model.UserService.Exceptions;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Es.Udc.DotNet.Betbook.Model.UserService;

namespace Es.Udc.DotNet.Betbook.Test
{
    /// <summary>
    ///This is a test class for IUserServiceTest and is intended
    ///to contain all IUserServiceTest Unit Tests
    ///</summary>
    [TestClass()]
    public class UserServiceTest
    {
        private static IUnityContainer container;
        private static IUserService UserService;

        // Variables used in several tests are initialized here
        private const long NON_EXISTENT_User_ID = -1;
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
            transaction = new TransactionScope();
        }

        //Use TestCleanup to run code after each test has run
        [TestCleanup()]
        public void MyTestCleanup()
        {
            transaction.Dispose();
        }

        #endregion


        [TestMethod()]
        public void CreateUserTest()
        {
            User actual = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            User expected = UserService.FindUser(actual.userId);

            Assert.AreEqual(expected.userId, actual.userId);
            Assert.AreEqual(expected.login, actual.login);
            Assert.AreEqual(expected.encPassword, actual.encPassword);
            Assert.AreEqual(expected.name, actual.name);
        }

        [TestMethod()]
        public void FindUserTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            User actual = UserService.FindUser(expected.userId);

            Assert.AreEqual(expected.userId, actual.userId);
            Assert.AreEqual(expected.login, actual.login);
            Assert.AreEqual(expected.encPassword, actual.encPassword);
            Assert.AreEqual(expected.name, actual.name);
        }

        [TestMethod()]
        public void FindUserDetailsTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            UserDetails actual = UserService.FindUserDetails(expected.userId);

            Assert.AreEqual(expected.name, actual.name);
            Assert.AreEqual(expected.surname, actual.surname);
            Assert.AreEqual(expected.email, actual.email);
            Assert.AreEqual(expected.countryCode, actual.countryCode);
            Assert.AreEqual(expected.languageCode, actual.languageCode);
        }
        [TestMethod()]
        [ExpectedException(typeof(InstanceNotFoundException))]
        public void FindNonExistentUserTest()
        {
            User actual =
                UserService.FindUser(NON_EXISTENT_User_ID);
        }

        [TestMethod()]
        public void UpdateUserDetailsTest()
        {
            User oldUser = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            
            UserDetails expected = new UserDetails("Alfonsito", "Lopes", "tomate@noesmicontraseña.com", "es", "MX");
            UserService.UpdateUserDetails(oldUser.userId, expected);

            User actual = UserService.FindUser(oldUser.userId);

            Assert.AreEqual(expected.name, actual.name);
            Assert.AreEqual(expected.surname, actual.surname);
            Assert.AreEqual(expected.email, actual.email);
        }

        [TestMethod()]
        public void LoginSuccessTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            LoginResult actual = UserService.Login(expected.login, "born2pwn", false);
            Assert.AreEqual(expected.userId, actual.UserId);
        }

        [TestMethod()]
        [ExpectedException(typeof(IncorrectPasswordException))]
        public void LoginFailTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            LoginResult actual = UserService.Login(expected.login, "born2lol", false);
        }

        [TestMethod()]
        [ExpectedException(typeof(InstanceNotFoundException))]
        public void MeantNotToBeLoginTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            LoginResult actual = UserService.Login("kerrigon", "born2pwn", false);
        }

        [TestMethod()]
        public void ChangePasswordTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            UserService.ChangePassword(expected.userId, "born2pwn", "born2lol");
            LoginResult actual = UserService.Login(expected.login, "born2lol", false);
            Assert.AreEqual(expected.userId, actual.UserId);
        }

    }
}
