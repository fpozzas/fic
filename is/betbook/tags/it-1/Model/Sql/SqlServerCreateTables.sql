/* 
 * SQL Server Script
 * 
 * This script can be directly executed to configure the test database from
 * PCs located at CECAFI Lab. The database and the corresponding users are 
 * already created in the sql server, so it will create the tables needed 
 * in the samples. 
 * 
 * In a local environment (for example, with the SQLServerExpress instance 
 * included in the VStudio installation) it will be necessary to create the 
 * database and the user required by the connection string. So, the following
 * steps are needed:
 *
 *   1) Uncomment lines between [BEGIN] and [END] Local Configuration 
 *      (remove -- characters before each line)
 *   2) Configure within the CREATE DATABASE sql-sentence the path where 
 *      database and log files will be created  
 *
 * This script can be executed from MS Sql Server Management Studio Express,
 * but also it is possible to use a command Line syntax:
 *
 *    > sqlcmd.exe -U [user] -P [password] -I -i SqlServerCreateTables.sql
 *
 */



-- /* [BEGIN] Local Configuration */

--USE [master]
--GO

--/****** Drop database if already exists  ******/
--IF  EXISTS (SELECT name FROM sys.databases WHERE name = 'PracticaIS')
--DROP DATABASE [PracticaIS]
--GO

--USE [master]
--GO

--/* DataBase Creation */


--CREATE DATABASE PracticaIS ON  PRIMARY 
--( NAME = 'PracticaIS', FILENAME = 'C:\Database\PracticaIS.mdf')
--LOG ON
--( NAME = 'PracticaIS_log', FILENAME = 'C:\Database\PracticaIS_log.ldf')
--GO


--/* Create LoginUser */
--IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'user')
--CREATE LOGIN [user]
--WITH   PASSWORD='password',
--	   DEFAULT_DATABASE=[Betbook],
--	   DEFAULT_LANGUAGE=[Español],
--	   CHECK_EXPIRATION=OFF,
--	   CHECK_POLICY=OFF
--GO


--/* Set user as database owner */
--USE PracticaIS
--GO

--SP_CHANGEDBOWNER 'user'
--GO


--/* [END] Local Configuration */


/*
 * Drop tables.
 * NOTE: before dropping a table (when re-executing the script), the tables
 * having columns acting as foreign keys of the table to be dropped must be
 * dropped first (otherwise, the corresponding checks on those tables could
 * not be done).
 */

USE Test


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[CommentTags]') 
AND type in ('U')) DROP TABLE [CommentTags]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Tag]') 
AND type in ('U')) DROP TABLE [Tag]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[RecommendationGroups]') 
AND type in ('U')) DROP TABLE [RecommendationGroups]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Recommendation]') 
AND type in ('U')) DROP TABLE [Recommendation]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Comment]') 
AND type in ('U')) DROP TABLE [Comment]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Favourite]') 
AND type in ('U')) DROP TABLE [Favourite]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[GroupUsers]') 
AND type in ('U')) DROP TABLE [GroupUsers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Group]') 
AND type in ('U')) DROP TABLE [Group]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[User]') 
AND type in ('U')) DROP TABLE [User]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Country]')
AND type in ('U'))
DROP TABLE [Country]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('[Language]')
AND type in ('U'))
DROP TABLE [Language]
GO


CREATE TABLE Language(
	languageCode nchar(2) NOT NULL,
	languageName varchar(50) NOT NULL,
	
 CONSTRAINT PK_Language PRIMARY KEY (languageCode)
)

CREATE TABLE Country (
    countryCode nchar(2) NOT NULL,
	countryName varchar(50) NOT NULL,
	languageCode nchar(2) NOT NULL,

    CONSTRAINT PK_Country PRIMARY KEY (countryCode, languageCode),
    CONSTRAINT FK_Language FOREIGN KEY (languageCode) REFERENCES Language (languageCode)
)



CREATE TABLE [User](
	userId bigint IDENTITY(1,1) NOT NULL,
	login varchar(50) UNIQUE NOT NULL,
	encPassword varchar(50) NOT NULL,
	name varchar(50) NOT NULL,
	surname varchar(50),
	email varchar(50),
	countryCode nchar(2),
	languageCode nchar(2),
	
	CONSTRAINT [PK_User] PRIMARY KEY (userId ASC)
)

CREATE NONCLUSTERED INDEX IX_UserIndexByUserId
ON [User] (userId);


CREATE TABLE Comment (
	commentId bigint IDENTITY(1,1) NOT NULL,
    userId bigint NOT NULL,
	text ntext NOT NULL,
    date datetime NOT NULL,
    eventId bigint NOT NULL,
    
    CONSTRAINT [PK_Comment] PRIMARY KEY (commentId ASC),
    
    CONSTRAINT [FK_CommentUserId] FOREIGN KEY(userId)
        REFERENCES [User] (userId) ON DELETE CASCADE
)

CREATE NONCLUSTERED INDEX IX_FK_CommentIndexByCommentId
ON Comment (commentId);


CREATE TABLE Favourite (
	favouriteId bigint IDENTITY(1,1) NOT NULL,
    userId bigint NOT NULL,
    date datetime NOT NULL,
    eventId bigint NOT NULL,
    name varchar(40),
    comment ntext,
    
    CONSTRAINT [PK_Favourite] PRIMARY KEY (favouriteId ASC),
    
    CONSTRAINT [FK_FavouriteUserId] FOREIGN KEY(userId)
        REFERENCES [User] (userId) ON DELETE CASCADE
)


CREATE TABLE [Group] (
	groupId bigint IDENTITY(1,1) NOT NULL,
    creatorId bigint NOT NULL,
    name varchar(50) NOT NULL,
    description ntext,
    
    CONSTRAINT [PK_Group] PRIMARY KEY (groupId ASC),
    
    CONSTRAINT [FK_GroupCreatorId] FOREIGN KEY(creatorId)
        REFERENCES [User] (userId) ON DELETE CASCADE
)


CREATE TABLE [GroupUsers] (
	groupId bigint NOT NULL,
	userId bigint NOT NULL,
    
    CONSTRAINT [PK_GroupUsers] PRIMARY KEY (groupId ASC, userId ASC),
    
    CONSTRAINT [FK_GroupUsersGroupId] FOREIGN KEY(groupId)
        REFERENCES [Group] (groupId),
    CONSTRAINT [FK_GroupUsersUserId] FOREIGN KEY(userId)
        REFERENCES [User] (userId)
)


CREATE TABLE Recommendation (
	recId bigint IDENTITY(1,1) NOT NULL,
	userId bigint NOT NULL,
	eventId bigint NOT NULL,
	date datetime NOT NULL,
	text ntext,
	
	CONSTRAINT [PK_Recommendation] PRIMARY KEY (recId ASC),
	
	CONSTRAINT [FK_RecommendationUserId] FOREIGN KEY(userId)
        REFERENCES [User] (userId)
)


CREATE TABLE RecommendationGroups (
	groupId bigint NOT NULL,
	recId bigint NOT NULL,
    
    CONSTRAINT [PK_RecommendationGroups] PRIMARY KEY (groupId ASC, recId ASC),
    
    CONSTRAINT [FK_RecommendationGroupsGroupId] FOREIGN KEY(groupId)
        REFERENCES [Group] (groupId),
    CONSTRAINT [FK_RecommendationGroupsRecommendationId] FOREIGN KEY(recId)
        REFERENCES Recommendation (recId)
)


CREATE TABLE Tag (
	tagId bigint IDENTITY(1,1) NOT NULL,
	text varchar(30) UNIQUE NOT NULL,
    
    CONSTRAINT [PK_Tag] PRIMARY KEY (tagId ASC)
)


CREATE TABLE CommentTags (
	commentId bigint NOT NULL,
	tagId bigint NOT NULL,
    
    CONSTRAINT [PK_CommentTags] PRIMARY KEY (commentId ASC, tagId ASC),
    
    CONSTRAINT [FK_CommentTagsCommentId] FOREIGN KEY(commentId)
        REFERENCES Comment (commentId),
    CONSTRAINT [FK_CommentTagsTagId] FOREIGN KEY(tagId)
        REFERENCES Tag (tagId)
)


GO


:r i18n.sql
GO