CREATE TABLE clientes
  (dni NUMBER(8) NOT NULL,
  nombre VARCHAR2(25) NOT NULL,
  apellido1 VARCHAR2(25) NOT NULL,
  apellido2 VARCHAR2(25),
  telefono NUMBER(9),
  PRIMARY KEY (dni)
);

CREATE TABLE tiposhab
  (denominacion VARCHAR2(50) NOT NULL,
  precio NUMBER(6,2),
  plazas NUMBER(1),
  PRIMARY KEY (denominacion),
  CONSTRAINT precioplazas CHECK (precio>0 AND plazas>0)
);

CREATE TABLE habitaciones
  (numero NUMBER(4) NOT NULL,
  denominacion VARCHAR2(50) NOT NULL,
  PRIMARY KEY (numero),
  FOREIGN KEY (denominacion) REFERENCES tiposhab (denominacion),
  CONSTRAINT numero CHECK (numero>0)
);

CREATE TABLE estancias
  (id NUMBER(9) NOT NULL,
  idc NUMBER(9) NOT NULL,
  idh NUMBER(4),
  fechaentrada DATE,
  duracion NUMBER(2),
  fechareserva DATE,
  estado VARCHAR2(1),
  formapago VARCHAR2(1),
  detallespago VARCHAR2(50),
  total NUMBER(9,2),
  PRIMARY KEY (id),
  FOREIGN KEY (idc) REFERENCES clientes (dni),
  FOREIGN KEY (idh) REFERENCES habitaciones (numero),
  CONSTRAINT
    estancia
    CHECK
      (estado IN ('R','C','P')
      AND formapago IN ('T','M','C')
      AND duracion>0
      AND duracion<=30
      AND fechareserva<=fechaentrada
      AND total>0)
);

CREATE TABLE consumos
  (ide NUMBER(9) NOT NULL,
  nombreservicio VARCHAR2(50) NOT NULL,
  fecha DATE NOT NULL,
  PRIMARY KEY (ide, nombreservicio, fecha),
  FOREIGN KEY (ide) REFERENCES estancias (id)
);

CREATE TABLE servicios
  (nombre VARCHAR2(50) NOT NULL,
  ppu NUMBER(6,2),
  PRIMARY KEY (nombre),
  CONSTRAINT ppu CHECK (ppu>=0)
);

DROP TABLE clientes CASCADE CONSTRAINTS;
DROP TABLE estancias CASCADE CONSTRAINTS;
DROP TABLE tiposhab CASCADE CONSTRAINTS;
DROP TABLE habitaciones CASCADE CONSTRAINTS;
DROP TABLE servicios CASCADE CONSTRAINTS;
DROP TABLE consumos CASCADE CONSTRAINTS;
