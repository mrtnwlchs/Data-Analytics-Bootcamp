----------------------
# Declaración SELECT #
----------------------

select first_name, last_name, age, (age * 10) + 10 + 10 from employee_demographics;
# PEMDAS (Parentesis, Exponente, Multiplicación, División, Suma, Resta)

-- Seleccionar registros únicos
select distinct(gender) from employee_demographics;

---------------------------
# Filtrar datos con WHERE #
---------------------------

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
# Clausula GROUP BY #
---------------------

-- Agrupar registros por genero y obtener el promedio de edad por cada registro agrupado
select gender, avg(age), max(age), min(age), count(age) from employee_demographics group by gender;
# AVG() - Valor promedio
# MAX() - Valor máximo
# MIN() - Valor mínimo
# COUNT() - Cantidad de registros

---------------------
# Clausula ORDER BY #
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
where occupation like '%manager%' -- WHERE se utiliza antes de la función de agrupación para filtrar registros
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
select occupation, avg(salary) alias avg_salary from employee_salary
group by occupation
having avg_salary > 70000; -- se reutiliza el alias avg_salary para aplicar el filtro

--------
# JOIN #
--------

-- INNER JOIN
select * from employee_demographics dem
join employee_salary sal -- si employee_id no existe en una de las tablas, el registro no se añade a los registros obtenidos
on dem.employee_id = sal.employee_id;

select emp1.first_name first_name_emp1, emp1.last_name last_name_emp1
from employee_demographics emp1
inner join employee_salary emp2; -- retorna los registros de la misma tabla combinados en emparejamientos por file empleado1 - empleado2

-- LEFT JOIN
select * from employee_demographics dem
left join employee_salary sal -- retorna todos los registros de la tabla de la izquierda, aunque employee_id no exista en la de la derecha
on dem.employee_id = sal.employee_id;

-- RIGHT JOIN
select * from employee_demographics dem
right join employee_salary sal -- retorna todos los registros de la tabla de la derecha, aunque employee_id no exista en la de la izquierda
on dem.employee_id = sal.employee_id;

-- JOIN (Multiples tablas)
select ed.first_name, ed.last_name, ed.age, ed.gender, pd.department_name from employee_demographics ed
join employee_salary es on ed.employee_id = es.employee_id
join parks_departments pd on es.dept_id = pd.department_id; -- el JOIN se realiza entre la segunda tabla y la tabla intermedia

---------
# UNION #
---------

-- Unir los registros de 2 o más tablas. (Todas las tablas involucradas en el UNION deben retornar el mismo numero de columnas)
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

-- LENGTH() - Cantidad de caracteres de una cadena de texto
select first_name, length(first_name) from employee_demographics;

-- UPPER() - Convertir caracteres de un texto a mayusculas
select first_name, upper(first_name) from employee_demographics;

-- LOWER() - Convertir caracteres de un texto a minuscula
select first_name, lower(first_name) from employee_demographics;

-- TRIM() - Remover espacios en blanco a la izquierda y derecha de un texto
select trim('           sky       ');

-- LTRIM() - Remover espacios a la izquierda de un texto
select ltrim('           sky       ');

-- RTRIM() - Remover espacios a la derecha de un texto
select rtrim('           sky       ');

-- SUBSTR() - Obtener una porción especifica de una cadena de texto
select first_name, substr(first_name, 1, 2) from employee_demographics;

-- REPLACE() - Reemplazar caracteres en una cadena de texto
select first_name, replace(first_name, 'a', 'x') from employee_demographics;

-- LOCATE() - Obtener la posición de caracteres en una cadena de texto
select first_name, locate('rk', first_name) from employee_demographics;

-- CONCAT() - Unir 2 o más cadenas de texto
select concat(first_name, ' ', last_name) as full_name from employee_demographics;

--------------------
# Declaración CASE #
--------------------

-- Estructura condicional tipo if-else
select first_name, last_name,
	case -- se añade una nueva columna age_label cuyo valor depende de la condición evaluada
		when age <= 30 then 'young'
        when age between 31 and 50 then 'old'
		when age >= 50 then 'granny'
	end as age_label
from employee_demographics;

-- a partir del salario o del departamento, el salario tendra un incremento
select es.first_name, es.last_name, es.salary, pd.department_name,
	case
		when es.salary < 50000 then ((salary * 5) / 100) + salary
        when es.salary > 50000 then ((salary * 7) / 100) + salary
        else salary
	end as new_salary,
    case
		when pd.department_name = 'Finance' then ((salary * 10) / 100) + salary
        else 0
	end bonus_salary
from employee_salary es
left join parks_departments pd on es.dept_id = pd.department_id;

----------------
# Subconsultas #
----------------

select * from employee_demographics
where employee_id in ( -- los empleados se obtienen a partir de los ids retornados por la subconsulta a la tabla employee_salary
	select employee_id from employee_salary where dept_id = 1
);

-- la subconsulta agrupa los registros por genero, la consulta principal obtiene el promedio entre los maximos de edad
select avg(max_age) from (
	select gender, avg(age) avg_age, max(age) max_age, min(age) min_age, count(age) count_age from employee_demographics
	group by gender
) as agg_table;