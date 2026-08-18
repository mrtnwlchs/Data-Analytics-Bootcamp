----------------------
# Declaración SELECT #
----------------------

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

---------------------
# Clausula Group By #
---------------------

-- Agrupar registros por genero y obtener el promedio de edad por cada registro agrupado
select gender, avg(age), max(age), min(age), count(age) from employee_demographics group by gender;
# AVG() - Valor promedio
# MAX() - Valor máximo
# MIN() - Valor mínimo
# COUNT() - Cantidad de registros

---------------------
# Clausula Order By #
---------------------

-- Seleccionar los registros ordenados por edad de forma descendente
select * from employee_demographics order by age desc;

-------------------
# WHERE vs HAVING #
-------------------

-- HAVING Permite filtrar registros obtenidos mediante funciones de agregación
select gender, avg(age) from employee_demographics
group by gender
having avg(age) > 40;

select occupation, avg(salary) from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 75000;

-----------------
# LIMIT & ALIAS #
-----------------

-- Limitar la cantidad de registros obtendidos
select * from employee_demographics
order by age desc
limit 3;

-- Crear un alias reutilizable en la consulta
select occupation, avg(salary) avg_salary from employee_salary
group by occupation
having avg_salary > 70000; -- se reutiliza el alias avg_salary para aplicar el filtro

--------
# JOIN #
--------

-- INNER JOIN
select * from employee_demographics dem
join employee_salary sal -- si employee_id existe en una tabla  y en otra no, se omite de la consulta
on dem.employee_id = sal.employee_id;

-- LEFT JOIN
select * from employee_demographics dem
left join employee_salary sal -- retorna todos los registros de la tabla de la izquierda, aunque employee_id no exista en la de la derecha
on dem.employee_id = sal.employee_id;

-- RIGHT JOIN
select * from employee_demographics dem
right join employee_salary sal -- retorna todos los registros de la tabla de la derecha, aunque employee_id no exista en la de la izquierda
on dem.employee_id = sal.employee_id;

-- INNER JOIN
select emp1.first_name first_name_emp1, emp1.last_name last_name_emp1
from employee_demographics emp1
inner join employee_salary emp2; -- retorna los registros de la misma tabla combinados en emparejamientos por file empleado1 - empleado2

-- JOIN MULTIPLE TABLES
select ed.first_name, ed.last_name, ed.age, ed.gender, pd.department_name from employee_demographics ed
join employee_salary es on ed.employee_id = es.employee_id
join parks_departments pd on es.dept_id = pd.department_id; -- el join se realiza con la segunda tabla

---------
# UNION #
---------

-- unir los registros de 2 o más tablas. (Todas las tablas involucradas en el UNION deben retornar el mismo numero de columnas)
select first_name, last_name, 'old man' as label from employee_demographics
where age > 40 and gender = 'Male'
union
select first_name, last_name, 'old lady' as label from employee_demographics
where age > 40 and gender = 'Female'
union
select first_name, last_name, 'high salary' as label from employee_salary
where salary > 70000
order by first_name desc;

----------------------
# Funciones de texto #
----------------------

-- Cantidad de caracteres de una cadena de texto
select first_name, length(first_name) from employee_demographics;

-- Convertir caracteres en minuscula
select first_name, lower(first_name) from employee_demographics;

-- Remover espacios en blanco a la izquierda y derecha de un texto
select trim('           sky       ');

-- Remover espacios a la izquierda de un texto
select ltrim('           sky       ');

-- Remover espacios a la derecha de un texto
select rtrim('           sky       ');

-- Obtener una porción especifica de una cadena de texto
select first_name, substr(first_name, 1, 2) from employee_demographics;

-- Reemplazar caracteres en una cadena de texto
select  first_name, replace(first_name, 'a', 'x') from employee_demographics;

-- Obtener la posición de caracteres en una cadena de texto
select first_name, locate('rk', first_name) from employee_demographics;

-- Unir 2 o más cadenas de texto
select concat(first_name, ' ', last_name) as full_name from employee_demographics;