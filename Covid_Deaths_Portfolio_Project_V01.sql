-- Tableau Visualisation Covid Numbers Project
-- Global Numbers
-- Query 1

Select SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as bigint)) as Total_Deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..Covid_Deaths
--Where location is like '%kingdom%'
Where continent is not NULL
-- Group by date
order by 1,2


-- Query 2
-- Showing Countries With Highest Death Count Per Population
-- Taking out European Union as it's part of the Europe calculation
-- Taking out International and World as they're already part of the individual calculations
-- Taking out Income based categories

Select location, MAX(cast(total_deaths as bigint)) as Total_Death_Count
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where continent is NULL
And location not in ('World', 'European Union', 'International')
And location not like '%income%'
Group by location
order by Total_Death_Count desc


-- Query 3
-- Looking at Countries with Highest Infection Rate vs Population

Select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 As Case_Percentage
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where location not in ('World', 'European Union', 'International')
And location not like '%income%'
Group by location, population
order by Case_Percentage desc


-- Query 4
--Looking at Countries with Highest Infection Rate vs Population over time

Select Location, Population, Date, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 As Case_Percentage
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where location not in ('World', 'European Union', 'International')
And location not like '%income%'
Group by location, population, date
order by Case_Percentage desc

