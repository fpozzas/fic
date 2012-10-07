SET NAMES 'utf8';

-- Indexes for primary keys have been explicitly created. Furthermore, with
-- InnoDB tables, there must be an index where the foreign key and the
-- referenced key are listed as the FIRST columns.

-- ---------- Table for validation queries from the connection pool -----------

DROP TABLE IF EXISTS PingTable;
CREATE TABLE PingTable (foo CHAR(1));

-- -----------------------------------------------------------------------------
-- Drop tables. NOTE: before dropping a table (when re-executing the script),
-- the tables having columns acting as foreign keys of the table to be dropped,
-- must be dropped first (otherwise, the corresponding checks on those tables
-- could not be done).

DROP TABLE IF EXISTS Bet;
DROP TABLE IF EXISTS BetOption;
DROP TABLE IF EXISTS BetType;
ALTER TABLE Account DROP FOREIGN KEY AccountUserIdFK;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Event;
DROP TABLE IF EXISTS Category;

-- ------------------------------- Account ------------------------------------

CREATE TABLE Account (
    accId BIGINT NOT NULL AUTO_INCREMENT,
    balance NUMERIC(8,2) NOT NULL,
    userId BIGINT,
    version BIGINT DEFAULT 0,
    CONSTRAINT AccountPK PRIMARY KEY(accId)
    ) ENGINE = InnoDB;

CREATE INDEX AccountIndexByAccId ON Account (accId);

-- ------------------------------- User ------------------------------------

CREATE TABLE User (
    userId BIGINT NOT NULL AUTO_INCREMENT,
    login VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    passwd VARCHAR(50) NOT NULL,
    accId BIGINT,
    version BIGINT DEFAULT 0,
    CONSTRAINT UserPK PRIMARY KEY(userId),
    CONSTRAINT UserAccIdFK FOREIGN KEY(accId) REFERENCES Account (accId)
    ) ENGINE = InnoDB;

CREATE INDEX UserIndexByUserId ON User (userId);
ALTER TABLE Account ADD CONSTRAINT AccountUserIdFK FOREIGN KEY(userId) REFERENCES User (userId);

-- ------------------------------- Category ------------------------------------

CREATE TABLE Category (
    catId BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    CONSTRAINT CategoryPK PRIMARY KEY(catId)
    ) ENGINE = InnoDB;

CREATE INDEX CategoryIndexByCatId ON Category (catId);

INSERT INTO Category (name) VALUES ('Cricket'), ('Petanca'), ('Mus'), ('Aguantar la respiración');

-- ------------------------------- Event ------------------------------------

CREATE TABLE Event (
    eventId BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    date TIMESTAMP NOT NULL,
    catId BIGINT NOT NULL,
    version BIGINT DEFAULT 0,
    CONSTRAINT EventPK PRIMARY KEY(eventId),
    CONSTRAINT EventCatIdFK FOREIGN KEY(catId) REFERENCES Category (catId)
    ) ENGINE = InnoDB;

CREATE INDEX EventIndexByEventId ON Event (eventId);

-- ------------------------------- BetType ------------------------------------

CREATE TABLE BetType (
    betTypeId BIGINT NOT NULL AUTO_INCREMENT,
    question VARCHAR(400) NOT NULL,
    multipleWinner CHAR NOT NULL,
    winner CHAR NOT NULL,
    eventId BIGINT NOT NULL,
    version BIGINT DEFAULT 0,
    CONSTRAINT BetTypePK PRIMARY KEY(betTypeId),
    CONSTRAINT BetTypeEventIdFK FOREIGN KEY(eventId) REFERENCES Event (eventId)
    ) ENGINE = InnoDB;

CREATE INDEX BetTypeIndexByBetTypeId ON BetType (betTypeId);

-- ------------------------------- BetOption ------------------------------------

CREATE TABLE BetOption (
    betOptionId BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(400) NOT NULL,
    quota NUMERIC(8,2) NOT NULL,
    winner CHAR NOT NULL,
    betTypeId BIGINT NOT NULL,
    version BIGINT DEFAULT 0,
    CONSTRAINT BetOptionPK PRIMARY KEY(betOptionId),
    CONSTRAINT BetOptionBetTypeIdFK FOREIGN KEY(betTypeId) REFERENCES BetType (betTypeId),
    CONSTRAINT validQuota CHECK ( quota >= 0 )
    ) ENGINE = InnoDB;

CREATE INDEX BetOptionIndexByBetOptionId ON BetOption (betOptionId);

-- ------------------------------- Bet ------------------------------------

CREATE TABLE Bet (
    betId BIGINT NOT NULL AUTO_INCREMENT,
    amount NUMERIC(8,2) NOT NULL,
    date TIMESTAMP NOT NULL,
    accId BIGINT NOT NULL,
    betOptionId BIGINT NOT NULL,
    betState TINYINT NOT NULL,
    version BIGINT DEFAULT 0,
    CONSTRAINT BetPK PRIMARY KEY(betId),
    CONSTRAINT BetAccIdFK FOREIGN KEY(accId) REFERENCES Account (accId),
    CONSTRAINT BetBetOptionIdFK FOREIGN KEY(betOptionId) REFERENCES BetOption (betOptionId),
    CONSTRAINT validAmount CHECK ( amount >= 0 )
    ) ENGINE = InnoDB;

CREATE INDEX BetIndexByBetId ON Bet (betId);
