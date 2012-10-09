using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Es.Udc.DotNet.Betbook.Model.UserService;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects;

namespace Es.Udc.DotNet.Betbook.Web.Pages
{
    public partial class UpdateUserProfile : SpecificCulturePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {

            if (IsPostBack == false)
            {
                UserDetails userDetails =
                    SessionManager.FindUserDetails(Context);

                txtFirstName.Text = userDetails.Name;
                txtSurname.Text = userDetails.Surname;
                txtEmail.Text = userDetails.Email;

                /* Combo box initialization */
                this.LoadLanguages();
                comboLanguage.SelectedValue =
                    userDetails.Language;

                UpdateCountries(userDetails.Language);
                comboCountry.SelectedValue =
                    userDetails.Country;
            }
            else
            {

                /* After a language change, the countries are printed in the
                 * correct language
                 */
                this.UpdateCountries(comboLanguage.SelectedValue);
            }

        }


        /// <summary>
        /// Loads the languages into the comboBox.
        /// </summary>
        private void LoadLanguages()
        {

            this.comboLanguage.DataSource =
                ((LanguagesTO)Application["Languages"]).GetLanguages();

            this.comboLanguage.DataTextField = "languageName";
            this.comboLanguage.DataValueField = "languageCode";
            this.comboLanguage.DataBind();

        }

        /// <summary>
        /// Updates the countries into the comboBox.
        /// </summary>
        /// <param name="languageCode">The language code used to represent the
        /// country name.</param>
        private void UpdateCountries(String languageCode)
        {

            string selectedCodeCountry = comboCountry.SelectedValue;

            this.comboCountry.DataSource =
                ((CountriesTO)Application["Countries"]).GetCountries(languageCode);

            this.comboCountry.DataTextField = "countryName";
            this.comboCountry.DataValueField = "countryCode";
            this.comboCountry.DataBind();

            comboCountry.SelectedValue = selectedCodeCountry;

        }


        /// <summary>
        /// Handles the Click event of the btnUpdate control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance 
        /// containing the event data.</param>
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            UserDetails userDetails =
                new UserDetails(txtFirstName.Text, txtSurname.Text,
                    txtEmail.Text, comboLanguage.SelectedValue,
                    comboCountry.SelectedValue);

            SessionManager.UpdateUserDetails(Context,
                userDetails);

            Response.Redirect(
                Response.ApplyAppPathModifier("~/Pages/MainPage.aspx"));
        }
    }
}
