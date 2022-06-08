# HOMEWORK SQL

## Q2_UNCOMMON_TYPE
List the longest title of each type along with the runtime minutes

Find the titles which are the longest by runtime minutes. There might be cases where there is a tie for the longest titles - in that case return all of them. Display the types, primary titles and runtime minutes, and order it according to type (ascending) and use primary titles (ascending) as tie-breaker.


在title表中，根据type的不同，分别选出runtime minutes最大的元组(允许并列)列出其type、primary titles、runtime minutes，根据type对所有结果进行排序，primary titles作为排序的最终决断项。


## Q3_TV_VS_MOVIE
List all types of titles along with the number of associated titles.

Print type and number of associated titles. For example, tvShort|4075. Sort by number of titles in ascending order.

在title表中，打印出不同type属性的元组的type及其数量，按照数量的升序排列

## Q4_OLD_IS_NOT_GOLD
Which decades saw the most number of titles getting premiered? List the number of titles in every decade. Like 2010s|2789741.

Print all decades and the number of titles. Print the relevant decade in a fancier format by constructing a string that looks like this: 2010s. Sort the decades in decreasing order with respect to the number of titles. Remember to exclude titles which have not been premiered (i.e. where premiered is NULL).

列出titles表中，每个年代中首映的电影的数量，按照数量的降序排列


## Q5_PERCENTAGE
List the decades and the percentage of titles which premiered in the corresponding decade. Display like : 2010s|45.7042

The percentage of titles for a decade is the number of titles which premiered that decade divided by the total number of titles. For the total number of titles, count all titles including ones that have not been premiered. Round the percentage to four decimal places using ROUND().

列出titles表中，每个年代中首映的电影的数量占所有电影数量的百分比(保留小数点后四位)，按照百分比的降序排列

## Q6_DUBBED_SMASH
List the top 10 dubbed titles with the number of dubs.

Count the number of titles in akas for each title in the titles table, and list only the top ten. Print the primary title and the number of corresponding dubbed movies.

列出titles表中的电影在akas表中配音数量最多的前十个记录的primary_title、配音数量，按照配音数量的降序排列




## Q8_NUMBER_OF_ACTORS

List the number of actors / actresses who have appeared in any title with Mark Hamill (born in 1951).

列出曾与Mark Hamill同台演出的演员的个数(包括他自己)

## Q9_MOVIE_NAMES

List the movies in alphabetical order which cast both Mark Hamill (born in 1951) and George Lucas (born in 1944).

列出Mark Hamill与George Lucas合作的电影名称（按照字母顺序排序）。