#define XML_DEBUG_

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.IO;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.Properties;
using System.Net;

namespace Es.Udc.DotNet.Betbook.Model.BetOMaticService
{
    class BetOMaticService : IBetOMaticService
    {
        [Dependency]
        public ICommentDao CommentDao { private get; set; }

        #region IBetOMaticService Members

#if XML_DEBUG
        private static string betomaticFindEventsUri = "Web/Pages/Test/FindEvents_test.xml";
        private static string betomaticShowBetTypesUri = "Web/Pages/Test/ShowBetTypes_test.xml";
#else
        private static string betomaticFindEventsUri =
            Settings.Default.Betbook_betomaticServer +
            "/bet-o-matic/xmlservice/FindEvents?keywords={0}&startIndex={1}&count={2}";
        private static string betomaticShowBetTypesUri =
            Settings.Default.Betbook_betomaticServer +
            "/bet-o-matic/xmlservice/ShowBetTypes?eventId={0}";
#endif

        /// <exception cref="BetOMaticException"/>
        XmlDocument IBetOMaticService.FindEvents(string[] keywords, int startIndex, int count, bool commentInfo)
        {
            XmlDocument xmlDocument = new XmlDocument();

            try
            {
                xmlDocument.Load(String.Format(betomaticFindEventsUri, String.Join("+", keywords), startIndex, count));

                if (commentInfo)
                {
                    /* Add the number of comments to each event */
                    XPathNavigator navigator = xmlDocument.CreateNavigator();
                    XPathNodeIterator iterator = navigator.Select("//event");
                    while (iterator.MoveNext())
                    {
                        XPathNodeIterator itId = iterator.Current.Select("./id");
                        itId.MoveNext();
                        int numberOfComments = CommentDao.GetNumberOfCommentsByEvent(int.Parse(itId.Current.InnerXml));
                        iterator.Current.AppendChildElement("", "numberOfComments", "", numberOfComments.ToString());
                    }
                }
            }
            catch (FileNotFoundException)
            {
                throw new BetOMaticException();
            }
            catch (WebException)
            {
                throw new BetOMaticException();
            }

            return xmlDocument;
        }

        /// <exception cref="BetOMaticException"/>
        XmlDocument IBetOMaticService.FindBetTypes(long eventId)
        {
            XmlDocument xmlDocument = new XmlDocument();

            try
            {
                xmlDocument.Load(String.Format(betomaticShowBetTypesUri, eventId));
            }
            catch (FileNotFoundException)
            {
                throw new Exception("Could not find resource");
            }
            catch (WebException)
            {
                throw new Exception("Could not connect to the remote server");
            }

            return xmlDocument;
        }

        #endregion
    }
}
