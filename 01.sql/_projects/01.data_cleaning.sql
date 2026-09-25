---------------------
# Limpieza de datos #
---------------------

# crear una tabla de ensayo para evitar modificar la tabla sin respaldo
create table layoffs_staging like layoffs;
insert into layoffs_staging select * from layoffs;

-- 1. Remover duplicados

# obtener registros duplicados
with get_duplicates as (
select company, location, industry, `date`, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging
)
select * from get_duplicates where row_num > 1;

# crear una nueva tabla que contenga la columna del numero de fila para poder posteriormente referenciar duplicados
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# insertar los registros de la tabla original en la nueva tabla de ensayo, agregando el numero de fila para referenciar duplicados
insert into layoffs_staging2 (
`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`
) select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging;

# eliminar los registros duplicados
delete from layoffs_staging2 where row_num > 1;

-- 2. Estandarizar los datos

# remover espacios en blanco en la columna company
update layoffs_staging2 set company = trim(company);

# normalizar las ocurrencias de `Crypto` en la columna industry
update layoffs_staging2 set industry = 'Crypto' where industry like 'crypto%';

# normalizar las ocurrencias de `United States` removiendo caracteres adicionales
update layoffs_staging2 set country = trim(trailing '.' from country) where country = 'United States';

# modificar formato del campo `date` a un campo de fecha valido
update layoffs_staging2 set `date` = str_to_date(`date`, '%m/%d/%Y');
alter table layoffs_staging2 modify column `date` date;

-- 3. Valores nulos o valores vacios

-- 4. Remover cualquier columna