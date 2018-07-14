
--数据库的表设计如下：
--部门：部门编号，部门名称，地址；
--员工：员工编号，员工名字，职务，管理编号，入职日期，薪资，奖金，部门编号；
--创建部门表：
CREATE TABLE dept(
deptno INT PRIMARY KEY,dname VARCHAR(20),loc VARCHAR(20) 
);
--创建员工表：
CREATE TABLE emp(empno INT PRIMARY KEY,ename VARCHAR(20) NOT NULL,  
job VARCHAR(20) CHECK (job IN('CLERK','SALESMAN','MANAGER','ANALYST')),mgp INT,
hiredate DATETIME ,sal DECIMAL(10,2),comm DECIMAL(10,2),
deptno INT,
CONSTRAINT pk_we FOREIGN KEY (deptno) REFERENCES dept (deptno)
)
--部门表中插入数据：
INSERT INTO dept VALUES (10,'ACCOUNTING','NEWTORK');
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept VALUES (30,'SALES','CHICAGO');
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');
--员工表中插入数据：
INSERT INTO empvalues(7369,'SMITH','CLERK',7902,'1980-12-17',1640,NULL,20);
INSERT INTO emp VALUES(7499,'ALLEN','SALESMAN',7698,'1981-2-20',11400,300,30);
INSERT INTO empvalues(7521,'WARD','SALESMAN',7698,'1981-2-22',5200,500,30);
INSERT INTO empvalues(7566,'JOENS','MANAGER',7839,'1981-4-2',7015,NULL,20);
INSERT INTO emp VALUES(7654,'MARTIN','SALESMAN',7698,'1981-9-28',5200,1400,30);
INSERT INTO empvalues(7698,'BLAKE','MANAGER',7839,'1981-5-1',5900,NULL,30);
INSERT INTO empvalues(7782,'CLARK','MANAGER',7839,'1981-6-9',2470,NULL,10);
INSERT INTO emp VALUES(7788,'SCOTT','ANALYST',7566,'1987-4-19',3040,NULL,20);
 
（1） 查询奖金高于工资的20%的员工信息
SELECT * FROM emp WHERE IFNULL(comm,0)>sal*0.2;
（2） 查询10号部门中工种为MANAGER和20部门中工种为CLERK的员工的信息
SELECT * FROM emp WHERE job='MANAGER' AND deptno=10 UNION SELECT * FROM emp WHERE job='CLERK' AND deptno=20;
--
SELECT * FROM emp WHERE (job='MANAGER' AND deptno=10) OR (job='CLERK' AND deptno=20);
（3） 查询所有员工工资与奖金的和
SELECT ename,sal + IFNULL(comm,0) 实发工资 FROM emp;

SELECT ename,sal + IFNULL(comm,0)  FROM emp;
（4） 查询没有奖金或奖金低于100的员工信息
SELECT * FROM emp WHERE  comm IS NULL OR comm <100;
（5） 查询各月倒数第3天(倒数第2天)入职的员工信息
SELECT * FROM emp WHERE  DATENAME (MONTH, HIREDATE+3)=1;
SELECT *FROM emp WHERE DATENAME(DAY,hiredate+3)=1;
SELECT * FROM DATENAME(DAYOFMONTH, hiredate+3)=1;
（6） 查询工龄大于或等于25年的员工信息。
SELECT ename 姓名,hiredate 雇用日期,DATEDIFF(YEAR,hiredate,getdate()) 工龄
FROM emp
WHERE DATEDIFF(YEAR,hiredate,getdate())>=25;
（7） 查询员工信息，要求以首字母大写的方式显示所有员工的姓名
SELECT UPPER(SUBSTRING(ename,1,1))+LOWER(SUBSTRING(ename,2,(len(ename)-1)))FROM emp;
（8） 查询员工名正好为6个字符的员工的信息
SELECT ename FROM emp WHERE len(ename)=6;
（9） 查询员工名字中不包含字母“Ｓ”的员工
SELECT ename FROM emp WHERE ename NOT LIKE '%Ｓ%';
（10） 查询员工姓名的第二字母为“M”的员工信息。
SELECT ename FROM emp WHERE ename LIKE '-M%';
（11） 查询所有员工姓名的前三个字符
SELECT ename 员工姓名,SUBSTRING(ename,1,3)员工姓名的前三个字符 FROM emp;


SELECT SUBSTRING('abcde',4,1) 返回结果 ab

SELECT SUBSTRING('abcde',1,3) 返回结果 bcd

SELECT SUBSTRING('abcde',1,0) 返回结果为空


（12） 查询所有员工的姓名，如果包含字母“S”，则用“s”替换
--返回被替换了指定子串的字符串
--REPLACE (<string_expression1>，<string_expression2>，<string_expression3>)
--用string_expression3替换在string_expression1 中的子串string_expression2。
SELECT REPLACE(ename,'S','s') FROM emp;
查询1981年入职员工的数据
SELECT * FROM `emp` WHERE hiredate LIKE '%1981-02%';
（13） 查询在2月份入职的所有员工信息
SELECT * FROM emp WHERE DATENAME (mm,hiredate)=2;
（14） 查询所有员工入职以来的工作期限，用“XX年XX月XX日”的形式表示。
SELECT ename,datename(yy,hiredate)+'年'+datename(mm,hiredate)+'月'+datename(dd,hiredate)+'日' 工作期限 FROM emp;
（15） 查询至少有一个员工的部门信息。
SELECT d.dname,COUNT(empno) 部门人数
FROM emp e
RIGHT JOIN dept d ON d.deptno=e.deptno
GROUP BY d.dname,e.deptno
HAVING COUNT(empno)>=1;
（16） 查询所有员工的姓名及其直接上级的姓名。
SELECT ename 员工的姓名,(
SELECT ename FROM emp e2 WHERE e2.empno=e1.mgp
) 直接上级
FROM emp e1;
（17） 查询入职日期早于其直接上级领导的所有员工信息
SELECT ename 员工的姓名,hiredate入职日期,(
SELECT ename FROM emp e2 WHERE e2.empno=e1.mgp
) 直接上级,(
SELECT hiredate FROM emp e2 WHERE e2.empno=e1.mgp
) 直接上级入职日期
FROM emp e1
WHERE e1.hiredate<(SELECT hiredate
FROM emp e2 WHERE e2.empno=e1.mgp
);
（18） 查询所有部门及其员工信息，包括那些没有员工的部门
SELECT dept.dname,emp.ename
FROM dept
LEFT OUTER JOIN emp ON emp.deptno=dept.deptno;
（19） 查询所有员工及其部门信息，包括那些还不属于任何部门的员工
SELECT dept.dname,emp.ename
FROM emp
LEFT OUTER JOIN dept ON emp.deptno=dept.deptno;
（20） 查询所有工种为CLERK的员工的姓名及其部门名称
SELECT dept.dname,emp.ename,emp.job
FROM emp
LEFT OUTER JOIN dept ON emp.deptno=dept.deptno
WHERE job='CLERK';