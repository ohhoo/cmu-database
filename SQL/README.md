# 结构化查询语言(Structured Query Language SQL)

本说明内容源于教材 [数据库系统概念](https://study.guoch.xyz/Books/%E6%9C%BA%E6%A2%B0%E5%B7%A5%E4%B8%9A%E5%87%BA%E7%89%88%E7%A4%BE%E9%BB%91%E7%9A%AE%E4%B9%A6/%E6%95%B0%E6%8D%AE%E5%BA%93%E7%B3%BB%E7%BB%9F%E6%A6%82%E5%BF%B5%20%20%E5%8E%9F%E4%B9%A6%E7%AC%AC6%E7%89%88_13013764.pdf?preview)，选择性地对2-5章节的部分内容进行记录说明。

## 多关系查询
问题背景：首先考虑这样的查询 "找出所有教师的姓名及其所在系的名称和系所在建筑的名称"

解决思路：

教师的关系模式为
```sql
instructor(ID,name,dept_name,salary)
```
其中不包含建筑名称，而建筑名称的属性在`department`表中，其关系模型为
```sql
department(dept_name, building, buget)
```
因此我们需要将两个关系联合起来进行查询。一般的思路是，查询到`instructor`的`dept_name`属性，然后根据该属性在`department`中查询`building`属性。为了满足查询的需求，`instructor`关系中的元组必须通过`dept_name`属性与`department`关系中的元组匹配。因此该查询的语句可以写为：
```sql
SELECT name, instructor.dept_name, building FROM instructor, department WHERE instructor.dept_name = department.dept_name;
```
对于两个关系模式中共用的属性`dept_name`通过关系名称进行区别

该查询语句相当于执行了以下操作：
```
for each 元组t1 in 关系instructor：
    for each 元组t2 in 关系department：
        将t1、t2连接成单个元组t
        对元组t执行条件语句 instructor.dept_name = department.dept_name
```
即在`instructor`与`department`笛卡尔积的结果(将两个关系结合为一个)执行条件查询。

对于多关系查询语句，其进行的操作可总结如下：

1、为FROM子句列出的关系产生笛卡尔积

2、在步骤1的结果上应用WHERE子句中指定的谓词

3、对于步骤2结果中的每个元组，输出select子句中指定的属性或表达式结果


## 自然连接
考虑上个查询中出现的组合两个关系的情况，查询之前需要首先通过笛卡尔积得到所有的组合情况，然后再在这些组合中选出符合条件的元组。而SQL提供了一种自动的机制来执行组合、筛选的操作。这就是`自然连接(nature join)`。<font color=#FF000>该操作作用于两个关系，产生一个新的关系作为结果。</font>

自然连接运算的作用在于：只将两个关系中拥有共同属性值并且属性值相等的元组进行连接，得到新的元组，再将这些新元组组合为一个新的关系。例如`instructor`与`teacher`关系具备相同的属性值`ID`，执行`natural join`操作后，结果如下：
```sql
instructor(ID,name,dept_name,salary) --元组总数为50
teaches(ID, course_id, sec_id, semester, year) --元组总数为100

SELECT * FROM instructor NATURAL JOIN teaches;

--执行natural join后得到的关系记作temp1， 元组总数为100
temp1(ID, course_id, sec_id, semester, year, name, dept_name, salary)

--执行笛卡尔乘积得到的关系记作temp2, 总数为 5000
temp2(ID, course_id, sec_id, semester, year, ID(1),name, dept_name, salary)
--执行笛卡尔积加上条件语句 instructor.ID = teaches.ID得到的元组总数为100
```

如上所述，自然连接只能作用于两个关系之间，但是通常我们还会遇到多个表关联查询的情况，那么如何在多个表之间使用自然连接？以`course`、`instructor`、`teaches`关系为例
```sql
course(course_id, title, dept_name, credits)
instructor(ID,name,dept_name,salary)
teaches(ID, course_id, sec_id, semester, year)
```
由这三个关系模式可以看出，没有相同的属性值可以将这三个关系连接起来，同时由于`自然连接`只作用于两个关系，因此可以采用以下做法
```sql
--列出教某一门课的教师的姓名及该门课的title
SELECT name, title FROM (instructor NATURAL JOIN teaches) JOIN course USING(course_id);
```
这个SQL语句使用了`r1 JOIN r2 USING(A1, A2)`语法，类似于`自然连接`，但是不同之处在于，前者在组合元组时只要满足`r1.A1 = r2.A1与r1.A2 = r2.A2`条件即可将该组合后的元组加入新的关系中，而`自然连接`则需要组合元组中来自不同关系的所有共有属性的值相同。这需要根据要查询的结果来实际地选择不同的语法(因为有时候不需要所有的共有属性值都相同)。


## 重命名
SQL语句中，支持将`SELECT`子句中或`FROM`子句中的属性名称、关系名称通过`AS`重命名。重命名常用于比较同一关系中的元组的情况。

考虑该查询：`找出满足下面条件的教师姓名，他们的工资至少比Biology系教师的最低工资高`

其SQL语句如下
```sql
SELECT DISTINCT T.name FROM instructor AS T, instructor AS S WHERE T.salary > S.salary AND S.dept_name = 'Biology'
```

## SQL的集合运算

### 并运算
将两个查询的结果取并集，譬如考虑查询条件`找出在2009年秋季开课，或者在2010年春季开课或两个学期都开课的所有课程`，查询语句如下：
```sql
(SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009) UNION (SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010)
```
`UNION`将两个查询的结果合并，并且去掉重复项，如果需要保留重复项的话可以使用`UNION ALL`

### 交运算
取两个查询结果的交集，譬如考虑查询条件`找出在2009年秋季和2010年春季同时开课的所有课程`，其查询语句如下：
```sql
(SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009) INTERSECT (SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010)
```
`INTERSECT`运算自动去重，如果需要保留重复结果，可以使用`INTERSECT ALL`

### 差运算
取两个查询结果的差值，譬如考虑查询条件`找出在2009年秋季开课但是不在2010年春季开课的所有课程`，其查询语句如下：
```sql
(SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009) EXCEPT (SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010)
```
差运算不保留重复项，如果希望保留重复项，可以使用`EXCEPT ALL`


## 聚集函数
聚集函数是指以值的集合作为输入，返回单个值的函数。SQL中提供了5个聚集函数，分别为
```sql
-- 计算平均值
AVG()

-- 取出最小值
MIN()

-- 取出最大值
MAX()

-- 求和
SUM()

-- 计数
COUNT()
```
对于空值`Unknown`，除`COUNT`外的聚集函数都会忽略包含空值的元组。

### 分组聚集
有时候我们可能会期望在不同的分组上采用聚集函数，比如考虑查询条件`计算每个系的平均工资`，其查询语句如下
```sql
SELECT dept_name, avg(salary) AS avg_salary FROM instructor GROUP BY dept_name
```
通过`GROUP BY`子句将关系中的元组通过某一属性的不同进行分组。同时需要注意的是，如果使用了`GROUP BY`子句，那么出现在`SELECT`子句中的属性值要么是`GROUP BY`后的属性，要么就必须使用聚集函数对其他属性进行处理。
```sql
-- 这是一个错误的查询，因为ID不在GROUP BY子句中，并且没有用聚集函数包裹
SELECT dept_name, ID, avg(salary) FROM instructor GROUP BY dept_name;
```

### HAVING 子句
使用`having`子句对`GROUP BY`子句生成的分组进行条件限定，考虑查询条件`查询平均工资超过42000美元的系名称及具体工资数`，sql语句如下：
```sql
SELECT dept_name, AVG(salary) AS avg_salary FROM instructor GROUP BY dept_name HAVING AVG(salary) > 42000; 
```
`HAVING`子句后跟的是针对整个分组的条件。任何出现在`HAVING`子句中但是没有被聚集函数包裹的属性必须出现在`GROUP BY`子句中，否则查询语句的格式即为不合法。

使用了`GROUP BY`与`HAVING`子句的查询语句的含义可以通过以下顺序进行定义：
```
1、根据FROM子句中的内容计算出一个关系
2、如果出现的WHERE子句，那么WHERE子句中的谓词将会被应用到步骤一所计算出的关系上
3、如果出现了GROUP BY子句，那么满足WHERE谓词的元组将会通过GROUP BY子句形成分组，如果没有GROUP BY子句，那么满足WHERE谓词的所有元组被当作一个分组
4、如果出现了HAVING子句，那么这个子句的条件将会被应用到每个分组上，不满足该条件的元组将会被抛弃
5、SELECT子句在剩下的元组中应用聚集函数(如果有)产生查询结果的元组。
```

考虑如下的sql语句
```sql
SELECT course_id, semester, year, sec_id, AVG(tot_cred) FROM takes NATURAL JOIN student WHERE year = 2009 GROUP BY course_id, semester, year, sec_id HAVING COUNT(ID) >= 2;
```
该sql语句查询的是：将`takes`关系与`student`关系中的每个元组进行连接，并筛选出满足`takes.ID == student.ID`条件的元组，形成新的关系。对该关系进行筛选，满足条件`year = 2009`的元组保留，并且将这些剩下的元组通过属性`course_id semester year sec_id`进行分组(所有以上属性相同的元组为一组)，并且这些组中的元组个数必须大于等于2。然后输出满足这些条件的分组的`course_id semester year sec_id`属性的值及整个分组中`tot_cred`属性的平均值。

说人话就是：`找出在2009年讲授的每个课程段，如果该课程至少有两个学生选课，找出选修该课程的学生的总学分的平均值。`


## 嵌套子查询
就是可以在另一个`select-from-where`查询结果的基础上进行查询。

### 集合成员测试
可以通过嵌套子查询与相关的关键字（IN、NOT IN）来进行成员资格的测试(某个(多个)元组是否在某个关系中)。

考虑查询条件`找出2009年秋与2010年春季学期同时开课的课程`
```sql
-- 首先查询出2010年春季开课的课程
SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010

-- 将上个查询语句作为子查询，再次基础上查询2009年秋季与2010年春季同时开课的课程(即在2009年开课的课程记录同时也存在于2010年春的开课记录中)
SELECT DISTINCT course_id FROM section WHERE semester = 'Fall' AND year = 2009 AND
 course_id IN (SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010);


-- 考虑2009年秋开课但是2010年春季学期不开课的课程
SELECT DISTINCT course_id FROM section WHERE semester = 'Fall' AND year = 2009 AND
 course_id NOT IN (SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010);
```

IN、NOT IN关键字也可用于`WHERE`子句中的谓词，用来测试属性是否为给定范围的值，如下所示：
```sql
-- 找出姓名不是'Mozart', 'Einstein'的教师
SELECT DISTINCT name FROM instructor WHERE name NOT IN ('Mozart', 'Einstein')

-- in与not in可以用于多个属性的匹配查询
-- 找出选修了ID为10101的教授所讲授的课程的学生总数 (如此查询的原因是考虑到takes关系与teaches关系之间可以用 course_id, sec_id, semester, year唯一确定一个学生元组)
SELECT COUNT(DISTINCT ID) FROM takes WHERE (course_id, sec_id, semester, year) IN (SELECT course_id, sec_id, semester, year FROM teaches WHERE teaches.ID = 10101) 
```


### 集合比较
SQL提供了两个关键字`SOME`、`ALL`来进行集合的比较操作。其中`SOME`表示任意一个满足条件就返回True，而`ALL`则需要所有的满足条件才返回True。

```sql
-- 考虑查询条件 找出满足后续条件的教师姓名，他们的工资至少比Biology系教师的最低工资高

-- 一般的写法
SELECT DISTINCT T.name FROM instructor AS T, instructor AS S WHERE T.salary > S.salary AND S.dept_name = 'Biology'

-- 采用子查询与关键字SOME的写法
SELECT name FROM instructor WHERE salary > SOME(SELECT salary FROM instructor WHERE dept_name)

改变查询条件：找出满足后续条件的教师姓名，他们的工资比Biology系所有教师的工资都要高
SELECT name FROM instructor WHERE salary > ALL(SELECT salary FROM instructor WHERE dept_name)
```

需要注意的是 `= SOME`等价于`IN` `<> ALL`等价于`NOT IN` 


### 关系测试
SQL中采用`EXISTS`来测试一个子查询中是否存在元组。如下SQL查询语句所示：
```sql
-- 找出2009年秋季学期和2010年春季学期同时开课的课程

-- 不使用EXISTS的查询语句如下
SELECT DISTINCT course_id FROM section WHERE semester = 'Fall' AND year = 2009 AND
 course_id IN (SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010);

使用EXISTS的查询语句如下
SELECT course_id FROM section AS S WHERE semester = 'Fall' AND year = 2009 AND EXISTS (SELECT * FROM section as T WHERE semester = 'Spring' AND year = 2010 AND S.course_id = T.course_id)
```
同样也采用`NOT EXISTS`来查询集合中是否不存在元组


## WITH子句
`WITH`子句提供了定义临时关系的方法，这个定义只对包含`WITH`子句的查询有效。如考虑查询条件：`找出具有最大预算的系`
```sql
WITH max_budget(value) AS (SELECT max(budget) FROM department) SELECT budget FROM department, max_budget WHERE department.budget = max_budget.value
```



## 连接表达式
连接表达式使用`JOIN ... ON ...`，不同于`NATURAL JOIN`，`JOIN ON`可以指定连接的属性。比如下面的SQL语句：
```sql
-- 该语句的结果是：当takes与student中的元组满足条件student.ID = takes.ID时，才会将这些元组连接起来，并且不同于NATURAL JOIN连接的结果，ID值只会出现一次
SELECT * FROM student JOIN takes ON student.ID = takes.ID
```

### 外连接
为什么需要外连接？首先我们来考虑查询条件：`显示所有学生的列表，该列表的属性包括学生的ID、name、dept_name、tot_cred及其所选修的课程`
```sql
-- 学生和选修课程的关系模型如下
students(ID, name, dept_name, tot_cred)
takes(ID, course_id, sec_id, semester, year, grade)
```
对于查询条件，查询语句`SELECT * FROM sudents NATURAL JOIN takes`似乎能够检索出所有的信息，但是实际上并不是。考虑这样的情况，如果一些学生没有选修任何课程，那么这些学生元组就不能与选课关系中的任一元组进行配对，因此最后的查询结果中是缺失了这一部分的学生信息的。这种不保留未匹配元组信息的连接也称为`内连接(inner join)`，连接的类型默认为内连接，也可以采用`INNER JOIN`注明

外连接则以在结果中创建包含空值元组的方式，保留了在连接过程中丢失的元组信息。

外连接分为以下几个类别：
```
右外连接(right outer join)  只保留出现在右外连接运算之后(右边)的关系中的元组
左外连接(left outer join)   只保留出现在左外连接运算之前(左边)的关系中的元组
全外连接(full outer join)   保留出现在两个关系中的元组
```

开始所提出的查询条件的sql语句应当为：
```sql
SELECT * FROM students NATURAL LEFT OUTER JOIN takes;
-- 此处需要保留未匹配的学生元组 

-- 该查询语句与上面的等价
SELECT * FROM students LEFT OUTER JOIN takes ON student.ID = takes.ID;
```

同时对于`JOIN ON`的条件与`WHERE`子句的条件也需要加以区分，这两个表示的不是相同的条件，外连接只会为那些对相应内连接结果没有贡献的元组加上空值，并将其加入结果。`ON`是外连接的一部分，而`WHERE`则是对外连接结果进行筛选。如`students.ID = takes.ID`条件，`ON`会对满足该条件的元组进行连接，而对于takes中没有的但是在students中有的元组将其将takes中的属性置为空值，然后将student中的元组与空值takes元组连接起来。但是WHERE则会对条件进行筛选，只有ID值同时在students与takes中出现的元组才满足该条件。


## 视图

#### 什么是视图？

其定义为:不是逻辑关系的一部分，但作为虚关系对用户可见的关系称为视图，简单来说视图就是一个由查询关系定义的虚拟表。

#### 为什么需要视图？

1. 视图可以隐藏一些数据，确保数据的安全；
2. 视图可以简化查询方法，使得查询易于理解和使用；

视图定义的命令格式：
```sql
-- 该命令通过查询语句query expression创建了一个名为v的视图
CREATE VIEW v AS <query expression>

-- 该语句通过select语句创建了一个包含属性ID, name, dept_name的名为faculty的视图
CREATE VIEW faculty AS SELECT ID, name, dept_name FROM instructor;

-- 也可以显式地指定视图的属性
CREATE VIEW faculty(ID, name, dept_name AS dn) AS SELECT ID, name, dept_name FROM instructor;
```

执行了视图创建命令后，该视图在概念上包含了查询结果中的元组，但是并不会进行预计算和存储。视图与表之间存在着一种虚关系，只有当需要使用的时候（在视图上使用查询语句时），视图中的元组才会被实际的计算出来。一个视图也能够用于定义其他的视图。


#### 可以对视图进行修改吗？（执行插入、删除、更新语句）
对视图的更改必须被翻译为对实际存在的关系中的元组的更改，这就要求翻译的过程与结果不能够出错，在此基础上提出了几点对于修改视图的要求，当视图满足以下要求时才可以进行更改：
```
1、FROM子句中只有一个数据库关系
2、SELECT子句中只包含关系的属性名，不包含任何表达式、聚集、DISTINCT声明
3、任何没有出现在SELECT子句中的属性可以取空值
4、查询中不含有GROUP BY或HAVING子句
```
最好还是不要在视图上对数据进行更改。



## 事务

#### 什么是事务？
事务(transaction)由查询和(或)更新语句的序列组成。一条SQL语句就是一个最简单的事务。

事务最经典的特征就是原子性即要么执行要么不执行，不会存在执行过程中被终止的情况。

SQL语句(MySQL)中的事务定义方式：
```sql
BEGIN;
<query expression>
END;
```


## 完整性约束

完整性约束保证了用户对数据库关系中的元组的更改不会破坏数据的一致性(从一个有效的状态转移到另一个有效的状态，即改变不会使数据元组变得不合法)。

以本书的数据库中的相关关系为例，一致性就是指：
```
教师的姓名不能为Null                                            not null约束

任意两个教师不能有相同的教师标识                                 unique约束

course关系中每个系的名称必须在department关系中有一个对应的系名    参照完整性

一个系的预算必须大于0.00元                                      check子句

```
在创建数据库关系时一般都已经通过`CREATE`语句指定了完整性约束，同时也可以通过`ALERT TABLE table-name ADD coonstraint`语句添加相关的约束。

各种约束的声明格式如下：
```sql
-- not null约束
name varchar(20) not null
budget numeric(12, 2) not null

-- unique约束 标明没有那两个元组的(A1, A2, ..., An)属性组合是相同的
unique (A1, A2, ..., An)

-- check子句，括号内是一个条件表达式
check(budget>0)

-- 参照完整性 保证一个关系内的取值也在另一个关系的特定属性集的取值中出现
-- 这是一个外码声明，一般情况下外码使用的是另一个关系中的主码，此处的department是被参照关系
FOREIGN KEY(dept_name) REFERENCES department 
-- 每个元组的属性dept_name必须在department关系中存在
-- 当操作会违反参照完整性约束时，通常会拒绝该操作的执行
```

#### 参照完整性约束
参照完整性约束，简单来说就是一个关系的属性集中包含了另一个关系的主码。不说人话表示就是：
```
令关系r1,r2的属性集分别为R1,R2，主码分别为K1,K2，如果要求对r2中任意的元组t2，均存在r1中的元组t1使得t1.K1 = t2.α，我们称R2的子集α为参照关系r1中K1的外码。同时r2的α的取值集合必须是r1中的K1的取值集合的子集
```
在处理事务时，很有可能会遇到破坏参照完整性约束的情况，比如：
```
有一个关系Person，其主码为name，同时该关系的属性集中包含属性spouse，并且spouse是在Person关系上的外码
```
根据关系的定义以及约束的要求，spouse是在Person关系上的外码的含义是spouse属性必须包含出现在Person关系中的名字。但是考虑这样的操作：`在Person关系中插入两个元组(同一个事务中执行)，一个的name属性为Jhon，另一个的name属性为Mary，这两个人互为配偶`，这样不论先插入哪个元组，都会违反约束，但是当第二个元组插入后，约束又会被满足。

对于这样的情况，SQL提供了一种机制，让约束检查在事务完成后进行，而不是在事务进行过程中进行。该机制的写法如下：
```sql
-- 将该语句作为事务的一部分，小写部分为约束列表
set CONSTRAINTS constraint-list DEFERRED
```
或者可以通过设置外键为null来规避对约束的违反，但是这样会需要对该外键的值进行更改，这可能会需要增加额外的SQL语句执行更新操作。


#### 复杂check条件于断言
check子句中的谓词可以是包含子查询的任意谓词，如下：

```sql
check (time_slot_id in (SELECT time_slot_id FROM time_slot))
```
注意，这个条件不仅在插入或修改元组时需要进行检查，在修改`time_slot`关系是也要进行检查。

复杂的check语句在确保数据完整性方面起到了很大的作用，但是它却会增加检测的开销。


