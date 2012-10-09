using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects
{
    public struct Locale
    {
        private string language;
        private string country;

        #region Properties

        public string Language
        {
            get { return language; }
            set { language = value; }
        }

        public string Country
        {
            get { return country; }
            set { country = value; }
        }

        #endregion


        public Locale(string language, string country)
        {
            this.language = language;
            this.country = country;
        }
    }
}
