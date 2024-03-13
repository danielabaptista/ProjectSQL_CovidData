SELECT *
FROM Project..CovidDeaths
ORDER BY 3,4

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
