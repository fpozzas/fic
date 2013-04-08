The E-Mail Server 0.99b ReadMe - June 2000
==============================================

Welcome to the Java(tm) E-Mail Server

This file contains valuable information regarding
the E-Mail Server, and additional information not
included in the product documentation.

This READ.ME file is divided into the following
categories:

   -  New in this version
   -  The E-Mail Server system requirements
   -  Programms in this packages
   -  How to Install
   -  Backing up your the E-Mail Server data
   -  Getting help
   -  Trademarks
   -  Your satisfaction
   -  Known bugs
   -  The jmailsrv.cfg file

===================================================
New in this version
===================================================

   - bugfix for settings GUI
   - properyfiles ar now correctly handled ( case sensitive!)

   - performance enhancements 
   - better resource management ( smaller memory footprint)
   - more logging messages
   - better recovery after unexpected connection problems
   - direct mail delivery based on MX record of destination domain
   - better support for undeliverable mail
   - better support for larger messages

   - general bugfixes
   - Alias user list
   - unknown user for undeliverable mail
   - In this version you need the Java mail package
     ( included)
   - POP3 nows the NOOP Command
   - Linux (Unix ?) support
   - statusmessages and traces are written to logfiles.
   - Swingbased GUI for configuration management
   - JDBC support: Mails can be stored in JDBC database

additional features:

   - remote administration in local network with
     RMI based configuration tool
     or over the internet with HTTP based applet.
     still under construction
   - mail traffic is displayed in a logwindow
     not fully implemented yet
===================================================
The E-Mail Server system requirements
===================================================

   Software Requirements
   ---------------------
        - fully supports 1.2 and 1.3
        - Java(tm) 1.1 and an operating system with
          TCP/IP installed.
        - Java mail from Sun not needed anymore !

=====================================================
Programms in this packages
=====================================================

   -  jmailserver.bat   The main Pop3 and SMTP Server
   -  Sender.bat        Sends the queue directory to
                        the Internet
                        ( only necessary if daemons are
                        disabled)
   -  Fetcher.bat       Fetch E-Mail accounts from the
                        Internet
                        ( only necessary if daemons are
                        disabled)
   -  AddUser.bat       cmd line tool to add usersaccounts
   -  Config.bat        GUI based tool to configure the
                        server

=====================================================
How to install
=====================================================

 - make shure JDK 1.2 is installed and accessable
 - unzip all files to a directory of your choice.
 - run Config.bat or edit the jmailsrv.cfg manually.
 - dont forget to add Users to your mailserver !!
 - now you are ready to start the server: jmailsrv.bat
 - if you are want to use the server under Linux, don't
   forget that these ports need root privileges !!

---------------

additional features:

 - to administrate your mailserver over the internet,
   you have either use a webserver which is able to
   run the provided servlet, or configure your
   mailservermachine to open the RMI ports.


 - possible configuration:

   .) mailserver on dedicated machine
   .) webserver available that supports servlets
   .) possible dedicated SQL server

   1) install provided servlet to webservermachine
      and configure as parameter "MailServerName" the
      name of your mailserver ( can be 'localhost' if it
      is the same machine)
   2) install applet and jar file to be accessible over
      the internet on your webserver. Configure MailServConf.html
      in that way that the parameter 'ServletPath' points to the
      relative path of your servlet
      ( something like "/servlets/MailServerServlet")
   3) start mailserver
      restart webserver that homes your servlet
      access MailServConf.html of the internet.


=====================================================
JDBC SQL Database for storing the emails
=====================================================

if not specified differently mails are stored using
the operatingsystems filesystem.

If you want you can use a SQL Database
(even on a remote machine !!) as your Mailstorage.

All you need is:

  - a JDBC driver for your database
  - make propriate changes to jmailsrv.cfg
  - an URL to your server/database
  - make propriate changes to jmailsrv.cfg
  - and a table in your database that has the
    following characteristics:
    ( the database is only used for mails in this version)

CREATE TABLE MESSAGES (
  id int(11) DEFAULT '0' NOT NULL auto_increment,
  user varchar(80),
  size BIGINT,
  date TIMESTAMP(14),
  msg LONGBLOB,
  PRIMARY KEY (id)
);

  - now you are ready to enable JDBC in the jmailsrv.cfg
    file and start your mailserver.

=====================================================
Backing up your the E-Mail Server data
=====================================================

       It is very important to periodically back up
   your the E-Mail Server data.

       If you wish to back up your the E-Mail Server data,
   there are a few things you should keep in mind.

   * To back up the data for an user, locate
     the user directory and copy the complete
     directory to your backup media.
   * To backup your user configuration and other related
     files, copy the user.cfg and the jmailsrv.cfg file to
     your backup media.

=====================================================
Purchasing the E-Mail Server
=====================================================

       The Java E-Mail Server is FREE !
       BUT your feedback is needed !!!!

=====================================================
Getting help
=====================================================

   Service and Technical Support
   -----------------------------

      Feel free to e-mail the the E-Mail Server
   support account.
   To ensure that you get a speedy response from
   us, make sure you include all pertinent information.
   The support e-mail address is:

             or jmailsrv@jps.at

   Defect Reporting
   ----------------

      If you encounter a bug or defect in the
   E-Mail Server, WE WANT TO HEAR ABOUT IT!  Unfortunately,
   we receive a lot of e-mail, so your cooperation in
   bug reporting is greatly appreciated.  Please use
   the following guidelines to report any bug and
   e-mail it to computer@mutter.com.  Following
   these instructions is essential to getting the
   bug properly fixed and a reply sent to you.
   Thanks!

   If you are reporting a bug, please let us know:

        - The *EXACT* steps in reproducing this bug.
     Make sure that you can reproduce this bug before
     you tell us about it.

        - If there is a problem with a specific
     e-mail message, send us the e-mail message
     as an *ATTACHMENT*. The bug report will be
     incomplete without this.

   Feature Requests
   ----------------

   If you are telling us about a feature you would
   like to request:

        - Please understand that all feature
     requests get added to a feature database.
     We do not necessarily determine on the spot
     if your feature will be in the next release
     or not.  Usually, some amount of research
     must be done before this can be determined.

====================================================
Trademarks
====================================================

OS/2 and OS/2 Warp are trademarks of International
Business Machines.

Windows 95, 98, 2000 and NT trademarks of Microsoft
Corporation.

Java is a trademark of Sun Microsystems.

====================================================
Your satisfaction
====================================================

Your satisfaction is important to us.
If you are dissatisfied with this product, or want to
report any bugs or anomalies please
contact us at

  jmailsrv@jps.at 

  or write to our mailing list 

  JMailSrv@listbot.com 

  if your problem seems to be of general interrest


====================================================
Known bugs
====================================================

-Changes at properties requiers an restart of the
 MailServer.
-remote administration not finished

====================================================
The jmailsrv.cfg file
====================================================

! Warning there have been a lot of property changes in 
  this realease !!!!

this is the general settings file for the mail server.
Please see <template.cfg> for details about the available
settings and their meaning.

sample configuration is also visible at

www.jps.at/java/tools/jms-howto.html





