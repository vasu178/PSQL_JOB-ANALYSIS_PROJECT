/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills, 
    helping job seekers understand which skills to develop that align with top salaries
*/


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


