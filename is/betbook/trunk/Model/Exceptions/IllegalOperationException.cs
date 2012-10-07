using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Es.Udc.DotNet.Betbook.Model
{
    public class IllegalOperationException : Exception
    {
        public readonly string exceptionText;
        public IllegalOperationException(string exceptionText)
            : base("Illegal operation exception => " + exceptionText)
        {
            this.exceptionText = exceptionText;
        }
    }
}
