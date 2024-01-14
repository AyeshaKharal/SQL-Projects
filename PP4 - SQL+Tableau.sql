/*
-- Purpose: Portfolio Project 4 - SQL Quarying + Tableau Visualization  
-- Datasets: https://ourworldindata.org/covid-deaths
-- Dataset time range: 1st Jan 2020 to 30th April 2021
*/

-- 1. Highest death count to population ratio globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject_Covid..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

/*
-- Just a double check based off the data provided
-> Result - numbers are extremely close so we will keep them 
-> The Second includes "International"  Location

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
-- where location = 'World'
-- Group By date
 order by 1,2
*/

-- 2. Total death count to population ratio by continent

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject_Covid..CovidDeaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- 3. Highest infection rate to population ratio by country

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject_Covid..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4. Highest infection rate to population ratio by country and date 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject_Covid..CovidDeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



