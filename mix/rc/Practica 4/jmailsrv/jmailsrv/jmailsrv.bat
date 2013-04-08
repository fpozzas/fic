REM ------------ JAVA MAILSERVER 0.99 --------------
REM copyright 1998 computer Mutter
REM copyright 1999 Johannes Plachy ( JMailServ@jps.at)
REM ------------------------------------------------
REM This batchfile starts the server itself
REM ------------------------------------------------

set CLASSPATH=%CLASSPATH%;.\jmailsrv.jar;

REM ------------------------------------------------
REM enable the following line for remote or dynamic configuration
REM start rmiregistry

java at.jps.mailserver.MailServer .\jmailsrv.cfg
