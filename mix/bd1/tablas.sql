----------------------
CREACION DE LAS TABLAS
----------------------


CREATE TABLE clientes
	(DNI NUMERIC(8) NOT NULL,
	APELLIDOS VARCHAR(30) NOT NULL,
	NOMBRE VARCHAR(15) NOT NULL,
	DIR VARCHAR(30),
	TLF NUMERIC(9),
	CIUDAD VARCHAR(15),
	PRIMARY KEY (DNI)
);

CREATE TABLE reservas
	(CODR NUMERIC(10) NOT NULL,
	DNI NUMERIC(8) NOT NULL,
	FECHAIN DATE NOT NULL,
	FECHAOUT DATE NOT NULL,
	PRECIOTOT NUMERIC(9,2),
	ESTADO VARCHAR(1),
	PRIMARY KEY (CODR),
	FOREIGN KEY (DNI) REFERENCES clientes (DNI),
	CONSTRAINT reservas
		CHECK 
			(FECHAIN<=FECHAOUT
			AND PRECIOTOT>0
			AND ESTADO IN ('C','P','E'))
);


CREATE TABLE tiposhab
	(TIPOHAB VARCHAR(20) NOT NULL,
	PLAZAS NUMERIC(1),
	PRECIO NUMERIC(6,2),
	PRIMARY KEY (TIPOHAB),
	CONSTRAINT tiposhab CHECK (PRECIO>0 AND PLAZAS>0)
);



CREATE TABLE habitaciones
	(NUMHAB NUMERIC(4) NOT NULL,
	TIPOHAB VARCHAR(20) NOT NULL,
	PRIMARY KEY (NUMHAB),
	FOREIGN KEY (TIPOHAB) REFERENCES tiposhab (TIPOHAB)
);



CREATE TABLE habreservadas
	(CODR NUMERIC(10) NOT NULL,
	NUMHAB NUMERIC(4) NOT NULL,
	PRECIONOCHE NUMERIC(6,2) NOT NULL,
	PRIMARY KEY (CODR,NUMHAB),
	FOREIGN KEY (CODR) REFERENCES reservas (CODR),
	FOREIGN KEY (NUMHAB) REFERENCES habitaciones (NUMHAB),
	CONSTRAINT habreservadas CHECK PRECIONOCHE>0
);



CREATE TABLE servicios
	(CODS NUMERIC(4) NOT NULL,
	NOMSERVICIO VARCHAR(20) NOT NULL,
	PRECIO NUMERIC(6,2) NOT NULL,
	PRIMARY KEY (CODS),
	CONSTRAINT servicios CHECK PRECIO>0
);



CREATE TABLE factura
	(CODF NUMERIC(10) NOT NULL,
	CODR NUMERIC(10) NOT NULL,
	DNI NUMERIC(8) NOT NULL,
	FECHA DATE,
	TOTAL NUMERIC(11,2),
	PRIMARY KEY (CODF),
	FOREIGN KEY (CODR) REFERENCES reservas (CODR),
	FOREIGN KEY (DNI) REFERENCES clientes (DNI)
);



CREATE TABLE servconsumidos
	(CODF NUMERIC(10) NOT NULL,
	CODSC NUMERIC(10) NOT NULL,
	CODS NUMERIC(4) NOT NULL,
	CANTIDAD NUMERIC(3) NOT NULL,
	PRECIOUNIDAD NUMERIC(6,2) NOT NULL,
	PRECIOTOTAL NUMERIC(10,2) NOT NULL,
	PRIMARY KEY (CODF,CODSC),
	FOREIGN KEY (CODF) REFERENCES factura (CODF),
	FOREIGN KEY (CODS) REFERENCES servicios (CODS)
);

INSERT INTO clientes VALUES('72764190','Gomez Ruiz','Luis','La Plaza 20','652874123','Madrid');
INSERT INTO clientes VALUES('23556735','Rodriguez Perez','Fernando','El Puerto 33','614856523','Lugo');
INSERT INTO habitaciones VALUES('101','INDIVIDUAL');
INSERT INTO habitaciones VALUES('102','INDIVIDUAL');
INSERT INTO habitaciones VALUES('201','SUITE');
INSERT INTO habitaciones VALUES('202','SUITE');
INSERT INTO tiposhab VALUES('SUITE','2','100');
INSERT INTO tiposhab VALUES('INDIVIDUAL','1','30');
INSERT INTO reservas VALUES('1','72764190',TO_DATE('03/08/2003','dd/mm/yyyy'),TO_DATE('07/08/2003','dd/mm/yyyy'),NULL,'P');
INSERT INTO reservas VALUES('2','23556735',TO_DATE('14/08/2003','dd/mm/yyyy'),TO_DATE('16/08/2003','dd/mm/yyyy'),NULL,'P');
INSERT INTO habreservadas VALUES('1','102','30');
INSERT INTO habreservadas VALUES('2','201','90');
INSERT INTO servicios VALUES('1','SAUNA','10');
INSERT INTO servicios VALUES('2','GYM','15');
INSERT INTO factura VALUES('1','2','23556735',NULL,NULL);
INSERT INTO factura VALUES('2','1','72764190',NULL,NULL);
INSERT INTO servconsumidos VALUES('1','1','1','2','10','20');
INSERT INTO servconsumidos VALUES('1','2','2','2','15','30');
INSERT INTO servconsumidos VALUES('2','3','1','1','10','10');
INSERT INTO servconsumidos VALUES('2','4','1','1','10','10');


--------------
SENTENCIAS SQL
--------------

1) Muestra los datos de las reservas del cliente con dni 72764190:
SELECT a.CODR,a.FECHAIN,a.FECHAOUT,b.NUMHAB,b.PRECIONOCHE
FROM reservas a JOIN habreservadas b ON a.CODR = b.CODR
WHERE a.DNI = 72764190;;

2) Muestra las reservas iniciadas a partir de una fecha dada:
SELECT *
FROM reservas
WHERE FECHAIN > TO_DATE('02/08/2003','dd/mm/yyyy');;

3) Relación de servicios consumidos en la estancia/reserva 1, mostrando el nombre de los servicios, la cantidad y el precio:
SELECT a.NOMSERVICIO, b.CANTIDAD, b.PRECIOTOTAL
FROM servicios a JOIN servconsumidos b ON a.CODS = b.CODS JOIN factura c ON c.CODF = b.CODF
WHERE c.CODR = 1;;

4) Muestra todos los gastos totales del cliente con dni 72764190 en servicios:
SELECT SUM(a.PRECIOTOTAL) AS GASTOSTOTALES
FROM servconsumidos a JOIN factura b ON a.CODF = b.CODF
WHERE b.DNI = 72764190

5) Muestra el numero y el tipo de las habitaciones no disponibles entre dos fechas dadas:
SELECT b.NUMHAB,c.TIPOHAB
FROM reservas a JOIN habreservadas b ON a.CODR = b.CODR JOIN habitaciones c ON b.NUMHAB = c.NUMHAB
WHERE a.FECHAIN > TO_DATE('02/08/2003','dd/mm/yyyy') AND a.FECHAIN < TO_DATE('10/08/2003','dd/mm/yyyy') AND a.ESTADO<>'C';;

6) Mostrar el DNI de los clientes que han usado la sauna:
SELECT DISTINCT c.DNI AS NCLIENTES
FROM servicios a JOIN servconsumidos b ON a.CODS = b.CODS JOIN factura c ON c.CODF = b.CODF
WHERE NOMSERVICIO = 'SAUNA';;

7) Mostrar el número de las habitaciones tipo Suite libres el dia 15/08/2003:
SELECT NUMHAB
FROM habitaciones
WHERE TIPOHAB = 'SUITE' AND NUMHAB not IN(
	SELECT b.NUMHAB
	FROM reservas a JOIN habreservadas b ON a.CODR = b.CODR JOIN habitaciones c ON b.NUMHAB = c.NUMHAB
	WHERE a.FECHAIN <= TO_DATE('15/08/2003','dd/mm/yyyy') AND a.FECHAOUT >= TO_DATE('15/08/2003','dd/mm/yyyy') AND a.ESTADO<>'C');;

