/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove null).
- Why? Highlight the top paying opportunities for Data Analyst
*/

SELECT  
    job.job_id,
    job.job_title,
    com.name as company,
    job.job_location,
    job.job_schedule_type,
    job.salary_year_avg,
    job.job_posted_date::date
from 
    job_postings_fact job
join 
    company_dim com on job.company_id = com.company_id
where 
    job_location = 'Anywhere' and 
    job_title_short = 'Data Analyst' and 
    salary_year_avg is not NULL
order by 
    salary_year_avg desc
limit 5