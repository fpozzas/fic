using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;
using Es.Udc.DotNet.ModelUtil.Log;

namespace Es.Udc.DotNet.Betbook.Web.HTTP.Util
{
    public class LanguageManager
    {
        static public String GetLanguageFromBrowserPreferences(HttpRequest request)
        {
            String language;
            CultureInfo cultureInfo = CultureInfo.CreateSpecificCulture(request.UserLanguages[0]);
            language = cultureInfo.TwoLetterISOLanguageName;
            LogManager.RecordMessage("Preferred language of user (based on browser preferences): " + language);
            return language;
        }

        static public String GetCountryFromBrowserPreferences(HttpRequest request)
        {
            String country;
            CultureInfo cultureInfo = CultureInfo.CreateSpecificCulture(request.UserLanguages[0]);

            if (cultureInfo.IsNeutralCulture)
            {
                country = "";
            }
            else
            {
                // cultureInfoName is something like en-US
                String cultureInfoName = cultureInfo.Name;
                // Gets the last two caracters of cultureInfoname
                country = cultureInfoName.Substring(cultureInfoName.Length - 2);

                LogManager.RecordMessage("Preferred region/country of user (based on browser preferences): " + country);
            }

            return country;
        }
    }
}
