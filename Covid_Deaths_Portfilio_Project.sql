Select*
From PortfolioProject..Covid_Deaths
Where continent is not NULL
order by 3,4

--Select*
--From PortfolioProject..Covid_Vaccinations
--order by 3,4

-- Select the data we're going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Covid_Deaths
Where continent is not NULL
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract Covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Death_Percentage
From PortfolioProject..Covid_Deaths
Where location like '%kingdom%'
Where continent is not NULL
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select location, date, population, total_cases, (total_cases/population)*100 As Case_Percentage
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where continent is not NULL
order by 1,2

-- Looking at Countries with Highest Infection Rate vs Population

Select location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 As Case_Percentage
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where continent is not NULL
Group by location, population
order by Case_Percentage desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing conntinets with highest death count per population

Select continent, MAX(cast(total_deaths as bigint)) as Total_Death_Count
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where continent is not NULL
Group by continent
order by Total_Death_Count desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as bigint)) as Total_Death_Count
From PortfolioProject..Covid_Deaths
--Where location like '%kingdom%'
Where continent is not NULL
Group by location
order by Total_Death_Count desc


-- GLOBAL NUMBERS

Select date, SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as bigint)) as Total_Deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..Covid_Deaths
--Where location is like '%kingdom%'
Where continent is not NULL
Group by date
order by 1,2



-- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_Vaccination_Count
		--(Rolling_Vaccination_Count/population)*100
	From PortfolioProject..Covid_Vaccinations vac
	JOIN PortfolioProject..Covid_Deaths dea
		ON dea.location = vac.location
		AND dea.date = vac.date
	Where dea.continent is not NULL

-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_Vaccination_Count)
AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
	AS Rolling_Vaccination_Count
	--(Rolling_Vaccination_Count/population)*100
From PortfolioProject..Covid_Vaccinations vac
JOIN PortfolioProject..Covid_Deaths dea
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not NULL
)
SELECT *, (Rolling_Vaccination_Count/Population)*100
From PopvsVac

-- TEMP TABLE

DROP Table if exists #Percent_Population_Vaccinated
Create Table #Percent_Population_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Rolling_Vaccination_Count numeric
)

Insert into #Percent_Population_Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
	AS Rolling_Vaccination_Count
	--(Rolling_Vaccination_Count/population)*100
From PortfolioProject..Covid_Vaccinations vac
JOIN PortfolioProject..Covid_Deaths dea
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not NULL

SELECT *, (Rolling_Vaccination_Count/Population)*100
From #Percent_Population_Vaccinated

-- Creating view to store data for later visualisations

Create View Percent_Population_Vaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
	AS Rolling_Vaccination_Count
	--(Rolling_Vaccination_Count/population)*100
From PortfolioProject..Covid_Vaccinations vac
JOIN PortfolioProject..Covid_Deaths dea
	ON dea.location = vac.location
	AND dea.date = vac.date
Where dea.continent is not NULL
-- Order by 2,3

Select *
FROM Percent_Population_Vaccinated