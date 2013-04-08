CREATE TABLE dept (
    deptno numeric(2,0) NOT NULL,
    dname character varying(14),
    loc character varying(13),
    CONSTRAINT dept_pkey PRIMARY KEY (deptno)
);

CREATE TABLE emp (
    empno numeric(4,0) NOT NULL,
    ename character varying(10),
    job character varying(9),
    mgr numeric(4,0),
    hiredate date,
    sal numeric(7,2),
    comm numeric(7,2),
    deptno numeric(2,0),
    CONSTRAINT emp_pkey PRIMARY KEY (empno),
    CONSTRAINT emp_deptno_fkey FOREIGN KEY (deptno) REFERENCES dept(deptno),
    CONSTRAINT emp_mgr_fkey FOREIGN KEY (mgr) REFERENCES emp(empno)
);

INSERT INTO dept (deptno, dname, loc) VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept (deptno, dname, loc) VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept (deptno, dname, loc) VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept (deptno, dname, loc) VALUES (40, 'OPERATIONS', 'BOSTON');

insert into emp values (7839, 'KING'   ,    'PRESIDENT',   NULL, to_date('17/11/81','dd/mm/yy') ,      5000,       NULL,     10);        
insert into emp values (7566, 'JONES'  ,    'MANAGER'  ,   7839, to_date('02/04/81','dd/mm/yy') ,      2975,       NULL,     20);        
insert into emp values (7902, 'FORD'   ,    'ANALYST'  ,   7566, to_date('03/12/81','dd/mm/yy') ,      3000,       NULL,     20);        
insert into emp values (7369, 'SMITH'  ,    'CLERK'    ,   7902, to_date('17/12/80','dd/mm/yy') ,       800,       NULL,     20);
insert into emp values (7698, 'BLAKE'  ,    'MANAGER'  ,   7839, to_date('01/05/81','dd/mm/yy') ,      2850,       NULL,     30);        
insert into emp values (7499, 'ALLEN'  ,    'SALESMAN' ,   7698, to_date('20/02/81','dd/mm/yy') ,      1600,        300,     30);        
insert into emp values (7521, 'WARD'   ,    'SALESMAN' ,   7698, to_date('22/02/81','dd/mm/yy') ,      1250,        500,     30);        
insert into emp values (7654, 'MARTIN' ,    'SALESMAN' ,   7698, to_date('28/09/81','dd/mm/yy') ,      1250,       1400,     30);        
insert into emp values (7782, 'CLARK'  ,    'MANAGER'  ,   7839, to_date('09/06/81','dd/mm/yy') ,      2450,       NULL,     10);        
insert into emp values (7788, 'SCOTT'  ,    'ANALYST'  ,   7566, to_date('09/12/82','dd/mm/yy') ,      3000,       NULL,     20);        
insert into emp values (7844, 'TURNER' ,    'SALESMAN' ,   7698, to_date('08/09/81','dd/mm/yy') ,      1500,          0,     30);        
insert into emp values (7876, 'ADAMS'  ,    'CLERK'    ,   7788, to_date('12/01/83','dd/mm/yy') ,      1100,       NULL,     20);        
insert into emp values (7900, 'JAMES'  ,    'CLERK'    ,   7698, to_date('03/12/81','dd/mm/yy') ,       950,       NULL,     30);        
insert into emp values (7934, 'MILLER' ,    'CLERK'    ,   7782, to_date('23/01/82','dd/mm/yy') ,      1300,       NULL,     10);        

