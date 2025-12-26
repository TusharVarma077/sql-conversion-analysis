-- ============================================================
-- FREE-TO-PAID CONVERSION ANALYSIS
-- TASK 2: CREATE THE MAIN QUERY
-- ============================================================
--
-- OBJECTIVE:
-- Calculate three key business metrics using the subquery
--
-- OUTPUT METRICS:
-- 1. conversion_rate - % of engaged students who purchased
-- 2. av_reg_watch - Avg days from registration to first watch
-- 3. av_watch_purch - Avg days from first watch to purchase
--
-- EXPECTED RESULTS:
-- conversion_rate:  11.00
-- av_reg_watch: 3.42
-- av_watch_purch: 26.25
-- ============================================================

USE db_course_conversions;

SELECT 
    -- CONVERSION RATE CALCULATION
    -- COUNT(first_date_purchased) = only counts non-NULL (purchasers)
    -- COUNT(first_date_watched) = counts all engaged students
    -- Division gives ratio, multiply by 100 for percentage
    ROUND(COUNT(first_date_purchased) / COUNT(first_date_watched), 2) * 100 
        AS conversion_rate,
    
    -- AVERAGE DAYS:  REGISTRATION TO FIRST WATCH
    -- SUM all the day differences, divide by count
    -- This gives the average duration
    ROUND(SUM(days_diff_reg_watch) / COUNT(days_diff_reg_watch), 2) 
        AS av_reg_watch,
    
    -- AVERAGE DAYS: FIRST WATCH TO FIRST PURCHASE
    -- Only non-NULL values are counted (students who purchased)
    ROUND(SUM(days_diff_watch_purch) / COUNT(days_diff_watch_purch), 2) 
        AS av_watch_purch

FROM
    (
    -- ========================================================
    -- SUBQUERY: Creates the analysis dataset
    -- ========================================================
    SELECT 
        e.student_id,
        i.date_registered,
        MIN(e.date_watched) AS first_date_watched,
        MIN(p.date_purchased) AS first_date_purchased,
        DATEDIFF(MIN(e.date_watched), i.date_registered) AS days_diff_reg_watch,
        DATEDIFF(MIN(p. date_purchased), MIN(e.date_watched)) AS days_diff_watch_purch
    FROM
        student_engagement e
        JOIN student_info i ON e.student_id = i.student_id
        LEFT JOIN student_purchases p ON e.student_id = p.student_id
    GROUP BY e.student_id
    HAVING first_date_purchased IS NULL
        OR first_date_watched <= first_date_purchased
    ) a;  -- Alias 'a' required for derived table in MySQL

-- ============================================================
-- HOW THE CALCULATIONS WORK
-- ============================================================
--
-- CONVERSION RATE: 
-- ┌─────────────────────────────────────────────────────────┐
-- │ COUNT(first_date_purchased) = Students who purchased   │
-- │ COUNT(first_date_watched) = All engaged students       │
-- │                                                        │
-- │ Example: 2,228 purchased / 20,255 watched = 0.11       │
-- │ Multiply by 100 = 11%                                  │
-- └─────────────────────────────────────────────────────────┘
--
-- AVERAGE CALCULATIONS:
-- ┌─────────────────────────────────────────────────────────┐
-- │ SUM(days) / COUNT(days) = Average                      │
-- │                                                        │
-- │ Note: NULL values are automatically excluded from      │
-- │ both SUM and COUNT operations                          │
-- └─────────────────────────────────────────────────────────┘
-- ============================================================