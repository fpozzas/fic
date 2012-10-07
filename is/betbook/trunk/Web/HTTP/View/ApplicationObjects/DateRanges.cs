using System;
using System.Collections;


namespace Es.Udc.DotNet.Betbook.Web.HTTP.View.ApplicationObjects
{
    public class DateRanges
    {
        private const int FIRST_DAY = 1;
        private const int LAST_DAY = 31;
        private const int FIRST_MONTH = 1;
        private const int LAST_MONTH = 12;
        private const int FIRST_YEAR = 1990;

        private static readonly IList days;
        private static readonly IList months;
        private static readonly IList years;

        #region Properties

        public static IList Days
        {
            get { return days; }
        }

        public static IList Months
        {
            get { return months; }
        }

        public static IList Years
        {
            get { return years; }
        }

        #endregion

        private DateRanges() {} 

        static DateRanges()
        {
            days = GetRange(FIRST_DAY, LAST_DAY);
            months = GetRange(FIRST_MONTH, LAST_MONTH);
            years = GetYears();
        }

        public static IList GetYears()
        {
            return GetRange(FIRST_YEAR, GetLastYear());
        }

        public static int GetLastYear()
        {
            return DateTime.Today.Year;
        }

        private static IList GetRange(int start, int end)
        {
            IList range = new ArrayList();

            for (int i = start; i <= end; i++)
            {
                range.Add(i);
            }

            return range;
        }
    }
}
