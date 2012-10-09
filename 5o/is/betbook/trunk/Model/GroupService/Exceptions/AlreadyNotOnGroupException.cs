using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Es.Udc.DotNet.Betbook.Model.GroupService
{
    public class AlreadyNotOnGroupException : Exception
    {
        private readonly long userId;
        private readonly long groupId;

        public AlreadyNotOnGroupException(long userId, long groupId)
            : base("Already not on group exception => userId = "+userId+ " | " + "groupId = " + groupId)
        {
            this.userId = userId;
            this.groupId = groupId;
        }
    }
}
