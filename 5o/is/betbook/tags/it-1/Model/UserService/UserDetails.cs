using System;


namespace Es.Udc.DotNet.Betbook.Model.UserService
{

    /// <summary>
    /// VO Class which contains the user details
    /// </summary>
    [Serializable()]
    public class UserDetails
    {
        #region Properties Region

        public String name { get; private set; }

        public String surname { get; private set; }

        public String email { get; private set; }

        public string languageCode { get; private set; }

        public string countryCode { get; private set; }

        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="UserDetails"/>
        /// class.
        /// </summary>
        /// <param name="firstName">The user's first name.</param>
        /// <param name="lastName">The user's last name.</param>
        /// <param name="email">The user's email.</param>
        /// <param name="language">The language.</param>
        /// <param name="country">The country.</param>

        public UserDetails(String name, String surname,
            String email, String language, String country)
        {
            this.name = name;
            this.surname = surname;
            this.email = email;
            this.languageCode = language;
            this.countryCode = country;
        }


        /// <summary>
        /// Returns a <see cref="T:System.String"></see> that represents the 
        /// current <see cref="T:System.Object"></see>.
        /// </summary>
        /// <returns>
        /// A <see cref="T:System.String"></see> that represents the current 
        /// <see cref="T:System.Object"></see>.
        /// </returns>
        public override String ToString()
        {
            String struserDetails;

            struserDetails =
                "[ firstName = " + name + " | " +
                "lastName = " + surname + " | " +
                "email = " + email + " | " +
                "language = " + languageCode + " | " +
                "country = " + countryCode + " ]";


            return struserDetails;
        }

        public override bool Equals(object obj)
        {

            UserDetails target = (UserDetails)obj;

            return (this.languageCode == target.languageCode)
                   && (this.countryCode == target.countryCode)
                   && (this.name == target.name)
                   && (this.surname == target.surname);
        }

        public override int GetHashCode()
        {
            string struserDetails = this.ToString();

            return struserDetails.GetHashCode();
        }
    }
}
