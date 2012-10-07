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

        public List<Comment> FindByEventId(long eventId, int startIndex, int count)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                    (from comment in container.Comment
                     where comment.eventId == eventId
                     orderby comment.date descending
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
                     orderby comment.date descending
                     select comment).Skip(startIndex).Take(count).ToList();
                foreach (var c in result)
                {
                    c.UserReference.Load();
                    c.Tag.Load();
                }
                return result;
            }
        }

        public int GetNumberOfCommentsByEvent(long eventId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                    (from comment in container.Comment
                     where comment.eventId == eventId
                     select comment).Count();
                return result;
            }
        }

        public int GetNumberOfCommentsByTag(long tagId)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                    (from tag in container.Tag
                     from comment in tag.Comment
                     where tag.tagId == tagId
                     select comment).Count();
                return result;
            }
        }

        public int GetNumberOfComments()
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                    (from comment in container.Comment
                     select comment).Count();
                return result;
            }
        }

        #endregion

    }
}
