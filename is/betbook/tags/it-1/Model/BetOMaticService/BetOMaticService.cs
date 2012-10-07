using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Es.Udc.DotNet.Betbook.Model.BetOMaticService
{
    class BetOMaticService : IBetOMaticService
    {
        #region IBetOMaticService Members

        List<Event> IBetOMaticService.FindEvents(List<string> keywords, int startIndex, int count)
        {
            throw new NotImplementedException();
        }

        List<BetType> IBetOMaticService.FindBetTypes()
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}
