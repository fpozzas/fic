using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.ModelUtil.Transactions;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Es.Udc.DotNet.Betbook.Model.TagDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;

namespace Es.Udc.DotNet.Betbook.Model.CommentService
{
    class CommentService: ICommentService
    {
        [Dependency]
        public ICommentDao CommentDao { private get; set; }
        [Dependency]
        public ITagDao TagDao { private get; set; }
        [Dependency]
        public IUserDao UserDao { private get; set; }

        
        #region ICommentService Members
        
        [Transactional]
        public void SubmitComment(long userId, long eventId, string text, global::System.DateTime date)
        {
            Comment comment = Comment.CreateComment(0, text, date, eventId);
            comment.text = text;
            comment.User = UserDao.Find(userId);
            CommentDao.Create(comment);
        }

        /// <exception cref="InstanceNotFoundException"/>
        public List<Comment> FindComments(long eventId, int startIndex, int count)
        {
            return CommentDao.FindByEventId(eventId, startIndex, count);
        }

        public List<Tag> FindAllTags()
        {
            return TagDao.FindAllTags();
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void AddTagToComment(long commentId, string text)
        {
            Comment comment;
            Tag tag;

            try
            {
                tag = TagDao.FindByText(text);

                // trololo
                tag = (Tag)CommentDao.Context.GetObjectByKey(tag.EntityKey);
                // look at my context my context is amazing
            }
            catch (InstanceNotFoundException)
            {
                tag = Tag.CreateTag(0, text);
                TagDao.Create(tag);
            }

            try
            {
                comment = CommentDao.Find(commentId);

                comment.Tag.Add(tag);
                CommentDao.Update(comment);
            }
            catch (InstanceNotFoundException)
            {
                throw;
            }
        }

        public List<Comment> FindCommentsByTag(long tagId, int startIndex, int count)
        {
            return CommentDao.FindByTagId(tagId, startIndex, count);
        }

        #endregion
    }
} // namespace
