using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Es.Udc.DotNet.Betbook.Model.BetOMaticService
{
    public interface IBetOMaticService
    {
        List<Event> FindEvents(List<string> keywords, int startIndex, int count);

        List<BetType> FindBetTypes();
    }
}
