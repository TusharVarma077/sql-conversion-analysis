-- ============================================================
-- FREE-TO-PAID CONVERSION ANALYSIS
-- TASK 1: CREATE THE SUBQUERY
-- ============================================================
-- 
-- OBJECTIVE: 
-- Create a result dataset by joining student_info, 
-- student_engagement, and student_purchases tables. 
--
-- OUTPUT COLUMNS:
-- 1. student_id - Unique student identifier
-- 2. date_registered - Registration date
-- 3. first_date_watched - First lecture watch date
-- 4. first_date_purchased - First purchase date (NULL if none)
-- 5. days_diff_reg_watch - Days from registration to first watch
-- 6. days_diff_watch_purch - Days from first watch to purchase
--
-- EXPECTED RESULT:  20,255 records
-- ============================================================

USE db_course_conversions;

SELECT 
    -- Student identifier from engagement table
    e.student_id,
    
    -- Registration date from student_info table
    i.date_registered,
    
    -- First date the student watched content
    -- Using MIN() because a student may watch multiple lectures
    MIN(e.date_watched) AS first_date_watched,
    
    -- First date the student made a purchase
    -- NULL if they never purchased (due to LEFT JOIN)
    MIN(p.date_purchased) AS first_date_purchased,
    
    -- Days between registration and first lecture watched
    -- DATEDIFF(later_date, earlier_date) returns difference in days
    DATEDIFF(MIN(e.date_watched), i.date_registered) AS days_diff_reg_watch,
    
    -- Days between first lecture and first purchase
    -- Returns NULL if first_date_purchased is NULL
    DATEDIFF(MIN(p.date_purchased), MIN(e.date_watched)) AS days_diff_watch_purch

FROM
    -- Start with engagement table (students who watched lectures)
    student_engagement e
    
    -- INNER JOIN with student_info
    -- All engaged students are registered (engagement is subset of info)
    JOIN student_info i ON e.student_id = i.student_id
    
    -- LEFT JOIN with student_purchases
    -- Not all engaged students purchase, so we keep NULLs
    LEFT JOIN student_purchases p ON e.student_id = p. student_id

-- Group by student to get one row per student
GROUP BY e. student_id

-- Filter results using HAVING (for aggregated columns)
HAVING 
    -- Include students who never purchased (NULL in purchase date)
    first_date_purchased IS NULL
    -- OR include students who watched before/on purchase date
    OR first_date_watched <= first_date_purchased;

-- ============================================================
-- WHY THESE CHOICES?
-- ============================================================
--
-- 1. Why INNER JOIN for student_info?
--    → Venn diagram shows all engaged students are registered
--    → We won't lose any records
--
-- 2. Why LEFT JOIN for student_purchases?
--    → Not all students who watch will purchase
--    → We need to keep non-purchasers (they get NULL)
--
-- 3. Why MIN() for dates?
--    → Students may have multiple watch/purchase records
--    → We need the FIRST occurrence of each
--
-- 4. Why HAVING instead of WHERE?
--    → We're filtering on aggregated columns (MIN values)
--    → WHERE runs before GROUP BY, HAVING runs after
--
-- 5. Why the OR condition?
--    → first_date_purchased IS NULL:  Never purchased
--    → first_date_watched <= first_date_purchased:  Logical flow
--    → These are mutually exclusive conditions
-- ============================================================