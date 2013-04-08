CREATE TABLE DEPT (
    deptno numeric(2,0) NOT NULL,
    dname character varying(14),
    loc character varying(13),
    CONSTRAINT dept_pkey PRIMARY KEY (deptno)
);

CREATE TABLE EMP (
    empno numeric(4,0) NOT NULL,
    ename character varying(10),
    job character varying(9),
    mgr numeric(4,0),
    hiredate date,
    sal numeric(7,2),
    comm numeric(7,2),
    deptno numeric(2,0),
    CONSTRAINT emp_pkey PRIMARY KEY (EMPNO),
    CONSTRAINT emp_deptno_fkey FOREIGN KEY (deptno) REFERENCES DEPT(deptno),
    CONSTRAINT emp_mgr_fkey FOREIGN KEY (mgr) REFERENCES EMP(empno)
);

INSERT INTO DEPT (deptno, dname, loc) VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT (deptno, dname, loc) VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO DEPT (deptno, dname, loc) VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO DEPT (deptno, dname, loc) VALUES (40, 'OPERATIONS', 'BOSTON');

insert into EMP values (7839, 'KING'   ,    'PRESIDENT',   NULL, STR_TO_DATE('17/11/81','dd/mm/yy') ,      5000,       NULL,     10);        
insert into EMP values (7566, 'JONES'  ,    'MANAGER'  ,   7839, STR_TO_DATE('02/04/81','dd/mm/yy') ,      2975,       NULL,     20);        
insert into EMP values (7902, 'FORD'   ,    'ANALYST'  ,   7566, STR_TO_DATE('03/12/81','dd/mm/yy') ,      3000,       NULL,     20);        
insert into EMP values (7369, 'SMITH'  ,    'CLERK'    ,   7902, STR_TO_DATE('17/12/80','dd/mm/yy') ,       800,       NULL,     20);
insert into EMP values (7698, 'BLAKE'  ,    'MANAGER'  ,   7839, STR_TO_DATE('01/05/81','dd/mm/yy') ,      2850,       NULL,     30);        
insert into EMP values (7499, 'ALLEN'  ,    'SALESMAN' ,   7698, STR_TO_DATE('20/02/81','dd/mm/yy') ,      1600,        300,     30);        
insert into EMP values (7521, 'WARD'   ,    'SALESMAN' ,   7698, STR_TO_DATE('22/02/81','dd/mm/yy') ,      1250,        500,     30);        
insert into EMP values (7654, 'MARTIN' ,    'SALESMAN' ,   7698, STR_TO_DATE('28/09/81','dd/mm/yy') ,      1250,       1400,     30);        
insert into EMP values (7782, 'CLARK'  ,    'MANAGER'  ,   7839, STR_TO_DATE('09/06/81','dd/mm/yy') ,      2450,       NULL,     10);        
insert into EMP values (7788, 'SCOTT'  ,    'ANALYST'  ,   7566, STR_TO_DATE('09/12/82','dd/mm/yy') ,      3000,       NULL,     20);        
insert into EMP values (7844, 'TURNER' ,    'SALESMAN' ,   7698, STR_TO_DATE('08/09/81','dd/mm/yy') ,      1500,          0,     30);        
insert into EMP values (7876, 'ADAMS'  ,    'CLERK'    ,   7788, STR_TO_DATE('12/01/83','dd/mm/yy') ,      1100,       NULL,     20);        
insert into EMP values (7900, 'JAMES'  ,    'CLERK'    ,   7698, STR_TO_DATE('03/12/81','dd/mm/yy') ,       950,       NULL,     30);        
insert into EMP values (7934, 'MILLER' ,    'CLERK'    ,   7782, STR_TO_DATE('23/01/82','dd/mm/yy') ,      1300,       NULL,     10);        

CREATE TABLE PRO (
  projno numeric(4,0) NOT NULL,
  pname  character varying(10),
  loc    character varying(13),
  deptno numeric(2,0));

CREATE TABLE EMPPRO (
  empno  numeric(4,0) NOT NULL,
  projno numeric(4,0) NOT NULL,
  hours  numeric(2,0));

INSERT INTO PRO VALUES (1001, 'P1', 'BOSTON', 20);
INSERT INTO PRO VALUES (1004, 'P4', 'CHICAGO', 30);
INSERT INTO PRO VALUES (1005, 'P5', 'CHICAGO', 30);
INSERT INTO PRO VALUES (1006, 'P6', 'LOS ANGELES', 30);
INSERT INTO PRO VALUES (1008, 'P8', 'NEW YORK', 30);

INSERT INTO EMPPRO VALUES (7499,1004,15);
INSERT INTO EMPPRO VALUES (7499,1005,12);
INSERT INTO EMPPRO VALUES (7521,1004,10);
INSERT INTO EMPPRO VALUES (7521,1008,8);
INSERT INTO EMPPRO VALUES (7654,1001,16);
INSERT INTO EMPPRO VALUES (7654,1006,15);
INSERT INTO EMPPRO VALUES (7654,1008, 5);
INSERT INTO EMPPRO VALUES (7844,1005,6);
INSERT INTO EMPPRO VALUES (7844,1005,10);
INSERT INTO EMPPRO VALUES (7844,1008,4);
