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

INSERT INTO Event (name, date, catId) VALUES ('AMD vs IBM', DATE('1977-12-31'), (SELECT catId from Category WHERE name = 'Petanca')),
                                             ('AMD vs IBM Aun sin ganador', DATE('2002-12-31'), (SELECT catId from Category WHERE name = 'Mus')),
                                             ('AMD vs IBM 2', DATE('2011-12-31'), (SELECT catId from Category WHERE name = 'Mus')),
                                             ('AMD vs IBM 3', DATE('2030-12-31'), (SELECT catId from Category WHERE name = 'Petanca')),
                                             ('AMD vs IBM Reloaded', DATE('2033-12-31'), (SELECT catId from Category WHERE name = 'Cricket')),
                                             ('AMD vs IBM Revolutions', DATE('2034-12-31'), (SELECT catId from Category WHERE name = 'Aguantar la respiración'));

INSERT INTO BetType (question, winner, multipleWinner, eventId) VALUES
       ('¿Quien programará al oponente?', true, true, (SELECT eventId FROM Event WHERE name = 'AMD vs IBM')),
       ('¿Quien humillará al oponente?', false, true, (SELECT eventId FROM Event WHERE name = 'AMD vs IBM Aun sin ganador')),
       ('Solo hay una correcta', false, false, (SELECT eventId FROM Event WHERE name = 'AMD vs IBM Aun sin ganador')),
       ('¿Quien se comerá al oponente?', false, true, (SELECT eventId FROM Event WHERE name = 'AMD vs IBM 2')),
       ('¿Quien se beberá al oponente?', false, false, (SELECT eventId FROM Event WHERE name = 'AMD vs IBM 2')),
       ('¿Quien se fumará al oponente?', false, true, (SELECT eventId FROM Event WHERE name = 'AMD vs IBM 3'));

INSERT INTO BetOption (name, quota, winner, betTypeId) VALUES
       ('AMD', 2, true, (SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),
       ('IBM', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),
       ('YO', 9, true, (SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),

       ('AMD', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien humillará al oponente?')),
       ('IBM', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien humillará al oponente?')),

       ('O esta', 2, false, (SELECT betTypeId FROM BetType WHERE question = 'Solo hay una correcta')),
       ('o si no esta', 2.5, false, (SELECT betTypeId FROM BetType WHERE question = 'Solo hay una correcta')),

       ('AMD', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien se comerá al oponente?')),
       ('IBM', 3, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien se comerá al oponente?')),

       ('AMD', 2, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien se beberá al oponente?')),
       ('IBM', 1.5, false, (SELECT betTypeId FROM BetType WHERE question = '¿Quien se beberá al oponente?'));

-- BetState -> PENDING=0; LOSER=1; WINNER=2
INSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (300,DATE('1990-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'AMD' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = '¿Quien se beberá al oponente?')),0);
INSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (200,DATE('1975-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'IBM' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),1);
INSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (500,DATE('1975-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'AMD' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = '¿Quien programará al oponente?')),2);
INSERT INTO Bet (amount,date,accId,betOptionId,betState) VALUES (1000,DATE('2003-12-31'),(SELECT accId FROM User WHERE login='javo'),(SELECT betOptionId FROM BetOption WHERE name LIKE 'O esta' AND betTypeId=(SELECT betTypeId FROM BetType WHERE question = 'Solo hay una correcta')),0);
