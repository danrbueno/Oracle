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
        ROW_NUMBER() OVER(ORDER BY SUBMISSION_DATE ASC) NUMBER_OF_DATE,
        SUBMISSION_DATE
    FROM SUBMISSIONS
    GROUP BY SUBMISSION_DATE
)
/*CTE to return the row number of the hackers on each day*/
, CTE_ORDERED_HACKERS AS (
    SELECT 
        HACKER_ID
        , SUBMISSION_DATE
        , ROW_NUMBER() OVER(PARTITION BY HACKER_ID ORDER BY SUBMISSION_DATE ASC) HACKER_ORDER
    FROM SUBMISSIONS
    GROUP BY SUBMISSION_DATE, HACKER_ID
)
/*CTE to return the hackers that submitted in all previous days*/
, CTE_ALL_DAYS_HACKERS AS (
    SELECT 
        OD.SUBMISSION_DATE
        , OH.HACKER_ID
    FROM CTE_ORDERED_DATES OD
    LEFT JOIN CTE_ORDERED_HACKERS OH ON (OD.SUBMISSION_DATE=OH.SUBMISSION_DATE 
                                         AND OD.NUMBER_OF_DATE=OH.HACKER_ORDER)
)
/*CTE to return which hacker submitted the maximum number of submissions in each day*/
, CTE_MAX_SUBMISSIONS AS (
    SELECT 
        S.SUBMISSION_DATE
        , S.HACKER_ID
        , RANK() OVER (PARTITION BY S.SUBMISSION_DATE ORDER BY COUNT(S.SUBMISSION_ID) DESC, S.HACKER_ID ASC) AS RANK
    FROM SUBMISSIONS S
    GROUP BY 
        S.SUBMISSION_DATE
        , S.HACKER_ID
)
/*Main query*/
SELECT 
    ADH.SUBMISSION_DATE 
    , COUNT(*)
    , MS.HACKER_ID
    , H.NAME
FROM CTE_ALL_DAYS_HACKERS ADH
JOIN CTE_MAX_SUBMISSIONS MS ON MS.SUBMISSION_DATE = ADH.SUBMISSION_DATE
JOIN HACKERS H ON H.HACKER_ID = MS.HACKER_ID
WHERE MS.RANK = 1
GROUP BY 
    ADH.SUBMISSION_DATE
    , MS.HACKER_ID
    , H.NAME
ORDER BY 
    ADH.SUBMISSION_DATE;