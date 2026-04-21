--Goal- to find out top paying data analyst jobs 

SELECT 
     jobs.job_id,
     jobs.company_id,
    companies.name,
    jobs.job_location,
    DISTINCT jobs.job_title,
    jobs.salary_year_avg
FROM job_postings_fact as jobs
LEFT JOIN company_dim as companies
ON jobs.company_id = companies.company_id
WHERE jobs.job_title Like '%Data analyst%'
AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
    