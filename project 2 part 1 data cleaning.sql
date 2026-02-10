# project 2: US Household Income Data Cleaning
-- data is generated from government website

select count(id)
from us_household_income
;

select count(id)
from ushouseholdincome_statistics
;

alter table ushouseholdincome_statistics rename column `ï»¿id` to `id`;

# using count and having clause to identify any duplicates
select id, count(id)
from us_household_income
group by id
having count(id) > 1
;

# use row_number() function to make duplicates pop out use row_id and partition them by id
-- we need to use subquery to filter data using where clause

select *
from (
select row_id, id,
row_number() over(partition by id order by id) as row_num
from us_household_income) as dupli
where row_num > 1
;

# use DELETE FROM and WHERE IN function to delete rows from column

delete from us_household_income
where row_id in (
	select row_id
    from (
		select row_id, id,
		row_number() over(partition by id order by id) as row_num
		from us_household_income) as dupli
		where row_num > 1
);

# lets check if there are any duplicates in 2nd table

select id, count(id)
from ushouseholdincome_statistics
group by id
having count(id) > 1; # no duplicates

select distinct(state_name) #count(state_name)
from us_household_income
group by State_name
;

# standerdizing data 
update us_household_income
set State_name = 'Georgia'
where State_name = 'georia'
;

select distinct(State_ab)
from us_household_income
group by State_ab
; # data is clean no errors

select *
from us_household_income
where place = ''
;

update us_household_income
set place = 'Autaugaville'
where county = 'Autauga County' and city = 'Vinemont'
;

select type, count(type)
from us_household_income
group by type;

update us_household_income
set type = 'Borough'
where type = 'Boroughs';

update us_household_income
set type = 'CDP'
where type = 'CPD';

select ALand, AWater
from us_household_income
where AWater = 0 or AWater = '' or AWater is null 
and (ALand = 0 or ALand = '' or ALand is null);