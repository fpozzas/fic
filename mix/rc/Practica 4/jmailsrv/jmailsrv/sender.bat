REM ------------ JAVA MAILSERVER 0.99 --------------
REM copyright 1998 computer Mutter
REM copyright 1999 Johannes Plachy ( JMailServ@jps.at)
REM ------------------------------------------------
REM This batchfile starts the sender utility
REM which send outbound mail to the internet
REM ------------------------------------------------


set CLASSPATH=%CLASSPATH%;.\jmailsrv.jar;


java at.jps.mailserver.Sender .\jmailsrv.cfg
