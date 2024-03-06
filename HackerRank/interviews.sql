/* 
This query consists in the solution of the HackerRank challenge below:

Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are .

Note: A specific contest can be used to screen candidates at more than one college, but each college only holds  screening contest.

Link to the challenge:
https://www.hackerrank.com/challenges/interviews/problem
*/

WITH 
/*Return the sums of total_submissions and total accepted submissions*/
CTE_SUBMISSIONS AS (
	SELECT 
		ss.CHALLENGE_ID
		, SUM(ss.TOTAL_SUBMISSIONS) AS TOTAL_SUBMISSIONS
		, SUM(ss.TOTAL_ACCEPTED_SUBMISSIONS) AS TOTAL_ACCEPTED_SUBMISSIONS
	FROM SUBMISSION_STATS ss
	 GROUP BY ss.CHALLENGE_ID
)
/*Return the sums of total views and total unique views*/
, CTE_VIEWS AS (
	SELECT 
		vs.CHALLENGE_ID
		, SUM(vs.TOTAL_VIEWS) AS TOTAL_VIEWS
		, SUM(vs.TOTAL_UNIQUE_VIEWS) AS TOTAL_UNIQUE_VIEWS
	FROM VIEW_STATS vs
	GROUP BY vs.CHALLENGE_ID
)
/*Main query*/
SELECT  c.CONTEST_ID
        , c.HACKER_ID
        , c.NAME
        , SUM(s.TOTAL_SUBMISSIONS)
        , SUM(s.TOTAL_ACCEPTED_SUBMISSIONS)
        , SUM(v.TOTAL_VIEWS)
        , SUM(v.TOTAL_UNIQUE_VIEWS)
FROM CONTESTS c
INNER JOIN COLLEGES co ON c.CONTEST_ID = co.CONTEST_ID
INNER JOIN CHALLENGES ch ON co.COLLEGE_ID = ch.COLLEGE_ID
LEFT JOIN CTE_SUBMISSIONS s ON ch.CHALLENGE_ID = s.CHALLENGE_ID
LEFT JOIN CTE_VIEWS v ON ch.CHALLENGE_ID = v.CHALLENGE_ID
GROUP BY 
    c.CONTEST_ID
    , c.HACKER_ID
    , c.NAME
HAVING SUM(s.TOTAL_SUBMISSIONS + s.TOTAL_ACCEPTED_SUBMISSIONS + v.TOTAL_VIEWS + v.TOTAL_UNIQUE_VIEWS)>0
ORDER BY c.CONTEST_ID;