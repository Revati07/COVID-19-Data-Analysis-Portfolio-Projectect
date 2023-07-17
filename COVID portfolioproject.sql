Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccine
--order by 3,4

--select data that we are going to use

Select Location, date, total_cases, new_cases, total_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--looking at total cases vs total deaths
--shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--looking at total_cases vs population
--shows what percentage of population got covid

Select Location, date,Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--looking at countries with highest infection rate compared to population

Select Location, Population, MAX(total_cases) as HightestInfectionCount,MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--showing countries with highest death count per population

Select Location,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location
order by TotalDeathCount desc

--lets break things down by continant

Select continent,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--showing contintents with the highest death count per population

Select continent,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



--global numbers

Select   SUM(new_cases)as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--Group By date
order by 1,2


--looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccination
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccine vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (Continent, Location,Date,Population,RollingPeopleVaccinated
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccination
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccine vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select*,(RollingPeopleVaccinated/Population)*100
From	PopvsVac

--temp table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccination
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccine vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select*,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--creating view to store date for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccination
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccine vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select*
From PercentPopulationVaccinated









