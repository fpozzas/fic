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
        public void CreateAndFindUserTest()
        {
            /* Register new user */
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Find created user */
            User actual = UserService.FindUser(expected.userId);

            Assert.AreEqual(expected.userId, actual.userId);
            Assert.AreEqual(expected.login, actual.login);
            Assert.AreEqual(expected.encPassword, actual.encPassword);
            Assert.AreEqual(expected.name, actual.name);
        }

        [TestMethod()]
        public void FindUserDetailsTest()
        {
            /* Create user */
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            
            /* Find user details */
            UserDetails actual = UserService.FindUserDetails(expected.userId);

            Assert.AreEqual(expected.name, actual.Name);
            Assert.AreEqual(expected.surname, actual.Surname);
            Assert.AreEqual(expected.email, actual.Email);
            Assert.AreEqual(expected.countryCode, actual.Country);
            Assert.AreEqual(expected.languageCode, actual.Language);
        }
        [TestMethod()]
        [ExpectedException(typeof(InstanceNotFoundException))]
        public void FindNonExistentUserTest()
        {
            /* Find user with an unexistent user identificator */
            User actual =
                UserService.FindUser(NON_EXISTENT_User_ID); //Exception
        }

        [TestMethod()]
        public void UpdateUserDetailsTest()
        {
            /* Create user */
            User oldUser = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            
            /* Update details of user previously created */
            UserDetails expected = new UserDetails("Alfonsito", "Lopes", "tomate@noesmicontraseña.com", "es", "MX");
            UserService.UpdateUserDetails(oldUser.userId, expected);

            /* Fetch again the user */
            User actual = UserService.FindUser(oldUser.userId);
            Assert.AreEqual(oldUser.login, actual.login);
            Assert.AreEqual(expected.Name, actual.name);
            Assert.AreEqual(expected.Surname, actual.surname);
            Assert.AreEqual(expected.Email, actual.email);
        }

        [TestMethod()]
        public void LoginSuccessTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Login with correct login string and password */
            LoginResult actual = UserService.Login(expected.login, "born2pwn", false);
            Assert.AreEqual(expected.userId, actual.UserId);
            Assert.AreEqual(expected.name, actual.Name);
            Assert.AreEqual(expected.languageCode, actual.Language);
            Assert.AreEqual(expected.countryCode, actual.Country);
        }

        [TestMethod()]
        [ExpectedException(typeof(IncorrectPasswordException))]
        public void LoginFailTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Login with an incorrect password */
            LoginResult actual = UserService.Login(expected.login, "born2lol", false);
        }

        [TestMethod()]
        [ExpectedException(typeof(InstanceNotFoundException))]
        public void MeantNotToBeLoginTest()
        {
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Login with a mispelled login string */ 
            LoginResult actual = UserService.Login("kerrigon", "born2pwn", false);
        }

        [TestMethod()]
        public void ChangePasswordTest()
        {
            /* Create user with password "born2pwn" */
            User expected = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            /* Change password to "born2lol" */
            UserService.ChangePassword(expected.userId, "born2pwn", "born2lol");
            /* Login attempt with the new password */
            LoginResult actual = UserService.Login(expected.login, "born2lol", false);
            Assert.AreEqual(expected.userId, actual.UserId);
        }

    }
}
