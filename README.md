# Introduction

📊 Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background

# The Analysis

### Top Paying Data Analyst Jobs

and location, focusing on remote jobs. This query highlights the high paying oppportunities in the field.

```sql
SELECT
    job.job_id,
    job.job_title,
    com.name AS company,
    job.job_location,
    job.job_schedule_type,
    job.salary_year_avg,
    job.job_posted_date::DATE
FROM
    job_postings_fact job
JOIN
    company_dim com ON job.company_id = com.company_id
WHERE
    job_location = 'Anywhere' AND
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### Top Paying Job Skills Required

Top skills for highest paying jobs for remote work

```sql
WITH top_paying_jobs as (
    SELECT
        job.job_id,
        job.job_title,
        com.name as company,
        job.salary_year_avg
    from
        job_postings_fact job
    left join
        company_dim com on job.company_id = com.company_id
    where
        job_location = 'Anywhere' and
        job_title_short = 'Data Analyst' and
        salary_year_avg is not NULL
    order by
        salary_year_avg desc
    limit 10
)

select
    top.job_id,
    top.job_title,
    top.salary_year_avg,
    top.company,
    skill.skills
from top_paying_jobs top
INNER JOIN skills_job_dim ON top.job_id = skills_job_dim.job_id
INNER JOIN skills_dim skill on skills_job_dim.skill_id = skill.skill_id
ORDER BY salary_year_avg desc
```

### Top Skills Demand For Data Analyst

```sql
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
```

### Top Skills Based On Salary

```sql
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
```

### Most Optimal Skills For Data Analyst

```sql
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

```

# What I Learned

# Conclusions
