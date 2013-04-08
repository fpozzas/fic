REM ------------ JAVA MAILSERVER 0.99 --------------
REM copyright 1998 computer Mutter
REM copyright 1999 Johannes Plachy ( JMailServ@jps.at)
REM ------------------------------------------------
REM This batchfile creates a mail user account
REM ------------------------------------------------

rem you have to specify directory where user.cfg should be updated, 
rem the name and the password for one user at a time

rem example:
rem java at.jps.mailserver.UserList PathForUserCfg Username Password

set CLASSPATH=%CLASSPATH%;.\jmailsrv.jar

java at.jps.mailserver.UserList . %1 %2

