select* From portfolio..CovidDeaths

select* From portfolio..CovidVac

--selecting data we are going to use from covid deaths table
select location, date, total_cases, total_deaths, population
From portfolio..CovidDeaths
order by 1,2


--Looking at total case vs total deaths in percentage
select total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From portfolio..CovidDeaths
order by 2,1

--Looking at total case vs total deaths in percentage in US
select date, location, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From portfolio..CovidDeaths
where location like '%states%'
order by 2,1

--Looking at total case vs overall population in percentage in US
select date, location, population, total_cases, (total_cases/population)*100 as cases_percentage
From portfolio..CovidDeaths
where location like '%states%'
order by 2,1

--Looking at countries with highest infection rate compared to popultion
select  location, population, max((total_cases/population)*100) as Max_cases_percentage
From portfolio..CovidDeaths
group by location, population
order by Max_cases_percentage desc

--Countries with highest death count per population
select location, max(cast(total_deaths as int)) as Max_death_per_country
From portfolio..CovidDeaths
group by location
having 'Max_death_per_country' is not null
order by 2 desc

--Removing NULL continent and invalid location from table 
select * 
From portfolio..CovidDeaths
where continent is not null

--New cases calculations 
select date, sum(new_cases) as new_cases_sum, sum(cast(new_deaths as int)) as new_deaths_sum ,
(sum(cast(new_deaths as int))/sum(new_cases))*100 as percentage
From portfolio..CovidDeaths
--need to take proper continents
where continent is not null
group by date
order by 1,2

--Lets join two tables 
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
From portfolio..CovidDeaths as cd
Join portfolio..CovidVac as cv
on cd.location = cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3

--Creating Temp table
Drop Table if exists #percentagepopulation
create table #percentagepopulation
(
continent varchar(255),
Location varchar(255),
Data datetime,
Population numeric,
New_vaccinations numeric,
)

Insert into #percentagepopulation
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
From portfolio..CovidDeaths as cd
Join portfolio..CovidVac as cv
on cd.location = cv.location
and cd.date=cv.date
where cd.continent is not null
order by 2,3

select* from #percentagepopulation
 
