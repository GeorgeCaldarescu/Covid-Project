--Tableau visualization

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))
as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) * 100
as deathPercentage
from Covid_project..covidDeaths
where continent is not null
order by 1,2

-- total deaths grouped by continent
Select location, SUM(cast(new_deaths as int)) as totalDeathCount
from Covid_project..covidDeaths
where continent is null 
and location not in ('World', 'European Union', 'International', 'Upper middle income',
'High income', 'Lower middle income', 'Low income')
group by location
order by totalDeathCount desc


-- highest infection and percentage of infected population from each country
Select location, population, MAX(total_cases) as highestInfectionCount, MAX((total_cases / population)) * 100 
as percentPopulationInfected
from Covid_project..covidDeaths
where continent is not null 
and location not in ('World', 'European Union', 'International', 'Upper middle income',
'High income', 'Lower middle income', 'Low income')
group by location, population
order by percentPopulationInfected desc

-- highest infection and percentage of infected population from each country by date
Select location, population, date, MAX(total_cases) as highestInfectionCount, MAX((total_cases / population)) * 100 
as percentPopulationInfected
from Covid_project..covidDeaths
where continent is not null 
and location not in ('World', 'European Union', 'International', 'Upper middle income',
'High income', 'Lower middle income', 'Low income')
group by location, population, date
order by percentPopulationInfected desc
