------------------------
# Declaración SELECT #
------------------------

select first_name, last_name, age, (age * 10) + 10 + 10 from employee_demographics;
# PEMDAS (Parentesis, Exponente, Multiplicación, División, Suma, Resta)

-- Seleccionar registros únicos
select distinct(gender) from employee_demographics;

-----------------
# Filtrar datos #
-----------------

-- Seleccionar registros que coincidan con una condición
select * from employee_demographics where first_name = 'Leslie';
select * from employee_salary where salary >= 50000;
select * from employee_demographics where gender = 'Female';
select * from employee_demographics where birth_date > '1985-01-01' and gender = 'Male';

-- Seleccionar registros que cumplan con una de 2 condiciones
select * from employee_demographics where (first_name = 'Leslie' and age = 44) or age > 55;

--------------------
# Declaración LIKE #
--------------------

-- Seleccionar registros a partir de una coincidencia parcial
select * from employee_demographics where first_name like '%jer%';

-- Seleccionar registros que empiecen con un caracter especifico y seguido tengan n cantidad de caracteres
select * from employee_demographics where first_name like 'a__'; -- 2 caracteres luego de `a`