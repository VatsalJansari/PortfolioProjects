--Selecting dataset

select*
from Portfolioproject..contrywisecases as cw

select *
from Portfolioproject.dbo.covidindia as ci

--Order by the data
select *
from Portfolioproject..contrywisecases as cw
order by 1,2

select [State/UnionTerritory],Cured,Deaths,[Total cases]
from Portfolioproject.dbo.covidindia as ci
order by 4 desc

--Max Cured ,Deaths and Totalcase from INDIA or we can say final numbers according to last date of dataset.
--Total cases of individual states of India until 11th august 2021.

select [State/UnionTerritory],max(Cured) As max_cured,max(Deaths) as max_death,max([Total cases]) as Total_case
from Portfolioproject.dbo.covidindia as ci
group by [State/UnionTerritory] 


-- Using of where : select any states from the data set and get the numbers. 

select [State/UnionTerritory],Cured,Deaths,[Total cases],Date
from covidindia
where [State/UnionTerritory]  = 'gujarat' 
order by [Total cases] desc

--In the first row of above result is, the total number of cures case,death case and total case which is sum of both of them until 11th august 2021.

--Finding total cured ,death and cases in all over india until 11th august 2021.

with newtable as (
select [State/UnionTerritory],max(Cured) As max_cured,max(Deaths) as max_death,max([Total cases]) as Total_case
from Portfolioproject.dbo.covidindia as ci
group by [State/UnionTerritory] )


select sum(max_cured) as Sum_of_cured ,sum(max_death) as Sum_of_death ,sum(Total_case) as Sum_of_total_cases 
from newtable

--Selecting all states with no null values.

select *
from newtable
where max_cured != 0
order by 1

--Delete extra column from the table.

alter table  Portfolioproject..covidindia
drop column time

alter table contrywisecases
drop column death,recovered 

--Selecting countywise data and doing Analysis and we can predict that those number are final covid numbers:

select *
from contrywisecases

-- Top 3 Infected countries in series : USA,India,Brazil.

select countryname,totalinfected
from contrywisecases
order by 2 desc

-- Top 3 death number countries in series : USA,Brazil,India

select countryname,TotalDeaths
from contrywisecases
order by 2 desc

-- Top 3 recovered countries in series : USA,Brazil,India

select countryname,TotalRecovered
from contrywisecases
order by 2 desc


-- How many counries are affected : 212 countries

select count(countryname)
from contrywisecases

-- Sum of totaldeath, total infected and total recoved cases all over the world.

select sum(TotalRecovered) as sumoftotalrecovered,sum(TotalDeaths) as sumoftotaldeath,sum(TotalInfected) as Sumoftotalinfected
from contrywisecases

-- Find minimum death number in data group by country : so in 8 contries deaths number is 0 so nobody died in those country according to dataset.

Select min(totaldeaths)
from contrywisecases

Select countryname,totaldeaths
from contrywisecases
where TotalDeaths = 0

--Create view for visulization :

create view Total_numbers as (
select sum(TotalRecovered) as sumoftotalrecovered,sum(TotalDeaths) as sumoftotaldeath,sum(TotalInfected) as Sumoftotalinfected
from contrywisecases
)

drop view if exists india_states

Create view india_states as (
select [State/UnionTerritory],max(Cured) As max_cured,max(Deaths) as max_death,max([Total cases]) as Total_case
from Portfolioproject.dbo.covidindia as ci
group by [State/UnionTerritory] 
)