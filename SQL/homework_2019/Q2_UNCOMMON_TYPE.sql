--我的答案
select type, primary_title,MAX(runtime_minutes) FROM titles GROUP BY type ORDER BY type, primary_title;
--查询结果中缺少了runtime_minutes并列的tvShort
-- 因为max只能返回一个最大值，并不能得到并列的最大值对应的元组，
-- 因此需要先获取最大值然后再去查询与最大值相等的元组


--参考答案
WITH types(type, runtime_minutes) AS ( 
  SELECT type, MAX(runtime_minutes)
    FROM titles
    GROUP BY type
)
SELECT titles.type, titles.primary_title, titles.runtime_minutes
  FROM titles
  JOIN types
  ON titles.runtime_minutes == types.runtime_minutes AND titles.type == types.type
  ORDER BY titles.type, titles.primary_title
;