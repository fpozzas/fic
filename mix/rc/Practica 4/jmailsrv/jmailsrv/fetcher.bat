REM ------------ JAVA MAILSERVER 0.99 --------------
REM copyright 1998 computer Mutter
REM copyright 1999 Johannes Plachy ( JMailServ@jps.at)
REM ------------------------------------------------
REM This batchfile starts the fetcher utility
REM which retrieves email from remote POP accounts
REM ------------------------------------------------


set CLASSPATH=%CLASSPATH%;.\jmailsrv.jar;


java at.jps.mailserver.Fetcher .\jmailsrv.cfg
