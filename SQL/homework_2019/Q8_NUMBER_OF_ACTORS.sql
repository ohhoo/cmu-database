-- 列出与'Mark Hamill'（生于1951）同台表演的演员个数(包括Mark Hamill自己)
WITH movie_with_markhamil(movie_title_id) AS 
    (select title_id FROM crew WHERE person_id = 
        (SELECT person_id FROM people WHERE name = 'Mark Hamill' AND born = 1951)
    ) 
    
    SELECT COUNT(DISTINCT person_id) FROM 
        movie_with_markhamil JOIN crew ON 
            movie_with_markhamil.movie_title_id = crew.title_id 
        WHERE crew.category = 'actress' OR crew.category = 'actor';

-- 参考答案 结果相同

WITH hamill_titles AS (
  SELECT DISTINCT(crew.title_id)
    FROM people
    JOIN crew
    ON crew.person_id == people.person_id AND people.name == "Mark Hamill" AND people.born == 1951
)
SELECT COUNT(DISTINCT(crew.person_id))
  FROM crew
  WHERE (crew.category == "actor" OR crew.category == "actress") AND crew.title_id in hamill_titles
;
