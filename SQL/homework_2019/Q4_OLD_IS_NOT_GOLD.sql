-- 列出titles表中，每个年代中首映的电影的数量，按照数量的降序排列

WITH middle_result(years, record_count) AS 
( SELECT CAST(premiered/10 * 10 AS varchar(10)) || 's', 
COUNT(title_id) as id_count FROM titles WHERE 
premiered IS NOT null GROUP BY premiered ORDER BY id_count) 
SELECT middle_result.years, SUM(middle_result.record_count) as sum_count 
FROM middle_result GROUP BY years ORDER BY sum_count DESC;


-- 参考答案
SELECT 
  CAST(premiered/10*10 AS TEXT) || 's' AS decade,
  COUNT(*) AS num_movies
  FROM titles
  WHERE premiered is not null
  GROUP BY decade
  ORDER BY num_movies DESC
  ;