select * 
from Covid_project..CovidDeaths
where continent is not null
order by 3,4


-- Total cases vs Total deaths and get the percentage

Select location, date, total_cases, total_deaths,(total_deaths / total_cases) * 100 as DeathPercentage
From Covid_project..CovidDeaths
where location like '%Czech%' and continent is not null
order by 1,2

-- Total cases vs Population and get the percentage
Select location, date, population, total_cases,(total_cases/population) * 100  as PercentageThatGetCOVID
From Covid_project..CovidDeaths
where location like '%czech%' and continent is not null
order by 1,2

-- higher infection rate compared to population
Select location, population, max(total_cases) as highestInfectionCount,max((total_cases/population) * 100)  as PercentageThatGetCOVID
From Covid_project..CovidDeaths
where continent is not null
group by location, population
order by PercentageThatGetCOVID desc


-- highest death rate VERY IMPORTANT total_deaths column is in char and not integer use cast or convert to get the integer
Select location, MAX(cast(total_deaths as int)) as totalDeathCount
From Covid_project..CovidDeaths
where continent is not null
group by location
order by totalDeathCount desc

--highest death by continent
Select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From Covid_project..CovidDeaths
where continent is not null
group by continent
order by totalDeathCount desc

-- Global numbers
Select  sum(new_cases) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths,
SUM(cast(new_deaths as int)) / sum(new_cases)   as DeathPercentage
From Covid_project..CovidDeaths
where continent is not null
--group by date
order by 1,2


-- Join covid deaths table to covid vaccination tabel
select *
from Covid_project..covidDeaths dea
join Covid_project..covidvaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date

select *
from Covid_project..covidVaccinations

-- Total population vs Vaccination
-- use CTE
with popVSvac (continent, location, date, population, new_vaccinations, rollingPeopleVaccinated)
as (
Select dea.continent, dea.location, dea.date, dea.population, 
vac.total_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (partition by 
dea.location order by dea.location, dea.date rows UNBOUNDED PRECEDING) 
as rollingPeopleVaccinated
from Covid_project..covidDeaths dea
join Covid_project..covidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (rollingPeopleVaccinated / population) *100
from popVSvac

-- create view 

Create view percentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, 
	vac.total_vaccinations, SUM(convert(int, vac.new_vaccinations)) over (partition by 
	dea.location order by dea.location, dea.date rows UNBOUNDED PRECEDING) 
as rollingPeopleVaccinated
from Covid_project..covidDeaths dea
join Covid_project..covidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
