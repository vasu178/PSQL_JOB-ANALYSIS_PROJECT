/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
*/

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

