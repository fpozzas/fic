using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Es.Udc.DotNet.Betbook.Model.GroupService
{
    public class AlreadyExistingGroupException : Exception
    {
        private readonly string groupName;

        public AlreadyExistingGroupException(string groupName)
            : base("Already existing group exception => groupName = " + groupName)
        {
            this.groupName = groupName;
        }
    }
}
