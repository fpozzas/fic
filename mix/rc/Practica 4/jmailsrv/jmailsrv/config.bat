REM ------------ JAVA MAILSERVER 0.99 --------------
REM copyright 1998 computer Mutter
REM copyright 1999 Johannes Plachy ( JMailServ@jps.at)
REM ------------------------------------------------
REM This batchfile starts the configuration utility (GUI)
REM ------------------------------------------------

set CLASSPATH=%CLASSPATH%;.\jmailsrv.jar;

REM ------------------------------------------------
REM use the following line for static configuration
java at.jps.mailserver.gui.SettingsFrame -f .\jmailsrv.cfg


REM ------------------------------------------------
REM use the folloeing linr to modify the configuration of a running server
rem java at.jps.mailserver.gui.SettingsFrame -c localhost
