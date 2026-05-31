-- ===================================
-- HEART DISEASE DATA ANALYSIS PROJECT
-- Tools: MySQL
-- Dataset: heart_disease
-- Puurpose-- SQL Data Analysis Portfolio Project
-- ====================================

-- CREATE DATABASE
-- ================

create database heart_disease_project;

use heart_disease_project;

-- CREATE TABLE
-- =============

create table heart_disease (patient_id varchar(20), slope int, thal varchar(50), resting_bp int, chest_pain_type int, no_major_vessels int, fasting_bloodsugar int, 
resting_ekg_result int, serum_cholesterol int, oldpeak decimal(4,2), sex int, age int, max_heart_rate int, exercise_induced_angina int, target int);


-- 1. DATA OVERVIEW
-- =================

-- View first records from dataset
select * from heart_disease limit 10;


-- Count total patient record
select count(*) as total_patients from heart_disease;

-- Check distinct chest pain categories
select distinct(chest_pain_type) from heart_disease;


-- 2. KPI Metrics
-- ================

-- Count patients with heart disease
select count(*) as disease_cases from heart_disease where target=1;

-- or

select sum(target) as disease_cases from heart_disease;

-- Count patients without heart disease
 select count(*) as no_disease_cases from heart_disease where target=0;
 
 -- or 
 
 select count(*)-sum(target) as no_disease_cases from heart_disease;
 
 -- Calculate average patient age
 select round(avg(age),2) as avg_age from heart_disease;
 
 -- Calculate average cholesterol
 select round(avg(serum_cholesterol),2) as avg_cholesterol from heart_disease;
 
 -- Calculate average resting blood pressure
 select round(avg(resting_bp),2) as avg_bp from heart_disease;
 
 
 
 -- 3. DEMOGRAPHIC ANALYSIS
 -- ========================
 
 -- Count male and female patients
 select sex, count(*) as total from heart_disease group by sex;
 
 -- Compare disease case by gender
 select sex, count(*) as total_patients, sum(target) as disease_cases from heart_disease group by sex;
 
 -- Compare average age by gender
 Select sex, round(avg(age),2) as avg_age from heart_disease group by sex;
 
 
 
 -- 4. AGE GROUP AMALYSIS
 -- ======================
 
 -- Disease prevalence by age group
 select case when age < 40 then 'Under 40'
 when age between 40 and 55 then '40-55'
 else '55+' end as age_group, count(*) as total_patients, sum(target) as disease_cases
 from heart_disease group by age_group order by total_patients asc ;
 
 -- Oldest patients
 select * from heart_disease order by age desc limit 10;
 
 
 
 -- 5. MEDICAL RISK FACTORS
 -- ========================
 
 -- Compare cholesterol by disease status
 select target, round(avg(serum_cholesterol),2) as avg_cholesterol from heart_disease group by target;
 
 -- Compare blood pressure by disease status
 select target, round(avg(resting_bp),2) as avg_bp from heart_disease group by target;
 
 -- Compare maximum heart rate by disease status
 select target, round(avg(max_heart_rate),2) as avg_heart_rate from heart_disease group by target;
 
 -- Count high cholesterol patients (>240)
 select count(*) from heart_disease where serum_cholesterol > 240;
 
-- Count patients with blood pressure >130
 select count(*) from heart_disease where resting_bp >130;
 
 -- High risk patients
 select patient_id,age, sex, serum_cholesterol, resting_bp, target from heart_disease where age>55 and serum_cholesterol>240 and target=1;
 
 
 
 -- 6. CHEST PAIN ANALYSIS
 -- =======================
 
 -- Count patients by chest pain type
 select chest_pain_type, count(*) as total_patients from heart_disease group by chest_pain_type;
 
 -- Compare disease cases by chest pain type
 select chest_pain_type, count(*) as total_patients, sum(target) as disease_cases from heart_disease group by chest_pain_type;
 
 
 
 -- 7. EXERCISE ANALYSIS
 -- =====================
 
 -- Compare disease by exercise induced angina
 select exercise_induced_angina, count(*) as total_patients, sum(target) as disease_cases from heart_disease group by exercise_induced_angina;
 
 -- Average oldpeak by disease status
 select target, count(*) as total_patients, round(avg(oldpeak),2) as avg_oldpeak from heart_disease group by target;
 
 
 
 -- 8. ADVANCED ANALYSIS
 -- =====================
 
 -- Rank top cholesterol patients
 select patient_id, age, sex, serum_cholesterol, rank() 
 over(order by serum_cholesterol desc) as cholesterol_rank from heart_disease;
 
 -- Patients above average age
 select patient_id, age from heart_disease 
 where age>(select avg(age) from heart_disease);
 


-- 9. FINAL DASHBOARD KPI QUERY
-- =============================

-- Summary metrics for Power BI cards
 select count(*) as total_patients,
		sum(target) as disease_cases,
        count(*)-sum(target) as no_disease_cases,
        round(avg(age),2) as avg_age,
        round(avg(serum_cholesterol),2) as avg_cholesterol,
        round(avg(resting_bp),2) as avg_bp
from heart_disease;



-- 10. CREATING SQL VIEWS
-- =======================

create view vw_heart_summary as 
select patient_id, age,
case	when sex=1 then 'Male'
		else 'Female'
end as gender, chest_pain_type, serum_cholesterol, resting_bp, max_heart_rate, target
from heart_disease;


-- Create Age Group View

create view vw_age_group as
select	case	when age<40 then 'Under 40'
				when age between 40 and 55 then '40-55'
                else '55+'
		end as age_group, count(*) as total_patients, sum(target) as disease_cases 
from heart_disease group by age_group;

select * from vw_heart_summary; 

select * from vw_age_group;

create view vw_target as
select patient_id, age, sex, serum_cholesterol, resting_bp,
case	when target=0 then 'No Heart Disease'
		else 'Heart Disease'
end as taregt from heart_disease;

select * from vw_target;

