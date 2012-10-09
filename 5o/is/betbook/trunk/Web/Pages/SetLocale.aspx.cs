using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects;
using Es.Udc.DotNet.ModelUtil.Log;
using Es.Udc.DotNet.Betbook.Web.HTTP.Util;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class SetLocale : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String language;
            String country;

            if (!IsPostBack)
            {
                /* 
                 * We check if exists a locale in the session. In this case, 
                 * we get the language and the region/country from the locale.
                 * Othercase we use the browser preferences to extract the
                 * language and the region/country
                 */
                if (!SessionManager.IsLocaleDefined(Context))
                {
                    /* Gets preferred language from browser */
                    language = LanguageManager.GetLanguageFromBrowserPreferences(Request);
                    country = LanguageManager.GetCountryFromBrowserPreferences(Request);
                }
                else
                {
                    Locale locale = SessionManager.GetLocale(Context);
                    language = locale.Language;
                    country = locale.Country;
                }

                /* Finally we update the data of the "Combo", using the
                 * selected laguage and region/country.
                 */
                LoadLanguages(language);
                UpdateCountries(language, country);
            }
        }


        private void LoadLanguages(String selectedLanguage)
        {
            comboLanguage.DataSource =
                ((LanguagesTO)Application["Languages"]).GetLanguages();
            comboLanguage.DataTextField = "languageName";
            comboLanguage.DataValueField = "languageCode";
            comboLanguage.DataBind();
            comboLanguage.SelectedValue = selectedLanguage;
        }

        private void UpdateCountries(String selectedLanguage, String selectedCountry)
        {
            comboCountry.DataSource =
                ((CountriesTO)Application["Countries"]).GetCountries(selectedLanguage);
            comboCountry.DataTextField = "countryName";
            comboCountry.DataValueField = "countryCode";
            comboCountry.DataBind();
            comboCountry.SelectedValue = selectedCountry;
        }


        protected void btnSetLocale_Click(object sender, EventArgs e)
        {
            string language = comboLanguage.SelectedValue;
            string country = comboCountry.SelectedValue;

            Locale locale = new Locale(language, country);

            SessionManager.SetLocale(Context, locale);

            Response.Redirect(Response.ApplyAppPathModifier("~/Pages/MainPage.aspx"));
        }

        protected void comboLanguage_SelectedIndexChanged(object sender, EventArgs e)
        {
            /* After a language change, the countries are printed in the
             * correct language.
            */
            this.UpdateCountries(comboLanguage.SelectedValue, comboCountry.SelectedValue);
        }
    }
}
