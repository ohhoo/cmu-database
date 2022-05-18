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