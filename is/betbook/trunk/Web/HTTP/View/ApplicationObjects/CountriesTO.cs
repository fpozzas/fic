using System;
using System.Data;
using System.Data.Common;

using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Web.Properties;


namespace Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects
{

    /// <summary>
    /// Summary description for Countries
    /// </summary>
    public class CountriesTO
    {

        private static DataSet dsCountries = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="Countries"/> class.
        /// </summary>
        public CountriesTO()
        {

            String providerName =
                Settings.Default.Betbook_providerInvariantName;

            String connectionString =
                Settings.Default.Betbook_connectionString;

            DbProviderFactory dbProviderFactory =
                DbProviderFactories.GetFactory(providerName);

            DbConnection connection = dbProviderFactory.CreateConnection();
            connection.ConnectionString = connectionString;
            connection.Open();

            DbDataAdapter daCountries = dbProviderFactory.CreateDataAdapter();
            DbCommand selectCommand = dbProviderFactory.CreateCommand();
            selectCommand.CommandText = "select * from Countries";
            selectCommand.Connection = connection;
            daCountries.SelectCommand = selectCommand;

            dsCountries = new DataSet("Countries");

            daCountries.FillSchema(dsCountries, SchemaType.Source, "Countries");
            daCountries.Fill(dsCountries, "Countries");

            connection.Close();

        }

        /// <summary>
        /// Gets the country names for an specific language code.
        /// </summary>
        /// <param name="languageCode">The language code.</param>
        public DataView GetCountries(String languageCode)
        {

            DataView dvCountries =
                new DataView(dsCountries.Tables["Countries"]);

            dvCountries.RowFilter = "languageCode='" + languageCode + "'";
            dvCountries.Sort = "countryName";

            return dvCountries;
        }
    }


}