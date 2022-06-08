-- 列出Mark Hamill与George Lucas共同合作的电影
SELECT primary_title FROM titles 
    WHERE title_id IN 
        (
            SELECT title_id FROM crew WHERE person_id in 
            (
                SELECT person_id FROM people 
                WHERE name = 'Mark Hamill' and born = 1951
            ) 

            INTERSECT 

            SELECT title_id FROM crew WHERE person_id in 
            (
                SELECT person_id FROM people 
                WHERE name = 'George Lucas' and born = 1944
            )
        ) AND type = 'movie' ORDER BY primary_title DESC;

-- 结果与参考答案相同

-- 参考答案
WITH hamill_movies(title_id) AS (
  SELECT crew.title_id
    FROM crew
    JOIN people
    ON crew.person_id == people.person_id AND people.name == "Mark Hamill" AND people.born == 1951
)
SELECT titles.primary_title
  FROM crew
  JOIN people
  ON crew.person_id == people.person_id AND people.name == "George Lucas" AND people.born == 1944 AND crew.title_id IN hamill_movies
  JOIN titles
  ON crew.title_id == titles.title_id AND titles.type == "movie"
  ORDER BY titles.primary_title
;

