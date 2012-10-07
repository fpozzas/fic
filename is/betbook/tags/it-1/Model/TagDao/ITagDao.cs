using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Dao;

namespace Es.Udc.DotNet.Betbook.Model.TagDao
{
    public interface ITagDao : IGenericDao<Tag, Int64>
    {
        List<Tag> FindAllTags();

        Tag FindByText(string text);
    }
}
