﻿using System;
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

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public long SubmitComment(long userId, long eventId, string text, global::System.DateTime date)
        {
            Comment comment = Comment.CreateComment(0, text, date, eventId);
            comment.text = text;
            comment.User = UserDao.Find(userId);
            CommentDao.Create(comment);

            return comment.commentId;
        }


        public List<Comment> FindCommentsByEvent(long eventId, int startIndex, int count)
        {
            return CommentDao.FindByEventId(eventId, startIndex, count);
        }

        public int GetNumberOfCommentsByEvent(long eventId)
        {
            return CommentDao.GetNumberOfCommentsByEvent(eventId);
        }


        public List<Comment> FindCommentsByTag(long tagId, int startIndex, int count)
        {
            return CommentDao.FindByTagId(tagId, startIndex, count);
        }

        public int GetNumberOfComments()
        {
            return CommentDao.GetNumberOfComments();
        }

        public int GetNumberOfCommentsByTag(long tagId)
        {
            return CommentDao.GetNumberOfCommentsByTag(tagId);
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
                tag = (Tag)CommentDao.Context.GetObjectByKey(tag.EntityKey);
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

        /// <exception cref="InstanceNotFoundException"/>
        public Tag FindTagByText(string text)
        {
            return TagDao.FindByText(text);
        }

        #endregion
    }
} // namespace
