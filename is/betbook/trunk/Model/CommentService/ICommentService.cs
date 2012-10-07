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

        /// <exception cref="InstanceNotFoundException">For userId</exception>
        long SubmitComment(long userId, long eventId, string text, global::System.DateTime date);

        List<Comment> FindCommentsByEvent(long eventId, int startIndex, int count);
        int GetNumberOfCommentsByEvent(long eventId);
        int GetNumberOfComments();

        List<Comment> FindCommentsByTag(long tagId, int startIndex, int count);
        int GetNumberOfCommentsByTag(long tagId);

        List<Tag> FindAllTags();

        /// <exception cref="InstanceNotFoundException"/>
        Tag FindTagByText(string text);
        /// <exception cref="InstanceNotFoundException">For commentId</exception>
        void AddTagToComment(long commentId, string text);
    }
}
