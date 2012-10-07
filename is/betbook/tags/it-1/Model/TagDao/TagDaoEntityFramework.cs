using System;
using System.Collections.Generic;
using System.Linq;
using Es.Udc.DotNet.ModelUtil.Dao;
using Es.Udc.DotNet.ModelUtil.Log;
using System.Data.Objects;
using System.Data.EntityClient;
using System.Data;
using System.Configuration;
using Es.Udc.DotNet.ModelUtil.Exceptions;


namespace Es.Udc.DotNet.Betbook.Model.TagDao
{
    class TagDaoEntityFramework :
        GenericDaoEntityFramework<Tag, Int64>, ITagDao
    {
        #region ITagDao Members

        public List<Tag> FindAllTags()
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from tag in container.Tag
                      select tag).ToList();

                return result;
            }
        }

        public Tag FindByText(string text)
        {
            using (BetbookEntitiesContainer container = new BetbookEntitiesContainer())
            {
                var result =
                     (from tag in container.Tag
                      where tag.text.ToLower() == text.ToLower()
                      select tag);

                if (result.Count() > 0)
                {
                    Tag tag = result.First();
                    tag.Comment.Load();
                    return tag;
                }
                else
                    throw new InstanceNotFoundException(text, typeof(Comment).FullName);
            }
        }

        #endregion
    }
}
