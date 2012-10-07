using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Log;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.Betbook.Model;
using System.Globalization;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects;
using Es.Udc.DotNet.Betbook.Web.HTTP.Util;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class Register : SpecificCulturePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblLoginError.Visible = false;

            if (!IsPostBack)
            {
                String defaultLanguage = LanguageManager.GetLanguageFromBrowserPreferences(Request);
                String defaultCountry = LanguageManager.GetCountryFromBrowserPreferences(Request);

                /* Combo box initialization */
                LoadLanguages(defaultLanguage);
                UpdateCountries(defaultLanguage, defaultCountry);
            }
            else
            {
                /* After a language change, the countries are printed in the
                 * correct language
                 */
                UpdateCountries(comboLanguage.SelectedValue, comboCountry.SelectedValue);
            }
        }

        private void LoadLanguages(string selectedLanguage)
        {
            comboLanguage.DataSource =
                ((LanguagesTO)Application["Languages"]).GetLanguages();
            comboLanguage.DataTextField = "languageName";
            comboLanguage.DataValueField = "languageCode";
            comboLanguage.DataBind();
            if (comboLanguage.Items.FindByValue(selectedLanguage) != null)
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

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            try
            {
                /* Create an User. */
                UserDetails userDetails = new UserDetails(
                    txtName.Text, txtSurname.Text, txtEmail.Text,
                    comboLanguage.SelectedValue,
                    comboCountry.SelectedValue);

                /* Get the Service */
                IUnityContainer container = (IUnityContainer)HttpContext.Current.Application["unityContainer"];
                IUserService userService = container.Resolve<IUserService>();

                SessionManager.RegisterUser(Context, txtLogin.Text, txtPassword.Text, userDetails);

                Server.Transfer(Response.ApplyAppPathModifier("./UserCreated.aspx"));
            }
            catch (DuplicateInstanceException)
            {
                lblLoginError.Visible = true;
            }
        }
    }
}
