SELECT job_posted_date::DATE AS date_column
FROM job_postings_fact
LIMIT 10;

SELECT '2023-09-25'::DATE;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date
FROM 
    job_postings_fact
LIMIT 
    100

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date
FROM 
    job_postings_fact
LIMIT 
    100

SELECT 
    extract(month from job_posted_date) as month
FROM job_postings_fact
limit 100

SELECT
    count(*) as job_posted,
    EXTRACT(MONTH FROM job_posted_date) as month
from job_postings_fact
where extract(year from job_posted_date) = '2023' and job_title_short = 'Data Analyst'
group by month
order by job_posted
limit 100

select 
    job_schedule_type,
    avg(salary_year_avg) as avg_yearly_salary,
    avg(salary_hour_avg) as avg_hourly_salary
from job_postings_fact
where extract(month from job_posted_date) >= 6 
group by job_schedule_type

select 
    count(job_id) as number_of_job_postings,
    extract(month from job_posted_date at time zone 'UTC' at time zone 'America/New_York') as month
from job_postings_fact
where extract(year from job_posted_date at time zone 'UTC' at time zone 'America/New_York') = '2023'
group by month
order by month


create table january_jobs as
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1;

create table february_jobs as
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 2;

create table march_jobs as
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 3;


select
    count(job_title_short) as total_job,
    case
        when job_location = 'Anywhere' then 'Remote'
        when job_location like '%Indo%' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
where job_title_short = 'Data Analyst'
group by location_category

select 
    job_location,
    count(job_id)
from job_postings_fact
where job_location like '%Indo%' and job_title_short = 'Data Analyst'
group by job_location
order by job_location

select 
    job_title_short,
    count(*) as job_in_indonesia
from job_postings_fact
where job_location like '%Indo%' 
group by job_title_short


select
    job_title,
    job_title_short,
    job_location,
    salary_year_avg,
    salary_hour_avg,
    case
        when salary_year_avg >= 200000 then 'High Salary'
        when salary_year_avg >= 70000 then 'Standard Salary'
        else 'Lower Salary'
    end as salary
from job_postings_fact
where job_title_short = 'Data Analyst' and salary_year_avg is not null
order by salary_year_avg desc


-- SubQuery

select 
    count(*)
from(
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1
)

---

with january_jobs as (
    select *
    from job_postings_fact
    where extract(month from job_posted_date) = 1
)

select *
from january_jobs
order by job_posted_date
---

select
    c.name,
    Count(*) as job_post
from job_postings_fact p
left join company_dim c on p.company_id = c.company_id
group by name
order by job_post desc


with company_job_count as (
    select 
        company_id,
        count(*) as job_count
    from job_postings_fact
    group by company_id
)

select 
    name,
    job_count
from company_job_count jc
left join company_dim c on jc.company_id = c.company_id
order by jc.job_count desc

with skills_count as(
select
    skill_id,
    count(*) as skill_count
from skills_job_dim
group by skill_id
)

select
    s.skills,
    sc.skill_count
from skills_count sc
left join skills_dim s 
    on sc.skill_id = s.skill_id
order by sc.skill_count desc


with remote_job as(
select 
    job_id
from job_postings_fact
where job_location = 'Anywhere'
group by job_id 
)

select 
    s.skill_id,
    s.skills,
    COUNT(*) as demant_skill
from remote_job r 
left join skills_job_dim sj on r.job_id = sj.job_id
left join skills_dim s on sj.skill_id = s.skill_id
group by s.skills, s.skill_id
order by demant_skill desc
limit 5



select
    skills.skill_id,
    skills.skillS as skill_name,
    count(*) skill_demand
from job_postings_fact job
inner join skills_job_dim sj 
    on job.job_id = sj.job_id
inner join skills_dim skills 
    on sj.skill_id = skills.skill_id
where job_location = 'Anywhere' and job_title_short = 'Data Analyst'
group by skill_name, skills.skill_id
order by skill_demand desc
limit 5


select *
from skills_dim


select 
    job_title_short,
    company_id,
    job_location
from january_jobs
union all
select 
    job_title_short,
    company_id,
    job_location
from february_jobs
union all
select 
    job_title_short,
    company_id,
    job_location
from march_jobs


with job_postings_q1 as(
    select *
    from january_jobs
    union all
    select *
    from february_jobs
    union all
    select *
    from march_jobs
)

select 
    job.job_id,
    job.job_title as job,
    --job.job_title_short as category_job,
    skills.skills,
    skills.type,
    avg(salary_year_avg) as avg_salary
from job_postings_q1 job
join skills_job_dim sd 
    on job.job_id = sd.job_id
join skills_dim skills
    on sd.skill_id = skills.skill_id
where salary_year_avg > 70000
and job.job_title_short = 'Data Analyst'
group by
    job.job_id,
    job,
    skills.skills,
    skills.type
order by avg_salary desc