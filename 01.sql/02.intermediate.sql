--------
# JOIN #
--------

# INNER JOIN
select * from employee_demographics dem
join employee_salary sal -- si employee_id no existe en uno de los registros, este no se añade a los datos retornados
on dem.employee_id = sal.employee_id;

# LEFT JOIN
select * from employee_demographics dem
left join employee_salary sal -- retorna todos los registros de la tabla de la izquierda, aunque el employee_id no exista en la de la derecha
on dem.employee_id = sal.employee_id;

# RIGHT JOIN
select * from employee_demographics dem
right join employee_salary sal -- retorna todos los registros de la tabla de la derecha, aunque el employee_id no exista en la de la izquierda
on dem.employee_id = sal.employee_id;

# JOIN (Multiples tablas)
select dem.first_name, dem.last_name, dem.age, dem.gender, pd.department_name from employee_demographics dem
join employee_salary es on dem.employee_id = es.employee_id
join parks_departments pd on es.dept_id = pd.department_id; -- el JOIN se realiza con la segunda tabla `employee_salary`

---------
# UNION #
---------

# Unir los registros de 2 o más tablas. (Todas las tablas involucradas en el UNION deben retornar el mismo numero de columnas)
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

# LENGTH() - Cantidad de caracteres de una cadena de texto
select first_name, length(first_name) from employee_demographics;

# UPPER() - Convertir caracteres de un texto a mayusculas
select first_name, upper(first_name) from employee_demographics;

# LOWER() - Convertir caracteres de un texto a minuscula
select first_name, lower(first_name) from employee_demographics;

# TRIM() - Remover espacios en blanco a la izquierda y derecha de un texto
select trim('    sky   ');

# LTRIM() - Remover espacios a la izquierda de un texto
select ltrim('    sky');

# RTRIM() - Remover espacios a la derecha de un texto
select rtrim('sky    ');

# SUBSTR() - Obtener una porción especifica de una cadena de texto
select first_name, substr(first_name, 1, 2) from employee_demographics;

# REPLACE() - Reemplazar caracteres dentro de una cadena de texto
select first_name, replace(first_name, 'a', 'x') from employee_demographics;

# LOCATE() - Obtener la posición inicial de uno o varios caracteres dentro de una cadena
select first_name, locate('rk', first_name) from employee_demographics;

# CONCAT() - Unir 2 o más cadenas de texto
select concat(first_name, ' ', last_name) as full_name from employee_demographics;

--------------------
# Declaración CASE #
--------------------

# Estructura condicional tipo if-else
select first_name, last_name,
	case
		when age <= 30 then 'young'
        when age between 31 and 50 then 'old'
		when age >= 50 then 'granny'
	end as age_label -- se añade una nueva columna `age_label` cuyo valor depende de las condiciones evaluadas
from employee_demographics;

# a partir del salario o del departamento, el salario del empleado tendra un incremento
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
where employee_id in (
	select employee_id from employee_salary where dept_id = 1 -- los empleados se obtienen a partir de los ids retornados por la subconsulta a la tabla employee_salary
);

# La consulta principal obtiene el promedio entre las edades maximas obtenidas en la subconsulta
select avg(max_age) from (
	select gender, max(age) max_age from employee_demographics
	group by gender -- agrupar los registros de la subconsulta por genero
) as agg_table;

------------------------
# Funciones de ventana #
------------------------

select dm.first_name, dm.gender,
avg(salary) over(partition by gender) as rolling_avg -- obtener el salario promedio por genero sin colapsar las filas
from employee_demographics dm
left join employee_salary sal on dm.employee_id = sal.employee_id;

select dm.first_name, dm.gender, sal.salary,
sum(sal.salary) over(partition by gender) as rolling_total -- obtener la suma del salario por genero sin colapsar las filas
from employee_demographics dm
left join employee_salary sal on dm.employee_id = sal.employee_id;

select dm.first_name, sal.salary, dm.gender,
-- obtener los registros agrupados por genero sin colapsar las filas
-- ordenar los registros por genero a partir del salario de forma descendente
row_number() over(partition by dm.gender order by sal.salary desc) as rolling_row_number -- obtener el número de la fila a partir del ordenamiento
from employee_demographics dm
left join employee_salary sal on dm.employee_id = sal.employee_id;

select dm.first_name, salary, dm.gender,
-- obtener el salario promedio agrupado por genero sin colapsar las filas
-- por cada grupo (genero) ordenar las filas por salario de forma ascendente
avg(sal.salary) over(partition by gender) as avg_salary, 
row_number() over(partition by gender order by sal.salary) as rolling_row_number -- obtener el número de la fila a partir del ordenamiento
from employee_demographics dm
left join employee_salary sal on sal.employee_id = dm.employee_id;