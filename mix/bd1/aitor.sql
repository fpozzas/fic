CREATE TABLE habitacion (NH NUMBER(4) NOT NULL, DES VARCHAR(15), PRE NUMBER(5) NOT NULL, PRIMARY KEY(NH));

CREATE TABLE cliente (DNI CHAR(9) NOT NULL, NOMBRE VARCHAR(10) NOT NULL, APE VARCHAR(10) NOT NULL, TLF NUMBER(9), DIR VARCHAR(10), PRIMARY KEY(DNI));

CREATE TABLE estancia (NE INT NOT NULL, FE DATE NOT NULL, FS DATE NOT NULL, DNI CHAR(9) NOT NULL, PRIMARY KEY(NE), FOREIGN KEY(DNI) REFERENCES cliente(DNI));

CREATE TABLE estancia_en (NH NUMBER(4) NOT NULL, NE NUMBER(4) NOT NULL, DIAS CHAR(4), SUBT NUMBER(5), PRIMARY KEY(NH,NE), FOREIGN KEY(NE) REFERENCES estancia(NE), FOREIGN KEY(NH) REFERENCES habitacion(NH));

CREATE TABLE reserva (NR INT NOT NULL, DNI CHAR(9) NOT NULL, PRIMARY KEY(NR), FOREIGN KEY(DNI) REFERENCES cliente(DNI));


CREATE TABLE reserva_en (NR NUMBER(4) NOT NULL, NH NUMBER(4) NOT NULL, FRE DATE, FRS DATE, PRIMARY KEY(NH,NR), FOREIGN KEY(NR) REFERENCES reserva(NR), FOREIGN KEY(NH) REFERENCES habitacion(NH));


CREATE TABLE factura (NF INT NOT NULL, FECH DATE, NE INT NOT NULL, DNI CHAR(9) NOT NULL, PRIMARY KEY(NF), FOREIGN KEY(DNI) REFERENCES cliente(DNI), FOREIGN KEY(NE) REFERENCES estancia(NE));


CREATE TABLE servicios (NS INT NOT NULL, NOM CHAR(9) NOT NULL,PRE NUMBER(5) NOT NULL, PRIMARY KEY(NS));

CREATE TABLE cobros (NC NUMBER(4) NOT NULL, NF INT NOT NULL, CANT NUMBER(2), SUBT INT, NS INT, PRIMARY KEY(NC,NF), FOREIGN KEY(NF) REFERENCES factura(NF), FOREIGN KEY(NS) REFERENCES servicios(NS));


INSERT INTO habitacion VALUES('32','asd','3');
INSERT INTO cliente VALUES('5456464','Estupido','Caca','123123','uasa');
INSERT INTO estancia VALUES('3',TO_DATE('12/01/1997','dd/mm/yyyy'),NULL,'78745458');
INSERT INTO estancia_en VALUES('32','3','1','320');
INSERT INTO reserva VALUES('2','5456464');
INSERT INTO reserva_en VALUES('1','2',TO_DATE('15/01/1997','dd/mm/yyyy'),TO_DATE('18/01/1997','dd/mm/yyyy'));
INSERT INTO factura VALUES('3',TO_DATE('4/01/1997','dd/mm/yyyy'),'2','5456464');
INSERT INTO servicios VALUES('2','pis','10');
INSERT INTO cobros VALUES('1','3','2','23','1');

MUESTRA LAS ESTANCIAS ENTRE LAS FECHAS PROPORCIONADAS:
SELECT * FROM estancia WHERE (FE >= TO_DATE('12/01/1997','dd/mm/yyyy') AND FE <= TO_DATE('18/01/1997','dd/mm/yyyy'));


MUESTRA LOS DATOS DE LOS SERVICIOS DE LA FACTURA NUMERO UNO:
SELECT c.NF, c.NC, s.NOM, c.CANT, c.SUBT FROM cobros c  JOIN  servicios s ON c.NS = s.NS WHERE c.NF = 1;


MUESTRA LOS DATOS DE TODAS LAS  ESTANCIAS DEL CLIENTE CON DNI = 78745458:
SELECT e.NE, s.NH, s.DIAS, s.SUBT, e.FE, e.FS FROM estancia e JOIN estancia_en s ON e.NE = s.NE WHERE e.DNI = '78745458';


MUESTRA LOS GASTOS EN SERVICIOS DEL CLIENTE CON DNI = 5456464:
SELECT f.NF, SUM(c.SUBT) AS TOTAL_SERVICIOS FROM cobros c JOIN factura f ON c.NF = f.NF WHERE f.DNI='5456464' GROUP BY f.NF;

MUESTRA LOS GASTOS EN ESTANCIAS DEL CLIENTE CON DNI = 78745458:
SELECT e.NE, SUM(s.SUBT) AS TOTAL_ESTANCIA FROM estancia e JOIN estancia_en s ON e.NE = s.NE WHERE e.DNI='78745458' GROUP BY e.NE;


MUESTRA LOS DATOS DE TODAS LAS  RESERVAS DEL CLIENTE CON DNI = 78745458:
SELECT r.NR, e.NH, e.FRE, e.FRS FROM reserva r JOIN reserva_en e ON r.NR = e.NR WHERE r.DNI = '78745458';

MUESTRA EL GASTO TOTAL Y EL GASTO MEDIO EN SERVICIOS DE TODOS LOS CLIENTES ENTRE DOS FECHAS:
SELECT SUM(c.SUBT) as GASTO_TOTAL,AVG(c.SUBT) AS GASTO_PROMEDIO FROM cobros c JOIN factura f ON c.NF=f.NF WHERE FECH BETWEEN TO_DATE('1/01/1997','dd/mm/yyyy') AND TO_DATE('16/01/1997','dd/mm/yyyy');