using System;
using System.Data;
using System.Data.Common;

using Es.Udc.DotNet.Betbook.Model;
using Es.Udc.DotNet.Betbook.Web.Properties;


namespace Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects
{

    /// <summary>
    /// Load the languages from database using a disconnect approach
    /// </summary>
    public class LanguagesTO
    {

        private static DataSet dsLanguages = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="Languages"/> class.
        /// </summary>
        public LanguagesTO()
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

            DbDataAdapter daLanguages = dbProviderFactory.CreateDataAdapter();
            DbCommand selectCommand = dbProviderFactory.CreateCommand();
            selectCommand.CommandText = "select * from Languages";
            selectCommand.Connection = connection;
            daLanguages.SelectCommand = selectCommand;

            dsLanguages = new DataSet("Languages");

            daLanguages.FillSchema(dsLanguages, SchemaType.Source, "Languages");
            daLanguages.Fill(dsLanguages, "Languages");

            connection.Close();

        }

        /// <summary>
        /// Gets the languages.
        /// </summary>
        public DataView GetLanguages()
        {

            DataView dvLanguages =
                new DataView(dsLanguages.Tables["Languages"]);

            return dvLanguages;
        }
    }


}