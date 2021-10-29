
-- Total cases vs Total Deaths
-- Shows likelihood of death via COVID-19 By Country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage, (total_deaths/total_cases)/100
FROM covid_deaths
ORDER BY 1, 2;

-- Total Cases vs Population in Oceania
-- Shoes what percentage of population contracted COVID-19
Select location, date, total_cases, total_deaths, population, (total_cases/population) * 100 as PercentContracted
FROM covid_deaths
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to population
Select location, date, MAX(total_cases) as HighestInfectionCount, total_deaths, population, MAX((total_cases/population))* 100 as PercentContracted
FROM covid_deaths
GROUP BY 1,5
ORDER BY 6 DESC;

-- Countries with the highest Death Count per population
Select location, max(total_cases) as MaxCases, MAX(casT(total_deaths AS signed)) as MaxDeaths
FROM covid_deaths
GROUP BY 1
ORDER BY 2 desc;


-- Total cases vs Total Deaths
-- Shows likelihood of death via COVID-19 by Continent

Select continent, sum(new_cases) as TotalCases, sum(cast(new_deaths as signed)) as TotalDeaths, sum(cast(new_deaths as signed))/sum(new_cases)*100 as DeathPercentage
FROM covid_deaths
ORDER BY 1;

-- Deaths and Vaccinations
Select  cd.location, max(cast(cd.total_deaths as signed)) as TotalDeaths, max(cv.total_vaccinations) as TotalVaccinations
FROM covid_deaths as cd
Inner JOIn covid_vaccinations as cv
ON cd.location=cv.location and cd.date=cv.date
GROUP BY 1
;

--  People Vaccinated Per Day
Select  cd.location, cd.date,  new_vaccinations, sum( cv.new_vaccinations) OVER (partition by cd.location ORDER BY cd.location, cd.date) as RollingVaccine
FROM covid_deaths as cd
INNER JOIn covid_vaccinations as cv
ON cd.location=cv.location and cd.date=cv.date
;

-- % of population vaccinated- CTE
WITH popVsVac (Location, population, Date, RollingVaccine)
as
(Select  cd.location, cd.population, cd.date,  sum( cv.new_vaccinations) OVER (partition by cd.location ORDER BY cd.location, cd.date) as RollingVaccine
FROM covid_deaths as cd
INNER JOIn covid_vaccinations as cv
ON cd.location=cv.location and cd.date=cv.date
)
SELECT *, (rollingvaccine/population)*100 
FROM popvsvac;

-- Create Temp Table
create temporary table popvac
SELECT Location, population, Date, RollingVaccine
FROM (Select  cd.location, cd.population, cd.date,  sum( cv.new_vaccinations) OVER (partition by cd.location ORDER BY cd.location, cd.date) as RollingVaccine
FROM covid_deaths as cd
INNER JOIn covid_vaccinations as cv
ON cd.location=cv.location and cd.date=cv.date 	
) as c;

-- Create View
Create view Deathsvsvacs as
Select  cd.location, max(cast(cd.total_deaths as signed)) as TotalDeaths, max(cv.total_vaccinations) as TotalVaccinations
FROM covid_deaths as cd
Inner JOIn covid_vaccinations as cv
ON cd.location=cv.location and cd.date=cv.date
GROUP BY 1;

SELECT * from deathvsvacs;