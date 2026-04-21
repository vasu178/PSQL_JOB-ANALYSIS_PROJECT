/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/
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