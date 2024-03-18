SELECT date, new_cases, new_deaths,total_cases, total_deaths
FROM Project..CovidDeaths
WHERE total_cases is not null
ORDER BY 1

SELECT location, date, new_vaccinations, total_vaccinations
FROM Project..CovidVaccinations
--WHERE total_cases is not null
WHERE location like 'Venezuela'
ORDER BY 1,2 

--SELECT *
--FROM Project..CovidVaccinations
--ORDER BY 3,4;

--DELETE FROM Project..CovidVaccinations
--WHERE continent is null

SELECT location, date, CONVERT(float,total_cases) AS Total_cases, new_cases, CONVERT(float,total_deaths) as Total_deaths, population
FROM Project..CovidDeaths
WHERE location like '%states%'
ORDER BY 5 desc


-- Total Cases vs Total Deaths
-- Percentage of Deaths
SELECT location, date, total_cases, total_deaths, (CONVERT(float,total_deaths)/CONVERT(float,total_cases))*100 AS DeathPercentage
FROM Project..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- Total Cases vs Population
-- Percentage of Deaths
SELECT location, date, population, total_cases, (CONVERT(float,total_cases)/population)*100 AS CasesPercentage
FROM Project..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- Highest Infection Rate compared to Population
SELECT location, population, MAX(CONVERT(float,total_cases)) AS HighestInfectionCountry, MAX((CONVERT(float,total_cases)/population))*100 
	AS PercentPopulationInfected
FROM Project..CovidDeaths
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- Highest Death Rate per Population
SELECT location, MAX(CONVERT(float,total_deaths)) AS TotalDeathCountry
FROM Project..CovidDeaths
GROUP BY location
ORDER BY TotalDeathCountry DESC

-- let's take a look now by continent
SELECT continent, MAX(CONVERT(float,total_deaths)) AS TotalDeathContinent
FROM Project..CovidDeaths
GROUP BY continent
ORDER BY TotalDeathContinent DESC

-- global numbers
SELECT date,SUM(CONVERT(int,new_cases)) AS TotalNewCases
FROM Project..CovidDeaths 
GROUP BY date
ORDER BY 1

Select date, MAX(CONVERT(int,total_deaths)) AS MaxTotalDeaths, MAX((CONVERT(float,total_deaths)/CONVERT(float,total_cases)))*100  AS PercentageDeaths
From Project..CovidDeaths
--Where location like '%states%'
Group By date
order by 1--,2

SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations, 
	SUM(CONVERT(bigint, ISNULL(vac.new_vaccinations, 0))) OVER (PARTITION BY dea.location ORDER BY dea.location)
	AS TotalVaccByCountry
FROM Project..CovidDeaths dea
JOIN Project..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
ORDER BY 2,3


-- Population vs Vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	   SUM(ISNULL(CONVERT(BIGINT, vac.new_vaccinations), 0)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RollingPeopleVaccinated
FROM Project..CovidDeaths dea
JOIN Project..CovidVaccinations vac
	 ON dea.location = vac.location
       AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL 
ORDER BY 2,3
