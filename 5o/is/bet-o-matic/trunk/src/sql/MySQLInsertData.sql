SET NAMES 'utf8';

UPDATE Account SET userId = NULL;

DELETE FROM BetOption;
DELETE FROM BetType;
DELETE FROM Event;
DELETE FROM User;
DELETE FROM Account;
DELETE FROM BetOption;
DELETE FROM BetType;

INSERT INTO Account (balance) VALUES (2000);

-- la contraseña es 'admin'
INSERT INTO User (login, name, lastname, email, passwd, accId) VALUES
       ('admin', 'Mr. Admin', 'Destroyer', 'admin@evil.com', 'AIhsCpU2iKJYY', null),
       ('javo', 'Javo', 'Decoyer', 'javo@decoyer.com', 'AIhsCpU2iKJYY', (SELECT accId FROM Account));

UPDATE Account SET userId = (SELECT userId FROM User WHERE login = 'javo') WHERE accId = (SELECT accId FROM User WHERE login = 'javo');

INSERT INTO Category (name) VALUES ('EXTREME'), ('Arquitectura'), ('Masculine Enlargement'), ('Guitar solo'), ('OH SHIT'), ('wtf'), ('Fascismo'), ('Guerra Santa'), ('Sí'), ('Megáfono'), ('Hambre');
INSERT INTO Event (name, date, catId) VALUES ('.NET Wars', DATE('2010-12-31'), (SELECT catId from Category WHERE name = 'Petanca')),
                                             ('C vs C++', DATE('2022-12-31'), (SELECT catId from Category WHERE name = 'Mus')),
                                             ('Java VS Python', DATE('2011-12-31'), (SELECT catId from Category WHERE name = 'Mus')),
                                             ('C# vs C++', DATE('2030-12-31'), (SELECT catId from Category WHERE name = 'Petanca')),
                                             ('OCaml vs F#', DATE('2033-12-31'), (SELECT catId from Category WHERE name = 'Cricket')),
                                             ('Lisp vs The Universe', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Aguantar la respiración')),
                                             ('Perl vs Sanity', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'EXTREME')),
                                             ('Haskell vs Quintela', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Arquitectura')),
                                             ('Linux vs OpenBSD', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Masculine Enlargement')),
                                             ('Beagleboard vs Arduino', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Guitar solo')),
                                             ('La tortilla de piwi vs Los Inspectores de Sanidad', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'OH SHIT')),
                                             ('Vim vs Emacs', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'wtf')),
                                             ('Emacs vs XEmacs', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Guerra Santa')),
                                             ('XEmacs vs µEmacs', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Guerra Santa')),
                                             ('Dieguín vs El Mal', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Fascismo')),
                                             ('Dabo vs La A', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Megáfono')),
                                             ('¿Falta mucho?', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Sí')),
                                             ('Venga va otro evento más para que pagine', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Hambre'));

INSERT INTO BetType (question, winner, multipleWinner, eventId) VALUES
       ('¿Quién será el máximo commiteador?', true, true, (SELECT eventId FROM Event WHERE name = '.NET Wars')),
       ('¿Quien humillará al oponente?', false, true, (SELECT eventId FROM Event WHERE name = '.NET Wars')),
       ('¿Cual será el máximo commit?', false, false, (SELECT eventId FROM Event WHERE name = '.NET Wars')),
       ('¿Cual será el máximo segfaulteador?', false, true, (SELECT eventId FROM Event WHERE name = 'C vs C++')),
       ('¿Cual le gustará más a Linus Torvalds el mes que viene?', false, false, (SELECT eventId FROM Event WHERE name = 'C vs C++')),
       ('¿Cual es mejor?', false, true, (SELECT eventId FROM Event WHERE name = 'C vs C++'));

INSERT INTO BetOption (name, quota, winner, betTypeId) VALUES
       ('David', 2, true, (SELECT betTypeId FROM BetType WHERE question = '¿Quién será el máximo commiteador?')),
       ('Daniel', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quién será el máximo commiteador?')),
       ('Ismael', 9, true, (SELECT betTypeId FROM BetType WHERE question = '¿Quién será el máximo commiteador?')),

       ('David', 2, true, (SELECT betTypeId FROM BetType WHERE question = '¿Quien humillará al oponente?')),
       ('Daniel', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien humillará al oponente?')),
       ('Ismael', 9, true, (SELECT betTypeId FROM BetType WHERE question = '¿Quien humillará al oponente?')),

       ('1-50', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),
       ('51-100', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),
       ('101-150', 3.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),
       ('151-200', 4.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),
       ('201-250', 5.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),
       ('251-300', 6.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),
       ('301-sky', 7.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo commit?')),

       ('C', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo segfaulteador?')),
       ('C++', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual será el máximo segfaulteador?')),

       ('C', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual le gustará más a Linus Torvalds el mes que viene?')),
       ('C++', 3, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual le gustará más a Linus Torvalds el mes que viene?')),

       ('C', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual es mejor?')),
       ('C++', 1.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Cual es mejor?'));

-- BetState -> PENDING=0; LOSER=1; WINNER=2
-- INSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (300,DATE('1990-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'AMD' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = '¿Quien se beberá al oponente?')),0);
-- NSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (200,DATE('1975-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'IBM' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),1);
-- NSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (500,DATE('1975-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'AMD' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),2);
-- NSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (1000,DATE('2003-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'O esta' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = 'Solo hay una correcta')),0);
