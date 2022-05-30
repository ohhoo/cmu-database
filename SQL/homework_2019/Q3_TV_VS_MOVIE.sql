SELECT type, COUNT(title_id) AS title_count FROM titles GROUP BY type ORDER BY title_count ;
-- 结果与参考答案一致

-- 参考答案
SELECT type, count(*) AS title_count FROM titles GROUP BY type ORDER BY title_count ASC;
