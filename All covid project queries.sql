


--selecting data for use
SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population AS TotalPopulation
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
-- AND location like '%State%'
ORDER BY 1,2


-- cases vs deaths (totals) on any date with cases

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PercentageTotalDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL AND new_cases != 0 
AND location like '%State%'
ORDER BY 1,2


-- cases vs deaths after vacinaitions start rolling out

DECLARE @start date = '2020-12-20 00:00:00.00'
SELECT location, CAST(date AS date) as date, total_cases, total_deaths
	FROM PortfolioProject..CovidDeaths
	WHERE continent IS NOT NULL AND total_cases IS NOT NULL AND new_cases != 0 AND date >= @start
		AND location like '%State%'
ORDER BY 1,2

-- new cases vs new deaths by date 
SELECT location, date, new_cases, new_deaths, (new_deaths/new_cases)*100 AS PercentageNewDeaths 
	FROM PortfolioProject..CovidDeaths
	WHERE continent IS NOT NULL AND new_cases IS NOT NULL AND new_cases != 0 
		AND location like '%State%'
ORDER BY 1,2

-- percentage of population that have died from covid
SELECT location, date, total_cases, total_deaths, population, (total_deaths/population)*100 AS PercentageOfPopulationDeaths
	FROM PortfolioProject..CovidDeaths
	WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
AND location like '%State%'
ORDER BY 1,2


-- highest infection rate as compared to population

SELECT location, population, MAX(total_cases) as HighestCount, MAX((total_cases/population))*100 AS PercentagePopulationCOVID
	FROM PortfolioProject..CovidDeaths
	WHERE continent IS NULL AND location NOT LIKE 'International' AND location NOT LIKE 'world' 
GROUP BY population, location
ORDER BY PercentagePopulationCOVID desc


-- highest death count by country

SELECT location, MAX(CAST(total_deaths AS INT)) as HighestDeathCount
	FROM PortfolioProject..CovidDeaths
--AND location like '%State%'
	WHERE continent IS NULL AND location NOT LIKE 'International' AND location NOT LIKE 'world' 
GROUP BY location
ORDER BY HighestDeathCount desc


-- by continent
-- *** not inlcuding International because the population is blank and the cases are 721 for every date. ***

SELECT location, MAX(total_cases) as HighestCount, population
FROM PortfolioProject..CovidDeaths
--AND location like '%State%'
WHERE continent IS NULL AND location NOT LIKE 'International' AND location NOT LIKE 'world' 
GROUP BY location, population



-- total vacinations continent


SELECT PortfolioProject..CovidVacinations.location, MAX(total_vaccinations) as Vaccinations, PortfolioProject..CovidDeaths.population 
	,MAX(CONVERT(BIGINT,PortfolioProject..CovidVacinations.total_vaccinations)/PortfolioProject..CovidDeaths.population)*100 AS PercentageVacinated -- Percentage is worng, need to keep working on this

FROM PortfolioProject..CovidVacinations
	
	INNER JOIN PortfolioProject..CovidDeaths ON PortfolioProject..CovidDeaths.location = PortfolioProject..CovidVacinations.location

	WHERE people_vaccinated IS NOT NULL AND total_vaccinations NOT LIKE '0' AND PortfolioProject..CovidVacinations.continent IS NULL 
		AND PortfolioProject..CovidVacinations.location NOT LIKE 'International' AND PortfolioProject..CovidVacinations.location NOT LIKE 'World'

GROUP BY PortfolioProject..CovidVacinations.location, PortfolioProject..CovidDeaths.population

ORDER BY PercentageVacinated DESC

SELECT location, MAX(people_fully_vaccinated)
	FROM PortfolioProject..CovidVacinations
	WHERE continent IS NULL AND location NOT LIKE 'International' AND location NOT LIKE 'world' 
	GROUP BY location
