-- exploring the data
SELECT * 
FROM Project.dbo.Cases
WHERE continent is NULL

--- as we can see location has continents , European Union .. etc, when continent is NULL, so the up coming
--- queries will take place only where continent is not NULL
SELECT * 
FROM Project.dbo.Cases
WHERE continent is not NULL
ORDER BY location , date

-- let's see how many cases and deaths for each day till the latest day 
SELECT date , SUM(CAST(new_cases AS int)) as total_cases , SUM(CAST(new_deaths AS int)) as total_deaths
FROM Project.dbo.Cases
WHERE continent is not NULL
group by date
order by date

-- total cases and deaths by each country
SELECT location , SUM(CAST(new_cases AS int)) as total_cases , SUM(CAST(new_deaths AS int)) as total_deaths 
FROM Project.dbo.Cases
WHERE continent is not NULL
GROUP BY location 
ORDER by location;

-- use CTE to remove the null values 
WITH new (location , total_cases , total_deaths)
as
(SELECT location , SUM(CAST(new_cases AS int)) as total_cases , SUM(CAST(new_deaths AS int)) as total_deaths 
FROM Project.dbo.Cases
WHERE continent is not NULL
GROUP BY location 
)
SELECT * 
FROM new 
WHERE total_cases is not null AND total_deaths is not null 
ORDER by location

-- explore vaccine data 
SELECT *
FROM Project.dbo.Vaccination

-- total vaccination for every country 
SELECT location , SUM(CAST(new_vaccinations AS int)) as total_vaccinations
FROM Project .dbo.Vaccination
WHERE continent is not null
GROUP BY location 
ORDER BY total_vaccinations desc

-- for USA we will see the total pof cases , deaths and vaccination till the latest day 

-- Join the two datasets 
WITH mix (continent ,location ,date ,new_cases ,total_cases , new_deaths , total_vaccinations ,people_vaccinated ,new_vaccinations )
as
(
SELECT ca.continent , ca.location , ca.date , ca.new_cases , ca.total_cases , ca.new_deaths, va.total_vaccinations , va.people_vaccinated , va.new_vaccinations 
FROM Project.dbo.Cases ca 
JOIn Project.dbo.Vaccination va 
     ON ca.location = va.location 
	 AND ca.date = va.date
where ca.continent is not null
) 
SELECT location , MAX(date) as till_this_date , SUM(CAST(new_cases AS int)) as total_cases , SUM(CAST(new_deaths AS int)) as total_deaths , SUM(CAST(new_vaccinations AS int)) as total_vaccinated_people
FROM mix
WHERE location = 'United States'
GROUP BY location

-- slice the data to visualize how vaccination affected the growth of new daily cases in USA 

WITH mix (continent ,location ,date ,new_cases ,total_cases , new_deaths , total_vaccinations ,people_vaccinated ,new_vaccinations )
as
(
SELECT ca.continent , ca.location , ca.date , ca.new_cases , ca.total_cases , ca.new_deaths, va.total_vaccinations , va.people_vaccinated , va.new_vaccinations 
FROM Project.dbo.Cases ca 
JOIn Project.dbo.Vaccination va 
     ON ca.location = va.location 
	 AND ca.date = va.date
where ca.continent is not null
) 
SELECT location, date, new_cases , new_deaths , total_vaccinations
FROM mix
WHERE location = 'United States'






