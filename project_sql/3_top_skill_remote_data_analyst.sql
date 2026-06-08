SELECT
    skill.skill_id,
    skill.skills,
    count(*) as skill_count
FROM
    job_postings_fact job
INNER JOIN
    skills_job_dim sd ON job.job_id = sd.job_id 
INNER JOIN
    skills_dim skill ON sd.skill_id = skill.skill_id
WHERE 
    job.job_location = 'Anywhere' and 
    job.job_title_short = 'Data Analyst'
group by 
    skill.skill_id
ORDER BY 
    skill_count desc
LIMIT 10