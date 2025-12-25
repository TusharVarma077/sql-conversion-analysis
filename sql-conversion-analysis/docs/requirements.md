# 📋 Project Requirements

## Project Title
**Calculating Free-to-Paid Conversion Rate with SQL**

## Overview
This practice project allows you to apply your SQL knowledge to a real-world dataset.  Once you complete all tasks, you will have found the answer to the following questions:

1. What is the free-to-paid conversion rate of students who have watched a lecture on the 365 platform?
2. What is the average duration between the registration date and when a student has watched a lecture for the first time (date of first-time engagement)?
3. What is the average duration between the date of first-time engagement and when a student purchases a subscription for the first time (date of first-time purchase)?
4. How can we interpret these results, and what are their implications? 

---

## Task 1: Create the Subquery

### Instructions
Import the `db_course_conversions` database—stored in the db_course_conversions.sql file—into your schemas and study its content.  Then, by appropriately joining and aggregating the tables, create a new result dataset comprising the following columns: 

### Required Output Columns

| Column | Type | Description |
|--------|------|-------------|
| `student_id` | INT | The unique identification of a student |
| `date_registered` | DATE | The date on which the student registered on the 365 platform |
| `first_date_watched` | DATE | The date of the first engagement |
| `first_date_purchased` | DATE | The date of first-time purchase (NULL if they have no purchases) |
| `date_diff_reg_watch` | INT | The difference in days between the registration date and the date of first-time engagement |
| `date_diff_watch_purch` | INT | The difference in days between the date of first-time engagement and the date of first-time purchase (NULL if they have no purchases) |

### Hints
- Research the `DATEDIFF` function in MySQL
- Note the Venn diagram showing table relationships
- The resulting set should include student IDs of students entering the diagram's shaded region
- Filter your result dataset so that the date of first-time engagement comes before (or is equal to) the date of first-time purchase

### Sanity Check
The number of records in the resulting set should be **20,255**

---

## Task 2: Create the Main Query

### Instructions
Use the subquery you've created and retrieve the following three metrics:

### Required Metrics

#### 1. Free-to-Paid Conversion Rate (`conversion_rate`)
This metric measures the proportion of engaged students who choose to benefit from full course access on the 365 platform by purchasing a subscription after watching a lecture.

**Calculation:**
- Numerator: The number of students who watched a lecture and purchased a subscription on the same day or later
- Denominator: The total number of students who have watched a lecture

Convert the result to percentages. 

#### 2. Average Duration Between Registration and First-Time Engagement (`av_reg_watch`)
This metric measures the average duration between the date of registration and the date of first-time engagement. 

**Calculation:**
- Numerator: The sum of all such durations
- Denominator:  The count of these durations (number of students who have watched a lecture)

#### 3. Average Duration Between First-Time Engagement and First-Time Purchase (`av_watch_purch`)
This metric measures the average time it takes individuals to subscribe to the platform after viewing a lecture. 

**Calculation:**
- Numerator: The sum of all such durations
- Denominator:  The count of these durations (number of students who have made a purchase)

---

## Task 3: Interpretation

### Instructions
Interpret the numbers you've obtained considering: 

#### 1. Conversion Rate
- Compare this metric to industry benchmarks or historical data
- Consider what factors might influence this rate

#### 2. Registration to First Engagement Duration
- A short duration (same or next day) could indicate user-friendly registration and onboarding
- A longer duration may suggest users are hesitant or facing challenges

#### 3. Engagement to Purchase Duration
- A shorter span would suggest compelling content or effective up-sell strategies
- A longer duration might indicate students have been waiting for exclusive offers

### Optional:  Python Analysis
Using a tool different from SQL (e.g., Python), calculate the median and mode values of the date difference between: 
- Registering and watching a lecture
- Watching a lecture and purchasing a subscription

Compare these metrics to their respective mean values and analyze: 

- **Distribution Symmetry**: If mean, median, and mode are equal or very close, distribution is symmetrical (bell curve). If they differ, data might be skewed. 

- **Outliers**: If mean is much higher or lower than median, it suggests outliers exist.

- **Common Patterns**: If a specific value has high frequency (mode), it can spotlight common behaviors. 