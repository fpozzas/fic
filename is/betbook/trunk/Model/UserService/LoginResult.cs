using System;


namespace Es.Udc.DotNet.Betbook.Model.UserService
{

    /// <summary>
    /// A Custom VO which keepts the results for a login action.
    /// </summary>
    [Serializable()]
    public class LoginResult
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LoginResult"/> class.
        /// </summary>
        /// <param name="userProfileId">The user profile id.</param>
        /// <param name="firstName">Users's first name.</param>
        /// <param name="encryptedPassword">The encrypted password.</param>
        /// <param name="language">The language.</param>
        /// <param name="country">The country.</param>
        public LoginResult(long userId, String name, 
            String encryptedPassword, String language, String country)
        {
            this.UserId = userId;
            this.Name = name;
            this.EncryptedPassword = encryptedPassword;
            this.Language = language;
            this.Country = country;
        }

        #region Properties Region

        /// <summary>
        /// Gets the user profile id.
        /// </summary>
        /// <value>The user profile id.</value>
        public long UserId { get; private set; }

        /// <summary>
        /// Gets the first name.
        /// </summary>
        /// <value>The <c>firstName</c></value>
        public string Name { get; private set; }


        /// <summary>
        /// Gets the encrypted password.
        /// </summary>
        /// <value>The <c>encryptedPassword.</c></value>
        public string EncryptedPassword { get; private set; }

        /// <summary>
        /// Gets the language code.
        /// </summary>
        /// <value>The language code.</value>
        public string Language { get; private set; }

        /// <summary>
        /// Gets the country code.
        /// </summary>
        /// <value>The country code.</value>
        public string Country { get; private set; }


        #endregion

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
            String strLoginResult;

            strLoginResult =
                "[ userProfileId = " + UserId + " | " +
                "firstName = " + Name + " | " +
                "encryptedPassword = " + EncryptedPassword + " | " +
                "language = " + Language + " | " +
                "country = " + Country + " ]";

            return strLoginResult;
        }

        public override bool Equals(object obj)
        {

            LoginResult target = (LoginResult)obj;

            return (this.Name == target.Name)
                   && (this.EncryptedPassword == target.EncryptedPassword)
                   && (this.Language == target.Language)
                   && (this.Country == target.Country);
        }

        public override int GetHashCode()
        {
            string strLoginResult = this.ToString();

            return strLoginResult.GetHashCode();
        }

    }
}
