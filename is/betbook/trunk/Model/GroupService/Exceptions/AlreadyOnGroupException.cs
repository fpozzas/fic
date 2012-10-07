using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Es.Udc.DotNet.Betbook.Model.GroupService
{
    public class AlreadyOnGroupException : Exception
    {
        private readonly long userId;
        private readonly long groupId;

        public AlreadyOnGroupException(long userId, long groupId)
            : base("Already on group exception => userId = "+userId+ " | " + "groupId = " + groupId)
        {
            this.userId = userId;
            this.groupId = groupId;
        }
    }
}
