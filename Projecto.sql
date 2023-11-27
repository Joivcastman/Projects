
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(NULLIF(convert(float,new_cases),0))* 100 AS DeathPercentage
from PortfolioProject..CovidDeadAnalysis
where continent is not null
order by 1,2




select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeadAnalysis
where continent is null
and location not in ('world','European Union','International','High income','Upper middle income', 'Lower middle income','Low income')
Group by location
order by TotalDeathCount desc



select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) * 100 AS PopulationPercentageInfected
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
group by location, population
order by PopulationPercentageInfected desc






--countries showing infection rate compared to population  (how many people got infected)
select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) * 100 AS PopulationPercentageInfected
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
group by location, population, date
order by PopulationPercentageInfected desc





select *
from PortfolioProject.dbo.CovidDeadAnalysis
where continent is not null
order by 3,4


--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeadAnalysis
where continent is not null
order by 1,2


--location at total cases vs total deaths, how many deaths for entire cases

select location, date, total_cases, total_deaths, (total_deaths/NULLIF(convert(float,total_cases),0)) * 100 AS PERC
from PortfolioProject..CovidDeadAnalysis
where location = 'Peru'
order by 1,2



--shows perc of population got covid
select location, date, population, total_cases, (total_cases/population) * 100 AS Perc
from PortfolioProject..CovidDeadAnalysis
where location = 'Peru'
order by 1,2


--countries showing infection rate compared to population  (how many people got infected)
select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) * 100 AS PopulationPercentageInfected
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
group by location, population, date
order by PopulationPercentageInfected desc


--countries showing highest death case per population
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
where continent is not null
group by location
order by TotalDeathCount desc



--BREAK THINGS DOWN BY COUNTRY
--right one
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
where continent is not null
group by location
order by TotalDeathCount desc

--BY CONTINENT
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
where continent is null
group by location
order by TotalDeathCount desc


--for exercise

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeadAnalysis
--where location = 'Peru'
where continent is not null
group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(NULLIF(convert(float,new_cases),0))* 100 AS DeathPercentage
from PortfolioProject..CovidDeadAnalysis 
--where location = 'Peru'
where continent is not null
group by date
order by 1,2


-- look at  toatl population vs vaccionations

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, CountingPopulationVaccinated) as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as CountingPopulationVaccinated
from PortfolioProject..CovidDeadAnalysis dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

select * , (CountingPopulationVaccinated/Population)*100
from PopvsVac


--temp table


create table #PercentPopulationVaccinated
(Continent nvarchar(255),
location varchar(255),
date datetime,
Population numeric,
New_Vaccination numeric,
CountingPopulationVaccinated numeric,
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as CountingPopulationVaccinated
from PortfolioProject..CovidDeadAnalysis dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
select * , (CountingPopulationVaccinated/Population)*100
from #PercentPopulationVaccinated



--create view to store data for later visualization

Create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as CountingPopulationVaccinated
from PortfolioProject..CovidDeadAnalysis dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

select * 
from PercentPopulationVaccinated