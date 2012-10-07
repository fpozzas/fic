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
        private const int EVENTID2 = 1;
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

        #endregion

        [TestMethod()]
        public void SubmitCommentsTest()
        {
            /* Create user */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));

            /* Create and submit comment */
            DateTime expectedDate = new DateTime(2000, 10, 30, 10, 20, 30);
            String expectedComment = "trololo";
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment, expectedDate);

            /* Fetch comment */
            List<Comment> foundComments;
            foundComments = CommentService.FindCommentsByEvent(EVENTID1, 0, 10);
            Assert.AreEqual(1, foundComments.Count);
            Assert.AreEqual(EVENTID1, foundComments[0].eventId);
            Assert.AreEqual(expectedComment, foundComments[0].text);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
            Assert.AreEqual(0, DateTime.Compare(expectedDate, foundComments[0].date));
        }

        [TestMethod()]
        public void PaginationAndOrderFindCommentsTest()
        {
            /* Create user */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));

            /* 
             * Create 5 comments
             * Date of comments is different for each
             */


            DateTime expectedDate1 = new DateTime(1974, 10, 30, 10, 20, 30);
            String expectedComment1 = "Very old comment";
            DateTime expectedDate2 = new DateTime(1998, 10, 30, 10, 20, 30);
            String expectedComment2 = "Old comment";
            DateTime expectedDate3 = new DateTime(2005, 10, 30, 10, 20, 30);
            String expectedComment3 = "Slightly old comment";
            DateTime expectedDate4 = new DateTime(2009, 10, 30, 10, 20, 30);
            String expectedComment4 = "Recent comment";
            DateTime expectedDate5 = new DateTime(2009, 10, 30, 10, 20, 35);
            String expectedComment5 = "Most recent comment";
            DateTime expectedDate6 = new DateTime(1900, 10, 30, 10, 20, 35);
            String expectedComment6 = "Comment not to be found";
            /* 
             * Submit comments
             * Submit order (first to last) => 3, 1, 5, 2, 6, 4
             */
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment3, expectedDate3);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment1, expectedDate1);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment5, expectedDate5);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment2, expectedDate2);
            CommentService.SubmitComment(user1.userId, EVENTID2, expectedComment6, expectedDate6);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment4, expectedDate4);
            
            /* Fetch comments for event 1
             * Number of comments per fetch -> 2
             * Comment 6 shouldn't be found (event 2)
             * Hence if we want to get all comments we need to do 3 FindComments (2+2+1=5)
             * The order should be => 5, 4, 3, 2, 1 (newest to oldest)
             */
            int nComments = 2;
            int startIndex = 0;
            List<Comment> foundComments;

            /* First fetch */
            foundComments = CommentService.FindCommentsByEvent(EVENTID1, startIndex, nComments);
            Assert.AreEqual(2, foundComments.Count);
            Assert.AreEqual(expectedComment5, foundComments[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate5, foundComments[0].date));
            Assert.AreEqual(EVENTID1, foundComments[0].eventId);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
            Assert.AreEqual(expectedComment4, foundComments[1].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate4, foundComments[1].date));
            Assert.AreEqual(EVENTID1, foundComments[1].eventId);
            Assert.AreEqual(user1.userId, foundComments[1].User.userId);

            /* Second fetch */
            startIndex = startIndex + nComments;
            foundComments = CommentService.FindCommentsByEvent(EVENTID1, startIndex, nComments);
            Assert.AreEqual(2, foundComments.Count);
            Assert.AreEqual(expectedComment3, foundComments[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate3, foundComments[0].date));
            Assert.AreEqual(EVENTID1, foundComments[0].eventId);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
            Assert.AreEqual(expectedComment2, foundComments[1].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate2, foundComments[1].date));
            Assert.AreEqual(EVENTID1, foundComments[1].eventId);
            Assert.AreEqual(user1.userId, foundComments[1].User.userId);

            /* Third and last fetch */
            startIndex = startIndex + nComments;
            foundComments = CommentService.FindCommentsByEvent(EVENTID1, startIndex, nComments);
            Assert.AreEqual(1, foundComments.Count);
            Assert.AreEqual(expectedComment1, foundComments[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate1, foundComments[0].date));
            Assert.AreEqual(EVENTID1, foundComments[0].eventId);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
        }

        [TestMethod()]
        public void AddAndFindTagByTextTest()
        {
            /* Create user */
            /* User submits one comment */
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            CommentService.SubmitComment(
                user.userId, EVENTID1, "This is stupid", new DateTime(2000, 10, 30, 10, 20, 30));
            List<Comment> comments = CommentService.FindCommentsByEvent(EVENTID1, 0, 10);
            
            /* Adding tag to comment1 */
            String expectedText = "troll";
            CommentService.AddTagToComment(comments[0].commentId, expectedText);

            /* Finding tag by name */
            Tag actualTag = CommentService.FindTagByText(expectedText);
            Assert.AreEqual(expectedText, actualTag.text);
            Assert.AreEqual(1, actualTag.Comment.Count);
            Comment actualComment = actualTag.Comment.ToList<Comment>()[0];
            Assert.AreEqual(comments[0].commentId, actualComment.commentId);
            Assert.AreEqual(comments[0].text, actualComment.text);
            Assert.AreEqual(0, DateTime.Compare(comments[0].date, actualComment.date));
        }


        [TestMethod()]
        public void AddAndFindAllTagsTest()
        {
            /* Create user */
            /* User submits two comments */
            User user = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));
            CommentService.SubmitComment(
                user.userId, EVENTID1, "This is stupid", new DateTime(2000, 10, 30, 10, 20, 30));
            CommentService.SubmitComment(
                user.userId, EVENTID1, "Another one", new DateTime(2000, 11, 02, 10, 20, 30));
            List<Comment> comments = CommentService.FindCommentsByEvent(EVENTID1,0,10);


            /* Adding tag to comment1 */
            String expectedText = "troll";
            CommentService.AddTagToComment(comments[0].commentId, expectedText);

            /* Fetch tags (should be only one) */
            List<Tag> listTags = CommentService.FindAllTags();
            Assert.AreEqual(1, listTags.Count);
            Tag actualTag = listTags[0];
            Assert.AreEqual(expectedText, actualTag.text);

            /* Fetch comments (only the first should have an associated tag */
            List<Comment> foundComments = CommentService.FindCommentsByEvent(EVENTID1, 0, 10);
            Assert.AreEqual(1, foundComments[0].Tag.Count);
            Assert.AreEqual(actualTag.tagId, foundComments[0].Tag.ToList<Tag>()[0].tagId);
            Assert.AreEqual(actualTag.text, foundComments[0].Tag.ToList<Tag>()[0].text);
            Assert.AreEqual(0, foundComments[1].Tag.Count);

            /* Adding same tag to the other comment */
            CommentService.AddTagToComment(comments[1].commentId, expectedText);
            /* Number of tags should be the same */
            listTags = CommentService.FindAllTags();
            Assert.AreEqual(1, listTags.Count);
            foundComments = CommentService.FindCommentsByEvent(EVENTID1, 0, 10);
            Assert.AreEqual(1, foundComments[0].Tag.Count);
            /* But now comment2 has a tag associated*/
            Assert.AreEqual(1, foundComments[1].Tag.Count);
            Assert.AreEqual(actualTag.tagId, foundComments[1].Tag.ToList<Tag>()[0].tagId);
            Assert.AreEqual(actualTag.text, foundComments[1].Tag.ToList<Tag>()[0].text);

            /* 
             * Finding comment by tag 
             */

            List<Comment> commentList = CommentService.FindCommentsByTag(actualTag.tagId, 0, 10);
            Assert.AreEqual(2, commentList.Count);
            for (int i=0; i<2; i++)
            {
                Assert.AreEqual(foundComments[i].commentId, commentList[i].commentId);
                Assert.AreEqual(foundComments[i].text, commentList[i].text);
            }


        }

        [TestMethod()]
        public void PaginationAndOrderFindCommentsByTagTest()
        {
            /* Create user */
            User user1 = UserService.RegisterUser("kerrigan", "born2pwn",
                new UserDetails("Sarah", "Kerrigan", "bitch@queen.ter", "en", "ES"));

            /* 
             * Create 5 comments
             * Date of comments is different for each
             */


            DateTime expectedDate1 = new DateTime(1974, 10, 30, 10, 20, 30);
            String expectedComment1 = "Very old comment";
            DateTime expectedDate2 = new DateTime(1998, 10, 30, 10, 20, 30);
            String expectedComment2 = "Old comment";
            DateTime expectedDate3 = new DateTime(2005, 10, 30, 10, 20, 30);
            String expectedComment3 = "Slightly old comment";
            DateTime expectedDate4 = new DateTime(2009, 10, 30, 10, 20, 30);
            String expectedComment4 = "Recent comment";
            DateTime expectedDate5 = new DateTime(2009, 10, 30, 10, 20, 35);
            String expectedComment5 = "Very recent comment";
            DateTime expectedDate6 = new DateTime(2010, 4, 30, 10, 20, 35);
            String expectedComment6 = "Comment now SHOULD be found";
            /* 
             * Submit comments
             * Submit order (first to last) => 3, 1, 5, 2, 6, 4
             */
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment3, expectedDate3);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment1, expectedDate1);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment5, expectedDate5);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment2, expectedDate2);
            CommentService.SubmitComment(user1.userId, EVENTID2, expectedComment6, expectedDate6);
            CommentService.SubmitComment(user1.userId, EVENTID1, expectedComment4, expectedDate4);


            /*
             * Fetch comments for event 1
             * Tag will be applied to comment 1 and 3
             * (Order of comments -> 5, 4, 3, 2, 1)
             */

            List<Comment> comments = CommentService.FindCommentsByEvent(EVENTID1, 0, 100);
            Assert.AreEqual(5, comments.Count);
            String expectedText = "troll";
            /* Adding tag to comment 1 */
            CommentService.AddTagToComment(comments[4].commentId, expectedText);
            /* Adding tag to comment 3 */
            CommentService.AddTagToComment(comments[2].commentId, expectedText);

            /*
             * Fetch comments for event 2
             * Tag will be applied to comment 6
             * (Order of comments -> 6)
             */

            comments = CommentService.FindCommentsByEvent(EVENTID2, 0, 100);
            Assert.AreEqual(1, comments.Count);
            /* Same tag name as before*/
            expectedText = "troll";
            /* Adding tag to comment 6 */
            CommentService.AddTagToComment(comments[0].commentId, expectedText);
            

            /* Fetch tags 
             * Number of tags per fetch -> 2
             * Hence if we want to get all comments we need to do 2 FindComments (2+1=3)
             * The order should be => 6, 3, 1 (newest to oldest)
             */
            int nComments = 2;
            int startIndex = 0;
            Tag tag = CommentService.FindTagByText(expectedText);
            List<Comment> foundComments;

            /* First fetch */
            foundComments = CommentService.FindCommentsByTag(tag.tagId, startIndex, nComments);
            Assert.AreEqual(2, foundComments.Count);
            /* Comment 6 */
            Assert.AreEqual(expectedComment6, foundComments[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate6, foundComments[0].date));
            Assert.AreEqual(EVENTID2, foundComments[0].eventId);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
            /* Comment 3 */
            Assert.AreEqual(expectedComment3, foundComments[1].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate3, foundComments[1].date));
            Assert.AreEqual(EVENTID1, foundComments[1].eventId);
            Assert.AreEqual(user1.userId, foundComments[1].User.userId);

            /* Second and last fetch */
            startIndex = startIndex + nComments;
            foundComments = CommentService.FindCommentsByTag(tag.tagId, startIndex, nComments);
            /* Comment 1 */
            Assert.AreEqual(1, foundComments.Count);
            Assert.AreEqual(expectedComment1, foundComments[0].text);
            Assert.AreEqual(0, DateTime.Compare(expectedDate1, foundComments[0].date));
            Assert.AreEqual(EVENTID1, foundComments[0].eventId);
            Assert.AreEqual(user1.userId, foundComments[0].User.userId);
        }

        

    }
}
