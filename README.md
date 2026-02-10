# US Household Income Data Project – SQL

## Overview

### This project demonstrates a comprehensive SQL-based data cleaning and exploratory analysis workflow on US household income data. The dataset is sourced from official government records and contains information about states, counties, cities, and household income statistics.

**The project is divided into two parts:**

**Data Cleaning –** Preparing raw data for analysis by handling duplicates, standardizing text, and filling missing values.

**Data Analysis –** Performing exploratory analysis to derive insights about income patterns across states and cities.

All SQL queries are well-commented for clarity, making this project suitable for learning and portfolio showcase.

## Dataset: The project uses two datasets:

### 1. us_household_income

**Contains geographical and administrative information:**

**Columns:** id, State_Code, State_Name, County, City, Place, Type, ALand, AWater, Lat, Lon, etc.

### 2. ushouseholdincome_statistics

**Contains household income statistics:**

**Columns:** id, State_Name, Mean, Median, Stdev, sum_w

## Part 1: Data Cleaning

***The cleaning process includes:***

***Removing duplicates using COUNT, ROW_NUMBER() and DELETE.***

<img width="774" height="498" alt="pro2_part1_pic1" src="https://github.com/user-attachments/assets/7d5ef8bf-6722-4d97-b9eb-ee22aa7060c4" />



***Renaming columns for readability (e.g., ï»¿id → id).***

<img width="592" height="544" alt="pro2_part1_pic2" src="https://github.com/user-attachments/assets/8d204f35-6fc4-4fa0-a5c6-a38385666da1" />



***Standardizing text (e.g., fixing typos in State_Name).***

<img width="436" height="594" alt="pro2_part1_pic3" src="https://github.com/user-attachments/assets/d953f78c-8a41-456a-a26c-d65a50ccf3a2" />



***Filling missing values for critical columns (Place, Type, ALand, AWater).***

<img width="565" height="687" alt="pro2_part1_pic4" src="https://github.com/user-attachments/assets/ef8c84d5-6640-4214-ac9e-75a090cd2961" />



***Validating data quality using DISTINCT, GROUP BY and HAVING clauses.***

<img width="565" height="692" alt="pro2_part1_pic5" src="https://github.com/user-attachments/assets/c373880a-3ae0-4ab6-8e2c-81c39057a7b9" />


```
-- Identify duplicates
select id, count(id)
from us_household_income
group by id
having count(id) > 1;

-- Remove duplicates
delete from us_household_income
where row_id in (
  select row_id
  from (
    select row_id, id,
    row_number() over(partition by id order by id) as row_num
    from us_household_income
  ) as dupli
  where row_num > 1
);

-- Standardize state names
update us_household_income
set State_name = 'Georgia'
where State_name = 'georia';

-- Fill missing place values
update us_household_income
set place = 'Autaugaville'
```

### The dataset is now clean, standardized, and ready for analysis.

## Part 2: Data Analysis

## After cleaning, exploratory analysis was performed:

**1.Largest states by land area:**

<img width="565" height="692" alt="pro2_part2_pic1" src="https://github.com/user-attachments/assets/ae6b4e4d-9ef0-46a4-8d67-078141354e05" />

```
select State_Name, sum(ALand), sum(AWater)
from us_household_income
group by State_Name
order by sum(ALand) desc
limit 10;
```

**2.States with lowest household income:**

<img width="567" height="662" alt="pro2_part2_pic2" src="https://github.com/user-attachments/assets/505201fc-6115-4122-b05a-4f6e44da012e" />

```
select u.State_Name, round(avg(Mean),1), round(avg(Median),1)
from us_household_income as u
inner join ushouseholdincome_statistics as uhs
  on u.id = uhs.id
where Mean <> 0
group by u.State_Name
order by 2 asc
limit 5;
```

**3.Correlation of area type with income:**

<img width="567" height="662" alt="pro2_part2_pic3" src="https://github.com/user-attachments/assets/505201fc-6115-4122-b05a-4f6e44da012e" />

```
select type, count(type), round(avg(mean),1), round(avg(median),1)
from us_household_income as u
inner join ushouseholdincome_statistics as us
  on u.id = us.id
where mean <> 0
group by type
having count(type) > 50
order by 2 desc;
```

**4.Income by city and state:**

<img width="567" height="662" alt="pro2_part2_pic4" src="https://github.com/user-attachments/assets/505201fc-6115-4122-b05a-4f6e44da012e" />


```
select u.State_Name, city, round(avg(mean),2), round(avg(median),2)
from us_household_income as u
inner join ushouseholdincome_statistics as us
  on u.id = us.id
group by u.State_Name, city
order by round(avg(mean),2) desc;
```

## Key Findings

### Certain states have much larger land area but fewer high-income households.

### Outliers in income (e.g., 0 or extremely high values) were identified and handled carefully.

### Area type (City, Town, Borough) shows correlation with average mean and median income.

### Cleaning the dataset significantly improves the accuracy of analysis.

## Author

## Varun Voleti – Data Analyst | SQL Enthusiast
