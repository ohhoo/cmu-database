-- 列出titles表中，每个年代中首映的电影的数量占所有电影数量的百分比(保留小数点后四位)，按照百分比的降序排列

SELECT CAST(premiered/10*10 AS varchar(10)) || 's' AS decade,
    ROUND(
        COUNT(*)*1.0/(SELECT COUNT(*) FROM titles)*100,4
    ) 
        AS precents FROM titles 
        WHERE premiered IS NOT null GROUP BY decade ORDER BY precents DESC;
-- 结果与参考答案一致，进行百分比处理时先乘以1.0再乘以100有些冗余，像参考答案一样直接乘以100.0即可
-- 需要注意sql语句中的除法也是根据数据类型来决定是否取整的

-- 参考答案
SELECT
  CAST(premiered/10*10 AS TEXT) || 's' AS decade,
  ROUND(CAST(COUNT(*) AS REAL) / (SELECT COUNT(*) FROM titles) * 100.0, 4) as percentage
  FROM titles
  WHERE premiered is not null
  GROUP BY decade
  ORDER BY percentage DESC, decade ASC
  ;