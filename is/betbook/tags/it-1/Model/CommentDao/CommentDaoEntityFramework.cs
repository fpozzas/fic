using System;
using System.Collections.Generic;
using System.Linq;
using Es.Udc.DotNet.ModelUtil.Dao;


namespace Es.Udc.DotNet.Betbook.Model.CommentDao
{
    class CommentDaoEntityFramework :
        GenericDaoEntityFramework<Comment, Int64>, ICommentDao
    {

        #region ICommentDao Members


        public List<Comment> FindByDate(long userId,
            DateTime startDate, DateTime endDate, int startIndex, int count)
        {
            using (BetbookEntitiesContainer container =
                new BetbookEntitiesContainer())
            {

                var result =
                    (from comment in container.Comment
                     where comment.User.userId == userId
                     && comment.date >= startDate
                     && comment.date <= endDate
                     orderby comment.date
                     select comment).Skip(startIndex).Take(count).ToList();

                return result;
            }
        }

        public List<Comment> FindByEventId(long eventId, int startIndex, int count)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                    (from comment in container.Comment
                     where comment.eventId == eventId
                     orderby comment.date
                     select comment).Skip(startIndex).Take(count).ToList();
                foreach (var c in result)
                {
                    c.UserReference.Load();
                    c.Tag.Load();
                }
                return result;
            }
        }

        public List<Comment> FindByTagId(long tagId, int startIndex, int count)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                    (from tag in container.Tag
                     from comment in tag.Comment
                     where tag.tagId == tagId
                     orderby comment.date
                     select comment).Skip(startIndex).Take(count).ToList();
                return result;
            }
        }

        #endregion

    }
}
