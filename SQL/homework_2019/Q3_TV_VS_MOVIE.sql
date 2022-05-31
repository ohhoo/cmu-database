-- 在title表中，打印出不同type属性的元组的type及其数量，按照数量的升序排列

SELECT type, COUNT(title_id) AS title_count FROM titles GROUP BY type ORDER BY title_count ;
-- 结果与参考答案一致

-- 参考答案
SELECT type, count(*) AS title_count FROM titles GROUP BY type ORDER BY title_count ASC;

