---------------------
# Limpieza de datos #
---------------------

-- 1. Remover duplicados

# obtener los registros duplicados encontrados en la tabla original
with get_duplicates as (
	select company, location, industry, `date`, 
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
	from layoffs
) select * from get_duplicates where row_num > 1;

# crear una tabla de ensayo para evitar realizar modificaciones sin respaldo de los datos
create table layoffs_staging like layoffs;

# agregar una columna adicional a la tabla de ensayo que permita referenciar los registros duplicados
alter table layoffs_staging add row_num int;

# insertar los registros de la tabla original en la nueva tabla de ensayo, agregando el numero de fila que se corresponde a cada registro para referenciar los duplicados
insert into layoffs_staging (
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
) select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs;

# eliminar los registros duplicados de la tabla de ensayo
delete from layoffs_staging where row_num > 1;

-- 2. Estandarizar los datos

# remover espacios en blanco en la columna company
update layoffs_staging set company = trim(company);	

# normalizar las ocurrencias de `Crypto` en la columna industry
update layoffs_staging set industry = 'Crypto' where industry like 'crypto%';

# normalizar las ocurrencias de `United States` removiendo caracteres adicionales en la columna country
update layoffs_staging set country = trim(trailing '.' from country) where country = 'United States';

# modificar formato del campo `date` a un campo de fecha valido
update layoffs_staging set `date` = str_to_date(`date`, '%m/%d/%Y'); # formado dia/mes/año
alter table layoffs_staging modify column `date` date;

-- 3. Valores nulos o valores vacios

# eliminar los registros con valores nulos en la columna `total_laid_off` y `percentage_laid_off`
delete FROM layoffs_staging where total_laid_off is null and percentage_laid_off is null;

-- 4. Remover cualquier columna

# eliminar la columna `row_column` utilizada en la tabla de ensayo para identificar registros duplicados
alter table layoffs_staging drop column row_num;