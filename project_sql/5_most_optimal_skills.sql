WITH skills_demand AS (
    SELECT
        skill.skill_id,
        skill.skills,
        COUNT(*) AS skill_count
    FROM job_postings_fact job
    INNER JOIN skills_job_dim sd
        ON job.job_id = sd.job_id
    INNER JOIN skills_dim skill
        ON sd.skill_id = skill.skill_id
    WHERE
        job.job_location = 'Anywhere'
        AND job.salary_year_avg IS NOT NULL
        AND job.job_title_short = 'Data Analyst'
    GROUP BY
        skill.skill_id,
        skill.skills
),

average_salary AS (
    SELECT
        skill.skill_id,
        skill.skills,
        ROUND(AVG(job.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact job
    INNER JOIN skills_job_dim sd
        ON job.job_id = sd.job_id
    INNER JOIN skills_dim skill
        ON sd.skill_id = skill.skill_id
    WHERE
        job.job_title_short = 'Data Analyst'
        AND job.salary_year_avg IS NOT NULL
        AND job.job_work_from_home = TRUE
    GROUP BY
        skill.skill_id,
        skill.skills
)

SELECT
    sd.skill_id,
    sd.skills,
    sd.skill_count,
    sal.avg_salary
FROM skills_demand sd
INNER JOIN average_salary sal
    ON sd.skill_id = sal.skill_id
WHERE sd.skill_count > 100
ORDER BY
    sal.avg_salary DESC,
    sd.skill_count DESC
LIMIT 25
