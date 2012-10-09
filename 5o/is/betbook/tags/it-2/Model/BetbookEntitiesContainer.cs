using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Es.Udc.DotNet.ModelUtil.Log;

namespace Es.Udc.DotNet.Betbook.Model
{
    partial class BetbookEntitiesContainer
    {
        partial void OnContextCreated()
        {
            LogManager.RecordMessage("");
        }
    }
}
