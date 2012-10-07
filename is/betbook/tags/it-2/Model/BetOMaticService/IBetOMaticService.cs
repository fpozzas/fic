using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace Es.Udc.DotNet.Betbook.Model.BetOMaticService
{
    public interface IBetOMaticService
    {
        /// <exception cref="BetOMaticException"/>
        XmlDocument FindEvents(string[] keywords, int startIndex, int count, bool commentInfo);

        /// <exception cref="BetOMaticException"/>
        XmlDocument FindBetTypes(long eventId);
    }
}
