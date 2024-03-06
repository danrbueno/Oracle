/* 
This query consists in the solution of the HackerRank challenge below:

Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

Link to the challenge:
https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem
*/

WITH  
/*CTE to return the row number of the days*/
CTE_ORDERED_DATES AS (
    SELECT 
        ROW_NUMBER() OVER(ORDER BY s.SUBMISSION_DATE ASC) DATE_ROW,
        s.SUBMISSION_DATE
    FROM SUBMISSIONS s
    GROUP BY 
		s.SUBMISSION_DATE
)
/*CTE to return the row number of the hackers on each day*/
, CTE_ORDERED_HACKERS AS (
    SELECT 
        s.HACKER_ID
        , s.SUBMISSION_DATE
        , ROW_NUMBER() OVER(PARTITION BY s.HACKER_ID ORDER BY s.SUBMISSION_DATE ASC) HACKER_ROW
    FROM SUBMISSIONS s
    GROUP BY 
		s.SUBMISSION_DATE
		, s.HACKER_ID
)
/*CTE to return the hackers that submitted in all previous days*/
, CTE_ALL_DAYS_HACKERS AS (
    SELECT 
        od.SUBMISSION_DATE
        , oh.HACKER_ID
    FROM CTE_ORDERED_DATES od
    LEFT JOIN CTE_ORDERED_HACKERS oh ON (od.SUBMISSION_DATE=oh.SUBMISSION_DATE 
                                         AND od.DATE_ROW=oh.HACKER_ROW)
)
/*CTE to return which hacker submitted the maximum number of submissions in each day*/
, CTE_MAX_SUBMISSIONS AS (
    SELECT 
        s.SUBMISSION_DATE
        , s.HACKER_ID
        , RANK() OVER (PARTITION BY s.SUBMISSION_DATE ORDER BY COUNT(s.SUBMISSION_ID) DESC, s.HACKER_ID ASC) AS RANKING
    FROM SUBMISSIONS s
    GROUP BY 
        s.SUBMISSION_DATE
        , s.HACKER_ID
)
/*Main query*/
SELECT 
    adh.SUBMISSION_DATE 
    , COUNT(*)
    , ms.HACKER_ID
    , h.NAME
FROM CTE_ALL_DAYS_HACKERS adh
JOIN CTE_MAX_SUBMISSIONS ms ON ms.SUBMISSION_DATE = adh.SUBMISSION_DATE
JOIN HACKERS h ON h.HACKER_ID = ms.HACKER_ID
WHERE ms.RANKING = 1
GROUP BY 
    adh.SUBMISSION_DATE
    , ms.HACKER_ID
    , h.NAME
ORDER BY 
    adh.SUBMISSION_DATE;
