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

# What I Learned

# Conclusions
