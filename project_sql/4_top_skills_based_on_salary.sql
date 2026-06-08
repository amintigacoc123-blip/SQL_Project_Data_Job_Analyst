SELECT
    skills,
    round(avg(salary_year_avg),0) as avg_salary
FROM
    job_postings_fact job 
INNER JOIN
    skills_job_dim sd on job.job_id = sd.job_id
INNER JOIN
    skills_dim skill on sd.skill_id = skill.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg is not null AND
    job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
limit 25
