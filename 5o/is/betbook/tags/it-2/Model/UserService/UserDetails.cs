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

        public String Name { get; private set; }

        public String Surname { get; private set; }

        public String Email { get; private set; }

        public string Language { get; private set; }

        public string Country { get; private set; }

        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="UserProfileDetails"/>
        /// class.
        /// </summary>
        /// <param name="firstName">The user's first name.</param>
        /// <param name="lastName">The user's last name.</param>
        /// <param name="email">The user's email.</param>
        /// <param name="language">The language.</param>
        /// <param name="country">The country.</param>

        public UserDetails(String firstName, String lastName,
            String email, String language, String country)
        {
            this.Name = firstName;
            this.Surname = lastName;
            this.Email = email;
            this.Language = language;
            this.Country = country;
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
            String strUserProfileDetails;

            strUserProfileDetails =
                "[ firstName = " + Name + " | " +
                "lastName = " + Surname + " | " +
                "email = " + Email + " | " +
                "language = " + Language + " | " +
                "country = " + Country + " ]";


            return strUserProfileDetails;
        }

        public override bool Equals(object obj)
        {

            UserDetails target = (UserDetails)obj;

            return (this.Language == target.Language)
                   && (this.Country == target.Country)
                   && (this.Name == target.Name)
                   && (this.Surname == target.Surname);
        }

        public override int GetHashCode()
        {
            string strUserProfileDetails = this.ToString();

            return strUserProfileDetails.GetHashCode();
        }
    }
}
