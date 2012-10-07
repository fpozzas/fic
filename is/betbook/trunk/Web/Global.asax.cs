using System;
using System.Configuration;
using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using Es.Udc.DotNet.Betbook.Web.HTTP.Session;
using Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects;

namespace Es.Udc.DotNet.Betbook
{
    public class Global : System.Web.HttpApplication
    {
        /// <summary>
        /// The language and country information is loaded when applicattion 
        /// starts. It will be used in the combo boxes.
        /// </summary>
        protected void Application_Start(object sender, EventArgs e)
        {
            Application.Lock();

            /*
             * We read the UnityConfigurationSection from the default 
             * configuration file, App.config, and then populate the 
             * UnityContainer.
             */
            IUnityContainer container = new UnityContainer();

            UnityConfigurationSection section =
                (UnityConfigurationSection)ConfigurationManager.GetSection("unity");

            section.Containers.Default.Configure(container);

            Application["UnityContainer"] = container;

            // Load Locale Info
            Application["Languages"] = new LanguagesTO();
            Application["Countries"] = new CountriesTO();

            Application.UnLock();
        }

        protected void Application_End(object sender, EventArgs e)
        {
            ((UnityContainer)Application["UnityContainer"]).Dispose();
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            SessionManager.TouchSession(Context);
        }
    }
}
