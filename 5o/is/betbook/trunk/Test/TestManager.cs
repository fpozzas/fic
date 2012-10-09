using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.Unity;
using Microsoft.Practices.Unity.Configuration;
using System.Configuration;

namespace Es.Udc.DotNet.Betbook.Test
{
    public class TestManager
    {
        public static IUnityContainer ConfigureUnityContainer(string sectionName)
        {
            IUnityContainer container = new UnityContainer();

            UnityConfigurationSection section =
                (UnityConfigurationSection)ConfigurationManager.GetSection(sectionName);

            section.Containers.Default.Configure(container);

            return container;
        }


        public static void ClearUnityContainer(IUnityContainer container)
        {
            container.Dispose();
        }
    }
}
