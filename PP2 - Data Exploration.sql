
--Purpose: Portfolio Project 1 - Data Exploration 
--Datasets: https://ourworldindata.org/covid-deaths
--Dataset time range: 1st Jan 2020 to 30th April 2021

-- Quarry to check correct tables are being called
Select *
From PortfolioProject_Covid..CovidDeaths$
Where continent is not null 
Order by 3,4

Select *
From PortfolioProject_Covid..CovidVaccinations$
Order by 3,4


------ Running basic calculations to explore the data from tabel CovidDeaths------
-- Now select data that is actually going to be used
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject_Covid..CovidDeaths$
Where continent is not null 
Order by 1,2

---- Total cases vs Total Deaths 
--> 18 march 2020 - covid related deaths started in Pakistan
--> Likelihood of a covid patient dying = 0.44% to 2.17% 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject_Covid..CovidDeaths$
Where location like '%pakistan%'
Order by 1,2

---- Total cases vs Total Population 
--> Percentage of population that got Covid = 0.37% of 220,892,331
Select location, date, population, total_cases, (total_cases/population)*100 as DiseasePrevalence
From PortfolioProject_Covid..CovidDeaths$
Where location like '%pakistan%'
Order by 1,2

---- Countries with highest infection rate to population ratio
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercPopulationInfected
From PortfolioProject_Covid..CovidDeaths$
Where continent is not null 
Group by location, population
Order by PercPopulationInfected desc

---- Highest death count to population ratio
--> By location:
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject_Covid..CovidDeaths$
-- Where continent is not null --> giving incorrect results
Where continent is null
Group by location
Order by TotalDeathCount desc

-- By continent: 
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject_Covid..CovidDeaths$
Where continent is not null 
Group by continent
Order by TotalDeathCount desc

-- Global Numbers:
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DeathPercentage
From PortfolioProject_Covid..CovidDeaths$
Where continent is not null 
--Group by date
Order by 1,2


----- Running basic calculations to explore the data from both tabels ------
Select *
From PortfolioProject_Covid..CovidDeaths$ dea
join PortfolioProject_Covid..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
	
--Total Population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(CONVERT(int,vac.new_vaccinations)) 
OVER(Partition by  dea.location ORDER BY dea.location, dea.date) as RollingPepVac
From PortfolioProject_Covid..CovidDeaths$ dea
join PortfolioProject_Covid..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
order by 2,3

------Create CTE------
With PopVsVacc (Continent, location, date, population, new_vaccinations, RollingPepVac)
as
(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	 , SUM(CONVERT(int,vac.new_vaccinations)) 
	OVER(Partition by  dea.location ORDER BY dea.location, dea.date) as RollingPepVac
	From PortfolioProject_Covid..CovidDeaths$ dea
	join PortfolioProject_Covid..CovidVaccinations$ vac
		on dea.location = vac.location
		and dea.date = vac.date
	Where dea.continent is not null 
)
Select *, (RollingPepVac/population)*100
From PopVsVacc

----Create Temp Table------
DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations numeric,
	RollingPepVacc numeric
)

Insert into #PercentPopulationVaccinated
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
		 , SUM(CONVERT(int,vac.new_vaccinations)) 
		OVER(Partition by  dea.location ORDER BY dea.location, dea.date) as RollingPepVacc
	From PortfolioProject_Covid..CovidDeaths$ dea
	join PortfolioProject_Covid..CovidVaccinations$ vac
		on dea.location = vac.location
		and dea.date = vac.date
	Where dea.continent is not null 
Select *, (RollingPepVacc/population)*100
From #PercentPopulationVaccinated


------ Creating view to store data for later visualization ------
Create View PercentPopulationVaccinated8 AS
Select 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPepVacc
From PortfolioProject_Covid..CovidDeaths$ dea
join PortfolioProject_Covid..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
	
	Select *
	From PercentPopulationVaccinated4



USE PortfolioProject_Covid; -- Replace with your actual database name
SELECT * FROM PercentPopulationVaccinated8;