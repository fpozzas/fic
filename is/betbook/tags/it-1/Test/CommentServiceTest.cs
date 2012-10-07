using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Transactions;
using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.Betbook.Model.CommentService;
using Es.Udc.DotNet.Betbook.Model.TagDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;

namespace Es.Udc.DotNet.Betbook.Test
{
    /// <summary>
    ///This is a test class for ICommentServiceTest and is intended
    ///to contain all ICommentServiceTest Unit Tests
    ///</summary>
    [TestClass()]
    public class CommentServiceTest
    {
        private static IUnityContainer container;
        private static IUserService UserService;
        private static ICommentService CommentService;
        private static ICommentDao commentDao;
        private static ITagDao tagDao;
        private static IUserDao userDao; 
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
            CommentService = container.Resolve<ICommentService>();
            commentDao = container.Resolve<ICommentDao>();
            tagDao = container.Resolve<ITagDao>();
            userDao = container.Resolve<IUserDao>();
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
        public void SubmitCommentsTest()
        {
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            List<Comment> foundComments;

            DateTime expectedDate = new DateTime(2000, 10, 30, 10, 20, 30);
            String expectedComment = "trololo";
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment, expectedDate);

            foundComments = CommentService.FindComments(EVENTID1, 0, 10);
            Assert.AreEqual(1, foundComments.Count);
            Assert.AreEqual(EVENTID1, foundComments[0].eventId);
            Assert.AreEqual(expectedComment, foundComments[0].text);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
            Assert.AreEqual(0, DateTime.Compare(expectedDate, foundComments[0].date));
        }

        [TestMethod()]
        public void TagsTest()
        {
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            CommentService.SubmitComment(
                user.userId, EVENTID1, "This is stupid", new DateTime(2000, 10, 30, 10, 20, 30));
            CommentService.SubmitComment(
                user.userId, EVENTID1, "Not to be found", new DateTime(2000, 11, 02, 10, 20, 30));
            List<Comment> comments = CommentService.FindComments(EVENTID1,0,10);


            /* Adding tag to comment */

            String expectedText = "troll";
            CommentService.AddTagToComment(comments[0].commentId, expectedText);

            List<Tag> listTags = CommentService.FindAllTags();
            Assert.AreEqual(1, listTags.Count);
            Tag actualTag = listTags[0];
            Assert.AreEqual(expectedText, actualTag.text);

            List<Comment> foundComments = CommentService.FindComments(EVENTID1, 0, 10);
            Assert.AreEqual(1, foundComments[0].Tag.Count);
            Assert.AreEqual(0, foundComments[1].Tag.Count);

            
            CommentService.AddTagToComment(comments[1].commentId, expectedText);
            listTags = CommentService.FindAllTags();
            Assert.AreEqual(1, listTags.Count);

            foundComments = CommentService.FindComments(EVENTID1, 0, 10);
            Assert.AreEqual(1, foundComments[0].Tag.Count);
            Assert.AreEqual(1, foundComments[1].Tag.Count);


            List<Tag> tags = foundComments[0].Tag.ToList();
            Assert.AreEqual(actualTag.tagId, tags[0].tagId);
            Assert.AreEqual(actualTag.text, tags[0].text);

            /* Finding comment by tag */

            List<Comment> commentList = CommentService.FindCommentsByTag(actualTag.tagId, 0, 10);
            Assert.AreEqual(2, commentList.Count);
            for (int i=0; i<2; i++)
            {
                Assert.AreEqual(foundComments[i].commentId, commentList[i].commentId);
                Assert.AreEqual(foundComments[i].text, commentList[i].text);
            }
        }

        #endregion

    }
}
