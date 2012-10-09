using System;
using System.Collections.Generic;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Es.Udc.DotNet.Betbook.Model.TagDao;
using Es.Udc.DotNet.Betbook.Model.UserDao;

namespace Es.Udc.DotNet.Betbook.Model.CommentService
{
    public interface ICommentService
    {
        ICommentDao CommentDao { set; }
        ITagDao TagDao { set; }
        IUserDao UserDao { set; }

        void SubmitComment(long userId, long eventId, string text, global::System.DateTime date);
        List<Comment> FindComments(long eventId, int startIndex, int count);

        List<Tag> FindAllTags();
        void AddTagToComment(long commentId, string text);
        
        List<Comment> FindCommentsByTag(long tagId, int startIndex, int count);
    }
}
