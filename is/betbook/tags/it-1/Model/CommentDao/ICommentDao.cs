using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Dao;

namespace Es.Udc.DotNet.Betbook.Model.CommentDao
{
    public interface ICommentDao : IGenericDao<Comment, Int64>
    {
        List<Comment> FindByDate(long accountIdentifier, DateTime startDate,
            DateTime endDate, int startIndex, int count);

        List<Comment> FindByEventId(long eventId, int startIndex, int count);

        List<Comment> FindByTagId(long tagId, int startIndex, int count);
    }
}
