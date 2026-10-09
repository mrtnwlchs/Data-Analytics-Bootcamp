----------------------------------
# Análisis exploratorio de datos #
----------------------------------

# maximo total de despidos y porcentaje mayor de despidos (1 = 100%)
select max(total_laid_off), max(percentage_laid_off) from layoffs_staging;

# empresas con porcentaje de despido del 100%
select * from layoffs_staging where percentage_laid_off = 1 order by total_laid_off desc;

# total de despidos agrupados por `company`
select company, sum(total_laid_off) from layoffs_staging 
group by company
order by 2 desc;

# obtener el total de despidos por año
select YEAR(`date`) as YEAR, sum(total_laid_off) 
from layoffs_staging
where YEAR(`date`) is not null
group by YEAR
order by 1 desc;

# total de despidos por industria
select industry, sum(total_laid_off) from layoffs_staging
group by industry
order by 2 desc;