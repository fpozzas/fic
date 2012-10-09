using System;
using System.Web;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.Betbook.Model.EventService;
using System.Xml.Xsl;
using Es.Udc.DotNet.Betbook.Web.Properties;
using System.Xml.XPath;
using Es.Udc.DotNet.Betbook.Model.BetOMaticService;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class FindEvents : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string[] keywords;
            int startIndex, count;

            try
            {
                string keywordsQuery = Server.UrlDecode(Request.QueryString["keywords"]);
                keywords = keywordsQuery.Split(' ');
                if (!IsPostBack)
                    txtKeywords.Text = keywordsQuery;
            }
            catch (NullReferenceException)
            {
                keywords = null;
            }

            if (!IsPostBack)
            try
            {
                checkNumberOfComments.Checked = bool.Parse(Request.QueryString["commentInfo"]);
            }
            catch (ArgumentNullException)
            {
                checkNumberOfComments.Checked = true;
            }

            if (keywords != null)
            {
                try
                {
                    startIndex = Int32.Parse(Request.Params.Get("startIndex"));
                }
                catch (ArgumentNullException)
                {
                    startIndex = 0;
                }

                try
                {
                    count = Int32.Parse(Request.Params.Get("count"));
                }
                catch (ArgumentNullException)
                {
                    count = Settings.Default.Betbook_defaultCount;
                }


                ShowEventList(keywords, startIndex, count, checkNumberOfComments.Checked);
            }
        }


        protected void btnFind_Click(object sender, EventArgs e)
        {
            string keywords = txtKeywords.Text;
            String url = 
                String.Format("~/Pages/FindEvents.aspx?keywords={0}&commentInfo={1}", Server.UrlEncode(keywords), checkNumberOfComments.Checked);
            Server.Transfer(Response.ApplyAppPathModifier(url));
        }

        private void ShowEventList(string[] keywords, int startIndex, int count, bool commentInfo)
        {
            try
            {
                /* Get the Service */
                IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
                IEventService eventService = container.Resolve<IEventService>();

                aspXml.XPathNavigator = eventService.FindEvents(keywords, startIndex, count, commentInfo).CreateNavigator();
                aspXml.TransformArgumentList = new XsltArgumentList();

                aspXml.TransformArgumentList.AddParam("commentInfo", "", checkNumberOfComments.Checked);
                aspXml.TransformArgumentList.AddParam("numberOfResults", "", aspXml.XPathNavigator.Select("//event").Count);

                foreach (var lcl in new string[] { "lclNoComments", "lclName", "lclDate", "lclCategory",
                    "lclAddComment", "lclViewComments", "lclFavouriteEvent", "lclRecommendEvent" })
                {
                    aspXml.TransformArgumentList.AddParam(lcl, "",
                        GetLocalResourceObject(lcl + ".Text").ToString());
                }

                foreach (var lcl in new string[] { "NoResults", "Previous", "Next" })
                {
                    aspXml.TransformArgumentList.AddParam(lcl, "",
                        GetGlobalResourceObject("Common", lcl).ToString());
                }

                foreach (var page in new string[] { "FindBetTypes", "AddComment", "ViewComments", "FavouriteEvent", "RecommendEvent" })
                {
                    aspXml.TransformArgumentList.AddParam("url"+page, "",
                        Response.ApplyAppPathModifier("~/Pages/"+page+".aspx"));
                }

                /* "Previous" link */
                if ((startIndex - count) >= 0)
                {
                    String url =
                        Settings.Default.Betbook_applicationURL +
                        "/Pages/FindEvents.aspx" +
                        "?keywords=" + Server.UrlEncode(String.Join("+", keywords)) +
                        "&commentInfo=" + commentInfo +
                        "&startIndex=" + (startIndex - count) +
                        "&count=" + count;
                    aspXml.TransformArgumentList.AddParam("urlPrevious", "", Response.ApplyAppPathModifier(url));
                }

                /* "Next" link */
                XPathNodeIterator iterator = aspXml.XPathNavigator.Select("//events");
                iterator.MoveNext();
                if (iterator.Current.GetAttribute("more", "") == "true")
                {
                    String url =
                        Settings.Default.Betbook_applicationURL +
                        "/Pages/FindEvents.aspx" +
                        "?keywords=" + Server.UrlEncode(String.Join("+", keywords)) +
                        "&commentInfo=" + commentInfo +
                        "&startIndex=" + (startIndex + count) +
                        "&count=" + count;

                    aspXml.TransformArgumentList.AddParam("urlNext", "", Response.ApplyAppPathModifier(url));
                }
            }
            catch (BetOMaticException e)
            {
                lblBetOMaticErrorMessage.Visible = true;
            }
        }
    }
}
