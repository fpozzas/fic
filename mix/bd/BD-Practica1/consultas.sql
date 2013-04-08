-- Consulta 1:
SELECT * FROM emp;

-- Consulta 2:
SELECT * FROM dept;

-- Consulta 3:
SELECT * FROM emp WHERE job='CLERK';

-- Consulta 4:
SELECT * FROM emp WHERE job='CLERK'ORDER BY ename;

-- Consulta 5:
SELECT * FROM  emp WHERE job='CLERK'ORDER BY ename;

-- Consulta 6:
SELECT empno,ename,sal FROM emp;

-- Consulta 7:
SELECT dname FROM dept;

-- Consulta 8:
SELECT dname FROM dept ORDER BY dname;

-- Consulta 9:
SELECT dname FROM dept ORDER BY loc;

-- Consulta 10:
SELECT loc, dname FROM dept ORDER BY loc desc;

-- Consulta 11:
SELECT ename,job FROM emp ORDER BY sal;

-- Consulta 12:
SELECT ename,job FROM emp ORDER BY job,sal;

-- Consulta 13:
SELECT ename,job FROM emp ORDER BY job desc,sal;

-- Consulta 14:
SELECT sal,comm FROM emp WHERE deptno=30;

-- Consulta 15:
SELECT sal,comm FROM emp WHERE deptno=30 ORDER BY comm;

-- Consulta 16 A:
SELECT comm FROM emp;

-- Consulta 16 B:
SELECT DISTINCT comm FROM emp;

-- Consulta 17:
SELECT DISTINCT ename,comm FROM emp;

-- Consulta 18:
SELECT DISTINCT ename,sal from emp;

-- Consulta 19:
SELECT DISTINCT comm,deptno FROM emp;

-- Consulta 20:
SELECT sal+1000,ename FROM emp WHERE deptno=30;

-- Consulta 21:
SELECT sal+1000 AS NUEVO_SALARIO,sal,ename FROM emp WHERE deptno=30;

-- Consulta 22:
SELECT ename FROM emp WHERE comm>(sal/2) AND comm IS NOT NULL;

-- Consulta 23:
SELECT ename FROM emp WHERE comm IS NULL OR comm<=(sal*0.25);

-- Consulta 24:
SELECT 'Nombre: '||ename AS ename,'Salario: '||sal AS sal FROM emp;

-- Consulta 25:
SELECT empno,sal,comm FROM emp WHERE empno>7500;

-- Consulta 26:
SELECT * FROM emp WHERE ename>='J%';

-- Consulta 27:
SELECT sal,comm, sal+comm AS salario_total FROM emp WHERE comm IS NOT NULL ORDER BY empno;

-- Consulta 28:
SELECT sal,comm, sal AS salario_total FROM emp WHERE comm IS NULL ORDER BY empno;

-- Consulta 29:
SELECT ename FROM emp WHERE sal>1000 AND mgr=7698;

-- Consulta 30:
SELECT ename FROM emp WHERE sal<=1000 OR mgr<>7698 OR mgr IS NULL;

-- Consulta 31:
SELECT ename,((NVL(comm,0)*100)/sal) AS porcentaje FROM emp ORDER BY ename;

-- Consulta 32:
SELECT ename FROM emp WHERE ename NOT LIKE '%LA%' AND deptno=10;

-- Consulta 33:
SELECT ename FROM emp WHERE mgr IS NULL;

-- Consulta 34:
SELECT dname FROM dept WHERE dname NOT IN ('SALES','RESEARCH') ORDER BY loc; 

-- Consulta 35:
SELECT ename,deptno FROM emp WHERE job='CLERK' AND deptno<>10 AND sal>800 ORDER BY hiredate;

-- Consulta 36:
SELECT ename,(sal/comm) AS Cociente FROM emp WHERE comm is NOT null AND comm<>0 ORDER BY ename;

-- Consulta 37:
SELECT * FROM emp WHERE ename LIKE '_____';

-- Consulta 38:
SELECT * FROM emp WHERE ename LIKE '%_____%';

-- Consulta 39:
SELECT * FROM emp WHERE (ename LIKE 'A%' AND sal>1000) OR (comm is NOT null AND deptno=30);
-- Consulta 40:
SELECT ename,sal,nvl(sal+comm,sal) AS Sueldo_Total FROM emp ORDER BY sal desc,Sueldo_Total desc;

-- Consulta 41:
SELECT ename,sal,comm FROM emp WHERE comm IS NOT NULL AND sal BETWEEN comm/2 AND comm;

-- Consulta 42:
SELECT ename,sal,comm FROM emp WHERE comm IS NOT NULL AND sal NOT BETWEEN comm/2 AND comm;

-- Consulta 43:
SELECT ename,job FROM emp WHERE job LIKE '%MAN' AND ename LIKE 'A%';

-- Consulta 44:
SELECT ename,job FROM emp WHERE ename || job LIKE 'A%MAN';

-- Consulta 45:
SELECT ename FROM emp WHERE length(ename)<=5;

-- Consulta 46:
SELECT ename,nvl(sal+comm,sal)AS SUELDO_TOTAL,nvl(sal+comm,sal)*1.06 AS SUELDOANO1,nvl(sal+comm,sal)*1.06*1.07 AS SUELDOANO2, decode(comm,null, 'NO', 'SI') AS comisiON FROM emp;

-- Consulta 47:
SELECT ename,hiredate FROM emp WHERE job <> 'SALESMAN';

-- Consulta 48:
SELECT * FROM emp WHERE empno IN ('7844','7900','7521','7521','7782','7934','7678','7369');

-- Consulta 49:
SELECT ename FROM emp ORDER BY deptno, empno desc;

-- Consulta 50:
SELECT ename FROM emp WHERE mgr>empno AND (sal BETWEEN 1000 AND 2000 OR deptno=30);

-- Consulta 51:
SELECT max(sal) AS Sal_Maximo,sum(comm) AS Com_Totales,count(empno) AS Num_Empleados FROM emp ;

-- Consulta 52:
SELECT * FROM emp WHERE sal>(SELECT sal FROM emp WHERE empno=7934) ORDER BY sal;

-- Consulta 53:
SELECT ename,job,sal FROM emp WHERE sal>(SELECT sal FROM emp WHERE ename='ALLEN') OR ename='ALLEN';

-- Consulta 54:
SELECT max(ename) FROM emp;

-- Consulta 55:
SELECT max(sal) AS Salario_Maximo, min(sal) AS Salario_Minimo, (max(sal)-min(sal)) AS Diferencia FROM emp; 

-- Consulta 56:
SELECT ename,sal FROM emp WHERE sal=(SELECT max(sal) FROM emp) OR sal=(SELECT min(sal) FROM emp);

-- Consulta 57:
SELECT D.dname,E.deptno,avg(E.sal) AS Salario_Medio FROM dept D, emp E  WHERE E.deptno = D.deptno AND E.sal<5000 GROUP BY D.dname,E.deptno having min(E.sal)>900;

-- Consulta 58:
SELECT E.ename FROM emp E, dept D WHERE D.deptno=E.deptno AND length(D.loc)>5 ORDER BY loc desc,ename;

-- Consulta 59:
SELECT ename FROM emp  WHERE sal>=(SELECT avg(sal) FROM emp);

-- Consulta 60:
SELECT ename,sal FROM emp A WHERE sal>=(SELECT MAX(sal) FROM emp B WHERE B.deptno=A.deptno);

-- Consulta 61:
SELECT count (DISTINCT job),count(ename), count (DISTINCT sal), sum(sal) FROM emp WHERE deptno=30;

-- Consulta 62:
SELECT count (ALL comm) FROM emp;

-- Consulta 63:
SELECT count(empno) FROM emp WHERE deptno=20;

-- Consulta 64:
SELECT dname,count(ename) FROM emp a INNER JOIN dept b ON a.deptno=b.deptno GROUP BY dname HAVING count(*)>3;

-- Consulta 65:
SELECT ename FROM emp WHERE deptno=10 and job=ANY(SELECT job FROM emp a, dept b WHERE a.deptno=b.deptno and dname='SALES');

-- Consulta 66:
SELECT ename FROM emp WHERE empno = SOME(SELECT mgr FROM emp) ORDER BY ename desc;

-- Consulta 67:
SELECT * FROM emp WHERE job = SOME(SELECT job FROM emp E, dept D WHERE E.deptno=D.deptno AND loc='CHICAGO');
 
-- Consulta 68:
SELECT job, count(ename) FROM emp GROUP BY job;

-- Consulta 69:
SELECT dname,SUM(sal) FROM dept D LEFT JOIN emp E ON D.deptno=E.deptno GROUP BY dname;

-- Consulta 70:
SELECT dname FROM dept WHERE NOT deptno = SOME(SELECT DISTINCT deptno FROM emp); 

-- Consulta 71:
SELECT ename FROM emp WHERE empno NOT IN(SELECT mgr FROM emp WHERE mgr is NOT NULL);

-- Consulta 72:
SELECT D.deptno,D.dname,count(ename) AS Num_Empleados,avg(E.sal*12) AS MEDIA_ANUAL FROM emp E right join dept D ON E.deptno=D.deptno GROUP BY D.deptno,D.dname;

-- Consulta 73:
SELECT ename FROM emp WHERE deptno=30 ORDER BY comm desc;

-- Consulta 74:
SELECT E.ename,D.loc FROM emp E, dept D WHERE D.deptno=E.deptno AND (D.loc='DALLAS' OR D.loc='NEW YORK');

-- Consulta 75: 
SELECT E.ename,D.ename FROM emp E LEFT JOIN emp D ON E.mgr=D.empno;

-- Consulta 76:
SELECT ename,sal,dname FROM emp E,dept D WHERE E.deptno=D.deptno AND sal IN (SELECT MAX(sal) FROM emp GROUP BY deptno);

-- Consulta 77:
SELECT A.empno,A.ename,count(A.ename) AS NUM_EMPLEADOS FROM emp A right join emp B ON A.empno=B.mgr GROUP BY A.empno,A.ename;

-- Consulta 78:
SELECT SUM(sal),dname FROM emp a,dept b WHERE a.deptno=b.deptno GROUP BY dname HAVING sum(sal) IN (SELECT MAX(SUM(sal)) FROM emp a,dept b WHERE a.deptno=b.deptno GROUP BY dname);

-- Consulta 79:
SELECT * FROM emp WHERE sal IN (SELECT sal FROM (SELECT DISTINCT sal FROM emp ORDER BY sal DESC) WHERE ROWNUM<=2);

-- Consulta 80:
 SELECT loc,count(empno) FROM emp a, dept b WHERE a.deptno=b.deptno and b.deptno not IN (SELECT b.deptno FROM dept b LEFT JOIN emp a ON a.deptno=b.deptno WHERE empno is NULL) GROUP BY loc HAVING count(empno)>4;
