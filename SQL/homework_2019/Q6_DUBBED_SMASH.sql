-- 列出titles表中的电影在akas表中配音数量最多的前十个记录的primary_title、配音数量，按照配音数量的降序排列

SELECT primary_title, COUNT(*) AS nums 
    FROM akas NATURAL JOIN titles GROUP BY title_id 
    ORDER BY nums DESC LIMIT(10);

-- 运行结果一致，
-- 但是参考答案的运行时间较短，因为参考答案中将新查询出来的关系与titles关系进行JOIN
-- 新查询的关系的数量只有10个，因此执行效率高

-- 参考答案
WITH translations AS (
  SELECT title_id, count(*) as num_translations 
    FROM akas 
    GROUP BY title_id 
    ORDER BY num_translations DESC, title_id 
    LIMIT 10
)
SELECT titles.primary_title, translations.num_translations
  FROM translations
  JOIN titles
  ON titles.title_id == translations.title_id
  ORDER BY translations.num_translations DESC
  ;