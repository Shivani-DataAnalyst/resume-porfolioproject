Select * 
from PortfolioProject2..[Covid-Deaths]
Order by 3,4

--Select * 
--from PortfolioProject2..[Covid-Vaccination]
--Order by 3,4


Select location, date,total_cases,new_cases,total_deaths,population
from PortfolioProject2..[Covid-Deaths]
order by 1,2

--Looking at Total cases vs Total deaths
--Shows likelihood of dying if you contract covid in your country
Select location, date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject2..[Covid-Deaths]
where location like '%states%'
order by 1,2


--Looking at Total Cases vs population
--Shows what percentage of population got covid 
Select location, date,Population,total_cases,(total_cases/population)*100 as percentpopulationInfected
from PortfolioProject2..[Covid-Deaths]
--where location like '%states%'
Where continent is not null
order by 1,2


--Looking at countries with highest infection rate  compared to population
Select location,Population,MAX(total_cases) AS HighestInfectionCount,max(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject2..[Covid-Deaths]
--where location like '%states%'
Where continent is not null
Group by Location, population
order by PercentPopulationInfected desc


--Showing Countries with highest Death count per population

Select location,MAX(cast(total_deaths as int)) AS TotalDeathCount
from PortfolioProject2..[Covid-Deaths]
--where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT

Select continents,MAX(cast(total_deaths as int)) AS TotalDeathCount
from PortfolioProject2..[Covid-Deaths]
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing the continentswith highest death count per population
Select continents,MAX(cast(total_deaths as int)) AS TotalDeathCount
from PortfolioProject2..[Covid-Deaths]
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



--Global Numbers

Select date,SUM(new_cases) as total_cases,Sum(cast(new_deaths as int)) as total_deaths,SUM(cast(New_deaths as int))/Sum(new_cases)*100 as DeathPercentage
from PortfolioProject2..[Covid-Deaths]
--where location like '%states%'
Where continent is not null
Group by date
order by 1,2


Select * 
From PortfolioProject2..[Covid-Vaccination]

--Looking at Total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject2..[Covid-Deaths] dea
Join PortfolioProject2..[Covid-Vaccination] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccinated
from PortfolioProject2..[Covid-Deaths] dea
Join PortfolioProject2..[Covid-Vaccination] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With popvsVac(continent,Location,Date,Population,new_vaccinationsRollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(convert(int,vac.new_vaccinations))over(partition by dea.location order by dea.location,dea.date) as RollingPeoplevaccinated
from PortfolioProject2..[Covid-Deaths] dea
Join PortfolioProject2..[Covid-Vaccination] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
Select *
from popvsVac