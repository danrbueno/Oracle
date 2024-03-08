/* 
This query consists in the solution of the HackerRank challenge below:

Julia conducted a  days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique TB_HACKER who made at least  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of TB_SUBMISSION each day. If more than one such hacker has a maximum number of TB_SUBMISSION, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

Link to the challenge:
https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem
*/

WITH  
    /*CTE to return the row number of the days*/
    CTE_ORDERED_DATES AS (
        SELECT 
            ROW_NUMBER() OVER(ORDER BY s.DT_SUBMISSION ASC) DATE_ROW,
            s.DT_SUBMISSION
        FROM TB_SUBMISSION s
        GROUP BY 
            s.DT_SUBMISSION
    )
    /*CTE to return the row number of the TB_HACKER on each day*/
    , CTE_ORDERED_TB_HACKER AS (
        SELECT 
            s.HACKER_ID
            , s.DT_SUBMISSION
            , ROW_NUMBER() OVER(PARTITION BY s.HACKER_ID ORDER BY s.DT_SUBMISSION ASC) HACKER_ROW
        FROM TB_SUBMISSION s
        GROUP BY 
            s.DT_SUBMISSION
            , s.HACKER_ID
    )
    /*CTE to return the TB_HACKER that submitted in all previous days*/
    , CTE_ALL_DAYS_HACKER AS (
        SELECT 
            od.DT_SUBMISSION
            , oh.HACKER_ID
        FROM CTE_ORDERED_DATES od
        LEFT JOIN CTE_ORDERED_TB_HACKER oh ON (od.DT_SUBMISSION=oh.DT_SUBMISSION 
                                             AND od.DATE_ROW=oh.HACKER_ROW)
    )
    /*CTE to return which hacker submitted the maximum number of TB_SUBMISSION in each day*/
    , CTE_MAX_TB_SUBMISSION AS (
        SELECT 
            s.DT_SUBMISSION
            , s.HACKER_ID
            , RANK() OVER (PARTITION BY s.DT_SUBMISSION ORDER BY COUNT(s.ID) DESC, s.HACKER_ID ASC) AS RANKING
        FROM TB_SUBMISSION s
        GROUP BY 
            s.DT_SUBMISSION
            , s.HACKER_ID
    )
/*Main query*/
SELECT 
    adh.DT_SUBMISSION 
    , COUNT(*) AS CT_DAY_HACKERS
    , ms.HACKER_ID AS MAX_SUB_HACKER_ID
    , h.DS_NAME AS MAX_SUB_HACKER_NAME
FROM CTE_ALL_DAYS_HACKER adh
JOIN CTE_MAX_TB_SUBMISSION ms ON ms.DT_SUBMISSION = adh.DT_SUBMISSION
JOIN TB_HACKER h ON h.ID = ms.HACKER_ID
WHERE ms.RANKING = 1
GROUP BY 
    adh.DT_SUBMISSION
    , ms.HACKER_ID
    , h.DS_NAME
ORDER BY 
    adh.DT_SUBMISSION;