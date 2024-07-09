Select location, date, total_cases, new_cases, total_deaths, population 
From ProjectOne..CovidDeaths order by 1,2

-- Total cases VS total_deaths
-- chance of dying if you get covid in 'county_name'
Select location, date, total_cases, round((total_deaths/total_cases),4) * 100 as deaths_percent,population 
From ProjectOne..CovidDeaths where location = 'Germany' order by 1,2


-- disease cases percentage
Select location, date, round((total_cases/population),4)*100 as cases_per_populus,population, round((total_deaths/total_cases),4) * 100 as deaths_percent, population 
From ProjectOne..CovidDeaths where location = 'Russia' order by 1,2 


-- country with highest infection rate
Select location,population,   max(total_cases) as HighestInfectionRate, max(round((total_cases/population),4))*100 as PercentageInfected 
From ProjectOne..CovidDeaths --where location = 'Russia'
group by  location,population
order by PercentageInfected desc

-- countries with highest death percentage per population and highest death count
Select location,population, max(cast(total_deaths as int)) as TotalDeadCount, max(round((total_deaths/population),4))*100 as PercentageDead
From ProjectOne..CovidDeaths --where location = 'Russia'  
where continent is not NULL
group by  location,population
order by 4 desc

-- same info breaked down by world parts
Select location, max(cast(total_deaths as int)) as TotalDeadCount, max(round((total_deaths/population),4))*100 as PercentageDead
From ProjectOne..CovidDeaths --where location = 'Russia'  
where continent is NULL
group by location
order by 3 desc

-- continents with highest death count

Select location, max(cast(total_deaths as int)) as TotalDeadCount, max(round((total_deaths/population),4))*100 as PercentageDead
From ProjectOne..CovidDeaths
where continent is  NULL
group by location
order by 2 desc

-- deaths per day
Select date, sum(cast(new_cases as int)) as TotalDiseaseCases, sum(cast(total_deaths as int)) as TotalDeaths, round((sum(cast(new_deaths as float))/sum(cast(new_cases as float)) * 100),3)  as DeathPercentPerDay
From ProjectOne..CovidDeaths
where continent is not NULL
group by date
order by 1,2 desc

-- total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location order by dea.location, dea.date) as PeopleVaccinated
from ProjectOne..CovidDeaths dea
JOIN ProjectOne..CovidVaccinations vac
on dea.location = vac.location AND 
dea.date = vac.date
where dea.continent is not NULL
order by 1,2

-- using CTE with the same zapros
with popvac (Continent, Location,Date,Population, NewVacinations ,PeopleVaccinated)
as ( select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location order by dea.location, dea.date) as PeopleVaccinated
from ProjectOne..CovidDeaths dea
JOIN ProjectOne..CovidVaccinations vac
on dea.location = vac.location AND 
dea.date = vac.date
where dea.continent is not NULL
--order by 2,3 
)
select *, round((PeopleVaccinated/Population)*100,3) as PercentageVaccinated
from popvac


Create table #PercentPopulationVaccinated
(
Continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, PeopleVaccinated numeric )


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location order by dea.location, dea.date) as PeopleVaccinated
from ProjectOne..CovidDeaths dea
JOIN ProjectOne..CovidVaccinations vac
on dea.location = vac.location AND 
dea.date = vac.date
where dea.continent is not NULL
order by 2,3 


select *, round((PeopleVaccinated/Population)*100,3) as PercentageVaccinated
from #PercentPopulationVaccinated

-- creating view
Create View PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) OVER (Partition by  dea.location order by dea.location, dea.date) as PeopleVaccinated
from ProjectOne..CovidDeaths dea
JOIN ProjectOne..CovidVaccinations vac
on dea.location = vac.location AND 
dea.date = vac.date
where dea.continent is not NULL
--order by 2,3 









