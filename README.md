# Introduction
📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT 
     jobs.job_id,
     jobs.company_id,
    companies.name,
    jobs.job_location,
    jobs.job_title,
    jobs.salary_year_avg
FROM job_postings_fact as jobs
LEFT JOIN company_dim as companies
ON jobs.company_id = companies.company_id
WHERE jobs.job_title Like '%Data analyst%'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:
- * **Top pay comes from specialization + location** → The highest salary (130k) is in New York, and roles tied to domains like security, blockchain, or intelligence tend to pay more than generic analyst roles.

* **Most salaries cluster tightly (~110k–120k)** → This shows a strong market standard; once you’re in the field, big jumps come from specialization, not just experience.

* **Repeated “Data Analyst” roles don’t add insight** → Multiple identical entries (~110k) indicate you’re looking at raw data, not trends—aggregation is needed for meaningful conclusions.

![Top Paying Roles](GRAPHS/Q1.png)
*Bar graph visualizing the salary for the top 10 jobs for data analysts; ChatGPT generated this graph from my SQL query results*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql

WITH top_data_analyst_jobs as(
SELECT 
     jobs.job_id,
     jobs.company_id,
    companies.name,
    jobs.job_location,
    jobs.job_title,
    jobs.salary_year_avg
FROM job_postings_fact as jobs
LEFT JOIN company_dim as companies
ON jobs.company_id = companies.company_id
WHERE jobs.job_title Like '%Data analyst%'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10)

SELECT 
    top_data_analyst_jobs.job_id,
    top_data_analyst_jobs.company_id,
    top_data_analyst_jobs.name,
    top_data_analyst_jobs.job_location,
    top_data_analyst_jobs.job_title,
    top_data_analyst_jobs.salary_year_avg,
    skills_dim.skills,
    skills_dim.skill_id
FROM top_data_analyst_jobs
LEFT JOIN skills_job_dim 
ON top_data_analyst_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
Limit 10;
```
* **High-paying roles consistently require core data stack** → SQL and Python appear across almost all top-paying jobs, making them non-negotiable baseline skills.

* **Advanced libraries/tools signal higher value** → Skills like Pandas, NumPy, Scikit-learn, Tableau, and Power BI show up in the highest salary role (130k), indicating that combining analysis + visualization + ML basics increases earning potential.

* **Hybrid roles demand broader skillsets** → The “Data analyst hybrid” role includes SQL, Python, and even Scala, showing that higher-paying roles often expect cross-functional or engineering-adjacent skills.


![Top Paying Skills](GRAPHS/Q2.png)
*Bar graph visualizing the count of skills for the top average salary by skills for data analysts; ChatGPT generated this graph from my SQL query results*

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
WITH top_data_analyst_jobs AS (
    SELECT 
        jobs.job_id,
        jobs.company_id,
        jobs.job_title
    FROM job_postings_fact AS jobs
    LEFT JOIN company_dim AS companies
        ON jobs.company_id = companies.company_id
    WHERE jobs.job_title LIKE '%Data analyst%'
)

SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM top_data_analyst_jobs
INNER JOIN skills_job_dim
    ON top_data_analyst_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY demand_count DESC
LIMIT 5;
```
![In Demand Skills](GRAPHS/Q3.png)
*Bar graph visualizing the count of skills for the most demanded jobs for data analysts; ChatGPT generated this graph from my SQL query results*

* **SQL dominates the market** → almost **2x demand vs Tableau/Power BI** → this is the *core skill*, not optional
* **Python is the second pillar** → strong demand but still clearly behind SQL → shows analysts are expected to handle programming + analysis
* **Excel is still very relevant** → despite hype around tools, it remains a **top 3 skill** in real jobs
* **BI tools (Power BI, Tableau) are similar tier** → useful but **not as critical as SQL/Python**

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact 
INNER JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title like '%Data analyst%'
AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY avg_salary 
LIMIT 25;
```
![Highest Paying Skills](GRAPHS/Q4.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts; ChatGPT generated this graph from my SQL query results*

* **Top-paying skills are not beginner tools** → Looker, Java, SAS, AWS sit at the top → these are **advanced / specialized skills**, not entry-level

* **SQL still holds strong value (~80k)** → Even though it’s common, it still pays well → confirms it’s a **must-have foundation**

* **Big data & cloud skills boost salary** → Spark, NoSQL, Redshift, AWS → all cluster in higher salary range
  👉 This is where salaries start increasing meaningfully

* **Basic tools = lower pay** → Excel, MS Access, Outlook → clearly on the lower end
  👉 These won’t differentiate you in the market

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH demand_count as(
SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title like '%Data analyst%'
AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY demand_count DESC)
, salary_avg as (
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title like '%Data analyst%'
AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skills
ORDER BY avg_salary DESC
)

SELECT 
    demand_count.skills,
    demand_count.demand_count,
    salary_avg.avg_salary
FROM demand_count
INNER JOIN salary_avg
ON demand_count.skills = salary_avg.skills
WHERE demand_count.demand_count > 10
ORDER BY salary_avg.avg_salary DESC, demand_count.demand_count DESC
```

![Most Optimal Skills](GRAPHS/Q5.png)
*Bar graph visualizing the count of skills for the most optimal  jobs for data analysts; ChatGPT generated this graph from my SQL query results*
---

## 

* **Python leads clearly (~95k)** → Best skill in terms of payoff → strong combination of demand + salary
* **Tableau is second (~89k)** → Shows visualization skills are highly valued when paired with analytics
* **SQL is essential but not top-paying (~80k)** → High demand but acts as a baseline, not a differentiator
* **Excel is lowest (~72k)** → Widely used but limited salary growth → not enough for high-paying roles

# What I Learned

Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers Using Subqueries and CTE's.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This mini project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.