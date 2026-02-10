# project 2: part 2 - explotary data analysis after cleaning the data

select *
from us_household_income
;

select *
from ushouseholdincome_statistics
;

# Top 10 largest states by land?
select State_Name, sum(ALand), sum(AWater)
from us_household_income
group by State_Name
order by 2 desc
limit 10
;

# what are least 5 states with low house hold income
select u.State_Name,  round(avg(Mean),1), round(avg(Median),1)
from us_household_income as u
#right join ushouseholdincome_statistics as uhs
inner join ushouseholdincome_statistics as uhs
	on u.id = uhs.id
where Mean <> 0
group by u.State_Name
#where uhi.id is null
order by 2 desc
limit 11
;

# be aware of data quality issues
-- correlation of area type with median and mean
-- we can remove outliers by using having
select type,count(type), round(avg(mean),1), round(avg(median),1)
from us_household_income as u
inner join ushouseholdincome_statistics as us
	on u.id = us.id
where mean <> 0
group by type
having count(type) > 50
order by 2 desc
;

# correlation between cities and states with mean and median
select u.State_Name, city, round(avg(mean),2), round(avg(median),2)
from us_household_income as u
inner join ushouseholdincome_statistics as us
	on u.id = us.id
group by u.State_Name, city
order by round(avg(mean),2) desc
;



