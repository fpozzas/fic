--========================================================================
--PRACTICA 1 DE BASES DE DATOS 1
--AUTORES:
--     Juan Font Alonso - infjfa00 - EI - 2ºA-2
                                                                
--     Daniel Fernández Núñez - infdfn02 - EI - 2ºA-2
                                                               
--========================================================================





-- Consulta 1:
SELECT * FROM emp;
-- Consulta 2:
SELECT * FROM dept;
-- Consulta 3:
SELECT * FROM emp WHERE job='CLERK'; 
-- Consulta 4:
SELECT * FROM emp WHERE job='CLERK' ORDER BY ename;
-- Consulta 5:
SELECT * FROM emp WHERE job='CLERK' ORDER BY ename ASC;
-- Consulta 6:
SELECT empno,ename,sal FROM emp;
-- Consulta 7:
SELECT dname FROM dept;
-- Consulta 8:
SELECT dname FROM dept ORDER BY dname;
-- Consulta 9:
SELECT dname FROM dept ORDER BY loc;
-- Consulta 10:
SELECT dname FROM dept ORDER BY loc DESC;
-- Consulta 11:
SELECT ename,job FROM emp ORDER BY sal;
-- Consulta 12:
SELECT ename,job FROM emp ORDER BY job,sal;
-- Consulta 13:
SELECT ename,job FROM emp ORDER BY job DESC,sal;
-- Consulta 14:
SELECT sal,comm FROM emp WHERE deptno=30;
-- Consulta 15:
SELECT sal,comm FROM emp WHERE deptno=30 ORDER BY comm;
-- Consulta 16a:
SELECT comm FROM emp;
-- Consulta 16b:
SELECT DISTINCT comm FROM emp;
-- Consulta 17:
SELECT DISTINCT ename,comm FROM emp;
-- Consulta 18:
SELECT DISTINCT ename,sal FROM emp;
-- Consulta 19:
SELECT DISTINCT comm,deptno FROM emp;
-- Consulta 20:
SELECT ename,sal+1000 AS sal FROM emp WHERE deptno=30;
-- Consulta 21:
SELECT ename,sal,sal+1000 AS nuevo_salario FROM emp WHERE deptno=30;
-- Consulta 22:
SELECT ename FROM emp WHERE comm is not NULL and comm>(sal/2);
-- Consulta 23:
SELECT ename FROM emp WHERE comm is NULL or comm<=0.25*sal;
-- Consulta 24:
SELECT 'Nombre: '||ename AS ename,'Salario: '||sal AS sal FROM emp;
-- Consulta 25:
SELECT empno,sal,comm FROM emp WHERE empno>7500;
-- Consulta 26:
SELECT * FROM emp WHERE ename>='J';
-- Consulta 27:
SELECT sal,comm,sal+comm AS sal_total FROM emp WHERE comm is not NULL ORDER BY empno;
-- Consulta 28:
SELECT sal,comm,sal AS sal_total FROM emp WHERE comm is NULL ORDER BY empno;
-- Consulta 29:
SELECT ename FROM emp WHERE sal>1000 and mgr=7698;
-- Consulta 30:
SELECT ename FROM emp WHERE not(sal>1000 and mgr=7698);
-- Consulta 31:
SELECT ename,100*NVL(comm,0)/sal||'%' AS porcentaje_comm_sobre_sal FROM emp ORDER BY ename;
-- Consulta 32:
SELECT ename FROM emp WHERE deptno=10 and not ename like '%LA%'; 
-- Consulta 33:
SELECT ename FROM emp WHERE mgr is NULL;
-- Consulta 34:
SELECT dname FROM dept WHERE dname<>'SALES' and dname<>'RESEARCH' ORDER BY loc;
-- Consulta 35:
SELECT ename,deptno FROM emp WHERE job='CLERK' and deptno<>10 and sal>800 ORDER BY hiredate;
-- Consulta 36:
SELECT ename,sal/comm FROM emp WHERE comm>0
UNION
SELECT ename,NULL FROM emp WHERE comm=0
ORDER BY 1;
-- Consulta 37:
SELECT * FROM emp WHERE ename LIKE '_____';
-- Consulta 38:
SELECT * FROM emp WHERE ename LIKE '%_____%';
-- Consulta 39:
SELECT * FROM emp WHERE (ename LIKE 'A%' and sal>1000) or (comm is not NULL and deptno=30);
-- Consulta 40:
SELECT ename,sal,sal+comm FROM emp WHERE comm is not NULL
UNION
SELECT ename,sal,sal FROM emp WHERE comm is NULL
ORDER BY 2,3;
-- Consulta 41:
SELECT ename,sal,comm FROM emp WHERE comm is not NULL and sal>(comm/2) and sal<comm;
-- Consulta 42:
SELECT ename,sal,comm FROM emp WHERE comm is not NULL and not(sal>(comm/2) and sal<comm);
-- Consulta 43:
SELECT ename,job FROM emp WHERE ename LIKE 'A%' and job LIKE '%MAN';
-- Consulta 44:
SELECT ename,job FROM emp WHERE ename || job LIKE 'A%MAN';
-- Consulta 45:
SELECT ename FROM emp WHERE LENGTH(ename)<=5;
-- Consulta 46:
SELECT ename,
sal+comm AS SALTOT_ACTUAL,
(0.06*(sal+comm)+(sal+comm)) AS SALTOT_1,
(0.07*(0.06*(sal+comm)+(sal+comm)) + (0.06*(sal+comm)+(sal+comm))) AS SALTOT_2,
'SI' AS COMM
FROM emp WHERE comm is not NULL
UNION
SELECT ename,
sal AS SALTOT_ACTUAL,
(0.06*(sal)+(sal)) AS SALTOT_1,
(0.07*(0.06*(sal)+(sal)) + (0.06*(sal)+(sal))) AS SALTOT_2,
'NO' AS COMM
FROM emp WHERE comm is NULL;
-- Consulta 47:
SELECT ename,hiredate FROM emp WHERE job<>'SALESMAN';
-- Consulta 48:
SELECT * FROM emp WHERE empno IN ('7844','7900', '7521','7782', '7934', '7678', '7369');
-- Consulta 49:
SELECT ename FROM emp ORDER BY deptno,empno DESC;
-- Consulta 50:
SELECT ename FROM emp WHERE mgr>empno and (sal BETWEEN 1000 AND 2000 or deptno=30);
-- Consulta 51:
SELECT MAX(sal),SUM(comm),COUNT(empno) FROM emp;
-- Consulta 52:
SELECT * FROM emp WHERE sal>(SELECT sal FROM emp WHERE empno='7934') ORDER BY sal;
-- Consulta 53:
SELECT * FROM emp WHERE sal>(SELECT sal FROM emp WHERE ename='ALLEN') or ename='ALLEN';
-- Consulta 54:
SELECT MAX(ename) FROM emp;
-- Consulta 55:
SELECT MAX(sal),MIN(sal),MAX(sal)-MIN(sal) FROM emp;
-- Consulta 56:
SELECT ename,sal FROM emp WHERE sal=(SELECT MAX(sal) FROM emp) or sal=(SELECT MIN(sal) FROM emp);
-- Consulta 57:
SELECT AVG(sal),a.deptno,dname
FROM emp a, dept b
WHERE a.deptno=b.deptno and sal<5000
GROUP BY a.deptno
HAVING MIN(sal)>900;
-- Consulta 58:
SELECT ename
FROM emp a ,dept b
WHERE a.deptno=b.deptno and b.loc LIKE '_____%'
ORDER BY loc DESC,ename;
-- Consulta 59:
SELECT ename FROM emp WHERE sal>=(SELECT AVG(sal) FROM emp);
-- Consulta 60:
SELECT ename FROM emp a,dept b
WHERE a.deptno=b.deptno
GROUP BY a.deptno
HAVING MAX(sal);
-- Consulta 61:
SELECT count(DISTINCT job),count(ename),count(DISTINCT sal),SUM(sal) FROM emp a WHERE deptno=30;
-- Consulta 62:
SELECT count(comm) FROM emp WHERE comm is not NULL;
-- Consulta 63:
SELECT count(ename) FROM emp WHERE deptno=20;
-- Consulta 64:
SELECT dname,count(ename) FROM emp a,dept b
WHERE a.deptno=b.deptno
GROUP BY a.deptno
HAVING count(*)>3;
-- Consulta 65:
SELECT ename FROM emp WHERE deptno=10 and job=ANY(
SELECT job FROM emp a, dept b 
WHERE a.deptno=b.deptno and dname='SALES');
-- Consulta 66:
SELECT ename FROM emp WHERE empno=ANY(SELECT mgr FROM emp) ORDER BY ename DESC;
-- Consulta 67:
SELECT * FROM emp WHERE job=ANY(SELECT job FROM emp a,dept b WHERE a.deptno=b.deptno and loc='CHICAGO');
-- Consulta 68:
SELECT job,count(ename) FROM emp GROUP BY job;
-- Consulta 69:
SELECT dname,SUM(sal) FROM dept a LEFT JOIN emp b ON a.deptno=b.deptno GROUP BY dname;
-- Consulta 70:
SELECT dname FROM dept WHERE not deptno=ANY(SELECT deptno FROM emp);
-- Consulta 71:
SELECT * FROM emp WHERE not empno=ANY(SELECT mgr FROM emp WHERE mgr is not NULL);
-- Consulta 72:
SELECT dname,count(ename),AVG(sal) FROM dept a LEFT JOIN emp b ON a.deptno=b.deptno GROUP BY dname;
-- Consulta 73:
-- Consulta 74:
-- Consulta 75:
-- Consulta 76:
-- Consulta 77:
-- Consulta 78:
-- Consulta 79:
-- Consulta 80: