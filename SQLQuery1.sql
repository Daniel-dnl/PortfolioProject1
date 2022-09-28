--SELECT * FROM ProjectCovid..covidDeaths
--where location = 'asia'
--ORDER BY 3,4 ;
--SELECT * FROM ProjectCovid..covidVaccination
--ORDER BY 3,4 ;
-- slectin the data

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM ProjectCovid..covidDeaths
where continent is not  NULL
ORDER BY 1,2;

USE ProjectCovid;
SELECT location, new_cases,population
FROM covidDeaths
where continent is not  NULL
order by 1 ;

-- Death percentae in india
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercantage
FROM ProjectCovid..covidDeaths
WHERE location = 'india' 
ORDER BY 1,2;

-- total cases vs population
SELECT location,date,total_cases,population, (total_cases/population)*100 as populationPercantage
FROM ProjectCovid..covidDeaths
WHERE location = 'india'
ORDER BY 1,2;


SELECT location,date,total_cases,population, (total_cases/population)*100 as populationPercantage
FROM ProjectCovid..covidDeaths
WHERE location = 'india'
ORDER BY 1,2;

-- countries with highest infection rate
SELECT location, population,MAX(total_cases) as HihestInfectionCount, MAX((total_cases/population)*100) as highestInfectedPercentage
FROM ProjectCovid..covidDeaths
--WHERE location = 'india'
where continent is not  NULL
group by location, population
ORDER BY 3 desc;


-- countries with the highest death count per population

SELECT location, MAX(cast (total_deaths as int)) as DeathCountMax
FROM ProjectCovid..covidDeaths
--WHERE location = 'india'
where continent is not  NULL
group by location
ORDER BY 2 desc;


-- by continent 
SELECT location,population, MAX(cast (total_deaths as int)) as DeathCountMax
FROM ProjectCovid..covidDeaths
--WHERE location = 'india'
where continent is NULL
group by location, population
ORDER BY 2 desc;


-- day wise case count
SELECT date, SUM(new_cases) as dayWiseCases, SUM(cast(new_deaths as int)) as DailyDeaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as DailyDeathPercentage
FROM ProjectCovid..covidDeaths
--WHERE location = 'india'
where continent is not NULL
group by date
ORDER BY 1;


-- total population vs vaccination 
SELECT dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations 
FROM covidDeaths dea
join covidVaccination vac
ON vac.location = dea.location and vac.date = dea.date
where dea.continent is not null
order by 2,3;

--vaccination table
SELECT * FROM covidVaccination;

--rolling vacciation table india
SELECT continent, location ,date ,new_vaccinations ,SUM(cast(new_vaccinations as float)) OVER (Partition by location ORDER BY date, location) as rollingVaccinateNum
FROM covidVaccination
WHERE continent is not null and location = 'india'
ORDER BY 2,3;

-- rolling vccinated poplation world
SELECT dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM covidDeaths dea
join covidVaccination vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2,3;


WITH popvsvac (continent,location,date,population,new_vaccination, RollingPeoplaVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population ,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
FROM covidDeaths dea
join covidVaccination vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT null

)
SELECT * , (RollingPeoplaVaccinated/population)*100 as percentvaccinated
FROM popvsvac
where location = 'india';
